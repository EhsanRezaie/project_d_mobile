import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/onboarding_provider.dart';
import '../../widgets/progress_bar.dart';
import 'photo_screen.dart';

class HeightWeightScreen extends StatefulWidget {
  const HeightWeightScreen({super.key});

  @override
  State<HeightWeightScreen> createState() => _HeightWeightScreenState();
}

class _HeightWeightScreenState extends State<HeightWeightScreen> {
  final _formKey = GlobalKey<FormState>();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  Future<void> _nextStep() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isLoading = true);
    
    final onboardingProvider = Provider.of<OnboardingProvider>(context, listen: false);
    
    onboardingProvider.updatePhysicalInfo(
      height: int.parse(_heightController.text),
      weight: int.parse(_weightController.text),
    );
    
    await Future.delayed(const Duration(milliseconds: 300));
    
    setState(() => _isLoading = false);
    
    if (!mounted) return;
    
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const PhotoScreen(),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const OnboardingProgressBar(currentStep: 2, totalSteps: 4),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      'Physical Information',
                      style: TextStyle(
                        fontSize: 28, 
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C3E50),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tell us about your physical attributes',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 40),
                    TextFormField(
                      controller: _heightController,
                      decoration: InputDecoration(
                        labelText: 'Height',
                        hintText: 'e.g., 175',
                        prefixIcon: const Icon(Icons.height, color: Color(0xFF2C3E50)),
                        suffixText: 'cm',
                        suffixStyle: const TextStyle(color: Color(0xFF2C3E50)),
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
                        if (v == null || v.isEmpty) return 'Height is required';
                        final height = int.tryParse(v);
                        if (height == null || height < 100 || height > 250) {
                          return 'Height must be between 100-250 cm';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _weightController,
                      decoration: InputDecoration(
                        labelText: 'Weight',
                        hintText: 'e.g., 70',
                        prefixIcon: const Icon(Icons.fitness_center, color: Color(0xFF2C3E50)),
                        suffixText: 'kg',
                        suffixStyle: const TextStyle(color: Color(0xFF2C3E50)),
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
                        if (v == null || v.isEmpty) return 'Weight is required';
                        final weight = int.tryParse(v);
                        if (weight == null || weight < 30 || weight > 300) {
                          return 'Weight must be between 30-300 kg';
                        }
                        return null;
                      },
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
                            : const Text(
                                'Continue',
                                style: TextStyle(fontSize: 16),
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