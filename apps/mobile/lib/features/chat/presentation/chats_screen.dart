import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ui/ui.dart';

import '../../../router.dart';
import '../../auth/providers/auth_provider.dart';
import '../data/chat_repository.dart';
import 'chat_widgets.dart';

class ChatsScreen extends ConsumerWidget {
  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatsAsync = ref.watch(mySessionsProvider);
    final userId = ref.watch(authProvider).value?.id;

    return Scaffold(
      backgroundColor: context.background,
      appBar: AppBar(
        title: const Text('Conversations'),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Get urgent help',
            onPressed: () => context.push(AppRoutes.urgentHelp),
            icon: Icon(Icons.health_and_safety_outlined, color: context.error),
          ),
        ],
      ),
      body: chatsAsync.when(
        data: (chats) {
          if (chats.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'When you offer or receive help, conversations will show up here.',
                  textAlign: TextAlign.center,
                  style: context.bodyLarge.copyWith(color: context.textSecondary),
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            itemCount: chats.length,
            itemBuilder: (context, index) {
              final chat = chats[index];
              return ChatSessionTile(
                chat: chat,
                currentUserId: userId,
                onTap: () => context.push('/session/${chat.id}'),
              );
            },
          );
        },
        loading: () => const Center(child: BreathingLoader()),
        error: (error, _) => Center(
          child: Text(
            'Could not load conversations.',
            style: context.bodyLarge.copyWith(color: context.error),
          ),
        ),
      ),
    );
  }
}
