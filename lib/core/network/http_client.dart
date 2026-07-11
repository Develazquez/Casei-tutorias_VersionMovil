import 'dart:convert';

import 'package:http/http.dart' as http;

import '../errors/failures.dart';
import '../storage/token_storage.dart';

class HttpClient {
  HttpClient(this._client, this._tokenStorage);

  final http.Client _client;
  final TokenStorage _tokenStorage;

  Future<http.Response> get(Uri uri) async {
    final response = await _client.get(uri, headers: await _headers());
    return _handle(response);
  }

  Future<http.Response> post(Uri uri, {Map<String, dynamic>? body}) async {
    final response = await _client.post(
      uri,
      headers: await _headers(),
      body: body == null ? null : jsonEncode(body),
    );
    return _handle(response);
  }

  Future<Map<String, String>> _headers() async {
    final token = await _tokenStorage.getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  http.Response _handle(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return response;
    }
    final message = _extractMessage(response.body);
    if (response.statusCode == 401 || response.statusCode == 403) {
      throw AuthException(message);
    }
    if (response.statusCode == 400 || response.statusCode == 422) {
      throw ValidationException(message);
    }
    throw ServerException(message);
  }

  String _extractMessage(String body) {
    if (body.isEmpty) return 'Ocurrió un error inesperado.';
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>) {
        return decoded['message']?.toString() ??
            decoded['error']?.toString() ??
            'Ocurrió un error inesperado.';
      }
    } catch (_) {
      return body;
    }
    return 'Ocurrió un error inesperado.';
  }
}
