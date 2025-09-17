import 'package:flutter/material.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/extension/date_time_extension.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/extension/size_screen_extension.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/styles/colors_app.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/styles/text_styles.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/widgets/reserve_tile.dart';
import 'package:mundi_flutter_platform_client_app/app/models/modality.dart';

class ReserveModal {
  static Future<void> show(
      BuildContext context, List<Modality> modalities, DateTime startAt) async {
    await showDialog(
      context: context,
      builder: (context) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Container(
            color: Colors.white,
            height: 1.sh,
            width: 1.sw,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  child: Image.asset(
                    'assets/images/dark_logo.png',
                    height: 35,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Text(
                  "Parabéns, sua reserva foi \nconfirmada!",
                  textAlign: TextAlign.center,
                  style: context.textStyles.titleBold.copyWith(
                    fontSize: 20,
                    decoration: TextDecoration.none,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xFFF2F2F2),
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Lista de modalidades agendadas
                      ...modalities.map((modality) {
                        // Calcular o horário para cada modalidade
                        DateTime modalityStartTime = startAt;

                        // Se não for a primeira modalidade, calcular o horário baseado nas anteriores
                        if (modalities.indexOf(modality) > 0) {
                          int totalPreviousDuration = 0;
                          for (int i = 0; i < modalities.indexOf(modality); i++) {
                            totalPreviousDuration += modalities[i].duration.toInt();
                          }
                          modalityStartTime = startAt.add(Duration(seconds: totalPreviousDuration));
                        }

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: ReserveTile(
                            modality: modality,
                            selectedDate: modalityStartTime,
                            selectedTime: modalityStartTime.appTimeFormat,
                          ),
                        );
                      }).toList(),

                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 10),
                        child: Text.rich(
                          TextSpan(children: [
                            TextSpan(
                                text: 'Equipe: ',
                                style: context.textStyles.titleBold.copyWith(
                                  fontWeight: FontWeight.w400,
                                  decoration: TextDecoration.none,
                                  color: Colors.black,
                                  fontSize: 10,
                                )),
                            TextSpan(
                              text: 'Estabelecimento 01',
                              style: context.textStyles.titleBold.copyWith(
                                fontSize: 10,
                                decoration: TextDecoration.none,
                                color: Colors.black,
                              ),
                            ),
                          ]),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  height: 300,
                  width: 300,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: context.colors.secondary,
                      width: 6,
                    ),
                    borderRadius: BorderRadius.circular(
                      150,
                    ),
                  ),
                  child: Image.asset(
                    'assets/images/like.png',
                    height: 150,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}