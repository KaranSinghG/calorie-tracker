import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/edit_profile_page.dart';
import 'package:frontend/models/user_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  final user = UserProfile(
    id: 1,
    username: 'karan',
    email: 'karan@example.com',
    age: 25,
    gender: 'MALE',
    weight: 70.0,
    height: 175.0,
    activityLevel: 'MODERATELY_ACTIVE',
    goalType: 'CUTTING',
    createdAt: DateTime(2026, 1, 1),
  );

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('EditProfilePage pre-fills the current profile values',
      (tester) async {
    await tester.pumpWidget(MaterialApp(home: EditProfilePage(user: user)));

    expect(find.text('Edit Profile'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'karan'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, '25'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, '70.0'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, '175.0'), findsOneWidget);
    // Dropdowns show the current selection.
    expect(find.text('Cutting'), findsOneWidget);
    expect(find.text('Moderately active'), findsOneWidget);
    expect(find.text('Male'), findsOneWidget);
  });

  testWidgets('EditProfilePage validates required fields', (tester) async {
    await tester.pumpWidget(MaterialApp(home: EditProfilePage(user: user)));

    // Clear the username and age fields.
    await tester.enterText(
        find.widgetWithText(TextFormField, 'karan'), '');
    await tester.enterText(find.widgetWithText(TextFormField, '25'), '');

    await tester.ensureVisible(find.text('Save changes'));
    await tester.tap(find.text('Save changes'));
    await tester.pump();

    expect(find.text('Please enter your username'), findsOneWidget);
    expect(find.text('Please enter a valid age'), findsOneWidget);
  });
}
