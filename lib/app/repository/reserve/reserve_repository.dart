import 'dart:convert';

import 'package:mundi_flutter_platform_client_app/app/core/exception/invalid_field_exception.dart';
import 'package:mundi_flutter_platform_client_app/app/core/rest/rest_client_exception.dart';
import 'package:mundi_flutter_platform_client_app/app/core/storage/local_storage.dart';
import 'package:mundi_flutter_platform_client_app/app/repository/reserve/i_reserve_repository.dart';

import '../../core/rest/rest_client.dart';

class ReserveRepository implements IReserveRepository {
  final RestClient rest;
  final LocalStorage localStorage;

  ReserveRepository({required this.localStorage, required this.rest});

  @override
  Future<void> createReserve({
    required int entrepreneurId,
    required String scheduledDate,
    required List<int> modalityIds,
    required String description,
    Map<String, String>? address,
  }) async {
    try {
      final response = await rest.post(
        "/scheduling/schedule",
        data: {
          "entrepreneurId": entrepreneurId,
          "scheduledDate": scheduledDate,
          "modalityIds": modalityIds,
          "status": "INIT",
          "description": description,
          "address": address,
        },
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Bearer ${await localStorage.read("accessToken")}",
        },
      );

      if (response.statusCode != 201) {
        throw InvalidFieldException(exception: "Erro ao realizar reserva");
      }
    } on RestClientException catch (e) {
      final apiMessage = _extractApiError(e);
      throw InvalidFieldException(
        exception: apiMessage ?? "Erro ao realizar reserva",
      );
    }
  }

  String? _extractApiError(RestClientException e) {
    final data = e.response?.data;
    if (data is Map && data['error'] is String) {
      return data['error'] as String;
    }
    return null;
  }

  @override
  Future<List<String>> checkHour({
    required int entrepreneurId,
    required String date,
    int? duration,
  }) async {
    try {
      final response = await rest.get(
        "/scheduling/$entrepreneurId/available-times",
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Bearer ${await localStorage.read("accessToken")}",
        },
        queryParameters: {"date": date, "duration": duration},
      );

      List<String> availableTimes = List<String>.from(response.data);
      print("Available times: $availableTimes");

      return availableTimes;
    } catch (e) {
      print("Error check > $e");
      return [];
    }
  }
}
