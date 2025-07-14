import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/styles/colors_app.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/styles/text_styles.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final double? width;
  final bool loading;
  final double? fontSize;
  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.fontSize,
    this.width,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? .8.sw,
      height: 49,
      decoration: BoxDecoration(
        gradient: onPressed == null
            ? null
            : LinearGradient(
                stops: const [.3, 1],
                colors: [
                  const Color.fromRGBO(144, 240, 153, 1),
                  context.colors.decorationPrimary,
                ],
              ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: ElevatedButton(
        onPressed: !loading ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Visibility(
          visible: !loading,
          replacement: const CircularProgressIndicator(),
          child: Text(
            text,
            style: context.textStyles.buttonFont.copyWith(
              color: onPressed == null
                  ? const Color.fromRGBO(35, 38, 39, .4)
                  : Colors.black,
              fontSize: fontSize,
            ),
          ),
        ),
      ),
    );
  }
}
