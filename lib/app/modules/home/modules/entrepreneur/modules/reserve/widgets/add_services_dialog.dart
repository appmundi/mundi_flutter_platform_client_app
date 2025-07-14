import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/styles/colors_app.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/styles/text_styles.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/widgets/app_button.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/widgets/app_button_outline.dart';
import 'package:mundi_flutter_platform_client_app/app/models/entrepreneur.dart';
import 'package:mundi_flutter_platform_client_app/app/models/modality.dart';
import 'package:mundi_flutter_platform_client_app/app/models/work.dart';
import 'package:mundi_flutter_platform_client_app/app/modules/home/modules/entrepreneur/modules/reserve/widgets/add_service_single_tile.dart';
import 'package:mundi_flutter_platform_client_app/app/modules/home/modules/entrepreneur/modules/services/widgets/service_tile.dart';
import 'package:mundi_flutter_platform_client_app/app/modules/home/modules/schedules/widgets/schedules_search_text_field.dart';

class AddServicesDialog extends StatefulWidget {
  final Entrepreneur entrepreneur;

  const AddServicesDialog({super.key, required this.entrepreneur});

  @override
  State<AddServicesDialog> createState() => _AddServicesDialogState();
}

class _AddServicesDialogState extends State<AddServicesDialog> {
  int filterSelected = 0;

  Entrepreneur get entrepreneur => widget.entrepreneur;

  late List<String> options = [
    'Todos',
    ...entrepreneur.works.map((work) => work.title).toList(),
  ];

  List<Modality> addedModalities = [];

  List<Work> get filteredWorks =>
      filterSelected == 0
          ? entrepreneur.works
          : entrepreneur.works
              .where((work) => work.title == options[filterSelected])
              .toList();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      insetPadding: EdgeInsets.zero,
      child: SizedBox(
        width: .90.sw,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Adicionar Serviços',
                    style: context.textStyles.textMedium.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Icon(
                      Icons.close,
                      color: context.colors.darkGrey,
                      size: 15,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: Colors.grey),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Column(
                children: [
                  SchedulesSearchTextField(
                    controller: TextEditingController(),
                    hintText: 'Buscar serviços...',
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 40,
                    width: double.infinity,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: options.length,
                      separatorBuilder:
                          (context, index) => const SizedBox(width: 5),
                      itemBuilder: (context, index) {
                        final option = options[index];
                        final isSelected = filterSelected == index;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              filterSelected = index;
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(microseconds: 200),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color:
                                    isSelected
                                        ? context.colors.secondary
                                        : Colors.grey,
                                width: .5,
                              ),
                              color:
                                  isSelected
                                      ? context.colors.secondary
                                      : Colors.transparent,
                            ),
                            child: Text(
                              option,
                              style: context.textStyles.textRegular.copyWith(
                                color: isSelected ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    width: double.infinity,
                    child: ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      separatorBuilder: (context, index) {
                        return const SizedBox(height: 20);
                      },
                      shrinkWrap: true,
                      itemCount: filteredWorks.length,
                      itemBuilder: (context, index) {
                        final work = filteredWorks[index];
                        return AddServiceSingleTile(
                          work: work,
                          addedModalities: addedModalities,
                          onAddModality: (modality) {
                            addedModalities.contains(modality)
                                ? addedModalities.remove(modality)
                                : addedModalities.add(modality);
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: AppButtonOutline(
                          text: 'Cancelar',
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: AppButton(
                          text: 'Confirmar',
                          onPressed: () {
                            Navigator.pop(context, addedModalities);
                          },
                          fontSize: 14,
                        ),
                      ),
                    ],
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
