# Flutterby v0

An interactive Flutter widget explorer and mini playground. Select a widget, tweak its properties, see the live preview update immediately, and view syntax-highlighted generated Dart source code.

## Features

- **13 widgets** across 4 categories (Display, Layout, Input, Composite)
- **Live preview** with subtle checkerboard background and animated transitions
- **Syntax-highlighted source code** with line numbers and copy-to-clipboard
- **Dark/light mode** toggle
- **Search filter** for the widget list
- **Reset to defaults** button per widget
- **Property editors**: text fields, sliders, toggles, choice chips

### Supported Widgets

| Category | Widgets |
|----------|---------|
| Display | Text, Icon |
| Layout | Container, Row, Column, Wrap, Stack, Padding, Center, SizedBox |
| Input | ElevatedButton |
| Composite | Card, ListTile |

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

**Data model:** `WidgetDemo` holds a property schema, category, preview builder, and source generator. All 13 demos are registered in `widget_registry.dart`. Adding a new widget means adding one function to that file and appending it to the registry list.

**Layout:** Three-panel desktop layout — widget selector with category headers and search (left), live preview with checkerboard background (center), properties/source tabs with syntax highlighting (right).

**File structure:**
- `lib/main.dart` — entry point
- `lib/app.dart` — app shell, theme management, and main `ExplorerScreen` with state
- `lib/models/widget_demo.dart` — `WidgetDemo` and `PropertySchema` data classes
- `lib/data/widget_registry.dart` — all 13 widget demo definitions
- `lib/panels/` — UI panels (selector, preview, property editor, source code)
