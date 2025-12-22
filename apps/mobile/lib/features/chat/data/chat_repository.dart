import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:utils/utils.dart';

import '../../../../core/network/dio_provider.dart';
import 'chat_models.dart';

class ChatRepository {
  final Dio _dio;

  ChatRepository(this._dio);

  Future<ChatSession> createSession(String requestId) async {
    final response = await _dio.post<Map<String, dynamic>>(ApiEndpoints.sessions, data: {'requestId': requestId});
    return ChatSessionMapper.fromMap(response.data!);
  }

  Future<List<ChatMessage>> getMessages(String sessionId) async {
    final response = await _dio.get<List<dynamic>>(ApiEndpoints.sessionsMessages(sessionId));
    return response.data!.map((e) => ChatMessageMapper.fromMap(e as Map<String, dynamic>)).toList();
  }
}

final chatRepositoryProvider = Provider((ref) {
  return ChatRepository(ref.watch(dioProvider));
});
