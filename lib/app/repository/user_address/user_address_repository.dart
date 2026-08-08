import 'package:mundi_flutter_platform_client_app/app/core/rest/rest_client.dart';
import 'package:mundi_flutter_platform_client_app/app/core/rest/rest_client_exception.dart';
import 'package:mundi_flutter_platform_client_app/app/core/storage/local_storage.dart';
import 'package:mundi_flutter_platform_client_app/app/models/address.dart';
import 'package:mundi_flutter_platform_client_app/app/repository/user_address/i_user_address_repository.dart';

class UserAddressRepository implements IUserAddressRepository {
  final RestClient rest;
  final LocalStorage localStorage;

  UserAddressRepository({required this.rest, required this.localStorage});

  Future<Map<String, String>> _authHeaders() async {
    final token = await localStorage.read('accessToken');
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  @override
  Future<List<Address>> list() async {
    try {
      final response = await rest.get(
        '/user/address',
        headers: await _authHeaders(),
      );
      final data = (response.data as List?) ?? [];
      return data
          .map((item) => Address.fromMap(item as Map<String, dynamic>))
          .toList();
    } on RestClientException catch (e) {
      print('[UserAddressRepository] list: erro $e');
      throw Exception('Não foi possível carregar seus endereços');
    }
  }

  @override
  Future<Address> create(Address address) async {
    try {
      final response = await rest.post(
        '/user/address',
        data: address.toCreateDto(),
        headers: await _authHeaders(),
      );
      final data = response.data;
      if (data is! Map<String, dynamic>) {
        throw Exception('Resposta inesperada ao salvar endereço');
      }
      return Address.fromMap(data);
    } on RestClientException catch (e) {
      print('[UserAddressRepository] create: erro $e');
      throw Exception(_extractApiError(e) ?? 'Não foi possível salvar o endereço');
    }
  }

  @override
  Future<void> delete(int id) async {
    try {
      await rest.delete(
        '/user/address/$id',
        headers: await _authHeaders(),
      );
    } on RestClientException catch (e) {
      print('[UserAddressRepository] delete: erro $e');
      throw Exception(_extractApiError(e) ?? 'Não foi possível excluir o endereço');
    }
  }

  String? _extractApiError(RestClientException e) {
    final data = e.response?.data;
    if (data is Map && data['error'] is String) {
      return data['error'] as String;
    }
    if (data is Map && data['message'] is String) {
      return data['message'] as String;
    }
    return null;
  }
}
