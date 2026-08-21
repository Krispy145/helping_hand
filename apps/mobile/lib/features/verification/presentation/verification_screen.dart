import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:models/models.dart';
import 'package:ui/ui.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../auth/providers/auth_provider.dart';
import 'verification_gate.dart';

class VerificationScreen extends ConsumerStatefulWidget {
  const VerificationScreen({super.key});

  @override
  ConsumerState<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends ConsumerState<VerificationScreen>
    with WidgetsBindingObserver {
  bool _busy = false;
  bool _didAttempt = false;
  String? _error;
  DateTime? _dateOfBirth;
  VerificationStatusResponseDto? _status;
  Timer? _poll;

  int get _minimumAge =>
      _status?.ageThreshold ??
      minimumUserAge(ref.read(authProvider).asData?.value);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadStatus();
  }

  @override
  void dispose() {
    _poll?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(_refreshFromProvider());
    }
  }

  Future<void> _loadStatus() async {
    try {
      final status = await ref.read(verificationRepositoryProvider).getStatus();
      if (!mounted) return;
      setState(() {
        _status = status;
        _error = _messageFor(status);
      });
      unawaited(_syncProfile());
      _maybePoll(status);
    } on DioException catch (error) {
      if (!mounted) return;
      setState(() => _error = _networkMessage(error));
    }
  }

  Future<void> _refreshFromProvider() async {
    if (_busy) return;
    try {
      final status = await ref.read(verificationRepositoryProvider).refresh();
      if (!mounted) return;
      setState(() {
        _status = status;
        _error = _messageFor(status);
      });
      await _syncProfile();
      _finishIfVerified();
      _maybePoll(status);
    } on DioException catch (error) {
      if (!mounted) return;
      setState(() => _error = _networkMessage(error));
    }
  }

  Future<void> _syncProfile() async {
    try {
      await ref.read(authProvider.notifier).refreshProfile();
    } catch (_) {
      // Status endpoint is authoritative for this screen.
    }
  }

  void _finishIfVerified() {
    if (!_didAttempt) return;
    final verified =
        _status?.isVerified ??
        isVerifiedAdult(ref.read(authProvider).asData?.value);
    if (verified && mounted) {
      _poll?.cancel();
      Navigator.of(context).pop(true);
    }
  }

  void _maybePoll(VerificationStatusResponseDto status) {
    _poll?.cancel();
    final waiting =
        status.verificationStatus == VerificationStatusDto.PENDING ||
        status.verificationStatus == VerificationStatusDto.REQUIRES_DOCUMENT;
    if (!waiting) return;
    _poll = Timer.periodic(const Duration(seconds: 4), (_) {
      unawaited(_refreshFromProvider());
    });
  }

  Future<void> _pickDateOfBirth() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - _minimumAge, now.month, now.day),
      firstDate: DateTime(now.year - 120),
      lastDate: now,
      helpText: 'Date of birth',
    );
    if (picked != null && mounted) {
      setState(() => _dateOfBirth = picked);
    }
  }

  Future<void> _startVerification() async {
    final dob = _dateOfBirth;
    if (dob == null) {
      setState(() => _error = 'Enter your date of birth first.');
      return;
    }

    setState(() {
      _busy = true;
      _didAttempt = true;
      _error = null;
    });
    try {
      final eligibility = await ref
          .read(verificationRepositoryProvider)
          .checkEligibility(dob);
      if (!eligibility.eligible) {
        setState(() {
          _error =
              'You must be at least ${eligibility.ageThreshold} years old to use this feature.';
        });
        return;
      }

      final status = await ref.read(verificationRepositoryProvider).start();
      if (!mounted) return;
      setState(() => _status = status);
      await _syncProfile();
      if (status.isVerified) {
        _finishIfVerified();
        return;
      }
      if (status.launchUrl != null) {
        await _openProvider(status.launchUrl!);
        _maybePoll(status);
        return;
      }
      if (status.stub) {
        return;
      }
      setState(
        () => _error =
            'Age verification is temporarily unavailable. Try again later.',
      );
    } on DioException catch (error) {
      if (!mounted) return;
      setState(() => _error = _startError(error));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _startDocument() async {
    setState(() {
      _busy = true;
      _didAttempt = true;
      _error = null;
    });
    try {
      final status = await ref
          .read(verificationRepositoryProvider)
          .startDocument();
      if (!mounted) return;
      setState(() => _status = status);
      final url = status.documentLaunchUrl ?? status.launchUrl;
      if (url != null) {
        await _openProvider(url);
        _maybePoll(status);
        return;
      }
      setState(
        () => _error = 'Document verification is not available right now.',
      );
    } on DioException catch (error) {
      if (!mounted) return;
      setState(() => _error = _startError(error));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _completeStub(String outcome) async {
    setState(() {
      _busy = true;
      _didAttempt = true;
      _error = null;
    });
    try {
      await ref.read(verificationRepositoryProvider).start();
      await ref.read(verificationRepositoryProvider).completeStub(outcome);
      await _syncProfile();
      if (!mounted) return;
      final user = ref.read(authProvider).asData?.value;
      if (user?.canParticipate ?? false) {
        Navigator.of(context).pop(true);
        return;
      }
      final status = await ref.read(verificationRepositoryProvider).getStatus();
      setState(() {
        _status = status;
        _error = _messageFor(status);
      });
    } catch (error) {
      if (mounted) {
        setState(() => _error = 'Verification failed: $error');
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _openProvider(String url) async {
    final uri = Uri.parse(url);
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched && mounted) {
      setState(() => _error = 'Could not open the age verification provider.');
    }
  }

  String _startError(DioException error) {
    final status = error.response?.statusCode;
    if (status == 403) {
      return 'Helping Hand is for adults $_minimumAge and over.';
    }
    if (status == 409) {
      return 'A verification session is already in progress.';
    }
    if (status == 503) {
      return 'Age verification is temporarily unavailable. Try again later.';
    }
    return _networkMessage(error);
  }

  String _networkMessage(DioException error) {
    if (error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.connectionTimeout) {
      return 'Network error. Check your connection and try again.';
    }
    return 'Could not reach age verification. Try again.';
  }

  String? _messageFor(VerificationStatusResponseDto status) {
    if (status.isVerified) return null;
    if (status.isUnderage) {
      return 'Helping Hand is for adults ${status.ageThreshold ?? _minimumAge} and over.';
    }
    if (status.verificationFailureReason ==
        VerificationFailureReasonDto.EXPIRED) {
      return 'Your verification session expired. Start again to continue.';
    }
    if (status.verificationFailureReason ==
        VerificationFailureReasonDto.PROVIDER_REJECTED) {
      return 'Verification did not complete. You can try again.';
    }
    if (status.needsDocument) {
      return 'We could not confirm your age from the face scan. You can verify with a government ID instead.';
    }
    if (status.verificationStatus == VerificationStatusDto.PENDING) {
      return 'Waiting for the independent check to finish. This can take a few seconds.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).asData?.value;
    final verified = _status?.isVerified ?? isVerifiedAdult(user);
    final underage =
        _status?.isUnderage ??
        user?.verificationFailureReason ==
            VerificationFailureReasonDto.UNDERAGE;
    final pending =
        _status?.verificationStatus == VerificationStatusDto.PENDING;
    final needsDocument = _status?.needsDocument ?? false;

    return Scaffold(
      appBar: AppBar(title: const Text('Verify your age')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'You must be at least $_minimumAge years old to request or offer help.',
                style: context.bodyMedium,
              ),
              const SizedBox(height: 12),
              Text(
                'We use an independent age-verification provider to confirm eligibility. Helping Hand stores only the verification result — not your selfie, identity document, or date of birth.',
                style: context.bodyMedium.copyWith(
                  color: context.textSecondary,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                _statusLabel(
                  verified: verified,
                  underage: underage,
                  pending: pending,
                  needsDocument: needsDocument,
                ),
                style: context.bodySmall.copyWith(
                  color: verified ? context.success : context.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(
                  _error!,
                  style: context.bodySmall.copyWith(color: context.error),
                ),
              ],
              if (!verified && !underage) ...[
                if (!pending && !needsDocument) ...[
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Date of birth'),
                    subtitle: Text(
                      _dateOfBirth == null
                          ? 'Used only to check eligibility. It is not stored.'
                          : '${_dateOfBirth!.year}-${_dateOfBirth!.month.toString().padLeft(2, '0')}-${_dateOfBirth!.day.toString().padLeft(2, '0')}',
                    ),
                    trailing: const Icon(Icons.calendar_today_outlined),
                    onTap: _busy ? null : _pickDateOfBirth,
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _busy ? null : _startVerification,
                      child: _busy
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Verify my age'),
                    ),
                  ),
                ],
                if (pending) ...[
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _busy ? null : _refreshFromProvider,
                      child: const Text('I have finished the check'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'If the provider is still processing, we will keep checking automatically.',
                    style: context.bodySmall.copyWith(
                      color: context.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
                if (needsDocument) ...[
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _busy ? null : _startDocument,
                      child: const Text('Verify with government ID'),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
                if (_status?.stub ?? false) ...[
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _busy ? null : () => _completeStub('verified'),
                      child: const Text('I am old enough (dev stub)'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: _busy ? null : () => _completeStub('underage'),
                      child: const Text('I am under the minimum age'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: _busy ? null : () => _completeStub('document'),
                      child: const Text('Face scan inconclusive (dev stub)'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Development stub. A live Yoti session replaces these controls when provider credentials are configured.',
                    style: context.bodySmall.copyWith(
                      color: context.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
                const SizedBox(height: 16),
                ExpansionTile(
                  tilePadding: EdgeInsets.zero,
                  title: Text(
                    'Why do I need to verify?',
                    style: context.bodySmall.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  children: [
                    Text(
                      'Helping Hand is adults-only. An independent provider confirms you meet the minimum age using a face scan with liveness checks, and a government ID only if that is not enough. We do not keep copies of those images.',
                      style: context.bodySmall.copyWith(
                        color: context.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _statusLabel({
    required bool verified,
    required bool underage,
    required bool pending,
    required bool needsDocument,
  }) {
    if (verified) {
      return 'Verified';
    }
    if (underage) {
      return 'This account cannot be used. Helping Hand is $_minimumAge+.';
    }
    if (needsDocument) {
      return 'Document verification required';
    }
    if (pending) {
      return 'Verification in progress';
    }
    return 'Not verified yet';
  }
}
