import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutterby/app.dart';
import 'package:flutterby/services/persistence_service.dart';

void main() {
  // This is a desktop-first app; use a reasonable window size for tests.
  const testSize = Size(1280, 800);

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    // Provide a fake SharedPreferences for tests
    final store = <String, Object>{};
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/shared_preferences'),
      (MethodCall methodCall) async {
        if (methodCall.method == 'getAll') {
          return store;
        } else if (methodCall.method.startsWith('set')) {
          final args = methodCall.arguments as Map;
          store[args['key'] as String] = args['value'];
          return true;
        } else if (methodCall.method == 'remove') {
          store.remove(methodCall.arguments as String);
          return true;
        }
        return null;
      },
    );
    await PersistenceService.init();
  });

  testWidgets('App renders and shows Flutterby header', (WidgetTester tester) async {
    tester.view.physicalSize = testSize;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.reset());

    await tester.pumpWidget(const FlutterbyApp());  // ignore: prefer_const_constructors

    expect(find.text('Flutterby'), findsOneWidget);
    expect(find.text('v3'), findsOneWidget);
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
    // Verify the count label shows widget count (e.g. "19 widgets")
    expect(find.textContaining(RegExp(r'^\d+ widgets?$')), findsOneWidget);
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

  testWidgets('Properties, Source Code, and Docs tabs exist', (WidgetTester tester) async {
    tester.view.physicalSize = testSize;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.reset());

    await tester.pumpWidget(const FlutterbyApp());  // ignore: prefer_const_constructors

    expect(find.text('Properties'), findsOneWidget);
    expect(find.text('Source Code'), findsOneWidget);
    expect(find.text('Docs'), findsOneWidget);
  });

  testWidgets('Docs tab shows documentation content', (WidgetTester tester) async {
    tester.view.physicalSize = testSize;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.reset());

    await tester.pumpWidget(const FlutterbyApp());  // ignore: prefer_const_constructors

    // Switch to Docs tab
    await tester.tap(find.text('Docs'));
    await tester.pumpAndSettle();

    // The ReferencePanel should be present
    expect(find.byType(ListView), findsWidgets);
    // Should show the PROPERTIES section header
    expect(find.text('PROPERTIES'), findsOneWidget);
  });

  testWidgets('Source Code tab shows generated Dart', (WidgetTester tester) async {
    tester.view.physicalSize = testSize;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.reset());

    await tester.pumpWidget(const FlutterbyApp());  // ignore: prefer_const_constructors

    // Switch to Source Code tab
    await tester.tap(find.text('Source Code'));
    await tester.pumpAndSettle();

    // Source code is rendered as SelectableText.rich per line — verify they exist
    expect(find.byType(SelectableText), findsWidgets);
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
