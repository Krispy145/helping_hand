import 'dart:developer';

import 'package:mobile/flavors.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:utils/utils.dart';

import '../data/chat_models.dart';
import '../data/chat_repository.dart';

part 'chat_provider.g.dart';

// State for a single chat session
class ChatState {
  final List<ChatMessage> messages;
  final bool isConnected;

  ChatState({this.messages = const [], this.isConnected = false});

  ChatState copyWith({List<ChatMessage>? messages, bool? isConnected}) {
    return ChatState(messages: messages ?? this.messages, isConnected: isConnected ?? this.isConnected);
  }
}

@riverpod
class Chat extends _$Chat {
  late io.Socket _socket;
  late String _sessionId;

  @override
  Future<ChatState> build(String sessionId) async {
    _sessionId = sessionId;

    // Connect Socket immediately
    _connectSocket();

    // Register disposal
    ref.onDispose(() {
      _socket.dispose();
    });

    // Load history
    try {
      final repository = ref.read(chatRepositoryProvider);
      final history = await repository.getMessages(_sessionId);
      return ChatState(messages: history, isConnected: _socket.connected);
    } catch (e) {
      return ChatState(messages: [], isConnected: _socket.connected);
    }
  }

  void _connectSocket() {
    final uri = '${F.apiBaseUrl}${ApiEndpoints.chatSocket}';

    _socket = io.io(uri, io.OptionBuilder().setTransports(['websocket']).disableAutoConnect().build());

    _socket.onConnect((_) {
      if (state.hasValue) {
        state = AsyncValue.data(state.value!.copyWith(isConnected: true));
      }
      _socket.emit('join_session', {'sessionId': _sessionId});
    });

    _socket.onDisconnect((_) {
      if (state.hasValue) {
        state = AsyncValue.data(state.value!.copyWith(isConnected: false));
      }
    });

    _socket.on('new_message', (data) {
      try {
        final msg = ChatMessageMapper.fromMap(data as Map<String, dynamic>);
        if (state.hasValue) {
          final currentList = state.value!.messages;
          state = AsyncValue.data(state.value!.copyWith(messages: [...currentList, msg]));
        }
      } catch (e) {
        log('Error parsing message: $e');
      }
    });

    _socket.connect();
  }

  void sendMessage(String content, String senderId) {
    if (_socket.connected == false) return;
    _socket.emit('send_message', {'sessionId': _sessionId, 'content': content, 'senderId': senderId});
  }
}
