import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/storage/token_storage.dart';
import '../models/segmentation_student_dto.dart';
import '../models/dashboard_summary_dto.dart';

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

  @override
  Future<List<SegmentationStudentDto>> getStudents({required String userId}) async {
    final response = await _get('/students?limit=500&offset=0&role=tutor', userId);
    final data = _normalizeResponse(response);
    return data.map((json) => SegmentationStudentDto.fromJson(json)).toList();
  }

  @override
  Future<DashboardSummaryDto> getSummary({required String userId}) async {
    final response = await _get('/summary', userId);
    final json = jsonDecode(response.body);
    return DashboardSummaryDto.fromJson(json);
  }

  @override
  Future<List<SegmentationStudentDto>> searchStudents({
    required String userId,
    required String query,
  }) async {
    final response = await _get('/search?q=$query&top_k=20&role=tutor', userId);
    final data = _normalizeResponse(response);
    return data.map((json) => SegmentationStudentDto.fromJson(json)).toList();
  }

  Future<http.Response> _get(String path, String userId) async {
    final token = await _tokenStorage.getToken();
    final url = Uri.parse('${AppConstants.segmentationApiUrl}$path');
    
    final response = await _client.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
        'X-CASEI-ROLE': 'tutor',
        'X-CASEI-USER-ID': userId,
        'X-CASEI-PURPOSE': 'casei_mobile_dashboard',
      },
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return response;
    }
    
    throw ServerException(_extractMessage(response.body));
  }

  List<dynamic> _normalizeResponse(http.Response response) {
    final decoded = jsonDecode(response.body);
    if (decoded is List) return decoded;
    if (decoded is Map<String, dynamic>) {
      final items = decoded['items'] ?? 
                    decoded['data'] ?? 
                    decoded['results'] ?? 
                    decoded['students'] ?? 
                    decoded['data_items']; // adding another potential one
      if (items is List) return items;
    }
    return [];
  }

  String _extractMessage(String body) {
    try {
      final decoded = jsonDecode(body);
      return decoded['message'] ?? decoded['error'] ?? 'Error del servidor';
    } catch (_) {
      return 'Error del servidor';
    }
  }
}
