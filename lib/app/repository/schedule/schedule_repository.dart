import 'dart:developer';

import 'package:flutter_modular/flutter_modular.dart';
import 'package:mundi_flutter_platform_client_app/app/core/rest/rest_client_exception.dart';
import 'package:mundi_flutter_platform_client_app/app/core/storage/local_storage.dart';
import 'package:mundi_flutter_platform_client_app/app/models/schedule.dart';
import 'package:mundi_flutter_platform_client_app/app/repository/schedule/i_schedule_repository.dart';

import '../../core/exception/connection_exception.dart';
import '../../core/rest/rest_client.dart';
import '../../models/feedback.dart';

class ScheduleRepository implements IScheduleRepository {
  final RestClient _rest;
  final LocalStorage localStorage = Modular.get<LocalStorage>();

  ScheduleRepository({
    required RestClient rest,
  }) : _rest = rest;

  @override
  Future<List<Schedule>?> schedules() async {
    final String? token = await localStorage.read('accessToken');
    try {
      var headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };
      final response =
          await _rest.get("/scheduling/findByUserId", headers: headers);

      final schedules = (response.data as List)
          .map<Schedule>((data) => Schedule.fromMap(data))
          .toList();

      log("Agendamentos : ${schedules.toString()}");

      return schedules;
    } on RestClientException catch (e, s) {
      print(e);
      print(s);
      throw ConnectionException();
    }
  }

  @override
  Future<void> cancelSchedule(int scheduleId) async {
    final tk = await localStorage.read("accessToken");
    final headers = {
      'Content-type': 'application/json',
      'Authorization': "Bearer $tk",
    };

    final response = await _rest.post(
      '/scheduling/$scheduleId/cancel',
      data: {'cancellerType': 'user'},
      headers: headers,
    );

    // Surface backend failures instead of silently succeeding — the cubit
    // depends on this to know whether the appointment was really cancelled.
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw ConnectionException(
        errorMessage: 'Falha ao cancelar o agendamento',
      );
    }
  }

  @override
  Future<List<Schedule>?> filterSchedule() async {
    try {
      return null;
    } on Error {
      return null;
    }
  }

  @override
  Future<void> sendFeedback(Feedback feedback) async {
    print('sending feedback');
    try {
      await _rest.post(
        '/avaliation/${feedback.entrepreneurId}/evaluate',
        data: feedback.toMap(),
        headers: {
          'Content-Type': 'application/json',
        }
      );
    } catch (e) {
      throw new Exception('Erro ao enviar feedback');
    }
  }
}
