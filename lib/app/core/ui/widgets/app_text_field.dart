import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/styles/colors_app.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/styles/text_styles.dart';

class AppTextField extends StatefulWidget {
  final String label;
  final String hintText;
  final TextEditingController? controller;
  final List<TextInputFormatter>? formatters;
  final String? Function(String?)? validator;
  final bool obscureText;

  const AppTextField({
    super.key,
    required this.label,
    required this.hintText,
    this.controller,
    this.formatters,
    this.validator,
    this.obscureText = false,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: context.textStyles.titleBold.copyWith(
            fontSize: 14.33,
            color: context.colors.mutedText,
            fontWeight: FontWeight.w300,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        BlurryContainer(
          blur: 20,
          padding: EdgeInsets.zero,
          height: 41,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            height: 41,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                stops: const [
                  0.1,
                  .9,
                ],
                colors: [
                  Colors.transparent,
                  Colors.white.withValues(alpha: .2),
                ],
              ),
              border: Border.all(
                color: Colors.white,
                width: .5,
              ),
            ),
            child: TextFormField(
              validator: widget.validator,
              scrollPadding: EdgeInsets.zero,
              textAlignVertical: TextAlignVertical.center,
              controller: widget.controller,
              obscureText: widget.obscureText,
              style: context.textStyles.textRegular.copyWith(
                color: Colors.white,
              ),
              inputFormatters: widget.formatters,
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: context.textStyles.textRegular.copyWith(
                  color: Colors.white.withValues(alpha: .32),
                ),
                focusedBorder: InputBorder.none,
              )
            ),
          ),
        ),
      ],
    );
  }
}
