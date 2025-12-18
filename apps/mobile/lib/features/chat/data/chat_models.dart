import 'package:dart_mappable/dart_mappable.dart';

part 'chat_models.mapper.dart';

@MappableClass()
class ChatMessage with ChatMessageMappable {
  final String id;
  final String sessionId;
  final String senderId;
  final String content;
  final DateTime createdAt;

  const ChatMessage({required this.id, required this.sessionId, required this.senderId, required this.content, required this.createdAt});
}

@MappableClass()
class ChatSession with ChatSessionMappable {
  final String id;
  final String requestId;
  final String helperId;
  final String status;
  // potentially helper/requestor objects

  const ChatSession({required this.id, required this.requestId, required this.helperId, required this.status});
}
