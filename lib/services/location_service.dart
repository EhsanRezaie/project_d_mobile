// lib/services/location_service.dart
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LocationService {
  static Future<bool> requestPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always;
  }

  static Future<Map<String, dynamic>?> getCurrentLocation() async {
    try {
      final hasPermission = await requestPermission();
      if (!hasPermission) return null;

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );

      // ✅ Get location details from API
      final locationData = await _getLocationDetailsFromCoordinates(
        position.latitude,
        position.longitude,
      );

      return {
        'lat': position.latitude,
        'lng': position.longitude,
        'country': locationData?['country'],
        'province': locationData?['province'],
        'city': locationData?['city'],
      };
    } catch (e) {
      print('❌ Location error: $e');
      return null;
    }
  }

  // ✅ Use OpenStreetMap API (no Placemark type)
  static Future<Map<String, String>?> _getLocationDetailsFromCoordinates(
    double lat,
    double lng,
  ) async {
    try {
      final url = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?format=json&lat=$lat&lon=$lng&zoom=18&addressdetails=1',
      );
      
      final response = await http.get(
        url,
        headers: {'User-Agent': 'DatingApp/1.0'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final address = data['address'] ?? {};
        
        return {
          'country': address['country'] ?? '',
          'province': address['state'] ?? address['province'] ?? '',
          'city': address['city'] ?? address['town'] ?? address['village'] ?? address['county'] ?? '',
        };
      }
    } catch (e) {
      print('❌ Reverse geocoding error: $e');
    }
    return null;
  }

  static Map<String, double> estimateLatLng(String city, String province) {
    final Map<String, Map<String, double>> cityCoordinates = {
      'tehran': {'lat': 35.6892, 'lng': 51.3890},
      'isfahan': {'lat': 32.6546, 'lng': 51.6680},
      'shiraz': {'lat': 29.5918, 'lng': 52.5837},
      'mashhad': {'lat': 36.2605, 'lng': 59.6168},
      'tabriz': {'lat': 38.0800, 'lng': 46.2919},
      'rasht': {'lat': 37.2808, 'lng': 49.5832},
      'ahvaz': {'lat': 31.3183, 'lng': 48.6706},
      'kermanshah': {'lat': 34.3277, 'lng': 47.0778},
      'qom': {'lat': 34.6416, 'lng': 50.8748},
      'urmia': {'lat': 37.5527, 'lng': 45.0761},
    };

    final cityKey = city.toLowerCase().trim();
    if (cityCoordinates.containsKey(cityKey)) {
      return cityCoordinates[cityKey]!;
    }

    return {'lat': 35.6892, 'lng': 51.3890};
  }
}