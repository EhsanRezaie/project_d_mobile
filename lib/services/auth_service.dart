import 'package:dio/dio.dart';
import 'api_service.dart';

class AuthService {
  // ============================================================
  // Step 1: Request verification code
  // POST /auth/register/init
  // ============================================================
  static Future<Response> registerInit(String email) async {
    try {
      return await ApiService.post(
        '/auth/register/init',
        data: {'email': email},
      );
    } on DioException catch (e) {
      if (e.response != null) {
        return e.response!;
      }
      rethrow;
    }
  }

  // ============================================================
  // Step 2: Verify code + create user
  // POST /auth/register/verify
  // ============================================================
  static Future<Response> registerVerify({
    required String email,
    required String code,
    required String password,
    String? referralCode,
  }) async {
    final data = {
      'email': email,
      'code': code,
      'password': password,
    };
    if (referralCode != null && referralCode.isNotEmpty) {
      data['referral_code'] = referralCode;
    }
    try {
      return await ApiService.post(
        '/auth/register/verify',
        data: data,
      );
    } on DioException catch (e) {
      if (e.response != null) {
        return e.response!;
      }
      rethrow;
    }
  }

  // ============================================================
  // Step 3: Complete profile
  // POST /auth/register/complete
  // ============================================================
  static Future<Response> registerComplete(Map<String, dynamic> data) async {
    try {
      return await ApiService.post(
        '/auth/register/complete',
        data: data,
      );
    } on DioException catch (e) {
      if (e.response != null) {
        return e.response!;
      }
      rethrow;
    }
  }

  // ============================================================
  // Login
  // POST /auth/login
  // ============================================================
  static Future<Response> login({
    required String email,
    required String password,
  }) async {
    try {
      return await ApiService.post(
        '/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );
    } on DioException catch (e) {
      if (e.response != null) {
        return e.response!;
      }
      rethrow;
    }
  }

  // ============================================================
  // Refresh Token
  // POST /auth/refresh
  // ============================================================
  static Future<Response> refreshToken(String refreshToken) async {
    try {
      return await ApiService.post(
        '/auth/refresh',
        data: {'refresh_token': refreshToken},
      );
    } on DioException catch (e) {
      if (e.response != null) {
        return e.response!;
      }
      rethrow;
    }
  }

  // ============================================================
  // Logout
  // POST /auth/logout
  // ============================================================
  static Future<Response> logout(String refreshToken) async {
    try {
      return await ApiService.post(
        '/auth/logout',
        data: {'refresh_token': refreshToken},
      );
    } on DioException catch (e) {
      if (e.response != null) {
        return e.response!;
      }
      rethrow;
    }
  }

  // ============================================================
  // Change Password
  // POST /auth/change-password
  // ============================================================
  static Future<Response> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      return await ApiService.post(
        '/auth/change-password',
        data: {
          'old_password': oldPassword,
          'new_password': newPassword,
        },
      );
    } on DioException catch (e) {
      if (e.response != null) {
        return e.response!;
      }
      rethrow;
    }
  }

  // ============================================================
  // Get Current User
  // GET /users/me
  // ============================================================
  static Future<Response> getCurrentUser() async {
    try {
      return await ApiService.get('/users/me');
    } on DioException catch (e) {
      if (e.response != null) {
        return e.response!;
      }
      rethrow;
    }
  }

  // ============================================================
  // Health Check
  // GET /health (without /api/v1)
  // ============================================================
  static Future<Response> healthCheck() async {
    try {
      return await ApiService.healthCheck();
    } on DioException catch (e) {
      if (e.response != null) {
        return e.response!;
      }
      rethrow;
    }
  }
}