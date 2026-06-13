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
}