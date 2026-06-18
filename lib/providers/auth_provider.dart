import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../services/auth_service.dart';
import '../services/storage_service.dart';
import '../models/user.dart';

class AuthProvider extends ChangeNotifier {
  final StorageService _storageService = StorageService();

  User? _user;
  String? _email;
  bool _isLoading = false;
  bool _isAuthenticated = false;
  bool _isServerHealthy = true;
  String? _serverError;
  String? _errorMessage;

  User? get user => _user;
  String? get email => _email;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;
  bool get isServerHealthy => _isServerHealthy;
  String? get serverError => _serverError;
  String? get errorMessage => _errorMessage;

  AuthProvider() {
    // Do NOT call _loadTokens() here anymore
    // Everything will be handled in initializeApp()
  }

  // ============================================================
  // Initialize app - check server health + auth status
  // ============================================================
  Future<bool> initializeApp() async {
    _isLoading = true;
    _isServerHealthy = true;
    _serverError = null;
    _isAuthenticated = false;
    _user = null;
    notifyListeners();

    print('🔍 Initializing app...');

    // 1. Check server health
    final isHealthy = await _checkServerHealth();
    if (!isHealthy) {
      _isLoading = false;
      _isServerHealthy = false;
      _serverError = 'Server connection failed';
      notifyListeners();
      print('❌ Server health check failed');
      return false;
    }
    print('✅ Server is healthy');

    // 2. Check if tokens exist
    final hasTokens = await _storageService.hasTokens();
    if (!hasTokens) {
      _isLoading = false;
      _isAuthenticated = false;
      _user = null;
      notifyListeners();
      print('❌ No tokens found');
      return false;
    }
    print('✅ Tokens found');

    // 3. Validate token
    final isValid = await _validateToken();
    if (!isValid) {
      await _storageService.clearTokens();
      _isAuthenticated = false;
      _user = null;
      _isLoading = false;
      notifyListeners();
      print('❌ Token validation failed');
      return false;
    }

    _isAuthenticated = true;
    _isLoading = false;
    notifyListeners();
    print('✅ User is authenticated: ${_user?.email}');
    return true;
  }

  Future<bool> _checkServerHealth() async {
    try {
      final response = await AuthService.healthCheck();
      return response.statusCode == 200;
    } catch (e) {
      print('❌ Health check error: $e');
      return false;
    }
  }

  Future<bool> _validateToken() async {
    try {
      final response = await AuthService.getCurrentUser();
      if (response.statusCode == 200) {
        _user = User.fromJson(response.data);
        print('✅ User loaded: ${_user?.email}');
        return true;
      }
      print('❌ GetCurrentUser failed: ${response.statusCode}');
      return false;
    } catch (e) {
      print('❌ Validate token error: $e');
      return false;
    }
  }

  // ============================================================
  // Step 1: Register Init - request verification code
  // POST /auth/register/init
  // ============================================================
  Future<bool> registerInit(String email) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await AuthService.registerInit(email);
      if (response.statusCode == 200) {
        _email = email;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = response.data['detail'] ?? 'Failed to send code';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        _errorMessage = 'This email is already registered';
      } else if (e.response?.statusCode == 422) {
        _errorMessage = 'Invalid email format';
      } else if (e.response?.statusCode == 429) {
        _errorMessage = 'Too many attempts. Please wait';
      } else {
        _errorMessage = 'Network error. Please try again';
      }
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'Something went wrong';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // ============================================================
  // Step 2: Register Verify - verify code + create user
  // POST /auth/register/verify
  // ============================================================
  Future<bool> registerVerify({
    required String code,
    required String password,
    String? referralCode,
  }) async {
    if (_email == null) {
      _errorMessage = 'Email not found. Please start over';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await AuthService.registerVerify(
        email: _email!,
        code: code,
        password: password,
        referralCode: referralCode,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        await _storageService.saveTokens(
          accessToken: data['access_token'],
          refreshToken: data['refresh_token'],
          userId: data['user_id'],
        );
        _isAuthenticated = true;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = response.data['detail'] ?? 'Verification failed';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        _errorMessage = 'Invalid or expired verification code';
      } else if (e.response?.statusCode == 409) {
        _errorMessage = 'This email is already registered';
      } else {
        _errorMessage = 'Network error. Please try again';
      }
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'Something went wrong';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // ============================================================
  // Step 3: Register Complete - complete profile
  // POST /auth/register/complete
  // ============================================================
  Future<bool> registerComplete(Map<String, dynamic> data) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await AuthService.registerComplete(data);
      if (response.statusCode == 200) {
        final responseData = response.data;
        final userData = responseData['user'];

        await _storageService.saveTokens(
          accessToken: responseData['access_token'],
          refreshToken: responseData['refresh_token'],
          userId: userData['id'],
        );

        _user = User.fromJson(userData);
        _isAuthenticated = true;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = response.data['detail'] ?? 'Profile completion failed';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        _errorMessage = 'Profile is already complete';
      } else if (e.response?.statusCode == 401) {
        _errorMessage = 'Session expired. Please login again';
      } else if (e.response?.statusCode == 422) {
        _errorMessage = 'Invalid data provided';
      } else {
        _errorMessage = 'Network error. Please try again';
      }
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'Something went wrong';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // ============================================================
  // Login
  // POST /auth/login
  // ============================================================
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await AuthService.login(
        email: email,
        password: password,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final userData = data['user'];

        await _storageService.saveTokens(
          accessToken: data['access_token'],
          refreshToken: data['refresh_token'],
          userId: userData['id'],
        );

        _user = User.fromJson(userData);
        _isAuthenticated = true;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = response.data['detail'] ?? 'Login failed';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        _errorMessage = 'Incorrect email or password';
      } else {
        _errorMessage = 'Network error. Please try again';
      }
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'Something went wrong';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // ============================================================
  // Logout
  // ============================================================
  Future<void> logout() async {
    final refreshToken = await _storageService.getRefreshToken();
    if (refreshToken != null) {
      try {
        await AuthService.logout(refreshToken);
      } catch (e) {
        // ignore logout errors
      }
    }
    await _storageService.clearTokens();
    _user = null;
    _email = null;
    _isAuthenticated = false;
    notifyListeners();
  }

  // ============================================================
  // Refresh user data
  // ============================================================
  Future<void> refreshUser() async {
    try {
      final response = await AuthService.getCurrentUser();
      if (response.statusCode == 200) {
        _user = User.fromJson(response.data);
        notifyListeners();
      }
    } catch (e) {
      // ignore
    }
  }

  void resetServerError() {
    _serverError = null;
    _isServerHealthy = true;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}