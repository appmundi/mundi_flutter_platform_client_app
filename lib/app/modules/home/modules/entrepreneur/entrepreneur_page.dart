import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mundi_flutter_platform_client_app/app/core/helpers/environments.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/extension/size_screen_extension.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/styles/colors_app.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/styles/text_styles.dart';
import 'package:mundi_flutter_platform_client_app/app/models/entrepreneur.dart';
import 'package:mundi_flutter_platform_client_app/app/modules/home/modules/entrepreneur/cubit/entrepreneur_cubit.dart';
import 'package:mundi_flutter_platform_client_app/app/modules/home/modules/entrepreneur/cubit/entrepreneur_state.dart';
import 'package:mundi_flutter_platform_client_app/app/modules/home/modules/entrepreneur/modules/details/details_page.dart';
import 'package:mundi_flutter_platform_client_app/app/modules/home/modules/entrepreneur/modules/portfolio/portfolio_page.dart';
import 'package:mundi_flutter_platform_client_app/app/modules/home/modules/entrepreneur/modules/services/services_page.dart';

import '../../../../core/ui/helpers/messages.dart';
import 'modules/rating/rating_page.dart';
import 'package:http/http.dart' as http;

class EntrepreneurPage extends StatefulWidget {
  final int entrepreneurId;
  const EntrepreneurPage({required this.entrepreneurId, super.key});

  @override
  State<EntrepreneurPage> createState() => _EntrepreneurPageState();
}

class _EntrepreneurPageState extends State<EntrepreneurPage>
    with TickerProviderStateMixin, Messages<EntrepreneurPage> {
  double stars = 0.0;
  late final TabController _tabController;
  final _imagesViewCtrl = PageController();
  int selectedImg = 0;
  bool favorite = false;
  final tabs = ['Serviços', 'Avaliações', 'Portfólio', 'Detalhes'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  double calculateStars(List<Rating> ratings) {
    stars = 0.0;
    for (var i = 0; i < (ratings.length); i++) {
      stars = stars + ratings[i].rating;
    }
    stars = ratings.isNotEmpty ? stars / (ratings.length) : 0.0;

    return stars;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BlocConsumer<EntrepreneurCubit, EntrepreneurState>(
        listener: (context, state) {
          state.status.matchAny(
            error: () {
              showError(state.errorMessage ?? "Erro não Informado");
              Modular.to.pop();
            },
            any: () {},
          );
        },
        builder: (context, state) {
          if (state.entrepreneur != null) {
            final screenHeight = MediaQuery.of(context).size.height;
            final screenWidth = MediaQuery.of(context).size.width;

            return Column(
              children: [
                // Imagem do perfil - altura responsiva
                SizedBox(
                  height: screenHeight * 0.35,
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: Image.network(
                          '${Environments.get('BASE_URL')}/images/profile/${state.entrepreneur?.id}',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: Image.asset(
                                'assets/images/dark_logo.png',
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                        ),
                      ),
                      Positioned(
                        top: MediaQuery.of(context).padding.top,
                        left: 0,
                        child: Container(
                          width: 40,
                          height: 30,
                          padding: const EdgeInsets.all(5.0),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(5),
                              topRight: Radius.circular(5),
                            ),
                          ),
                          child: Center(
                            child: InkWell(
                              onTap: () => Modular.to.pop(),
                              child: Icon(
                                Icons.arrow_back,
                                size: 20,
                                color: context.colors.decorationPrimary,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 8,
                        left: 8,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              favorite = !favorite;
                            });
                          },
                          child: Icon(
                            favorite ? Icons.favorite : Icons.favorite_outline,
                            size: 30,
                            color: favorite ? context.colors.secondary : Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Conteúdo scrollável
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: screenWidth * 0.05,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header com nome e avaliação
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      state.entrepreneur?.name ?? '',
                                      style: context.textStyles.textMedium.copyWith(
                                        color: const Color(0xFF212121),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      state.entrepreneur?.fullAddress ?? '',
                                      maxLines: 3,
                                      style: context.textStyles.textRegular.copyWith(
                                        color: const Color(0xFFA4A4A4),
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    size: 10,
                                    color: context.colors.decorationPrimary,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    calculateStars(
                                      state.entrepreneur?.ratings ?? [],
                                    ).toString(),
                                    style: context.textStyles.textMedium.copyWith(
                                      fontSize: 16,
                                      color: context.colors.decorationPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // Tabs responsivas
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: ((state.entrepreneur?.imagesID ?? []).isEmpty
                                  ? tabs.where((tab) => tab != 'Portfólio').toList()
                                  : tabs)
                                  .map<Widget>((tab) {
                                final isSelected = tabs.indexOf(tab) == _tabController.index;
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        _tabController.animateTo(tabs.indexOf(tab));
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12.0,
                                        vertical: 8.0,
                                      ),
                                      decoration: BoxDecoration(
                                        border: isSelected
                                            ? Border.all(
                                          color: context.colors.decorationPrimary,
                                          width: 1,
                                        )
                                            : null,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        tab,
                                        style: context.textStyles.textMedium.copyWith(
                                          fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                                          color: Colors.black,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              })
                                  .toList(),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // TabBarView com altura dinâmica
                          SizedBox(
                            height: screenHeight * 0.55,
                            child: TabBarView(
                              physics: const NeverScrollableScrollPhysics(),
                              controller: _tabController,
                              children: [
                                ServicesPage(
                                  entrepreneur: state.entrepreneur!,
                                  services: state.entrepreneur!.works,
                                  entrepreneurId: state.entrepreneur?.id,
                                ),
                                RatingPage(
                                  ratings: state.entrepreneur?.ratings,
                                  stars: stars,
                                ),
                                if ((state.entrepreneur?.imagesID ?? []).isNotEmpty)
                                  PortfolioPage(
                                    services: state.entrepreneur!.works,
                                    images: state.entrepreneur?.imagesID ?? [],
                                  ),
                                DetailsPage(
                                  address: state.entrepreneur!.address,
                                  email: state.entrepreneur!.email,
                                  phone: state.entrepreneur!.phone,
                                  operation: state.entrepreneur?.operation ?? [],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Center(
              child: CircularProgressIndicator(color: context.colors.secondary),
            );
          }
        },
      ),
    );
  }
}
