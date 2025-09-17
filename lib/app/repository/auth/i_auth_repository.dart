import 'dart:io';

import 'package:mundi_flutter_platform_client_app/app/models/user.dart';

abstract class IAuthRepository {
  Future<String> login(String email, String password);
  Future<void> register(User user);
  Future<User> findOneById(int userId);
  Future<void> updateUser(int userId, String name, String email, String phone, [File? image]);
  Future<void> resetPassword(String email);
  Future<void> validateCode(String email, String code);
  Future<void> updatePassword(String email, String code, String newPassword);
  Future<void> updateImage(int userId, File file);
  Future<void> deleteImage(int userId);
}
