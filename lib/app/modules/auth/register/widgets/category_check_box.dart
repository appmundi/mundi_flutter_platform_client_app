import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/extension/size_screen_extension.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/styles/colors_app.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/styles/text_styles.dart';

class CategoryCheckbox extends StatefulWidget {
  final String text;
  final bool value;
  final Function(bool?) onChanged;
  const CategoryCheckbox({
    super.key,
    required this.text,
    required this.value,
    required this.onChanged,
  });

  @override
  State<CategoryCheckbox> createState() => _CategoryCheckboxState();
}

class _CategoryCheckboxState extends State<CategoryCheckbox> {
  final _checkboxKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white,
          width: .1,
        ),
        borderRadius: BorderRadius.circular(40),
      ),
      child: ElevatedButton(
        onPressed: () {
          widget.onChanged(!widget.value);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
        ),
        child: BlurryContainer(
          color: const Color.fromRGBO(11, 22, 70, .2),
          blur: 30,
          width: .85.sw,
          height: 45,
          elevation: 1,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          borderRadius: BorderRadius.circular(40),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.text,
                style: context.textStyles.titleBold.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              Checkbox(
                fillColor:
                    WidgetStateProperty.all(context.colors.decorationPrimary),
                side: BorderSide(
                  width: 1,
                  color: context.colors.decorationPrimary,
                ),
                key: _checkboxKey,
                value: widget.value,
                onChanged: widget.onChanged,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
