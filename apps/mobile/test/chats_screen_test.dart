import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/auth/providers/auth_provider.dart';
import 'package:mobile/features/chat/data/chat_models.dart';
import 'package:mobile/features/chat/data/chat_repository.dart';
import 'package:mobile/features/chat/presentation/chats_screen.dart';
import 'package:models/models.dart';
import 'package:ui/ui.dart';

class _LoggedOutAuth extends AuthNotifier {
  @override
  Future<UserDto?> build() async => null;
}

void main() {
  testWidgets('empty conversations copy is calm and plain', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authProvider.overrideWith(_LoggedOutAuth.new),
          mySessionsProvider.overrideWith((ref) async => <ChatSessionDetails>[]),
        ],
        child: MaterialApp(
          theme: AppTheme.build(style: AppThemeStyle.primary, brightness: Brightness.light),
          home: const ChatsScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Conversations'), findsOneWidget);
    expect(
      find.text('When you offer or receive help, conversations will show up here.'),
      findsOneWidget,
    );
  });
}
