import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:dating_app/providers/chat_provider.dart';
import 'package:dating_app/providers/settings_provider.dart';
import 'package:dating_app/screens/profile/blocked_users_screen.dart';
import '../../../helpers/test_helpers.dart';
import '../../../helpers/mock_api.dart';

void main() {
  setUpAll(() async {
    await initTestEnvironment(secrets: {'user_id': 'user-a'});
  });

  late ChatProvider provider;
  late MockApi api;

  setUp(() {
    provider = ChatProvider();
    api = MockApi();
  });

  tearDown(() {
    provider.dispose();
  });

  Map<String, dynamic> blockJson({
    String id = 'b1',
    String userId = 'user-x',
    String? name = 'Blocked User',
    int? age = 30,
    String? photo,
  }) {
    return {
      'id': id,
      'blocked_user_id': userId,
      'blocked_user_name': name,
      'blocked_user_age': age,
      'main_photo_url': photo,
      'blocked_at': '2026-08-01T00:00:00Z',
    };
  }

  Future<void> pumpScreen(WidgetTester tester) async {
    await tester.pumpWidget(
      buildTestable(
        const BlockedUsersScreen(),
        providers: [
          ChangeNotifierProvider<ChatProvider>.value(value: provider),
          ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ],
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('lists blocked users with name and age', (tester) async {
    api
      ..onGet('/blocks', body: [
        blockJson(name: 'Sara', age: 27, userId: 'u1'),
        blockJson(id: 'b2', name: 'Alex', age: 34, userId: 'u2'),
      ])
      ..install();

    await pumpScreen(tester);

    expect(find.text('Sara · 27'), findsOneWidget);
    expect(find.text('Alex · 34'), findsOneWidget);
    api.expectCalled('/blocks');
  });

  testWidgets('unblocks via confirmation dialog and removes the row',
      (tester) async {
    api
      ..onGet('/blocks', body: [blockJson(name: 'Sara', userId: 'u1')])
      ..onPost('/blocks/u1/unblock', statusCode: 204, body: {})
      ..install();

    await pumpScreen(tester);

    expect(find.text('Sara · 30'), findsOneWidget);
    await tester.tap(find.text('Unblock'));
    await tester.pumpAndSettle();
    // Confirmation dialog.
    expect(find.textContaining('Unblock Sara?'), findsOneWidget);
    await tester.tap(find.text('Unblock').last);
    await tester.pumpAndSettle();

    expect(find.text('Sara · 30'), findsNothing);
    expect(find.text('You haven\'t blocked anyone'), findsOneWidget);
    api.expectCalled('/blocks/u1/unblock');

    // Let the unblock toast timer fire so no timers are left pending.
    await tester.pump(const Duration(seconds: 4));
  });

  testWidgets('shows empty state when no one is blocked', (tester) async {
    api
      ..onGet('/blocks', body: <Object>[])
      ..install();

    await pumpScreen(tester);

    expect(find.text('You haven\'t blocked anyone'), findsOneWidget);
  });
}
