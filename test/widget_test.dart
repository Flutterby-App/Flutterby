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

    await tester.pumpWidget(const FlutterbyApp());

    expect(find.text('Flutterby'), findsOneWidget);
    expect(find.text('v0'), findsOneWidget);
  });

  testWidgets('Widget selector shows all 5 widgets', (WidgetTester tester) async {
    tester.view.physicalSize = testSize;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.reset());

    await tester.pumpWidget(const FlutterbyApp());

    expect(find.text('Text'), findsWidgets);
    expect(find.text('Container'), findsOneWidget);
    expect(find.text('Row'), findsOneWidget);
    expect(find.text('Column'), findsOneWidget);
    expect(find.text('ElevatedButton'), findsOneWidget);
  });

  testWidgets('Selecting a widget updates the preview header', (WidgetTester tester) async {
    tester.view.physicalSize = testSize;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.reset());

    await tester.pumpWidget(const FlutterbyApp());

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

    await tester.pumpWidget(const FlutterbyApp());

    expect(find.text('Properties'), findsOneWidget);
    expect(find.text('Source Code'), findsOneWidget);
  });

  testWidgets('Source Code tab shows generated Dart', (WidgetTester tester) async {
    tester.view.physicalSize = testSize;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.reset());

    await tester.pumpWidget(const FlutterbyApp());

    // Switch to Source Code tab
    await tester.tap(find.text('Source Code'));
    await tester.pumpAndSettle();

    // Should contain generated Text widget code
    expect(find.textContaining('Text('), findsWidgets);
    expect(find.textContaining('TextAlign'), findsOneWidget);
  });
}
