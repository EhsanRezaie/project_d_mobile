import 'package:flutter/material.dart';
import 'package:dating_app/generated/app_localizations.dart';
import '../../widgets/progress_bar.dart';  // اضافه شد
import 'location_screen.dart';

class PhotoScreen extends StatefulWidget {
  const PhotoScreen({super.key});

  @override
  State<PhotoScreen> createState() => _PhotoScreenState();
}

class _PhotoScreenState extends State<PhotoScreen> {
  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      body: Column(
        children: [
          const OnboardingProgressBar(currentStep: 3, totalSteps: 4),  // اضافه شد
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.camera_alt, size: 80),
                    const SizedBox(height: 20),
                    Text(
                      't.photo_title',
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      't.photo_subtitle',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton.icon(
                      onPressed: () {
                        // TODO: Open image picker
                      },
                      icon: const Icon(Icons.photo_library),
                      label: Text('t.gallery_button'),
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton.icon(
                      onPressed: () {
                        // TODO: Open camera
                      },
                      icon: const Icon(Icons.camera_alt),
                      label: Text('t.camera_button'),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: _nextStep,
                      child: Text('t.skip_button'),
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

  void _nextStep() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const LocationScreen(),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }
}