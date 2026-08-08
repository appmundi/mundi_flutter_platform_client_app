import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/styles/colors_app.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/styles/text_styles.dart';

/// Campo de formulário de endereço — mesmo visual (borda verde, cantos
/// arredondados, 45px) já usado nos campos de CEP/número/complemento da
/// reserva hoje, agora como widget reutilizável entre a reserva e a tela de
/// endereços salvos. Quando `readOnly`, fica com fundo e borda neutros
/// (usado em Cidade/UF, sempre derivados do CEP).
class AddressFormField extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final List<TextInputFormatter>? formatters;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final bool readOnly;
  final bool required;

  const AddressFormField({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
    this.formatters,
    this.keyboardType,
    this.onChanged,
    this.readOnly = false,
    this.required = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: context.textStyles.titleBold.copyWith(
              fontSize: 10,
              color: colors.darkGrey,
              fontWeight: FontWeight.w500,
            ),
            children: [
              TextSpan(text: label),
              if (required)
                TextSpan(
                  text: ' *',
                  style: TextStyle(color: colors.secondary),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: readOnly ? colors.cardBackground : Colors.white,
            border: Border.all(
              color: readOnly ? colors.border : colors.secondary,
              width: .5,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          height: 45,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: TextField(
              controller: controller,
              readOnly: readOnly,
              inputFormatters: formatters,
              keyboardType: keyboardType,
              onChanged: onChanged,
              onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
              style: context.textStyles.textRegular.copyWith(
                fontSize: 12,
                color: readOnly ? colors.mutedText : Colors.black,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                errorBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                hintText: hintText,
                hintStyle: context.textStyles.textRegular.copyWith(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
