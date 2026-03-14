# Flutterby v0

An interactive Flutter widget explorer and mini playground. Select a widget, tweak its properties, see the live preview update immediately, and view the generated Dart source code.

## Run locally

```bash
flutter run -d chrome
```

Or build and serve:

```bash
flutter build web
cd build/web && python3 -m http.server 8080
```

Then open http://localhost:8080.

## Run tests

```bash
flutter test
```

## Architecture

**State management:** Plain `setState` — no external packages. Each widget demo's property values are stored in a `Map<String, Map<String, dynamic>>` keyed by widget ID, so switching between widgets preserves edits.

**Data model:** `WidgetDemo` holds a property schema list, a preview builder function, and a source generator function. All five demos are registered in `widget_registry.dart`. Adding a new widget means adding one function to that file.

**Layout:** Three-panel desktop layout — widget selector (left), live preview (center), properties/source tabs (right). The right panel uses a `TabBar` to switch between the property editor and generated source code.

**File structure:**
- `lib/main.dart` — entry point
- `lib/app.dart` — app shell, theme, and main `ExplorerScreen` with state
- `lib/models/widget_demo.dart` — `WidgetDemo` and `PropertySchema` data classes
- `lib/data/widget_registry.dart` — all five widget demo definitions
- `lib/panels/` — UI panels (selector, preview, property editor, source code)
