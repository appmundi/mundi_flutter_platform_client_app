import 'package:flutter/material.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/styles/colors_app.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/styles/text_styles.dart';
import 'package:mundi_flutter_platform_client_app/app/models/entrepreneur.dart';
import 'package:mundi_flutter_platform_client_app/app/models/modality.dart';
import 'package:mundi_flutter_platform_client_app/app/models/work.dart';
import 'package:mundi_flutter_platform_client_app/app/modules/home/modules/entrepreneur/modules/reserve/widgets/modality_checkbox.dart';
import 'package:mundi_flutter_platform_client_app/app/modules/home/modules/entrepreneur/modules/services/widgets/modality_tile.dart';

class AddServiceSingleTile extends StatefulWidget {
  final Work work;
  final Function(Modality modality) onAddModality;
  final List<Modality> addedModalities;

  const AddServiceSingleTile({
    super.key,
    required this.work,
    required this.onAddModality,
    required this.addedModalities,
  });

  @override
  State<AddServiceSingleTile> createState() => _AddServiceSingleTileState();
}

class _AddServiceSingleTileState extends State<AddServiceSingleTile> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      separatorBuilder: (context, index) {
        return const SizedBox(height: 20);
      },
      itemCount: widget.work.modalities.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final modality = widget.work.modalities[index];
        final isModalityAdded = widget.addedModalities.contains(modality);
        return ModalityCheckbox(
          modality: modality,
          value: isModalityAdded,
          onChanged: (value) {
            setState(() {
              widget.onAddModality(modality);
            });
          },
        );
      },
    );
  }
}
