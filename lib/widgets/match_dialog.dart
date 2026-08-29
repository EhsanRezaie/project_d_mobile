// lib/widgets/match_dialog.dart
import 'package:flutter/material.dart';
import 'package:dating_app/config/app_theme.dart';
import 'package:dating_app/generated/app_localizations.dart';
import 'package:dating_app/utils/cached_image.dart';
import 'package:dating_app/utils/responsive.dart';

/// The "It's a Match!" popup shown after a mutual like.
///
/// Shows both users' avatars side-by-side with a heart between them, then the
/// call-to-action buttons.
class MatchDialog extends StatelessWidget {
  final String? myPhotoUrl;
  final String? theirPhotoUrl;
  final String name;
  final bool messageSent;
  final VoidCallback onSendMessage;
  final VoidCallback onKeepSwiping;

  const MatchDialog({
    super.key,
    required this.myPhotoUrl,
    required this.theirPhotoUrl,
    required this.name,
    this.messageSent = false,
    required this.onSendMessage,
    required this.onKeepSwiping,
  });

  Widget _avatar(BuildContext context, String? url) {
    return Container(
      width: AppLayout.s(context, 72),
      height: AppLayout.s(context, 72),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: 0.2),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.7),
          width: 3,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: (url != null && url.isNotEmpty)
          ? CachedImage.widget(
              url,
              width: AppLayout.s(context, 72),
              height: AppLayout.s(context, 72),
              fit: BoxFit.cover,
              errorWidget: const _PersonFallback(),
            )
          : const _PersonFallback(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final isDark = context.isDarkMode;
    final isPersian = !Localizations.localeOf(
      context,
    ).languageCode.contains('en');
    final heroStyle =
        (isPersian ? AppTheme.heroDisplayFa : AppTheme.heroDisplay).copyWith(
          fontSize: 30,
        );
    final bodyStyle = (isPersian ? AppTheme.bodyFa : AppTheme.body).copyWith(
      color: Colors.white.withValues(alpha: 0.85),
      fontSize: 15,
    );

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: AppTheme.primaryGradient(),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryGradientStart.withValues(alpha: 0.4),
              blurRadius: 32,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Two avatars side-by-side (slight overlap) with a heart in the middle.
            SizedBox(
              height: AppLayout.s(context, 72),
              width: AppLayout.s(context, 72) * 2 - 16,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    left: 0,
                    child: _avatar(context, myPhotoUrl),
                  ),
                  Positioned(
                    right: 0,
                    child: _avatar(context, theirPhotoUrl),
                  ),
                  Container(
                    width: AppLayout.s(context, 40),
                    height: AppLayout.s(context, 40),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.favorite,
                      size: AppLayout.s(context, 22),
                      color: isDark
                          ? AppTheme.darkError
                          : AppTheme.lightError,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            Text(
              t.discover_match_title,
              textAlign: TextAlign.center,
              style: heroStyle.copyWith(color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              t.discover_match_subtitle(name),
              textAlign: TextAlign.center,
              style: bodyStyle,
            ),
            if (messageSent) ...[
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.check_circle,
                    size: 16,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    t.discover_match_message_sent,
                    style: bodyStyle.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: onSendMessage,
                style: AppTheme.primaryButton.copyWith(
                  backgroundColor: const WidgetStatePropertyAll<Color>(
                    Colors.white,
                  ),
                  foregroundColor: const WidgetStatePropertyAll<Color>(
                    AppTheme.primaryGradientStart,
                  ),
                  elevation: const WidgetStatePropertyAll<double>(0),
                ),
                child: Text(
                  t.discover_send_message,
                  style: (isPersian ? AppTheme.buttonFa : AppTheme.button)
                      .copyWith(color: AppTheme.primaryGradientStart),
                ),
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: onKeepSwiping,
              child: Text(
                t.discover_keep_swiping,
                style: (isPersian ? AppTheme.bodyBoldFa : AppTheme.bodyBold)
                    .copyWith(color: Colors.white, fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PersonFallback extends StatelessWidget {
  const _PersonFallback();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white.withValues(alpha: 0.2),
      child: const Icon(
        Icons.person,
        size: 34,
        color: Colors.white,
      ),
    );
  }
}
