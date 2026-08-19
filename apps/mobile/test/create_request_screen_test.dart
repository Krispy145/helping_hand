import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/requests/presentation/create_request_screen.dart';
import 'package:ui/ui.dart';

void main() {
  testWidgets('empty submit shows Title and Description required errors', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: AppTheme.build(style: AppThemeStyle.primary, brightness: Brightness.light),
          home: const CreateRequestScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Submit Request'));
    await tester.tap(find.text('Submit Request'));
    await tester.pump();

    expect(find.text('Required'), findsNWidgets(2));
  });
}
