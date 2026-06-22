// lib/screens/onboarding/interests_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dating_app/generated/app_localizations.dart';
import '../../config/app_theme.dart';
import '../../providers/onboarding_provider.dart';
import '../../services/onboarding_service.dart';
import '../../models/interest.dart';
import 'prompts_screen.dart';

class InterestsScreen extends StatefulWidget {
  const InterestsScreen({super.key});

  @override
  State<InterestsScreen> createState() => _InterestsScreenState();
}

class _InterestsScreenState extends State<InterestsScreen> {
  List<Interest> _allInterests = [];
  List<String> _selectedInterests = [];
  bool _isLoading = true;
  bool _isSubmitting = false;
  String? _errorMessage;

  Map<String, List<Interest>> _groupedInterests = {};
  final Set<String> _expandedCategories = {};

  @override
  void initState() {
    super.initState();
    _loadInterests();
    _loadSavedInterests();
  }

  void _loadSavedInterests() {
    final onboarding = Provider.of<OnboardingProvider>(context, listen: false);
    if (onboarding.interests != null) {
      _selectedInterests = List.from(onboarding.interests!);
    }
  }

  Future<void> _loadInterests() async {
    setState(() => _isLoading = true);
    try {
      final interests = await OnboardingService.getInterests();
      setState(() {
        _allInterests = interests;
        _groupedInterests = _groupByCategory(interests);
        if (_groupedInterests.isNotEmpty) {
          _expandedCategories.add(_groupedInterests.keys.first);
        }
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load interests';
        _isLoading = false;
      });
    }
  }

  Map<String, List<Interest>> _groupByCategory(List<Interest> interests) {
    final map = <String, List<Interest>>{};
    for (final interest in interests) {
      final category = interest.category.isNotEmpty
          ? _formatCategory(interest.category)
          : 'Other';
      if (!map.containsKey(category)) {
        map[category] = [];
      }
      map[category]!.add(interest);
    }
    return map;
  }

  String _formatCategory(String category) {
    final parts = category.split('_');
    return parts.map((part) => part[0].toUpperCase() + part.substring(1)).join(' & ');
  }

  void _toggleInterest(Interest interest) {
    setState(() {
      if (_selectedInterests.contains(interest.name)) {
        _selectedInterests.remove(interest.name);
      } else {
        _selectedInterests.add(interest.name);
      }
      _errorMessage = null;
    });
  }

  void _toggleCategory(String category) {
    setState(() {
      if (_expandedCategories.contains(category)) {
        _expandedCategories.remove(category);
      } else {
        _expandedCategories.add(category);
      }
    });
  }

  bool _isSelected(String interestName) {
    return _selectedInterests.contains(interestName);
  }

  Future<void> _handleNext() async {
    if (_selectedInterests.length < 8) {
      setState(() {
        _errorMessage = 'Please select at least 8 interests';
      });
      return;
    }

    final onboarding = Provider.of<OnboardingProvider>(context, listen: false);
    onboarding.setInterests(_selectedInterests);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PromptsScreen()),
    );
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: onSurfaceColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Interests',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: onSurfaceColor,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Your Interests',
                style: AppTheme.headlineMedium.copyWith(
                  color: onSurfaceColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Pick at least 8 interests that represent you',
                style: AppTheme.bodyLarge.copyWith(
                  color: textMutedColor,
                ),
              ),
              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Selected: ${_selectedInterests.length} / 8',
                    style: AppTheme.labelLarge.copyWith(
                      color: _selectedInterests.length >= 8
                          ? Colors.green
                          : primaryColor,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${_selectedInterests.length}',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              if (_errorMessage != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: errorColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: errorColor.withOpacity(0.3)),
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
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              if (_errorMessage != null) const SizedBox(height: 16),

              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _groupedInterests.isEmpty
                        ? Center(
                            child: Text(
                              'No interests available',
                              style: AppTheme.bodyLarge.copyWith(
                                color: textMutedColor,
                              ),
                            ),
                          )
                        : ListView(
                            children: _groupedInterests.keys.map((category) {
                              return _buildCategorySection(
                                category,
                                _groupedInterests[category]!,
                                primaryColor,
                                surfaceColor,
                                borderColor,
                                textMutedColor,
                                onSurfaceColor,
                              );
                            }).toList(),
                          ),
              ),

              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _handleNext,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selectedInterests.length >= 8
                        ? primaryColor
                        : Colors.grey.shade400,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                    minimumSize: const Size(double.infinity, 56),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          'Next',
                          style: AppTheme.buttonText,
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategorySection(
    String category,
    List<Interest> interests,
    Color primaryColor,
    Color surfaceColor,
    Color borderColor,
    Color textMutedColor,
    Color onSurfaceColor,
  ) {
    final isExpanded = _expandedCategories.contains(category);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => _toggleCategory(category),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: borderColor,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  category,
                  style: AppTheme.titleMedium.copyWith(
                    color: onSurfaceColor,
                  ),
                ),
                Icon(
                  isExpanded ? Icons.expand_less : Icons.expand_more,
                  color: textMutedColor,
                ),
              ],
            ),
          ),
        ),
        if (isExpanded)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: interests.map((interest) {
                final isSelected = _isSelected(interest.name);
                return GestureDetector(
                  onTap: () => _toggleInterest(interest),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? primaryColor : surfaceColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected ? primaryColor : borderColor,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (interest.icon != null)
                          Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: Text(
                              interest.icon!,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        Text(
                          _formatInterestName(interest.name),
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            color: isSelected ? Colors.white : onSurfaceColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        const SizedBox(height: 4),
      ],
    );
  }

  String _formatInterestName(String name) {
    return name.replaceAll('_', ' ').split(' ')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }
}