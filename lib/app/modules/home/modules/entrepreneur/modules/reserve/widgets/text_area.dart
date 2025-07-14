import 'package:flutter/material.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/extension/size_screen_extension.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/styles/colors_app.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/styles/text_styles.dart';

class TextArea extends StatefulWidget {
  final TextEditingController? controller;

  const TextArea({super.key, this.controller});

  @override
  State<TextArea> createState() => _TextAreaState();
}

class _TextAreaState extends State<TextArea> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: context.colors.secondary, width: .5),
        borderRadius: BorderRadius.circular(20),
      ),
      height: 80,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: TextField(
              controller: widget.controller,
              maxLines: 8,
              style: context.textStyles.textRegular.copyWith(
                fontSize: 10,
                color: Colors.black,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                errorBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                hintText:
                    'Deseja fazer uma observação para a empresa? (opcional)',
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              width: 13,
              height: 13,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFD4D4D4), width: 1),
                borderRadius: BorderRadius.circular(6.5),
              ),
              alignment: Alignment.center,
              child: Text(
                '?',
                style: context.textStyles.textMedium.copyWith(
                  color: context.colors.secondary,
                  fontSize: 8,
                  height: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
