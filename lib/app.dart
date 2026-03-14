import 'package:flutter/material.dart';
import 'data/widget_registry.dart';
import 'models/widget_demo.dart';
import 'panels/preview_panel.dart';
import 'panels/property_editor_panel.dart';
import 'panels/source_code_panel.dart';
import 'panels/widget_selector_panel.dart';

class FlutterbyApp extends StatelessWidget {
  const FlutterbyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutterby',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      home: const ExplorerScreen(),
    );
  }
}

class ExplorerScreen extends StatefulWidget {
  const ExplorerScreen({super.key});

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

  @override
  Widget build(BuildContext context) {
    final demo = _selectedDemo;
    final values = _currentValues;
    final source = demo.sourceGenerator(values);

    return Scaffold(
      body: Column(
        children: [
          _buildHeader(context),
          const Divider(height: 1),
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
                const VerticalDivider(width: 1),
                // Center panel — preview
                Expanded(
                  flex: 3,
                  child: PreviewPanel(
                    widgetName: demo.displayName,
                    child: demo.previewBuilder(values),
                  ),
                ),
                const VerticalDivider(width: 1),
                // Right panel — properties + source
                SizedBox(
                  width: 320,
                  child: Column(
                    children: [
                      TabBar(
                        controller: _tabController,
                        labelColor: Colors.indigo,
                        unselectedLabelColor: Colors.grey.shade600,
                        indicatorColor: Colors.indigo,
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

  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      color: Colors.white,
      child: Row(
        children: [
          Icon(Icons.flutter_dash, color: Colors.indigo.shade400, size: 28),
          const SizedBox(width: 10),
          Text(
            'Flutterby',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.indigo.shade50,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              'v0',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.indigo.shade400),
            ),
          ),
        ],
      ),
    );
  }
}
