// lib/screens/profile/delete_account_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:dating_app/config/app_theme.dart';
import 'package:dating_app/generated/app_localizations.dart';
import 'package:dating_app/providers/auth_provider.dart';
import 'package:dating_app/utils/responsive.dart';
import '../login_screen.dart';

class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  static const int _resendCooldownSeconds = 60;

  int _step = 0; // 0 = info+reason, 1 = code, 2 = success
  bool _isBusy = false;
  String? _errorMessage;

  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();

  Timer? _resendTimer;
  int _resendRemaining = 0;

  @override
  void initState() {
    super.initState();
    _codeController.addListener(() {
      if (_codeController.text.length == 6) {
        _delete();
      }
    });
  }

  @override
  void dispose() {
    _reasonController.dispose();
    _codeController.dispose();
    _resendTimer?.cancel();
    super.dispose();
  }

  void _startResendTimer() {
    _resendTimer?.cancel();
    setState(() => _resendRemaining = _resendCooldownSeconds);
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        if (_resendRemaining > 0) {
          _resendRemaining--;
        } else {
          _resendTimer?.cancel();
        }
      });
    });
  }

  Future<void> _requestCode() async {
    final t = AppLocalizations.of(context)!;
    setState(() {
      _isBusy = true;
      _errorMessage = null;
    });

    final provider = context.read<AuthProvider>();
    final sent = await provider.requestDeleteCode(context);

    if (!mounted) return;
    setState(() {
      _isBusy = false;
      if (sent) {
        _step = 1;
        _startResendTimer();
      } else {
        _errorMessage = provider.deleteError ?? t.delete_account_error_generic;
      }
    });
  }

  Future<void> _delete() async {
    if (_codeController.text.length != 6) return;
    final t = AppLocalizations.of(context)!;
    setState(() {
      _isBusy = true;
      _errorMessage = null;
    });

    final provider = context.read<AuthProvider>();
    final deleted = await provider.deleteAccount(
      _codeController.text,
      reason: _reasonController.text.trim(),
    );

    if (!mounted) return;
    setState(() {
      _isBusy = false;
      if (deleted) {
        _step = 2;
      } else {
        _errorMessage = switch (provider.deleteError) {
          'delete_account_error_generic' => t.delete_account_error_generic,
          'network_error' => t.error_network,
          final other when other != null => other,
          _ => t.delete_account_error_generic,
        };
      }
    });
  }

  void _resend() {
    if (_resendRemaining > 0 || _isBusy) return;
    _codeController.clear();
    _requestCode();
  }

  void _finish() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;
    final isDark = colors.brightness == Brightness.dark;
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
          onPressed: _step == 2
              ? _finish
              : () => Navigator.pop(context),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: AppLayout.box(
            context: context,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.delete_forever, size: 40, color: errorColor),
                const SizedBox(height: 16),
                Text(
                  t.delete_account_title,
                  style: AppTheme.headlineMedium.copyWith(color: onSurfaceColor),
                ),
                const SizedBox(height: 12),

                if (_step != 2) ...[
                  Text(
                    _step == 0 ? t.delete_account_desc : t.delete_account_step_code(_phone()),
                    style: AppTheme.bodyLarge.copyWith(color: textMutedColor),
                  ),
                  const SizedBox(height: 24),
                ],

                if (_errorMessage != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: errorColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: errorColor.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline, color: errorColor, size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _errorMessage!,
                            style: TextStyle(fontSize: 14, color: errorColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                if (_step == 0) ..._buildInfoStep(context, t, surfaceColor, borderColor, onSurfaceColor, textMutedColor, primaryColor),
                if (_step == 1) ..._buildCodeStep(context, t, surfaceColor, borderColor, onSurfaceColor, textMutedColor, primaryColor, errorColor),
                if (_step == 2) ..._buildSuccessStep(context, t, textMutedColor, onSurfaceColor, primaryColor),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _phone() {
    final provider = context.read<AuthProvider>();
    return provider.user?.phone ?? '';
  }

  List<Widget> _buildInfoStep(
    BuildContext context,
    AppLocalizations t,
    Color surfaceColor,
    Color borderColor,
    Color onSurfaceColor,
    Color textMutedColor,
    Color primaryColor,
  ) {
    return [
      TextField(
        controller: _reasonController,
        maxLength: 255,
        maxLines: 3,
        minLines: 1,
        decoration: InputDecoration(
          hintText: t.delete_account_reason_hint,
          hintStyle: TextStyle(color: textMutedColor),
          filled: true,
          fillColor: surfaceColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: borderColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: borderColor),
          ),
        ),
      ),
      const SizedBox(height: 24),
      SizedBox(
        width: double.infinity,
        height: 54,
        child: ElevatedButton(
          onPressed: _isBusy ? null : _requestCode,
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 0,
          ),
          child: _isBusy
              ? const SizedBox(
                  height: 22,
                  width: 22,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
              : Text(t.delete_account_confirm, style: AppTheme.buttonText),
        ),
      ),
      const SizedBox(height: 12),
      Text(
        t.delete_account_permanent_note,
        style: AppTheme.bodySmall.copyWith(color: textMutedColor),
      ),
    ];
  }

  List<Widget> _buildCodeStep(
    BuildContext context,
    AppLocalizations t,
    Color surfaceColor,
    Color borderColor,
    Color onSurfaceColor,
    Color textMutedColor,
    Color primaryColor,
    Color errorColor,
  ) {
    return [
      Text(
        t.delete_account_code_label,
        style: AppTheme.bodyLarge.copyWith(color: onSurfaceColor, fontWeight: FontWeight.w600),
      ),
      const SizedBox(height: 12),
      TextField(
        controller: _codeController,
        keyboardType: TextInputType.number,
        maxLength: 6,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 22, letterSpacing: 10, color: onSurfaceColor),
        decoration: InputDecoration(
          counterText: '',
          hintText: t.delete_account_code_hint,
          hintStyle: TextStyle(color: textMutedColor),
          filled: true,
          fillColor: surfaceColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: borderColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: borderColor),
          ),
        ),
      ),
      const SizedBox(height: 16),
      TextButton(
        onPressed: (_resendRemaining > 0 || _isBusy) ? null : _resend,
        child: Text(
          _resendRemaining > 0
              ? '${t.delete_account_resend} (${_resendRemaining}s)'
              : t.delete_account_resend,
          style: TextStyle(color: _resendRemaining > 0 ? textMutedColor : primaryColor),
        ),
      ),
      const SizedBox(height: 16),
      SizedBox(
        width: double.infinity,
        height: 54,
        child: ElevatedButton(
          onPressed: (_isBusy || _codeController.text.length != 6)
              ? null
              : _delete,
          style: ElevatedButton.styleFrom(
            backgroundColor: errorColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 0,
          ),
          child: _isBusy
              ? const SizedBox(
                  height: 22,
                  width: 22,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
              : Text(t.delete_account_confirm, style: AppTheme.buttonText),
        ),
      ),
    ];
  }

  List<Widget> _buildSuccessStep(
    BuildContext context,
    AppLocalizations t,
    Color textMutedColor,
    Color onSurfaceColor,
    Color primaryColor,
  ) {
    final provider = context.read<AuthProvider>();
    final date = provider.deletionScheduledFor ?? '';
    String formattedDate = date;
    final parsed = DateTime.tryParse(date);
    if (parsed != null) {
      formattedDate = '${parsed.year}-${parsed.month.toString().padLeft(2, '0')}-${parsed.day.toString().padLeft(2, '0')}';
    }

    return [
      const SizedBox(height: 8),
      Icon(Icons.check_circle, color: primaryColor, size: 64),
      const SizedBox(height: 16),
      Text(
        t.delete_account_success_title,
        style: AppTheme.headlineSmall.copyWith(color: onSurfaceColor),
      ),
      const SizedBox(height: 12),
      Text(
        t.delete_account_success_body(formattedDate),
        style: AppTheme.bodyLarge.copyWith(color: textMutedColor),
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 32),
      SizedBox(
        width: double.infinity,
        height: 54,
        child: ElevatedButton(
          onPressed: _finish,
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 0,
          ),
          child: Text(t.done, style: AppTheme.buttonText),
        ),
      ),
    ];
  }
}
