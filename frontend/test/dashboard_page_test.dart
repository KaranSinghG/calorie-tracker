import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/dashboard_page.dart';

void main() {
  testWidgets('Dashboard shows the signed-in email', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: DashboardPage(email: 'user@example.com'),
      ),
    );

    expect(find.text('user@example.com'), findsOneWidget);
  });
}
