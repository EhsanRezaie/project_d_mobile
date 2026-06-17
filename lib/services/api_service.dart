// lib/services/api_service.dart
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/app_constants.dart';

class ApiService {
  static late Dio _dio;
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  
  static void init() {
    _dio = Dio(BaseOptions(
      baseUrl: AppConstants.apiBaseUrl,
      connectTimeout: const Duration(seconds: AppConstants.connectTimeout),
      receiveTimeout: const Duration(seconds: AppConstants.receiveTimeout),
      headers: {'Content-Type': 'application/json'},
    ));
    
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _secureStorage.read(key: 'access_token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            final refreshToken = await _secureStorage.read(key: 'refresh_token');
            if (refreshToken != null) {
              try {
                final response = await _dio.post(
                  '${AppConstants.apiBaseUrl}/auth/refresh',
                  data: {'refresh_token': refreshToken},
                );
                if (response.statusCode == 200) {
                  final newAccessToken = response.data['access_token'];
                  final newRefreshToken = response.data['refresh_token'];
                  await _secureStorage.write(key: 'access_token', value: newAccessToken);
                  await _secureStorage.write(key: 'refresh_token', value: newRefreshToken);
                  
                  error.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';
                  return handler.resolve(await _dio.fetch(error.requestOptions));
                }
              } catch (e) {
                await _secureStorage.deleteAll();
              }
            }
          }
          return handler.next(error);
        },
      ),
    );
    
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));
  }
  
  static Dio get dio => _dio;
  
  static void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }
  
  static void clearAuthToken() {
    _dio.options.headers.remove('Authorization');
  }
  
  static Future<Response> get(String path, {Map<String, dynamic>? queryParams}) async {
    return await _dio.get(path, queryParameters: queryParams);
  }
  
  static Future<Response> post(String path, {dynamic data, Map<String, dynamic>? queryParams}) async {
    return await _dio.post(path, data: data, queryParameters: queryParams);
  }
  
  static Future<Response> put(String path, {dynamic data}) async {
    return await _dio.put(path, data: data);
  }
  
  static Future<Response> patch(String path, {dynamic data}) async {
    return await _dio.patch(path, data: data);
  }
  
  static Future<Response> delete(String path) async {
    return await _dio.delete(path);
  }
  
  static Future<Response> upload(String path, FormData formData) async {
    return await _dio.post(path, data: formData);
  }

  // Health check with baseUrl without /api/v1
  static Future<Response> healthCheck() async {
    final healthDio = Dio(BaseOptions(
      baseUrl: AppConstants.apiBaseUrl.replaceAll('/api/v1', ''),
      connectTimeout: const Duration(seconds: AppConstants.connectTimeout),
      receiveTimeout: const Duration(seconds: AppConstants.receiveTimeout),
    ));
    return await healthDio.get('/health');
  }
}