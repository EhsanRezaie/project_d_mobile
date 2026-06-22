import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dating_app/generated/app_localizations.dart';
import '../../config/app_theme.dart';
import '../../providers/onboarding_provider.dart';
import '../../services/location_service.dart';
import 'profile_details_screen.dart';

class BasicInfoScreen extends StatefulWidget {
  const BasicInfoScreen({super.key});

  @override
  State<BasicInfoScreen> createState() => _BasicInfoScreenState();
}

class _BasicInfoScreenState extends State<BasicInfoScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  DateTime? _selectedBirthDate;
  String? _selectedGender;
  String? _selectedCountry;
  String? _selectedProvince;
  String? _selectedCity;

  double? _lat;
  double? _lng;
  final bool _isLoading = false;
  bool _isLoadingLocation = false;
  String? _errorMessage;

  List<String> _countries = [];
  List<String> _provinces = [];
  List<String> _cities = [];

  @override
  void initState() {
    super.initState();
    _loadSavedData();
    _loadCountries();
  }

  void _loadSavedData() {
    final onboarding = Provider.of<OnboardingProvider>(context, listen: false);
    if (onboarding.name != null) _nameController.text = onboarding.name!;
    if (onboarding.bio != null) _bioController.text = onboarding.bio!;
    if (onboarding.gender != null) _selectedGender = onboarding.gender;
    if (onboarding.birthDate != null) {
      try {
        _selectedBirthDate = DateTime.parse(onboarding.birthDate!);
        _birthDateController.text = onboarding.birthDate!;
      } catch (_) {}
    }
    if (onboarding.country != null) {
      _selectedCountry = onboarding.country;
      _loadProvinces(onboarding.country!);
    }
    if (onboarding.province != null) {
      _selectedProvince = onboarding.province;
      _loadCities(onboarding.province!);
    }
    if (onboarding.city != null) _selectedCity = onboarding.city;
    if (onboarding.lat != null) _lat = onboarding.lat;
    if (onboarding.lng != null) _lng = onboarding.lng;
  }

  void _loadCountries() {
    _countries = ['Iran', 'Turkey', 'UAE', 'Iraq', 'Afghanistan'];
  }

  void _loadProvinces(String country) {
    if (country == 'Iran') {
      _provinces = [
        'Tehran',
        'Isfahan',
        'Shiraz',
        'Mashhad',
        'Tabriz',
        'Rasht',
        'Ahvaz',
        'Kermanshah',
        'Qom',
        'Urmia'
      ];
    } else {
      _provinces = [];
    }
    _selectedProvince = null;
    _selectedCity = null;
  }

  void _loadCities(String province) {
    final Map<String, List<String>> cityMap = {
      'Tehran': ['Tehran', 'Karaj', 'Shahriar'],
      'Isfahan': ['Isfahan', 'Kashan', 'Najafabad'],
      'Shiraz': ['Shiraz', 'Marvdasht', 'Kazerun'],
    };
    _cities = cityMap[province] ?? [];
    _selectedCity = null;
  }

  Future<void> _selectBirthDate() async {
    final now = DateTime.now();
    final initialDate = DateTime(now.year - 18, now.month, now.day);
    final firstDate = DateTime(now.year - 100);
    final lastDate = DateTime(now.year - 18, now.month, now.day);

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedBirthDate ?? initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (context, child) {
        final isDark = context.isDarkMode;
        return Theme(
          data: isDark ? ThemeData.dark() : ThemeData.light(),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        _selectedBirthDate = pickedDate;
        _birthDateController.text =
            '${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}';
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoadingLocation = true;
      _errorMessage = null;
    });

    final location = await LocationService.getCurrentLocation();
    if (location != null) {
      setState(() {
        _lat = location['lat'];
        _lng = location['lng'];
        _selectedCountry = location['country'];
        if (_selectedCountry != null) {
          _loadProvinces(_selectedCountry!);
          _selectedProvince = location['province'];
          if (_selectedProvince != null) {
            _loadCities(_selectedProvince!);
            _selectedCity = location['city'];
          }
        }
      });
    } else {
      setState(() {
        _errorMessage = 'Could not get location. Please select manually.';
      });
    }

    setState(() => _isLoadingLocation = false);
  }

  void _onCountryChanged(String? value) {
    setState(() {
      _selectedCountry = value;
      _selectedProvince = null;
      _selectedCity = null;
      if (value != null) _loadProvinces(value);
    });
  }

  void _onProvinceChanged(String? value) {
    setState(() {
      _selectedProvince = value;
      _selectedCity = null;
      if (value != null) _loadCities(value);
    });
  }

  void _onCityChanged(String? value) {
    setState(() {
      _selectedCity = value;
      if (_selectedProvince != null && value != null) {
        final coords = LocationService.estimateLatLng(value, _selectedProvince!);
        _lat = coords['lat'];
        _lng = coords['lng'];
      }
    });
  }

  Future<void> _handleNext() async {
    if (!_formKey.currentState!.validate()) return;

    final name = _nameController.text.trim();
    final gender = _selectedGender;
    final bio = _bioController.text.trim();

    if (gender == null) {
      setState(() => _errorMessage = 'Please select your gender');
      return;
    }

    if (_selectedCountry == null || _selectedProvince == null || _selectedCity == null) {
      setState(() => _errorMessage = 'Please select your location');
      return;
    }

    final onboarding = Provider.of<OnboardingProvider>(context, listen: false);

    onboarding.setPersonalInfo(
      name: name,
      birthDate: _birthDateController.text,
      gender: gender,
      bio: bio.isNotEmpty ? bio : null,
    );

    onboarding.setLocation(
      lat: _lat ?? 0.0,
      lng: _lng ?? 0.0,
      country: _selectedCountry,
      province: _selectedProvince,
      city: _selectedCity,
    );

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ProfileDetailsScreen()),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _birthDateController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;
    final isDark = context.isDarkMode;
    final primaryColor = isDark ? AppTheme.darkPrimary : AppTheme.lightPrimary;
    final bgColor = isDark ? AppTheme.darkBackground : AppTheme.lightBackground;
    final surfaceColor = isDark ? AppTheme.darkSurface : AppTheme.lightSurface;
    final borderColor = isDark ? AppTheme.darkBorder : AppTheme.lightBorder;
    final textMutedColor = isDark ? AppTheme.darkTextMuted : AppTheme.lightTextMuted;
    final onSurfaceColor = colors.onSurface;
    final errorColor = AppTheme.lightError;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 80,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return Expanded(
                    child: Container(
                      height: 4,
                      margin: const EdgeInsets.symmetric(horizontal: 2.0),
                      decoration: BoxDecoration(
                        color: index == 0
                            ? primaryColor
                            : (isDark ? Colors.white12 : Colors.black12),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 14),
              Text(
                'Basic Info',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: onSurfaceColor,
                  letterSpacing: -0.4,
                ),
              ),
            ],
          ),
        ),
        centerTitle: true,
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                    sliver: SliverToBoxAdapter(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tell us about yourself',
                              style: AppTheme.headlineMedium.copyWith(
                                color: onSurfaceColor,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'This information will be shown on your profile',
                              style: AppTheme.bodyLarge.copyWith(
                                color: textMutedColor,
                              ),
                            ),
                            const SizedBox(height: 28),
                            if (_errorMessage != null) ...[
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                decoration: BoxDecoration(
                                  color: errorColor.withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: errorColor.withOpacity(0.2)),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.error_outline, color: errorColor, size: 20),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        _errorMessage!,
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 14,
                                          color: errorColor,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],
                            TextFormField(
                              controller: _nameController,
                              textInputAction: TextInputAction.next,
                              style: AppTheme.bodyLarge.copyWith(color: onSurfaceColor),
                              decoration: InputDecoration(
                                labelText: 'Full Name',
                                hintText: 'Enter your full name',
                                prefixIcon: Icon(Icons.person_outline, color: textMutedColor, size: 22),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your name';
                                }
                                if (value.length < 2) {
                                  return 'Name must be at least 2 characters';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: _birthDateController,
                              readOnly: true,
                              onTap: _selectBirthDate,
                              style: AppTheme.bodyLarge.copyWith(color: onSurfaceColor),
                              decoration: InputDecoration(
                                labelText: 'Date of Birth',
                                hintText: 'Select your birth date',
                                prefixIcon: Icon(Icons.cake_outlined, color: textMutedColor, size: 22),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select your birth date';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 24),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 4.0),
                                  child: Text(
                                    'Gender',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: onSurfaceColor,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _GenderOption(
                                        label: 'Male',
                                        icon: Icons.male,
                                        isSelected: _selectedGender == 'male',
                                        onTap: () {
                                          setState(() {
                                            _selectedGender = 'male';
                                            _errorMessage = null;
                                          });
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: _GenderOption(
                                        label: 'Female',
                                        icon: Icons.female,
                                        isSelected: _selectedGender == 'female',
                                        onTap: () {
                                          setState(() {
                                            _selectedGender = 'female';
                                            _errorMessage = null;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            TextFormField(
                              controller: _bioController,
                              maxLines: 3,
                              maxLength: 500,
                              style: AppTheme.bodyLarge.copyWith(color: onSurfaceColor),
                              decoration: InputDecoration(
                                labelText: 'Bio (optional)',
                                hintText: 'Tell others a bit about yourself...',
                                alignLabelWithHint: true,
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.only(bottom: 40.0),
                                  child: Icon(Icons.notes, color: textMutedColor, size: 22),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 4.0),
                                      child: Text(
                                        'Location',
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: onSurfaceColor,
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    TextButton.icon(
                                      onPressed: _isLoadingLocation ? null : _getCurrentLocation,
                                      style: TextButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                        backgroundColor: primaryColor.withOpacity(0.06),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                      ),
                                      icon: _isLoadingLocation
                                          ? SizedBox(
                                              height: 14,
                                              width: 14,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                color: primaryColor,
                                              ),
                                            )
                                          : Icon(Icons.my_location, color: primaryColor, size: 14),
                                      label: Text(
                                        _isLoadingLocation ? 'Locating...' : 'GPS',
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          color: primaryColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                DropdownButtonFormField<String>(
                                  value: _selectedCountry,
                                  isExpanded: true,
                                  decoration: InputDecoration(
                                    labelText: 'Country',
                                    prefixIcon: Icon(Icons.public, color: textMutedColor, size: 22),
                                  ),
                                  items: _countries.map((country) {
                                    return DropdownMenuItem(value: country, child: Text(country));
                                  }).toList(),
                                  onChanged: _onCountryChanged,
                                  validator: (value) => value == null ? 'Please select your country' : null,
                                ),
                                const SizedBox(height: 16),
                                DropdownButtonFormField<String>(
                                  value: _selectedProvince,
                                  isExpanded: true,
                                  decoration: InputDecoration(
                                    labelText: 'Province',
                                    prefixIcon: Icon(Icons.map_outlined, color: textMutedColor, size: 22),
                                  ),
                                  items: _provinces.map((province) {
                                    return DropdownMenuItem(value: province, child: Text(province));
                                  }).toList(),
                                  onChanged: _onProvinceChanged,
                                  validator: (value) => value == null ? 'Please select your province' : null,
                                ),
                                const SizedBox(height: 16),
                                DropdownButtonFormField<String>(
                                  value: _selectedCity,
                                  isExpanded: true,
                                  decoration: InputDecoration(
                                    labelText: 'City',
                                    prefixIcon: Icon(Icons.location_city_outlined, color: textMutedColor, size: 22),
                                  ),
                                  items: _cities.map((city) {
                                    return DropdownMenuItem(value: city, child: Text(city));
                                  }).toList(),
                                  onChanged: _onCityChanged,
                                  validator: (value) => value == null ? 'Please select your city' : null,
                                ),
                              ],
                            ),
                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      padding: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 24.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _handleNext,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            elevation: 0,
                            minimumSize: const Size(double.infinity, 56),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                )
                              : Text('Continue', style: AppTheme.buttonText),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _GenderOption extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _GenderOption({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final primaryColor = isDark ? AppTheme.darkPrimary : AppTheme.lightPrimary;
    final surfaceColor = isDark ? AppTheme.darkSurface : AppTheme.lightSurface;
    final borderColor = isDark ? AppTheme.darkBorder : AppTheme.lightBorder;
    final onSurfaceColor = Theme.of(context).colorScheme.onSurface;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor.withOpacity(0.06) : surfaceColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? primaryColor : borderColor,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [BoxShadow(color: primaryColor.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? primaryColor : onSurfaceColor.withOpacity(0.6),
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 15,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? primaryColor : onSurfaceColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}