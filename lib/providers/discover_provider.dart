import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:dating_app/models/discover_profile.dart';
import 'package:dating_app/services/discover_service.dart';

class DiscoverProvider extends ChangeNotifier {
  bool _disposed = false;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  void _safeNotify() {
    if (!_disposed) notifyListeners();
  }

  List<DiscoverProfile> _profiles = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  String? _errorMessage;
  int _total = 0;
  int _offset = 0;
  bool _hasMore = true;

  bool _isPremium = false;
  int _likesRemaining = 0;
  int _dailyLikesLimit = 20;

  String? _genderFilter;
  int _ageMin = 18;
  int _ageMax = 100;
  int _distanceKm = 50;

  List<DiscoverProfile> get profiles => _profiles;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  String? get errorMessage => _errorMessage;
  bool get hasMore => _hasMore;
  bool get isPremium => _isPremium;
  int get likesRemaining => _likesRemaining;
  int get dailyLikesLimit => _dailyLikesLimit;
  String? get genderFilter => _genderFilter;
  int get ageMin => _ageMin;
  int get ageMax => _ageMax;
  int get distanceKm => _distanceKm;

  List<DiscoverProfile> get visibleProfiles => _profiles.take(1).toList();

  bool get hasProfiles => _profiles.isNotEmpty;

  double get likesProgress {
    if (_isPremium || _dailyLikesLimit == 0) return 1.0;
    return (_dailyLikesLimit - _likesRemaining) / _dailyLikesLimit;
  }

  Future<void> loadProfiles() async {
    _isLoading = true;
    _errorMessage = null;
    _offset = 0;
    _hasMore = true;
    _safeNotify();

    try {
      final response = await DiscoverService.getDiscoverProfiles(
        gender: _genderFilter,
        ageMin: _ageMin,
        ageMax: _ageMax,
        distanceKm: _distanceKm,
        limit: 20,
        offset: 0,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        _profiles = (data['users'] as List)
            .map((j) => DiscoverProfile.fromJson(j as Map<String, dynamic>))
            .toList();
        _total = data['total'] ?? 0;
        _hasMore = _profiles.length < _total && _profiles.isNotEmpty;
        _offset = _profiles.length;
      } else {
        _errorMessage = 'Failed to load profiles';
      }
    } on DioException catch (e) {
      debugPrint('DiscoverProvider.loadProfiles DioError: ${e.message} (status: ${e.response?.statusCode})');
      _errorMessage = 'Network error. Please try again.';
    } catch (e) {
      debugPrint('DiscoverProvider.loadProfiles Error: $e');
      _errorMessage = 'Something went wrong';
    }

    _isLoading = false;
    _safeNotify();

    await _refreshLimits();
  }

  Future<void> loadMore() async {
    if (_isLoadingMore || !_hasMore) return;
    _isLoadingMore = true;
    _safeNotify();

    try {
      final response = await DiscoverService.getDiscoverProfiles(
        gender: _genderFilter,
        ageMin: _ageMin,
        ageMax: _ageMax,
        distanceKm: _distanceKm,
        limit: 20,
        offset: _offset,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final more = (data['users'] as List)
            .map((j) => DiscoverProfile.fromJson(j as Map<String, dynamic>))
            .toList();
        _profiles.addAll(more);
        _offset = _profiles.length;
        _hasMore = _profiles.length < (data['total'] ?? _total);
      }
    } catch (_) {}

    _isLoadingMore = false;
    _safeNotify();
  }

  Future<Map<String, dynamic>?> swipeRight(DiscoverProfile profile) async {
    try {
      final response = await DiscoverService.swipeUser(profile.id, 'like');
      _removeProfile(profile);
      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        await _refreshLimits();
        if (data['matched'] == true) {
          return data;
        }
      }
    } catch (_) {}
    return null;
  }

  Future<void> swipeLeft(DiscoverProfile profile) async {
    try {
      await DiscoverService.swipeUser(profile.id, 'pass');
      _removeProfile(profile);
    } catch (_) {}
  }

  Future<Map<String, dynamic>?> swipeAndChat(
    DiscoverProfile profile, {
    String? message,
  }) async {
    try {
      final response = await DiscoverService.swipeUser(profile.id, 'like');

      bool messageSent = false;
      if (message != null && message.isNotEmpty) {
        try {
          await DiscoverService.sendFirstMessage(profile.id, message);
          messageSent = true;
        } catch (_) {}
      }

      _removeProfile(profile);
      await _refreshLimits();

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        return {
          ...data,
          'message_sent': messageSent,
        };
      }
    } catch (_) {}
    return null;
  }

  void _removeProfile(DiscoverProfile profile) {
    _profiles.removeWhere((p) => p.id == profile.id);
    _safeNotify();
    if (_profiles.length <= 2 && _hasMore) {
      loadMore();
    }
  }

  Future<void> _refreshLimits() async {
    try {
      final response = await DiscoverService.getMyLimits();
      if (response.statusCode == 200) {
        final data = response.data;
        _isPremium = data['is_premium'] ?? false;
        _likesRemaining = data['likes_remaining_today'] ?? 0;
        _dailyLikesLimit = data['daily_likes_limit'] ?? 20;
        _safeNotify();
      }
    } catch (_) {}
  }

  void setGenderFilter(String? gender) {
    _genderFilter = gender;
    loadProfiles();
  }

  void setAgeRange(int min, int max) {
    _ageMin = min;
    _ageMax = max;
    loadProfiles();
  }

  void setDistance(int km) {
    _distanceKm = km;
    loadProfiles();
  }

  void refresh() {
    loadProfiles();
  }

  void clearError() {
    _errorMessage = null;
    _safeNotify();
  }
}
