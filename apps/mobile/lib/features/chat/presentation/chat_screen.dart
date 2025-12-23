import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ui/ui.dart';

import '../../auth/providers/auth_provider.dart';
import '../application/chat_provider.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final String sessionId;
  const ChatScreen({super.key, required this.sessionId});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final chatAsync = ref.watch(chatProvider(widget.sessionId));
    final user = ref.watch(authProvider).value;

    return Scaffold(
      appBar: AppBar(
        title: Text('Chat', style: context.h3),
        centerTitle: true,
        actions: [
          chatAsync.when(
            data: (state) => Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Icon(Icons.circle, color: state.isConnected ? context.success : context.error, size: 12),
            ),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Icon(Icons.error, color: context.error, size: 12),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: chatAsync.when(
              data: (state) {
                if (state.messages.isEmpty) {
                  return Center(
                    child: Text(
                      'No messages yet.\nStart the conversation!',
                      textAlign: TextAlign.center,
                      style: context.bodyLarge.copyWith(color: context.textSecondary),
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: state.messages.length,
                  itemBuilder: (context, index) {
                    final msg = state.messages[index];
                    final isMe = msg.senderId == user?.id;
                    return Align(
                      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: isMe ? context.primary : context.surfaceVariant,
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(20),
                            topRight: const Radius.circular(20),
                            bottomLeft: isMe ? const Radius.circular(20) : Radius.zero,
                            bottomRight: isMe ? Radius.zero : const Radius.circular(20),
                          ),
                        ),
                        child: Text(msg.content, style: context.bodyLarge.copyWith(color: isMe ? context.surface : context.textPrimary)),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: BreathingLoader()),
              error: (err, stack) => Center(
                child: Text('Error: $err', style: TextStyle(color: context.error)),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: context.surface,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))],
                      ),
                      child: TextField(
                        controller: _controller,
                        style: context.bodyLarge,
                        decoration: InputDecoration(
                          hintText: 'Type a message...',
                          hintStyle: context.bodyLarge.copyWith(color: context.textSecondary),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                        ),
                        textCapitalization: TextCapitalization.sentences,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  CircleAvatar(
                    backgroundColor: context.primary,
                    radius: 24,
                    child: IconButton(
                      icon: Icon(Icons.send_rounded, color: context.surface, size: 20),
                      onPressed: () {
                        final content = _controller.text.trim();
                        if (content.isNotEmpty && user != null) {
                          ref.read(chatProvider(widget.sessionId).notifier).sendMessage(content, user.id);
                          _controller.clear();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
