import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:models/models.dart';

import '../../chat/data/chat_models.dart';
import '../../chat/data/chat_repository.dart';
import '../providers/request_provider.dart';

extension RequestBusyX on RequestDto {
  bool get isBusy => status == RequestStatusDto.IN_PROGRESS;
}

ChatSessionDetails? sessionForRequest(List<ChatSessionDetails>? sessions, String requestId) {
  if (sessions == null) return null;
  for (final session in sessions) {
    if (session.requestId == requestId) return session;
  }
  return null;
}

Future<void> openOrStartAssist({
  required BuildContext context,
  required WidgetRef ref,
  required RequestDto request,
}) async {
  final repository = ref.read(chatRepositoryProvider);
  final nearby = ref.read(nearbyRequestsProvider.notifier);

  try {
    final availability = await repository.checkOfferAvailability(request.id);

    if (availability.sessionId != null) {
      if (context.mounted) {
        await context.push('/session/${availability.sessionId}');
      }
      return;
    }

    if (!availability.open) {
      if (availability.busy) {
        nearby.patchStatus(request.id, RequestStatusDto.IN_PROGRESS);
      }
      unawaited(nearby.refresh());
      ref.invalidate(mySessionsProvider);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(availability.userMessage)));
      }
      return;
    }

    final session = await repository.createSession(request.id);
    nearby.patchStatus(request.id, RequestStatusDto.IN_PROGRESS);
    ref.invalidate(mySessionsProvider);
    unawaited(nearby.refresh());
    if (context.mounted) {
      await context.push('/session/${session.id}');
    }
  } on DioException catch (error) {
    if (error.response?.statusCode == 409) {
      nearby.patchStatus(request.id, RequestStatusDto.IN_PROGRESS);
    }
    unawaited(nearby.refresh());
    ref.invalidate(mySessionsProvider);
    if (!context.mounted) return;
    final status = error.response?.statusCode;
    final message = status == 409
        ? 'Someone is already helping with this request.'
        : 'Failed to start session: ${error.message}';
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  } catch (error) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to start session: $error')));
    }
  }
}
