abstract class IDeviceTokenRepository {
  Future<void> registerToken({
    required String token,
    required String platform,
    required String ownerType,
    String? appVersion,
  });

  Future<void> removeToken(String token);
}
