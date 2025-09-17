import 'package:flutter/material.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/styles/colors_app.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/styles/text_styles.dart';

class AppButtonOutline extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double? fontSize;
  const AppButtonOutline(
      {super.key, required this.text, required this.onPressed, this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * .8,
        height: 49,
        decoration: BoxDecoration(
          border: Border.all(
              color: context.colors.decorationPrimary,
              width: 1,
              style: BorderStyle.solid),
          borderRadius: BorderRadius.circular(15),
        ),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          child: Text(
            text,
            style: context.textStyles.buttonFont.copyWith(
              color: context.colors.decorationPrimary,
              fontSize: fontSize,
            ),
          ),
        ),
      ),
    );
  }
}
