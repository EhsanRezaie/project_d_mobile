import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dating_app/generated/app_localizations.dart';
import '../../providers/auth_provider.dart';
import '../../providers/onboarding_provider.dart';
import '../../widgets/progress_bar.dart';
import 'height_weight_screen.dart';

class NameAgeScreen extends StatefulWidget {
  const NameAgeScreen({super.key});

  @override
  State<NameAgeScreen> createState() => _NameAgeScreenState();
}

class _NameAgeScreenState extends State<NameAgeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  String? _selectedGender;
  String? _referralCode;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  Future<void> _nextStep() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedGender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.gender_required)),
      );
      return;
    }

    setState(() => _isLoading = true);

    final onboardingProvider = Provider.of<OnboardingProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    final email = onboardingProvider.tempEmail;
    final password = onboardingProvider.tempPassword;
    
    if (email == null || password == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Session expired. Please start over.'),
          backgroundColor: Colors.red,
        ),
      );
      Navigator.pop(context);
      setState(() => _isLoading = false);
      return;
    }

    // Save user info to onboarding provider
    onboardingProvider.updateUserInfo(
      name: _nameController.text.trim(),
      email: email,
      password: password,
      age: int.parse(_ageController.text),
      gender: _selectedGender!,
      referralCode: _referralCode,
    );

    // Register user
    final success = await authProvider.register(
      email: email,
      password: password,
      name: _nameController.text.trim(),
      age: int.parse(_ageController.text),
      gender: _selectedGender!,
      referralCode: _referralCode,
    );

    setState(() => _isLoading = false);

    if (!mounted) return;

    if (success) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const HeightWeightScreen(),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.error ?? 'Registration failed'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const OnboardingProgressBar(currentStep: 1, totalSteps: 4),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      t.basic_info_title,
                      style: const TextStyle(
                        fontSize: 28, 
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C3E50),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tell us about yourself',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 40),
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: t.name_label,
                        prefixIcon: const Icon(Icons.person, color: Color(0xFF2C3E50)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFF3498DB), width: 2),
                        ),
                      ),
                      validator: (v) => v == null || v.isEmpty ? t.name_required : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _ageController,
                      decoration: InputDecoration(
                        labelText: t.age_label,
                        prefixIcon: const Icon(Icons.cake, color: Color(0xFF2C3E50)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFF3498DB), width: 2),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (v) {
                        if (v == null || v.isEmpty) return t.age_required;
                        final age = int.tryParse(v);
                        if (age == null || age < 18 || age > 100) return t.age_invalid;
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: t.gender_label,
                        prefixIcon: const Icon(Icons.person_outline, color: Color(0xFF2C3E50)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFF3498DB), width: 2),
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'male', child: Text('Male')),
                        DropdownMenuItem(value: 'female', child: Text('Female')),
                      ],
                      onChanged: (value) => setState(() => _selectedGender = value),
                      validator: (v) => v == null ? t.gender_required : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: t.referral_code_hint,
                        prefixIcon: const Icon(Icons.code, color: Color(0xFF2C3E50)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFF3498DB), width: 2),
                        ),
                      ),
                      onChanged: (v) => _referralCode = v.isEmpty ? null : v,
                    ),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _nextStep,
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
                            : Text(
                                t.continue_button,
                                style: const TextStyle(fontSize: 16),
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}