// lib/screens/profile/referral_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dating_app/config/app_theme.dart';
import 'package:dating_app/generated/app_localizations.dart';
import 'package:dating_app/services/auth_service.dart';
import 'package:dating_app/utils/responsive.dart';
import 'package:dating_app/widgets/action_toast.dart';

class ReferralScreen extends StatefulWidget {
  const ReferralScreen({super.key});

  @override
  State<ReferralScreen> createState() => _ReferralScreenState();
}

class _ReferralScreenState extends State<ReferralScreen> {
  bool _isLoading = true;
  String? _code;
  String? _shareText;
  int _successfulReferrals = 0;
  int _totalDays = 0;
  String? _errorKey;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _isLoading = true;
      _errorKey = null;
    });
    try {
      final codeRes = await AuthService.getMyReferralCode();
      final statsRes = await AuthService.getReferralStats();
      if (!mounted) return;
      if (codeRes.statusCode == 200 && statsRes.statusCode == 200) {
        final codeData = codeRes.data as Map<String, dynamic>;
        final statsData = statsRes.data as Map<String, dynamic>;
        setState(() {
          _code = codeData['referral_code'] as String? ?? '';
          _shareText = codeData['share_text'] as String?;
          _successfulReferrals = statsData['successful_referrals'] as int? ?? 0;
          _totalDays = statsData['total_premium_days_earned'] as int? ?? 0;
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorKey = 'referral_load_error';
          _isLoading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorKey = 'referral_load_error';
        _isLoading = false;
      });
    }
  }

  Future<void> _copyCode() async {
    final t = AppLocalizations.of(context)!;
    if (_code == null || _code!.isEmpty) return;
    await Clipboard.setData(ClipboardData(text: _code!));
    if (mounted) {
      showActionToast(context, t.referral_copied);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final isDark = context.isDarkMode;
    final onSurfaceColor = Theme.of(context).colorScheme.onSurface;
    final bgColor = isDark ? AppTheme.darkBackground : AppTheme.lightBackground;
    final surfaceColor = isDark ? AppTheme.darkSurface : AppTheme.lightSurface;
    final borderColor = isDark ? AppTheme.darkBorder : AppTheme.lightBorder;
    final textMutedColor = isDark ? AppTheme.darkTextMuted : AppTheme.lightTextMuted;
    final primaryColor = isDark ? AppTheme.darkPrimary : AppTheme.lightPrimary;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: onSurfaceColor),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          t.referral_title,
          style: TextStyle(
            fontFamily: AppTheme.fontFor(!Localizations.localeOf(context).languageCode.contains('en')),
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: onSurfaceColor,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: AppLayout.box(
            context: context,
            child: _isLoading
                ? const Padding(
                    padding: EdgeInsets.only(top: 120),
                    child: Center(child: CircularProgressIndicator()),
                  )
                : _errorKey != null
                    ? _buildError(t, onSurfaceColor, primaryColor, errorColor: AppTheme.lightError)
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.card_giftcard, size: 44, color: primaryColor),
                          const SizedBox(height: 12),
                          Text(
                            t.referral_subtitle,
                            style: AppTheme.bodyLarge.copyWith(color: textMutedColor),
                          ),
                          const SizedBox(height: 28),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: surfaceColor,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: borderColor),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  t.referral_your_code,
                                  style: AppTheme.bodySmall.copyWith(color: textMutedColor),
                                ),
                                const SizedBox(height: 8),
                                SelectableText(
                                  _code ?? '',
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 4,
                                    color: primaryColor,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                SizedBox(
                                  width: double.infinity,
                                  height: 48,
                                  child: ElevatedButton.icon(
                                    onPressed: _copyCode,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: primaryColor,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      elevation: 0,
                                    ),
                                    icon: const Icon(Icons.copy, size: 18),
                                    label: Text(t.referral_copy, style: AppTheme.buttonText),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          if (_shareText != null && _shareText!.isNotEmpty) ...[
                            Text(
                              _shareText!,
                              style: AppTheme.bodyMedium.copyWith(color: textMutedColor),
                            ),
                            const SizedBox(height: 20),
                          ],
                          Row(
                            children: [
                              Expanded(
                                child: _buildStatCard(
                                  icon: Icons.group_outlined,
                                  value: '$_successfulReferrals',
                                  label: t.referral_stats_successful,
                                  isDark: isDark,
                                  surfaceColor: surfaceColor,
                                  borderColor: borderColor,
                                  onSurfaceColor: onSurfaceColor,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildStatCard(
                                  icon: Icons.star_outline,
                                  value: '$_totalDays',
                                  label: t.referral_stats_days,
                                  isDark: isDark,
                                  surfaceColor: surfaceColor,
                                  borderColor: borderColor,
                                  onSurfaceColor: onSurfaceColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
    required bool isDark,
    required Color surfaceColor,
    required Color borderColor,
    required Color onSurfaceColor,
  }) {
    final textMutedColor = isDark ? AppTheme.darkTextMuted : AppTheme.lightTextMuted;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 22, color: textMutedColor),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: onSurfaceColor,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppTheme.bodySmall.copyWith(color: textMutedColor),
          ),
        ],
      ),
    );
  }

  Widget _buildError(AppLocalizations t, Color onSurfaceColor, Color primaryColor, {required Color errorColor}) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, size: 48, color: errorColor),
          const SizedBox(height: 12),
          Text(
            _errorKey == 'referral_load_error' ? t.referral_load_error : t.error_something_wrong,
            style: AppTheme.bodyLarge.copyWith(color: onSurfaceColor),
          ),
          const SizedBox(height: 16),
          OutlinedButton(onPressed: _load, child: Text(t.splash_retry)),
        ],
      ),
    );
  }
}
