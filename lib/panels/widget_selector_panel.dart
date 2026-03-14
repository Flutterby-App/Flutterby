import 'package:flutter/material.dart';
import '../models/widget_demo.dart';

class WidgetSelectorPanel extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      color: colorScheme.surfaceContainerLow,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
            child: Text(
              'Widgets',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
            ),
          ),
          Divider(height: 1, color: colorScheme.outlineVariant),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: demos.length,
              itemBuilder: (context, index) {
                final demo = demos[index];
                final selected = demo.id == selectedId;
                return _WidgetTile(
                  demo: demo,
                  selected: selected,
                  onTap: () => onSelected(demo.id),
                );
              },
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
