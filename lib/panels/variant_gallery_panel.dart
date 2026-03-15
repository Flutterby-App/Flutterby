import 'package:flutter/material.dart';

import '../models/widget_demo.dart';

class VariantGalleryPanel extends StatefulWidget {
  final WidgetDemo demo;
  final Map<String, dynamic> currentValues;
  final ValueChanged<Map<String, dynamic>> onApplyValues;

  const VariantGalleryPanel({
    super.key,
    required this.demo,
    required this.currentValues,
    required this.onApplyValues,
  });

  @override
  State<VariantGalleryPanel> createState() => _VariantGalleryPanelState();
}

class _VariantGalleryPanelState extends State<VariantGalleryPanel> {
  String? _axis1;
  String? _axis2;

  List<PropertySchema> get _variableProperties {
    return widget.demo.properties.where((p) {
      return p.type == PropertyType.double ||
          p.type == PropertyType.int ||
          p.type == PropertyType.bool ||
          p.type == PropertyType.enumChoice;
    }).toList();
  }

  @override
  void didUpdateWidget(VariantGalleryPanel old) {
    super.didUpdateWidget(old);
    if (old.demo.id != widget.demo.id) {
      _axis1 = null;
      _axis2 = null;
    }
  }

  List<dynamic> _generateValues(PropertySchema prop) {
    return switch (prop.type) {
      PropertyType.double => () {
          final min = prop.min ?? 0;
          final max = prop.max ?? 100;
          const steps = 5;
          return List.generate(steps, (i) {
            final v = min + (max - min) * i / (steps - 1);
            return double.parse(v.toStringAsFixed(1));
          });
        }(),
      PropertyType.int => () {
          final min = (prop.min ?? 0).toInt();
          final max = (prop.max ?? 10).toInt();
          final steps = (max - min).clamp(2, 6);
          return List.generate(steps, (i) => min + ((max - min) * i / (steps - 1)).round());
        }(),
      PropertyType.bool => [true, false],
      PropertyType.enumChoice => prop.options ?? [],
      _ => [],
    };
  }

  String _formatValue(dynamic v) {
    if (v is double) return v.toStringAsFixed(1);
    if (v is bool) return v ? 'true' : 'false';
    return v.toString();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final varProps = _variableProperties;

    if (varProps.isEmpty) {
      return Center(
        child: Text('No variable properties', style: TextStyle(color: colorScheme.onSurfaceVariant)),
      );
    }

    // Auto-select first axis if not set
    _axis1 ??= varProps.first.name;
    final axis1Prop = varProps.firstWhere((p) => p.name == _axis1, orElse: () => varProps.first);
    final axis2Prop = _axis2 != null ? varProps.where((p) => p.name == _axis2).firstOrNull : null;

    final axis1Values = _generateValues(axis1Prop);
    final axis2Values = axis2Prop != null ? _generateValues(axis2Prop) : <dynamic>[null];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Axis selectors
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Row(
            children: [
              Text('Axis 1: ', style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant)),
              const SizedBox(width: 4),
              _AxisDropdown(
                props: varProps,
                value: _axis1!,
                onChanged: (v) => setState(() => _axis1 = v),
              ),
              const SizedBox(width: 16),
              Text('Axis 2: ', style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant)),
              const SizedBox(width: 4),
              _AxisDropdown(
                props: [PropertySchema(name: '__none__', label: 'None', type: PropertyType.string, defaultValue: ''), ...varProps],
                value: _axis2 ?? '__none__',
                onChanged: (v) => setState(() => _axis2 = v == '__none__' ? null : v),
              ),
            ],
          ),
        ),
        Divider(height: 1, color: colorScheme.outlineVariant),
        // Grid
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: axis2Prop != null ? axis2Values.length : (axis1Values.length).clamp(1, 4),
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 1.0,
            ),
            itemCount: axis1Values.length * axis2Values.length,
            itemBuilder: (context, index) {
              final i1 = axis2Prop != null ? index ~/ axis2Values.length : index;
              final i2 = axis2Prop != null ? index % axis2Values.length : 0;

              final cellValues = Map<String, dynamic>.from(widget.currentValues);
              cellValues[axis1Prop.name] = axis1Values[i1];
              if (axis2Prop != null && axis2Values[i2] != null) {
                cellValues[axis2Prop.name] = axis2Values[i2];
              }

              final label = axis2Prop != null
                  ? '${_formatValue(axis1Values[i1])}, ${_formatValue(axis2Values[i2])}'
                  : '${axis1Prop.label}: ${_formatValue(axis1Values[i1])}';

              return GestureDetector(
                onTap: () => widget.onApplyValues(cellValues),
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: [
                      Expanded(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: SizedBox(
                                width: 200,
                                height: 200,
                                child: Center(child: widget.demo.previewBuilder(cellValues)),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                        color: colorScheme.surfaceContainerHighest,
                        child: Text(
                          label,
                          style: TextStyle(fontSize: 9, color: colorScheme.onSurfaceVariant),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _AxisDropdown extends StatelessWidget {
  final List<PropertySchema> props;
  final String value;
  final ValueChanged<String> onChanged;

  const _AxisDropdown({required this.props, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: value,
      isDense: true,
      style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface),
      items: props.map((p) => DropdownMenuItem(value: p.name, child: Text(p.label))).toList(),
      onChanged: (v) {
        if (v != null) onChanged(v);
      },
    );
  }
}
