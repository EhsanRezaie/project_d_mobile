import 'package:flutter/material.dart';

class OnboardingProvider extends ChangeNotifier {
  // Step 1: Email & Password (already passed from SignUp)
  String? _email;
  String? _password;

  // Step 2: Personal Info
  String? _name;
  String? _birthDate;
  String? _gender;
  String? _sexualOrientation;
  String? _bio;

  // Step 3: Physical & Lifestyle
  int? _height;
  int? _weight;
  String? _bodyType;
  String? _relationshipStatus;
  String? _livingSituation;
  String? _childrenStatus;
  String? _smoking;
  String? _drinking;
  String? _education;
  String? _workplace;
  String? _religion;
  String? _ethnicity;
  String? _politicalOrientation;

  // Step 4: Location
  double? _lat;
  double? _lng;
  String? _country;
  String? _province;
  String? _city;

  // Step 5: Interests & Prompts
  List<String>? _interests;
  List<Map<String, dynamic>>? _prompts;

  // Getters
  String? get email => _email;
  String? get password => _password;
  String? get name => _name;
  String? get birthDate => _birthDate;
  String? get gender => _gender;
  String? get sexualOrientation => _sexualOrientation;
  String? get bio => _bio;
  int? get height => _height;
  int? get weight => _weight;
  String? get bodyType => _bodyType;
  String? get relationshipStatus => _relationshipStatus;
  String? get livingSituation => _livingSituation;
  String? get childrenStatus => _childrenStatus;
  String? get smoking => _smoking;
  String? get drinking => _drinking;
  String? get education => _education;
  String? get workplace => _workplace;
  String? get religion => _religion;
  String? get ethnicity => _ethnicity;
  String? get politicalOrientation => _politicalOrientation;
  double? get lat => _lat;
  double? get lng => _lng;
  String? get country => _country;
  String? get province => _province;
  String? get city => _city;
  List<String>? get interests => _interests;
  List<Map<String, dynamic>>? get prompts => _prompts;

  bool get hasEmail => _email != null && _email!.isNotEmpty;

  // ============================================================
  // Set from SignUp (called after successful verify)
  // ============================================================
  void setEmailAndPassword(String email, String password) {
    _email = email;
    _password = password;
    notifyListeners();
  }

  // ============================================================
  // Step 2: Personal Info
  // ============================================================
  void setPersonalInfo({
    required String name,
    required String birthDate,
    required String gender,
    String? sexualOrientation,
    String? bio,
  }) {
    _name = name;
    _birthDate = birthDate;
    _gender = gender;
    _sexualOrientation = sexualOrientation;
    _bio = bio;
    notifyListeners();
  }

  // ============================================================
  // Step 3: Physical & Lifestyle
  // ============================================================
  void setPhysicalAndLifestyle({
    int? height,
    int? weight,
    String? bodyType,
    String? relationshipStatus,
    String? livingSituation,
    String? childrenStatus,
    String? smoking,
    String? drinking,
    String? education,
    String? workplace,
    String? religion,
    String? ethnicity,
    String? politicalOrientation,
  }) {
    _height = height;
    _weight = weight;
    _bodyType = bodyType;
    _relationshipStatus = relationshipStatus;
    _livingSituation = livingSituation;
    _childrenStatus = childrenStatus;
    _smoking = smoking;
    _drinking = drinking;
    _education = education;
    _workplace = workplace;
    _religion = religion;
    _ethnicity = ethnicity;
    _politicalOrientation = politicalOrientation;
    notifyListeners();
  }

  // ============================================================
  // Step 4: Location
  // ============================================================
  void setLocation({
    required double lat,
    required double lng,
    String? country,
    String? province,
    String? city,
  }) {
    _lat = lat;
    _lng = lng;
    _country = country;
    _province = province;
    _city = city;
    notifyListeners();
  }

  // ============================================================
  // Step 5: Interests & Prompts
  // ============================================================
  void setInterests(List<String> interests) {
    _interests = interests;
    notifyListeners();
  }

  void setPrompts(List<Map<String, dynamic>> prompts) {
    _prompts = prompts;
    notifyListeners();
  }

  void addInterest(String interest) {
    if (_interests == null) {
      _interests = [];
    }
    if (!_interests!.contains(interest)) {
      _interests!.add(interest);
      notifyListeners();
    }
  }

  void removeInterest(String interest) {
    if (_interests != null) {
      _interests!.remove(interest);
      notifyListeners();
    }
  }

  // ============================================================
  // Build complete request for /auth/register/complete
  // ============================================================
  Map<String, dynamic> buildCompleteRequest() {
    return {
      'name': _name,
      'birth_date': _birthDate,
      'gender': _gender,
      if (_sexualOrientation != null) 'sexual_orientation': _sexualOrientation,
      if (_bio != null) 'bio': _bio,
      if (_height != null) 'height': _height,
      if (_weight != null) 'weight': _weight,
      if (_bodyType != null) 'body_type': _bodyType,
      if (_relationshipStatus != null) 'relationship_status': _relationshipStatus,
      if (_livingSituation != null) 'living_situation': _livingSituation,
      if (_childrenStatus != null) 'children_status': _childrenStatus,
      if (_smoking != null) 'smoking': _smoking,
      if (_drinking != null) 'drinking': _drinking,
      if (_education != null) 'education': _education,
      if (_workplace != null) 'workplace': _workplace,
      if (_religion != null) 'religion': _religion,
      if (_ethnicity != null) 'ethnicity': _ethnicity,
      if (_politicalOrientation != null) 'political_orientation': _politicalOrientation,
      'lat': _lat ?? 0.0,
      'lng': _lng ?? 0.0,
      if (_country != null) 'country': _country,
      if (_province != null) 'province': _province,
      if (_city != null) 'city': _city,
      if (_interests != null && _interests!.isNotEmpty) 'interests': _interests,
      if (_prompts != null && _prompts!.isNotEmpty) 'prompts': _prompts,
    };
  }

  // ============================================================
  // Check if all required fields are filled
  // ============================================================
  bool get isComplete {
    return _name != null &&
        _name!.isNotEmpty &&
        _birthDate != null &&
        _birthDate!.isNotEmpty &&
        _gender != null &&
        _gender!.isNotEmpty &&
        _lat != null &&
        _lng != null;
  }

  // ============================================================
  // Reset all data
  // ============================================================
  void clear() {
    _email = null;
    _password = null;
    _name = null;
    _birthDate = null;
    _gender = null;
    _sexualOrientation = null;
    _bio = null;
    _height = null;
    _weight = null;
    _bodyType = null;
    _relationshipStatus = null;
    _livingSituation = null;
    _childrenStatus = null;
    _smoking = null;
    _drinking = null;
    _education = null;
    _workplace = null;
    _religion = null;
    _ethnicity = null;
    _politicalOrientation = null;
    _lat = null;
    _lng = null;
    _country = null;
    _province = null;
    _city = null;
    _interests = null;
    _prompts = null;
    notifyListeners();
  }
}