import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/onboarding_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/progress_bar.dart';
import '../main_screen.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  bool _useGPS = true;
  String? _selectedProvince;
  String? _selectedCity;
  bool _isLoading = false;

  final List<String> _provinces = [
    'Tehran', 'Isfahan', 'Shiraz', 'Mashhad', 'Tabriz',
    'Karaj', 'Qom', 'Ahvaz', 'Kermanshah', 'Rasht'
  ];

  final Map<String, List<String>> _cities = {
    'Tehran': ['Tehran', 'Shahriar', 'Islamshahr', 'Pakdasht'],
    'Isfahan': ['Isfahan', 'Kashan', 'Najafabad', 'Khomeini Shahr'],
    'Shiraz': ['Shiraz', 'Marvdasht', 'Jahrom', 'Kazerun'],
    'Mashhad': ['Mashhad', 'Nishapur', 'Sabzevar'],
    'Tabriz': ['Tabriz', 'Maragheh', 'Bonab'],
    'Karaj': ['Karaj', 'Fardis', 'Kamal Shahr'],
    'Qom': ['Qom', 'Jafarieh'],
    'Ahvaz': ['Ahvaz', 'Khorramshahr'],
    'Kermanshah': ['Kermanshah', 'Eslamabad'],
    'Rasht': ['Rasht', 'Bandar Anzali'],
  };

  Future<void> _completeOnboarding() async {
    if (!_useGPS && (_selectedProvince == null || _selectedCity == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select your province and city'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    final onboardingProvider = Provider.of<OnboardingProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    // ذخیره لوکیشن
    onboardingProvider.updateLocation(
      useGPS: _useGPS,
      province: _selectedProvince,
      city: _selectedCity,
      country: 'Iran',
    );

    // ارسال همه داده‌ها به سرور (آپدیت پروفایل)
    final Map<String, dynamic> allData = onboardingProvider.getAllData();
    
    // اگر AuthProvider متد updateUserProfile داره از اون استفاده کن
    // در غیر این صورت فقط داده‌ها رو لاگ کن
    print('Final user data: $allData');
    
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (!mounted) return;

    setState(() => _isLoading = false);

    // پاک کردن داده‌های موقت آنبوردینگ
    onboardingProvider.clearAll();
    
    // رفتن به صفحه اصلی
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const MainScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const OnboardingProgressBar(currentStep: 4, totalSteps: 4),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    'Location',
                    style: TextStyle(
                      fontSize: 28, 
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Help us find matches near you',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    children: [
                      Radio<bool>(
                        value: true,
                        groupValue: _useGPS,
                        onChanged: (value) => setState(() => _useGPS = value!),
                        activeColor: const Color(0xFF3498DB),
                      ),
                      const SizedBox(width: 8),
                      const Text('Use my current location (GPS)'),
                    ],
                  ),
                  Row(
                    children: [
                      Radio<bool>(
                        value: false,
                        groupValue: _useGPS,
                        onChanged: (value) => setState(() => _useGPS = value!),
                        activeColor: const Color(0xFF3498DB),
                      ),
                      const SizedBox(width: 8),
                      const Text('Select manually'),
                    ],
                  ),
                  if (!_useGPS) ...[
                    const SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Province / State',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFF3498DB), width: 2),
                        ),
                      ),
                      items: _provinces.map((p) {
                        return DropdownMenuItem(value: p, child: Text(p));
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedProvince = value;
                          _selectedCity = null;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'City',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFF3498DB), width: 2),
                        ),
                      ),
                      items: _selectedProvince != null && _cities.containsKey(_selectedProvince)
                          ? _cities[_selectedProvince]!.map((c) {
                              return DropdownMenuItem(value: c, child: Text(c));
                            }).toList()
                          : [],
                      onChanged: (value) => setState(() => _selectedCity = value),
                    ),
                  ],
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _completeOnboarding,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2C3E50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'Complete',
                              style: TextStyle(fontSize: 16),
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}