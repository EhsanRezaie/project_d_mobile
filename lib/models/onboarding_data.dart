// lib/models/onboarding_data.dart
class OnboardingData {
  String? name;
  String? email;
  String? password;
  int? age;
  String? gender;
  String? referralCode;
  
  int? height;
  int? weight;
  
  List<String>? photoPaths;
  String? mainPhotoPath;
  
  bool useGPS = true;
  String? country;
  String? province;
  String? city;
  double? lat;
  double? lng;

  OnboardingData();

  Map<String, dynamic> toUserUpdateJson() {
    return {
      if (name != null) 'name': name,
      if (age != null) 'age': age,
      if (gender != null) 'gender': gender,
      if (height != null) 'height': height,
      if (weight != null) 'weight': weight,
    };
  }
}