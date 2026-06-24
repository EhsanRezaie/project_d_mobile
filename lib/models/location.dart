// lib/models/location_models.dart

class CountryResponse {
  final String iso2;
  final String iso3;
  final String name;
  final double? latitude;
  final double? longitude;

  CountryResponse({
    required this.iso2,
    required this.iso3,
    required this.name,
    this.latitude,
    this.longitude,
  });

  factory CountryResponse.fromJson(Map<String, dynamic> json) {
    return CountryResponse(
      iso2: json['iso2'] ?? '',
      iso3: json['iso3'] ?? '',
      name: json['name'] ?? '',
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
    );
  }
}

class ProvinceResponse {
  final String code;
  final String isoCode;
  final String name;
  final String type;

  ProvinceResponse({
    required this.code,
    required this.isoCode,
    required this.name,
    required this.type,
  });

  factory ProvinceResponse.fromJson(Map<String, dynamic> json) {
    return ProvinceResponse(
      code: json['code'] ?? '',
      isoCode: json['iso_code'] ?? '',
      name: json['name'] ?? '',
      type: json['type'] ?? '',
    );
  }
}

class CityResponse {
  final String name;
  final String? province;
  final double? latitude;
  final double? longitude;
  final int? population;

  CityResponse({
    required this.name,
    this.province,
    this.latitude,
    this.longitude,
    this.population,
  });

  factory CityResponse.fromJson(Map<String, dynamic> json) {
    return CityResponse(
      name: json['name'] ?? '',
      province: json['province'],
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      population: json['population'],
    );
  }
}

class ReverseGeocodeResponse {
  final String? country;
  final String? countryIso2;
  final String? province;
  final String? city;

  ReverseGeocodeResponse({
    this.country,
    this.countryIso2,
    this.province,
    this.city,
  });

  factory ReverseGeocodeResponse.fromJson(Map<String, dynamic> json) {
    return ReverseGeocodeResponse(
      country: json['country'],
      countryIso2: json['country_iso2'],
      province: json['province'],
      city: json['city'],
    );
  }
}