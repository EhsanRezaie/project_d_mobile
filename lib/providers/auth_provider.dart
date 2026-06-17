// lib/providers/auth_provider.dart
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/auth_service.dart';
import '../services/storage_service.dart';
import '../models/user.dart';

class AuthProvider extends ChangeNotifier {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final StorageService _storageService = StorageService();
  
  User? _user;
  String? _accessToken;
  String? _refreshToken;
  bool _isLoading = false;
  bool _isAuthenticated = false;
  bool _isServerHealthy = true;
  String? _serverError;
  String? _error;

  User? get user => _user;
  String? get accessToken => _accessToken;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;
  bool get isServerHealthy => _isServerHealthy;
  String? get serverError => _serverError;
  String? get error => _error;

  AuthProvider() {
    _loadTokens();
  }

  Future<void> _loadTokens() async {
    _accessToken = await _secureStorage.read(key: 'access_token');
    _refreshToken = await _secureStorage.read(key: 'refresh_token');
    if (_accessToken != null) {
      _isAuthenticated = true;
    }
    notifyListeners();
  }

  Future<bool> initializeApp() async {
    _isLoading = true;
    _isServerHealthy = true;
    _serverError = null;
    notifyListeners();

    final isHealthy = await _checkServerHealth();
    if (!isHealthy) {
      _isLoading = false;
      _isServerHealthy = false;
      _serverError = 'Server connection failed';
      notifyListeners();
      return false;
    }

    await _loadTokens();

    if (_accessToken != null) {
      final isValid = await _validateToken();
      if (!isValid) {
        await _logout();
        _isAuthenticated = false;
        _accessToken = null;
        _refreshToken = null;
      } else {
        _isAuthenticated = true;
      }
    }

    _isLoading = false;
    notifyListeners();
    return _isAuthenticated;
  }

  Future<bool> _checkServerHealth() async {
    try {
      final response = await AuthService.healthCheck();
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<bool> _validateToken() async {
    try {
      final response = await AuthService.getCurrentUser();
      if (response.statusCode == 200) {
        _user = User.fromJson(response.data);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await AuthService.login(
        email: email,
        password: password,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        _accessToken = data['access_token'];
        _refreshToken = data['refresh_token'];
        _user = User.fromJson(data['user']);
        _isAuthenticated = true;

        await _storageService.saveTokens(
          accessToken: _accessToken!,
          refreshToken: _refreshToken!,
        );
        await _storageService.saveUser(_user!);

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = response.data['detail'] ?? 'Login failed';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Network error. Please try again.';
      _isLoading = false;
      notifyListeners();
      return false;
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
        _accessToken = data['access_token'];
        _refreshToken = data['refresh_token'];
        _user = User.fromJson(data['user']);
        _isAuthenticated = true;

        await _storageService.saveTokens(
          accessToken: _accessToken!,
          refreshToken: _refreshToken!,
        );
        await _storageService.saveUser(_user!);

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = response.data['detail'] ?? 'Registration failed';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Network error. Please try again.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> _logout() async {
    await _storageService.clearAll();
    _accessToken = null;
    _refreshToken = null;
    _user = null;
    _isAuthenticated = false;
    notifyListeners();
  }

  Future<void> logout() async {
    if (_refreshToken != null) {
      try {
        await AuthService.logout(_refreshToken!);
      } catch (e) {
        // Ignore errors on logout
      }
    }
    await _logout();
  }

  Future<void> checkAuthStatus() async {
    await _loadTokens();
    if (_accessToken != null) {
      final isValid = await _validateToken();
      if (!isValid) {
        await _logout();
      } else {
        _isAuthenticated = true;
      }
    }
    notifyListeners();
  }

  void resetServerError() {
    _serverError = null;
    _isServerHealthy = true;
    notifyListeners();
  }
}