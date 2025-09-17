import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mundi_flutter_platform_client_app/app/core/storage/local_storage.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/styles/colors_app.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/styles/text_styles.dart';
import 'package:mundi_flutter_platform_client_app/app/models/entrepreneur.dart';
import 'package:mundi_flutter_platform_client_app/app/models/modality.dart';
import 'package:mundi_flutter_platform_client_app/app/modules/home/modules/entrepreneur/modules/reserve/reserve_page.dart';

class ModalityCheckbox extends StatefulWidget {
  final Modality modality;
  final bool value;
  final ValueChanged<bool?>? onChanged;

  const ModalityCheckbox({
    super.key,
    required this.modality,
    required this.value,
    required this.onChanged,
  });

  @override
  State<ModalityCheckbox> createState() => _ModalityCheckboxState();
}

class _ModalityCheckboxState extends State<ModalityCheckbox> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            widget.modality.title,
            style: context.textStyles.textMedium.copyWith(fontSize: 12),
          ),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    widget.modality.getPrice(),
                    style: context.textStyles.textMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    "${widget.modality.getDuration()} MIN",
                    style: context.textStyles.textRegular.copyWith(fontSize: 8),
                  ),
                ],
              ),
              const SizedBox(width: 8),
              Checkbox(
                value: widget.value,
                onChanged: widget.onChanged,
                activeColor: context.colors.secondary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
