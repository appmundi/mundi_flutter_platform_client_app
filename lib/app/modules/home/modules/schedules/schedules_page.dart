import 'dart:developer';

import 'package:flutter/material.dart' hide Feedback;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart'
    hide ModularWatchExtension;
import 'package:geocoding/geocoding.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:mundi_flutter_platform_client_app/app/core/storage/local_storage.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/extension/date_time_extension.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/styles/colors_app.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/styles/text_styles.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/widgets/filter_widget.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/widgets/reserve_tile.dart';
import 'package:mundi_flutter_platform_client_app/app/models/reservation.dart';
import 'package:mundi_flutter_platform_client_app/app/models/schedule.dart';
import 'package:mundi_flutter_platform_client_app/app/modules/home/modules/schedules/cubit/schedules_cubit.dart';
import 'package:mundi_flutter_platform_client_app/app/modules/home/modules/schedules/cubit/schedules_state.dart';
import 'package:mundi_flutter_platform_client_app/app/modules/home/modules/schedules/widgets/schedule_feedback_modal.dart';
import 'package:mundi_flutter_platform_client_app/app/modules/home/modules/schedules/widgets/schedules_outline_button.dart';
import 'package:mundi_flutter_platform_client_app/app/modules/home/modules/schedules/widgets/schedules_search_text_field.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/ui/widgets/more_info.dart';
import '../../../../models/feedback.dart';

class SchedulesPage extends StatefulWidget {
  const SchedulesPage({super.key});

  @override
  State<SchedulesPage> createState() => _SchedulesPageState();
}

class _SchedulesPageState extends State<SchedulesPage> {
  final TextEditingController _filterSchedule = TextEditingController();

  Future<void> _refreshSchedules() async {
    await context.read<ScheduleCubit>().loadSchedule();
  }

  void abrirWazeOuMaps(double latitude, double longitude) async {
    final wazeUrl = 'waze://?ll=$latitude,$longitude&navigate=yes';
    final googleMapsUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    final appleMapsUrl = 'http://maps.apple.com/?ll=$latitude,$longitude';

    if (await canLaunchUrl(Uri.parse(wazeUrl))) {
      await launchUrl(
        Uri.parse(wazeUrl),
        mode: LaunchMode.externalApplication,
      );
      return;
    }

    if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
      await launchUrl(
        Uri.parse(googleMapsUrl),
        mode: LaunchMode.externalApplication,
      );
      return;
    }

    if (await canLaunchUrl(Uri.parse(appleMapsUrl))) {
      await launchUrl(
        Uri.parse(appleMapsUrl),
        mode: LaunchMode.externalApplication,
      );
    }
  }

  Future<void> checkSchedulesToFeedback(List<Schedule> schedules) async {
    if (schedules.isEmpty) return;

    final needFeedbackSchedule = schedules.where(
      (schedule) {
        return schedule.status == 'FEEDBACK';
      },
    ).firstOrNull;

    if (needFeedbackSchedule == null) return;

    final profile = await getProfile();

    final response = await showDialog(
      context: context,
      builder: (context) {
        return const ScheduleFeedbackModal();
      },
    );
    if(response == null) {
      return;
    }
    final [comment, rating] = response;
    final feedback = Feedback(
      comment: comment,
      entrepreneurId: needFeedbackSchedule.entrepreneurEntrepreneurId,
      rating: (rating as int).toDouble(),
      scheduleId: needFeedbackSchedule.id,
      userName: profile['username'],
      userId: profile['id'],
    );
    await context.read<ScheduleCubit>().sendFeedback(feedback);
    _refreshSchedules();
  }

  Future<Map<String, dynamic>> getProfile() async {
    final localStorage = Modular.get<LocalStorage>();
    String token = await localStorage.read('accessToken');
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    print("Aq ${decodedToken}");

    return decodedToken;
  }

  @override
  void initState() {
    super.initState();
    context.read<ScheduleCubit>().loadSchedule();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ScheduleCubit, ScheduleState>(
      listener: (context, state) {
        if (state.status == ScheduleStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'Erro ao carregar os dados'),
            ),
          );
        }
        state.status.matchAny(
            any: () {},
            success: () {
              checkSchedulesToFeedback(state.schedules ?? []);
            });
      },
      builder: (context, state) {
        if (state.status == ScheduleStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        // Ordenar a lista filtrada por data
        List<Schedule> sortedSchedules = List.from(state.scheduleFiltered);
        sortedSchedules.sort((a, b) {
          DateTime dateA = DateTime.parse(a.scheduledDate);
          DateTime dateB = DateTime.parse(b.scheduledDate);
          return dateA.compareTo(dateB);
        });

        return Scaffold(
          appBar: AppBar(
            title: Image.asset(
              'assets/images/dark_logo.png',
              height: 32,
            ),
            automaticallyImplyLeading: false,
            centerTitle: false,
          ),
          body: RefreshIndicator(
            onRefresh: _refreshSchedules, // Adicionando pull-to-refresh
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Próximos agendamentos",
                    style: context.textStyles.titleBold.copyWith(
                      color: context.colors.primary,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SchedulesSearchTextField(
                    hintText: "Pesquisar por agendamentos",
                    controller: _filterSchedule,
                    onChanged: (value) async {
                      await context
                          .read<ScheduleCubit>()
                          .applyFilter(_filterSchedule.text);
                    },
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  const FilterWidget(),
                  const SizedBox(
                    height: 15,
                  ),

                    Visibility(
                      visible: sortedSchedules.isNotEmpty,
                      replacement: const Center(
                        child: Text('Nenhum agendamento encontrado'),
                      ),
                      child: Expanded(
                        child: ListView.separated(
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 10),
                          physics: const AlwaysScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: sortedSchedules.length,
                          itemBuilder: (context, index) {
                            DateTime scheduledDate = DateTime.parse(
                                sortedSchedules[index].scheduledDate);

                            final currentDate = DateTime.now();
                            final currentDateWithoutTime = DateTime(
                                currentDate.year,
                                currentDate.month,
                                currentDate.day);
                            final scheduledDateWithoutTime = DateTime(
                                scheduledDate.year,
                                scheduledDate.month,
                                scheduledDate.day);

                            if (!scheduledDateWithoutTime
                                .isBefore(currentDateWithoutTime)) {
                              return Column(
                                children: [
                                  ReserveTile(
                                    modality: sortedSchedules[index].modality,
                                    selectedDate: scheduledDate,
                                    selectedTime: scheduledDate.appTimeFormat,
                                  ),
                                  const SizedBox(height: 7),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SchedulesOutlineButton(
                                        onPressed: () {
                                          MoreInfoModal.show(
                                            context,
                                            Reservation(
                                              entrepreneurId:
                                                  sortedSchedules[index]
                                                      .entrepreneurEntrepreneurId,
                                              userId: sortedSchedules[index]
                                                  .userUserId,
                                              modality:
                                                  sortedSchedules[index].modality,
                                              startAt: DateTime.parse(
                                                  sortedSchedules[index]
                                                      .scheduledDate),
                                              entrepreneurPhone:
                                                  sortedSchedules[index]
                                                      .entrepreneurPhone,
                                              scheduleId:
                                                  sortedSchedules[index].id,
                                            ),
                                          );
                                        },
                                        label: 'Mais informações',
                                      ),
                                      SchedulesOutlineButton(
                                        onPressed: () {
                                          _getCoordinatesFromAddress(
                                              sortedSchedules[index].cep);
                                        },
                                        label: 'Como chegar',
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 30),
                                ],
                              );
                            } else {
                              return const Row();
                            }
                          },
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _refreshSchedules, // Função chamada pelo botão
            child: const Icon(Icons.refresh),
            backgroundColor: context.colors.secondary,
          ),
        );
      },
    );
  }

  Future<void> _getCoordinatesFromAddress(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        Location location = locations.first;
        abrirWazeOuMaps(location.latitude, location.longitude);
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
