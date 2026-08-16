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

class ChatParticipant {
  final String id;
  final String? name;

  const ChatParticipant({required this.id, this.name});

  factory ChatParticipant.fromMap(Map<String, dynamic> map) {
    return ChatParticipant(id: map['id'] as String, name: map['name'] as String?);
  }
}

class ChatRequestSummary {
  final String title;
  final String description;
  final String? category;
  final String urgency;
  final String? status;

  const ChatRequestSummary({required this.title, required this.description, this.category, required this.urgency, this.status});

  factory ChatRequestSummary.fromMap(Map<String, dynamic> map) {
    return ChatRequestSummary(
      title: map['title'] as String,
      description: map['description'] as String,
      category: map['category'] as String?,
      urgency: map['urgency'] as String,
      status: map['status'] as String?,
    );
  }
}

class ChatSessionDetails {
  final String id;
  final String requestId;
  final String helperId;
  final String status;
  final ChatRequestSummary request;
  final ChatParticipant requester;
  final ChatParticipant helper;

  const ChatSessionDetails({
    required this.id,
    required this.requestId,
    required this.helperId,
    required this.status,
    required this.request,
    required this.requester,
    required this.helper,
  });

  factory ChatSessionDetails.fromMap(Map<String, dynamic> map) {
    return ChatSessionDetails(
      id: map['id'] as String,
      requestId: map['requestId'] as String,
      helperId: map['helperId'] as String,
      status: map['status'] as String,
      request: ChatRequestSummary.fromMap(map['request'] as Map<String, dynamic>),
      requester: ChatParticipant.fromMap(map['requester'] as Map<String, dynamic>),
      helper: ChatParticipant.fromMap(map['helper'] as Map<String, dynamic>),
    );
  }

  String otherPartyName(String? currentUserId) {
    final other = currentUserId == helperId ? requester : helper;
    return other.name?.trim().isNotEmpty == true ? other.name! : 'Helper';
  }

  bool get isActive => status == 'ACTIVE';
}

class OfferAvailability {
  final bool open;
  final bool busy;
  final String reason;
  final String? sessionId;

  const OfferAvailability({required this.open, required this.busy, required this.reason, this.sessionId});

  factory OfferAvailability.fromMap(Map<String, dynamic> map) {
    return OfferAvailability(
      open: map['open'] as bool? ?? false,
      busy: map['busy'] as bool? ?? false,
      reason: map['reason'] as String? ?? 'not_open',
      sessionId: map['sessionId'] as String?,
    );
  }

  String get userMessage {
    switch (reason) {
      case 'busy':
        return 'Someone is already helping with this request.';
      case 'own_request':
        return 'You cannot offer help on your own request.';
      case 'not_open':
        return 'This request is no longer open for help.';
      default:
        return 'This request is not available.';
    }
  }
}
