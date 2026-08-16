import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:utils/utils.dart';

import '../../../../core/network/dio_provider.dart';
import 'chat_models.dart';

class ChatRepository {
  final Dio _dio;

  ChatRepository(this._dio);

  Future<OfferAvailability> checkOfferAvailability(String requestId) async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.sessionsAvailability,
      queryParameters: {'requestId': requestId},
    );
    return OfferAvailability.fromMap(response.data!);
  }

  Future<ChatSession> createSession(String requestId) async {
    final response = await _dio.post<Map<String, dynamic>>(ApiEndpoints.sessions, data: {'requestId': requestId});
    return ChatSessionMapper.fromMap(response.data!);
  }

  Future<List<ChatSessionDetails>> getMySessions() async {
    final response = await _dio.get<List<dynamic>>(ApiEndpoints.sessions);
    final data = response.data ?? [];
    return [
      for (final item in data)
        if (item is Map<String, dynamic>) ChatSessionDetails.fromMap(item),
    ];
  }

  Future<ChatSessionDetails> getSession(String sessionId) async {
    final response = await _dio.get<Map<String, dynamic>>(ApiEndpoints.session(sessionId));
    return ChatSessionDetails.fromMap(response.data!);
  }

  Future<List<ChatMessage>> getMessages(String sessionId) async {
    final response = await _dio.get<List<dynamic>>(ApiEndpoints.sessionsMessages(sessionId));
    return response.data!.map((e) => ChatMessageMapper.fromMap(e as Map<String, dynamic>)).toList();
  }

  Future<void> cancelAssist(String sessionId) async {
    await _dio.post<Map<String, dynamic>>(ApiEndpoints.sessionCancel(sessionId));
  }

  Future<ChatSessionDetails> completeAssist(String sessionId) async {
    final response = await _dio.post<Map<String, dynamic>>(ApiEndpoints.sessionComplete(sessionId));
    return ChatSessionDetails.fromMap(response.data!);
  }
}

final chatRepositoryProvider = Provider((ref) {
  return ChatRepository(ref.watch(dioProvider));
});

final sessionDetailsProvider = FutureProvider.family<ChatSessionDetails, String>((ref, sessionId) {
  return ref.watch(chatRepositoryProvider).getSession(sessionId);
});

final mySessionsProvider = FutureProvider<List<ChatSessionDetails>>((ref) {
  return ref.watch(chatRepositoryProvider).getMySessions();
});
