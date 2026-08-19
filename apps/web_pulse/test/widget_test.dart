import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_pulse/app.dart';
import 'package:web_pulse/core/shared_preferences_provider.dart';

void main() {
  testWidgets('shows Humanity Pulse sign-in', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [sharedPreferencesProvider.overrideWith((_) => prefs)],
        child: const PulseApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Humanity Pulse'), findsWidgets);
    expect(find.text('Sign in'), findsOneWidget);
  });
}
