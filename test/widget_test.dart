import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutterby/app.dart';

void main() {
  // This is a desktop-first app; use a reasonable window size for tests.
  const testSize = Size(1280, 800);

  testWidgets('App renders and shows Flutterby header', (WidgetTester tester) async {
    tester.view.physicalSize = testSize;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.reset());

    await tester.pumpWidget(const FlutterbyApp());  // ignore: prefer_const_constructors

    expect(find.text('Flutterby'), findsOneWidget);
    expect(find.text('v0'), findsOneWidget);
  });

  testWidgets('Widget selector shows all widgets', (WidgetTester tester) async {
    tester.view.physicalSize = testSize;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.reset());

    await tester.pumpWidget(const FlutterbyApp());  // ignore: prefer_const_constructors

    // Check visible widgets from top of list
    expect(find.text('Text'), findsWidgets);
    expect(find.text('Icon'), findsOneWidget);
    expect(find.text('Container'), findsOneWidget);
    expect(find.text('Row'), findsOneWidget);
    // Verify the count label shows all widgets
    expect(find.textContaining('18 widgets'), findsOneWidget);
  });

  testWidgets('Selecting a widget updates the preview header', (WidgetTester tester) async {
    tester.view.physicalSize = testSize;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.reset());

    await tester.pumpWidget(const FlutterbyApp());  // ignore: prefer_const_constructors

    // Default selection is Text
    expect(find.text('Preview — Text'), findsOneWidget);

    // Tap Container in the selector
    await tester.tap(find.text('Container'));
    await tester.pumpAndSettle();

    expect(find.text('Preview — Container'), findsOneWidget);
  });

  testWidgets('Properties and Source Code tabs exist', (WidgetTester tester) async {
    tester.view.physicalSize = testSize;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.reset());

    await tester.pumpWidget(const FlutterbyApp());  // ignore: prefer_const_constructors

    expect(find.text('Properties'), findsOneWidget);
    expect(find.text('Source Code'), findsOneWidget);
  });

  testWidgets('Source Code tab shows generated Dart', (WidgetTester tester) async {
    tester.view.physicalSize = testSize;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.reset());

    await tester.pumpWidget(const FlutterbyApp());  // ignore: prefer_const_constructors

    // Switch to Source Code tab
    await tester.tap(find.text('Source Code'));
    await tester.pumpAndSettle();

    // Should contain generated Text widget code
    expect(find.textContaining('Text('), findsWidgets);
    expect(find.textContaining('TextAlign'), findsOneWidget);
  });

  testWidgets('Dark mode toggle works', (WidgetTester tester) async {
    tester.view.physicalSize = testSize;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.reset());

    await tester.pumpWidget(const FlutterbyApp());  // ignore: prefer_const_constructors

    // Should start in light mode — dark_mode icon visible (to switch to dark)
    expect(find.byIcon(Icons.dark_mode), findsOneWidget);

    // Tap dark mode toggle
    await tester.tap(find.byIcon(Icons.dark_mode));
    await tester.pumpAndSettle();

    // Now in dark mode — light_mode icon visible (to switch back)
    expect(find.byIcon(Icons.light_mode), findsOneWidget);
  });

  testWidgets('Reset to defaults button exists in property editor', (WidgetTester tester) async {
    tester.view.physicalSize = testSize;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.reset());

    await tester.pumpWidget(const FlutterbyApp());  // ignore: prefer_const_constructors

    expect(find.text('Reset to defaults'), findsOneWidget);
  });
}
