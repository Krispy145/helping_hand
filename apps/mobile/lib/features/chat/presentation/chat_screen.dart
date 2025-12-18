import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    final user = ref.watch(authProvider).value; // authProvider is AsyncValue implicitly? No, AuthNotifier extends AsyncNotifier.
    // wait, authProvider in auth_provider.dart is AsyncNotifierProvider<AuthNotifier, UserDto?>.
    // So watching it returns AsyncValue<UserDto?>.

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        actions: [
          chatAsync.when(
            data: (state) => Icon(Icons.circle, color: state.isConnected ? Colors.green : Colors.red, size: 12),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const Icon(Icons.error, color: Colors.red, size: 12),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: chatAsync.when(
              data: (state) => ListView.builder(
                itemCount: state.messages.length,
                itemBuilder: (context, index) {
                  final msg = state.messages[index];
                  final isMe = msg.senderId == user?.id; // user might be null if loading
                  return Align(
                    alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: isMe ? Colors.blue[100] : Colors.grey[200], borderRadius: BorderRadius.circular(12)),
                      child: Text(msg.content),
                    ),
                  );
                },
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(hintText: 'Type a message...'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    final content = _controller.text.trim();
                    if (content.isNotEmpty && user != null) {
                      ref.read(chatProvider(widget.sessionId).notifier).sendMessage(content, user.id);
                      _controller.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
