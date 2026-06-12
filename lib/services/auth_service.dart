import 'package:dio/dio.dart';
import 'api_service.dart';

class AuthService {
  static Future<Response> register({
    required String email,
    required String password,
    required String name,
    required int age,
    required String gender,
    String? referralCode,
  }) async {
    try {
      return await ApiService.post('/auth/register', data: {
        'email': email,
        'password': password,
        'name': name,
        'age': age,
        'gender': gender,
        'referral_code': referralCode,
      });
    } on DioException catch (e) {
      if (e.response != null) {
        return e.response!;
      }
      rethrow;
    }
  }

  static Future<Response> login({
    required String email,
    required String password,
  }) async {
    try {
      return await ApiService.post('/auth/login', data: {
        'email': email,
        'password': password,
      });
    } on DioException catch (e) {
      if (e.response != null) {
        return e.response!;
      }
      rethrow;
    }
  }

  static Future<Response> refreshToken(String refreshToken) async {
    return await ApiService.post('/auth/refresh', data: {
      'refresh_token': refreshToken,
    });
  }

  static Future<Response> logout(String refreshToken) async {
    return await ApiService.post('/auth/logout', data: {
      'refresh_token': refreshToken,
    });
  }

  static Future<Response> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    return await ApiService.post('/auth/change-password', data: {
      'old_password': oldPassword,
      'new_password': newPassword,
    });
  }
}