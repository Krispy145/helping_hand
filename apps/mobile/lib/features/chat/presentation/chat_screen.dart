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
import '../data/chat_models.dart';
import '../data/chat_repository.dart';
import 'chat_widgets.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final String sessionId;
  const ChatScreen({super.key, required this.sessionId});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onDraftChanged);
  }

  void _onDraftChanged() => setState(() {});

  void _openReport() {
    final session = ref.read(sessionDetailsProvider(widget.sessionId)).asData?.value;
    final userId = ref.read(authProvider).value?.id;
    final suggested = session != null && userId == session.helperId ? ReportTypeDto.HELPEE_MISUSE : ReportTypeDto.HELPER_MISCONDUCT;
    context.push(
      AppRoutes.report,
      extra: ReportEntry(sessionId: widget.sessionId, requestId: session?.requestId, targetUserId: session?.otherPartyId(userId), suggestedType: suggested, sessionActive: session?.isActive ?? false),
    );
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_onDraftChanged)
      ..dispose();
    super.dispose();
  }

  Future<void> _cancelAssist() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('End this assist?'),
        content: const Text('The conversation will close and the request will stay on the map for someone else.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Keep talking')),
          TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('End assist')),
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
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Assist ended. The request is open again.')));
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not end assist: $error')));
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

  void _send() {
    final content = _controller.text.trim();
    final user = ref.read(authProvider).value;
    if (content.isEmpty || user == null || _busy) return;

    final chat = ref.read(chatProvider(widget.sessionId)).asData?.value;
    if (chat == null || !chat.isConnected) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Still connecting. Try again in a moment.')));
      return;
    }

    ref.read(chatProvider(widget.sessionId).notifier).sendMessage(content, user.id);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final chatAsync = ref.watch(chatProvider(widget.sessionId));
    final sessionAsync = ref.watch(sessionDetailsProvider(widget.sessionId));
    final user = ref.watch(authProvider).value;
    final session = sessionAsync.asData?.value;
    final otherName = session?.otherPartyName(user?.id) ?? 'Conversation';
    final isActive = session?.isActive ?? false;
    final canSend = isActive && !_busy && _controller.text.trim().isNotEmpty;

    return Scaffold(
      backgroundColor: context.background,
      appBar: AppBar(
        title: Column(
          children: [
            Text(otherName, style: context.h3),
            Text(
              session?.request.title ?? 'Connecting...',
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
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: chatAsync.when(
              data: (state) => _MessageThread(messages: state.messages, currentUserId: user?.id),
              loading: () => const Center(child: BreathingLoader()),
              error: (err, stack) => Center(
                child: Text('Could not load this conversation.', style: TextStyle(color: context.error)),
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Column(
                children: [
                  if (isActive) ...[
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(onPressed: _busy ? null : _cancelAssist, child: const Text('End assist')),
                        ),
                        Expanded(
                          child: TextButton(onPressed: _busy ? null : _completeAssist, child: const Text('Assistance offered')),
                        ),
                      ],
                    ),
                    ChatComposer(controller: _controller, enabled: !_busy, canSend: canSend, onSend: _send),
                  ] else if (sessionAsync.hasValue) ...[
                    Text(
                      switch (session!.status) {
                        'COMPLETED' => 'This request is completed.',
                        'DISPUTED' => 'This conversation ended after a safety report.',
                        _ => 'This assist has ended.',
                      },
                      style: context.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    const GetUrgentHelpButton(compact: true),
                    TextButton(
                      onPressed: _busy ? null : _openReport,
                      child: Text('Report a concern', style: TextStyle(color: context.error)),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageThread extends StatelessWidget {
  const _MessageThread({required this.messages, required this.currentUserId});

  final List<ChatMessage> messages;
  final String? currentUserId;

  @override
  Widget build(BuildContext context) {
    if (messages.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            'You are connected. Send a message when you are ready.',
            textAlign: TextAlign.center,
            style: context.bodyLarge.copyWith(color: context.textSecondary),
          ),
        ),
      );
    }

    return ListView.builder(
      reverse: true,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final msgIndex = messages.length - 1 - index;
        final msg = messages[msgIndex];
        final previous = msgIndex > 0 ? messages[msgIndex - 1] : null;
        final isIntro = msgIndex == 0;
        final showDay = previous == null || !isSameChatDay(msg.createdAt, previous.createdAt);

        if (isIntro) {
          return Column(
            children: [
              if (showDay) ChatDayMarker(time: msg.createdAt),
              ChatIntroCard(content: msg.content),
            ],
          );
        }

        return Column(
          children: [
            if (showDay) ChatDayMarker(time: msg.createdAt),
            ChatBubble(
              message: msg,
              isMine: msg.senderId == currentUserId,
              showTime: shouldShowChatTimestamp(current: msg, previous: isIntro ? null : previous),
            ),
          ],
        );
      },
    );
  }
}
