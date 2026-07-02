// lib/providers/profile_provider.dart
import 'package:flutter/material.dart';
import 'package:dating_app/models/photo.dart';
import 'package:dating_app/models/profile_stats.dart';
import 'package:dating_app/services/photo_service.dart';

class ProfileProvider extends ChangeNotifier {
  List<PhotoResponse> _photos = [];
  ProfileStats? _stats;
  bool _isLoading = false;
  bool _isInitialized = false;
  String? _error;

  // Getters
  List<PhotoResponse> get photos => _photos;
  ProfileStats? get stats => _stats;
  bool get isLoading => _isLoading;
  bool get isInitialized => _isInitialized;
  String? get error => _error;

  PhotoResponse? get mainPhoto {
    try {
      return _photos.firstWhere((p) => p.isMain);
    } catch (e) {
      return _photos.isNotEmpty ? _photos.first : null;
    }
  }

  List<PhotoResponse> get otherPhotos {
    return _photos.where((p) => !p.isMain).toList();
  }

  // Load photos
  Future<void> loadPhotos() async {
    if (_isLoading) return;
    _setLoading(true);
    _error = null;

    try {
      print('📸 Loading photos...');
      final photos = await PhotoService.getMyPhotos();
      print('📸 Photos loaded: ${photos.length}');
      _photos = photos;
      _isInitialized = true;
    } catch (e) {
      print('❌ Failed to load photos: $e');
      _error = 'Failed to load photos';
    } finally {
      _setLoading(false);
    }
  }

  // Load stats
  Future<void> loadStats() async {
    try {
      // TODO: Replace with actual API call when available
      _stats = ProfileStats(
        likesSent: 0,
        matches: 0,
        messages: 0,
        likesRemainingToday: 10,
      );
      notifyListeners();
    } catch (e) {
      // Handle error
    }
  }

  void addPhotoFromUpload(PhotoResponse photo) {
    _photos.add(photo);
    notifyListeners();
  }

  void removePhotoById(String id) {
    _photos.removeWhere((p) => p.id == id);
    notifyListeners();
  }

  void setMainPhotoById(String id) {
    for (var photo in _photos) {
      photo.isMain = (photo.id == id);
    }
    notifyListeners();
  }

  void updatePhotoOrder(List<PhotoResponse> reordered) {
    _photos = reordered;
    notifyListeners();
  }

  // Refresh all data
  Future<void> refreshData() async {
    print('🔄 Refreshing profile data...');
    await Future.wait([
      loadPhotos(),
      loadStats(),
    ]);
    print('✅ Profile data refreshed');
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void clear() {
    _photos = [];
    _stats = null;
    _error = null;
    _isLoading = false;
    _isInitialized = false;
    notifyListeners();
  }
}