import 'package:flutter/material.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/styles/colors_app.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/styles/text_styles.dart';
import 'package:mundi_flutter_platform_client_app/app/modules/home/modules/addresses/widgets/address_form_field.dart';
import 'package:mundi_flutter_platform_client_app/app/modules/home/modules/addresses/widgets/address_label_icon.dart';

const _presetLabels = ['Casa', 'Trabalho'];

/// Chips de apelido rápido (Casa / Trabalho / Outro) para o endereço que
/// está sendo salvo. "Outro" revela um campo de texto livre abaixo. Sempre
/// opcional — sem chip nenhum selecionado, o endereço é salvo sem apelido.
class AddressLabelChips extends StatelessWidget {
  final String? selectedLabel;
  final TextEditingController customLabelController;
  final ValueChanged<String> onSelect;

  const AddressLabelChips({
    super.key,
    required this.selectedLabel,
    required this.customLabelController,
    required this.onSelect,
  });

  bool get _isCustom =>
      selectedLabel != null && !_presetLabels.contains(selectedLabel);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Nome do endereço',
          style: context.textStyles.titleBold.copyWith(
            fontSize: 10,
            color: context.colors.darkGrey,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            for (final preset in _presetLabels) ...[
              _LabelChip(
                label: preset,
                selected: selectedLabel == preset,
                onTap: () => onSelect(preset),
              ),
              const SizedBox(width: 8),
            ],
            _LabelChip(
              label: 'Outro',
              selected: _isCustom,
              onTap: () => onSelect(''),
            ),
          ],
        ),
        if (_isCustom) ...[
          const SizedBox(height: 12),
          AddressFormField(
            label: 'Qual o nome?',
            hintText: 'Ex.: Casa da minha mãe',
            controller: customLabelController,
          ),
        ],
      ],
    );
  }
}

class _LabelChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _LabelChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? colors.secondary.withValues(alpha: .12) : Colors.white,
          border: Border.all(
            color: selected ? colors.secondary : colors.border,
            width: selected ? 1 : .5,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              addressLabelIcon(label == 'Outro' ? null : label),
              size: 14,
              color: selected ? colors.secondary : colors.mutedText,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: context.textStyles.textMedium.copyWith(
                fontSize: 11,
                color: selected ? colors.secondary : colors.darkGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
