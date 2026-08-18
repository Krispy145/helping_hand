import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:models/models.dart';
import 'package:ui/ui.dart';

import '../../chat/data/chat_repository.dart';
import '../../requests/providers/request_provider.dart';
import '../data/report_repository.dart';
import 'report_entry.dart';

class ReportScreen extends ConsumerStatefulWidget {
  final ReportEntry entry;

  const ReportScreen({super.key, required this.entry});

  @override
  ConsumerState<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends ConsumerState<ReportScreen> {
  final _descriptionController = TextEditingController();
  late ReportTypeDto _type;
  late bool _endSession;
  bool _submitting = false;
  ReportDto? _receipt;

  @override
  void initState() {
    super.initState();
    _type = widget.entry.suggestedType ?? ReportTypeDto.UNSAFE_SITUATION;
    _endSession = widget.entry.sessionActive;
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final description = _descriptionController.text.trim();
    if (description.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please describe what happened in a bit more detail.')));
      return;
    }

    setState(() => _submitting = true);
    try {
      final report = await ref.read(reportRepositoryProvider).create(
        CreateReportDto(
          type: _type,
          description: description,
          sessionId: widget.entry.sessionId,
          requestId: widget.entry.requestId,
          targetUserId: widget.entry.targetUserId,
          endSession: widget.entry.sessionId != null && _endSession,
        ),
      );
      if (widget.entry.sessionId != null) {
        ref.invalidate(sessionDetailsProvider(widget.entry.sessionId!));
        ref.invalidate(mySessionsProvider);
      }
      if (widget.entry.requestId != null && report.sessionEnded) {
        final nextStatus = _type == ReportTypeDto.HELPER_MISCONDUCT ? RequestStatusDto.APPROVED : RequestStatusDto.CANCELLED;
        ref.read(nearbyRequestsProvider.notifier).patchStatus(widget.entry.requestId!, nextStatus);
        await ref.read(nearbyRequestsProvider.notifier).refresh();
      }
      if (mounted) setState(() => _receipt = report);
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not send report: $error')));
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final receipt = _receipt;
    return Scaffold(
      appBar: AppBar(title: Text(receipt == null ? 'Report a concern' : 'Report received')),
      body: receipt == null ? _buildForm(context) : _buildReceipt(context, receipt),
    );
  }

  Widget _buildForm(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text('Tell us what happened. We will review this. You will get a confirmation.', style: context.bodyLarge),
        const SizedBox(height: 20),
        Text('What is this about?', style: context.h3),
        const SizedBox(height: 12),
        for (final type in ReportTypeDto.values)
          ListTile(
            selected: _type == type,
            onTap: _submitting ? null : () => setState(() => _type = type),
            title: Text(type.label),
            subtitle: Text(type.hint),
            leading: Icon(_type == type ? Icons.radio_button_checked : Icons.radio_button_off, color: context.primary),
            contentPadding: EdgeInsets.zero,
          ),
        if (_type.isVictimHarm) ...[
          const SizedBox(height: 8),
          Text(
            'If you were harmed, this report is a community signal. It does not count against you.',
            style: context.bodySmall,
          ),
        ],
        const SizedBox(height: 16),
        TextFormField(
          controller: _descriptionController,
          minLines: 4,
          maxLines: 8,
          enabled: !_submitting,
          decoration: const InputDecoration(
            labelText: 'What happened?',
            alignLabelWithHint: true,
          ),
        ),
        if (widget.entry.sessionActive) ...[
          const SizedBox(height: 8),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: _endSession,
            onChanged: _submitting ? null : (value) => setState(() => _endSession = value),
            title: const Text('End this chat now'),
            subtitle: const Text('Recommended. The other person will not be able to keep messaging you.'),
          ),
        ],
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _submitting ? null : _submit,
            child: Text(_submitting ? 'Sending…' : 'Send report'),
          ),
        ),
      ],
    );
  }

  Widget _buildReceipt(BuildContext context, ReportDto report) {
    final shortId = report.id.length >= 8 ? report.id.substring(0, 8).toUpperCase() : report.id.toUpperCase();
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('We received your report.', style: context.h2),
          const SizedBox(height: 12),
          Text(
            'Reference $shortId · ${report.type.label}. Keep this if you need to follow up.',
            style: context.bodyLarge,
          ),
          const SizedBox(height: 12),
          Text(
            'If you are in danger, contact local emergency services. Helping Hand is not an emergency service.',
            style: context.bodySmall,
          ),
          if (report.type.isVictimHarm) ...[
            const SizedBox(height: 12),
            Text('This does not penalize you for being harmed.', style: context.bodySmall),
          ],
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (report.sessionEnded) {
                  context.go('/');
                } else {
                  context.pop();
                }
              },
              child: Text(report.sessionEnded ? 'Back to home' : 'Done'),
            ),
          ),
        ],
      ),
    );
  }
}

extension ReportTypeCopy on ReportTypeDto {
  String get label => switch (this) {
    ReportTypeDto.HELPER_MISCONDUCT => 'Helper misconduct',
    ReportTypeDto.HELPEE_MISUSE => 'Misuse of a request',
    ReportTypeDto.SCAM => 'Scam or fraud',
    ReportTypeDto.THEFT => 'Theft',
    ReportTypeDto.UNSAFE_SITUATION => 'Unsafe situation',
  };

  String get hint => switch (this) {
    ReportTypeDto.HELPER_MISCONDUCT => 'Someone offering help behaved unsafely or unkindly.',
    ReportTypeDto.HELPEE_MISUSE => 'A request looks like a lure, spam, or policy breach.',
    ReportTypeDto.SCAM => 'You were targeted by a scam. This does not blame you.',
    ReportTypeDto.THEFT => 'You were stolen from. This does not blame you.',
    ReportTypeDto.UNSAFE_SITUATION => 'You felt unsafe or at risk.',
  };

  bool get isVictimHarm => this == ReportTypeDto.SCAM || this == ReportTypeDto.THEFT;
}
