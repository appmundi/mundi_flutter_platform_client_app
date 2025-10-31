import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mundi_flutter_platform_client_app/app/core/helpers/firebase_api.dart';
import 'package:mundi_flutter_platform_client_app/app/core/storage/local_storage.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/extension/size_screen_extension.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/widgets/gradient_text_field.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/widgets/more_info.dart';
import 'package:mundi_flutter_platform_client_app/app/models/entrepreneur.dart';
import 'package:mundi_flutter_platform_client_app/app/models/modality.dart';
import 'package:mundi_flutter_platform_client_app/app/models/reservation.dart';
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
      body: BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {
          log("Filter > ${state.filteredCategoryEntrepreneurs}");
        },
        builder: (context, state) {
          final filteredEntrepreneurs =
              state.filteredEntrepreneurs ?? state.entrepreneurs ?? [];

          return PageView(
            physics: const NeverScrollableScrollPhysics(),
            controller: _pageController,
            children: [
              Page(
                entrepreneurs: filteredEntrepreneurs,
                isLoading: state.status == HomeStateStatus.loading,
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
            print("Tem token ${token}");
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
  final List<Entrepreneur> entrepreneurs;

  const Page({super.key, required this.entrepreneurs, required this.isLoading});

  @override
  State<Page> createState() => _PageState();
}

class _PageState extends State<Page> {
  final searchController = TextEditingController();
  final categoryController = TextEditingController();
  final imagesViewCtrl = PageController();
  int selectedImg = 0;
  List<dynamic> images = [];

  @override
  void initState() {
    super.initState();
    // searchController.addListener(_onSearchChanged);
    categoryController.addListener(_onCategoryChanged);
  }

  @override
  void dispose() {
    // searchController.removeListener(_onSearchChanged);
    categoryController.removeListener(_onCategoryChanged);
    searchController.dispose();
    categoryController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String text) {
    BlocProvider.of<HomeCubit>(context).applyFilter(text);
  }

  void _onCategoryChanged() {
    BlocProvider.of<HomeCubit>(
      context,
    ).applyFilterCategory(categoryController.text);
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
                      print("Texto mudou ${string}");
                      searchController.text = string;
                    },
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      /*
                  InkWell(
                    child: const CategoryTile(
                      image: 'assets/images/scissors.png',
                      title: "Barbeiro",
                    ),
                      onTap: (){
                        BlocProvider.of<HomeCubit>(context).applyFilterCategory("Barbearia");
                      setState(() {
                        categoryController.text = "Barbearia";
                      });
                        _onCategoryChanged();
                      },
                  ),
                  InkWell(
                    child: const CategoryTile(
                      image: 'assets/images/beauty.png',
                      title: "Salão de Beleza",
                    ),
                    onTap: (){
                      setState(() {
                        categoryController.text = "Salão de Beleza";
                        _onCategoryChanged();
                      });
                    },
                  ),
                  InkWell(
                    child: const CategoryTile(
                      image: 'assets/images/health.png',
                      title: "Saúde e Bem-estar",
                    ),
                    onTap: (){
                      setState(() {
                        categoryController.text = "Saúde e Bem-estar";
                        _onCategoryChanged();
                      });
                    },
                  ),
    */
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Opacity(
                opacity: widget.isLoading ? 0.3 : 1.0,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        HorizontalEntrepreneursList(
                          title: 'Ofertas Especiais',
                          entrepeneurs: widget.entrepreneurs,
                          isLoading: widget.isLoading,
                        ),
                        HorizontalEntrepreneursList(
                          title: 'Recomendados',
                          entrepeneurs: widget.entrepreneurs,
                          isLoading: widget.isLoading,
                        ),
                        HorizontalEntrepreneursList(
                          title: 'Disponíveis hoje',
                          entrepeneurs: widget.entrepreneurs,
                          isLoading: widget.isLoading,
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
