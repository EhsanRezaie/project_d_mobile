// lib/screens/profile/edit_profile_details_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../generated/app_localizations.dart';
import '../../utils/profile_localization.dart';
import '../../utils/responsive.dart';
import '../../widgets/action_toast.dart';

class EditProfileDetailsScreen extends StatefulWidget {
  const EditProfileDetailsScreen({super.key});

  @override
  State<EditProfileDetailsScreen> createState() => _EditProfileDetailsScreenState();
}

class _EditProfileDetailsScreenState extends State<EditProfileDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isSaving = false;
  String? _errorMessage;

  final TextEditingController _workplaceController = TextEditingController();

  double _height = 175;
  double _weight = 70;

  String? _bodyType;
  String? _relationshipStatus;
  String? _livingSituation;
  String? _childrenStatus;
  String? _smoking;
  String? _drinking;
  String? _hereFor;
  String? _pets;
  String? _workoutFrequency;
  String? _zodiacSign;
  String? _education;
  String? _politicalOrientation;
  String? _religion;
  String? _ethnicity;
  List<String> _selectedLanguages = [];

  final List<String> _languageOptions = [
    'English',
    'Persian',
    'Turkish',
    'Arabic',
    'Spanish',
    'French',
    'German',
    'Italian',
    'Russian',
    'Chinese',
    'Japanese',
    'Korean',
    'Hindi',
    'Urdu',
    'Kurdish',
    'Armenian',
  ];

  // ============================================================
  // BODY TYPE - Matches backend: slim, average, athletic, curvy, muscular, overweight
  // ============================================================
  final List<String> _bodyTypeOptions = [
    'slim',
    'average',
    'athletic',
    'curvy',
    'muscular',
    'overweight',
  ];

  // ============================================================
  // RELATIONSHIP STATUS - Matches backend: single, divorced, widowed, separated
  // ============================================================
  final List<String> _relationshipOptions = [
    'single',
    'divorced',
    'widowed',
    'separated',
  ];

  // ============================================================
  // LIVING SITUATION - Matches backend: alone, with_family, with_roommate, with_partner
  // ============================================================
  final List<String> _livingSituationOptions = [
    'alone',
    'with_family',
    'with_roommate',
    'with_partner',
  ];

  // ============================================================
  // CHILDREN STATUS - Matches backend: have_children, want_children,
  // dont_want_children, open_to_children
  // ============================================================
  final List<String> _childrenOptions = [
    'have_children',
    'want_children',
    'dont_want_children',
    'open_to_children',
  ];

  // ============================================================
  // HERE FOR - Matches backend: long_term_relationship, casual_dating,
  // marriage, new_friends, not_sure_yet
  // ============================================================
  final List<String> _hereForOptions = [
    'long_term_relationship',
    'casual_dating',
    'marriage',
    'new_friends',
    'not_sure_yet',
  ];

  // ============================================================
  // PETS - Matches backend: dog, cat, both, other_pet, no_pets, loves_pets
  // ============================================================
  final List<String> _petsOptions = [
    'dog',
    'cat',
    'both',
    'other_pet',
    'no_pets',
    'loves_pets',
  ];

  // ============================================================
  // WORKOUT FREQUENCY - Matches backend: never, occasionally, regularly, daily
  // ============================================================
  final List<String> _workoutOptions = [
    'never',
    'occasionally',
    'regularly',
    'daily',
  ];

  // ============================================================
  // ZODIAC SIGN - Matches backend: 12 signs
  // ============================================================
  final List<String> _zodiacOptions = [
    'aries',
    'taurus',
    'gemini',
    'cancer',
    'leo',
    'virgo',
    'libra',
    'scorpio',
    'sagittarius',
    'capricorn',
    'aquarius',
    'pisces',
  ];

  // ============================================================
  // SMOKING - Matches backend: never, occasionally, regularly
  // ============================================================
  final List<String> _smokingOptions = [
    'never',
    'occasionally',
    'regularly',
  ];

  // ============================================================
  // DRINKING - Matches backend: never, socially, regularly
  // ============================================================
  final List<String> _drinkingOptions = [
    'never',
    'socially',
    'regularly',
  ];

  // ============================================================
  // EDUCATION - Matches backend: high_school, bachelor, master, phd
  // ============================================================
  final List<String> _educationOptions = [
    'high_school',
    'bachelor',
    'master',
    'phd',
  ];

  // ============================================================
  // POLITICAL - Matches backend: liberal, conservative, moderate, apolitical
  // ============================================================
  final List<String> _politicalOptions = [
    'liberal',
    'conservative',
    'moderate',
    'apolitical',
  ];

  // ============================================================
  // RELIGION - Free text (no enum)
  // ============================================================
  final List<String> _religionOptions = [
    'muslim',
    'christian',
    'jewish',
    'zoroastrian',
    'atheist',
    'agnostic',
    'spiritual',
    'sikh',
    'buddhist',
    'hindu',
    'other',
  ];

  // ============================================================
  // ETHNICITY - Free text (no enum)
  // ============================================================
  final List<String> _ethnicityOptions = [
    'persian',
    'azeri',
    'kurd',
    'lur',
    'arab',
    'baloch',
    'turkmen',
    'asian',
    'black / african descent',
    'hispanic / latino',
    'white / caucasian',
    'middle eastern',
    'mixed',
    'other',
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.user;

    if (user != null) {
      if (user.height != null) _height = user.height!.toDouble();
      if (user.weight != null) _weight = user.weight!.toDouble();
      if (user.bodyType != null) _bodyType = user.bodyType;
      if (user.relationshipStatus != null) {
        _relationshipStatus = user.relationshipStatus;
      }
      if (user.livingSituation != null) {
        _livingSituation = user.livingSituation;
      }
      if (user.childrenStatus != null) {
        _childrenStatus = user.childrenStatus;
      }
      if (user.smoking != null) _smoking = user.smoking;
      if (user.drinking != null) _drinking = user.drinking;
      if (user.hereFor != null) _hereFor = user.hereFor;
      if (user.pets != null) _pets = user.pets;
      if (user.workoutFrequency != null) {
        _workoutFrequency = user.workoutFrequency;
      }
      if (user.zodiacSign != null) _zodiacSign = user.zodiacSign;
      if (user.education != null) _education = user.education;
      if (user.workplace != null) _workplaceController.text = user.workplace!;
      if (user.religion != null) _religion = user.religion;
      if (user.ethnicity != null) _ethnicity = user.ethnicity;
      if (user.politicalOrientation != null) {
        _politicalOrientation = user.politicalOrientation;
      }
      if (user.languages != null) _selectedLanguages = List.from(user.languages!);
    }
  }

  void _toggleLanguage(String language) {
    setState(() {
      if (_selectedLanguages.contains(language)) {
        _selectedLanguages.remove(language);
      } else {
        _selectedLanguages.add(language);
      }
    });
  }

  void _selectChip(String value, Function(String?) setter, String? current) {
    setState(() {
      if (current == value) {
        setter(null);
      } else {
        setter(value);
      }
    });
  }

  Future<void> _handleSave() async {
    final t = AppLocalizations.of(context)!;
    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      final Map<String, dynamic> updateData = {};

      // Height
      if (_height != 0) updateData['height'] = _height.toInt();

      // Weight
      if (_weight != 0) updateData['weight'] = _weight.toInt();

      // Body Type
      if (_bodyType != null) {
        final backendValue = _bodyType!;
        updateData['body_type'] = backendValue;
      }

      // Relationship Status
      if (_relationshipStatus != null) {
        final backendValue = _relationshipStatus!;
        updateData['relationship_status'] = backendValue;
      }

      // Living Situation
      if (_livingSituation != null) {
        final backendValue = _livingSituation!;
        updateData['living_situation'] = backendValue;
      }

      // Children Status
      if (_childrenStatus != null) {
        final backendValue = _childrenStatus!;
        updateData['children_status'] = backendValue;
      }

      // Smoking
      if (_smoking != null) {
        final backendValue = _smoking!;
        updateData['smoking'] = backendValue;
      }

      // Drinking
      if (_drinking != null) {
        final backendValue = _drinking!;
        updateData['drinking'] = backendValue;
      }

      // Here For
      if (_hereFor != null) {
        updateData['here_for'] = _hereFor!;
      }

      // Pets
      if (_pets != null) {
        updateData['pets'] = _pets!;
      }

      // Workout Frequency
      if (_workoutFrequency != null) {
        updateData['workout_frequency'] = _workoutFrequency!;
      }

      // Zodiac Sign
      if (_zodiacSign != null) {
        updateData['zodiac_sign'] = _zodiacSign!;
      }

      // Education
      if (_education != null) {
        final backendValue = _education!;
        updateData['education'] = backendValue;
      }

      // Workplace - send null if empty
      updateData['workplace'] = _workplaceController.text.trim().isNotEmpty
          ? _workplaceController.text.trim()
          : null;

      // Religion
      if (_religion != null) {
        final backendValue = _religion!;
        updateData['religion'] = backendValue;
      }

      // Ethnicity
      if (_ethnicity != null) {
        final backendValue = _ethnicity!;
        updateData['ethnicity'] = backendValue;
      }

      // Political Orientation
      if (_politicalOrientation != null) {
        final backendValue = _politicalOrientation!;
        updateData['political_orientation'] = backendValue;
      }

      // Languages - send null if empty
      if (_selectedLanguages.isNotEmpty) {
        updateData['languages'] = _selectedLanguages;
      }

      debugPrint('📤 Sending update data: $updateData');

      final success = await authProvider.updateProfile(updateData);

      if (success && mounted) {
        showActionToast(context, t.profile_updated_success);
        Navigator.pop(context);
      } else if (mounted) {
        setState(() {
          _errorMessage = authProvider.errorMessage ?? 'Failed to update profile';
          _isSaving = false;
        });
        showActionToast(context, t.error_something_wrong, isError: true);
      }
    } catch (e) {
      debugPrint('❌ Save error: $e');
      if (mounted) {
        setState(() {
          _errorMessage = 'An error occurred. Please try again.';
          _isSaving = false;
        });
        showActionToast(context, t.error_something_wrong, isError: true);
      }
    }
  }

  @override
  void dispose() {
    _workplaceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: onSurfaceColor, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Edit Profile Details',
          style: TextStyle(
            fontFamily: AppTheme.fontFor(!Localizations.localeOf(context).languageCode.contains('en')),
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: onSurfaceColor,
            letterSpacing: -0.4,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: AppLayout.box(
            context: context,
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
                            if (_errorMessage != null) ...[
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                decoration: BoxDecoration(
                                  color: errorColor.withValues(alpha: 0.08),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: errorColor.withValues(alpha: 0.2)),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.error_outline, color: errorColor, size: 20),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        _errorMessage!,
                                        style: TextStyle(
                                          fontFamily: AppTheme.fontFor(!Localizations.localeOf(context).languageCode.contains('en')),
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
                            // HEIGHT
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '📏 Height',
                                      style: TextStyle(
                                        fontFamily: AppTheme.fontFor(!Localizations.localeOf(context).languageCode.contains('en')),
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: onSurfaceColor,
                                      ),
                                    ),
                                    Text(
                                      '${_height.toInt()} cm',
                                      style: TextStyle(
                                        fontFamily: AppTheme.fontFor(!Localizations.localeOf(context).languageCode.contains('en')),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: primaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                                Slider(
                                  value: _height,
                                  min: 140,
                                  max: 220,
                                  divisions: 80,
                                  activeColor: primaryColor,
                                  inactiveColor: isDark ? Colors.white12 : Colors.black12,
                                  onChanged: (value) {
                                    setState(() {
                                      _height = value;
                                    });
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            // WEIGHT
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '🏋️ Weight',
                                      style: TextStyle(
                                        fontFamily: AppTheme.fontFor(!Localizations.localeOf(context).languageCode.contains('en')),
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: onSurfaceColor,
                                      ),
                                    ),
                                    Text(
                                      '${_weight.toInt()} kg',
                                      style: TextStyle(
                                        fontFamily: AppTheme.fontFor(!Localizations.localeOf(context).languageCode.contains('en')),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: primaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                                Slider(
                                  value: _weight,
                                  min: 40,
                                  max: 140,
                                  divisions: 100,
                                  activeColor: primaryColor,
                                  inactiveColor: isDark ? Colors.white12 : Colors.black12,
                                  onChanged: (value) {
                                    setState(() {
                                      _weight = value;
                                    });
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            // BODY TYPE
                            _buildChipSection(
                              label: '💪 Body Type',
                              options: _bodyTypeOptions,
                              selected: _bodyType,
                              onTap: (value) => _selectChip(value, (v) => _bodyType = v, _bodyType),
                            ),
                            const SizedBox(height: 24),
                            // RELATIONSHIP STATUS
                            _buildChipSection(
                              label: '❤️ Relationship Status',
                              options: _relationshipOptions,
                              selected: _relationshipStatus,
                              onTap: (value) => _selectChip(value, (v) => _relationshipStatus = v, _relationshipStatus),
                            ),
                            const SizedBox(height: 24),
                            // LIVING SITUATION
                            _buildChipSection(
                              label: '🏠 Living Situation',
                              options: _livingSituationOptions,
                              selected: _livingSituation,
                              onTap: (value) => _selectChip(value, (v) => _livingSituation = v, _livingSituation),
                            ),
                            const SizedBox(height: 24),
                            // CHILDREN STATUS
                            _buildChipSection(
                              label: '👶 Children Status',
                              options: _childrenOptions,
                              selected: _childrenStatus,
                              onTap: (value) => _selectChip(value, (v) => _childrenStatus = v, _childrenStatus),
                            ),
                            const SizedBox(height: 24),
                            // SMOKING
                            _buildChipSection(
                              label: '🚬 Smoking',
                              options: _smokingOptions,
                              selected: _smoking,
                              onTap: (value) => _selectChip(value, (v) => _smoking = v, _smoking),
                            ),
                            const SizedBox(height: 24),
                            // DRINKING
                            _buildChipSection(
                              label: '🍷 Drinking',
                              options: _drinkingOptions,
                              selected: _drinking,
                              onTap: (value) => _selectChip(value, (v) => _drinking = v, _drinking),
                            ),
                            const SizedBox(height: 24),
                            // HERE FOR
                            _buildChipSection(
                              label: '🎯 I\'m Here For',
                              options: _hereForOptions,
                              selected: _hereFor,
                              onTap: (value) => _selectChip(value, (v) => _hereFor = v, _hereFor),
                            ),
                            const SizedBox(height: 24),
                            // PETS
                            _buildChipSection(
                              label: '🐾 Pets',
                              options: _petsOptions,
                              selected: _pets,
                              onTap: (value) => _selectChip(value, (v) => _pets = v, _pets),
                            ),
                            const SizedBox(height: 24),
                            // WORKOUT FREQUENCY
                            _buildChipSection(
                              label: '🏃 Workout Frequency',
                              options: _workoutOptions,
                              selected: _workoutFrequency,
                              onTap: (value) => _selectChip(value, (v) => _workoutFrequency = v, _workoutFrequency),
                            ),
                            const SizedBox(height: 24),
                            // ZODIAC SIGN
                            _buildChipSection(
                              label: '♈ Zodiac Sign',
                              options: _zodiacOptions,
                              selected: _zodiacSign,
                              onTap: (value) => _selectChip(value, (v) => _zodiacSign = v, _zodiacSign),
                            ),
                            const SizedBox(height: 24),
                            // EDUCATION
                            _buildChipSection(
                              label: '🎓 Education',
                              options: _educationOptions,
                              selected: _education,
                              onTap: (value) => _selectChip(value, (v) => _education = v, _education),
                            ),
                            const SizedBox(height: 24),
                            // POLITICAL ORIENTATION
                            _buildChipSection(
                              label: '🗳️ Political Orientation',
                              options: _politicalOptions,
                              selected: _politicalOrientation,
                              onTap: (value) => _selectChip(value, (v) => _politicalOrientation = v, _politicalOrientation),
                            ),
                            const SizedBox(height: 24),
                            // RELIGION
                            _buildChipSection(
                              label: '🕌 Religion',
                              options: _religionOptions,
                              selected: _religion,
                              onTap: (value) => _selectChip(value, (v) => _religion = v, _religion),
                            ),
                            const SizedBox(height: 24),
                            // ETHNICITY
                            _buildChipSection(
                              label: '🌍 Ethnicity',
                              options: _ethnicityOptions,
                              selected: _ethnicity,
                              onTap: (value) => _selectChip(value, (v) => _ethnicity = v, _ethnicity),
                            ),
                            const SizedBox(height: 24),
                            // LANGUAGES (Multi-select)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 4.0),
                                  child: Text(
                                    '🗣️ Languages (Multi-select)',
                                    style: TextStyle(
                                      fontFamily: AppTheme.fontFor(!Localizations.localeOf(context).languageCode.contains('en')),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: onSurfaceColor,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: _languageOptions.map((language) {
                                    final isSelected = _selectedLanguages.contains(language);
                                    return GestureDetector(
                                      onTap: () => _toggleLanguage(language),
                                      child: AnimatedContainer(
                                        duration: const Duration(milliseconds: 150),
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                        decoration: BoxDecoration(
                                          color: isSelected ? primaryColor.withValues(alpha: 0.06) : surfaceColor,
                                          borderRadius: BorderRadius.circular(20),
                                          border: Border.all(
                                            color: isSelected ? primaryColor : borderColor,
                                            width: isSelected ? 1.5 : 1,
                                          ),
                                        ),
                                        child: Text(
                                          localizedLanguage(AppLocalizations.of(context)!, language),
                                          style: TextStyle(
                                            fontFamily: AppTheme.fontFor(!Localizations.localeOf(context).languageCode.contains('en')),
                                            fontSize: 14,
                                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                            color: isSelected ? primaryColor : onSurfaceColor.withValues(alpha: 0.8),
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            // WORKPLACE
                            TextFormField(
                              controller: _workplaceController,
                              style: TextStyle(
                                fontFamily: AppTheme.fontFor(!Localizations.localeOf(context).languageCode.contains('en')),
                                fontSize: 16,
                                color: onSurfaceColor,
                              ),
                              decoration: InputDecoration(
                                labelText: '💼 Workplace (optional)',
                                hintText: 'Your job title or company',
                                prefixIcon: Icon(Icons.work_outline, color: textMutedColor, size: 22),
                              ),
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
                          onPressed: _isSaving ? null : _handleSave,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                            minimumSize: const Size(double.infinity, 56),
                          ),
                          child: _isSaving
                              ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                )
                              : Text(
                                  'Save',
                                  style: TextStyle(
                                    fontFamily: AppTheme.fontFor(!Localizations.localeOf(context).languageCode.contains('en')),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
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
      ),
    );
  }

  Widget _buildChipSection({
    required String label,
    required List<String> options,
    required String? selected,
    required void Function(String) onTap,
    String Function(String)? display,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? AppTheme.darkPrimary : AppTheme.lightPrimary;
    final surfaceColor = isDark ? AppTheme.darkSurface : AppTheme.lightSurface;
    final borderColor = isDark ? AppTheme.darkBorder : AppTheme.lightBorder;
    final onSurfaceColor = Theme.of(context).colorScheme.onSurface;
    final t = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4.0),
          child: Text(
            label,
            style: TextStyle(
              fontFamily: AppTheme.fontFor(!Localizations.localeOf(context).languageCode.contains('en')),
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: onSurfaceColor,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((option) {
            final isSelected = selected == option;
            final optionLabel =
                display?.call(option) ?? localizedEnum(t, option);
            return GestureDetector(
              onTap: () => onTap(option),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? primaryColor.withValues(alpha: 0.06) : surfaceColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? primaryColor : borderColor,
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: Text(
                  optionLabel,
                  style: TextStyle(
                    fontFamily: AppTheme.fontFor(!Localizations.localeOf(context).languageCode.contains('en')),
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? primaryColor : onSurfaceColor.withValues(alpha: 0.8),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}