// lib/services/onboarding_service.dart
import 'package:flutter/foundation.dart';
import 'package:dating_app/services/api_service.dart';
import 'package:dating_app/services/interest_localizer.dart';
import 'package:dating_app/models/interest.dart';
import 'package:dating_app/models/prompt.dart';

class OnboardingService {
  // ============================================================================
  // Get Interests
  // ============================================================================

  static Future<List<Interest>> getInterests({String? language}) async {
    try {
      final queryParams = <String, String>{};
      if (language != null && language.isNotEmpty) {
        queryParams['language'] = language;
      }
      final response = await ApiService.dio.get(
        '/interests',
        queryParameters: queryParams,
      );
      final interests = (response.data as List)
          .map((json) => Interest.fromJson(json))
          .toList();
      // Cache localized labels so profile badges render in the viewer's language.
      InterestLocalizer.instance.load(interests, language: language ?? 'en');
      return interests;
    } catch (e) {
      debugPrint('❌ Get interests error: $e');
      return [];
    }
  }

  // ============================================================================
  // Get Prompts (with language support)
  // ============================================================================

  static Future<List<Prompt>> getPrompts({String? language}) async {
    try {
      final queryParams = <String, String>{};
      if (language != null && language.isNotEmpty) {
        queryParams['language'] = language;
      }

      final response = await ApiService.dio.get(
        '/prompts',
        queryParameters: queryParams,
      );
      return (response.data as List)
          .map((json) => Prompt.fromJson(json))
          .toList();
    } catch (e) {
      debugPrint('❌ Get prompts error: $e');
      return [];
    }
  }
}