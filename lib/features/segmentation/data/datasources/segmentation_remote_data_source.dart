import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/storage/token_storage.dart';
import '../models/dashboard_summary_dto.dart';
import '../models/segmentation_student_dto.dart';

abstract class SegmentationRemoteDataSource {
  Future<List<SegmentationStudentDto>> getStudents({required String userId});
  Future<DashboardSummaryDto> getSummary({required String userId});
  Future<List<SegmentationStudentDto>> searchStudents({
    required String userId,
    required String query,
  });
}

class SegmentationRemoteDataSourceImpl implements SegmentationRemoteDataSource {
  SegmentationRemoteDataSourceImpl(this._client, this._tokenStorage);

  final http.Client _client;
  final TokenStorage _tokenStorage;
  static const _requestTimeout = Duration(seconds: 20);

  @override
  Future<List<SegmentationStudentDto>> getStudents({
    required String userId,
  }) async {
    final response = await _get(
      '/students',
      userId,
      queryParameters: const {'limit': '500', 'offset': '0', 'role': 'tutor'},
    );
    final data = _normalizeResponse(response);
    return data.map((json) => SegmentationStudentDto.fromJson(json)).toList();
  }

  @override
  Future<DashboardSummaryDto> getSummary({required String userId}) async {
    final response = await _get(
      '/summary',
      userId,
      queryParameters: const {'role': 'tutor'},
    );
    final json = jsonDecode(response.body);
    if (json is! Map<String, dynamic>) {
      throw const ServerException(
        'El resumen de segmentación tiene un formato inválido.',
      );
    }
    return DashboardSummaryDto.fromJson(json);
  }

  @override
  Future<List<SegmentationStudentDto>> searchStudents({
    required String userId,
    required String query,
  }) async {
    final response = await _get(
      '/search',
      userId,
      queryParameters: {
        'q': query.trim(),
        'top_k': '20',
        'mode': 'auto',
        'retrieval': 'hybrid',
        'role': 'tutor',
        'explain': 'true',
      },
    );
    final data = _normalizeResponse(response);
    return data.map((json) => SegmentationStudentDto.fromJson(json)).toList();
  }

  Future<http.Response> _get(
    String path,
    String userId, {
    Map<String, String> queryParameters = const {},
  }) async {
    final token = await _tokenStorage.getToken();
    if (token == null || token.trim().isEmpty) {
      throw const AuthException('La sesión expiró. Inicia sesión nuevamente.');
    }
    if (userId.trim().isEmpty) {
      throw const AuthException(
        'No fue posible identificar al tutor autenticado.',
      );
    }

    final baseUri = Uri.parse(AppConstants.segmentationApiUrl);
    final url = baseUri.replace(
      path: '${baseUri.path}$path',
      queryParameters: queryParameters.isEmpty ? null : queryParameters,
    );

    final response = await _client
        .get(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
            'X-CASEI-ROLE': 'tutor',
            'X-CASEI-USER-ID': userId,
            'X-CASEI-PURPOSE': 'casei_mobile_dashboard',
          },
        )
        .timeout(_requestTimeout);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return response;
    }

    throw ServerException(_extractMessage(response.body));
  }

  List<Map<String, dynamic>> _normalizeResponse(http.Response response) {
    final decoded = jsonDecode(response.body);
    if (decoded is List) {
      return decoded
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
    }
    if (decoded is Map<String, dynamic>) {
      final items =
          decoded['items'] ??
          decoded['data'] ??
          decoded['results'] ??
          decoded['students'] ??
          decoded['data_items'];
      if (items is List) {
        return items
            .whereType<Map>()
            .map((item) => Map<String, dynamic>.from(item))
            .toList();
      }
    }
    return [];
  }

  String _extractMessage(String body) {
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>) {
        return decoded['message']?.toString() ??
            decoded['detail']?.toString() ??
            decoded['error']?.toString() ??
            'Error del servidor';
      }
      return 'Error del servidor';
    } catch (_) {
      return 'Error del servidor';
    }
  }
}
