import 'package:flutter/material.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/extension/size_screen_extension.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/styles/text_styles.dart';

class GradientTextField extends StatefulWidget {
  final String hintText;
  final double? width;
  final double? height;
  final double? radius;
  final IconData prefixIcon;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? contentPadding;
  final TextEditingController controller;
  final Function(String)? function;
  final Function(String)? onSubmitted;
  const GradientTextField({
    super.key,
    required this.hintText,
    required this.prefixIcon,
    this.width,
    this.height,
    this.radius,
    this.padding,
    this.contentPadding,
    required this.controller,
    this.onSubmitted,
    this.function
  });


  @override
  State<GradientTextField> createState() => _GradientTextFieldState();
}

class _GradientTextFieldState extends State<GradientTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? .85.sw,
      height: widget.height ?? 56,
      padding: widget.padding ?? const EdgeInsets.all(5),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1A2641),
            Color(0xFF060E31),
          ],
          //stops: [],
        ),
        border: Border.all(
          color: Colors.white,
          width: .5,
        ),
        borderRadius: BorderRadius.circular(widget.radius ?? 21),
      ),
      child: TextField(
        controller: widget.controller,
        maxLines: 1,
        textInputAction: TextInputAction.search,
        onSubmitted: widget.onSubmitted,
        onChanged: (string){
          widget.function!(string);
        },
        scrollPadding: EdgeInsets.zero,
        textAlignVertical: TextAlignVertical.center,
        style: context.textStyles.textRegular.copyWith(
          color: Colors.white,
        ),
        decoration: InputDecoration(
          prefixIcon: Icon(
            widget.prefixIcon,
            color: Colors.white,
          ),
          contentPadding: widget.contentPadding,
          hintText: widget.hintText,
          hintStyle: context.textStyles.textRegular.copyWith(
            color: Colors.white.withOpacity(.32),
          ),
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
      ),
    );
  }
}
