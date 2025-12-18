import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:utils/utils.dart';

import '../../../../core/network/dio_provider.dart';
import 'chat_models.dart';

class ChatRepository {
  final Dio _dio;

  ChatRepository(this._dio);

  Future<ChatSession> createSession(String requestId) async {
    final response = await _dio.post(ApiEndpoints.sessions, data: {'requestId': requestId});
    return ChatSessionMapper.fromMap(response.data as Map<String, dynamic>);
  }

  Future<List<ChatMessage>> getMessages(String sessionId) async {
    final response = await _dio.get(ApiEndpoints.sessionsMessages(sessionId));
    return (response.data as List).map((e) => ChatMessageMapper.fromMap(e as Map<String, dynamic>)).toList();
  }
}

final chatRepositoryProvider = Provider((ref) {
  return ChatRepository(ref.watch(dioProvider));
});
