import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mundi_flutter_platform_client_app/app/core/storage/local_storage.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/styles/colors_app.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/styles/text_styles.dart';
import 'package:mundi_flutter_platform_client_app/app/models/entrepreneur.dart';
import 'package:mundi_flutter_platform_client_app/app/models/modality.dart';
import 'package:mundi_flutter_platform_client_app/app/modules/home/modules/entrepreneur/modules/reserve/reserve_page.dart';

class ModalityTile extends StatefulWidget {
  final int entrepreneurId;
  final Modality modality;
  final Entrepreneur entrepreneur;
  const ModalityTile(
      {super.key, required this.modality, required this.entrepreneurId, required this.entrepreneur});

  @override
  State<ModalityTile> createState() => _ModalityTileState();
}

class _ModalityTileState extends State<ModalityTile> {
  void checkIfIsLogged() async {
    final localStorage = Modular.get<LocalStorage>();
    bool isLogged = await localStorage.contains("accessToken");
    if (isLogged) {
      Modular.to.pushNamed(
        '/home/entrepreneur/reserve',
        arguments: ReservePageArguments(
                        entrepreneurId: widget.entrepreneurId, modality: widget.modality,entrepreneur: widget.entrepreneur),
      );
    } else {
      Modular.to.pushNamed(
        '/auth/options',
      );
    }
  }

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
            style: context.textStyles.textMedium.copyWith(
              fontSize: 12,
            ),
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
                    style: context.textStyles.textRegular.copyWith(
                      fontSize: 8,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                width: 8,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.colors.secondary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 14.5,
                    horizontal: 21.5,
                  ),
                ),
                onPressed: checkIfIsLogged,
                child: Text(
                  "Reservar",
                  style: context.textStyles.textMedium.copyWith(
                    fontWeight: FontWeight.w900,
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
