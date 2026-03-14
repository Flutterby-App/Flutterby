import 'package:flutter/material.dart';
import '../models/widget_demo.dart';

class PropertyEditorPanel extends StatelessWidget {
  final List<PropertySchema> properties;
  final Map<String, dynamic> values;
  final ValueChanged<Map<String, dynamic>> onChanged;

  const PropertyEditorPanel({
    super.key,
    required this.properties,
    required this.values,
    required this.onChanged,
  });

  void _update(String name, dynamic value) {
    final next = Map<String, dynamic>.from(values);
    next[name] = value;
    onChanged(next);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: properties.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final prop = properties[index];
        return _buildEditor(prop);
      },
    );
  }

  Widget _buildEditor(PropertySchema prop) {
    return switch (prop.type) {
      PropertyType.string => _StringEditor(
          label: prop.label,
          value: values[prop.name] as String? ?? '',
          onChanged: (v) => _update(prop.name, v),
        ),
      PropertyType.double => _SliderEditor(
          label: prop.label,
          value: (values[prop.name] as num?)?.toDouble() ?? prop.defaultValue as double,
          min: prop.min ?? 0,
          max: prop.max ?? 100,
          onChanged: (v) => _update(prop.name, v),
        ),
      PropertyType.int => _IntSliderEditor(
          label: prop.label,
          value: (values[prop.name] as num?)?.toInt() ?? prop.defaultValue as int,
          min: prop.min?.toInt() ?? 0,
          max: prop.max?.toInt() ?? 10,
          onChanged: (v) => _update(prop.name, v),
        ),
      PropertyType.bool => _BoolEditor(
          label: prop.label,
          value: values[prop.name] as bool? ?? false,
          onChanged: (v) => _update(prop.name, v),
        ),
      PropertyType.enumChoice => _EnumEditor(
          label: prop.label,
          value: values[prop.name] as String? ?? prop.options!.first,
          options: prop.options!,
          onChanged: (v) => _update(prop.name, v),
        ),
      PropertyType.color => const SizedBox.shrink(),
    };
  }
}

// ---------------------------------------------------------------------------
// Individual editors
// ---------------------------------------------------------------------------

class _StringEditor extends StatefulWidget {
  final String label;
  final String value;
  final ValueChanged<String> onChanged;

  const _StringEditor({required this.label, required this.value, required this.onChanged});

  @override
  State<_StringEditor> createState() => _StringEditorState();
}

class _StringEditorState extends State<_StringEditor> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(covariant _StringEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value && _controller.text != widget.value) {
      _controller.text = widget.value;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Label(widget.label),
        const SizedBox(height: 4),
        TextField(
          controller: _controller,
          style: const TextStyle(fontSize: 14),
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onChanged: widget.onChanged,
        ),
      ],
    );
  }
}

class _SliderEditor extends StatelessWidget {
  final String label;
  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;

  const _SliderEditor({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _Label(label),
            const Spacer(),
            Text(
              value.toStringAsFixed(1),
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        Slider(
          value: value.clamp(min, max),
          min: min,
          max: max,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class _IntSliderEditor extends StatelessWidget {
  final String label;
  final int value;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  const _IntSliderEditor({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _Label(label),
            const Spacer(),
            Text(
              '$value',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        Slider(
          value: value.toDouble().clamp(min.toDouble(), max.toDouble()),
          min: min.toDouble(),
          max: max.toDouble(),
          divisions: max - min,
          onChanged: (v) => onChanged(v.round()),
        ),
      ],
    );
  }
}

class _BoolEditor extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _BoolEditor({required this.label, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _Label(label),
        const Spacer(),
        Switch(value: value, onChanged: onChanged),
      ],
    );
  }
}

class _EnumEditor extends StatelessWidget {
  final String label;
  final String value;
  final List<String> options;
  final ValueChanged<String> onChanged;

  const _EnumEditor({
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Label(label),
        const SizedBox(height: 6),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: options.map((opt) {
            final selected = opt == value;
            return ChoiceChip(
              label: Text(opt, style: const TextStyle(fontSize: 12)),
              selected: selected,
              onSelected: (_) => onChanged(opt),
              visualDensity: VisualDensity.compact,
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: Colors.grey.shade700,
      ),
    );
  }
}
