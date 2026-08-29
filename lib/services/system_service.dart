// lib/services/system_service.dart
import 'package:flutter/foundation.dart';
import 'package:dating_app/services/api_service.dart';

/// Result of the backend `/system/version-check`.
class VersionCheck {
  final String status; // 'ok' | 'update_required' | 'maintenance'
  final String? message;
  final String? updateUrl;
  final bool forceUpdate;

  VersionCheck({
    required this.status,
    this.message,
    this.updateUrl,
    this.forceUpdate = false,
  });

  bool get isMaintenance => status == 'maintenance';
  bool get isUpdateRequired => status == 'update_required';
}

class SystemService {
  /// Test seam: when set, checkVersion short-circuits (no network) — used by
  /// FakeAsync-driven widget tests where a real HTTP attempt would hang.
  @visibleForTesting
  static Future<VersionCheck?> Function()? checkVersionOverride;

  /// Calls POST /system/version-check. Returns null on network/parse failure so
  /// the splash can fail-open (an outage must not block the app).
  static Future<VersionCheck?> checkVersion({
    required String platform,
    required String version,
  }) async {
    final override = checkVersionOverride;
    if (override != null) return override();
    try {
      final response = await ApiService.post(
        '/system/version-check',
        data: {'platform': platform, 'version': version},
      );
      if (response.statusCode == 200) {
        final d = response.data as Map<String, dynamic>;
        return VersionCheck(
          status: d['status'] as String? ?? 'ok',
          message: d['message'] as String?,
          updateUrl: d['update_url'] as String?,
          forceUpdate: d['force_update'] as bool? ?? false,
        );
      }
    } catch (_) {
      // fail-open
    }
    return null;
  }
}
