import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/dashboard_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('Dashboard shows a loading indicator then error state without backend',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: DashboardPage(email: 'user@example.com'),
      ),
    );

    // Loading indicator shown initially.
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Let the API call fail (no backend in test) and settle.
    await tester.pump(const Duration(seconds: 1));
    await tester.pump(const Duration(seconds: 1));

    // Error state with retry is shown.
    expect(find.textContaining('Unable to load dashboard'), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'Retry'), findsOneWidget);
  });

  testWidgets('Dashboard shows a sign out button', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: DashboardPage(email: 'user@example.com'),
      ),
    );

    expect(find.text('Sign out'), findsOneWidget);
  });
}