// lib/services/auth_service.dart
import 'package:dio/dio.dart';
import 'package:dating_app/services/api_service.dart';

class AuthService {
  // ============================================================
  // Health Check
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

  // ============================================================
  // Step 1: Register Init - request verification code
  // POST /auth/register/init
  // ============================================================
  static Future<Response> registerInit(String email) async {
    try {
      return await ApiService.post('/auth/register/init', data: {
        'email': email,
      });
    } on DioException catch (e) {
      if (e.response != null) {
        return e.response!;
      }
      rethrow;
    }
  }

  // ============================================================
  // Step 2: Register Verify - verify code + create user
  // POST /auth/register/verify
  // ============================================================
  static Future<Response> registerVerify({
    required String email,
    required String code,
    required String password,
    String? referralCode,
  }) async {
    try {
      final data = {
        'email': email,
        'code': code,
        'password': password,
      };
      if (referralCode != null && referralCode.isNotEmpty) {
        data['referral_code'] = referralCode;
      }
      return await ApiService.post('/auth/register/verify', data: data);
    } on DioException catch (e) {
      if (e.response != null) {
        return e.response!;
      }
      rethrow;
    }
  }

  // ============================================================
  // Step 3: Register Complete - complete profile
  // POST /auth/register/complete
  // ============================================================
  static Future<Response> registerComplete(Map<String, dynamic> data) async {
    try {
      return await ApiService.post('/auth/register/complete', data: data);
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

  // ============================================================
  // Google Login
  // POST /auth/google
  // ============================================================
  static Future<Response> googleLogin({
    required String idToken,
    String? name,
    String? email,
    String? picture,
  }) async {
    try {
      final data = {
        'id_token': idToken,
      };
      if (name != null && name.isNotEmpty) data['name'] = name;
      if (email != null && email.isNotEmpty) data['email'] = email;
      if (picture != null && picture.isNotEmpty) data['picture'] = picture;
      return await ApiService.post('/auth/google', data: data);
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
      return await ApiService.post('/auth/refresh', data: {
        'refresh_token': refreshToken,
      });
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
      return await ApiService.post('/auth/logout', data: {
        'refresh_token': refreshToken,
      });
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
  // Update Current User Profile
  // PUT /users/me
  // All fields are optional - only provided fields will be updated
  // ============================================================
  static Future<Response> updateProfile(Map<String, dynamic> data) async {
    try {
      return await ApiService.put('/users/me', data: data);
    } on DioException catch (e) {
      if (e.response != null) {
        return e.response!;
      }
      rethrow;
    }
  }

  // ============================================================
  // Delete Account (soft delete)
  // DELETE /users/me
  // ============================================================
  static Future<Response> deleteAccount() async {
    try {
      return await ApiService.delete('/users/me');
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
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      return await ApiService.post('/auth/change-password', data: {
        'current_password': currentPassword,
        'new_password': newPassword,
      });
    } on DioException catch (e) {
      if (e.response != null) {
        return e.response!;
      }
      rethrow;
    }
  }

  // ============================================================
  // Password Reset Request
  // POST /auth/password-reset
  // ============================================================
  static Future<Response> requestPasswordReset(String email) async {
    try {
      return await ApiService.post('/auth/password-reset', data: {
        'email': email,
      });
    } on DioException catch (e) {
      if (e.response != null) {
        return e.response!;
      }
      rethrow;
    }
  }

  // ============================================================
  // Password Reset Verify
  // POST /auth/password-reset/verify
  // ============================================================
  static Future<Response> verifyPasswordReset({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    try {
      return await ApiService.post('/auth/password-reset/verify', data: {
        'email': email,
        'code': code,
        'new_password': newPassword,
      });
    } on DioException catch (e) {
      if (e.response != null) {
        return e.response!;
      }
      rethrow;
    }
  }

  static Future<Response> updateInterests(List<String> interests) async {
    try {
      return await ApiService.put('/users/me/interests', data: {
        'interests': interests,
      });
    } on DioException catch (e) {
      if (e.response != null) {
        return e.response!;
      }
      rethrow;
    }
  }

  /// Update user settings
  /// PUT /users/me/settings
  static Future<Response> updateSettings(Map<String, dynamic> data) async {
    try {
      return await ApiService.put('/users/me/settings', data: data);
    } on DioException catch (e) {
      if (e.response != null) {
        return e.response!;
      }
      rethrow;
    }
  }

  /// Update user prompts
  /// PUT /users/me/prompts
  static Future<Response> updatePrompts(List<Map<String, dynamic>> prompts) async {
    try {
      return await ApiService.put('/users/me/prompts', data: {
        'prompts': prompts,
      });
    } on DioException catch (e) {
      if (e.response != null) {
        return e.response!;
      }
      rethrow;
    }
  }

}