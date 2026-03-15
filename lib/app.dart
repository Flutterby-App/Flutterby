import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'data/widget_registry.dart';
import 'models/property_history.dart';
import 'models/widget_demo.dart';
import 'panels/preview_panel.dart';
import 'panels/property_editor_panel.dart';
import 'panels/reference_panel.dart';
import 'panels/shortcuts_overlay.dart';
import 'panels/source_code_panel.dart';
import 'panels/widget_selector_panel.dart';
import 'services/persistence_service.dart';

class FlutterbyApp extends StatefulWidget {
  const FlutterbyApp({super.key});

  @override
  State<FlutterbyApp> createState() => _FlutterbyAppState();
}

class _FlutterbyAppState extends State<FlutterbyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  @override
  void initState() {
    super.initState();
    final isDark = PersistenceService.getIsDark();
    if (isDark == true) _themeMode = ThemeMode.dark;
  }

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
    PersistenceService.setIsDark(_themeMode == ThemeMode.dark);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutterby',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      home: ExplorerScreen(
        isDark: _themeMode == ThemeMode.dark,
        onToggleTheme: _toggleTheme,
      ),
    );
  }
}

class ExplorerScreen extends StatefulWidget {
  final bool isDark;
  final VoidCallback onToggleTheme;

  const ExplorerScreen({
    super.key,
    required this.isDark,
    required this.onToggleTheme,
  });

  @override
  State<ExplorerScreen> createState() => _ExplorerScreenState();
}

class _ExplorerScreenState extends State<ExplorerScreen> with SingleTickerProviderStateMixin {
  late String _selectedId;
  late Map<String, Map<String, dynamic>> _allValues;
  late TabController _tabController;
  Timer? _saveDebounce;

  // Compact layout: which section is visible
  int _compactTab = 1; // 0=Widgets, 1=Preview, 2=Properties

  // Feature 2: Keyboard shortcuts
  bool _showShortcuts = false;
  final FocusNode _searchFocusNode = FocusNode();

  // Feature 3: Undo/Redo
  final Map<String, PropertyHistory> _histories = {};

  // Feature 4: Code <-> Property linking
  String? _highlightedProperty;
  bool _isWideLayout = false;

  @override
  void initState() {
    super.initState();
    // Restore selected widget
    final savedId = PersistenceService.getSelectedWidget();
    _selectedId = (savedId != null && widgetRegistry.any((d) => d.id == savedId))
        ? savedId
        : widgetRegistry.first.id;
    // Restore property values (merge with defaults for safety)
    final defaults = {
      for (final demo in widgetRegistry) demo.id: demo.defaultValues(),
    };
    final saved = PersistenceService.getPropertyValues();
    if (saved != null) {
      for (final entry in saved.entries) {
        if (defaults.containsKey(entry.key)) {
          defaults[entry.key]!.addAll(entry.value);
        }
      }
    }
    _allValues = defaults;
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _saveDebounce?.cancel();
    _tabController.dispose();
    _searchFocusNode.dispose();
    for (final h in _histories.values) {
      h.dispose();
    }
    super.dispose();
  }

  void _persistState() {
    _saveDebounce?.cancel();
    _saveDebounce = Timer(const Duration(milliseconds: 500), () {
      PersistenceService.setSelectedWidget(_selectedId);
      PersistenceService.setPropertyValues(_allValues);
    });
  }

  WidgetDemo get _selectedDemo => widgetRegistry.firstWhere((d) => d.id == _selectedId);

  Map<String, dynamic> get _currentValues => _allValues[_selectedId]!;

  PropertyHistory get _currentHistory =>
      _histories.putIfAbsent(_selectedId, () => PropertyHistory());

  void _selectWidget(String id) {
    setState(() => _selectedId = id);
    _persistState();
  }

  void _resetCurrentWidget() {
    _currentHistory.push(Map<String, dynamic>.from(_currentValues));
    setState(() {
      _allValues[_selectedId] = _selectedDemo.defaultValues();
    });
    _persistState();
  }

  void _undo() {
    final prev = _currentHistory.undo(_currentValues);
    if (prev != null) {
      setState(() => _allValues[_selectedId] = prev);
      _persistState();
    }
  }

  void _redo() {
    final next = _currentHistory.redo(_currentValues);
    if (next != null) {
      setState(() => _allValues[_selectedId] = next);
      _persistState();
    }
  }

  /// Find which property changed between old and new values.
  String? _findChangedProperty(Map<String, dynamic> oldValues, Map<String, dynamic> newValues) {
    for (final key in newValues.keys) {
      if (oldValues[key] != newValues[key]) return key;
    }
    return null;
  }

  void _copySource() {
    final source = _selectedDemo.sourceGenerator(_currentValues);
    Clipboard.setData(ClipboardData(text: source));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Source code copied'), duration: Duration(seconds: 1)),
    );
  }

  /// Check if a TextField/EditableText currently has focus.
  bool get _isTextFieldFocused {
    final focus = FocusManager.instance.primaryFocus;
    if (focus == null) return false;
    final ctx = focus.context;
    if (ctx == null) return false;
    // Walk up to see if there's an EditableText ancestor
    bool found = false;
    ctx.visitAncestorElements((element) {
      if (element.widget is EditableText) {
        found = true;
        return false; // stop
      }
      return true; // continue
    });
    return found;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: KeyboardListener(
        focusNode: FocusNode(),
        autofocus: true,
        onKeyEvent: _handleKeyEvent,
        child: Stack(
          children: [
            Column(
              children: [
                _buildHeader(context, colorScheme),
                Divider(height: 1, color: colorScheme.outlineVariant),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      _isWideLayout = constraints.maxWidth >= 900;
                      if (constraints.maxWidth < 600) {
                        return _buildCompactLayout(colorScheme);
                      } else if (constraints.maxWidth < 900) {
                        return _buildMediumLayout(colorScheme);
                      } else {
                        return _buildWideLayout(colorScheme);
                      }
                    },
                  ),
                ),
              ],
            ),
            if (_showShortcuts)
              ShortcutsOverlay(
                onDismiss: () => setState(() => _showShortcuts = false),
              ),
          ],
        ),
      ),
    );
  }

  // -------------------------------------------------------------------------
  // Wide layout (900+): original 3-panel
  // -------------------------------------------------------------------------
  Widget _buildWideLayout(ColorScheme colorScheme) {
    final demo = _selectedDemo;
    final values = _currentValues;
    final source = demo.sourceGenerator(values);

    return Row(
      children: [
        SizedBox(
          width: 200,
          child: WidgetSelectorPanel(
            demos: widgetRegistry,
            selectedId: _selectedId,
            onSelected: _selectWidget,
            searchFocusNode: _searchFocusNode,
          ),
        ),
        VerticalDivider(width: 1, color: colorScheme.outlineVariant),
        Expanded(
          flex: 3,
          child: PreviewPanel(
            widgetName: demo.displayName,
            description: demo.description,
            child: _buildAnimatedPreview(demo, values),
          ),
        ),
        VerticalDivider(width: 1, color: colorScheme.outlineVariant),
        SizedBox(
          width: 320,
          child: _buildRightPanel(demo, values, source),
        ),
      ],
    );
  }

  // -------------------------------------------------------------------------
  // Medium layout (600-900): drawer selector + stacked preview/properties
  // -------------------------------------------------------------------------
  Widget _buildMediumLayout(ColorScheme colorScheme) {
    final demo = _selectedDemo;
    final values = _currentValues;
    final source = demo.sourceGenerator(values);

    return Row(
      children: [
        SizedBox(
          width: 180,
          child: WidgetSelectorPanel(
            demos: widgetRegistry,
            selectedId: _selectedId,
            onSelected: _selectWidget,
            searchFocusNode: _searchFocusNode,
          ),
        ),
        VerticalDivider(width: 1, color: colorScheme.outlineVariant),
        Expanded(
          child: Column(
            children: [
              Expanded(
                flex: 3,
                child: PreviewPanel(
                  widgetName: demo.displayName,
                  description: demo.description,
                  child: _buildAnimatedPreview(demo, values),
                ),
              ),
              Divider(height: 1, color: colorScheme.outlineVariant),
              Expanded(
                flex: 2,
                child: _buildRightPanel(demo, values, source),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // -------------------------------------------------------------------------
  // Compact layout (<600): single column with bottom nav
  // -------------------------------------------------------------------------
  Widget _buildCompactLayout(ColorScheme colorScheme) {
    final demo = _selectedDemo;
    final values = _currentValues;
    final source = demo.sourceGenerator(values);

    return Column(
      children: [
        Expanded(
          child: switch (_compactTab) {
            0 => WidgetSelectorPanel(
                demos: widgetRegistry,
                selectedId: _selectedId,
                onSelected: (id) {
                  _selectWidget(id);
                  setState(() => _compactTab = 1); // jump to preview
                },
                searchFocusNode: _searchFocusNode,
              ),
            1 => PreviewPanel(
                widgetName: demo.displayName,
                description: demo.description,
                child: _buildAnimatedPreview(demo, values),
              ),
            _ => _buildRightPanel(demo, values, source),
          },
        ),
        Divider(height: 1, color: colorScheme.outlineVariant),
        NavigationBar(
          height: 60,
          selectedIndex: _compactTab,
          onDestinationSelected: (i) => setState(() => _compactTab = i),
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: const [
            NavigationDestination(icon: Icon(Icons.widgets_outlined), selectedIcon: Icon(Icons.widgets), label: 'Widgets'),
            NavigationDestination(icon: Icon(Icons.preview_outlined), selectedIcon: Icon(Icons.preview), label: 'Preview'),
            NavigationDestination(icon: Icon(Icons.tune_outlined), selectedIcon: Icon(Icons.tune), label: 'Properties'),
          ],
        ),
      ],
    );
  }

  // -------------------------------------------------------------------------
  // Shared builders
  // -------------------------------------------------------------------------
  Widget _buildAnimatedPreview(WidgetDemo demo, Map<String, dynamic> values) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: KeyedSubtree(
        key: ValueKey(_selectedId),
        child: demo.previewBuilder(values),
      ),
    );
  }

  Widget _buildRightPanel(WidgetDemo demo, Map<String, dynamic> values, String source) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Properties'),
            Tab(text: 'Source Code'),
            Tab(text: 'Docs'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              PropertyEditorPanel(
                properties: demo.properties,
                values: values,
                onChanged: (next) {
                  final changedProp = _findChangedProperty(_currentValues, next);
                  _currentHistory.push(
                    Map<String, dynamic>.from(_currentValues),
                    changedProperty: changedProp,
                  );
                  setState(() => _allValues[_selectedId] = next);
                  _persistState();
                },
                onReset: _resetCurrentWidget,
                canUndo: _currentHistory.canUndo,
                canRedo: _currentHistory.canRedo,
                onUndo: _undo,
                onRedo: _redo,
                highlightedPropertyName: _isWideLayout ? _highlightedProperty : null,
                onPropertyHover: _isWideLayout
                    ? (name) => setState(() => _highlightedProperty = name)
                    : null,
              ),
              SourceCodePanel(
                source: source,
                highlightedPropertyName: _isWideLayout ? _highlightedProperty : null,
                properties: _isWideLayout ? demo.properties : null,
                onPropertyHover: _isWideLayout
                    ? (name) => setState(() => _highlightedProperty = name)
                    : null,
              ),
              ReferencePanel(
                demo: demo,
                onRelatedWidgetTap: (id) {
                  if (widgetRegistry.any((d) => d.id == id)) {
                    _selectWidget(id);
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return;

    // Undo/Redo: Ctrl+Z / Cmd+Z and Ctrl+Shift+Z / Cmd+Shift+Z
    final isCtrlOrMeta = HardwareKeyboard.instance.isControlPressed ||
        HardwareKeyboard.instance.isMetaPressed;
    final isShift = HardwareKeyboard.instance.isShiftPressed;

    if (isCtrlOrMeta && event.logicalKey == LogicalKeyboardKey.keyZ) {
      if (isShift) {
        _redo();
      } else {
        _undo();
      }
      return;
    }

    // Skip single-key shortcuts when a text field has focus
    if (_isTextFieldFocused) return;

    final idx = widgetRegistry.indexWhere((d) => d.id == _selectedId);

    if (event.logicalKey == LogicalKeyboardKey.arrowDown ||
        event.logicalKey == LogicalKeyboardKey.arrowRight) {
      if (idx < widgetRegistry.length - 1) {
        _selectWidget(widgetRegistry[idx + 1].id);
      }
    } else if (event.logicalKey == LogicalKeyboardKey.arrowUp ||
        event.logicalKey == LogicalKeyboardKey.arrowLeft) {
      if (idx > 0) {
        _selectWidget(widgetRegistry[idx - 1].id);
      }
    } else if (event.character == '?') {
      setState(() => _showShortcuts = !_showShortcuts);
    } else if (event.character == '/') {
      _searchFocusNode.requestFocus();
    } else if (event.logicalKey == LogicalKeyboardKey.escape) {
      if (_showShortcuts) {
        setState(() => _showShortcuts = false);
      } else {
        // Unfocus search
        FocusManager.instance.primaryFocus?.unfocus();
      }
    } else if (event.character == '1') {
      _tabController.animateTo(0);
    } else if (event.character == '2') {
      _tabController.animateTo(1);
    } else if (event.character == '3') {
      _tabController.animateTo(2);
    } else if (event.character == 'r') {
      _resetCurrentWidget();
    } else if (event.character == 'c') {
      _copySource();
    } else if (event.character == 't') {
      widget.onToggleTheme();
    }
  }

  Widget _buildHeader(BuildContext context, ColorScheme colorScheme) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      color: colorScheme.surface,
      child: Row(
        children: [
          Icon(Icons.flutter_dash, color: colorScheme.primary, size: 28),
          const SizedBox(width: 10),
          Text(
            'Flutterby',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              'v3',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: colorScheme.onPrimaryContainer,
              ),
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.keyboard, size: 18),
            tooltip: 'Keyboard shortcuts (?)',
            onPressed: () => setState(() => _showShortcuts = !_showShortcuts),
          ),
          IconButton(
            icon: Icon(
              widget.isDark ? Icons.light_mode : Icons.dark_mode,
              size: 20,
            ),
            tooltip: widget.isDark ? 'Switch to light mode' : 'Switch to dark mode',
            onPressed: widget.onToggleTheme,
          ),
        ],
      ),
    );
  }
}
