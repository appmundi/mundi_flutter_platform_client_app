import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mundi_flutter_platform_client_app/app/core/helpers/firebase_api.dart';
import 'package:mundi_flutter_platform_client_app/app/core/storage/local_storage.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/extension/size_screen_extension.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/widgets/gradient_text_field.dart';
import 'package:mundi_flutter_platform_client_app/app/models/entrepreneur.dart';
import 'package:mundi_flutter_platform_client_app/app/modules/home/cubit/home_cubit.dart';
import 'package:mundi_flutter_platform_client_app/app/modules/home/cubit/home_state.dart';
import 'package:mundi_flutter_platform_client_app/app/modules/home/modules/profile/profile_page.dart';
import 'package:mundi_flutter_platform_client_app/app/modules/home/modules/schedules/schedules_page.dart';
import 'package:mundi_flutter_platform_client_app/app/modules/home/widgets/bottom_nav_bar.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/widgets/horizontal_entrepreneurs_list.dart';
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
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          final filteredEntrepreneurs =
              state.filteredEntrepreneurs ?? state.entrepreneurs ?? [];

          return PageView(
            physics: const NeverScrollableScrollPhysics(),
            controller: _pageController,
            children: [
              Page(
                isLoading: state.status == HomeStateStatus.loading,
                specialOffers: state.specialOffers ?? [],
                recommended: state.recommended ?? [],
                availableToday: state.availableToday ?? [],
              ),
              SearchPage(specialOffers: filteredEntrepreneurs),
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
              Modular.to.pushNamed('/auth/options/');
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

  const Page({
    super.key,
    required this.isLoading,
    required this.specialOffers,
    required this.recommended,
    required this.availableToday,
  });

  @override
  State<Page> createState() => _PageState();
}

class _PageState extends State<Page> {
  final searchController = TextEditingController();
  final imagesViewCtrl = PageController();
  int selectedImg = 0;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String text) {
    BlocProvider.of<HomeCubit>(context).applyFilter(text);
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
                    controller: searchController,
                    onSubmitted: _onSearchChanged,
                    function: (string) {
                      searchController.text = string;
                    },
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
            Expanded(
              child: Opacity(
                opacity: widget.isLoading ? 0.3 : 1.0,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (widget.specialOffers.isNotEmpty)
                          HorizontalEntrepreneursList(
                            title: 'Ofertas Especiais',
                            entrepeneurs: widget.specialOffers,
                            isLoading: widget.isLoading,
                          ),
                        if (widget.recommended.isNotEmpty)
                          HorizontalEntrepreneursList(
                            title: 'Recomendados',
                            entrepeneurs: widget.recommended,
                            isLoading: widget.isLoading,
                          ),
                        if (widget.availableToday.isNotEmpty)
                          HorizontalEntrepreneursList(
                            title: 'Disponíveis hoje',
                            entrepeneurs: widget.availableToday,
                            isLoading: widget.isLoading,
                          ),
                        if (widget.specialOffers.isEmpty &&
                            widget.recommended.isEmpty &&
                            widget.availableToday.isEmpty &&
                            !widget.isLoading)
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
