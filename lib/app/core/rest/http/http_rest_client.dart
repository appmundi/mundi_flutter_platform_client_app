import 'package:http/http.dart' as http;
import 'package:mundi_flutter_platform_client_app/app/core/rest/rest_client.dart';
import 'package:mundi_flutter_platform_client_app/app/core/rest/rest_client_response.dart';

class HttpRestClient implements RestClient {
  late final http.Client rest;
  final String baseUrl;
  final Map<String, String> defaultHeaders;

  HttpRestClient({
    required this.baseUrl,
  })  : rest = http.Client(),
        defaultHeaders = {
          'content-type': 'application/json',
        };

  @override
  RestClient auth() {
    defaultHeaders['authorization'] = 'token';
    return this;
  }

  @override
  Future<RestClientResponse<T>> get<T>(String path,
      {Map<String, dynamic>? queryParameters,
      Map<String, String>? headers}) async {
    final uri = Uri.https(baseUrl, path, queryParameters);
    final response = await rest.get(uri, headers: joinHeaders(headers));
    return RestClientResponse.fromHttp(response);
  }

  @override
  Future<RestClientResponse<T>> post<T>(String path,
      {data,
      Map<String, dynamic>? queryParameters,
      Map<String, String>? headers}) async {
    final uri = Uri.https(baseUrl, path, queryParameters);
    final response =
        await rest.post(uri, body: data, headers: joinHeaders(headers));
    print(data);
    return RestClientResponse.fromHttp(response);
  }

  @override
  Future<RestClientResponse<T>> put<T>(String path,
      {data,
        Map<String, dynamic>? queryParameters,
        Map<String, String>? headers}) async {

    final uri = Uri.https(baseUrl, path, queryParameters);
    final response =
    await rest.put(uri, body: data, headers: joinHeaders(headers));
    return RestClientResponse.fromHttp(response);
  }

  @override
  RestClient unAuth() {
    defaultHeaders.remove("authorization");
    return this;
  }

  Map<String, String> joinHeaders(Map<String, String>? h) {
    Map<String, String> headers = defaultHeaders;
    h?.forEach((key, value) {
      headers[key] = value;
    });
    return headers;
  }

  @override
  Future<RestClientResponse<T>> delete<T>(
      String path, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Map<String, String>? headers,
      }) async {
    final uri = Uri.https(baseUrl, path, queryParameters);

    final request = http.Request('DELETE', uri);
    request.headers.addAll(joinHeaders(headers));
    if (data != null) {
      request.body = data;
    }

    final streamedResponse = await rest.send(request);
    final response = await http.Response.fromStream(streamedResponse);
    return RestClientResponse.fromHttp(response);
  }

}
