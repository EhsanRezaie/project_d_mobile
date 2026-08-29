import 'package:flutter_test/flutter_test.dart';
import 'package:dating_app/generated/app_localizations.dart';
import 'package:dating_app/generated/app_localizations_en.dart';
import 'package:dating_app/generated/app_localizations_fa.dart';
import 'package:dating_app/models/interest.dart';
import 'package:dating_app/services/interest_localizer.dart';
import 'package:dating_app/utils/profile_localization.dart';
import '../../helpers/test_helpers.dart';

void main() {
  late AppLocalizations en;
  late AppLocalizations fa;

  setUpAll(() async {
    await initTestEnvironment();
    en = AppLocalizationsEn();
    fa = AppLocalizationsFa();
  });

  group('localizedEnum', () {
    test('resolves known backend keys in English', () {
      expect(localizedEnum(en, 'single'), 'Single');
      expect(localizedEnum(en, 'long_term_relationship'), 'Long-term Relationship');
      expect(localizedEnum(en, 'open_to_children'), 'Open to Children');
      expect(localizedEnum(en, 'black / african descent'), 'Black / African Descent');
      expect(localizedEnum(en, 'muslim'), 'Muslim');
      expect(localizedEnum(en, 'libra'), 'Libra');
    });

    test('resolves known backend keys in Persian', () {
      expect(localizedEnum(fa, 'single'), 'مجرد');
      expect(localizedEnum(fa, 'open_to_children'), 'مشتاق بچه‌دار شدن');
      expect(localizedEnum(fa, 'muslim'), 'مسلمان');
    });

    test('falls back to title-cased key for unknown values', () {
      expect(localizedEnum(en, 'custom_religion'), 'Custom Religion');
      expect(localizedEnum(en, null), '');
      expect(localizedEnum(en, ''), '');
    });
  });

  group('localizedLanguage', () {
    test('resolves spoken languages', () {
      expect(localizedLanguage(en, 'English'), 'English');
      expect(localizedLanguage(fa, 'persian'), 'فارسی');
      expect(localizedLanguage(fa, 'English'), 'انگلیسی');
      expect(localizedLanguage(en, 'Kurdish'), 'Kurdish');
    });

    test('returns raw value for unknown languages', () {
      expect(localizedLanguage(en, 'Klingon'), 'Klingon');
    });
  });

  group('InterestLocalizer', () {
    test('maps stable names/categories to localized labels', () {
      InterestLocalizer.instance.load([
        Interest(
          id: '1',
          name: 'football',
          nameLocalized: 'فوتبال',
          category: 'sports_fitness',
          categoryLocalized: 'ورزش',
        ),
      ], language: 'fa');

      expect(InterestLocalizer.instance.name('football'), 'فوتبال');
      expect(InterestLocalizer.instance.category('sports_fitness'), 'ورزش');
    });

    test('humanizes unknown keys', () {
      InterestLocalizer.instance.clear();
      expect(InterestLocalizer.instance.name('rock climbing'), 'Rock Climbing');
      expect(InterestLocalizer.instance.category('outdoors_nature'), 'Outdoors Nature');
    });
  });
}
