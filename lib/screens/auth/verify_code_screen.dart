import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:dating_app/generated/app_localizations.dart';
import '../../config/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/onboarding_provider.dart';
import 'sign_up_screen.dart';
import '../onboarding/basic_info_screen.dart';

class VerifyCodeScreen extends StatefulWidget {
  final String email;
  final String password;
  final String? referralCode;

  const VerifyCodeScreen({
    super.key,
    required this.email,
    required this.password,
    this.referralCode,
  });

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  final List<TextEditingController> _codeControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _codeFocusNodes = List.generate(
    6,
    (index) => FocusNode(),
  );

  final TextEditingController _referralController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  // Timer variables
  int _resendTimerSeconds = 300;
  bool _isTimerRunning = true;
  late VoidCallback _timerCallback;

  @override
  void initState() {
    super.initState();
    this._startResendTimer();
    // Focus on first field after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      this._codeFocusNodes[0].requestFocus();
    });
  }

  void _startResendTimer() {
    this._isTimerRunning = true;
    this._resendTimerSeconds = 300;
    this._timerCallback = () {
      if (mounted) {
        setState(() {
          if (this._resendTimerSeconds > 0) {
            this._resendTimerSeconds--;
          } else {
            this._isTimerRunning = false;
            this._timerCallback = () {};
          }
        });
      }
    };
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      this._timerCallback();
      return this._isTimerRunning && mounted;
    });
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    for (var controller in this._codeControllers) {
      controller.dispose();
    }
    for (var node in this._codeFocusNodes) {
      node.dispose();
    }
    this._referralController.dispose();
    this._isTimerRunning = false;
    super.dispose();
  }

  void _onCodeChanged(int index, String value) {
    // Auto-advance to next field
    if (value.length == 1 && index < 5) {
      this._codeFocusNodes[index + 1].requestFocus();
    }
    // Auto-backspace to previous field
    if (value.isEmpty && index > 0) {
      this._codeFocusNodes[index - 1].requestFocus();
    }
    setState(() {
      this._errorMessage = null;
    });
  }

  String _getFullCode() {
    return this._codeControllers.map((c) => c.text).join();
  }

  Future<void> _handleVerify() async {
    final t = AppLocalizations.of(context)!;
    final code = this._getFullCode();
    if (code.length != 6) {
      setState(() {
        this._errorMessage = t.verify_code_required;
      });
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    this._setLoading(true);

    final success = await authProvider.registerVerify(
      code: code,
      password: widget.password,
      referralCode: this._referralController.text.trim().isNotEmpty
          ? this._referralController.text.trim()
          : null,
      context: context,
    );

    this._setLoading(false);

    if (success) {
      if (mounted) {
        final onboardingProvider =
            Provider.of<OnboardingProvider>(context, listen: false);
        onboardingProvider.setEmailAndPassword(widget.email, widget.password);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const BasicInfoScreen(),
          ),
        );
      }
    } else {
      if (mounted) {
        setState(() {
          this._errorMessage = authProvider.errorMessage ?? t.error_verification_failed;
        });
        for (var controller in this._codeControllers) {
          controller.clear();
        }
        this._codeFocusNodes[0].requestFocus();
      }
    }
  }

  void _setLoading(bool loading) {
    setState(() {
      this._isLoading = loading;
    });
  }

  void _resendCode() async {
    if (this._isTimerRunning) {
      return;
    }

    final t = AppLocalizations.of(context)!;
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    this._setLoading(true);

    final success = await authProvider.registerInit(widget.email, context);

    this._setLoading(false);

    if (success && mounted) {
      this._startResendTimer();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(t.verify_resend_success),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
        ),
      );
      for (var controller in this._codeControllers) {
        controller.clear();
      }
      this._codeFocusNodes[0].requestFocus();
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            authProvider.errorMessage ?? t.verify_resend_failed,
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;
    final isDark = context.isDarkMode;
    final primaryColor = isDark ? AppTheme.darkPrimary : AppTheme.lightPrimary;
    final bgColor = isDark ? AppTheme.darkBackground : AppTheme.lightBackground;
    final surfaceColor =
        isDark ? AppTheme.darkSurface : AppTheme.lightSurface;
    final borderColor = isDark ? AppTheme.darkBorder : AppTheme.lightBorder;
    final textMutedColor =
        isDark ? AppTheme.darkTextMuted : AppTheme.lightTextMuted;
    final onSurfaceColor = colors.onSurface;
    final errorColor = AppTheme.lightError;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: onSurfaceColor),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const SignUpScreen()),
            );
          },
        ),
        centerTitle: true,
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    t.verify_title,
                    style: AppTheme.headlineMedium.copyWith(
                      color: onSurfaceColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    t.verify_subtitle,
                    style: AppTheme.bodyLarge.copyWith(
                      color: textMutedColor,
                    ),
                  ),
                  Text(
                    widget.email,
                    style: AppTheme.bodyLarge.copyWith(
                      color: primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 48),

                  if (this._errorMessage != null)
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
                              this._errorMessage!,
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
                  if (this._errorMessage != null) const SizedBox(height: 24),

                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(6, (index) {
                        return SizedBox(
                          width: 48,
                          height: 56,
                          child: TextFormField(
                            controller: this._codeControllers[index],
                            focusNode: this._codeFocusNodes[index],
                            textAlign: TextAlign.center,
                            textDirection: TextDirection.ltr,
                            maxLength: 1,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: onSurfaceColor,
                            ),
                            onChanged: (value) => this._onCodeChanged(index, value),
                            decoration: InputDecoration(
                              counterText: '',
                              hintText: '—',
                              hintStyle: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: textMutedColor.withOpacity(0.3),
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
                              contentPadding: const EdgeInsets.all(0),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 16),

                  TextButton(
                    onPressed: this._isTimerRunning || this._isLoading ? null : this._resendCode,
                    child: Text(
                      this._isTimerRunning
                          ? '${t.verify_resend} (${this._formatTime(this._resendTimerSeconds)})'
                          : t.verify_resend,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        color: this._isTimerRunning
                            ? textMutedColor
                            : primaryColor,
                        fontWeight: this._isTimerRunning
                            ? FontWeight.w400
                            : FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Text(
                    t.verify_referral_hint,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      color: textMutedColor,
                    ),
                  ),
                  const SizedBox(height: 8),

                  TextFormField(
                    controller: this._referralController,
                    textInputAction: TextInputAction.done,
                    style: AppTheme.bodyLarge.copyWith(
                      color: onSurfaceColor,
                    ),
                    decoration: InputDecoration(
                      hintText: t.verify_referral_hint,
                      hintStyle: AppTheme.bodyMedium.copyWith(
                        color: textMutedColor,
                      ),
                      prefixIcon: Icon(
                        Icons.card_giftcard_outlined,
                        color: textMutedColor,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: borderColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: primaryColor,
                          width: 2,
                        ),
                      ),
                      filled: true,
                      fillColor: surfaceColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    t.verify_referral_bonus,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      color: textMutedColor,
                    ),
                  ),
                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: this._isLoading ? null : this._handleVerify,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                        minimumSize: const Size(double.infinity, 56),
                      ),
                      child: this._isLoading
                          ? SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              t.verify_button,
                              style: AppTheme.buttonText,
                            ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}