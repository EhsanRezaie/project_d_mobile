import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:dating_app/providers/auth_provider.dart';
import 'package:dating_app/providers/settings_provider.dart';
import 'package:dating_app/screens/profile/delete_account_screen.dart';
import '../../../helpers/test_helpers.dart';
import '../../../helpers/mock_api.dart';

void main() {
  setUpAll(() async {
    await initTestEnvironment(secrets: {'user_id': 'user-a'});
  });

  late AuthProvider provider;
  late MockApi api;

  setUp(() {
    provider = AuthProvider();
    api = MockApi();
  });

  tearDown(() {
    provider.dispose();
  });

  Future<void> pumpScreen(WidgetTester tester) async {
    await tester.pumpWidget(
      buildTestable(
        const DeleteAccountScreen(),
        providers: [
          ChangeNotifierProvider<AuthProvider>.value(value: provider),
          ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ],
      ),
    );
    await tester.pump();
  }

  testWidgets('full flow: reason → code → success with scheduled date',
      (tester) async {
    api
      ..onPost('/users/me/delete-code', statusCode: 204, body: {})
      ..onDelete(
        '/users/me',
        statusCode: 200,
        body: {
          'message': 'Account deletion scheduled',
          'deletion_scheduled_for': '2026-09-28T00:00:00Z',
        },
        data: {'code': '123456'},
      )
      ..install();

    await pumpScreen(tester);

    // Step 0: description + reason field + confirm button.
    expect(find.text('Delete Account'), findsOneWidget);
    await tester.tap(find.text('Delete my account'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // Step 1: code entry appears.
    expect(find.text('Verification code'), findsOneWidget);

    // Entering 6 digits auto-triggers the delete.
    await tester.enterText(find.byType(TextField).last, '123456');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // Step 2: success with the scheduled date.
    expect(find.text('Account deletion scheduled'), findsOneWidget);
    expect(find.textContaining('2026-09-28'), findsOneWidget);
    api.expectCalled('/users/me/delete-code');
    api.expectCalled('/users/me');
  });

  testWidgets('shows an error message when the code request fails',
      (tester) async {
    api
      ..onPost('/users/me/delete-code', statusCode: 429, body: {
        'detail': 'Please wait 42 seconds before requesting a new code.',
      })
      ..install();

    await pumpScreen(tester);

    await tester.tap(find.text('Delete my account'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.textContaining('42'), findsOneWidget);
  });
}
