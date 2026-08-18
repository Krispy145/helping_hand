import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:models/models.dart';
import 'package:ui/ui.dart';

import '../../auth/providers/auth_provider.dart';
import 'verification_gate.dart';

class VerificationScreen extends ConsumerStatefulWidget {
  const VerificationScreen({super.key});

  @override
  ConsumerState<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends ConsumerState<VerificationScreen> {
  bool _busy = false;

  Future<void> _complete(String outcome) async {
    setState(() => _busy = true);
    try {
      await ref.read(verificationRepositoryProvider).start();
      await ref.read(verificationRepositoryProvider).completeStub(outcome);
      await ref.read(authProvider.notifier).refreshProfile();
      if (!mounted) return;
      final user = ref.read(authProvider).asData?.value;
      if (user?.canParticipate ?? false) {
        context.pop(true);
        return;
      }
      final message = user?.verificationFailureReason == VerificationFailureReasonDto.UNDERAGE ? 'Helping Hand is for adults 18 and over.' : 'Verification did not complete. You can try again later.';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Verification failed: $error')));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).asData?.value;
    final verified = isVerifiedAdult(user);
    final underage = user?.verificationFailureReason == VerificationFailureReasonDto.UNDERAGE;

    return Scaffold(
      appBar: AppBar(title: const Text('Identity check')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Helping Hand is for verified adults. We do not store ID documents, legal names, or dates of birth — a provider only tells us whether you are a real adult.',
                style: context.bodyMedium,
              ),
              const SizedBox(height: 16),
              Text(
                verified
                    ? 'Verified adult'
                    : underage
                    ? 'This account cannot be used. Helping Hand is 18+.'
                    : 'Not verified yet',
                style: context.bodySmall.copyWith(color: verified ? context.success : context.textSecondary, fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              if (!verified && !underage) ...[
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _busy ? null : () => _complete('verified'),
                    child: _busy ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('I am 18 or older'),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(onPressed: _busy ? null : () => _complete('underage'), child: const Text('I am under 18')),
                ),
                const SizedBox(height: 8),
                Text(
                  'This is a development stub. A real ID provider will replace these buttons.',
                  style: context.bodySmall.copyWith(color: context.textSecondary),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
