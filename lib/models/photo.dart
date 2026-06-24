// lib/models/photo.dart
import 'dart:io';

class PhotoUpload {
  final String id;
  final File file;
  bool isMain;
  bool isUploaded;
  String? url;
  String? serverId;

  PhotoUpload({
    required this.id,
    required this.file,
    this.isMain = false,
    this.isUploaded = false,
    this.url,
    this.serverId,
  });

  PhotoUpload copyWith({
    String? id,
    File? file,
    bool? isMain,
    bool? isUploaded,
    String? url,
    String? serverId,
  }) {
    return PhotoUpload(
      id: id ?? this.id,
      file: file ?? this.file,
      isMain: isMain ?? this.isMain,
      isUploaded: isUploaded ?? this.isUploaded,
      url: url ?? this.url,
      serverId: serverId ?? this.serverId,
    );
  }
}

class PhotoResponse {
  final String id;
  final String userId;
  final String url;
  final int order;
  final bool isMain;
  final String status;
  final String? rejectReason;
  final bool faceVerified;

  PhotoResponse({
    required this.id,
    required this.userId,
    required this.url,
    required this.order,
    required this.isMain,
    required this.status,
    this.rejectReason,
    required this.faceVerified,
  });

  factory PhotoResponse.fromJson(Map<String, dynamic> json) {
    return PhotoResponse(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      url: json['url'] ?? '',
      order: json['order'] ?? 0,
      isMain: json['is_main'] ?? false,
      status: json['status'] ?? 'pending',
      rejectReason: json['reject_reason'],
      faceVerified: json['face_verified'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'url': url,
      'order': order,
      'is_main': isMain,
      'status': status,
      'reject_reason': rejectReason,
      'face_verified': faceVerified,
    };
  }
}

class PhotoUploadResponse {
  final String id;
  final String url;
  final String status;
  final String message;

  PhotoUploadResponse({
    required this.id,
    required this.url,
    required this.status,
    required this.message,
  });

  factory PhotoUploadResponse.fromJson(Map<String, dynamic> json) {
    return PhotoUploadResponse(
      id: json['id'] ?? '',
      url: json['url'] ?? '',
      status: json['status'] ?? 'pending',
      message: json['message'] ?? 'Photo uploaded. Under review by admin.',
    );
  }
}