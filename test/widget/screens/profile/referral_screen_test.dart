import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:dating_app/providers/settings_provider.dart';
import 'package:dating_app/screens/profile/referral_screen.dart';
import '../../../helpers/test_helpers.dart';
import '../../../helpers/mock_api.dart';

void main() {
  setUpAll(() async {
    await initTestEnvironment(secrets: {'user_id': 'user-a'});
  });

  late MockApi api;

  setUp(() {
    api = MockApi();
  });

  Future<void> pumpScreen(WidgetTester tester) async {
    await tester.pumpWidget(
      buildTestable(
        const ReferralScreen(),
        providers: [
          ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ],
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('shows the referral code and stats', (tester) async {
    final codeCopied = <MethodCall>[];
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        if (call.method == 'Clipboard.setData') {
          codeCopied.add(call);
          return null;
        }
        if (call.method == 'Clipboard.getData') return null;
        return null;
      },
    );

    api
      ..onGet('/referrals/my-code', body: {
        'referral_code': 'ABCD1234',
        'share_text': 'Join me with ABCD1234',
      })
      ..onGet('/referrals/stats', body: {
        'referral_code': 'ABCD1234',
        'successful_referrals': 3,
        'total_premium_days_earned': 9,
        'inviter_reward_days': 3,
        'invited_reward_days': 3,
        'is_premium': true,
        'premium_until': null,
      })
      ..install();

    await pumpScreen(tester);

    expect(find.text('ABCD1234'), findsOneWidget);
    expect(find.text('3'), findsOneWidget);
    expect(find.text('9'), findsOneWidget);

    await tester.tap(find.text('Copy'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 4));

    expect(codeCopied, isNotEmpty);
    expect((codeCopied.first.arguments as Map)['text'], 'ABCD1234');
  });
}
