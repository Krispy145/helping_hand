import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/chat/data/chat_models.dart';
import 'package:mobile/features/chat/data/chat_repository.dart';
import 'package:mobile/features/home/presentation/feed_screen.dart';
import 'package:mobile/features/requests/providers/request_provider.dart';
import 'package:models/models.dart';
import 'package:ui/ui.dart';

class _LoadingNearby extends NearbyRequestsNotifier {
  @override
  Future<List<RequestDto>> build() => Completer<List<RequestDto>>().future;
}

class _FeedNearby extends NearbyRequestsNotifier {
  @override
  Future<List<RequestDto>> build() async {
    return [
      RequestDto(
        id: 'req-1',
        title: 'Need groceries',
        description: 'A few essentials from the corner shop.',
        status: RequestStatusDto.APPROVED,
        urgency: RequestUrgencyDto.MEDIUM,
        createdAt: DateTime.utc(2026, 8, 19),
        updatedAt: DateTime.utc(2026, 8, 19),
      ),
    ];
  }
}

Widget _app({required NearbyRequestsNotifier Function() nearby}) {
  return ProviderScope(
    overrides: [
      nearbyRequestsProvider.overrideWith(nearby),
      mySessionsProvider.overrideWith((ref) async => <ChatSessionDetails>[]),
    ],
    child: MaterialApp(
      theme: AppTheme.build(style: AppThemeStyle.primary, brightness: Brightness.light),
      home: const Scaffold(body: FeedScreen()),
    ),
  );
}

void main() {
  testWidgets('shows a spinner while nearby requests are loading', (tester) async {
    await tester.pumpWidget(_app(nearby: _LoadingNearby.new));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('renders nearby request titles after load', (tester) async {
    await tester.pumpWidget(_app(nearby: _FeedNearby.new));
    await tester.pumpAndSettle();

    expect(find.text('Need groceries'), findsOneWidget);
    expect(find.text('A few essentials from the corner shop.'), findsOneWidget);
    expect(find.text('Assist'), findsOneWidget);
  });
}
