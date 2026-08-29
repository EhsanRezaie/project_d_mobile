import 'package:flutter_test/flutter_test.dart';
import 'package:dating_app/providers/auth_provider.dart';
import '../../helpers/test_helpers.dart';
import '../../helpers/mock_api.dart';

void main() {
  late AuthProvider provider;
  late MockApi api;

  setUpAll(() async {
    await initTestEnvironment(secrets: {'user_id': 'user-a'});
  });

  setUp(() {
    provider = AuthProvider();
    api = MockApi();
  });

  tearDown(() {
    provider.dispose();
  });

  group('deleteAccount', () {
    test('clears the session and stores the scheduled deletion date', () async {
      api.onDelete(
        '/users/me',
        statusCode: 200,
        body: {
          'message': 'Account deletion scheduled',
          'deletion_scheduled_for': '2026-09-28T00:00:00Z',
        },
        data: {'code': '123456', 'reason': 'found a partner'},
      );
      api.install();

      final ok = await provider.deleteAccount('123456', reason: 'found a partner');

      expect(ok, isTrue);
      expect(provider.deletionScheduledFor, '2026-09-28T00:00:00Z');
      expect(provider.isAuthenticated, isFalse);
      expect(provider.user, isNull);
      api.expectCalled('/users/me');
    });

    test('returns false and surfaces the detail on a wrong code', () async {
      api.onDelete(
        '/users/me',
        statusCode: 400,
        body: {'detail': 'Invalid or expired verification code.'},
        data: {'code': '999999'},
      );
      api.install();

      final ok = await provider.deleteAccount('999999');

      expect(ok, isFalse);
      expect(provider.deleteError, 'Invalid or expired verification code.');
    });
  });
}
