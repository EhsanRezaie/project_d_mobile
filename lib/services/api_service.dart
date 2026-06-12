import 'package:dio/dio.dart';
import '../config/app_constants.dart';

class ApiService {
  static late Dio _dio;
  
  static void init() {
    _dio = Dio(BaseOptions(
      baseUrl: AppConstants.apiBaseUrl,
      connectTimeout: const Duration(seconds: AppConstants.connectTimeout),
      receiveTimeout: const Duration(seconds: AppConstants.receiveTimeout),
      headers: {'Content-Type': 'application/json'},
    ));
    
    // Add logging interceptor for debugging
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
  
  // GET request
  static Future<Response> get(String path, {Map<String, dynamic>? queryParams}) async {
    return await _dio.get(path, queryParameters: queryParams);
  }
  
  // POST request
  static Future<Response> post(String path, {dynamic data}) async {
    return await _dio.post(path, data: data);
  }
  
  // PUT request
  static Future<Response> put(String path, {dynamic data}) async {
    return await _dio.put(path, data: data);
  }
  
  // PATCH request
  static Future<Response> patch(String path, {dynamic data}) async {
    return await _dio.patch(path, data: data);
  }
  
  // DELETE request
  static Future<Response> delete(String path) async {
    return await _dio.delete(path);
  }
  
  // Upload file with FormData
  static Future<Response> upload(String path, FormData formData) async {
    return await _dio.post(path, data: formData);
  }
}