import 'package:flutter/material.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/styles/colors_app.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/styles/text_styles.dart';

class SettingButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  final bool isFilled;

  const SettingButton({
    super.key,
    required this.label,
    required this.onPressed,
  }) : isFilled = false;

  const SettingButton.filled({
    super.key,
    required this.label,
    required this.onPressed,
  }) : isFilled = true;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor:
            isFilled ? context.colors.secondary : Colors.transparent,
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 5,
        ),
        side: BorderSide(
          color: !isFilled
              ? Colors.black.withValues(alpha: .4)
              : context.colors.secondary,
          width: .5,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: context.textStyles.titleBold.copyWith(
              fontSize: 12,
              color: !isFilled ? Colors.black : Colors.white,
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            size: 18,
            color: !isFilled ? context.colors.secondary : Colors.white,
          )
        ],
      ),
    );
  }
}
