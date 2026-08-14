import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/food_picker_dialog.dart';
import 'package:frontend/models/food.dart';

/// Smoke test for the food picker, exercising it with real mouse events to
/// make sure hover/scroll interactions don't trip framework assertions
/// (e.g. rendering/mouse_tracker.dart).
void main() {
  testWidgets('picker handles mouse hover, search, selection and submit',
      (tester) async {
    final foods = [
      Food(id: 1, name: 'Basmati Rice', calories: 356, carbohydrate: 77.0, protein: 7.1, fat: 0.6),
      Food(id: 2, name: 'Whole Wheat Roti', calories: 297, carbohydrate: 47.0, protein: 7.8, fat: 0.9),
      Food(id: 3, name: 'Toor Dal', calories: 116, carbohydrate: 20.0, protein: 7.2, fat: 0.4),
      Food(id: 4, name: 'Paneer', calories: 265, carbohydrate: 2.6, protein: 18.0, fat: 20.8),
      Food(id: 5, name: 'Palak Paneer', calories: 122, carbohydrate: 5.7, protein: 9.2, fat: 7.6),
      Food(id: 6, name: 'Chicken Curry', calories: 165, carbohydrate: 5.0, protein: 24.0, fat: 5.2),
      Food(id: 7, name: 'Mango', calories: 60, carbohydrate: 15.0, protein: 0.8, fat: 0.4),
      Food(id: 8, name: 'Banana', calories: 89, carbohydrate: 23.0, protein: 1.1, fat: 0.3),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => Center(
              child: TextButton(
                onPressed: () => showDialog<FoodLogInput>(
                  context: context,
                  builder: (_) => FoodPickerDialog(foods: foods),
                ),
                child: const Text('open picker'),
              ),
            ),
          ),
        ),
      ),
    );

    // Open the picker dialog.
    await tester.tap(find.text('open picker'));
    await tester.pumpAndSettle();

    expect(find.text('Choose a food'), findsOneWidget);
    expect(find.byType(ListTile), findsWidgets);
    expect(find.text('Banana'), findsOneWidget); // first alphabetically

    // Create a real mouse device and move it across the visible tiles.
    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: const Offset(20, 20));
    addTearDown(() => mouse.removePointer());
    await tester.pump();

    final visibleTiles = find.byType(ListTile).evaluate().length;
    for (var i = 0; i < visibleTiles.clamp(0, 3); i++) {
      await mouse.moveTo(tester.getRect(find.byType(ListTile).at(i)).center);
      await tester.pump();
    }

    // Type in the search box to filter.
    await tester.tap(find.byType(TextField).first);
    await tester.enterText(find.byType(TextField).first, 'paneer');
    await tester.pumpAndSettle();
    expect(find.text('Palak Paneer'), findsOneWidget);
    expect(find.text('Mango'), findsNothing);

    // Clear the search and pick a food.
    await tester.tap(find.byIcon(Icons.clear));
    await tester.pumpAndSettle();
    await mouse.moveTo(tester.getCenter(find.text('Banana')));
    await tester.pump();
    await tester.tap(find.text('Banana'));
    await tester.pumpAndSettle();

    // Quantity step: quick quantity + meal type chips.
    expect(find.text('Set quantity & meal'), findsOneWidget);
    expect(find.text('150 g'), findsOneWidget);
    for (final label in ['50 g', '150 g', '200 g']) {
      await mouse.moveTo(tester.getCenter(find.text(label)));
      await tester.pump();
    }
    await tester.tap(find.text('150 g'));
    await tester.pump();

    await mouse.moveTo(tester.getCenter(find.text('Log Food')));
    await tester.pump();
    await tester.tap(find.text('Log Food'));
    await tester.pumpAndSettle();

    // Dialog popped with a result.
    expect(find.text('Choose a food'), findsNothing);
  });
}