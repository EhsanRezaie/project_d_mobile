// lib/services/photo_service.dart
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dating_app/services/api_service.dart';
import 'package:dating_app/models/photo.dart';

class PhotoService {
  static final Dio _dio = ApiService.dio;

  // ============================================================================
  // Upload Photo
  // ============================================================================

  static Future<PhotoUploadResponse?> uploadPhoto(File file) async {
    try {
      // Debug: Print file info
      print('📸 Uploading photo: ${file.path}');
      print('📸 File size: ${file.lengthSync()} bytes');
      print('📸 File extension: ${file.path.split('.').last}');

      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          file.path,
          filename: 'photo_${DateTime.now().millisecondsSinceEpoch}.jpg',
        ),
      });

      final response = await _dio.post(
        '/users/me/photos',
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      print('✅ Photo uploaded successfully');
      return PhotoUploadResponse.fromJson(response.data);
    } on DioException catch (e) {
      // Detailed error logging
      print('❌ Upload photo error:');
      print('   Status code: ${e.response?.statusCode}');
      print('   Response data: ${e.response?.data}');
      print('   Error message: ${e.message}');
      
      // Try to extract the actual error message from response
      if (e.response?.data != null) {
        final data = e.response?.data;
        if (data is Map<String, dynamic>) {
          print('   Detail: ${data['detail']}');
        }
      }
      return null;
    } catch (e) {
      print('❌ Upload photo error: $e');
      return null;
    }
  }

  // ============================================================================
  // Get My Photos
  // ============================================================================

  static Future<List<PhotoResponse>> getMyPhotos() async {
    try {
      final response = await _dio.get('/users/me/photos');
      return (response.data as List)
          .map((json) => PhotoResponse.fromJson(json))
          .toList();
    } catch (e) {
      print('❌ Get photos error: $e');
      return [];
    }
  }

  // ============================================================================
  // Delete Photo
  // ============================================================================

  static Future<bool> deletePhoto(String photoId) async {
    try {
      await _dio.delete('/users/me/photos/$photoId');
      return true;
    } catch (e) {
      print('❌ Delete photo error: $e');
      return false;
    }
  }

  // ============================================================================
  // Set Main Photo
  // ============================================================================

  static Future<PhotoResponse?> setMainPhoto(String photoId) async {
    try {
      final response = await _dio.put('/users/me/photos/$photoId/main');
      return PhotoResponse.fromJson(response.data);
    } catch (e) {
      print('❌ Set main photo error: $e');
      return null;
    }
  }

  // ============================================================================
  // Upload Multiple Photos
  // ============================================================================

  static Future<List<PhotoUploadResponse>> uploadMultiplePhotos(
    List<File> files,
    Function(int, int) onProgress,
  ) async {
    final results = <PhotoUploadResponse>[];
    int uploaded = 0;

    for (final file in files) {
      final result = await uploadPhoto(file);
      if (result != null) {
        results.add(result);
      }
      uploaded++;
      onProgress(uploaded, files.length);
    }

    return results;
  }

  // ============================================================================
  // Reorder Photos
  // ============================================================================

  static Future<bool> reorderPhotos(Map<String, int> orders) async {
    try {
      await _dio.patch(
        '/users/me/photos/order',
        data: {'orders': orders},
      );
      return true;
    } catch (e) {
      print('❌ Reorder photos error: $e');
      return false;
    }
  }

  // ============================================================================
  // Validate Image Before Upload
  // ============================================================================

  static String? validateImage(File file) {
    // Check if file exists
    if (!file.existsSync()) {
      return 'File does not exist';
    }

    // Check file size (max 5MB)
    final sizeInBytes = file.lengthSync();
    const maxSize = 5 * 1024 * 1024; // 5MB
    if (sizeInBytes > maxSize) {
      return 'Image too large. Max 5MB';
    }

    // Check file extension
    final extension = file.path.split('.').last.toLowerCase();
    const allowedExtensions = ['jpg', 'jpeg', 'png', 'webp', 'heic', 'heif'];
    if (!allowedExtensions.contains(extension)) {
      return 'Invalid format. Allowed: JPG, PNG, WEBP';
    }

    // Check if file is empty
    if (sizeInBytes == 0) {
      return 'File is empty';
    }

    return null;
  }

  // ============================================================================
  // Convert Image to JPEG (if needed)
  // ============================================================================

  static Future<File> convertToJpeg(File file) async {
    final extension = file.path.split('.').last.toLowerCase();
    if (['jpg', 'jpeg'].contains(extension)) {
      return file;
    }

    try {
      // For now, just return the file as-is
      // The backend can handle PNG/WebP/HEIC
      print('📸 Converting $extension to JPEG...');
      return file;
    } catch (e) {
      print('❌ Error converting to JPEG: $e');
      return file;
    }
  }
}