import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/chat/data/chat_models.dart';
import 'package:mobile/features/chat/presentation/chat_widgets.dart';
import 'package:ui/ui.dart';

ChatMessage _message({
  required String id,
  required String senderId,
  required String content,
  required DateTime createdAt,
}) {
  return ChatMessage(
    id: id,
    sessionId: 'session-1',
    senderId: senderId,
    content: content,
    createdAt: createdAt,
  );
}

ChatSessionDetails _session({required String status}) {
  return ChatSessionDetails(
    id: 'session-1',
    requestId: 'req-1',
    helperId: 'helper-1',
    status: status,
    request: const ChatRequestSummary(
      title: 'Need groceries',
      description: 'A few essentials.',
      urgency: 'MEDIUM',
    ),
    requester: const ChatParticipant(id: 'user-1', name: 'Pat'),
    helper: const ChatParticipant(id: 'helper-1', name: 'Alex'),
  );
}

void main() {
  Widget app(Widget child) {
    return MaterialApp(
      theme: AppTheme.build(style: AppThemeStyle.primary, brightness: Brightness.light),
      home: Scaffold(body: child),
    );
  }

  testWidgets('mine and their bubbles align quietly with timestamps', (tester) async {
    final mine = _message(
      id: 'm1',
      senderId: 'me',
      content: 'I can pick these up this afternoon.',
      createdAt: DateTime(2026, 8, 19, 10, 15),
    );
    final theirs = _message(
      id: 'm2',
      senderId: 'them',
      content: 'Thank you. The shop is around the corner.',
      createdAt: DateTime(2026, 8, 19, 10, 16),
    );

    await tester.pumpWidget(
      app(
        Column(
          children: [
            ChatBubble(message: mine, isMine: true, showTime: true),
            ChatBubble(message: theirs, isMine: false, showTime: true),
          ],
        ),
      ),
    );

    expect(find.text('I can pick these up this afternoon.'), findsOneWidget);
    expect(find.text('Thank you. The shop is around the corner.'), findsOneWidget);
    expect(find.text('10:15'), findsOneWidget);
    expect(find.text('10:16'), findsOneWidget);
  });

  testWidgets('session tile uses in-progress copy instead of busy', (tester) async {
    await tester.pumpWidget(
      app(
        ChatSessionTile(
          chat: _session(status: 'ACTIVE'),
          currentUserId: 'helper-1',
        ),
      ),
    );

    expect(find.text('Pat'), findsOneWidget);
    expect(find.textContaining('Need groceries'), findsOneWidget);
    expect(find.textContaining('Offering help · In progress'), findsOneWidget);
    expect(find.textContaining('Busy'), findsNothing);
  });

  testWidgets('intro card names the request without shouting', (tester) async {
    await tester.pumpWidget(
      app(const ChatIntroCard(content: 'Need groceries\n\nA few essentials.')),
    );

    expect(find.text('This request'), findsOneWidget);
    expect(find.text('Need groceries\n\nA few essentials.'), findsOneWidget);
  });

  test('timestamp grouping waits five minutes for the same sender', () {
    final first = _message(
      id: 'm1',
      senderId: 'me',
      content: 'Hi',
      createdAt: DateTime.utc(2026, 8, 19, 10),
    );
    final soon = _message(
      id: 'm2',
      senderId: 'me',
      content: 'Still here',
      createdAt: DateTime.utc(2026, 8, 19, 10, 3),
    );
    final later = _message(
      id: 'm3',
      senderId: 'me',
      content: 'On my way',
      createdAt: DateTime.utc(2026, 8, 19, 10, 6),
    );

    expect(shouldShowChatTimestamp(current: first), isTrue);
    expect(shouldShowChatTimestamp(current: soon, previous: first), isFalse);
    expect(shouldShowChatTimestamp(current: later, previous: first), isTrue);
  });
}
