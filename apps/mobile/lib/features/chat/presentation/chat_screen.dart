import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:models/models.dart';
import 'package:ui/ui.dart';

import '../../../router.dart';
import '../../auth/providers/auth_provider.dart';
import '../../reports/presentation/report_entry.dart';
import '../../requests/providers/request_provider.dart';
import '../../urgent_help/presentation/get_urgent_help_button.dart';
import '../application/chat_provider.dart';
import '../data/chat_repository.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final String sessionId;
  const ChatScreen({super.key, required this.sessionId});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _busy = false;

  void _openReport() {
    final session = ref.read(sessionDetailsProvider(widget.sessionId)).asData?.value;
    final userId = ref.read(authProvider).value?.id;
    final suggested = session != null && userId == session.helperId ? ReportTypeDto.HELPEE_MISUSE : ReportTypeDto.HELPER_MISCONDUCT;
    context.push(
      AppRoutes.report,
      extra: ReportEntry(
        sessionId: widget.sessionId,
        requestId: session?.requestId,
        targetUserId: session?.otherPartyId(userId),
        suggestedType: suggested,
        sessionActive: session?.isActive ?? false,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _cancelAssist() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel assist?'),
        content: const Text('This chat will end and the request will stay open on the map for someone else.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Keep chatting')),
          TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Cancel assist')),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    setState(() => _busy = true);
    try {
      final requestId = ref.read(sessionDetailsProvider(widget.sessionId)).asData?.value.requestId;
      await ref.read(chatRepositoryProvider).cancelAssist(widget.sessionId);
      if (requestId != null) {
        ref.read(nearbyRequestsProvider.notifier).patchStatus(requestId, RequestStatusDto.APPROVED);
      }
      await ref.read(nearbyRequestsProvider.notifier).refresh();
      ref.invalidate(mySessionsProvider);
      if (mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Assist cancelled. The request is open again.')));
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not cancel assist: $error')));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _completeAssist() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Mark assistance offered?'),
        content: const Text('This will complete the request and remove it from the map.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Not yet')),
          TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Assistance offered')),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    setState(() => _busy = true);
    try {
      final completed = await ref.read(chatRepositoryProvider).completeAssist(widget.sessionId);
      ref.invalidate(sessionDetailsProvider(widget.sessionId));
      ref.read(nearbyRequestsProvider.notifier).patchStatus(completed.requestId, RequestStatusDto.COMPLETED);
      await ref.read(nearbyRequestsProvider.notifier).refresh();
      ref.invalidate(mySessionsProvider);
      if (mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Request marked completed.')));
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not complete request: $error')));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatAsync = ref.watch(chatProvider(widget.sessionId));
    final sessionAsync = ref.watch(sessionDetailsProvider(widget.sessionId));
    final user = ref.watch(authProvider).value;
    final otherName = sessionAsync.asData?.value.otherPartyName(user?.id) ?? 'Chat';

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(otherName, style: context.h3),
            if (sessionAsync.asData != null)
              Text(
                sessionAsync.asData!.value.request.title,
                style: context.bodySmall.copyWith(color: context.textSecondary),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Get urgent help',
            onPressed: () => context.push(AppRoutes.urgentHelp),
            icon: Icon(Icons.health_and_safety_outlined, color: context.error),
          ),
          IconButton(
            tooltip: 'Report',
            onPressed: _openReport,
            icon: Icon(Icons.flag_outlined, color: context.error),
          ),
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
                    if (index == 0) {
                      return _RequestIntroCard(content: msg.content);
                    }
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
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                children: [
                  if (sessionAsync.asData?.value.isActive ?? false) ...[
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _busy ? null : _cancelAssist,
                            child: const Text('Cancel assist'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: FilledButton(
                            onPressed: _busy ? null : _completeAssist,
                            child: const Text('Assistance offered'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const GetUrgentHelpButton(compact: true),
                    TextButton(
                      onPressed: _busy ? null : _openReport,
                      child: Text('Report a concern', style: TextStyle(color: context.error)),
                    ),
                    const SizedBox(height: 12),
                  ] else if (sessionAsync.hasValue) ...[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        switch (sessionAsync.asData!.value.status) {
                          'COMPLETED' => 'This request is completed.',
                          'DISPUTED' => 'This chat ended after a safety report.',
                          _ => 'This assist was cancelled.',
                        },
                        style: context.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const GetUrgentHelpButton(compact: true),
                    TextButton(
                      onPressed: _busy ? null : _openReport,
                      child: Text('Report a concern', style: TextStyle(color: context.error)),
                    ),
                    const SizedBox(height: 12),
                  ],
                  Row(
                    children: [
                      Expanded(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: context.surface,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [BoxShadow(color: context.shadow.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))],
                          ),
                          child: TextField(
                            controller: _controller,
                            enabled: (sessionAsync.asData?.value.isActive ?? true) && !_busy,
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
                          onPressed: _busy
                              ? null
                              : () {
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RequestIntroCard extends StatelessWidget {
  final String content;
  const _RequestIntroCard({required this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.surfaceVariant,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.primary.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Assistance request', style: context.bodySmall.copyWith(color: context.primary, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text(content, style: context.bodyLarge.copyWith(color: context.textPrimary)),
        ],
      ),
    );
  }
}
