import 'package:flutter_test/flutter_test.dart';
import 'package:dating_app/services/system_service.dart';
import '../../helpers/test_helpers.dart';
import '../../helpers/mock_api.dart';

void main() {
  late MockApi api;

  setUpAll(() async {
    await initTestEnvironment();
  });

  setUp(() {
    api = MockApi();
  });

  group('SystemService.checkVersion', () {
    test('parses an ok response', () async {
      api
        ..onPost(
          '/system/version-check',
          body: {
            'status': 'ok',
            'current_version': '1.0.0',
            'minimum_version': '1.0.0',
            'platform': 'android',
            'force_update': false,
          },
          data: {'platform': 'android', 'version': '1.0.0'},
        )
        ..install();

      final result = await SystemService.checkVersion(platform: 'android', version: '1.0.0');

      expect(result, isNotNull);
      expect(result!.isMaintenance, isFalse);
      expect(result.isUpdateRequired, isFalse);
    });

    test('parses a maintenance response', () async {
      api
        ..onPost(
          '/system/version-check',
          body: {
            'status': 'maintenance',
            'message': 'Down for maintenance',
            'current_version': '1.0.0',
            'minimum_version': '1.0.0',
            'platform': 'android',
            'force_update': false,
          },
          data: {'platform': 'android', 'version': '1.0.0'},
        )
        ..install();

      final result = await SystemService.checkVersion(platform: 'android', version: '1.0.0');

      expect(result!.isMaintenance, isTrue);
      expect(result.message, 'Down for maintenance');
    });

    test('parses a forced update with update url', () async {
      api
        ..onPost(
          '/system/version-check',
          body: {
            'status': 'update_required',
            'current_version': '1.0.0',
            'minimum_version': '2.0.0',
            'platform': 'android',
            'update_url': 'https://play.google.com/store/apps/details?id=x',
            'force_update': true,
          },
          data: {'platform': 'android', 'version': '1.0.0'},
        )
        ..install();

      final result = await SystemService.checkVersion(platform: 'android', version: '1.0.0');

      expect(result!.isUpdateRequired, isTrue);
      expect(result.forceUpdate, isTrue);
      expect(result.updateUrl, contains('play.google.com'));
    });

    test('fails open (returns null) on a network error', () async {
      api.onPost('/system/version-check', body: <String, dynamic>{}, statusCode: 500);
      api.install();

      final result = await SystemService.checkVersion(platform: 'android', version: '1.0.0');

      expect(result, isNull);
    });
  });
}
