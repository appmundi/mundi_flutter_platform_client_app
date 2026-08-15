import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:mundi_flutter_platform_client_app/app/core/notifications/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../repositories/i_device_token_repository.dart';

class RegisterFcmTokenUseCase {
  static const _tokenKey = '_fcm_token';

  final IDeviceTokenRepository? _repo;

  RegisterFcmTokenUseCase(this._repo);

  /// background-safe constructor — no HTTP, only stores token locally.
  RegisterFcmTokenUseCase.backgroundSafe() : _repo = null;

  /// Called from foreground: fetches current FCM token and registers with backend.
  Future<void> run() async {
    final sp = await SharedPreferences.getInstance();

    var token = '';
    try {
      token = await NotificationService.instance.currentFcmToken() ?? '';
    } catch (e) {
      debugPrint('FCM token request failed: $e');
    }

    // On iOS the token only exists once APNs registration completes, so fall
    // back to whatever storeToken() already persisted from the plugin callback.
    if (token.isEmpty) token = sp.getString(_tokenKey) ?? '';
    if (token.isEmpty) return;

    await sp.setString(_tokenKey, token);
    await _register(token);
  }

  /// Called from the plugin's onFcmTokenHandle whenever FCM mints or rotates a
  /// token — the path that actually delivers it on iOS.
  Future<void> storeToken(String token) async {
    if (token.isEmpty) return;

    final sp = await SharedPreferences.getInstance();
    await sp.setString(_tokenKey, token);
    await _register(token);
  }

  /// Removes the token from the backend on logout.
  Future<void> unregister() async {
    final sp = await SharedPreferences.getInstance();
    final token = sp.getString(_tokenKey);
    if (token == null) return;

    try {
      await _repo?.removeToken(token);
    } catch (e) {
      debugPrint('FCM token unregister failed: $e');
    }
    await sp.remove(_tokenKey);
  }

  Future<void> _register(String token) async {
    final repo = _repo;
    if (repo == null) return;

    try {
      await repo.registerToken(
        token: token,
        platform: Platform.isAndroid ? 'android' : 'ios',
        ownerType: 'user',
      );
    } catch (e) {
      debugPrint('FCM token registration failed: $e');
    }
  }
}
