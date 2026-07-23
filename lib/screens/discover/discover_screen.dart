import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dating_app/config/app_theme.dart';
import 'package:dating_app/generated/app_localizations.dart';
import 'package:dating_app/models/discover_profile.dart';
import 'package:dating_app/providers/discover_provider.dart';
import 'package:dating_app/services/onboarding_service.dart';
import 'package:dating_app/widgets/user_card.dart';
import 'package:dating_app/widgets/discover_action_button.dart';
import 'package:dating_app/screens/discover/profile_detail_screen.dart';

class DiscoverScreen extends StatefulWidget {
  final VoidCallback? onSwitchToChats;

  const DiscoverScreen({super.key, this.onSwitchToChats});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  Map<String, String> _interestIcons = {};

  @override
  void initState() {
    super.initState();
    _loadInterestIcons();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<DiscoverProvider>(context, listen: false);
      if (provider.profiles.isEmpty && !provider.isLoading) {
        provider.loadProfiles();
      }
    });
  }

  Future<void> _loadInterestIcons() async {
    final interests = await OnboardingService.getInterests();
    if (!mounted) return;
    final map = <String, String>{};
    for (final i in interests) {
      if (i.icon != null && i.icon!.isNotEmpty) {
        map[i.name] = i.icon!;
      }
    }
    setState(() { _interestIcons = map; });
  }

  Future<void> _handleSwipeRight(DiscoverProfile profile) async {
    if (!mounted) return;
    final provider = Provider.of<DiscoverProvider>(context, listen: false);
    final result = await provider.swipeRight(profile);
    if (result != null && result['matched'] == true && mounted) {
      _showMatchDialog(result, profile);
    }
  }

  Future<void> _handleSwipeLeft(DiscoverProfile profile) async {
    if (!mounted) return;
    final provider = Provider.of<DiscoverProvider>(context, listen: false);
    await provider.swipeLeft(profile);
  }

  Future<void> _handleChat(DiscoverProfile profile) async {
    if (!mounted) return;
    final message = await _showChatBottomSheet();
    if (message == null) return;
    if (!mounted) return;

    final provider = Provider.of<DiscoverProvider>(context, listen: false);
    final result = await provider.swipeAndChat(profile, message: message);

    if (result != null && result['matched'] == true && mounted) {
      _showMatchDialog(result, profile, messageSent: result['message_sent'] == true);
    }
  }

  Future<String?> _showChatBottomSheet() async {
    final t = AppLocalizations.of(context)!;
    final controller = TextEditingController();
    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final isDark = ctx.isDarkMode;
        return Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDark ? AppTheme.darkSurface : Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isDark ? AppTheme.darkBorder : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  t.discover_say_something,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppTheme.darkText : AppTheme.lightText,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: controller,
                  autofocus: true,
                  maxLength: 200,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: t.discover_send_message_hint,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(ctx, controller.text),
                    child: Text(t.discover_send_and_like),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
    controller.dispose();
    return result;
  }

  void _showMatchDialog(Map<String, dynamic> result, DiscoverProfile profile,
      {bool messageSent = false}) {
    if (!mounted) return;
    final t = AppLocalizations.of(context)!;
    final isDark = context.isDarkMode;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return Dialog(
          backgroundColor: isDark ? AppTheme.darkSurface : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppTheme.likeGradient(isDark: isDark),
                  ),
                  child: const Icon(Icons.favorite, size: 48, color: Colors.white),
                ),
                const SizedBox(height: 16),
                Text(
                  t.discover_match_title,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppTheme.darkText : AppTheme.lightText,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  t.discover_match_subtitle(profile.name),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    color: isDark ? AppTheme.darkTextMuted : AppTheme.lightTextMuted,
                  ),
                ),
                if (messageSent) ...[
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle, size: 16,
                          color: isDark ? AppTheme.darkSuccess : AppTheme.lightSuccess),
                      const SizedBox(width: 6),
                      Text(
                        t.discover_match_message_sent,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13,
                          color: isDark ? AppTheme.darkSuccess : AppTheme.lightSuccess,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      if (mounted) {
                        _switchToChatsTab();
                      }
                    },
                    child: Text(t.discover_send_message),
                  ),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: Text(
                    t.discover_keep_swiping,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      color: isDark ? AppTheme.darkTextMuted : AppTheme.lightTextMuted,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _openProfileDetail(DiscoverProfile profile) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProfileDetailScreen(
          profile: profile,
          interestIcons: _interestIcons,
          onSwipeLeft: () => _handleSwipeLeft(profile),
          onSwipeRight: () => _handleSwipeRight(profile),
          onChat: () => _handleChat(profile),
        ),
      ),
    );
  }

  void _switchToChatsTab() {
    widget.onSwitchToChats?.call();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final isDark = context.isDarkMode;
    final primaryColor = isDark ? AppTheme.darkPrimary : AppTheme.lightPrimary;
    final bgColor = isDark ? AppTheme.darkBackground : AppTheme.lightBackground;
    final onSurfaceColor = Theme.of(context).colorScheme.onSurface;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          t.discover_title,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: onSurfaceColor,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_outlined, color: onSurfaceColor),
            onPressed: () {},
          ),
        ],
      ),
      body: Consumer<DiscoverProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading && provider.profiles.isEmpty) {
            return _buildLoadingState(t, isDark, primaryColor);
          }

          if (provider.errorMessage != null && provider.profiles.isEmpty) {
            return _buildErrorState(provider, t, isDark, primaryColor);
          }

          return Column(
            children: [
              _buildFilterBar(provider, t, isDark, primaryColor),
              _buildLimitIndicator(provider, isDark, primaryColor),
              Expanded(
                child: provider.hasProfiles
                    ? _buildCardStack(provider, isDark)
                    : _buildEmptyState(provider, t, isDark, primaryColor),
              ),
              if (provider.hasProfiles)
                _buildActionButtons(provider, t, isDark),
              const SizedBox(height: 16),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLoadingState(AppLocalizations t, bool isDark, Color primaryColor) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(color: primaryColor),
          const SizedBox(height: 16),
          Text(
            t.discover_loading,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              color: isDark ? AppTheme.darkTextMuted : AppTheme.lightTextMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(
      DiscoverProvider provider, AppLocalizations t, bool isDark, Color primaryColor) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off, size: 48,
                color: isDark ? AppTheme.darkTextMuted : AppTheme.lightTextMuted),
            const SizedBox(height: 16),
            Text(
              provider.errorMessage ?? t.error_something_wrong,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                color: isDark ? AppTheme.darkTextMuted : AppTheme.lightTextMuted,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => provider.refresh(),
              icon: const Icon(Icons.refresh),
              label: Text(t.discover_try_again),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(
      DiscoverProvider provider, AppLocalizations t, bool isDark, Color primaryColor) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.person_search, size: 64,
                color: isDark ? AppTheme.darkTextMuted : AppTheme.lightTextMuted),
            const SizedBox(height: 16),
            Text(
              t.discover_no_profiles,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: isDark ? AppTheme.darkText : AppTheme.lightText,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              t.discover_no_profiles_hint,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                color: isDark ? AppTheme.darkTextMuted : AppTheme.lightTextMuted,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => provider.refresh(),
              icon: const Icon(Icons.refresh),
              label: Text(t.discover_refresh),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterBar(DiscoverProvider provider, AppLocalizations t,
      bool isDark, Color primaryColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: [
            _buildFilterChip(
              icon: Icons.wc,
              label: provider.genderFilter != null
                  ? provider.genderFilter == 'male'
                      ? t.discover_filter_male
                      : t.discover_filter_female
                  : t.discover_filter_all,
              onTap: () => _showGenderPicker(provider),
              isDark: isDark,
              primaryColor: primaryColor,
            ),
            const SizedBox(width: 8),
            _buildFilterChip(
              icon: Icons.cake_outlined,
              label: '${provider.ageMin}-${provider.ageMax}',
              onTap: () => _showAgePicker(provider),
              isDark: isDark,
              primaryColor: primaryColor,
            ),
            const SizedBox(width: 8),
            _buildFilterChip(
              icon: Icons.near_me,
              label: '${provider.distanceKm} km',
              onTap: () => _showDistancePicker(provider),
              isDark: isDark,
              primaryColor: primaryColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool isDark,
    required Color primaryColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isDark ? AppTheme.darkSurface : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: primaryColor),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isDark ? AppTheme.darkText : AppTheme.lightText,
              ),
            ),
            const SizedBox(width: 4),
            Icon(Icons.arrow_drop_down, size: 18,
                color: isDark ? AppTheme.darkTextMuted : AppTheme.lightTextMuted),
          ],
        ),
      ),
    );
  }

  void _showGenderPicker(DiscoverProvider provider) {
    final t = AppLocalizations.of(context)!;
    final isDark = context.isDarkMode;
    final primaryColor = isDark ? AppTheme.darkPrimary : AppTheme.lightPrimary;

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppTheme.darkSurface : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                t.discover_filter_show,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppTheme.darkText : AppTheme.lightText,
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  'all',
                  'male',
                  'female',
                ].map((g) {
                  final selected = (g == 'all' && provider.genderFilter == null) ||
                      provider.genderFilter == g;
                  return ChoiceChip(
                    label: Text(
                      g == 'all' ? t.discover_filter_all : g == 'male' ? t.discover_filter_male : t.discover_filter_female,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        color: selected ? Colors.white : null,
                      ),
                    ),
                    selected: selected,
                    selectedColor: primaryColor,
                    onSelected: (_) {
                      Navigator.pop(ctx);
                      provider.setGenderFilter(g == 'all' ? null : g);
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  void _showAgePicker(DiscoverProvider provider) {
    final t = AppLocalizations.of(context)!;
    final isDark = context.isDarkMode;
    final primaryColor = isDark ? AppTheme.darkPrimary : AppTheme.lightPrimary;
    double min = provider.ageMin.toDouble();
    double max = provider.ageMax.toDouble();

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppTheme.darkSurface : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    t.discover_filter_age_range,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppTheme.darkText : AppTheme.lightText,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    t.discover_filter_years(max.round(), min.round()),
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      color: isDark ? AppTheme.darkTextMuted : AppTheme.lightTextMuted,
                    ),
                  ),
                  RangeSlider(
                    values: RangeValues(min, max),
                    min: 18,
                    max: 100,
                    divisions: 82,
                    activeColor: primaryColor,
                    labels: RangeLabels(
                      '${min.round()}',
                      '${max.round()}',
                    ),
                    onChanged: (values) {
                      setSheetState(() {
                        min = values.start;
                        max = values.end;
                      });
                    },
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        provider.setAgeRange(min.round(), max.round());
                      },
                      child: Text(t.discover_filter_apply),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showDistancePicker(DiscoverProvider provider) {
    final t = AppLocalizations.of(context)!;
    final isDark = context.isDarkMode;
    final primaryColor = isDark ? AppTheme.darkPrimary : AppTheme.lightPrimary;
    double distance = provider.distanceKm.toDouble();

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppTheme.darkSurface : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    t.discover_filter_max_distance,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppTheme.darkText : AppTheme.lightText,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${distance.round()} km',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      color: isDark ? AppTheme.darkTextMuted : AppTheme.lightTextMuted,
                    ),
                  ),
                  Slider(
                    value: distance,
                    min: 1,
                    max: 500,
                    divisions: 499,
                    activeColor: primaryColor,
                    label: '${distance.round()} km',
                    onChanged: (v) => setSheetState(() => distance = v),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        provider.setDistance(distance.round());
                      },
                      child: Text(t.discover_filter_apply),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildLimitIndicator(
      DiscoverProvider provider, bool isDark, Color primaryColor) {
    if (provider.isPremium) return const SizedBox.shrink();

    final remaining = provider.likesRemaining;
    final total = provider.dailyLikesLimit;
    final fraction = total > 0 ? remaining / total : 1.0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      child: Row(
        children: [
          Icon(Icons.favorite_border, size: 14,
              color: remaining > 0 ? primaryColor : AppTheme.darkTextMuted),
          const SizedBox(width: 6),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: fraction,
                minHeight: 4,
                backgroundColor: isDark ? AppTheme.darkBorder : Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(
                  remaining > 5
                      ? (isDark ? AppTheme.darkSuccess : AppTheme.lightSuccess)
                      : (isDark ? AppTheme.darkWarning : AppTheme.lightWarning),
                ),
              ),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            '$remaining / $total',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 11,
              color: isDark ? AppTheme.darkTextMuted : AppTheme.lightTextMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardStack(DiscoverProvider provider, bool isDark) {
    final profile = provider.visibleProfiles.isNotEmpty
        ? provider.visibleProfiles.first
        : null;
    if (profile == null) return const SizedBox.shrink();

    final cardHeight = MediaQuery.of(context).size.height * 0.55;

    return Container(
      height: cardHeight,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: UserCard(
        key: ValueKey(profile.id),
        profile: profile,
        interestIcons: _interestIcons,
        isTop: true,
        onTap: () => _openProfileDetail(profile),
        onSwipeLeft: () => _handleSwipeLeft(profile),
        onSwipeRight: () => _handleSwipeRight(profile),
      ),
    );
  }

  Widget _buildActionButtons(DiscoverProvider provider, AppLocalizations t, bool isDark) {
    final profile = provider.visibleProfiles.isNotEmpty
        ? provider.visibleProfiles.first
        : null;
    if (profile == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DiscoverActionButton(
            icon: Icons.close_rounded,
            gradient: AppTheme.rejectGradient(isDark: isDark),
            size: 56,
            onPressed: () => _handleSwipeLeft(profile),
          ),
          const SizedBox(width: 20),
          DiscoverActionButton(
            icon: Icons.chat_bubble_rounded,
            gradient: AppTheme.chatGradient(isDark: isDark),
            size: 62,
            onPressed: () => _handleChat(profile),
          ),
          const SizedBox(width: 20),
          DiscoverActionButton(
            icon: Icons.favorite_rounded,
            gradient: AppTheme.likeGradient(isDark: isDark),
            size: 56,
            onPressed: () => _handleSwipeRight(profile),
          ),
        ],
      ),
    );
  }
}
