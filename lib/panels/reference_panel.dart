import 'package:flutter/material.dart';
import '../models/widget_demo.dart';

class ReferencePanel extends StatelessWidget {
  final WidgetDemo demo;
  final ValueChanged<String>? onRelatedWidgetTap;

  const ReferencePanel({
    super.key,
    required this.demo,
    this.onRelatedWidgetTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final hasContent = demo.documentation != null ||
        demo.propertyReference != null ||
        demo.relatedWidgetIds != null;

    if (!hasContent) {
      return Center(
        child: Text(
          'No documentation available yet.',
          style: TextStyle(color: colorScheme.onSurfaceVariant),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Material / Cupertino badge
        _buildBadges(colorScheme),
        // Documentation
        if (demo.documentation != null) ...[
          const SizedBox(height: 12),
          Text(
            demo.documentation!,
            style: TextStyle(
              fontSize: 13,
              height: 1.5,
              color: colorScheme.onSurface,
            ),
          ),
        ],
        // Property reference table
        if (demo.propertyReference != null &&
            demo.propertyReference!.isNotEmpty) ...[
          const SizedBox(height: 20),
          Text(
            'PROPERTIES',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.0,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 8),
          ...demo.propertyReference!.map(
            (p) => _PropertyRefTile(prop: p),
          ),
        ],
        // Related widgets
        if (demo.relatedWidgetIds != null &&
            demo.relatedWidgetIds!.isNotEmpty) ...[
          const SizedBox(height: 20),
          Text(
            'RELATED WIDGETS',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.0,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: demo.relatedWidgetIds!.map((id) {
              return ActionChip(
                label: Text(id, style: const TextStyle(fontSize: 12)),
                visualDensity: VisualDensity.compact,
                onPressed: onRelatedWidgetTap != null
                    ? () => onRelatedWidgetTap!(id)
                    : null,
              );
            }).toList(),
          ),
        ],
      ],
    );
  }

  Widget _buildBadges(ColorScheme colorScheme) {
    return Wrap(
      spacing: 6,
      children: [
        if (demo.isMaterial)
          _Badge(
            label: 'Material',
            color: colorScheme.primary,
            bgColor: colorScheme.primaryContainer,
          ),
        if (demo.isCupertino)
          _Badge(
            label: 'Cupertino',
            color: colorScheme.tertiary,
            bgColor: colorScheme.tertiaryContainer,
          ),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;
  final Color bgColor;

  const _Badge({
    required this.label,
    required this.color,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

class _PropertyRefTile extends StatelessWidget {
  final WidgetPropertyRef prop;

  const _PropertyRefTile({required this.prop});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                prop.name,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                  fontFamily: 'JetBrains Mono, Fira Code, monospace',
                ),
              ),
              if (prop.isRequired) ...[
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                  decoration: BoxDecoration(
                    color: colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Text(
                    'required',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.error,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 2),
          Text(
            prop.type,
            style: TextStyle(
              fontSize: 11,
              color: colorScheme.primary,
              fontFamily: 'JetBrains Mono, Fira Code, monospace',
            ),
          ),
          if (prop.description.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              prop.description,
              style: TextStyle(
                fontSize: 12,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
          if (prop.defaultValue != null) ...[
            const SizedBox(height: 2),
            Text(
              'Default: ${prop.defaultValue}',
              style: TextStyle(
                fontSize: 11,
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
