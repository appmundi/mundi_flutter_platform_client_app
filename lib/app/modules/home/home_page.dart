import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart'
    hide ModularWatchExtension;
import 'package:mundi_flutter_platform_client_app/app/core/helpers/firebase_api.dart';
import 'package:mundi_flutter_platform_client_app/app/core/storage/local_storage.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/extension/size_screen_extension.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/widgets/gradient_text_field.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/widgets/location_filter_banner.dart';
import 'package:mundi_flutter_platform_client_app/app/models/entrepreneur.dart';
import 'package:mundi_flutter_platform_client_app/app/repository/entrepeneur/entrepreneur_search_result.dart';
import 'package:mundi_flutter_platform_client_app/app/modules/home/cubit/home_cubit.dart';
import 'package:mundi_flutter_platform_client_app/app/modules/home/cubit/home_state.dart';
import 'package:mundi_flutter_platform_client_app/app/modules/home/modules/profile/profile_page.dart';
import 'package:mundi_flutter_platform_client_app/app/modules/home/modules/schedules/schedules_page.dart';
import 'package:mundi_flutter_platform_client_app/app/modules/home/widgets/bottom_nav_bar.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/widgets/horizontal_entrepreneurs_list.dart';
import 'package:mundi_flutter_platform_client_app/app/modules/home/modules/search/cubit/search_cubit.dart';
import 'modules/search/search_page.dart';

class HomePage extends StatefulWidget {
  final currentPage;

  const HomePage({super.key, required this.currentPage});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseApi firebaseApi = FirebaseApi();
  final _pageController = PageController();
  final _searchController = TextEditingController();
  int _currentPage = 0;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onHomeSearchSubmitted(String query) {
    context.read<SearchCubit>().applyFilter(query);
    setState(() {
      _pageController.jumpToPage(1);
      _currentPage = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          return PageView(
            physics: const NeverScrollableScrollPhysics(),
            controller: _pageController,
            children: [
              Page(
                isLoading:
                    state.status == HomeStateStatus.loading ||
                    state.status == HomeStateStatus.initial,
                specialOffers: state.specialOffers ?? [],
                recommended: state.recommended ?? [],
                availableToday: state.availableToday ?? [],
                controller: _searchController,
                onSearchSubmitted: _onHomeSearchSubmitted,
                appliedFilter: state.appliedFilter,
                showLocationBanner: state.status == HomeStateStatus.loaded,
                onRefresh: () => context.read<HomeCubit>().loadData(),
              ),
              SearchPage(
                specialOffers: state.specialOffers ?? [],
                specialOffersLoading:
                    state.status == HomeStateStatus.loading ||
                    state.status == HomeStateStatus.initial,
                controller: _searchController,
              ),
              const SchedulesPage(),
              const ProfilePage(),
            ],
          );
        },
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentPage,
        onChangePage: (index) async {
          final isAuthenticatedPage = [2, 3].contains(index);
          if (isAuthenticatedPage) {
            final LocalStorage localStorage = Modular.get<LocalStorage>();
            final String? token = await localStorage.read('accessToken');
            if (token != null && token != "") {
              setState(() {
                _pageController.jumpToPage(index);
                _currentPage = index;
              });
            } else {
              setState(() {
                _pageController.jumpToPage(0);
                _currentPage = 0;
              });
              Modular.to.pushNamed('/auth/options');
            }
          } else {
            setState(() {
              _pageController.jumpToPage(index);
              _currentPage = index;
            });
          }
        },
      ),
    );
  }
}

class Page extends StatefulWidget {
  final bool isLoading;
  final List<Entrepreneur> specialOffers;
  final List<Entrepreneur> recommended;
  final List<Entrepreneur> availableToday;
  final TextEditingController controller;
  final void Function(String) onSearchSubmitted;
  final AppliedGeoFilter appliedFilter;
  final bool showLocationBanner;
  final Future<void> Function() onRefresh;

  const Page({
    super.key,
    required this.isLoading,
    required this.specialOffers,
    required this.recommended,
    required this.availableToday,
    required this.controller,
    required this.onSearchSubmitted,
    required this.onRefresh,
    this.appliedFilter = AppliedGeoFilter.none,
    this.showLocationBanner = false,
  });

  @override
  State<Page> createState() => _PageState();
}

class _PageState extends State<Page> {
  final imagesViewCtrl = PageController();
  int selectedImg = 0;

  void _onSearchChanged(String text) {
    widget.onSearchSubmitted(text);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 1.sw,
              color: const Color(0xFF060E31),
              padding: EdgeInsets.only(top: 1.statusBar + 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset('assets/images/logo.png', height: 31),
                  const SizedBox(height: 25),
                  GradientTextField(
                    hintText: 'Pesquisa aqui a especialidade...',
                    prefixIcon: Icons.search,
                    controller: widget.controller,
                    onSubmitted: _onSearchChanged,
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: widget.onRefresh,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (widget.showLocationBanner)
                          LocationFilterBanner(
                            appliedFilter: widget.appliedFilter,
                          ),
                        if (widget.isLoading) ...[
                          for (final title in const [
                            'Ofertas Especiais',
                            'Recomendados',
                            'Disponíveis hoje',
                          ])
                            HorizontalEntrepreneursList(
                              title: title,
                              entrepeneurs: const [],
                              isLoading: true,
                            ),
                        ] else ...[
                          if (widget.specialOffers.isNotEmpty)
                            HorizontalEntrepreneursList(
                              title: 'Ofertas Especiais',
                              entrepeneurs: widget.specialOffers,
                            ),
                          if (widget.recommended.isNotEmpty)
                            HorizontalEntrepreneursList(
                              title: 'Recomendados',
                              entrepeneurs: widget.recommended,
                            ),
                          if (widget.availableToday.isNotEmpty)
                            HorizontalEntrepreneursList(
                              title: 'Disponíveis hoje',
                              entrepeneurs: widget.availableToday,
                            ),
                          if (widget.specialOffers.isEmpty &&
                              widget.recommended.isEmpty &&
                              widget.availableToday.isEmpty)
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.only(top: 60),
                                child: Text(
                                  'Nenhum profissional encontrado.',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                            ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
