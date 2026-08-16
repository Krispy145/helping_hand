import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ui/ui.dart';

import '../../auth/providers/auth_provider.dart';
import '../data/chat_models.dart';
import '../data/chat_repository.dart';

class ChatsScreen extends ConsumerWidget {
  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatsAsync = ref.watch(mySessionsProvider);
    final userId = ref.watch(authProvider).value?.id;
    final topInset = MediaQuery.paddingOf(context).top + kToolbarHeight + 16;

    return chatsAsync.when(
      data: (chats) {
        if (chats.isEmpty) {
          return Padding(
            padding: EdgeInsets.fromLTRB(24, topInset, 24, 24),
            child: Center(
              child: Text(
                'No current chats.\nOffer help on a request to start one.',
                textAlign: TextAlign.center,
                style: context.bodyLarge.copyWith(color: context.textSecondary),
              ),
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.fromLTRB(16, topInset, 16, 120),
          itemCount: chats.length,
          itemBuilder: (context, index) {
            final chat = chats[index];
            return _ChatTile(chat: chat, currentUserId: userId);
          },
        );
      },
      loading: () => const Center(child: BreathingLoader()),
      error: (error, _) => Center(child: Text('Could not load chats: $error')),
    );
  }
}

class _ChatTile extends StatelessWidget {
  const _ChatTile({required this.chat, required this.currentUserId});

  final ChatSessionDetails chat;
  final String? currentUserId;

  @override
  Widget build(BuildContext context) {
    final otherName = chat.otherPartyName(currentUserId);
    final roleLabel = currentUserId == chat.helperId ? 'Helping' : 'Your request';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: context.surfaceVariant,
          child: Icon(Icons.chat_bubble_outline, color: context.textPrimary),
        ),
        title: Text(otherName, style: context.h3),
        subtitle: Text(
          '${chat.request.title}\n$roleLabel · Busy',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        isThreeLine: true,
        trailing: Icon(Icons.chevron_right, color: context.textSecondary),
        onTap: () => context.push('/session/${chat.id}'),
      ),
    );
  }
}
