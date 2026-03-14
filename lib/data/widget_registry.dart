import 'package:flutter/material.dart';
import '../models/widget_demo.dart';

/// Preset colors available in the Container color picker.
const Map<String, Color> presetColors = {
  'Blue': Colors.blue,
  'Red': Colors.red,
  'Green': Colors.green,
  'Orange': Colors.orange,
  'Purple': Colors.purple,
  'Teal': Colors.teal,
  'Grey': Colors.grey,
  'Indigo': Colors.indigo,
};

/// Text color presets (includes Black).
const Map<String, Color> _textColors = {
  'Black': Colors.black,
  'Blue': Colors.blue,
  'Red': Colors.red,
  'Green': Colors.green,
  'Orange': Colors.orange,
  'Purple': Colors.purple,
  'Teal': Colors.teal,
  'Indigo': Colors.indigo,
};

/// Converts a color name from [presetColors] to a Flutter `Colors.*` string.
String _colorToCode(String colorName) {
  return 'Colors.${colorName.toLowerCase()}';
}

/// Small colored box used in Row/Column demos.
Widget _demoBox(String label) {
  return Container(
    width: 60,
    height: 40,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: Colors.indigo.shade100,
      borderRadius: BorderRadius.circular(6),
      border: Border.all(color: Colors.indigo.shade300),
    ),
    child: Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
  );
}

/// All demo widgets available in Flutterby v0.
final List<WidgetDemo> widgetRegistry = [
  _textDemo(),
  _containerDemo(),
  _rowDemo(),
  _columnDemo(),
  _elevatedButtonDemo(),
  _iconDemo(),
  _cardDemo(),
  _stackDemo(),
];

// ---------------------------------------------------------------------------
// Text
// ---------------------------------------------------------------------------
WidgetDemo _textDemo() {
  return WidgetDemo(
    id: 'text',
    displayName: 'Text',
    icon: Icons.text_fields,
    properties: const [
      PropertySchema(name: 'text', label: 'Text', type: PropertyType.string, defaultValue: 'Hello world'),
      PropertySchema(name: 'fontSize', label: 'Font Size', type: PropertyType.double, defaultValue: 24.0, min: 8, max: 72),
      PropertySchema(name: 'bold', label: 'Bold', type: PropertyType.bool, defaultValue: false),
      PropertySchema(name: 'italic', label: 'Italic', type: PropertyType.bool, defaultValue: false),
      PropertySchema(
        name: 'color',
        label: 'Color',
        type: PropertyType.enumChoice,
        defaultValue: 'Black',
        options: ['Black', 'Blue', 'Red', 'Green', 'Orange', 'Purple', 'Teal', 'Indigo'],
      ),
      PropertySchema(
        name: 'textAlign',
        label: 'Text Align',
        type: PropertyType.enumChoice,
        defaultValue: 'center',
        options: ['left', 'center', 'right'],
      ),
    ],
    previewBuilder: (props) {
      final align = {
        'left': TextAlign.left,
        'center': TextAlign.center,
        'right': TextAlign.right,
      }[props['textAlign']] ?? TextAlign.center;
      final color = _textColors[props['color']] ?? Colors.black;

      return Text(
        props['text'] as String,
        textAlign: align,
        style: TextStyle(
          fontSize: (props['fontSize'] as num).toDouble(),
          fontWeight: props['bold'] == true ? FontWeight.bold : FontWeight.normal,
          fontStyle: props['italic'] == true ? FontStyle.italic : FontStyle.normal,
          color: color,
        ),
      );
    },
    sourceGenerator: (props) {
      final bold = props['bold'] == true;
      final italic = props['italic'] == true;
      final fontSize = (props['fontSize'] as num).toDouble();
      final textAlign = props['textAlign'] as String;
      final colorName = props['color'] as String;
      final text = props['text'] as String;
      final escaped = text.replaceAll("'", "\\'");

      final buf = StringBuffer();
      buf.writeln("Text(");
      buf.writeln("  '$escaped',");
      buf.writeln("  textAlign: TextAlign.$textAlign,");
      buf.writeln("  style: TextStyle(");
      buf.writeln("    fontSize: ${_fmt(fontSize)},");
      if (bold) buf.writeln("    fontWeight: FontWeight.bold,");
      if (italic) buf.writeln("    fontStyle: FontStyle.italic,");
      if (colorName != 'Black') buf.writeln("    color: ${_colorToCode(colorName)},");
      buf.writeln("  ),");
      buf.write(")");
      return buf.toString();
    },
  );
}

// ---------------------------------------------------------------------------
// Container
// ---------------------------------------------------------------------------
WidgetDemo _containerDemo() {
  return WidgetDemo(
    id: 'container',
    displayName: 'Container',
    icon: Icons.check_box_outline_blank,
    properties: const [
      PropertySchema(name: 'width', label: 'Width', type: PropertyType.double, defaultValue: 200.0, min: 50, max: 400),
      PropertySchema(name: 'height', label: 'Height', type: PropertyType.double, defaultValue: 120.0, min: 30, max: 400),
      PropertySchema(name: 'padding', label: 'Padding', type: PropertyType.double, defaultValue: 16.0, min: 0, max: 64),
      PropertySchema(
        name: 'color',
        label: 'Color',
        type: PropertyType.enumChoice,
        defaultValue: 'Blue',
        options: ['Blue', 'Red', 'Green', 'Orange', 'Purple', 'Teal', 'Grey', 'Indigo'],
      ),
      PropertySchema(name: 'borderRadius', label: 'Border Radius', type: PropertyType.double, defaultValue: 12.0, min: 0, max: 64),
      PropertySchema(name: 'childText', label: 'Child Text', type: PropertyType.string, defaultValue: 'Container'),
    ],
    previewBuilder: (props) {
      final color = presetColors[props['color']] ?? Colors.blue;
      return Container(
        width: (props['width'] as num).toDouble(),
        height: (props['height'] as num).toDouble(),
        padding: EdgeInsets.all((props['padding'] as num).toDouble()),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular((props['borderRadius'] as num).toDouble()),
        ),
        child: Center(
          child: Text(
            props['childText'] as String,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
          ),
        ),
      );
    },
    sourceGenerator: (props) {
      final width = (props['width'] as num).toDouble();
      final height = (props['height'] as num).toDouble();
      final padding = (props['padding'] as num).toDouble();
      final colorName = props['color'] as String;
      final borderRadius = (props['borderRadius'] as num).toDouble();
      final childText = (props['childText'] as String).replaceAll("'", "\\'");

      final buf = StringBuffer();
      buf.writeln("Container(");
      buf.writeln("  width: ${_fmt(width)},");
      buf.writeln("  height: ${_fmt(height)},");
      buf.writeln("  padding: const EdgeInsets.all(${_fmt(padding)}),");
      buf.writeln("  decoration: BoxDecoration(");
      buf.writeln("    color: ${_colorToCode(colorName)},");
      buf.writeln("    borderRadius: BorderRadius.circular(${_fmt(borderRadius)}),");
      buf.writeln("  ),");
      buf.writeln("  child: const Center(");
      buf.writeln("    child: Text('$childText'),");
      buf.writeln("  ),");
      buf.write(")");
      return buf.toString();
    },
  );
}

// ---------------------------------------------------------------------------
// Row
// ---------------------------------------------------------------------------
WidgetDemo _rowDemo() {
  return WidgetDemo(
    id: 'row',
    displayName: 'Row',
    icon: Icons.table_rows_outlined,
    properties: const [
      PropertySchema(
        name: 'mainAxisAlignment',
        label: 'Main Axis',
        type: PropertyType.enumChoice,
        defaultValue: 'center',
        options: ['start', 'center', 'end', 'spaceBetween', 'spaceAround', 'spaceEvenly'],
      ),
      PropertySchema(
        name: 'crossAxisAlignment',
        label: 'Cross Axis',
        type: PropertyType.enumChoice,
        defaultValue: 'center',
        options: ['start', 'center', 'end'],
      ),
      PropertySchema(name: 'childCount', label: 'Children', type: PropertyType.int, defaultValue: 3, min: 2, max: 4),
    ],
    previewBuilder: (props) {
      final mainAxis = _parseMainAxis(props['mainAxisAlignment'] as String);
      final crossAxis = _parseCrossAxis(props['crossAxisAlignment'] as String);
      final count = (props['childCount'] as num).toInt();
      final labels = ['A', 'B', 'C', 'D'];
      return Row(
        mainAxisAlignment: mainAxis,
        crossAxisAlignment: crossAxis,
        children: [for (int i = 0; i < count; i++) _demoBox(labels[i])],
      );
    },
    sourceGenerator: (props) {
      final mainAxis = props['mainAxisAlignment'] as String;
      final crossAxis = props['crossAxisAlignment'] as String;
      final count = (props['childCount'] as num).toInt();
      final labels = ['A', 'B', 'C', 'D'];

      final buf = StringBuffer();
      buf.writeln("Row(");
      buf.writeln("  mainAxisAlignment: MainAxisAlignment.$mainAxis,");
      buf.writeln("  crossAxisAlignment: CrossAxisAlignment.$crossAxis,");
      buf.writeln("  children: [");
      for (int i = 0; i < count; i++) {
        buf.writeln("    _demoBox('${labels[i]}'),");
      }
      buf.writeln("  ],");
      buf.write(")");
      return buf.toString();
    },
  );
}

// ---------------------------------------------------------------------------
// Column
// ---------------------------------------------------------------------------
WidgetDemo _columnDemo() {
  return WidgetDemo(
    id: 'column',
    displayName: 'Column',
    icon: Icons.view_column_outlined,
    properties: const [
      PropertySchema(
        name: 'mainAxisAlignment',
        label: 'Main Axis',
        type: PropertyType.enumChoice,
        defaultValue: 'center',
        options: ['start', 'center', 'end', 'spaceBetween', 'spaceAround', 'spaceEvenly'],
      ),
      PropertySchema(
        name: 'crossAxisAlignment',
        label: 'Cross Axis',
        type: PropertyType.enumChoice,
        defaultValue: 'center',
        options: ['start', 'center', 'end', 'stretch'],
      ),
      PropertySchema(name: 'childCount', label: 'Children', type: PropertyType.int, defaultValue: 3, min: 2, max: 4),
    ],
    previewBuilder: (props) {
      final mainAxis = _parseMainAxis(props['mainAxisAlignment'] as String);
      final crossAxis = _parseCrossAxis(props['crossAxisAlignment'] as String);
      final count = (props['childCount'] as num).toInt();
      final labels = ['A', 'B', 'C', 'D'];
      return Column(
        mainAxisAlignment: mainAxis,
        crossAxisAlignment: crossAxis,
        children: [for (int i = 0; i < count; i++) _demoBox(labels[i])],
      );
    },
    sourceGenerator: (props) {
      final mainAxis = props['mainAxisAlignment'] as String;
      final crossAxis = props['crossAxisAlignment'] as String;
      final count = (props['childCount'] as num).toInt();
      final labels = ['A', 'B', 'C', 'D'];

      final buf = StringBuffer();
      buf.writeln("Column(");
      buf.writeln("  mainAxisAlignment: MainAxisAlignment.$mainAxis,");
      buf.writeln("  crossAxisAlignment: CrossAxisAlignment.$crossAxis,");
      buf.writeln("  children: [");
      for (int i = 0; i < count; i++) {
        buf.writeln("    _demoBox('${labels[i]}'),");
      }
      buf.writeln("  ],");
      buf.write(")");
      return buf.toString();
    },
  );
}

// ---------------------------------------------------------------------------
// ElevatedButton
// ---------------------------------------------------------------------------
WidgetDemo _elevatedButtonDemo() {
  return WidgetDemo(
    id: 'elevated_button',
    displayName: 'ElevatedButton',
    icon: Icons.smart_button,
    properties: const [
      PropertySchema(name: 'label', label: 'Label', type: PropertyType.string, defaultValue: 'Click Me'),
      PropertySchema(name: 'enabled', label: 'Enabled', type: PropertyType.bool, defaultValue: true),
      PropertySchema(name: 'padding', label: 'Padding', type: PropertyType.double, defaultValue: 16.0, min: 0, max: 48),
      PropertySchema(name: 'borderRadius', label: 'Border Radius', type: PropertyType.double, defaultValue: 12.0, min: 0, max: 32),
    ],
    previewBuilder: (props) {
      final enabled = props['enabled'] == true;
      return ElevatedButton(
        onPressed: enabled ? () {} : null,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all((props['padding'] as num).toDouble()),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular((props['borderRadius'] as num).toDouble()),
          ),
        ),
        child: Text(props['label'] as String),
      );
    },
    sourceGenerator: (props) {
      final label = (props['label'] as String).replaceAll("'", "\\'");
      final enabled = props['enabled'] == true;
      final padding = (props['padding'] as num).toDouble();
      final borderRadius = (props['borderRadius'] as num).toDouble();

      final buf = StringBuffer();
      buf.writeln("ElevatedButton(");
      buf.writeln("  onPressed: ${enabled ? '() {}' : 'null'},");
      buf.writeln("  style: ElevatedButton.styleFrom(");
      buf.writeln("    padding: const EdgeInsets.all(${_fmt(padding)}),");
      buf.writeln("    shape: RoundedRectangleBorder(");
      buf.writeln("      borderRadius: BorderRadius.circular(${_fmt(borderRadius)}),");
      buf.writeln("    ),");
      buf.writeln("  ),");
      buf.writeln("  child: const Text('$label'),");
      buf.write(")");
      return buf.toString();
    },
  );
}

// ---------------------------------------------------------------------------
// Icon
// ---------------------------------------------------------------------------
/// A curated set of icons for the demo.
const Map<String, IconData> _presetIcons = {
  'star': Icons.star,
  'favorite': Icons.favorite,
  'home': Icons.home,
  'settings': Icons.settings,
  'search': Icons.search,
  'check_circle': Icons.check_circle,
  'lightbulb': Icons.lightbulb,
  'rocket_launch': Icons.rocket_launch,
  'palette': Icons.palette,
  'bolt': Icons.bolt,
};

WidgetDemo _iconDemo() {
  return WidgetDemo(
    id: 'icon',
    displayName: 'Icon',
    icon: Icons.emoji_emotions_outlined,
    properties: const [
      PropertySchema(
        name: 'icon',
        label: 'Icon',
        type: PropertyType.enumChoice,
        defaultValue: 'star',
        options: ['star', 'favorite', 'home', 'settings', 'search', 'check_circle', 'lightbulb', 'rocket_launch', 'palette', 'bolt'],
      ),
      PropertySchema(name: 'size', label: 'Size', type: PropertyType.double, defaultValue: 48.0, min: 16, max: 128),
      PropertySchema(
        name: 'color',
        label: 'Color',
        type: PropertyType.enumChoice,
        defaultValue: 'Blue',
        options: ['Blue', 'Red', 'Green', 'Orange', 'Purple', 'Teal', 'Grey', 'Indigo'],
      ),
    ],
    previewBuilder: (props) {
      final iconData = _presetIcons[props['icon']] ?? Icons.star;
      final color = presetColors[props['color']] ?? Colors.blue;
      return Icon(
        iconData,
        size: (props['size'] as num).toDouble(),
        color: color,
      );
    },
    sourceGenerator: (props) {
      final iconName = props['icon'] as String;
      final size = (props['size'] as num).toDouble();
      final colorName = props['color'] as String;

      final buf = StringBuffer();
      buf.writeln("Icon(");
      buf.writeln("  Icons.$iconName,");
      buf.writeln("  size: ${_fmt(size)},");
      buf.writeln("  color: ${_colorToCode(colorName)},");
      buf.write(")");
      return buf.toString();
    },
  );
}

// ---------------------------------------------------------------------------
// Card
// ---------------------------------------------------------------------------
WidgetDemo _cardDemo() {
  return WidgetDemo(
    id: 'card',
    displayName: 'Card',
    icon: Icons.credit_card,
    properties: const [
      PropertySchema(name: 'elevation', label: 'Elevation', type: PropertyType.double, defaultValue: 4.0, min: 0, max: 24),
      PropertySchema(name: 'borderRadius', label: 'Border Radius', type: PropertyType.double, defaultValue: 12.0, min: 0, max: 32),
      PropertySchema(name: 'title', label: 'Title', type: PropertyType.string, defaultValue: 'Card Title'),
      PropertySchema(name: 'subtitle', label: 'Subtitle', type: PropertyType.string, defaultValue: 'Card subtitle goes here'),
      PropertySchema(name: 'showImage', label: 'Show Image Placeholder', type: PropertyType.bool, defaultValue: true),
    ],
    previewBuilder: (props) {
      final elevation = (props['elevation'] as num).toDouble();
      final borderRadius = (props['borderRadius'] as num).toDouble();
      final showImage = props['showImage'] == true;

      return SizedBox(
        width: 280,
        child: Card(
          elevation: elevation,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (showImage)
                Container(
                  height: 120,
                  width: double.infinity,
                  color: Colors.indigo.shade100,
                  child: Icon(Icons.image, size: 48, color: Colors.indigo.shade300),
                ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      props['title'] as String,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      props['subtitle'] as String,
                      style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
    sourceGenerator: (props) {
      final elevation = (props['elevation'] as num).toDouble();
      final borderRadius = (props['borderRadius'] as num).toDouble();
      final title = (props['title'] as String).replaceAll("'", "\\'");
      final subtitle = (props['subtitle'] as String).replaceAll("'", "\\'");
      final showImage = props['showImage'] == true;

      final buf = StringBuffer();
      buf.writeln("Card(");
      buf.writeln("  elevation: ${_fmt(elevation)},");
      buf.writeln("  shape: RoundedRectangleBorder(");
      buf.writeln("    borderRadius: BorderRadius.circular(${_fmt(borderRadius)}),");
      buf.writeln("  ),");
      buf.writeln("  clipBehavior: Clip.antiAlias,");
      buf.writeln("  child: Column(");
      buf.writeln("    mainAxisSize: MainAxisSize.min,");
      buf.writeln("    crossAxisAlignment: CrossAxisAlignment.start,");
      buf.writeln("    children: [");
      if (showImage) {
        buf.writeln("      Container(");
        buf.writeln("        height: 120,");
        buf.writeln("        color: Colors.grey.shade200,");
        buf.writeln("        child: const Center(");
        buf.writeln("          child: Icon(Icons.image, size: 48),");
        buf.writeln("        ),");
        buf.writeln("      ),");
      }
      buf.writeln("      Padding(");
      buf.writeln("        padding: const EdgeInsets.all(16),");
      buf.writeln("        child: Column(");
      buf.writeln("          crossAxisAlignment: CrossAxisAlignment.start,");
      buf.writeln("          children: [");
      buf.writeln("            Text(");
      buf.writeln("              '$title',");
      buf.writeln("              style: const TextStyle(");
      buf.writeln("                fontSize: 18,");
      buf.writeln("                fontWeight: FontWeight.w600,");
      buf.writeln("              ),");
      buf.writeln("            ),");
      buf.writeln("            const SizedBox(height: 4),");
      buf.writeln("            Text('$subtitle'),");
      buf.writeln("          ],");
      buf.writeln("        ),");
      buf.writeln("      ),");
      buf.writeln("    ],");
      buf.writeln("  ),");
      buf.write(")");
      return buf.toString();
    },
  );
}

// ---------------------------------------------------------------------------
// Stack
// ---------------------------------------------------------------------------
WidgetDemo _stackDemo() {
  return WidgetDemo(
    id: 'stack',
    displayName: 'Stack',
    icon: Icons.layers,
    properties: const [
      PropertySchema(
        name: 'alignment',
        label: 'Alignment',
        type: PropertyType.enumChoice,
        defaultValue: 'center',
        options: ['topLeft', 'topCenter', 'topRight', 'centerLeft', 'center', 'centerRight', 'bottomLeft', 'bottomCenter', 'bottomRight'],
      ),
      PropertySchema(name: 'layers', label: 'Layers', type: PropertyType.int, defaultValue: 3, min: 2, max: 4),
      PropertySchema(name: 'offset', label: 'Offset', type: PropertyType.double, defaultValue: 20.0, min: 5, max: 40),
    ],
    previewBuilder: (props) {
      final alignment = _parseAlignment(props['alignment'] as String);
      final layers = (props['layers'] as num).toInt();
      final offset = (props['offset'] as num).toDouble();
      final colors = [Colors.blue.shade200, Colors.indigo.shade300, Colors.purple.shade300, Colors.pink.shade300];

      return SizedBox(
        width: 240,
        height: 200,
        child: Stack(
          alignment: alignment,
          children: [
            for (int i = 0; i < layers; i++)
              Positioned(
                left: i * offset,
                top: i * offset,
                child: Container(
                  width: 100,
                  height: 70,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: colors[i % colors.length],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 4,
                        offset: const Offset(1, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    'Layer ${i + 1}',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13),
                  ),
                ),
              ),
          ],
        ),
      );
    },
    sourceGenerator: (props) {
      final alignment = props['alignment'] as String;
      final layers = (props['layers'] as num).toInt();
      final offset = (props['offset'] as num).toDouble();

      final buf = StringBuffer();
      buf.writeln("Stack(");
      buf.writeln("  alignment: Alignment.$alignment,");
      buf.writeln("  children: [");
      for (int i = 0; i < layers; i++) {
        buf.writeln("    Positioned(");
        buf.writeln("      left: ${_fmt(i * offset)},");
        buf.writeln("      top: ${_fmt(i * offset)},");
        buf.writeln("      child: _layerBox('Layer ${i + 1}'),");
        buf.writeln("    ),");
      }
      buf.writeln("  ],");
      buf.write(")");
      return buf.toString();
    },
  );
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------
Alignment _parseAlignment(String value) {
  return switch (value) {
    'topLeft' => Alignment.topLeft,
    'topCenter' => Alignment.topCenter,
    'topRight' => Alignment.topRight,
    'centerLeft' => Alignment.centerLeft,
    'center' => Alignment.center,
    'centerRight' => Alignment.centerRight,
    'bottomLeft' => Alignment.bottomLeft,
    'bottomCenter' => Alignment.bottomCenter,
    'bottomRight' => Alignment.bottomRight,
    _ => Alignment.center,
  };
}

/// Formats a double for clean code output (e.g. 24.0 not 24.000000000000004).
String _fmt(double v) {
  if (v == v.roundToDouble()) return v.toStringAsFixed(0);
  return v.toStringAsFixed(1);
}

MainAxisAlignment _parseMainAxis(String value) {
  return switch (value) {
    'start' => MainAxisAlignment.start,
    'center' => MainAxisAlignment.center,
    'end' => MainAxisAlignment.end,
    'spaceBetween' => MainAxisAlignment.spaceBetween,
    'spaceAround' => MainAxisAlignment.spaceAround,
    'spaceEvenly' => MainAxisAlignment.spaceEvenly,
    _ => MainAxisAlignment.center,
  };
}

CrossAxisAlignment _parseCrossAxis(String value) {
  return switch (value) {
    'start' => CrossAxisAlignment.start,
    'center' => CrossAxisAlignment.center,
    'end' => CrossAxisAlignment.end,
    'stretch' => CrossAxisAlignment.stretch,
    _ => CrossAxisAlignment.center,
  };
}
