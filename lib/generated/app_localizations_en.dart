// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get welcome_title => 'Hugsy';

  @override
  String get welcome_subtitle => 'Connect with people around you';

  @override
  String get email_label => 'Email';

  @override
  String get sign_up_button => 'Sign Up';

  @override
  String get or => 'OR';

  @override
  String get continue_with_google => 'Continue with Google';

  @override
  String get already_have_account => 'Already have an account?';

  @override
  String get login_button => 'Login';

  @override
  String get join_community_text =>
      'Join a community of intentional individuals seeking meaningful relationships';

  @override
  String get enter_email_hint => 'Enter your email';

  @override
  String get enter_password_hint => 'Enter your password';

  @override
  String get terms_and_policy =>
      'By continuing, you agree to our Terms of Service and Privacy Policy';

  @override
  String get select_language => 'Select Language';

  @override
  String get cancel => 'Cancel';

  @override
  String get english => 'English';

  @override
  String get persian => 'Persian';

  @override
  String get sign_in => 'Sign in';

  @override
  String get email_required => 'Email is required';

  @override
  String get email_invalid => 'Please enter a valid email';

  @override
  String get password_required => 'Password is required';

  @override
  String get password_min_length => 'Password must be at least 8 characters';
}
