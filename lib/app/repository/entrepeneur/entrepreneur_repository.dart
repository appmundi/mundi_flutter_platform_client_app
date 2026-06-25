import 'dart:developer';

import 'package:mundi_flutter_platform_client_app/app/core/exception/connection_exception.dart';
import 'package:mundi_flutter_platform_client_app/app/core/rest/rest_client.dart';
import 'package:mundi_flutter_platform_client_app/app/models/entrepreneur.dart';
import 'package:mundi_flutter_platform_client_app/app/repository/entrepeneur/i_entrepreneur_repository.dart';

class EntrepreneurRepository implements IEntrepreneurRepository {
  final RestClient _rest;

  EntrepreneurRepository({
    required RestClient rest,
  }) : _rest = rest;

  @override
  Future<List<Entrepreneur>?> searchAll([String? query]) async {
    try {
      final response = await _rest.get("/entrepreneur/searchAll",headers: {
        'Content-Type': 'application/json',
      }, queryParameters: {
        'query': query,
      });
      print('deu erro?');
      print(response.data);
      final entrepreneurs = (response.data as List)
          .map<Entrepreneur>((data){
       return Entrepreneur.fromMap(data);
      })
          .toList();

      return entrepreneurs;
    } catch (e) {
      print(e);
      throw ConnectionException();
    }
  }

  @override
  Future<Entrepreneur?> search(int id) async {
    try {
      final response = await _rest.get("/entrepreneur/search/$id",headers: {
        'Content-Type': 'application/json',
      });
      
      final entrepreneur = Entrepreneur.fromMap(response.data);

      return entrepreneur;
    } catch (e) {
      print(e);
      throw ConnectionException();
    }
  }
}
