import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:mundi_flutter_platform_client_app/app/core/exception/connection_exception.dart';
import 'package:mundi_flutter_platform_client_app/app/core/exception/invalid_field_exception.dart';
import 'package:mundi_flutter_platform_client_app/app/core/exception/user_already_exists.dart';
import 'package:mundi_flutter_platform_client_app/app/core/rest/rest_client.dart';
import 'package:mundi_flutter_platform_client_app/app/core/storage/local_storage.dart';
import 'package:mundi_flutter_platform_client_app/app/models/user.dart';
import 'package:mundi_flutter_platform_client_app/app/repository/auth/i_auth_repository.dart';

class AuthRepository implements IAuthRepository {
  final RestClient _rest;
  final LocalStorage localStorage;

  const AuthRepository({required RestClient rest, required LocalStorage})
    : _rest = rest,
      localStorage = LocalStorage;

  String _normalizeLoginIdentifier(String value) {
    final v = value.trim();
    if (v.contains('@')) return v;
    return v.replaceAll(RegExp(r'\D'), '');
  }

  @override
  Future<String> login(String email, String password) async {
    try {
      final response = await _rest.post(
        "/user/login",
        data: {
          'email': _normalizeLoginIdentifier(email),
          'password': password,
          "isEntrepreneur": false,
        },
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 401) {
        throw InvalidFieldException();
      }

      final accessToken = response.data['access_token'];
      localStorage.write("access_token", accessToken);

      log("TOKEN > ${accessToken}");

      return accessToken;
    } on DioException {
      throw ConnectionException(
        errorMessage: "Erro ao conectar-se com o Servidor",
      );
    }
  }

  @override
  Future<void> register(User user) async {
    try {
      final response = await _rest.post(
        "/user/register",
        data: user.toMap(),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.data['mensagem'] == "Usuário já cadastrado") {
        throw UserAlreadyExists();
      } else if (response.data['mensagem'] == "Erro ao cadastrar!") {
        throw InvalidFieldException(exception: response.data['mensagem']);
      }
    } on DioException {
      throw ConnectionException(
        errorMessage: "Erro ao conectar-se com o servidor",
      );
    }
  }

  @override
  Future<User> findOneById(int userId) async {
    try {
      final response = await _rest.get(
        "/user/searchById$userId",
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 401) {
        throw InvalidFieldException();
      }

      final userData = User.fromJson(jsonEncode(response.data));

      return userData;
    } on DioException {
      throw ConnectionException(
        errorMessage: "Erro ao conectar-se com o Servidor",
      );
    }
  }

  @override
  Future<void> updateUser(
    int userId,
    String name,
    String email,
    String phone, [
    File? image,
  ]) async {
    try {
      final response = await _rest.put(
        "/user/$userId",
        data: {
          'name': name,
          'email': email,
          'phone': phone,
          'image': image?.readAsBytesSync(),
        },
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 401) {
        throw InvalidFieldException();
      }
    } catch (e) {
      print("Error > $e");
    } on DioException {
      throw ConnectionException(
        errorMessage: "Erro ao conectar-se com o Servidor",
      );
    }
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      final response = await _rest.post(
        "/user/reset-password",
        data: {'email': email},
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 401) {
        throw InvalidFieldException();
      }
    } on DioException {
      throw ConnectionException(
        errorMessage: "Erro ao conectar-se com o Servidor",
      );
    }
  }

  @override
  Future<void> validateCode(String email, String code) async {
    try {
      final response = await _rest.post(
        "/user/validate-reset-code",
        data: {'email': email, 'code': code},
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 401) {
        throw InvalidFieldException();
      }
    } on DioException {
      throw ConnectionException(
        errorMessage: "Erro ao conectar-se com o Servidor",
      );
    }
  }

  @override
  Future<void> updatePassword(
    String email,
    String code,
    String newPassword,
  ) async {
    try {
      final response = await _rest.post(
        "/user/update-password",
        data: {'email': email, 'code': code, 'newPassword': newPassword},
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 401) {
        throw InvalidFieldException();
      }
    } on DioException {
      throw ConnectionException(
        errorMessage: "Erro ao conectar-se com o Servidor",
      );
    }
  }

  @override
  Future<void> updateImage(int userId, File file) async {
    try {
      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(
          file.path,
          filename: file.path.split('/').last,
        ),
      });

      final response = await _rest.put(
        "/user/update-image/$userId",
        data: formData,
      );

      if (response.statusCode == 401) {
        throw InvalidFieldException();
      }
    } on DioException {
      throw ConnectionException(
        errorMessage: "Erro ao conectar-se com o Servidor",
      );
    }
  }

  @override
  Future<void> deleteImage(int userId) async {
    try {
      final response = await _rest.delete(
        "/images/profile/user/$userId",
      );

      if (response.statusCode == 401) {
        throw InvalidFieldException();
      }
    } on DioException {
      throw ConnectionException(
        errorMessage: "Erro ao conectar-se com o Servidor",
      );
    }
  }

  @override
  Future<void> deleteAccount(int userId) async {
    try {
      final token = await localStorage.read('accessToken');
      if (token == null || token.isEmpty) {
        throw InvalidFieldException(exception: 'Sessão expirada');
      }

      print('[FLUTTER PLATFORM CLIENT] deleteAccount: userId=$userId, tokenExists=${token.isNotEmpty}');
      final response = await _rest.delete(
        "/user/$userId",
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('[FLUTTER PLATFORM CLIENT] deleteAccount response: statusCode=${response.statusCode}, data=${response.data}');
      if (response.statusCode == 401) {
        throw InvalidFieldException();
      }
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ConnectionException(
          errorMessage: "Erro ao excluir a conta",
        );
      }
    } on DioException catch (e) {
      print('[FLUTTER PLATFORM CLIENT] deleteAccount DioException: $e');
      print('[FLUTTER PLATFORM CLIENT] response: ${e.response?.statusCode} ${e.response?.data}');
      throw ConnectionException(
        errorMessage: "Erro ao conectar-se com o Servidor",
      );
    }
  }
}
