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
/// import 'l10n/app_localizations.dart';
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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fa')
  ];

  /// No description provided for @welcome_title.
  ///
  /// In en, this message translates to:
  /// **'Find Your Match'**
  String get welcome_title;

  /// No description provided for @welcome_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Connect with people around you'**
  String get welcome_subtitle;

  /// No description provided for @login_title.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get login_title;

  /// No description provided for @register_title.
  ///
  /// In en, this message translates to:
  /// **'Join Us'**
  String get register_title;

  /// No description provided for @name_label.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get name_label;

  /// No description provided for @email_label.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email_label;

  /// No description provided for @password_label.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password_label;

  /// No description provided for @age_label.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get age_label;

  /// No description provided for @gender_label.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender_label;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @referral_code_hint.
  ///
  /// In en, this message translates to:
  /// **'Referral Code (Optional)'**
  String get referral_code_hint;

  /// No description provided for @continue_button.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continue_button;

  /// No description provided for @skip_button.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip_button;

  /// No description provided for @complete_button.
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get complete_button;

  /// No description provided for @height_title.
  ///
  /// In en, this message translates to:
  /// **'Height & Weight'**
  String get height_title;

  /// No description provided for @height_subtitle.
  ///
  /// In en, this message translates to:
  /// **'These help with match accuracy'**
  String get height_subtitle;

  /// No description provided for @height_cm.
  ///
  /// In en, this message translates to:
  /// **'cm'**
  String get height_cm;

  /// No description provided for @weight_kg.
  ///
  /// In en, this message translates to:
  /// **'kg'**
  String get weight_kg;

  /// No description provided for @photo_title.
  ///
  /// In en, this message translates to:
  /// **'Upload Profile Photo'**
  String get photo_title;

  /// No description provided for @photo_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Add at least one photo to get more matches'**
  String get photo_subtitle;

  /// No description provided for @gallery_button.
  ///
  /// In en, this message translates to:
  /// **'Choose from gallery'**
  String get gallery_button;

  /// No description provided for @camera_button.
  ///
  /// In en, this message translates to:
  /// **'Take a photo'**
  String get camera_button;

  /// No description provided for @location_title.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location_title;

  /// No description provided for @location_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Set your location to find people nearby'**
  String get location_subtitle;

  /// No description provided for @gps_option.
  ///
  /// In en, this message translates to:
  /// **'Use my current location (GPS)'**
  String get gps_option;

  /// No description provided for @manual_option.
  ///
  /// In en, this message translates to:
  /// **'Select manually'**
  String get manual_option;

  /// No description provided for @province_label.
  ///
  /// In en, this message translates to:
  /// **'Province'**
  String get province_label;

  /// No description provided for @city_label.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city_label;

  /// No description provided for @step_1.
  ///
  /// In en, this message translates to:
  /// **'Step 1 of 4'**
  String get step_1;

  /// No description provided for @step_2.
  ///
  /// In en, this message translates to:
  /// **'Step 2 of 4'**
  String get step_2;

  /// No description provided for @step_3.
  ///
  /// In en, this message translates to:
  /// **'Step 3 of 4'**
  String get step_3;

  /// No description provided for @step_4.
  ///
  /// In en, this message translates to:
  /// **'Step 4 of 4'**
  String get step_4;

  /// No description provided for @basic_info_title.
  ///
  /// In en, this message translates to:
  /// **'Basic Information'**
  String get basic_info_title;

  /// No description provided for @email_invalid.
  ///
  /// In en, this message translates to:
  /// **'Valid email required'**
  String get email_invalid;

  /// No description provided for @age_invalid.
  ///
  /// In en, this message translates to:
  /// **'Age must be 18-100'**
  String get age_invalid;

  /// No description provided for @name_required.
  ///
  /// In en, this message translates to:
  /// **'Name required'**
  String get name_required;

  /// No description provided for @email_required.
  ///
  /// In en, this message translates to:
  /// **'Email required'**
  String get email_required;

  /// No description provided for @age_required.
  ///
  /// In en, this message translates to:
  /// **'Age required'**
  String get age_required;

  /// No description provided for @gender_required.
  ///
  /// In en, this message translates to:
  /// **'Please select gender'**
  String get gender_required;

  /// No description provided for @login_button.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login_button;

  /// No description provided for @create_account_button.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get create_account_button;

  /// No description provided for @already_have_account.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get already_have_account;

  /// No description provided for @dont_have_account.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dont_have_account;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get or;

  /// No description provided for @select_gender.
  ///
  /// In en, this message translates to:
  /// **'Select gender'**
  String get select_gender;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'fa'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'fa': return AppLocalizationsFa();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
