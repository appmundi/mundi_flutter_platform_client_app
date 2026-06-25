import 'dart:convert';

import 'package:mundi_flutter_platform_client_app/app/core/rest/rest_client.dart';
import 'package:mundi_flutter_platform_client_app/app/core/storage/local_storage.dart';

import 'i_device_token_repository.dart';

class DeviceTokenRepository implements IDeviceTokenRepository {
  final RestClient _rest;
  final LocalStorage _storage;

  DeviceTokenRepository({required RestClient rest, required LocalStorage storage})
      : _rest = rest,
        _storage = storage;

  @override
  Future<void> registerToken({
    required String token,
    required String platform,
    required String ownerType,
    String? appVersion,
  }) async {
    final accessToken = await _storage.read<String>('accessToken');
    if (accessToken == null) return;

    await _rest.post(
      '/device-tokens',
      data: jsonEncode({
        'token': token,
        'platform': platform,
        'ownerType': ownerType,
        if (appVersion != null) 'appVersion': appVersion,
      }),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
    );
  }

  @override
  Future<void> removeToken(String token) async {
    final accessToken = await _storage.read<String>('accessToken');
    if (accessToken == null) return;

    await _rest.delete(
      '/device-tokens/${Uri.encodeComponent(token)}',
      headers: {'Authorization': 'Bearer $accessToken'},
    );
  }
}
