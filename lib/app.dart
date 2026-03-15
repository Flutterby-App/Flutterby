import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'data/widget_registry.dart';
import 'models/device_spec.dart';
import 'models/property_history.dart';
import 'models/widget_demo.dart';
import 'panels/compare_panel.dart';
import 'panels/curve_playground_panel.dart';
import 'panels/device_frame_painter.dart';
import 'panels/preview_panel.dart';
import 'panels/property_editor_panel.dart';
import 'panels/reference_panel.dart';
import 'panels/shortcuts_overlay.dart';
import 'panels/source_code_panel.dart';
import 'panels/theme_builder_panel.dart';
import 'panels/variant_gallery_panel.dart';
import 'panels/widget_selector_panel.dart';
import 'services/persistence_service.dart';
import 'services/url_state_service.dart';

class FlutterbyApp extends StatefulWidget {
  final String? initialWidgetId;
  final Map<String, dynamic>? initialProperties;

  const FlutterbyApp({
    super.key,
    this.initialWidgetId,
    this.initialProperties,
  });

  @override
  State<FlutterbyApp> createState() => _FlutterbyAppState();
}

class _FlutterbyAppState extends State<FlutterbyApp> {
  ThemeMode _themeMode = ThemeMode.light;
  Color? _seedColor;
  Brightness _themeBrightness = Brightness.light;

  @override
  void initState() {
    super.initState();
    final isDark = PersistenceService.getIsDark();
    if (isDark == true) _themeMode = ThemeMode.dark;

    final savedSeedColor = PersistenceService.getSeedColor();
    if (savedSeedColor != null) _seedColor = savedSeedColor;
  }

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
    PersistenceService.setIsDark(_themeMode == ThemeMode.dark);
  }

  Color get _effectiveSeedColor => _seedColor ?? Colors.indigo;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutterby',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        colorSchemeSeed: _effectiveSeedColor,
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: _effectiveSeedColor,
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      home: ExplorerScreen(
        isDark: _themeMode == ThemeMode.dark,
        onToggleTheme: _toggleTheme,
        seedColor: _effectiveSeedColor,
        themeBrightness: _themeBrightness,
        onSeedColorChanged: (color) {
          setState(() => _seedColor = color);
          PersistenceService.setSeedColor(color);
        },
        onThemeBrightnessChanged: (b) => setState(() => _themeBrightness = b),
        initialWidgetId: widget.initialWidgetId,
        initialProperties: widget.initialProperties,
      ),
    );
  }
}

class ExplorerScreen extends StatefulWidget {
  final bool isDark;
  final VoidCallback onToggleTheme;
  final Color seedColor;
  final Brightness themeBrightness;
  final ValueChanged<Color> onSeedColorChanged;
  final ValueChanged<Brightness> onThemeBrightnessChanged;
  final String? initialWidgetId;
  final Map<String, dynamic>? initialProperties;

  const ExplorerScreen({
    super.key,
    required this.isDark,
    required this.onToggleTheme,
    required this.seedColor,
    required this.themeBrightness,
    required this.onSeedColorChanged,
    required this.onThemeBrightnessChanged,
    this.initialWidgetId,
    this.initialProperties,
  });

  @override
  State<ExplorerScreen> createState() => _ExplorerScreenState();
}

class _ExplorerScreenState extends State<ExplorerScreen> with SingleTickerProviderStateMixin {
  late String _selectedId;
  late Map<String, Map<String, dynamic>> _allValues;
  late TabController _tabController;
  Timer? _saveDebounce;
  Timer? _urlDebounce;

  // Compact layout: which section is visible
  int _compactTab = 1; // 0=Widgets, 1=Preview, 2=Properties

  // Keyboard shortcuts
  bool _showShortcuts = false;
  final FocusNode _searchFocusNode = FocusNode();

  // Undo/Redo
  final Map<String, PropertyHistory> _histories = {};

  // Code <-> Property linking
  String? _highlightedProperty;
  bool _isWideLayout = false;

  // Feature: Theme builder
  bool _showThemeBuilder = false;

  // Feature: Curve playground
  bool _showCurvePlayground = false;

  // Feature: Device frame
  DeviceSpec _selectedDevice = devicePresets.first; // None
  bool _showSafeArea = false;

  // Feature: Gallery mode
  bool _galleryMode = false;

  // Feature: Compare / A-B diff
  Map<String, dynamic>? _snapshotA;
  Map<String, dynamic>? _snapshotB;
  bool _compareMode = false;
  double _morphT = 0.5;

  @override
  void initState() {
    super.initState();

    // Check URL state first (web only)
    String? urlWidgetId;
    Map<String, dynamic>? urlProperties;
    final fragment = UrlStateService.readFragment();
    if (fragment != null) {
      final decoded = UrlStateService.decode(fragment);
      if (decoded != null) {
        urlWidgetId = decoded.widgetId;
        urlProperties = decoded.properties;
      }
    }

    // Use URL state > constructor params > persistence
    final initWidgetId = urlWidgetId ?? widget.initialWidgetId;
    final initProps = urlProperties ?? widget.initialProperties;

    // Restore selected widget
    final savedId = initWidgetId ?? PersistenceService.getSelectedWidget();
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

    // Apply URL property overrides
    if (initProps != null && _allValues.containsKey(_selectedId)) {
      _allValues[_selectedId]!.addAll(initProps);
    }

    // Restore device
    final savedDevice = PersistenceService.getDeviceName();
    if (savedDevice != null) {
      final match = devicePresets.where((d) => d.name == savedDevice).firstOrNull;
      if (match != null) _selectedDevice = match;
    }

    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _saveDebounce?.cancel();
    _urlDebounce?.cancel();
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

  void _updateUrlDebounced() {
    if (!kIsWeb) return;
    _urlDebounce?.cancel();
    _urlDebounce = Timer(const Duration(milliseconds: 300), () {
      final demo = _selectedDemo;
      final fragment = UrlStateService.encode(
        _selectedId,
        _currentValues,
        demo.defaultValues(),
      );
      UrlStateService.writeFragment(fragment);
    });
  }

  WidgetDemo get _selectedDemo => widgetRegistry.firstWhere((d) => d.id == _selectedId);

  Map<String, dynamic> get _currentValues => _allValues[_selectedId]!;

  PropertyHistory get _currentHistory =>
      _histories.putIfAbsent(_selectedId, () => PropertyHistory());

  void _selectWidget(String id) {
    setState(() {
      _selectedId = id;
      _compareMode = false;
      _snapshotA = null;
      _snapshotB = null;
      _showThemeBuilder = false;
      _showCurvePlayground = false;
    });
    _persistState();
    _updateUrlDebounced();
  }

  void _resetCurrentWidget() {
    _currentHistory.push(Map<String, dynamic>.from(_currentValues));
    setState(() {
      _allValues[_selectedId] = _selectedDemo.defaultValues();
    });
    _persistState();
    _updateUrlDebounced();
  }

  void _undo() {
    final prev = _currentHistory.undo(_currentValues);
    if (prev != null) {
      setState(() => _allValues[_selectedId] = prev);
      _persistState();
      _updateUrlDebounced();
    }
  }

  void _redo() {
    final next = _currentHistory.redo(_currentValues);
    if (next != null) {
      setState(() => _allValues[_selectedId] = next);
      _persistState();
      _updateUrlDebounced();
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

  void _shareLink() {
    final demo = _selectedDemo;
    final fragment = UrlStateService.encode(
      _selectedId,
      _currentValues,
      demo.defaultValues(),
    );

    if (kIsWeb) {
      UrlStateService.writeFragment(fragment);
      // Copy the full URL to clipboard
      final url = Uri.base.replace(fragment: fragment).toString();
      Clipboard.setData(ClipboardData(text: url));
    } else {
      // On non-web, just copy the fragment as a reference
      Clipboard.setData(ClipboardData(text: 'flutterby://$fragment'));
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Link copied!'), duration: Duration(seconds: 1)),
    );
  }

  void _cycleDevice() {
    final idx = devicePresets.indexOf(_selectedDevice);
    final next = devicePresets[(idx + 1) % devicePresets.length];
    setState(() => _selectedDevice = next);
    PersistenceService.setDeviceName(next.name);
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
          child: _buildMainContent(demo, values, colorScheme),
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
  // Medium layout (600-900)
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
                child: _buildMainContent(demo, values, colorScheme),
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
  // Compact layout (<600)
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
            1 => _buildMainContent(demo, values, colorScheme),
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
  // Main content area — preview, theme builder, curve playground, or gallery
  // -------------------------------------------------------------------------
  Widget _buildMainContent(WidgetDemo demo, Map<String, dynamic> values, ColorScheme colorScheme) {
    if (_showThemeBuilder) {
      return ThemeBuilderPanel(
        seedColor: widget.seedColor,
        brightness: widget.themeBrightness,
        onSeedColorChanged: widget.onSeedColorChanged,
        onBrightnessChanged: widget.onThemeBrightnessChanged,
      );
    }

    if (_showCurvePlayground) {
      return const CurvePlaygroundPanel();
    }

    if (_compareMode && _snapshotA != null && _snapshotB != null) {
      return PreviewPanel(
        widgetName: demo.displayName,
        description: 'Compare Mode',
        selectedDevice: _selectedDevice,
        showSafeArea: _showSafeArea,
        onDeviceChanged: (d) {
          setState(() => _selectedDevice = d);
          PersistenceService.setDeviceName(d.name);
        },
        onSafeAreaToggled: () => setState(() => _showSafeArea = !_showSafeArea),
        galleryMode: false,
        onGalleryToggled: () {},
        child: ComparePanel(
          demo: demo,
          snapshotA: _snapshotA!,
          snapshotB: _snapshotB!,
          morphT: _morphT,
          onMorphChanged: (t) => setState(() => _morphT = t),
        ),
      );
    }

    if (_galleryMode) {
      return PreviewPanel(
        widgetName: demo.displayName,
        description: 'Gallery Mode',
        selectedDevice: _selectedDevice,
        showSafeArea: _showSafeArea,
        onDeviceChanged: (d) {
          setState(() => _selectedDevice = d);
          PersistenceService.setDeviceName(d.name);
        },
        onSafeAreaToggled: () => setState(() => _showSafeArea = !_showSafeArea),
        galleryMode: true,
        onGalleryToggled: () => setState(() => _galleryMode = !_galleryMode),
        child: VariantGalleryPanel(
          demo: demo,
          currentValues: values,
          onApplyValues: (cellValues) {
            _currentHistory.push(Map<String, dynamic>.from(_currentValues));
            setState(() {
              _allValues[_selectedId] = cellValues;
              _galleryMode = false;
            });
            _persistState();
            _updateUrlDebounced();
          },
        ),
      );
    }

    return PreviewPanel(
      widgetName: demo.displayName,
      description: demo.description,
      selectedDevice: _selectedDevice,
      showSafeArea: _showSafeArea,
      onDeviceChanged: (d) {
        setState(() => _selectedDevice = d);
        PersistenceService.setDeviceName(d.name);
      },
      onSafeAreaToggled: () => setState(() => _showSafeArea = !_showSafeArea),
      galleryMode: false,
      onGalleryToggled: () => setState(() => _galleryMode = !_galleryMode),
      child: _buildAnimatedPreview(demo, values),
    );
  }

  // -------------------------------------------------------------------------
  // Shared builders
  // -------------------------------------------------------------------------
  Widget _buildAnimatedPreview(WidgetDemo demo, Map<String, dynamic> values) {
    Widget preview = AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: KeyedSubtree(
        key: ValueKey(_selectedId),
        child: Theme(
          data: ThemeData(
            colorSchemeSeed: widget.seedColor,
            useMaterial3: true,
            brightness: widget.themeBrightness,
          ),
          child: demo.previewBuilder(values),
        ),
      ),
    );

    if (_selectedDevice.type != DeviceType.none) {
      preview = DeviceFrameWrapper(
        device: _selectedDevice,
        showSafeArea: _showSafeArea,
        child: preview,
      );
    }

    return preview;
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
              Column(
                children: [
                  Expanded(
                    child: PropertyEditorPanel(
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
                        _updateUrlDebounced();
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
                  ),
                  // Compare controls
                  CompareControls(
                    hasSnapshotA: _snapshotA != null,
                    hasSnapshotB: _snapshotB != null,
                    compareMode: _compareMode,
                    onSetA: () {
                      setState(() => _snapshotA = Map<String, dynamic>.from(values));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Snapshot A captured'), duration: Duration(seconds: 1)),
                      );
                    },
                    onSetB: () {
                      setState(() {
                        _snapshotB = Map<String, dynamic>.from(values);
                        if (_snapshotA != null) _compareMode = true;
                      });
                      if (_snapshotA != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Compare mode activated'), duration: Duration(seconds: 1)),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Snapshot B captured — set A first'), duration: Duration(seconds: 1)),
                        );
                      }
                    },
                    onCompare: () => setState(() => _compareMode = true),
                    onExit: () => setState(() => _compareMode = false),
                  ),
                ],
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
      } else if (_showThemeBuilder) {
        setState(() => _showThemeBuilder = false);
      } else if (_showCurvePlayground) {
        setState(() => _showCurvePlayground = false);
      } else if (_compareMode) {
        setState(() => _compareMode = false);
      } else {
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
    } else if (event.character == 's') {
      _shareLink();
    } else if (event.character == 'g') {
      setState(() => _galleryMode = !_galleryMode);
    } else if (event.character == 'd') {
      _cycleDevice();
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
              'v4',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: colorScheme.onPrimaryContainer,
              ),
            ),
          ),
          const Spacer(),
          // Share button
          IconButton(
            icon: const Icon(Icons.share, size: 18),
            tooltip: 'Copy share link (s)',
            onPressed: _shareLink,
          ),
          // Theme builder
          IconButton(
            icon: Icon(
              _showThemeBuilder ? Icons.palette : Icons.palette_outlined,
              size: 20,
            ),
            tooltip: 'Theme builder',
            onPressed: () => setState(() {
              _showThemeBuilder = !_showThemeBuilder;
              if (_showThemeBuilder) _showCurvePlayground = false;
            }),
          ),
          // Curve playground
          IconButton(
            icon: Icon(
              _showCurvePlayground ? Icons.timeline : Icons.timeline_outlined,
              size: 20,
            ),
            tooltip: 'Animation curves',
            onPressed: () => setState(() {
              _showCurvePlayground = !_showCurvePlayground;
              if (_showCurvePlayground) _showThemeBuilder = false;
            }),
          ),
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
