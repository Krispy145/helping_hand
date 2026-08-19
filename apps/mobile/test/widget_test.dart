// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/app.dart';
import 'package:mobile/core/shared_preferences_provider.dart';
import 'package:mobile/flavors.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    F.appFlavor = Flavor.dev;
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('Smoke test: App launches LoginScreen', (tester) async {
    final prefs = await SharedPreferences.getInstance();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [sharedPreferencesProvider.overrideWith((ref) => prefs)],
        child: const App(),
      ),
    );
    await tester.pump(const Duration(seconds: 2));

    expect(find.text('Welcome Back'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
  });
}
