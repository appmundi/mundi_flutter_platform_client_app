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

class _AddServicesDialogState extends State<AddServicesDialog>
    with SingleTickerProviderStateMixin {
  int filterSelected = 0;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

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
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.h),
              child: Container(
                width: double.infinity,
                constraints: BoxConstraints(
                  maxHeight: 0.85.sh,
                  maxWidth: 500.w,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header aprimorado
                    Container(
                      padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 16.h),
                      decoration: BoxDecoration(
                        color: context.colors.secondary.withOpacity(0.05),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.r),
                          topRight: Radius.circular(20.r),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8.w),
                            decoration: BoxDecoration(
                              color: context.colors.secondary,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Icon(
                              Icons.add_task,
                              color: Colors.white,
                              size: 20.sp,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Adicionar Serviços',
                                  style: context.textStyles.textMedium.copyWith(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w700,
                                    color: context.colors.darkGrey,
                                  ),
                                ),
                                Text(
                                  'Selecione os serviços desejados',
                                  style: context.textStyles.textRegular.copyWith(
                                    fontSize: 12.sp,
                                    color: context.colors.darkGrey.withOpacity(0.7),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12.r),
                              onTap: () => Navigator.of(context).pop(),
                              child: Container(
                                padding: EdgeInsets.all(8.w),
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Icon(
                                  Icons.close_rounded,
                                  color: context.colors.darkGrey,
                                  size: 18.sp,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Conteúdo principal
                    Flexible(
                      child: Padding(
                        padding: EdgeInsets.all(24.w),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Campo de busca melhorado
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(16.r),
                                border: Border.all(
                                  color: Colors.grey.withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                              child: SchedulesSearchTextField(
                                controller: TextEditingController(),
                                hintText: 'Buscar serviços...',
                                onChanged: (value) {},
                              ),
                            ),

                            SizedBox(height: 20.h),

                            // Filtros aprimorados
                            Container(
                              height: 32.h,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: options.length,
                                separatorBuilder: (context, index) => SizedBox(width: 8.w),
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
                                      duration: const Duration(milliseconds: 200),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 12.w,
                                        vertical: 5.h,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12.r),
                                        gradient: isSelected
                                            ? LinearGradient(
                                          colors: [
                                            context.colors.secondary,
                                            context.colors.secondary.withOpacity(0.8),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        )
                                            : null,
                                        color: isSelected
                                            ? null
                                            : Colors.grey.withOpacity(0.1),
                                        border: Border.all(
                                          color: isSelected
                                              ? context.colors.secondary
                                              : Colors.grey.withOpacity(0.3),
                                          width: 1,
                                        ),
                                        boxShadow: isSelected
                                            ? [
                                          BoxShadow(
                                            color: context.colors.secondary.withOpacity(0.3),
                                            blurRadius: 8,
                                            offset: const Offset(0, 2),
                                          ),
                                        ]
                                            : null,
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          if (isSelected) ...[
                                            Icon(
                                              Icons.check_circle_rounded,
                                              color: Colors.white,
                                              size: 12.sp,
                                            ),
                                            SizedBox(width: 6.w),
                                          ],
                                          Text(
                                            option,
                                            style: context.textStyles.textRegular.copyWith(
                                              color: isSelected ? Colors.white : Colors.black87,
                                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                              fontSize: 12.sp,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),

                            SizedBox(height: 24.h),

                            // Lista de serviços aprimorada
                            Flexible(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.02),
                                  borderRadius: BorderRadius.circular(16.r),
                                  border: Border.all(
                                    color: Colors.grey.withOpacity(0.1),
                                    width: 1,
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16.r),
                                  child: ListView.separated(
                                    physics: const AlwaysScrollableScrollPhysics(),
                                    padding: EdgeInsets.all(16.w),
                                    separatorBuilder: (context, index) {
                                      return SizedBox(height: 16.h);
                                    },
                                    shrinkWrap: true,
                                    itemCount: filteredWorks.length,
                                    itemBuilder: (context, index) {
                                      final work = filteredWorks[index];
                                      return Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(12.r),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.03),
                                              blurRadius: 8,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: AddServiceSingleTile(
                                          work: work,
                                          addedModalities: addedModalities,
                                          onAddModality: (modality) {
                                            setState(() {
                                              addedModalities.contains(modality)
                                                  ? addedModalities.remove(modality)
                                                  : addedModalities.add(modality);
                                            });
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Footer com botões aprimorados
                    Container(
                      padding: EdgeInsets.all(24.w),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.03),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20.r),
                          bottomRight: Radius.circular(20.r),
                        ),
                      ),
                      child: Column(
                        children: [
                          if (addedModalities.isNotEmpty) ...[
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 12.h,
                              ),
                              decoration: BoxDecoration(
                                color: context.colors.secondary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(
                                  color: context.colors.secondary.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.check_circle_outline_rounded,
                                    color: context.colors.secondary,
                                    size: 20.sp,
                                  ),
                                  SizedBox(width: 8.w),
                                  Text(
                                    '${addedModalities.length} serviço${addedModalities.length > 1 ? 's' : ''} selecionado${addedModalities.length > 1 ? 's' : ''}',
                                    style: context.textStyles.textRegular.copyWith(
                                      color: context.colors.secondary,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 16.h),
                          ],
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 48.h,
                                  child: AppButtonOutline(
                                    text: 'Cancelar',
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Container(
                                  height: 48.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12.r),
                                    gradient: LinearGradient(
                                      colors: [
                                        context.colors.secondary,
                                        context.colors.secondary.withOpacity(0.8),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: context.colors.secondary.withOpacity(0.3),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: AppButton(
                                    text: 'Confirmar',
                                    onPressed: () {
                                      Navigator.pop(context, addedModalities);
                                    },
                                    fontSize: 16,
                                  ),
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
            ),
          ),
        );
      },
    );
  }
}