import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:dating_app/providers/settings_provider.dart';
import 'package:dating_app/widgets/match_dialog.dart';
import '../../helpers/test_helpers.dart';

void main() {
  setUpAll(() async {
    await initTestEnvironment();
  });

  Future<void> pumpDialog(
    WidgetTester tester, {
    String? myPhotoUrl = 'https://example.com/me.jpg',
    String? theirPhotoUrl = 'https://example.com/them.jpg',
    String name = 'Sara',
    bool messageSent = false,
    VoidCallback? onSendMessage,
    VoidCallback? onKeepSwiping,
  }) async {
    await tester.pumpWidget(
      buildTestable(
        Material(
          child: MatchDialog(
            myPhotoUrl: myPhotoUrl,
            theirPhotoUrl: theirPhotoUrl,
            name: name,
            messageSent: messageSent,
            onSendMessage: onSendMessage ?? () {},
            onKeepSwiping: onKeepSwiping ?? () {},
          ),
        ),
        providers: [
          ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ],
      ),
    );
    await tester.pump();
  }

  testWidgets('shows the match title, subtitle, and both avatars', (tester) async {
    await pumpDialog(tester, name: 'Sara');

    expect(find.text("It's a Match!"), findsOneWidget);
    expect(find.text('You and Sara liked each other'), findsOneWidget);
    expect(find.byIcon(Icons.favorite), findsOneWidget);
    // Two avatar images (CachedImage renders network images).
    expect(find.byType(Image), findsNWidgets(2));
    expect(find.text('Send a Message'), findsOneWidget);
    expect(find.text('Keep Swiping'), findsOneWidget);
  });

  testWidgets('falls back to person icons when photos are missing', (tester) async {
    await pumpDialog(tester, myPhotoUrl: null, theirPhotoUrl: null);

    expect(find.byIcon(Icons.person), findsNWidgets(2));
    expect(find.byIcon(Icons.favorite), findsOneWidget);
  });

  testWidgets('shows the message-sent confirmation when messageSent', (tester) async {
    await pumpDialog(tester, messageSent: true);

    expect(find.text('Your message was sent!'), findsOneWidget);
  });

  testWidgets('invokes the send-message callback', (tester) async {
    var sent = false;
    await pumpDialog(tester, onSendMessage: () => sent = true);

    await tester.tap(find.text('Send a Message'));
    expect(sent, isTrue);
  });
}
