import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fa.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fa'),
  ];

  /// No description provided for @app_title.
  ///
  /// In en, this message translates to:
  /// **'Bondi'**
  String get app_title;

  /// No description provided for @welcome_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Connect with people around you'**
  String get welcome_subtitle;

  /// No description provided for @email_label.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email_label;

  /// No description provided for @sign_in_button.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get sign_in_button;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get or;

  /// No description provided for @continue_with_google.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continue_with_google;

  /// No description provided for @dont_have_an_account.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dont_have_an_account;

  /// No description provided for @login_button.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login_button;

  /// No description provided for @join_community_text.
  ///
  /// In en, this message translates to:
  /// **'Join a community of intentional individuals seeking meaningful relationships'**
  String get join_community_text;

  /// No description provided for @enter_email_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get enter_email_hint;

  /// No description provided for @enter_password_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enter_password_hint;

  /// No description provided for @terms_and_policy.
  ///
  /// In en, this message translates to:
  /// **'By continuing, you agree to our Terms of Service and Privacy Policy'**
  String get terms_and_policy;

  /// No description provided for @select_language.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get select_language;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @persian.
  ///
  /// In en, this message translates to:
  /// **'Persian'**
  String get persian;

  /// No description provided for @sign_up.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get sign_up;

  /// No description provided for @sign_in.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get sign_in;

  /// No description provided for @email_required.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get email_required;

  /// No description provided for @email_invalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get email_invalid;

  /// No description provided for @password_required.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get password_required;

  /// No description provided for @password_min_length.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get password_min_length;

  /// No description provided for @splash_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Find Your Match'**
  String get splash_subtitle;

  /// No description provided for @splash_connecting.
  ///
  /// In en, this message translates to:
  /// **'Connecting to server...'**
  String get splash_connecting;

  /// No description provided for @splash_check_internet.
  ///
  /// In en, this message translates to:
  /// **'Please check your internet connection'**
  String get splash_check_internet;

  /// No description provided for @splash_retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get splash_retry;

  /// No description provided for @splash_connection_failed.
  ///
  /// In en, this message translates to:
  /// **'Connection failed'**
  String get splash_connection_failed;

  /// No description provided for @signup_title.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get signup_title;

  /// No description provided for @signup_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Join us and find your match'**
  String get signup_subtitle;

  /// No description provided for @signup_email_label.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get signup_email_label;

  /// No description provided for @signup_password_label.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get signup_password_label;

  /// No description provided for @signup_confirm_password_label.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get signup_confirm_password_label;

  /// No description provided for @signup_button.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signup_button;

  /// No description provided for @signup_already_have_account.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get signup_already_have_account;

  /// No description provided for @signup_email_required.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get signup_email_required;

  /// No description provided for @signup_email_invalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get signup_email_invalid;

  /// No description provided for @signup_password_required.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get signup_password_required;

  /// No description provided for @signup_password_min_length.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get signup_password_min_length;

  /// No description provided for @signup_confirm_password_required.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password'**
  String get signup_confirm_password_required;

  /// No description provided for @signup_passwords_do_not_match.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get signup_passwords_do_not_match;

  /// No description provided for @signin_button.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signin_button;

  /// No description provided for @signup_email_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get signup_email_hint;

  /// No description provided for @signup_password_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get signup_password_hint;

  /// No description provided for @signup_confirm_password_hint.
  ///
  /// In en, this message translates to:
  /// **'Confirm your password'**
  String get signup_confirm_password_hint;

  /// No description provided for @verify_title.
  ///
  /// In en, this message translates to:
  /// **'Verify Your Email'**
  String get verify_title;

  /// No description provided for @verify_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit code sent to'**
  String get verify_subtitle;

  /// No description provided for @verify_code_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter 6-digit code'**
  String get verify_code_hint;

  /// No description provided for @verify_resend.
  ///
  /// In en, this message translates to:
  /// **'Resend Code'**
  String get verify_resend;

  /// No description provided for @verify_button.
  ///
  /// In en, this message translates to:
  /// **'Verify & Continue'**
  String get verify_button;

  /// No description provided for @verify_referral_hint.
  ///
  /// In en, this message translates to:
  /// **'Referral code (optional)'**
  String get verify_referral_hint;

  /// No description provided for @verify_referral_bonus.
  ///
  /// In en, this message translates to:
  /// **'💡 Get 3 days of premium free with a referral code'**
  String get verify_referral_bonus;

  /// No description provided for @login_email_required.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get login_email_required;

  /// No description provided for @login_email_invalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get login_email_invalid;

  /// No description provided for @login_password_required.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get login_password_required;

  /// No description provided for @login_password_invalid.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get login_password_invalid;

  /// No description provided for @verify_resend_success.
  ///
  /// In en, this message translates to:
  /// **'New verification code sent to your email'**
  String get verify_resend_success;

  /// No description provided for @verify_resend_failed.
  ///
  /// In en, this message translates to:
  /// **'Failed to resend code'**
  String get verify_resend_failed;

  /// No description provided for @verify_code_required.
  ///
  /// In en, this message translates to:
  /// **'Please enter the 6-digit code'**
  String get verify_code_required;

  /// No description provided for @settings_title.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings_title;

  /// No description provided for @settings_appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settings_appearance;

  /// No description provided for @settings_dark_mode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get settings_dark_mode;

  /// No description provided for @settings_dark_mode_desc.
  ///
  /// In en, this message translates to:
  /// **'Use dark theme throughout the app'**
  String get settings_dark_mode_desc;

  /// No description provided for @settings_privacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get settings_privacy;

  /// No description provided for @settings_hide_last_seen.
  ///
  /// In en, this message translates to:
  /// **'Hide Last Seen'**
  String get settings_hide_last_seen;

  /// No description provided for @settings_hide_last_seen_desc.
  ///
  /// In en, this message translates to:
  /// **'Don\'t show when you were last active'**
  String get settings_hide_last_seen_desc;

  /// No description provided for @settings_hide_online_status.
  ///
  /// In en, this message translates to:
  /// **'Hide Online Status'**
  String get settings_hide_online_status;

  /// No description provided for @settings_hide_online_status_desc.
  ///
  /// In en, this message translates to:
  /// **'Don\'t show when you\'re online'**
  String get settings_hide_online_status_desc;

  /// No description provided for @settings_notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get settings_notifications;

  /// No description provided for @settings_push_notifications.
  ///
  /// In en, this message translates to:
  /// **'Push Notifications'**
  String get settings_push_notifications;

  /// No description provided for @settings_push_notifications_desc.
  ///
  /// In en, this message translates to:
  /// **'Receive push notifications'**
  String get settings_push_notifications_desc;

  /// No description provided for @settings_like_notifications.
  ///
  /// In en, this message translates to:
  /// **'Like Notifications'**
  String get settings_like_notifications;

  /// No description provided for @settings_like_notifications_desc.
  ///
  /// In en, this message translates to:
  /// **'Get notified when someone likes you'**
  String get settings_like_notifications_desc;

  /// No description provided for @settings_match_notifications.
  ///
  /// In en, this message translates to:
  /// **'Match Notifications'**
  String get settings_match_notifications;

  /// No description provided for @settings_match_notifications_desc.
  ///
  /// In en, this message translates to:
  /// **'Get notified when you get a match'**
  String get settings_match_notifications_desc;

  /// No description provided for @settings_message_notifications.
  ///
  /// In en, this message translates to:
  /// **'Message Notifications'**
  String get settings_message_notifications;

  /// No description provided for @settings_message_notifications_desc.
  ///
  /// In en, this message translates to:
  /// **'Get notified when you receive a message'**
  String get settings_message_notifications_desc;

  /// No description provided for @settings_language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settings_language;

  /// No description provided for @settings_language_desc.
  ///
  /// In en, this message translates to:
  /// **'Choose your preferred language'**
  String get settings_language_desc;

  /// No description provided for @error_email_exists.
  ///
  /// In en, this message translates to:
  /// **'This email is already registered'**
  String get error_email_exists;

  /// No description provided for @error_email_invalid_format.
  ///
  /// In en, this message translates to:
  /// **'Invalid email format'**
  String get error_email_invalid_format;

  /// No description provided for @error_too_many_attempts.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Please wait a moment'**
  String get error_too_many_attempts;

  /// No description provided for @error_network.
  ///
  /// In en, this message translates to:
  /// **'Connection error. Please check your internet'**
  String get error_network;

  /// No description provided for @error_something_wrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again'**
  String get error_something_wrong;

  /// No description provided for @error_email_not_found.
  ///
  /// In en, this message translates to:
  /// **'Email not found. Please start over'**
  String get error_email_not_found;

  /// No description provided for @error_verification_failed.
  ///
  /// In en, this message translates to:
  /// **'Verification failed'**
  String get error_verification_failed;

  /// No description provided for @error_invalid_code.
  ///
  /// In en, this message translates to:
  /// **'Invalid or expired verification code'**
  String get error_invalid_code;

  /// No description provided for @error_profile_complete_failed.
  ///
  /// In en, this message translates to:
  /// **'Profile completion failed'**
  String get error_profile_complete_failed;

  /// No description provided for @error_profile_already_complete.
  ///
  /// In en, this message translates to:
  /// **'Profile is already complete'**
  String get error_profile_already_complete;

  /// No description provided for @error_session_expired.
  ///
  /// In en, this message translates to:
  /// **'Session expired. Please login again'**
  String get error_session_expired;

  /// No description provided for @error_invalid_data.
  ///
  /// In en, this message translates to:
  /// **'Invalid data provided'**
  String get error_invalid_data;

  /// No description provided for @error_login_failed.
  ///
  /// In en, this message translates to:
  /// **'Login failed'**
  String get error_login_failed;

  /// No description provided for @error_wrong_credentials.
  ///
  /// In en, this message translates to:
  /// **'Incorrect email or password'**
  String get error_wrong_credentials;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fa'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fa':
      return AppLocalizationsFa();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
