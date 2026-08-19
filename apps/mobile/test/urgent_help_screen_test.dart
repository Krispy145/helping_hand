import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/urgent_help/presentation/urgent_help_screen.dart';
import 'package:ui/ui.dart';

void main() {
  testWidgets('lists emergency and helpline routes', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.build(style: AppThemeStyle.primary, brightness: Brightness.light),
        home: const UrgentHelpScreen(),
      ),
    );

    expect(find.text('Get urgent help'), findsOneWidget);
    expect(
      find.textContaining('Helping Hand is not an emergency service'),
      findsOneWidget,
    );
    expect(find.text('Emergency services'), findsOneWidget);
    expect(find.textContaining('Call 112'), findsOneWidget);
    expect(find.text('SADAG suicide crisis line'), findsOneWidget);
  });
}
