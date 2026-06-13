import 'package:flutter/material.dart';

class OnboardingProvider extends ChangeNotifier {
  // Temporary storage for email/password from first screen
  String? _tempEmail;
  String? _tempPassword;
  
  // User info storage
  String? _name;
  String? _email;
  String? _password;
  int? _age;
  String? _gender;
  String? _referralCode;
  
  // Physical info
  int? _height;
  int? _weight;
  
  // Location info
  bool _useGPS = true;
  String? _province;
  String? _city;
  String? _country;
  
  // Getters
  String? get tempEmail => _tempEmail;
  String? get tempPassword => _tempPassword;
  String? get name => _name;
  String? get email => _email;
  String? get password => _password;
  int? get age => _age;
  String? get gender => _gender;
  String? get referralCode => _referralCode;
  int? get height => _height;
  int? get weight => _weight;
  bool get useGPS => _useGPS;
  String? get province => _province;
  String? get city => _city;
  String? get country => _country;
  
  void saveEmailAndPassword({required String email, required String password}) {
    _tempEmail = email;
    _tempPassword = password;
    notifyListeners();
  }
  
  void updateUserInfo({
    required String name,
    required String email,
    required String password,
    required int age,
    required String gender,
    String? referralCode,
  }) {
    _name = name;
    _email = email;
    _password = password;
    _age = age;
    _gender = gender;
    _referralCode = referralCode;
    notifyListeners();
  }
  
  void updatePhysicalInfo({required int height, required int weight}) {
    _height = height;
    _weight = weight;
    notifyListeners();
  }
  
  void updateLocation({
    required bool useGPS,
    String? province,
    String? city,
    String? country,
  }) {
    _useGPS = useGPS;
    _province = province;
    _city = city;
    _country = country ?? 'Iran';
    notifyListeners();
  }
  
  Future<bool> submitAllData() async {
    try {
      // جمع‌آوری همه داده‌ها
      final Map<String, dynamic> userData = {
        'email': _email,
        'password': _password,
        'name': _name,
        'age': _age,
        'gender': _gender,
        'referralCode': _referralCode,
        'height': _height,
        'weight': _weight,
        'useGPS': _useGPS,
        'province': _province,
        'city': _city,
        'country': _country,
      };
      
      // TODO: ارسال به API
      // final response = await ApiService.updateProfile(userData);
      
      print('Submitting user data: $userData');
      
      // شبیه‌سازی تاخیر شبکه
      await Future.delayed(const Duration(milliseconds: 500));
      
      return true;
    } catch (e) {
      print('Error submitting data: $e');
      return false;
    }
  }
  
  // متد کمکی برای دریافت تمام داده‌ها به صورت مپ
  Map<String, dynamic> getAllData() {
    return {
      'email': _email,
      'password': _password,
      'name': _name,
      'age': _age,
      'gender': _gender,
      'referralCode': _referralCode,
      'height': _height,
      'weight': _weight,
      'useGPS': _useGPS,
      'province': _province,
      'city': _city,
      'country': _country,
    };
  }
  
  void clearAll() {
    _tempEmail = null;
    _tempPassword = null;
    _name = null;
    _email = null;
    _password = null;
    _age = null;
    _gender = null;
    _referralCode = null;
    _height = null;
    _weight = null;
    _useGPS = true;
    _province = null;
    _city = null;
    _country = null;
    notifyListeners();
  }
}