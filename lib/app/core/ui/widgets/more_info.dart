import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:mundi_flutter_platform_client_app/app/core/helpers/environments.dart';
import 'package:mundi_flutter_platform_client_app/app/core/rest/http/http_rest_client.dart';
import 'package:mundi_flutter_platform_client_app/app/core/storage/local_storage.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/extension/date_time_extension.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/styles/text_styles.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/widgets/app_button.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/widgets/reserve_tile.dart';
import 'package:mundi_flutter_platform_client_app/app/models/reservation.dart';
import 'package:mundi_flutter_platform_client_app/app/repository/schedule/schedule_repository.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;  // Pacote HTTP


import '../../../modules/home/modules/chat/chat_page.dart';

class MoreInfoModal {
  static Future<void> show(
      BuildContext context, Reservation reservation) async {
    await showModalBottomSheet(
      context: context,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.7,
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(16))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    width: double.infinity,
                    child: Text(
                      "Informações gerais",
                      textAlign: TextAlign.left,
                      style: context.textStyles.titleBold.copyWith(
                        fontSize: 20,
                        decoration: TextDecoration.none,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
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
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xff40B64B),
                            border: Border.all(
                              color: const Color(0xff40B64B),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(
                              15,
                            ),
                          ),
                          child: Text(
                            'O profissional que irá realizar o seu serviço chegará em',
                            style: context.textStyles.textRegular
                                .copyWith(color: Colors.white, fontSize: 12),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ReserveTile(
                          modality: reservation.modality,
                          selectedDate: reservation.startAt,
                          selectedTime: reservation.startAt.appTimeFormat,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: AppButton(
                              text: "Chat",
                              onPressed: () async{

                                final message = 'Olá, estou entrando em contato através do aplicativo da mundi.';

                                final encodedMessage = Uri.encodeComponent(message);

                                final whatsappUrl = Uri.parse('https://wa.me/+55${reservation.entrepreneurPhone}?text=$encodedMessage');

                                if (await canLaunchUrl(whatsappUrl)) {
                                  await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
                                } else {
                                  throw 'Could not launch $whatsappUrl';
                                }

                                Navigator.pop(context);
                               /* Modular.to.pushNamed('/home/chat/',
                                    arguments: ChatPageArguments(
                                        entrepreneurId:
                                            reservation.entrepreneurId,
                                        userId: reservation.userId));*/
                              }),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: AppButton(
                            text: "Cancelar agendamento",
                            onPressed: () async{
                              await showDialog<bool>(
                                context: context,
                                builder: (BuildContext dialogContext) {
                                  return StatefulBuilder(
                                    builder: (BuildContext context, StateSetter setState) {
                                      return AlertDialog(
                                        title: const Text('Confirmar cancelamento'),
                                        content: const Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SizedBox(height: 16),
                                            Text('Deseja cancelar o agendamento ?'),
                                          ],
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            child: Text('Não'),
                                            onPressed: () {
                                              Navigator.of(dialogContext).pop(false);
                                            },
                                          ),
                                          TextButton(
                                            child: Text('Sim'),
                                            onPressed: () {
                                              cancelSchedule(reservation.scheduleId);
                                              Navigator.of(dialogContext).pop(true);
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              );

                              Navigator.pop(context);
                              /* Modular.to.pushNamed(
                                '/home/chat/',
                                arguments: ChatPageArguments(
                                    entrepreneurId: reservation.entrepreneurId,
                                    userId: reservation.userId),
                              );*/
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }


}

void _fetchChallengesByStatus(int scheduleId) async {
  try {
    final restClient =
    HttpRestClient(baseUrl: Environments.get("BASE_URL") ?? "");
    final cancelSchedule = await ScheduleRepository(
      rest: restClient,
    ).cancelSchedule(scheduleId);


  } catch (error, s) {
    print("Deu erro > $error, + $s");
  }
}




Future<void> cancelSchedule(int scheduleId) async {
  try {
    final LocalStorage localStorage = Modular.get<LocalStorage>();

    final tk = await localStorage.read("accessToken");

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer $tk",
    };

    // URL completa
    final url = 'https://api.mundiapp.com.br/scheduling/$scheduleId/cancel';

    // Fazendo a requisição POST
    final response = await http.post(
      Uri.parse(url),
      headers: headers,
    );

    if (response.statusCode == 200) {
      print("Cancelamento realizado com sucesso");
      print(response.body);
    } else {
      print("Erro ao cancelar: ${response.statusCode} - ${response.body}");
    }
  } catch (e) {
    print("Erro: ${e.toString()}");
  }
}
