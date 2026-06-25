import 'dart:io';

import 'package:mundi_flutter_platform_client_app/app/core/notifications/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../repositories/i_device_token_repository.dart';

class RegisterFcmTokenUseCase {
  final IDeviceTokenRepository? _repo;

  RegisterFcmTokenUseCase(this._repo);

  /// background-safe constructor — no HTTP, only stores token locally.
  RegisterFcmTokenUseCase.backgroundSafe() : _repo = null;

  /// Called from foreground: fetches current FCM token and registers with backend.
  Future<void> run() async {
    final token = await NotificationService.instance.currentFcmToken();
    if (token == null) return;

    // Persist token so it survives background isolate writes from storeToken()
    final sp = await SharedPreferences.getInstance();
    await sp.setString('_fcm_token', token);

    await _repo?.registerToken(
      token: token,
      platform: Platform.isAndroid ? 'android' : 'ios',
      ownerType: 'user',
    );
  }

  /// Called from background isolate (fcmTokenHandle) — persists only, no HTTP.
  Future<void> storeToken(String token) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString('_fcm_token', token);
  }

  /// Removes the token from the backend on logout.
  Future<void> unregister() async {
    final sp = await SharedPreferences.getInstance();
    final token = sp.getString('_fcm_token');
    if (token == null) return;

    await _repo?.removeToken(token);
    await sp.remove('_fcm_token');
  }
}
