import 'package:flutter/material.dart';
import 'data/widget_registry.dart';
import 'models/widget_demo.dart';
import 'panels/preview_panel.dart';
import 'panels/property_editor_panel.dart';
import 'panels/source_code_panel.dart';
import 'panels/widget_selector_panel.dart';

class FlutterbyApp extends StatefulWidget {
  const FlutterbyApp({super.key});

  @override
  State<FlutterbyApp> createState() => _FlutterbyAppState();
}

class _FlutterbyAppState extends State<FlutterbyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
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

  @override
  void initState() {
    super.initState();
    _selectedId = widgetRegistry.first.id;
    _allValues = {
      for (final demo in widgetRegistry) demo.id: demo.defaultValues(),
    };
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  WidgetDemo get _selectedDemo => widgetRegistry.firstWhere((d) => d.id == _selectedId);

  Map<String, dynamic> get _currentValues => _allValues[_selectedId]!;

  void _resetCurrentWidget() {
    setState(() {
      _allValues[_selectedId] = _selectedDemo.defaultValues();
    });
  }

  @override
  Widget build(BuildContext context) {
    final demo = _selectedDemo;
    final values = _currentValues;
    final source = demo.sourceGenerator(values);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: Column(
        children: [
          _buildHeader(context, colorScheme),
          Divider(height: 1, color: colorScheme.outlineVariant),
          Expanded(
            child: Row(
              children: [
                // Left panel — widget selector
                SizedBox(
                  width: 200,
                  child: WidgetSelectorPanel(
                    demos: widgetRegistry,
                    selectedId: _selectedId,
                    onSelected: (id) => setState(() => _selectedId = id),
                  ),
                ),
                VerticalDivider(width: 1, color: colorScheme.outlineVariant),
                // Center panel — preview
                Expanded(
                  flex: 3,
                  child: PreviewPanel(
                    widgetName: demo.displayName,
                    child: demo.previewBuilder(values),
                  ),
                ),
                VerticalDivider(width: 1, color: colorScheme.outlineVariant),
                // Right panel — properties + source
                SizedBox(
                  width: 320,
                  child: Column(
                    children: [
                      TabBar(
                        controller: _tabController,
                        tabs: const [
                          Tab(text: 'Properties'),
                          Tab(text: 'Source Code'),
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
                                setState(() => _allValues[_selectedId] = next);
                              },
                              onReset: _resetCurrentWidget,
                            ),
                            SourceCodePanel(source: source),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
              'v0',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: colorScheme.onPrimaryContainer,
              ),
            ),
          ),
          const Spacer(),
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
