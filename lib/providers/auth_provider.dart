import 'package:flutter/material.dart';
import 'dart:convert';
import '../models/user.dart';
import '../services/auth_service.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class AuthProvider extends ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;
  String? _error;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _currentUser != null;

  String _getErrorMessage(int statusCode, dynamic data, {bool isLogin = true}) {
    switch (statusCode) {
      case 401:
        return 'Incorrect email or password. Please try again.';
      case 404:
        return 'User not found. Please check your email.';
      case 409:
        return isLogin 
            ? 'Account already exists. Please login.'
            : 'This email is already registered. Please login.';
      case 422:
        if (data != null && data['detail'] != null) {
          return 'Invalid data: ${data['detail']}';
        }
        return 'Please check your information and try again.';
      default:
        return isLogin 
            ? 'Login failed. Please try again.'
            : 'Registration failed. Please try again.';
    }
  }

  String _getNetworkErrorMessage(dynamic error) {
    if (error.toString().contains('Connection refused') ||
        error.toString().contains('SocketException')) {
      return 'Cannot connect to server. Make sure backend is running on port 8000';
    } else if (error.toString().contains('Timeout')) {
      return 'Connection timeout. Please try again.';
    } else {
      return 'Network error. Please check your connection.';
    }
  }

  Future<bool> register({
    required String email,
    required String password,
    required String name,
    required int age,
    required String gender,
    String? referralCode,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await AuthService.register(
        email: email,
        password: password,
        name: name,
        age: age,
        gender: gender,
        referralCode: referralCode,
      );

      if (response.statusCode == 201) {
        final data = response.data;
        final token = data['access_token'];
        final refreshToken = data['refresh_token'];
        final userJson = data['user'];

        await StorageService.saveToken(token);
        await StorageService.saveRefreshToken(refreshToken);
        await StorageService.saveUser(jsonEncode(userJson));
        
        ApiService.setAuthToken(token);
        _currentUser = User.fromJson(userJson);

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = _getErrorMessage(response.statusCode!, response.data, isLogin: false);
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = _getNetworkErrorMessage(e);
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> login({required String email, required String password}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await AuthService.login(email: email, password: password);

      if (response.statusCode == 200) {
        final data = response.data;
        final token = data['access_token'];
        final refreshToken = data['refresh_token'];
        final userJson = data['user'];

        await StorageService.saveToken(token);
        await StorageService.saveRefreshToken(refreshToken);
        await StorageService.saveUser(jsonEncode(userJson));
        
        ApiService.setAuthToken(token);
        _currentUser = User.fromJson(userJson);

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = _getErrorMessage(response.statusCode!, response.data, isLogin: true);
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = _getNetworkErrorMessage(e);
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> checkAuthStatus() async {
    _isLoading = true;
    notifyListeners();

    final token = await StorageService.getToken();
    final userJson = await StorageService.getUser();

    if (token != null && userJson != null) {
      ApiService.setAuthToken(token);
      try {
        _currentUser = User.fromJson(jsonDecode(userJson));
      } catch (e) {
        print('Error parsing user: $e');
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> logout() async {
    final refreshToken = await StorageService.getRefreshToken();
    if (refreshToken != null) {
      try {
        await AuthService.logout(refreshToken);
      } catch (e) {
        print('Logout error: $e');
      }
    }
    await StorageService.clearAll();
    ApiService.clearAuthToken();
    _currentUser = null;
    notifyListeners();
  }
}