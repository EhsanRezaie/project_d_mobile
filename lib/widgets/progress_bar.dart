import 'package:flutter/material.dart';

class OnboardingProgressBar extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const OnboardingProgressBar({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Row(
        children: List.generate(totalSteps, (index) {
          final isCompleted = index < currentStep;
          final isCurrent = index == currentStep - 1;
          return Expanded(
            child: Container(
              height: 4,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: isCompleted
                    ? (isCurrent 
                        ? const Color(0xFF3498DB) 
                        : const Color(0xFF2C3E50))
                    : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }
}