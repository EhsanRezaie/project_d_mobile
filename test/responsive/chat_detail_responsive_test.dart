// Lint: builds the chat detail screen at multiple sizes to catch overflow —
// specifically the message bubble (text/photo/voice/reply) + input bar.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:dating_app/providers/chat_provider.dart';
import 'package:dating_app/providers/settings_provider.dart';
import 'package:dating_app/screens/chats/chat_detail_screen.dart';
import '../helpers/test_helpers.dart';
import '../helpers/mock_api.dart';
import '../helpers/fixtures.dart';

const kWidths = [320.0, 360.0, 428.0, 600.0, 800.0, 1280.0];

Future<void> _pumpChatAt(WidgetTester tester, double width) async {
  tester.view.physicalSize = Size(width * 3, 800 * 3);
  tester.view.devicePixelRatio = 3.0;
  addTearDown(tester.view.reset);

  final provider = ChatProvider();
  addTearDown(provider.dispose);
  final api = MockApi();
  api.onGet('/chats/chat-1', body: {
    'id': 'chat-1',
    'status': 'accepted',
    'initiator_id': 'user-a',
    'user': {'id': 'user-b', 'name': 'Bob'},
    'is_blocked': false,
    'is_ended': false,
  });
  api.onGet('/messages/chat-1', body: {
    'items': [
      jsonMessage(id: 'm-text', content: 'a' * 400),
      jsonMessage(id: 'm-photo', messageType: 'photo', content: null,
          mediaUrl: 'https://example.com/p.jpg'),
      jsonMessage(id: 'm-voice', messageType: 'voice', content: null,
          mediaUrl: 'https://example.com/v.mp3', mediaDuration: 45),
      jsonMessage(id: 'm-reply', replyTo: jsonMessage(id: 'm-text', content: 'original reply target')),
    ],
  });
  api.install();

  await tester.pumpWidget(
    buildTestable(
      ChatDetailScreen(identifier: 'chat-1', userName: 'Bob', peerId: 'user-b'),
      providers: [
        ChangeNotifierProvider<ChatProvider>.value(value: provider),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ],
    ),
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 400));

  final exception = tester.takeException();
  expect(exception, isNull, reason: 'overflow/exception at width $width');
}

void main() {
  setUpAll(() async {
    await initTestEnvironment(secrets: {'user_id': 'user-a'});
  });

  group('chat detail responsive', () {
    for (final width in kWidths) {
      testWidgets('no overflow @$width', (tester) async {
        await _pumpChatAt(tester, width);
      });
    }
  });
}
