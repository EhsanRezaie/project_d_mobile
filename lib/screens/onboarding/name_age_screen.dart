import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dating_app/generated/app_localizations.dart';
import 'package:dating_app/providers/language_provider.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  static const Color colorBackground = Color(0xFFFBF9F9);
  static const Color colorPrimaryNavy = Color(0xFF001F3F);
  static const Color colorSecondarySurface = Color.fromARGB(255, 224, 229, 231);
  static const Color colorBorder = Color(0xFFE0E5EB);
  static const Color colorTextMuted = Color(0xFF707070);

  @override
  void initState() {
    super.initState();
    _emailFocusNode.addListener(() {
      setState(() {});
    });
    _passwordFocusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _showLanguageSelector() {
    final l10n = AppLocalizations.of(context)!;
    final languageProvider = context.read<LanguageProvider>();
    final isEnglish = languageProvider.isEnglish;
    
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          backgroundColor: Colors.white,
          child: Container(
            padding: const EdgeInsets.all(24.0),
            width: 320.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.select_language,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                    color: colorPrimaryNavy,
                  ),
                ),
                const SizedBox(height: 16.0),
                const Divider(color: colorBorder),
                const SizedBox(height: 16.0),
                _LanguageOption(
                  languageCode: 'EN',
                  languageName: l10n.english,
                  flag: '🇺🇸',
                  isSelected: isEnglish,
                  onTap: () {
                    languageProvider.changeLanguage('en');
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(height: 12.0),
                _LanguageOption(
                  languageCode: 'FA',
                  languageName: l10n.persian,
                  flag: '🇮🇷',
                  isSelected: !isEnglish,
                  onTap: () {
                    languageProvider.changeLanguage('fa');
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(height: 16.0),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    l10n.cancel,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16.0,
                      color: colorTextMuted,
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final languageProvider = context.watch<LanguageProvider>();
    final currentLanguage = languageProvider.currentLanguageCode.toUpperCase();
    
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: colorBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: _showLanguageSelector,
                      icon: const Icon(
                        Icons.language,
                        size: 18.0,
                        color: colorTextMuted,
                      ),
                      label: Text(
                        currentLanguage,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                          color: colorTextMuted,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12.0,
                          vertical: 8.0,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32.0),
                Text(
                  l10n.welcome_title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 40.0,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.8,
                    color: colorPrimaryNavy,
                  ),
                ),
                const SizedBox(height: 16.0),
                Text(
                  l10n.welcome_subtitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 28.0,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.28,
                    color: colorPrimaryNavy,
                  ),
                ),
                const SizedBox(height: 12.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    l10n.join_community_text,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16.0,
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                      color: colorTextMuted,
                    ),
                  ),
                ),
                const SizedBox(height: 32.0),
                // Email TextField
                TextField(
                  controller: _emailController,
                  focusNode: _emailFocusNode,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16.0,
                    color: colorPrimaryNavy,
                  ),
                  decoration: InputDecoration(
                    hintText: l10n.enter_email_hint,
                    hintStyle: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16.0,
                      color: colorTextMuted,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 16.0,
                    ),
                    filled: true,
                    fillColor: colorBackground,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.0),
                      borderSide: const BorderSide(
                        color: colorBorder,
                        width: 1.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.0),
                      borderSide: const BorderSide(
                        color: colorPrimaryNavy,
                        width: 2.0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                // Password TextField
                TextField(
                  controller: _passwordController,
                  focusNode: _passwordFocusNode,
                  obscureText: true,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16.0,
                    color: colorPrimaryNavy,
                  ),
                  decoration: InputDecoration(
                    hintText: l10n.enter_password_hint,
                    hintStyle: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16.0,
                      color: colorTextMuted,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 16.0,
                    ),
                    filled: true,
                    fillColor: colorBackground,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.0),
                      borderSide: const BorderSide(
                        color: colorBorder,
                        width: 1.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.0),
                      borderSide: const BorderSide(
                        color: colorPrimaryNavy,
                        width: 2.0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24.0),
                // Continue Button
                Container(
                  height: 56.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x14001F3F),
                        offset: Offset(0, 12),
                        blurRadius: 32.0,
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorPrimaryNavy,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      elevation: 0,
                      minimumSize: const Size(double.infinity, 56),
                    ),
                    child: Text(
                      l10n.sign_up_button,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32.0),
                // OR Divider
                Row(
                  children: [
                    const Expanded(child: Divider(color: colorBorder, thickness: 1.0)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        l10n.or,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12.0,
                          fontWeight: FontWeight.w500,
                          color: colorTextMuted,
                        ),
                      ),
                    ),
                    const Expanded(child: Divider(color: Color(0xFFE0E5EB), thickness: 1.0)),
                  ],
                ),
                const SizedBox(height: 32.0),
                // Google Button
                SizedBox(
                  height: 56.0,
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: Image.asset(
                      'assets/images/google_logo.png',
                      height: 24.0,
                      width: 24.0,
                      fit: BoxFit.contain,
                    ),
                    label: Text(
                      l10n.continue_with_google,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: colorSecondarySurface,
                      foregroundColor: colorPrimaryNavy,
                      side: BorderSide.none,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 48.0),
                // Sign in link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${l10n.already_have_account} ',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16.0,
                        color: colorTextMuted,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        l10n.sign_in,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                          color: colorPrimaryNavy,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                // Terms and Policy
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(
                    l10n.terms_and_policy,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12.0,
                      fontWeight: FontWeight.w400,
                      height: 1.4,
                      color: colorTextMuted,
                    ),
                  ),
                ),
                const SizedBox(height: 24.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LanguageOption extends StatelessWidget {
  final String languageCode;
  final String languageName;
  final String flag;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageOption({
    required this.languageCode,
    required this.languageName,
    required this.flag,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE8EDF5) : Colors.transparent,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: isSelected ? const Color(0xFF001F3F) : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Text(
              flag,
              style: const TextStyle(fontSize: 24.0),
            ),
            const SizedBox(width: 16.0),
            Text(
              languageName,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16.0,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? const Color(0xFF001F3F) : const Color(0xFF707070),
              ),
            ),
            const Spacer(),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: Color(0xFF001F3F),
                size: 24.0,
              ),
          ],
        ),
      ),
    );
  }
}