import 'dart:io';

import 'package:flutter/material.dart' hide Feedback;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
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

  Future<void> _showMapSelectionDialog(double latitude, double longitude) async {
    final selectedOption = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        final mapOptions = _getMapOptions();

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Como chegar',
                  style: context.textStyles.titleBold.copyWith(
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 24),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 16,
                  children: mapOptions.map((option) => _buildMapOption(
                    icon: option['icon'],
                    label: option['label'],
                    color: option['color'],
                    onTap: () => Navigator.of(context).pop(option['type']),
                  )).toList(),
                ),
                const SizedBox(height: 24),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  ),
                  child: Text(
                    'Cancelar',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (selectedOption != null) {
      await _openSelectedMap(selectedOption, latitude, longitude);
    }
  }

  List<Map<String, dynamic>> _getMapOptions() {
    final options = <Map<String, dynamic>>[
      {
        'icon': MdiIcons.waze,
        'label': 'Waze',
        'color': const Color(0xFF00D4AA),
        'type': 'waze',
      },
      {
        'icon': MdiIcons.googleMaps,
        'label': 'Google Maps',
        'color': const Color(0xFF4285F4),
        'type': 'google',
      },
    ];

    // Adiciona Apple Maps apenas se for iOS
    if (Platform.isIOS) {
      options.add({
        'icon': MdiIcons.apple,
        'label': 'Apple Maps',
        'color': const Color(0xFF000000),
        'type': 'apple',
      });
    }

    return options;
  }

  Widget _buildMapOption({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 80,
        height: 80,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 28,
              color: color,
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openSelectedMap(String mapType, double latitude, double longitude) async {
    String url;

    switch (mapType) {
      case 'waze':
        url = 'waze://?ll=$latitude,$longitude&navigate=yes';
        break;
      case 'google':
        url = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
        break;
      case 'apple':
        url = 'http://maps.apple.com/?ll=$latitude,$longitude';
        break;
      default:
        return;
    }

    try {
      final uri = Uri.parse(url);
      
      // No iOS, canLaunchUrl não funciona bem para URL schemes customizados
      // mesmo quando estão no Info.plist. Tentamos abrir diretamente.
      if (Platform.isIOS) {
        try {
          final launched = await launchUrl(
            uri,
            mode: LaunchMode.externalApplication,
          );
          
          if (!launched) {
            // Se não conseguiu abrir e é o Waze, oferece instalar
            if (mapType == 'waze' && mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Waze não está instalado. Abrindo App Store...'),
                  backgroundColor: Colors.orange,
                ),
              );
              await launchUrl(
                Uri.parse('https://apps.apple.com/app/id323229106'),
                mode: LaunchMode.externalApplication,
              );
            } else if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Não foi possível abrir o ${_getMapName(mapType)}.'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        } catch (e) {
          // Se der erro ao tentar abrir Waze, oferece instalar
          if (mapType == 'waze' && mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Waze não está instalado. Abrindo App Store...'),
                backgroundColor: Colors.orange,
              ),
            );
            await launchUrl(
              Uri.parse('https://apps.apple.com/app/id323229106'),
              mode: LaunchMode.externalApplication,
            );
          } else if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Erro ao abrir ${_getMapName(mapType)}: ${e.toString()}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      } else {
        // Android: verifica antes de tentar abrir
        if (await canLaunchUrl(uri)) {
          await launchUrl(
            uri,
            mode: LaunchMode.externalApplication,
          );
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Não foi possível abrir o ${_getMapName(mapType)}. Verifique se está instalado.'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao abrir o aplicativo de mapas: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  String _getMapName(String mapType) {
    switch (mapType) {
      case 'waze':
        return 'Waze';
      case 'google':
        return 'Google Maps';
      case 'apple':
        return 'Apple Maps';
      default:
        return 'aplicativo de mapas';
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

        List<Schedule> sortedSchedules = List.from(state.scheduleFiltered);
        sortedSchedules.sort((a, b) {
          DateTime dateA = a.scheduledDate.apiDateMinusThreeHours;
          DateTime dateB = b.scheduledDate.apiDateMinusThreeHours;
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
            onRefresh: _refreshSchedules,
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
                  FilterWidget(
                    onTap: () {

                    },
                  ),

                  Visibility(
                    visible: sortedSchedules.isNotEmpty,
                    replacement: const Center(
                      child: Text('Nenhum agendamento encontrado'),
                    ),
                    child: Expanded(
                      child: ListView.separated(
                        separatorBuilder: (context, index) =>
                        const SizedBox(height: 2),
                        physics: const AlwaysScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: sortedSchedules.length,
                        itemBuilder: (context, index) {
                          final scheduledDate =
                              sortedSchedules[index].scheduledDate.apiDateMinusThreeHours;

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
                                            startAt: sortedSchedules[index]
                                                .scheduledDate
                                                .apiDateMinusThreeHours,
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
                                    if (!sortedSchedules[index].optionwork)
                                      SchedulesOutlineButton(
                                        onPressed: () {
                                          _getCoordinatesFromAddress(
                                              sortedSchedules[index].cep);
                                        },
                                        label: 'Como chegar',
                                      )
                                    else
                                      Padding(
                                        padding: const EdgeInsets.only(right: 4),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.home_outlined,
                                              size: 16,
                                              color: Colors.grey[600],
                                            ),
                                            const SizedBox(width: 6),
                                            Text(
                                              'Prestador irá até você',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey[600],
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
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
        // Agora chama o dialog de seleção ao invés de tentar abrir diretamente
        await _showMapSelectionDialog(location.latitude, location.longitude);
      }
    } catch (e) {
      print('Error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao obter coordenadas do endereço: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}