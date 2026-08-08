import 'dart:developer';

import 'package:mundi_flutter_platform_client_app/app/core/exception/connection_exception.dart';
import 'package:mundi_flutter_platform_client_app/app/core/rest/rest_client.dart';
import 'package:mundi_flutter_platform_client_app/app/models/entrepreneur.dart';
import 'package:mundi_flutter_platform_client_app/app/repository/entrepeneur/entrepreneur_search_result.dart';
import 'package:mundi_flutter_platform_client_app/app/repository/entrepeneur/i_entrepreneur_repository.dart';

class EntrepreneurRepository implements IEntrepreneurRepository {
  final RestClient _rest;

  EntrepreneurRepository({
    required RestClient rest,
  }) : _rest = rest;

  @override
  Future<List<Entrepreneur>?> searchAll([String? query, String? section]) async {
    try {
      final response = await _rest.get('/entrepreneur/searchAll', headers: {
        'Content-Type': 'application/json',
      }, queryParameters: {
        if (query != null && query.isNotEmpty) 'query': query,
        if (section != null) 'section': section,
      });
      final entrepreneurs = (response.data as List)
          .map<Entrepreneur>((data) => Entrepreneur.fromMap(data))
          .toList();
      return entrepreneurs;
    } catch (e, s) {
      log(
        'Falha ao listar empreendedores',
        name: 'EntrepreneurRepository',
        error: e,
        stackTrace: s,
      );
      throw ConnectionException(errorMessage: e.toString());
    }
  }

  @override
  Future<EntrepreneurSearchResult> nearby({
    String? query,
    String? section,
    double? latitude,
    double? longitude,
  }) async {
    try {
      final response = await _rest.get('/entrepreneur/nearby', headers: {
        'Content-Type': 'application/json',
      }, queryParameters: {
        if (query != null && query.isNotEmpty) 'query': query,
        if (section != null) 'section': section,
        if (latitude != null && longitude != null) ...{
          'lat': latitude.toString(),
          'lng': longitude.toString(),
        },
      });
      return EntrepreneurSearchResult.fromMap(
        Map<String, dynamic>.from(response.data as Map),
      );
    } catch (e, s) {
      log(
        'Falha ao listar empreendedores por proximidade',
        name: 'EntrepreneurRepository',
        error: e,
        stackTrace: s,
      );
      throw ConnectionException(errorMessage: e.toString());
    }
  }

  @override
  Future<Entrepreneur?> search(int id) async {
    try {
      final response = await _rest.get('/entrepreneur/search/$id', headers: {
        'Content-Type': 'application/json',
      });
      return Entrepreneur.fromMap(response.data);
    } catch (e, s) {
      // Sem este log, uma falha de PARSE chega na UI disfarçada de erro de
      // conexão — foi exatamente o que aconteceu quando a API respondia com
      // Content-Type: text/html e o Dio entregava String em vez de Map.
      log(
        'Falha ao carregar empreendedor $id',
        name: 'EntrepreneurRepository',
        error: e,
        stackTrace: s,
      );
      throw ConnectionException(errorMessage: e.toString());
    }
  }
}
