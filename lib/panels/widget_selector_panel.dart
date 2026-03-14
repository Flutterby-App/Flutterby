import 'package:flutter/material.dart';
import '../models/widget_demo.dart';

class WidgetSelectorPanel extends StatefulWidget {
  final List<WidgetDemo> demos;
  final String selectedId;
  final ValueChanged<String> onSelected;

  const WidgetSelectorPanel({
    super.key,
    required this.demos,
    required this.selectedId,
    required this.onSelected,
  });

  @override
  State<WidgetSelectorPanel> createState() => _WidgetSelectorPanelState();
}

class _WidgetSelectorPanelState extends State<WidgetSelectorPanel> {
  String _filter = '';

  List<Widget> _buildGroupedList(List<WidgetDemo> demos, ColorScheme colorScheme) {
    final widgets = <Widget>[];
    String? lastCategory;

    for (final demo in demos) {
      if (demo.category != lastCategory) {
        lastCategory = demo.category;
        widgets.add(
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Text(
              demo.category.toUpperCase(),
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.0,
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
              ),
            ),
          ),
        );
      }
      widgets.add(
        _WidgetTile(
          demo: demo,
          selected: demo.id == widget.selectedId,
          onTap: () => widget.onSelected(demo.id),
        ),
      );
    }

    return widgets;
  }

  List<WidgetDemo> get _filteredDemos {
    if (_filter.isEmpty) return widget.demos;
    final lower = _filter.toLowerCase();
    return widget.demos.where((d) => d.displayName.toLowerCase().contains(lower)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final filtered = _filteredDemos;

    return Container(
      color: colorScheme.surfaceContainerLow,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 16, 12, 8),
            child: TextField(
              style: const TextStyle(fontSize: 13),
              decoration: InputDecoration(
                hintText: 'Filter widgets...',
                hintStyle: TextStyle(fontSize: 13, color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6)),
                prefixIcon: Icon(Icons.search, size: 18, color: colorScheme.onSurfaceVariant),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: colorScheme.outlineVariant),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: colorScheme.outlineVariant),
                ),
                filled: true,
                fillColor: colorScheme.surface,
              ),
              onChanged: (v) => setState(() => _filter = v),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: Text(
              '${filtered.length} widget${filtered.length == 1 ? '' : 's'}',
              style: TextStyle(
                fontSize: 11,
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Divider(height: 1, color: colorScheme.outlineVariant),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: _buildGroupedList(filtered, colorScheme),
            ),
          ),
        ],
      ),
    );
  }
}

class _WidgetTile extends StatelessWidget {
  final WidgetDemo demo;
  final bool selected;
  final VoidCallback onTap;

  const _WidgetTile({
    required this.demo,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Material(
        color: selected ? colorScheme.primaryContainer : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Icon(
                  demo.icon,
                  size: 20,
                  color: selected ? colorScheme.primary : colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    demo.displayName,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                      color: selected ? colorScheme.onPrimaryContainer : colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
