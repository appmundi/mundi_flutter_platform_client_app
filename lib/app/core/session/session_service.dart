import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:mundi_flutter_platform_client_app/app/core/storage/local_storage.dart';

class SessionService {
  final LocalStorage _storage;

  SessionService(this._storage);

  Future<String?> token() => _storage.read<String>('accessToken');

  Future<bool> isLoggedIn() async {
    final tk = await token();
    if (tk == null || tk.isEmpty) return false;
    try {
      JwtDecoder.decode(tk);
    } catch (_) {
      return false;
    }
    try {
      return !JwtDecoder.isExpired(tk);
    } catch (_) {
      // No exp claim means the token never expires
      return true;
    }
  }

  Future<int?> currentUserId() async {
    final tk = await token();
    if (tk == null) return null;
    try {
      final payload = JwtDecoder.decode(tk);
      return payload['sub'] as int? ?? payload['userId'] as int?;
    } catch (_) {
      return null;
    }
  }

  Future<int?> currentEntrepreneurId() async {
    final tk = await token();
    if (tk == null) return null;
    try {
      final payload = JwtDecoder.decode(tk);
      return payload['entrepreneurId'] as int?;
    } catch (_) {
      return null;
    }
  }

  Future<void> logout() => _storage.remove('accessToken');

  Future<void> bootstrap() async {
    // called at startup; hook here for future env/fcm init ordering
  }
}
