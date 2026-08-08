import 'package:flutter/material.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/styles/colors_app.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/styles/text_styles.dart';
import 'package:mundi_flutter_platform_client_app/app/models/address.dart';
import 'package:mundi_flutter_platform_client_app/app/modules/home/modules/addresses/widgets/address_label_icon.dart';

/// Card de endereço salvo — reusado na lista da tela de endereços e no
/// resumo da tela de reserva (lá sempre com `selected: true`).
class SavedAddressCard extends StatelessWidget {
  final Address address;
  final bool selected;
  final bool showSelectionIndicator;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const SavedAddressCard({
    super.key,
    required this.address,
    this.selected = false,
    this.showSelectionIndicator = true,
    this.onTap,
    this.onLongPress,
  });

  String get _title =>
      (address.label?.isNotEmpty ?? false) ? address.label! : 'Endereço';

  String get _line1 {
    final parts = <String>[
      address.street,
      if ((address.neighborhood ?? '').trim().isNotEmpty)
        address.neighborhood!.trim(),
    ];
    final joined = parts.join(', ');
    return address.number.isNotEmpty ? '$joined, ${address.number}' : joined;
  }

  String get _line2 => '${address.city} · ${address.state} · ${address.zipCode}';

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: selected ? colors.secondary : colors.border,
            width: selected ? 1.2 : .5,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: colors.atHomeBadgeBg,
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: Icon(
                addressLabelIcon(address.label),
                size: 18,
                color: colors.secondary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _title,
                    style: context.textStyles.titleBold.copyWith(
                      fontSize: 13,
                      color: colors.primary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _line1,
                    style: context.textStyles.textRegular.copyWith(
                      fontSize: 11,
                      color: colors.darkGrey,
                    ),
                  ),
                  Text(
                    _line2,
                    style: context.textStyles.textRegular.copyWith(
                      fontSize: 11,
                      color: colors.darkGrey,
                    ),
                  ),
                ],
              ),
            ),
            if (showSelectionIndicator) ...[
              const SizedBox(width: 8),
              Icon(
                selected ? Icons.radio_button_checked : Icons.radio_button_off,
                size: 20,
                color: selected ? colors.secondary : colors.border,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
