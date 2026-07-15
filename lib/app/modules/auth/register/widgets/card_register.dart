import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/styles/text_styles.dart';

class CardRegister extends StatefulWidget {
  final String label;
  final VoidCallback onSubmit;
  final TextEditingController controller;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final bool obscureText;
  final String? hintText;
  const CardRegister({
    Key? key,
    required this.label,
    required this.onSubmit,
    required this.controller,
    this.hintText,
    this.inputFormatters,
    this.validator,
    this.obscureText = false,
  }) : super(key: key);

  @override
  State<CardRegister> createState() => _CardRegisterState();
}

class _CardRegisterState extends State<CardRegister> {
  bool obscure = false;

  @override
  void initState() {
    super.initState();
    obscure = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: BlurryContainer(
        color: const Color.fromRGBO(11, 22, 70, .2),
        blur: 8,
        elevation: 6,
        width: 362,
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.label,
              style: context.textStyles.titleBold.copyWith(
                color: Colors.white,
                fontSize: 25,
              ),
            ),
            TextFormField(
              controller: widget.controller,
              validator: widget.validator,
              scrollPadding: EdgeInsets.only(
                bottom: MediaQuery.viewInsetsOf(context).bottom + 80,
              ),
              inputFormatters: widget.inputFormatters,
              style: context.textStyles.textMedium.copyWith(
                fontSize: 12,
                color: Colors.white,
              ),
              obscureText: obscure,
              decoration: InputDecoration(
                hintText: widget.hintText,
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromRGBO(144, 240, 153, 1),
                  ),
                ),
                hintStyle: context.textStyles.textMedium.copyWith(
                  fontSize: 12,
                  color: const Color.fromRGBO(243, 244, 246, .6),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromRGBO(144, 240, 153, 1),
                  ),
                ),
                suffixIconConstraints: const BoxConstraints(maxHeight: 25),
                suffixIcon: Visibility(
                  visible: widget.obscureText,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        obscure = !obscure;
                      });
                    },
                    child: Container(
                      height: 19,
                      padding: const EdgeInsets.only(right: 7),
                      child: Image.asset(
                        obscure
                            ? "assets/images/closed_eye.png"
                            : "assets/images/eye.png",
                        height: 19,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: widget.onSubmit,
                  icon: const Icon(Icons.arrow_forward_ios),
                  color: const Color.fromRGBO(144, 240, 153, 1),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
