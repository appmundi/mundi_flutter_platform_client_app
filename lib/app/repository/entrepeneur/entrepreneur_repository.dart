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
    } catch (e) {
      throw ConnectionException();
    }
  }

  @override
  Future<Entrepreneur?> search(int id) async {
    try {
      final response = await _rest.get('/entrepreneur/search/$id', headers: {
        'Content-Type': 'application/json',
      });
      return Entrepreneur.fromMap(response.data);
    } catch (e) {
      throw ConnectionException();
    }
  }
}
