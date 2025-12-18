// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Chat)
const chatProvider = ChatFamily._();

final class ChatProvider extends $AsyncNotifierProvider<Chat, ChatState> {
  const ChatProvider._({
    required ChatFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'chatProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$chatHash();

  @override
  String toString() {
    return r'chatProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  Chat create() => Chat();

  @override
  bool operator ==(Object other) {
    return other is ChatProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$chatHash() => r'14faffaf7442624c156d7e50b5fc8b0f679792e1';

final class ChatFamily extends $Family
    with
        $ClassFamilyOverride<
          Chat,
          AsyncValue<ChatState>,
          ChatState,
          FutureOr<ChatState>,
          String
        > {
  const ChatFamily._()
    : super(
        retry: null,
        name: r'chatProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ChatProvider call(String sessionId) =>
      ChatProvider._(argument: sessionId, from: this);

  @override
  String toString() => r'chatProvider';
}

abstract class _$Chat extends $AsyncNotifier<ChatState> {
  late final _$args = ref.$arg as String;
  String get sessionId => _$args;

  FutureOr<ChatState> build(String sessionId);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref = this.ref as $Ref<AsyncValue<ChatState>, ChatState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ChatState>, ChatState>,
              AsyncValue<ChatState>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
