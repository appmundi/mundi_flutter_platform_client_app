import 'package:dio/dio.dart';
import 'package:mundi_flutter_platform_client_app/app/core/helpers/environments.dart';
import 'package:mundi_flutter_platform_client_app/app/core/rest/rest_client.dart';
import 'package:mundi_flutter_platform_client_app/app/core/rest/rest_client_exception.dart';
import 'package:mundi_flutter_platform_client_app/app/core/rest/rest_client_response.dart';
import 'package:mundi_flutter_platform_client_app/app/core/storage/local_storage.dart';

class CustomDio implements RestClient {
  late final Dio _dio;
  final LocalStorage localStorage;

  final _defaultOptions = BaseOptions(
    baseUrl: Environments.get('BASE_URL') ?? '',
    connectTimeout: const Duration(milliseconds: 60000),
    receiveTimeout: const Duration(milliseconds: 60000),
    validateStatus: (status) => [401, 200, 201].contains(status),
  );

  CustomDio({BaseOptions? baseOptions, required this.localStorage}) {
    _dio = Dio(baseOptions ?? _defaultOptions);
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await localStorage.read<String>('accessToken');
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
      ),
    );
  }

  @override
  RestClient auth() => this;

  @override
  RestClient unAuth() {
    _dio.options.headers.remove('Authorization');
    return this;
  }

  @override
  Future<RestClientResponse<T>> get<T>(String path,
      {Map<String, dynamic>? queryParameters,
      Map<String, dynamic>? headers}) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return RestClientResponse<T>.fromDio(response);
    } on DioException catch (e) {
      throw RestClientException.fromDioException(e);
    }
  }

  @override
  Future<RestClientResponse<T>> post<T>(String path,
      {dynamic data,
      Map<String, dynamic>? queryParameters,
      Map<String, dynamic>? headers}) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return RestClientResponse<T>.fromDio(response);
    } on DioException catch (e) {
      throw RestClientException.fromDioException(e);
    }
  }

  @override
  Future<RestClientResponse<T>> put<T>(String path,
      {data,
      Map<String, dynamic>? queryParameters,
      Map<String, String>? headers}) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return RestClientResponse<T>.fromDio(response);
    } on DioException catch (e) {
      throw RestClientException.fromDioException(e);
    }
  }

  @override
  Future<RestClientResponse<T>> delete<T>(
      String path, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Map<String, dynamic>? headers,
      }) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return RestClientResponse<T>.fromDio(response);
    } on DioException catch (e) {
      throw RestClientException.fromDioException(e);
    }
  }
}
