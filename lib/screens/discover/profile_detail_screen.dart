import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dating_app/config/app_theme.dart';
import 'package:dating_app/generated/app_localizations.dart';
import 'package:dating_app/models/discover_profile.dart';
import 'package:dating_app/widgets/shimmer_avatar.dart';
import 'package:dating_app/widgets/discover_action_button.dart';

class ProfileDetailScreen extends StatefulWidget {
  final DiscoverProfile profile;
  final Map<String, String> interestIcons;
  final VoidCallback? onSwipeLeft;
  final VoidCallback? onSwipeRight;
  final VoidCallback? onChat;

  const ProfileDetailScreen({
    super.key,
    required this.profile,
    this.interestIcons = const {},
    this.onSwipeLeft,
    this.onSwipeRight,
    this.onChat,
  });

  @override
  State<ProfileDetailScreen> createState() => _ProfileDetailScreenState();
}

class _ProfileDetailScreenState extends State<ProfileDetailScreen> {
  int _currentPhotoIndex = 0;
  late ScrollController _photoStripController;

  @override
  void initState() {
    super.initState();
    _photoStripController = ScrollController();
  }

  @override
  void dispose() {
    _photoStripController.dispose();
    super.dispose();
  }

  DiscoverProfile get profile => widget.profile;

  List<String> get allPhotos {
    final photos = <String>[];
    if (profile.mainPhotoUrl != null && profile.mainPhotoUrl!.isNotEmpty) {
      photos.add(profile.mainPhotoUrl!);
    }
    photos.addAll(profile.photos.where((p) => p != profile.mainPhotoUrl));
    return photos;
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final isDark = context.isDarkMode;
    final primaryColor = isDark ? AppTheme.darkPrimary : AppTheme.lightPrimary;
    final bgColor = isDark ? AppTheme.darkBackground : AppTheme.lightBackground;
    final surfaceColor = isDark ? AppTheme.darkSurface : AppTheme.lightSurface;
    final textColor = isDark ? AppTheme.darkText : AppTheme.lightText;
    final mutedColor = isDark ? AppTheme.darkTextMuted : AppTheme.lightTextMuted;
    final borderColor = isDark ? AppTheme.darkBorder : AppTheme.lightBorder;

    final photos = allPhotos;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: _buildHeaderSection(
                      t, isDark, primaryColor, mutedColor, textColor, surfaceColor, borderColor, photos,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: _buildBodySection(
                      t, isDark, primaryColor, mutedColor, textColor, surfaceColor, borderColor,
                    ),
                  ),
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: SizedBox(height: 80),
                  ),
                ],
              ),
            ),
            _buildBottomActionBar(t, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection(
    AppLocalizations t,
    bool isDark,
    Color primaryColor,
    Color mutedColor,
    Color textColor,
    Color surfaceColor,
    Color borderColor,
    List<String> photos,
  ) {
    return Column(
      children: [
        Stack(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.42,
              width: double.infinity,
              child: photos.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: _getDisplayUrl(photos[_currentPhotoIndex]),
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const ShimmerAvatar(),
                      errorWidget: (context, url, error) => Container(
                        color: isDark ? AppTheme.darkSecondary : Colors.grey.shade200,
                        child: Icon(Icons.person, size: 80,
                            color: isDark ? AppTheme.darkTextMuted : Colors.grey),
                      ),
                    )
                  : Container(
                      color: isDark ? AppTheme.darkSecondary : Colors.grey.shade200,
                      child: Icon(Icons.person, size: 80,
                          color: isDark ? AppTheme.darkTextMuted : Colors.grey),
                    ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.4),
                    Colors.transparent,
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                  stops: const [0.0, 0.2, 0.6, 1.0],
                ),
              ),
            ),
            Positioned(
              top: 8,
              left: 8,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, color: Colors.white, size: 22),
                ),
              ),
            ),
            if (photos.length > 1)
              Positioned(
                bottom: 60,
                left: 0,
                right: 0,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(photos.length, (index) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        width: _currentPhotoIndex == index ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentPhotoIndex == index
                              ? Colors.white
                              : Colors.white.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        profile.name,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${profile.age}',
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 24,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Icon(
                        profile.gender == 'male' ? Icons.male : Icons.female,
                        size: 20,
                        color: profile.gender == 'male'
                            ? (isDark ? AppTheme.darkPrimary : AppTheme.lightPrimary)
                            : (isDark ? AppTheme.darkError : AppTheme.lightError),
                      ),
                      if (profile.isPremium) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: isDark ? AppTheme.darkError : AppTheme.lightError,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.workspace_premium, size: 12, color: Colors.white),
                              const SizedBox(width: 3),
                              Text(t.discover_premium,
                                  style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white)),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      if (profile.distanceKm != null) ...[
                        Icon(Icons.near_me, size: 14, color: Colors.white.withOpacity(0.8)),
                        const SizedBox(width: 4),
                        Text(
                          t.discover_km_away(profile.distanceKm!.round()),
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                        const SizedBox(width: 12),
                      ],
                      if (profile.locationDisplay.isNotEmpty) ...[
                        Icon(Icons.location_on, size: 14, color: Colors.white.withOpacity(0.8)),
                        const SizedBox(width: 4),
                        Text(
                          profile.locationDisplay,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13,
                            color: Colors.white.withOpacity(0.85),
                          ),
                        ),
                      ],
                      if (profile.isVerified) ...[
                        const SizedBox(width: 8),
                        Icon(Icons.verified, size: 16,
                            color: isDark ? AppTheme.darkPrimary : AppTheme.lightPrimary),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        if (photos.length > 1)
          SizedBox(
            height: 64,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              controller: _photoStripController,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: photos.length,
              itemBuilder: (context, index) {
                final isSelected = _currentPhotoIndex == index;
                return GestureDetector(
                  onTap: () {
                    setState(() => _currentPhotoIndex = index);
                  },
                  child: Container(
                    width: 56,
                    height: 56,
                    margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected ? primaryColor : Colors.transparent,
                        width: 2.5,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        imageUrl: _getDisplayUrl(photos[index]),
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: isDark ? AppTheme.darkSecondary : Colors.grey.shade200,
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: isDark ? AppTheme.darkSecondary : Colors.grey.shade200,
                          child: const Icon(Icons.broken_image, size: 20),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildBodySection(
    AppLocalizations t,
    bool isDark,
    Color primaryColor,
    Color mutedColor,
    Color textColor,
    Color surfaceColor,
    Color borderColor,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (profile.bio != null && profile.bio!.isNotEmpty)
            _buildBioSection(t, isDark, primaryColor, mutedColor, textColor, surfaceColor, borderColor),
          _buildSection(
            emoji: '💪',
            title: t.profile_section_physical,
            children: [
              if (profile.height != null)
                _buildInfoRow(Icons.height, t.profile_label_height, '${profile.height} cm', textColor, mutedColor, primaryColor),
              if (profile.weight != null)
                _buildInfoRow(Icons.monitor_weight_outlined, t.profile_label_weight, '${profile.weight} kg', textColor, mutedColor, primaryColor),
              if (profile.bodyType != null)
                _buildInfoRow(Icons.fitness_center, t.profile_label_body_type, _capitalize(profile.bodyType!), textColor, mutedColor, primaryColor),
            ],
            mutedColor: mutedColor,
            primaryColor: primaryColor,
          ),
          _buildSection(
            emoji: '🏠',
            title: t.profile_section_lifestyle,
            children: [
              if (profile.relationshipStatus != null)
                _buildInfoRow(Icons.favorite_outline, t.profile_label_relationship, _capitalize(profile.relationshipStatus!), textColor, mutedColor, primaryColor),
              if (profile.livingSituation != null)
                _buildInfoRow(Icons.home_outlined, t.profile_label_living_situation, _formatLiving(profile.livingSituation!), textColor, mutedColor, primaryColor),
              if (profile.childrenStatus != null)
                _buildInfoRow(Icons.child_care_outlined, t.profile_label_children, _formatChildren(profile.childrenStatus!), textColor, mutedColor, primaryColor),
              if (profile.smoking != null)
                _buildInfoRow(Icons.smoking_rooms_outlined, t.profile_label_smoking, _capitalize(profile.smoking!), textColor, mutedColor, primaryColor),
              if (profile.drinking != null)
                _buildInfoRow(Icons.local_bar_outlined, t.profile_label_drinking, _capitalize(profile.drinking!), textColor, mutedColor, primaryColor),
            ],
            mutedColor: mutedColor,
            primaryColor: primaryColor,
          ),
          _buildSection(
            emoji: '🌍',
            title: t.profile_section_background,
            children: [
              if (profile.education != null)
                _buildInfoRow(Icons.school_outlined, t.profile_label_education, _formatEducation(profile.education!), textColor, mutedColor, primaryColor),
              if (profile.workplace != null && profile.workplace!.isNotEmpty)
                _buildInfoRow(Icons.work_outline, t.profile_label_work, profile.workplace!, textColor, mutedColor, primaryColor),
              if (profile.religion != null)
                _buildInfoRow(Icons.church_outlined, t.profile_label_religion, _capitalize(profile.religion!), textColor, mutedColor, primaryColor),
              if (profile.ethnicity != null)
                _buildInfoRow(Icons.public_outlined, t.profile_label_ethnicity, _capitalize(profile.ethnicity!), textColor, mutedColor, primaryColor),
              if (profile.politicalOrientation != null)
                _buildInfoRow(Icons.how_to_vote_outlined, t.profile_label_politics, _capitalize(profile.politicalOrientation!), textColor, mutedColor, primaryColor),
            ],
            mutedColor: mutedColor,
            primaryColor: primaryColor,
          ),
          if (profile.languages != null && profile.languages!.isNotEmpty)
            _buildChipsSection(
              emoji: '🗣️',
              title: t.profile_section_languages,
              items: profile.languages!,
              isDark: isDark,
              primaryColor: primaryColor,
              mutedColor: mutedColor,
              textColor: textColor,
              borderColor: borderColor,
            ),
          if (profile.interests.isNotEmpty)
            _buildChipsSection(
              emoji: '❤️',
              title: t.profile_section_interests,
              items: profile.interests,
              iconMap: widget.interestIcons,
              isDark: isDark,
              primaryColor: primaryColor,
              mutedColor: mutedColor,
              textColor: textColor,
              borderColor: borderColor,
            ),
          if (profile.prompts.isNotEmpty)
            _buildPromptsSection(
              t: t,
              isDark: isDark,
              mutedColor: mutedColor,
              textColor: textColor,
              surfaceColor: surfaceColor,
              borderColor: borderColor,
              primaryColor: primaryColor,
            ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildBioSection(
    AppLocalizations t,
    bool isDark,
    Color primaryColor,
    Color mutedColor,
    Color textColor,
    Color surfaceColor,
    Color borderColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Row(
          children: [
            const Text('🔥', style: TextStyle(fontSize: 20)),
            const SizedBox(width: 8),
            Text(
              t.profile_section_about,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: primaryColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: borderColor.withOpacity(0.5)),
          ),
          child: Text(
            profile.bio!,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 15,
              height: 1.5,
              color: textColor,
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildSection({
    required String emoji,
    required String title,
    required List<Widget> children,
    required Color mutedColor,
    required Color primaryColor,
  }) {
    if (children.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: primaryColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ...children,
      ],
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String label,
    String value,
    Color textColor,
    Color mutedColor,
    Color primaryColor,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: primaryColor),
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              color: mutedColor,
            ),
          ),
          const Spacer(),
          Flexible(
            child: Text(
              value,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChipsSection({
    required String emoji,
    required String title,
    required List<String> items,
    Map<String, String> iconMap = const {},
    required bool isDark,
    required Color primaryColor,
    required Color mutedColor,
    required Color textColor,
    required Color borderColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: primaryColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: items.map((item) {
            final icon = iconMap[item];
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isDark ? Colors.white10 : primaryColor.withOpacity(0.06),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                icon != null ? '$icon $item' : item,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPromptsSection({
    required AppLocalizations t,
    required bool isDark,
    required Color mutedColor,
    required Color textColor,
    required Color surfaceColor,
    required Color borderColor,
    required Color primaryColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Row(
          children: [
            const Text('💬', style: TextStyle(fontSize: 20)),
            const SizedBox(width: 8),
            Text(
              t.profile_section_prompts,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: primaryColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ...profile.prompts.map((prompt) {
          final question = prompt['question'] as String? ?? '';
          final answer = prompt['answer'] as String? ?? '';
          if (answer.isEmpty) return const SizedBox.shrink();
          return Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: borderColor.withOpacity(0.5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  question,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: primaryColor,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  answer,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 15,
                    height: 1.4,
                    color: textColor,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildBottomActionBar(AppLocalizations t, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkSurface : Colors.white,
        border: Border(
          top: BorderSide(
            color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder,
            width: 0.5,
          ),
        ),
      ),
      padding: EdgeInsets.only(
        top: 10,
        bottom: MediaQuery.of(context).padding.bottom > 0 ? 10 : 10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DiscoverActionButton(
            icon: Icons.close_rounded,
            gradient: AppTheme.rejectGradient(isDark: isDark),
            size: 52,
            onPressed: widget.onSwipeLeft,
          ),
          const SizedBox(width: 20),
          DiscoverActionButton(
            icon: Icons.chat_bubble_rounded,
            gradient: AppTheme.chatGradient(isDark: isDark),
            size: 58,
            onPressed: widget.onChat,
          ),
          const SizedBox(width: 20),
          DiscoverActionButton(
            icon: Icons.favorite_rounded,
            gradient: AppTheme.likeGradient(isDark: isDark),
            size: 52,
            onPressed: widget.onSwipeRight,
          ),
        ],
      ),
    );
  }

  String _getDisplayUrl(String url) {
    if (url.isEmpty) return '';
    if (url.contains('localhost')) {
      return url.replaceAll('localhost', '10.0.2.2');
    }
    return url;
  }

  String _capitalize(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1);
  }

  String _formatLiving(String value) {
    switch (value.toLowerCase()) {
      case 'alone':
        return 'Alone';
      case 'with_family':
        return 'With Family';
      case 'with_roommate':
        return 'With Roommates';
      case 'with_partner':
        return 'With Partner';
      default:
        return _capitalize(value);
    }
  }

  String _formatChildren(String value) {
    switch (value.toLowerCase()) {
      case 'have':
        return 'Have children';
      case 'dont_have':
        return 'Don\'t have children';
      case 'want':
        return 'Want children';
      case 'dont_want':
        return 'Don\'t want children';
      default:
        return _capitalize(value);
    }
  }

  String _formatEducation(String value) {
    switch (value.toLowerCase()) {
      case 'high_school':
        return 'High School';
      case 'bachelor':
        return 'Undergraduate Degree';
      case 'master':
        return 'Postgraduate Degree';
      case 'phd':
        return 'PhD / Doctorate';
      default:
        return _capitalize(value);
    }
  }
}
