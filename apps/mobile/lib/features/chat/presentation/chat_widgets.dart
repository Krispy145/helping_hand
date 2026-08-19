import 'package:flutter/material.dart';
import 'package:ui/ui.dart';

import '../data/chat_models.dart';

const _monthNames = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

String formatChatClock(DateTime time) {
  final local = time.toLocal();
  final hour = local.hour.toString().padLeft(2, '0');
  final minute = local.minute.toString().padLeft(2, '0');
  return '$hour:$minute';
}

String formatChatDay(DateTime time) {
  final local = time.toLocal();
  return '${local.day} ${_monthNames[local.month - 1]}';
}

bool isSameChatDay(DateTime a, DateTime b) {
  final left = a.toLocal();
  final right = b.toLocal();
  return left.year == right.year && left.month == right.month && left.day == right.day;
}

bool shouldShowChatTimestamp({required ChatMessage current, ChatMessage? previous}) {
  if (previous == null) return true;
  if (current.senderId != previous.senderId) return true;
  return current.createdAt.difference(previous.createdAt).inMinutes >= 5;
}

class ChatIntroCard extends StatelessWidget {
  const ChatIntroCard({super.key, required this.content});

  final String content;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'This request',
            style: context.bodySmall.copyWith(color: context.primary, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(content, style: context.bodyLarge.copyWith(color: context.textPrimary)),
        ],
      ),
    );
  }
}

class ChatDayMarker extends StatelessWidget {
  const ChatDayMarker({super.key, required this.time});

  final DateTime time;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Center(
        child: Text(
          formatChatDay(time),
          style: context.bodySmall.copyWith(color: context.textSecondary),
        ),
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    super.key,
    required this.message,
    required this.isMine,
    this.showTime = false,
  });

  final ChatMessage message;
  final bool isMine;
  final bool showTime;

  @override
  Widget build(BuildContext context) {
    final background = isMine ? context.primaryContainer : context.surface;
    final foreground = isMine ? context.onPrimaryContainer : context.textPrimary;

    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.78),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 3),
          child: Column(
            crossAxisAlignment: isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: background,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(18),
                    topRight: const Radius.circular(18),
                    bottomLeft: Radius.circular(isMine ? 18 : 4),
                    bottomRight: Radius.circular(isMine ? 4 : 18),
                  ),
                  border: isMine ? null : Border.all(color: context.outlineVariant),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  child: Text(message.content, style: context.bodyLarge.copyWith(color: foreground, height: 1.4)),
                ),
              ),
              if (showTime) ...[
                const SizedBox(height: 4),
                Text(formatChatClock(message.createdAt), style: context.bodySmall),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class ChatSessionTile extends StatelessWidget {
  const ChatSessionTile({super.key, required this.chat, required this.currentUserId, this.onTap});

  final ChatSessionDetails chat;
  final String? currentUserId;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final otherName = chat.otherPartyName(currentUserId);
    final initial = otherName.isNotEmpty ? otherName[0].toUpperCase() : '?';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      color: context.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: context.outlineVariant),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: context.primaryContainer,
          foregroundColor: context.onPrimaryContainer,
          child: Text(initial, style: context.h3.copyWith(color: context.onPrimaryContainer)),
        ),
        title: Text(otherName, style: context.h3),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            '${chat.request.title}\n${chat.roleLabel(currentUserId)} · ${chat.statusLabel}',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: context.bodySmall,
          ),
        ),
        isThreeLine: true,
        trailing: Icon(Icons.chevron_right, color: context.textSecondary),
        onTap: onTap,
      ),
    );
  }
}

class ChatComposer extends StatelessWidget {
  const ChatComposer({
    super.key,
    required this.controller,
    required this.enabled,
    required this.canSend,
    required this.onSend,
  });

  final TextEditingController controller;
  final bool enabled;
  final bool canSend;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: context.surface,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: context.outlineVariant),
            ),
            child: TextField(
              controller: controller,
              enabled: enabled,
              minLines: 1,
              maxLines: 4,
              style: context.bodyLarge,
              decoration: InputDecoration(
                hintText: 'Write a message',
                hintStyle: context.bodyLarge.copyWith(color: context.textSecondary),
                filled: false,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              ),
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.send,
              onSubmitted: enabled && canSend ? (_) => onSend() : null,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Material(
          color: canSend ? context.primary : context.surfaceVariant,
          shape: const CircleBorder(),
          child: IconButton(
            tooltip: 'Send',
            onPressed: canSend ? onSend : null,
            icon: Icon(
              Icons.send_rounded,
              color: canSend ? context.onPrimary : context.textSecondary,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }
}
