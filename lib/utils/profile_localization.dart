// lib/utils/profile_localization.dart
import 'package:dating_app/generated/app_localizations.dart';

/// Resolves a backend enum key (e.g. 'long_term_relationship', 'open_to_children',
/// 'black / african descent') into a localized display label.
///
/// Falls back to a title-cased version of the key for unknown values — this
/// matters for religion/ethnicity which are effectively free-text.
String localizedEnum(AppLocalizations t, String? key) {
  if (key == null || key.isEmpty) return '';
  final k = key.trim().toLowerCase();
  switch (k) {
    // gender / orientation
    case 'male': return t.enum_male;
    case 'female': return t.enum_female;
    case 'straight': return t.enum_straight;
    case 'gay': return t.enum_gay;
    case 'bisexual': return t.enum_bisexual;
    case 'pansexual': return t.enum_pansexual;
    case 'asexual': return t.enum_asexual;
    // body type
    case 'slim': return t.enum_slim;
    case 'average': return t.enum_average;
    case 'athletic': return t.enum_athletic;
    case 'curvy': return t.enum_curvy;
    case 'muscular': return t.enum_muscular;
    case 'overweight':
    case 'plus size': return t.enum_overweight;
    // relationship status
    case 'single': return t.enum_single;
    case 'divorced': return t.enum_divorced;
    case 'widowed': return t.enum_widowed;
    case 'separated': return t.enum_separated;
    // living situation
    case 'alone': return t.enum_alone;
    case 'with_family': return t.enum_with_family;
    case 'with_roommate':
    case 'with_roommates': return t.enum_with_roommate;
    case 'with_partner': return t.enum_with_partner;
    // children
    case 'have_children': return t.enum_have_children;
    case 'want_children': return t.enum_want_children;
    case 'dont_want_children': return t.enum_dont_want_children;
    case 'open_to_children': return t.enum_open_to_children;
    // frequency
    case 'never': return t.enum_never;
    case 'occasionally': return t.enum_occasionally;
    case 'regularly': return t.enum_regularly;
    case 'daily': return t.enum_daily;
    case 'socially': return t.enum_socially;
    // here for
    case 'long_term_relationship': return t.enum_long_term_relationship;
    case 'casual_dating': return t.enum_casual_dating;
    case 'marriage': return t.enum_marriage;
    case 'new_friends': return t.enum_new_friends;
    case 'not_sure_yet': return t.enum_not_sure_yet;
    // pets
    case 'dog': return t.enum_dog;
    case 'cat': return t.enum_cat;
    case 'both': return t.enum_both;
    case 'other_pet': return t.enum_other_pet;
    case 'no_pets': return t.enum_no_pets;
    case 'loves_pets': return t.enum_loves_pets;
    // zodiac
    case 'aries': return t.enum_aries;
    case 'taurus': return t.enum_taurus;
    case 'gemini': return t.enum_gemini;
    case 'cancer': return t.enum_cancer;
    case 'leo': return t.enum_leo;
    case 'virgo': return t.enum_virgo;
    case 'libra': return t.enum_libra;
    case 'scorpio': return t.enum_scorpio;
    case 'sagittarius': return t.enum_sagittarius;
    case 'capricorn': return t.enum_capricorn;
    case 'aquarius': return t.enum_aquarius;
    case 'pisces': return t.enum_pisces;
    // education
    case 'high_school': return t.enum_high_school;
    case 'bachelor':
    case 'undergraduate degree': return t.enum_bachelor;
    case 'master':
    case 'postgraduate degree': return t.enum_master;
    case 'phd':
    case 'phd / doctorate': return t.enum_phd;
    // political orientation
    case 'liberal': return t.enum_liberal;
    case 'conservative': return t.enum_conservative;
    case 'moderate': return t.enum_moderate;
    case 'apolitical': return t.enum_apolitical;
    // religion
    case 'muslim': return t.enum_muslim;
    case 'christian': return t.enum_christian;
    case 'jewish': return t.enum_jewish;
    case 'zoroastrian': return t.enum_zoroastrian;
    case 'atheist': return t.enum_atheist;
    case 'agnostic': return t.enum_agnostic;
    case 'spiritual': return t.enum_spiritual;
    case 'sikh': return t.enum_sikh;
    case 'buddhist': return t.enum_buddhist;
    case 'hindu': return t.enum_hindu;
    case 'other': return t.enum_other_religion;
    // ethnicity
    case 'persian': return t.enum_persian;
    case 'azeri': return t.enum_azeri;
    case 'kurd': return t.enum_kurd;
    case 'lur': return t.enum_lur;
    case 'arab': return t.enum_arab;
    case 'baloch': return t.enum_baloch;
    case 'turkmen': return t.enum_turkmen;
    case 'asian': return t.enum_asian;
    case 'black':
    case 'black / african descent':
    case 'black / african': return t.enum_black;
    case 'hispanic':
    case 'hispanic / latino': return t.enum_hispanic;
    case 'white':
    case 'white / caucasian': return t.enum_white;
    case 'middle eastern': return t.enum_middle_eastern;
    case 'mixed': return t.enum_mixed;
    case 'other ethnicity': return t.enum_other_ethnicity;
    default:
      return _titleCase(k);
  }
}

/// Resolves a spoken-language value (e.g. 'English', 'persian') into a
/// localized label. Falls back to the raw value for unknown languages.
String localizedLanguage(AppLocalizations t, String? key) {
  if (key == null || key.isEmpty) return '';
  final k = key.trim().toLowerCase();
  switch (k) {
    case 'english': return t.lang_english;
    case 'persian':
    case 'farsi': return t.lang_persian;
    case 'turkish': return t.lang_turkish;
    case 'arabic': return t.lang_arabic;
    case 'spanish': return t.lang_spanish;
    case 'french': return t.lang_french;
    case 'german': return t.lang_german;
    case 'italian': return t.lang_italian;
    case 'russian': return t.lang_russian;
    case 'chinese': return t.lang_chinese;
    case 'japanese': return t.lang_japanese;
    case 'korean': return t.lang_korean;
    case 'hindi': return t.lang_hindi;
    case 'urdu': return t.lang_urdu;
    case 'kurdish': return t.lang_kurdish;
    case 'armenian': return t.lang_armenian;
    default:
      return key;
  }
}

String _titleCase(String value) {
  return value
      .split(RegExp(r'[_/\s]+'))
      .where((w) => w.isNotEmpty)
      .map((w) => w[0].toUpperCase() + w.substring(1))
      .join(' ');
}
