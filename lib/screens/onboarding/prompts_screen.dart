// lib/screens/onboarding/prompts_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dating_app/generated/app_localizations.dart';
import '../../config/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/onboarding_provider.dart';
import '../../services/onboarding_service.dart';
import '../../models/prompt.dart';
import '../main_screen.dart';

class PromptsScreen extends StatefulWidget {
  const PromptsScreen({super.key});

  @override
  State<PromptsScreen> createState() => _PromptsScreenState();
}

class _PromptsScreenState extends State<PromptsScreen> {
  List<Prompt> _allPrompts = [];
  List<Map<String, dynamic>> _selectedPrompts = [];
  bool _isLoading = true;
  bool _isSubmitting = false;
  String? _errorMessage;

  // For each selected prompt, we need an answer controller
  final Map<String, TextEditingController> _answerControllers = {};

  @override
  void initState() {
    super.initState();
    _loadPrompts();
    _loadSavedPrompts();
  }

  void _loadSavedPrompts() {
    final onboarding = Provider.of<OnboardingProvider>(context, listen: false);
    if (onboarding.prompts != null && onboarding.prompts!.isNotEmpty) {
      _selectedPrompts = List.from(onboarding.prompts!);
      // Initialize controllers for saved prompts
      for (final prompt in _selectedPrompts) {
        final promptId = prompt['prompt_id'] as String;
        _answerControllers[promptId] = TextEditingController(
          text: prompt['answer'] ?? '',
        );
      }
    }
  }

  Future<void> _loadPrompts() async {
    setState(() => _isLoading = true);
    try {
      final prompts = await OnboardingService.getPrompts();
      setState(() {
        _allPrompts = prompts.where((p) => p.isActive).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load prompts';
        _isLoading = false;
      });
    }
  }

  void _togglePrompt(Prompt prompt) {
    setState(() {
      final exists = _selectedPrompts.any((p) => p['prompt_id'] == prompt.id);
      if (exists) {
        // Remove prompt
        _selectedPrompts.removeWhere((p) => p['prompt_id'] == prompt.id);
        _answerControllers.remove(prompt.id);
      } else {
        // Add prompt (max 3)
        if (_selectedPrompts.length >= 3) {
          setState(() {
            _errorMessage = 'You can select up to 3 prompts';
          });
          return;
        }
        _selectedPrompts.add({
          'prompt_id': prompt.id,
          'answer': '',
        });
        _answerControllers[prompt.id] = TextEditingController();
      }
      _errorMessage = null;
    });
  }

  void _updateAnswer(String promptId, String answer) {
    setState(() {
      final index = _selectedPrompts.indexWhere((p) => p['prompt_id'] == promptId);
      if (index != -1) {
        _selectedPrompts[index]['answer'] = answer;
      }
    });
  }

  bool _isPromptSelected(String promptId) {
    return _selectedPrompts.any((p) => p['prompt_id'] == promptId);
  }

  String? _getAnswer(String promptId) {
    final found = _selectedPrompts.firstWhere(
      (p) => p['prompt_id'] == promptId,
      orElse: () => {},
    );
    return found['answer'] as String?;
  }

  bool _isFormValid() {
    // Check if all selected prompts have answers
    for (final prompt in _selectedPrompts) {
      final answer = prompt['answer'] as String?;
      if (answer == null || answer.trim().isEmpty) {
        return false;
      }
      if (answer.trim().length < 2) {
        return false;
      }
    }
    return true;
  }

  Future<void> _handleSubmit() async {
    if (_selectedPrompts.isEmpty) {
      // User can skip, just proceed
      await _completeOnboarding();
      return;
    }

    // Validate answers
    if (!_isFormValid()) {
      setState(() {
        _errorMessage = 'Please answer all selected prompts';
      });
      return;
    }

    await _completeOnboarding();
  }

  Future<void> _completeOnboarding() async {
    final onboarding = Provider.of<OnboardingProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // Save prompts to provider
    onboarding.setPrompts(_selectedPrompts);

    // Build complete request
    final data = onboarding.buildCompleteRequest();

    setState(() => _isSubmitting = true);

    final success = await authProvider.registerComplete(data, context);

    setState(() => _isSubmitting = false);

    if (success && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainScreen()),
      );
    } else if (mounted) {
      setState(() {
        _errorMessage = authProvider.errorMessage ?? 'Failed to complete profile';
      });
    }
  }

  void _handleSkip() {
    _completeOnboarding();
  }

  @override
  void dispose() {
    for (final controller in _answerControllers.values) {
      controller.dispose();
    }
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: onSurfaceColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Your Prompts',
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
                'Answer up to 3 questions',
                style: AppTheme.headlineMedium.copyWith(
                  color: onSurfaceColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Choose prompts and write your answers',
                style: AppTheme.bodyLarge.copyWith(
                  color: textMutedColor,
                ),
              ),
              const SizedBox(height: 16),

              // Selection counter
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Selected: ${_selectedPrompts.length} / 3',
                    style: AppTheme.labelLarge.copyWith(
                      color: _selectedPrompts.isNotEmpty
                          ? primaryColor
                          : textMutedColor,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _selectedPrompts.isNotEmpty
                          ? primaryColor
                          : Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${_selectedPrompts.length}',
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

              // Prompts list
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _allPrompts.isEmpty
                        ? Center(
                            child: Text(
                              'No prompts available',
                              style: AppTheme.bodyLarge.copyWith(
                                color: textMutedColor,
                              ),
                            ),
                          )
                        : ListView.separated(
                            itemCount: _allPrompts.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 16),
                            itemBuilder: (context, index) {
                              final prompt = _allPrompts[index];
                              final isSelected = _isPromptSelected(prompt.id);
                              final answer = _getAnswer(prompt.id);

                              return _buildPromptItem(
                                prompt,
                                isSelected,
                                answer,
                              );
                            },
                          ),
              ),

              const SizedBox(height: 16),

              // Buttons
              Row(
                children: [
                  // Skip button (optional)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isSubmitting ? null : _handleSkip,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: textMutedColor,
                        side: BorderSide(color: borderColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        minimumSize: const Size(0, 56),
                      ),
                      child: Text(
                        'Skip',
                        style: AppTheme.buttonText.copyWith(
                          color: textMutedColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Submit button
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _isSubmitting ? null : _handleSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                        minimumSize: const Size(0, 56),
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
                              _selectedPrompts.isEmpty ? 'Skip & Continue' : 'Done',
                              style: AppTheme.buttonText,
                            ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPromptItem(
    Prompt prompt,
    bool isSelected,
    String? answer,
  ) {
    final isDark = context.isDarkMode;
    final primaryColor = isDark ? AppTheme.darkPrimary : AppTheme.lightPrimary;
    final surfaceColor = isDark ? AppTheme.darkSurface : AppTheme.lightSurface;
    final borderColor = isDark ? AppTheme.darkBorder : AppTheme.lightBorder;
    final onSurfaceColor = Theme.of(context).colorScheme.onSurface;
    final textMutedColor = isDark ? AppTheme.darkTextMuted : AppTheme.lightTextMuted;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isSelected ? primaryColor.withOpacity(0.05) : surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? primaryColor : borderColor,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Prompt with select button
          Row(
            children: [
              Expanded(
                child: Text(
                  prompt.question,
                  style: AppTheme.bodyLarge.copyWith(
                    color: isSelected ? primaryColor : onSurfaceColor,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => _togglePrompt(prompt),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? primaryColor : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    isSelected ? 'Selected' : 'Select',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : textMutedColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (isSelected) ...[
            const SizedBox(height: 12),
            TextFormField(
              controller: _answerControllers[prompt.id],
              maxLines: 3,
              maxLength: 500,
              decoration: InputDecoration(
                hintText: 'Write your answer...',
                hintStyle: AppTheme.bodyMedium.copyWith(
                  color: textMutedColor,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: borderColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: borderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: primaryColor,
                    width: 2,
                  ),
                ),
                filled: true,
                fillColor: surfaceColor,
                contentPadding: const EdgeInsets.all(12),
              ),
              onChanged: (value) => _updateAnswer(prompt.id, value),
              style: AppTheme.bodyLarge.copyWith(
                color: onSurfaceColor,
              ),
            ),
          ],
        ],
      ),
    );
  }
}