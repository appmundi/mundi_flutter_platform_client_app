import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/extension/size_screen_extension.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/styles/colors_app.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/styles/text_styles.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/widgets/filter_widget.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/widgets/gradient_text_field.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/widgets/horizontal_entrepreneurs_list.dart';
import 'package:mundi_flutter_platform_client_app/app/modules/home/modules/search/cubit/search_cubit.dart';
import 'package:mundi_flutter_platform_client_app/app/modules/home/modules/search/cubit/search_state.dart';

import '../../../../models/entrepreneur.dart';
import 'widgets/result_tile.dart';
import 'widgets/filter_dialog.dart';

class SearchPage extends StatefulWidget {
  final List<Entrepreneur> specialOffers;

  const SearchPage({super.key, required this.specialOffers});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final searchController = TextEditingController();
  final whereController = TextEditingController();
  final whenController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    whereController.dispose();
    whenController.dispose();
    super.dispose();
  }

  void _showFilterDialog() async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => const FilterDialog(),
    );

    if (result != null && mounted) {
      _applyFilters(result);
      _showFilterFeedback(result);
    }
  }

  void _applyFilters(Map<String, dynamic> filters) {
    final List<int> specialtyIds = filters['specialtyIds'] as List<int>;
    final double maxDistance = filters['maxDistance'] as double;
    final double minRating = filters['minRating'] as double;

    context.read<SearchCubit>().applyAdvancedFilters(
      specialtyIds: specialtyIds.isNotEmpty ? specialtyIds : null,
      maxDistance: maxDistance,
      minRating: minRating,
    );
  }

  void _showFilterFeedback(Map<String, dynamic> filters) {
    final List<int> specialtyIds = filters['specialtyIds'] as List<int>;
    final double maxDistance = filters['maxDistance'] as double;
    final double minRating = filters['minRating'] as double;

    final List<String> activeFilters = [];

    if (specialtyIds.isNotEmpty) {
      activeFilters.add('${specialtyIds.length} especialidade(s)');
    }
    if (maxDistance < 50) {
      activeFilters.add('até ${maxDistance.toInt()} km');
    }
    if (minRating > 0) {
      activeFilters.add('${minRating.toStringAsFixed(1)}⭐ ou mais');
    }

    if (activeFilters.isEmpty) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Filtros aplicados: ${activeFilters.join(", ")}',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: context.colors.secondary,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 1.sw,
          color: const Color(0xFF060E31),
          padding: EdgeInsets.only(top: 1.statusBar + 10, left: 30, right: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset('assets/images/logo.png', height: 31),
                  Row(
                    children: [
                      Text(
                        "Meus Favoritos",
                        style: context.textStyles.textRegular.copyWith(
                          fontSize: 13,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 20),
                      const Icon(
                        Icons.favorite_outline,
                        color: Color.fromRGBO(242, 242, 242, 1),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 25),
              GradientTextField(
                hintText: 'Pesquisa aqui a especialidade...',
                prefixIcon: Icons.search,
                controller: searchController,
                onSubmitted: context.read<SearchCubit>().applyFilter,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 25.0,
                vertical: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BlocBuilder<SearchCubit, SearchState>(
                    builder: (context, state) {
                      return HorizontalEntrepreneursList(
                        title: 'Ofertas Especiais',
                        entrepeneurs: widget.specialOffers,
                        isLoading: false,
                      );
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Resultados",
                        style: context.textStyles.titleBold.copyWith(
                          fontSize: 20,
                          color: context.colors.primary,
                        ),
                      ),
                      BlocBuilder<SearchCubit, SearchState>(
                        builder: (context, state) {
                          final cubit = context.read<SearchCubit>();

                          if (!cubit.hasActiveFilters) {
                            return const SizedBox.shrink();
                          }

                          return GestureDetector(
                            onTap: () {
                              cubit.clearFilters();

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text(
                                    'Filtros removidos',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor: context.colors.secondary,
                                  behavior: SnackBarBehavior.floating,
                                  duration: const Duration(seconds: 2),
                                  margin: const EdgeInsets.all(20),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: context.colors.decorationPrimary.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: context.colors.decorationPrimary,
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Limpar filtros',
                                    style: context.textStyles.textRegular.copyWith(
                                      fontSize: 11,
                                      color: context.colors.decorationPrimary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Icon(
                                    Icons.close,
                                    size: 14,
                                    color: context.colors.decorationPrimary,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  FilterWidget(
                    onTap: _showFilterDialog,
                  ),
                  BlocBuilder<SearchCubit, SearchState>(
                    builder: (context, state) {
                      final isLoading = state.status == SearchStateStatus.loading;
                      final entrepreneurs = state.entrepreneurs ?? [];

                      if (!isLoading && entrepreneurs.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.all(40.0),
                          child: Center(
                            child: Column(
                              children: [
                                Icon(
                                  Icons.search_off,
                                  size: 64,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Nenhum resultado encontrado',
                                  style: context.textStyles.textRegular.copyWith(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: ListView.separated(
                          separatorBuilder: (context, index) {
                            return const SizedBox(height: 30);
                          },
                          shrinkWrap: true,
                          itemCount: isLoading ? 10 : entrepreneurs.length,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            if (isLoading) {
                              return const ResultTile.loading();
                            }

                            return ResultTile(
                              entrepreneur: entrepreneurs[index],
                            );
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}