import 'package:flutter/material.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/styles/colors_app.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/styles/text_styles.dart';

class FilterDialog extends StatefulWidget {
  const FilterDialog({super.key});

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  // Especialidades baseadas nos IDs do sistema
  final List<Map<String, dynamic>> specialties = [
    {'id': 1, 'name': 'Barbearia'},
    {'id': 2, 'name': 'Salão de Beleza'},
    {'id': 3, 'name': 'Manicure'},
    {'id': 4, 'name': 'Makeup'},
    {'id': 5, 'name': 'Saúde e Bem-estar'},
    {'id': 6, 'name': 'Estética'},
  ];

  List<int> selectedSpecialties = [];
  double maxDistance = 50.0; // km
  double minRating = 0.0; // 0 a 5

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 600),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey.shade200,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Filtros',
                    style: context.textStyles.titleBold.copyWith(
                      fontSize: 24,
                      color: context.colors.primary,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(
                      Icons.close_rounded,
                      color: context.colors.primary,
                      size: 28,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    splashRadius: 20,
                  ),
                ],
              ),
            ),

            // Content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Especialidades
                    Text(
                      'Especialidades',
                      style: context.textStyles.textRegular.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: context.colors.primary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: specialties.map((specialty) {
                        final isSelected = selectedSpecialties.contains(specialty['id']);
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                selectedSpecialties.remove(specialty['id']);
                              } else {
                                selectedSpecialties.add(specialty['id']);
                              }
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? context.colors.decorationPrimary
                                  : Colors.grey.shade50,
                              border: Border.all(
                                color: isSelected
                                    ? context.colors.decorationPrimary
                                    : Colors.grey.shade300,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              specialty['name'],
                              style: context.textStyles.textRegular.copyWith(
                                fontSize: 14,
                                color: isSelected
                                    ? Colors.white
                                    : context.colors.primary,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 32),

                    // Proximidade
                    Text(
                      'Proximidade',
                      style: context.textStyles.textRegular.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: context.colors.primary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.grey.shade200,
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Distância máxima',
                                style: context.textStyles.textRegular.copyWith(
                                  fontSize: 14,
                                  color: Colors.grey.shade700,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: context.colors.decorationPrimary,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  '${maxDistance.toInt()} km',
                                  style: context.textStyles.textRegular.copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          SliderTheme(
                            data: SliderThemeData(
                              activeTrackColor: context.colors.decorationPrimary,
                              inactiveTrackColor: Colors.grey.shade300,
                              thumbColor: context.colors.decorationPrimary,
                              overlayColor: context.colors.decorationPrimary.withOpacity(0.2),
                              thumbShape: const RoundSliderThumbShape(
                                enabledThumbRadius: 12,
                              ),
                              trackHeight: 6,
                            ),
                            child: Slider(
                              value: maxDistance,
                              min: 1,
                              max: 50,
                              divisions: 49,
                              onChanged: (value) {
                                setState(() {
                                  maxDistance = value;
                                });
                              },
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '1 km',
                                style: context.textStyles.textRegular.copyWith(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              Text(
                                '50 km',
                                style: context.textStyles.textRegular.copyWith(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Avaliação
                    Text(
                      'Avaliação Mínima',
                      style: context.textStyles.textRegular.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: context.colors.primary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.grey.shade200,
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Nota mínima',
                                style: context.textStyles.textRegular.copyWith(
                                  fontSize: 14,
                                  color: Colors.grey.shade700,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: context.colors.decorationPrimary,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      minRating.toStringAsFixed(1),
                                      style: context.textStyles.textRegular.copyWith(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    const Icon(
                                      Icons.star_rounded,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          SliderTheme(
                            data: SliderThemeData(
                              activeTrackColor: context.colors.decorationPrimary,
                              inactiveTrackColor: Colors.grey.shade300,
                              thumbColor: context.colors.decorationPrimary,
                              overlayColor: context.colors.decorationPrimary.withOpacity(0.2),
                              thumbShape: const RoundSliderThumbShape(
                                enabledThumbRadius: 12,
                              ),
                              trackHeight: 6,
                            ),
                            child: Slider(
                              value: minRating,
                              min: 0,
                              max: 5,
                              divisions: 10,
                              onChanged: (value) {
                                setState(() {
                                  minRating = value;
                                });
                              },
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(6, (index) {
                              return Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '$index',
                                    style: context.textStyles.textRegular.copyWith(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  const SizedBox(width: 2),
                                  Icon(
                                    Icons.star_rounded,
                                    size: 12,
                                    color: Colors.grey.shade400,
                                  ),
                                ],
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Footer com botões
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
                border: Border(
                  top: BorderSide(
                    color: Colors.grey.shade200,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          selectedSpecialties.clear();
                          maxDistance = 50.0;
                          minRating = 0.0;
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: Colors.grey.shade300,
                          width: 2,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        'Limpar',
                        style: context.textStyles.textRegular.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: context.colors.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop({
                          'specialtyIds': selectedSpecialties,
                          'maxDistance': maxDistance,
                          'minRating': minRating,
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.colors.decorationPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 0,
                      ),
                      child: Text(
                        'Aplicar Filtros',
                        style: context.textStyles.textRegular.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}