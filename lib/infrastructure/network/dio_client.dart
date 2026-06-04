import 'package:dio/dio.dart';

/// Client HTTP (dio) — extensible pour API REST SaaS (facturation, export, etc.).
class DioClient {
  DioClient({String? baseUrl})
      : _dio = Dio(
          BaseOptions(
            baseUrl: baseUrl ?? 'https://api.example.com',
            connectTimeout: const Duration(seconds: 15),
            receiveTimeout: const Duration(seconds: 15),
            headers: {'Accept': 'application/json'},
          ),
        );

  final Dio _dio;

  Dio get client => _dio;

  Future<Response<Map<String, dynamic>>> getJson(String path) async {
    final r = await _dio.get<Map<String, dynamic>>(path);
    return r;
  }
}
