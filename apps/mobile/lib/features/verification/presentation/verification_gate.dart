import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:models/models.dart';

import '../../../core/api_client_provider.dart';
import '../../../router.dart';
import '../../auth/providers/auth_provider.dart';
import '../data/verification_repository.dart';

final verificationRepositoryProvider = Provider<VerificationRepository>((ref) {
  return VerificationRepository(dio: ref.watch(apiClientProvider));
});

bool isVerifiedAdult(UserDto? user) => user?.canParticipate ?? false;

int minimumUserAge(UserDto? user) => user?.ageThreshold ?? 18;

Future<bool> ensureVerifiedAdult(BuildContext context, WidgetRef ref) async {
  if (isVerifiedAdult(ref.read(authProvider).asData?.value)) return true;
  if (!context.mounted) return false;
  await context.push(AppRoutes.verification);
  return isVerifiedAdult(ref.read(authProvider).asData?.value);
}
