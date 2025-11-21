import 'package:flutter/material.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/styles/colors_app.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/styles/text_styles.dart';

class FilterWidget extends StatelessWidget {
  final VoidCallback onTap;
  const FilterWidget({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 87,
        height: 26,
        decoration: BoxDecoration(
          border: Border.all(
            color: context.colors.secondary,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(
            15,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/filter.png',
              height: 15,
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              "filtros",
              style: context.textStyles.textMedium.copyWith(
                color: const Color(0xFF353839),
              ),
            )
          ],
        ),
      ),
    );
  }
}
