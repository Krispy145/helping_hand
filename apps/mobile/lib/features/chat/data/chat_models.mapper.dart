// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'chat_models.dart';

class ChatMessageMapper extends ClassMapperBase<ChatMessage> {
  ChatMessageMapper._();

  static ChatMessageMapper? _instance;
  static ChatMessageMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ChatMessageMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'ChatMessage';

  static String _$id(ChatMessage v) => v.id;
  static const Field<ChatMessage, String> _f$id = Field('id', _$id);
  static String _$sessionId(ChatMessage v) => v.sessionId;
  static const Field<ChatMessage, String> _f$sessionId = Field(
    'sessionId',
    _$sessionId,
  );
  static String _$senderId(ChatMessage v) => v.senderId;
  static const Field<ChatMessage, String> _f$senderId = Field(
    'senderId',
    _$senderId,
  );
  static String _$content(ChatMessage v) => v.content;
  static const Field<ChatMessage, String> _f$content = Field(
    'content',
    _$content,
  );
  static DateTime _$createdAt(ChatMessage v) => v.createdAt;
  static const Field<ChatMessage, DateTime> _f$createdAt = Field(
    'createdAt',
    _$createdAt,
  );

  @override
  final MappableFields<ChatMessage> fields = const {
    #id: _f$id,
    #sessionId: _f$sessionId,
    #senderId: _f$senderId,
    #content: _f$content,
    #createdAt: _f$createdAt,
  };

  static ChatMessage _instantiate(DecodingData data) {
    return ChatMessage(
      id: data.dec(_f$id),
      sessionId: data.dec(_f$sessionId),
      senderId: data.dec(_f$senderId),
      content: data.dec(_f$content),
      createdAt: data.dec(_f$createdAt),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static ChatMessage fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ChatMessage>(map);
  }

  static ChatMessage fromJson(String json) {
    return ensureInitialized().decodeJson<ChatMessage>(json);
  }
}

mixin ChatMessageMappable {
  String toJson() {
    return ChatMessageMapper.ensureInitialized().encodeJson<ChatMessage>(
      this as ChatMessage,
    );
  }

  Map<String, dynamic> toMap() {
    return ChatMessageMapper.ensureInitialized().encodeMap<ChatMessage>(
      this as ChatMessage,
    );
  }

  ChatMessageCopyWith<ChatMessage, ChatMessage, ChatMessage> get copyWith =>
      _ChatMessageCopyWithImpl<ChatMessage, ChatMessage>(
        this as ChatMessage,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return ChatMessageMapper.ensureInitialized().stringifyValue(
      this as ChatMessage,
    );
  }

  @override
  bool operator ==(Object other) {
    return ChatMessageMapper.ensureInitialized().equalsValue(
      this as ChatMessage,
      other,
    );
  }

  @override
  int get hashCode {
    return ChatMessageMapper.ensureInitialized().hashValue(this as ChatMessage);
  }
}

extension ChatMessageValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ChatMessage, $Out> {
  ChatMessageCopyWith<$R, ChatMessage, $Out> get $asChatMessage =>
      $base.as((v, t, t2) => _ChatMessageCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ChatMessageCopyWith<$R, $In extends ChatMessage, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? id,
    String? sessionId,
    String? senderId,
    String? content,
    DateTime? createdAt,
  });
  ChatMessageCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _ChatMessageCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ChatMessage, $Out>
    implements ChatMessageCopyWith<$R, ChatMessage, $Out> {
  _ChatMessageCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ChatMessage> $mapper =
      ChatMessageMapper.ensureInitialized();
  @override
  $R call({
    String? id,
    String? sessionId,
    String? senderId,
    String? content,
    DateTime? createdAt,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (sessionId != null) #sessionId: sessionId,
      if (senderId != null) #senderId: senderId,
      if (content != null) #content: content,
      if (createdAt != null) #createdAt: createdAt,
    }),
  );
  @override
  ChatMessage $make(CopyWithData data) => ChatMessage(
    id: data.get(#id, or: $value.id),
    sessionId: data.get(#sessionId, or: $value.sessionId),
    senderId: data.get(#senderId, or: $value.senderId),
    content: data.get(#content, or: $value.content),
    createdAt: data.get(#createdAt, or: $value.createdAt),
  );

  @override
  ChatMessageCopyWith<$R2, ChatMessage, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ChatMessageCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class ChatSessionMapper extends ClassMapperBase<ChatSession> {
  ChatSessionMapper._();

  static ChatSessionMapper? _instance;
  static ChatSessionMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ChatSessionMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'ChatSession';

  static String _$id(ChatSession v) => v.id;
  static const Field<ChatSession, String> _f$id = Field('id', _$id);
  static String _$requestId(ChatSession v) => v.requestId;
  static const Field<ChatSession, String> _f$requestId = Field(
    'requestId',
    _$requestId,
  );
  static String _$helperId(ChatSession v) => v.helperId;
  static const Field<ChatSession, String> _f$helperId = Field(
    'helperId',
    _$helperId,
  );
  static String _$status(ChatSession v) => v.status;
  static const Field<ChatSession, String> _f$status = Field('status', _$status);

  @override
  final MappableFields<ChatSession> fields = const {
    #id: _f$id,
    #requestId: _f$requestId,
    #helperId: _f$helperId,
    #status: _f$status,
  };

  static ChatSession _instantiate(DecodingData data) {
    return ChatSession(
      id: data.dec(_f$id),
      requestId: data.dec(_f$requestId),
      helperId: data.dec(_f$helperId),
      status: data.dec(_f$status),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static ChatSession fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ChatSession>(map);
  }

  static ChatSession fromJson(String json) {
    return ensureInitialized().decodeJson<ChatSession>(json);
  }
}

mixin ChatSessionMappable {
  String toJson() {
    return ChatSessionMapper.ensureInitialized().encodeJson<ChatSession>(
      this as ChatSession,
    );
  }

  Map<String, dynamic> toMap() {
    return ChatSessionMapper.ensureInitialized().encodeMap<ChatSession>(
      this as ChatSession,
    );
  }

  ChatSessionCopyWith<ChatSession, ChatSession, ChatSession> get copyWith =>
      _ChatSessionCopyWithImpl<ChatSession, ChatSession>(
        this as ChatSession,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return ChatSessionMapper.ensureInitialized().stringifyValue(
      this as ChatSession,
    );
  }

  @override
  bool operator ==(Object other) {
    return ChatSessionMapper.ensureInitialized().equalsValue(
      this as ChatSession,
      other,
    );
  }

  @override
  int get hashCode {
    return ChatSessionMapper.ensureInitialized().hashValue(this as ChatSession);
  }
}

extension ChatSessionValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ChatSession, $Out> {
  ChatSessionCopyWith<$R, ChatSession, $Out> get $asChatSession =>
      $base.as((v, t, t2) => _ChatSessionCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ChatSessionCopyWith<$R, $In extends ChatSession, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? id, String? requestId, String? helperId, String? status});
  ChatSessionCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _ChatSessionCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ChatSession, $Out>
    implements ChatSessionCopyWith<$R, ChatSession, $Out> {
  _ChatSessionCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ChatSession> $mapper =
      ChatSessionMapper.ensureInitialized();
  @override
  $R call({String? id, String? requestId, String? helperId, String? status}) =>
      $apply(
        FieldCopyWithData({
          if (id != null) #id: id,
          if (requestId != null) #requestId: requestId,
          if (helperId != null) #helperId: helperId,
          if (status != null) #status: status,
        }),
      );
  @override
  ChatSession $make(CopyWithData data) => ChatSession(
    id: data.get(#id, or: $value.id),
    requestId: data.get(#requestId, or: $value.requestId),
    helperId: data.get(#helperId, or: $value.helperId),
    status: data.get(#status, or: $value.status),
  );

  @override
  ChatSessionCopyWith<$R2, ChatSession, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ChatSessionCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

