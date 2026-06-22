// lib/services/onboarding_service.dart
import 'package:dio/dio.dart';
import '../models/interest.dart';
import '../models/prompt.dart';
import 'api_service.dart';

class OnboardingService {
  static Future<List<Interest>> getInterests() async {
    try {
      final response = await ApiService.get('/interests');
      if (response.statusCode == 200) {
        final List data = response.data;
        return data.map((json) => Interest.fromJson(json)).toList();
      }
      return [];
    } on DioException catch (e) {
      print('❌ Error fetching interests: $e');
      return [];
    }
  }

  static Future<List<Prompt>> getPrompts() async {
    try {
      final response = await ApiService.get('/prompts');
      if (response.statusCode == 200) {
        final List data = response.data;
        return data.map((json) => Prompt.fromJson(json)).toList();
      }
      return [];
    } on DioException catch (e) {
      print('❌ Error fetching prompts: $e');
      return [];
    }
  }
}