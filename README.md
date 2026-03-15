# Flutterby

An interactive Flutter widget explorer, playground, and reference tool. Select a widget, tweak its properties in real time, see a live preview with syntax-highlighted source code, read documentation with full property references, and export directly to DartPad.

Built with Flutter, for learning Flutter.

## Features

### Explore & Play
- **19 widgets** across 4 categories (Display, Layout, Input, Composite)
- **Live preview** with checkerboard background and animated crossfade transitions
- **Animated value transitions** — property changes smoothly animate in the preview (AnimatedContainer, AnimatedOpacity, AnimatedPadding, etc.)
- **Property editors** — text fields, sliders, toggles, and color-coded choice chips
- **Inline value previews** — color swatches, alignment dot grids, and semantic bool labels next to property values
- **Undo/redo** — per-widget property history with Ctrl+Z / Cmd+Z and redo, plus toolbar buttons
- **Keyboard navigation** — arrow keys to browse widgets instantly

### Learn
- **Docs tab** with documentation, full property reference table (name, type, required/optional, defaults), Material/Cupertino badges, and tappable related widget chips for discovery
- **Syntax-highlighted source code** — VS Code dark+ theme with line numbers and copy-to-clipboard
- **Code-property linking** — hover a property label to highlight the corresponding source line, and vice versa (wide layout)
- **Open in DartPad** — export any widget configuration as a runnable `main.dart` and iterate in DartPad

### Polished
- **Keyboard shortcuts** — press `?` to see all shortcuts: `/` to search, `1/2/3` for tabs, `r` reset, `c` copy, `t` toggle theme
- **Responsive layout** — adapts across three breakpoints:
  - **Wide (900+px):** 3-panel layout (selector | preview | properties)
  - **Medium (600-900px):** sidebar + stacked preview/properties
  - **Compact (<600px):** single column with bottom navigation
- **Dark/light mode** toggle
- **State persistence** — remembers your selected widget, theme, and all edited property values across sessions
- **Search filter** for the widget list with category grouping
- **Reset to defaults** per widget

### Supported Widgets

| Category | Widgets |
|----------|---------|
| Display | Text, Icon, Divider, Opacity, Progress |
| Layout | Container, Row, Column, Wrap, Stack, Padding, Center, SizedBox |
| Input | ElevatedButton, TextField, Switch, Slider |
| Composite | Card, ListTile |

## Platforms

| Platform | Status |
|----------|--------|
| Web | Primary target |
| macOS | Supported |
| iOS | Supported |
| Android | Supported |
| Linux | Supported |
| Windows | Supported |

## Quick Start

```bash
# Web (primary)
flutter run -d chrome

# macOS
flutter run -d macos

# Or build and serve statically
flutter build web
cd build/web && python3 -m http.server 8080
```

## Tests

```bash
flutter test        # 8 integration tests
flutter analyze     # zero issues
```

## Architecture

```
lib/
├── main.dart                        # Entry point + persistence init
├── app.dart                         # App shell, responsive layouts, state management
├── models/
│   ├── widget_demo.dart             # WidgetDemo, PropertySchema, WidgetPropertyRef, PropertyVisualHint
│   └── property_history.dart        # Per-widget undo/redo stack with debounced slider pushes
├── data/
│   └── widget_registry.dart         # All 19 widget demos with docs & properties
├── panels/
│   ├── widget_selector_panel.dart   # Left sidebar: search, categories, widget list
│   ├── preview_panel.dart           # Center: live widget preview with checkerboard
│   ├── property_editor_panel.dart   # Right tab: interactive property controls + undo/redo + hover linking
│   ├── source_code_panel.dart       # Right tab: syntax-highlighted code + DartPad export + hover linking
│   ├── reference_panel.dart         # Right tab: docs, property reference, related widgets
│   └── shortcuts_overlay.dart       # Modal overlay showing keyboard shortcuts
└── services/
    ├── dartpad_service.dart          # Wraps source in template, opens DartPad
    └── persistence_service.dart     # SharedPreferences for session state
```

**State management:** Plain `setState` with debounced persistence — no external state packages. Property values stored in a `Map<String, Map<String, dynamic>>` keyed by widget ID.

**Adding a widget:** Add one function to `widget_registry.dart` with a `WidgetDemo` (preview builder, source generator, property schema, docs) and append it to the registry list.

**Dependencies:** `url_launcher` (DartPad export), `shared_preferences` (session persistence). Everything else is pure Flutter.
