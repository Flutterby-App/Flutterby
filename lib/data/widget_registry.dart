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
      color: Colors.indigo.shade400,
      borderRadius: BorderRadius.circular(6),
    ),
    child: Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white)),
  );
}

/// All demo widgets available in Flutterby v0, grouped by category.
final List<WidgetDemo> widgetRegistry = [
  // Display
  _textDemo(),
  _iconDemo(),
  _dividerDemo(),
  _opacityDemo(),
  _progressIndicatorDemo(),
  // Layout
  _containerDemo(),
  _rowDemo(),
  _columnDemo(),
  _wrapDemo(),
  _stackDemo(),
  _paddingDemo(),
  _centerDemo(),
  _sizedBoxDemo(),
  // Input
  _elevatedButtonDemo(),
  _textFieldDemo(),
  _switchDemo(),
  _sliderDemo(),
  // Composite
  _cardDemo(),
  _listTileDemo(),
];

// ---------------------------------------------------------------------------
// Text
// ---------------------------------------------------------------------------
WidgetDemo _textDemo() {
  return WidgetDemo(
    id: 'text',
    displayName: 'Text',
    icon: Icons.text_fields,
    category: 'Display',
    description: 'A run of styled text.',
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
    description: 'A box with decoration, padding, and sizing.',
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
    description: 'Lays out children horizontally.',
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
    description: 'Lays out children vertically.',
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
    category: 'Input',
    description: 'A Material button with elevation.',
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
    category: 'Display',
    description: 'A Material Design icon.',
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
    category: 'Composite',
    description: 'A Material card with elevation and rounded corners.',
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
                  color: Colors.indigo.shade400,
                  child: Icon(Icons.image, size: 48, color: Colors.indigo.shade200),
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
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
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
    description: 'Overlaps children on top of each other.',
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
      final colors = [Colors.blue.shade400, Colors.indigo.shade500, Colors.purple.shade400, Colors.pink.shade400];

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
// Padding
// ---------------------------------------------------------------------------
WidgetDemo _paddingDemo() {
  return WidgetDemo(
    id: 'padding',
    displayName: 'Padding',
    icon: Icons.padding,
    description: 'Adds empty space around a child widget.',
    properties: const [
      PropertySchema(name: 'horizontal', label: 'Horizontal', type: PropertyType.double, defaultValue: 24.0, min: 0, max: 64),
      PropertySchema(name: 'vertical', label: 'Vertical', type: PropertyType.double, defaultValue: 16.0, min: 0, max: 64),
      PropertySchema(name: 'childText', label: 'Child Text', type: PropertyType.string, defaultValue: 'Padded content'),
      PropertySchema(name: 'showBorder', label: 'Show Boundary', type: PropertyType.bool, defaultValue: true),
    ],
    previewBuilder: (props) {
      final h = (props['horizontal'] as num).toDouble();
      final v = (props['vertical'] as num).toDouble();
      final showBorder = props['showBorder'] == true;

      return Container(
        decoration: showBorder
            ? BoxDecoration(
                border: Border.all(color: Colors.indigo.withValues(alpha: 0.4), width: 1),
                borderRadius: BorderRadius.circular(4),
              )
            : null,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: h, vertical: v),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.indigo.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              props['childText'] as String,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ),
      );
    },
    sourceGenerator: (props) {
      final h = (props['horizontal'] as num).toDouble();
      final v = (props['vertical'] as num).toDouble();
      final childText = (props['childText'] as String).replaceAll("'", "\\'");

      final buf = StringBuffer();
      buf.writeln("Padding(");
      if (h == v) {
        buf.writeln("  padding: const EdgeInsets.all(${_fmt(h)}),");
      } else {
        buf.writeln("  padding: const EdgeInsets.symmetric(");
        buf.writeln("    horizontal: ${_fmt(h)},");
        buf.writeln("    vertical: ${_fmt(v)},");
        buf.writeln("  ),");
      }
      buf.writeln("  child: Text('$childText'),");
      buf.write(")");
      return buf.toString();
    },
  );
}

// ---------------------------------------------------------------------------
// Center
// ---------------------------------------------------------------------------
WidgetDemo _centerDemo() {
  return WidgetDemo(
    id: 'center',
    displayName: 'Center',
    icon: Icons.center_focus_strong,
    description: 'Centers its child within itself.',
    properties: const [
      PropertySchema(name: 'widthFactor', label: 'Width Factor', type: PropertyType.double, defaultValue: 1.0, min: 0.5, max: 3.0),
      PropertySchema(name: 'heightFactor', label: 'Height Factor', type: PropertyType.double, defaultValue: 1.0, min: 0.5, max: 3.0),
      PropertySchema(name: 'childText', label: 'Child Text', type: PropertyType.string, defaultValue: 'Centered'),
      PropertySchema(name: 'showBorder', label: 'Show Boundary', type: PropertyType.bool, defaultValue: true),
    ],
    previewBuilder: (props) {
      final wf = (props['widthFactor'] as num).toDouble();
      final hf = (props['heightFactor'] as num).toDouble();
      final showBorder = props['showBorder'] == true;

      return Container(
        decoration: showBorder
            ? BoxDecoration(
                border: Border.all(color: Colors.indigo.withValues(alpha: 0.4), width: 1),
                borderRadius: BorderRadius.circular(4),
              )
            : null,
        child: Center(
          widthFactor: wf,
          heightFactor: hf,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.indigo.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              props['childText'] as String,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
        ),
      );
    },
    sourceGenerator: (props) {
      final wf = (props['widthFactor'] as num).toDouble();
      final hf = (props['heightFactor'] as num).toDouble();
      final childText = (props['childText'] as String).replaceAll("'", "\\'");

      final buf = StringBuffer();
      buf.writeln("Center(");
      if (wf != 1.0) buf.writeln("  widthFactor: ${_fmt(wf)},");
      if (hf != 1.0) buf.writeln("  heightFactor: ${_fmt(hf)},");
      buf.writeln("  child: Text('$childText'),");
      buf.write(")");
      return buf.toString();
    },
  );
}

// ---------------------------------------------------------------------------
// Wrap
// ---------------------------------------------------------------------------
WidgetDemo _wrapDemo() {
  return WidgetDemo(
    id: 'wrap',
    displayName: 'Wrap',
    icon: Icons.wrap_text,
    description: 'Lays out children and wraps to the next line.',
    properties: const [
      PropertySchema(name: 'spacing', label: 'Spacing', type: PropertyType.double, defaultValue: 8.0, min: 0, max: 24),
      PropertySchema(name: 'runSpacing', label: 'Run Spacing', type: PropertyType.double, defaultValue: 8.0, min: 0, max: 24),
      PropertySchema(
        name: 'alignment',
        label: 'Alignment',
        type: PropertyType.enumChoice,
        defaultValue: 'start',
        options: ['start', 'center', 'end', 'spaceBetween', 'spaceAround', 'spaceEvenly'],
      ),
      PropertySchema(name: 'chipCount', label: 'Chips', type: PropertyType.int, defaultValue: 6, min: 3, max: 10),
    ],
    previewBuilder: (props) {
      final spacing = (props['spacing'] as num).toDouble();
      final runSpacing = (props['runSpacing'] as num).toDouble();
      final alignment = _parseWrapAlignment(props['alignment'] as String);
      final count = (props['chipCount'] as num).toInt();
      final labels = ['Flutter', 'Dart', 'Widget', 'Layout', 'Material', 'Design', 'Mobile', 'Web', 'Desktop', 'App'];

      return SizedBox(
        width: 300,
        child: Wrap(
          spacing: spacing,
          runSpacing: runSpacing,
          alignment: alignment,
          children: [
            for (int i = 0; i < count; i++)
              Chip(
                label: Text(labels[i % labels.length], style: const TextStyle(fontSize: 13)),
                backgroundColor: Colors.indigo.withValues(alpha: 0.12),
                side: BorderSide(color: Colors.indigo.withValues(alpha: 0.3)),
              ),
          ],
        ),
      );
    },
    sourceGenerator: (props) {
      final spacing = (props['spacing'] as num).toDouble();
      final runSpacing = (props['runSpacing'] as num).toDouble();
      final alignment = props['alignment'] as String;
      final count = (props['chipCount'] as num).toInt();
      final labels = ['Flutter', 'Dart', 'Widget', 'Layout', 'Material', 'Design', 'Mobile', 'Web', 'Desktop', 'App'];

      final buf = StringBuffer();
      buf.writeln("Wrap(");
      buf.writeln("  spacing: ${_fmt(spacing)},");
      buf.writeln("  runSpacing: ${_fmt(runSpacing)},");
      buf.writeln("  alignment: WrapAlignment.$alignment,");
      buf.writeln("  children: [");
      for (int i = 0; i < count; i++) {
        buf.writeln("    Chip(label: Text('${labels[i % labels.length]}')),");
      }
      buf.writeln("  ],");
      buf.write(")");
      return buf.toString();
    },
  );
}

WrapAlignment _parseWrapAlignment(String value) {
  return switch (value) {
    'start' => WrapAlignment.start,
    'center' => WrapAlignment.center,
    'end' => WrapAlignment.end,
    'spaceBetween' => WrapAlignment.spaceBetween,
    'spaceAround' => WrapAlignment.spaceAround,
    'spaceEvenly' => WrapAlignment.spaceEvenly,
    _ => WrapAlignment.start,
  };
}

// ---------------------------------------------------------------------------
// ListTile
// ---------------------------------------------------------------------------
WidgetDemo _listTileDemo() {
  return WidgetDemo(
    id: 'list_tile',
    displayName: 'ListTile',
    icon: Icons.list,
    category: 'Composite',
    description: 'A single row with icon, text, and trailing action.',
    properties: const [
      PropertySchema(name: 'title', label: 'Title', type: PropertyType.string, defaultValue: 'List Tile Title'),
      PropertySchema(name: 'subtitle', label: 'Subtitle', type: PropertyType.string, defaultValue: 'Secondary text goes here'),
      PropertySchema(name: 'showLeading', label: 'Show Leading Icon', type: PropertyType.bool, defaultValue: true),
      PropertySchema(
        name: 'leadingIcon',
        label: 'Leading Icon',
        type: PropertyType.enumChoice,
        defaultValue: 'person',
        options: ['person', 'email', 'phone', 'star', 'settings', 'notifications'],
      ),
      PropertySchema(name: 'showTrailing', label: 'Show Trailing', type: PropertyType.bool, defaultValue: true),
      PropertySchema(name: 'dense', label: 'Dense', type: PropertyType.bool, defaultValue: false),
    ],
    previewBuilder: (props) {
      final showLeading = props['showLeading'] == true;
      final showTrailing = props['showTrailing'] == true;
      final dense = props['dense'] == true;
      final leadingIcon = _listTileIcons[props['leadingIcon']] ?? Icons.person;

      return SizedBox(
        width: 340,
        child: Card(
          child: ListTile(
            leading: showLeading ? Icon(leadingIcon) : null,
            title: Text(props['title'] as String),
            subtitle: Text(props['subtitle'] as String),
            trailing: showTrailing ? const Icon(Icons.chevron_right) : null,
            dense: dense,
          ),
        ),
      );
    },
    sourceGenerator: (props) {
      final title = (props['title'] as String).replaceAll("'", "\\'");
      final subtitle = (props['subtitle'] as String).replaceAll("'", "\\'");
      final showLeading = props['showLeading'] == true;
      final showTrailing = props['showTrailing'] == true;
      final dense = props['dense'] == true;
      final leadingIcon = props['leadingIcon'] as String;

      final buf = StringBuffer();
      buf.writeln("ListTile(");
      if (showLeading) buf.writeln("  leading: const Icon(Icons.$leadingIcon),");
      buf.writeln("  title: const Text('$title'),");
      buf.writeln("  subtitle: const Text('$subtitle'),");
      if (showTrailing) buf.writeln("  trailing: const Icon(Icons.chevron_right),");
      if (dense) buf.writeln("  dense: true,");
      buf.write(")");
      return buf.toString();
    },
  );
}

const Map<String, IconData> _listTileIcons = {
  'person': Icons.person,
  'email': Icons.email,
  'phone': Icons.phone,
  'star': Icons.star,
  'settings': Icons.settings,
  'notifications': Icons.notifications,
};

// ---------------------------------------------------------------------------
// SizedBox
// ---------------------------------------------------------------------------
WidgetDemo _sizedBoxDemo() {
  return WidgetDemo(
    id: 'sized_box',
    displayName: 'SizedBox',
    icon: Icons.aspect_ratio,
    description: 'A box with a fixed width and/or height.',
    properties: const [
      PropertySchema(name: 'width', label: 'Width', type: PropertyType.double, defaultValue: 200.0, min: 20, max: 400),
      PropertySchema(name: 'height', label: 'Height', type: PropertyType.double, defaultValue: 100.0, min: 20, max: 300),
      PropertySchema(name: 'hasChild', label: 'Has Child', type: PropertyType.bool, defaultValue: true),
      PropertySchema(name: 'childText', label: 'Child Text', type: PropertyType.string, defaultValue: 'Fixed size'),
    ],
    previewBuilder: (props) {
      final w = (props['width'] as num).toDouble();
      final h = (props['height'] as num).toDouble();
      final hasChild = props['hasChild'] == true;

      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.indigo.withValues(alpha: 0.5), width: 1.5),
          borderRadius: BorderRadius.circular(4),
        ),
        child: SizedBox(
          width: w,
          height: h,
          child: hasChild
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        props['childText'] as String,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${w.round()} × ${h.round()}',
                        style: const TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : null,
        ),
      );
    },
    sourceGenerator: (props) {
      final w = (props['width'] as num).toDouble();
      final h = (props['height'] as num).toDouble();
      final hasChild = props['hasChild'] == true;
      final childText = (props['childText'] as String).replaceAll("'", "\\'");

      final buf = StringBuffer();
      buf.writeln("SizedBox(");
      buf.writeln("  width: ${_fmt(w)},");
      buf.writeln("  height: ${_fmt(h)},");
      if (hasChild) {
        buf.writeln("  child: Center(");
        buf.writeln("    child: Text('$childText'),");
        buf.writeln("  ),");
      }
      buf.write(")");
      return buf.toString();
    },
  );
}

// ---------------------------------------------------------------------------
// Slider
// ---------------------------------------------------------------------------
WidgetDemo _sliderDemo() {
  return WidgetDemo(
    id: 'slider_widget',
    displayName: 'Slider',
    icon: Icons.tune,
    category: 'Input',
    description: 'A Material slider for selecting a value from a range.',
    properties: const [
      PropertySchema(name: 'value', label: 'Value', type: PropertyType.double, defaultValue: 0.5, min: 0.0, max: 1.0),
      PropertySchema(name: 'divisions', label: 'Divisions', type: PropertyType.int, defaultValue: 0, min: 0, max: 20),
      PropertySchema(name: 'showLabel', label: 'Show Label', type: PropertyType.bool, defaultValue: true),
      PropertySchema(
        name: 'color',
        label: 'Active Color',
        type: PropertyType.enumChoice,
        defaultValue: 'Blue',
        options: ['Blue', 'Red', 'Green', 'Orange', 'Purple', 'Indigo'],
      ),
    ],
    previewBuilder: (props) {
      final value = (props['value'] as num).toDouble().clamp(0.0, 1.0);
      final divisions = (props['divisions'] as num).toInt();
      final showLabel = props['showLabel'] == true;
      final color = presetColors[props['color']] ?? Colors.blue;

      return SizedBox(
        width: 300,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Slider(
              value: value,
              divisions: divisions > 0 ? divisions : null,
              label: showLabel ? value.toStringAsFixed(2) : null,
              activeColor: color,
              onChanged: (_) {},
            ),
            if (showLabel)
              Text(
                value.toStringAsFixed(2),
                style: TextStyle(fontSize: 13, color: color, fontWeight: FontWeight.w600),
              ),
          ],
        ),
      );
    },
    sourceGenerator: (props) {
      final value = (props['value'] as num).toDouble();
      final divisions = (props['divisions'] as num).toInt();
      final showLabel = props['showLabel'] == true;
      final colorName = props['color'] as String;

      final buf = StringBuffer();
      buf.writeln("Slider(");
      buf.writeln("  value: _value,");
      if (divisions > 0) buf.writeln("  divisions: $divisions,");
      if (showLabel) buf.writeln("  label: _value.toStringAsFixed(2),");
      buf.writeln("  activeColor: ${_colorToCode(colorName)},");
      buf.writeln("  onChanged: (double newValue) {");
      buf.writeln("    setState(() => _value = newValue);");
      buf.writeln("  },");
      buf.write(")");
      return buf.toString();
    },
  );
}

// ---------------------------------------------------------------------------
// Divider
// ---------------------------------------------------------------------------
WidgetDemo _dividerDemo() {
  return WidgetDemo(
    id: 'divider',
    displayName: 'Divider',
    icon: Icons.horizontal_rule,
    category: 'Display',
    description: 'A thin horizontal or vertical line.',
    properties: const [
      PropertySchema(name: 'thickness', label: 'Thickness', type: PropertyType.double, defaultValue: 1.0, min: 0.5, max: 8),
      PropertySchema(name: 'indent', label: 'Indent', type: PropertyType.double, defaultValue: 0.0, min: 0, max: 60),
      PropertySchema(name: 'endIndent', label: 'End Indent', type: PropertyType.double, defaultValue: 0.0, min: 0, max: 60),
      PropertySchema(
        name: 'color',
        label: 'Color',
        type: PropertyType.enumChoice,
        defaultValue: 'Grey',
        options: ['Grey', 'Blue', 'Red', 'Green', 'Orange', 'Purple', 'Teal', 'Indigo'],
      ),
    ],
    previewBuilder: (props) {
      final thickness = (props['thickness'] as num).toDouble();
      final indent = (props['indent'] as num).toDouble();
      final endIndent = (props['endIndent'] as num).toDouble();
      final color = presetColors[props['color']] ?? Colors.grey;

      return SizedBox(
        width: 300,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Content above', style: TextStyle(fontSize: 14)),
            const SizedBox(height: 8),
            Divider(thickness: thickness, indent: indent, endIndent: endIndent, color: color),
            const SizedBox(height: 8),
            const Text('Content below', style: TextStyle(fontSize: 14)),
          ],
        ),
      );
    },
    sourceGenerator: (props) {
      final thickness = (props['thickness'] as num).toDouble();
      final indent = (props['indent'] as num).toDouble();
      final endIndent = (props['endIndent'] as num).toDouble();
      final colorName = props['color'] as String;

      final buf = StringBuffer();
      buf.writeln("Divider(");
      if (thickness != 1.0) buf.writeln("  thickness: ${_fmt(thickness)},");
      if (indent != 0.0) buf.writeln("  indent: ${_fmt(indent)},");
      if (endIndent != 0.0) buf.writeln("  endIndent: ${_fmt(endIndent)},");
      if (colorName != 'Grey') buf.writeln("  color: ${_colorToCode(colorName)},");
      buf.write(")");
      return buf.toString();
    },
  );
}

// ---------------------------------------------------------------------------
// Opacity
// ---------------------------------------------------------------------------
WidgetDemo _opacityDemo() {
  return WidgetDemo(
    id: 'opacity',
    displayName: 'Opacity',
    icon: Icons.opacity,
    category: 'Display',
    description: 'Makes a child partially transparent.',
    properties: const [
      PropertySchema(name: 'opacity', label: 'Opacity', type: PropertyType.double, defaultValue: 0.5, min: 0.0, max: 1.0),
      PropertySchema(
        name: 'icon',
        label: 'Child Icon',
        type: PropertyType.enumChoice,
        defaultValue: 'star',
        options: ['star', 'favorite', 'home', 'lightbulb', 'rocket_launch'],
      ),
      PropertySchema(
        name: 'color',
        label: 'Color',
        type: PropertyType.enumChoice,
        defaultValue: 'Blue',
        options: ['Blue', 'Red', 'Green', 'Orange', 'Purple', 'Indigo'],
      ),
    ],
    previewBuilder: (props) {
      final opacity = (props['opacity'] as num).toDouble();
      final iconData = _presetIcons[props['icon']] ?? Icons.star;
      final color = presetColors[props['color']] ?? Colors.blue;

      return Opacity(
        opacity: opacity.clamp(0.0, 1.0),
        child: Icon(iconData, size: 80, color: color),
      );
    },
    sourceGenerator: (props) {
      final opacity = (props['opacity'] as num).toDouble();
      final iconName = props['icon'] as String;
      final colorName = props['color'] as String;

      final buf = StringBuffer();
      buf.writeln("Opacity(");
      buf.writeln("  opacity: ${_fmt(opacity)},");
      buf.writeln("  child: Icon(");
      buf.writeln("    Icons.$iconName,");
      buf.writeln("    size: 80,");
      buf.writeln("    color: ${_colorToCode(colorName)},");
      buf.writeln("  ),");
      buf.write(")");
      return buf.toString();
    },
  );
}

// ---------------------------------------------------------------------------
// CircularProgressIndicator
// ---------------------------------------------------------------------------
WidgetDemo _progressIndicatorDemo() {
  return WidgetDemo(
    id: 'progress_indicator',
    displayName: 'Progress',
    icon: Icons.donut_large,
    category: 'Display',
    description: 'Circular or linear progress indicators.',
    properties: const [
      PropertySchema(
        name: 'type',
        label: 'Type',
        type: PropertyType.enumChoice,
        defaultValue: 'circular',
        options: ['circular', 'linear'],
      ),
      PropertySchema(name: 'determinate', label: 'Determinate', type: PropertyType.bool, defaultValue: true),
      PropertySchema(name: 'value', label: 'Value', type: PropertyType.double, defaultValue: 0.65, min: 0.0, max: 1.0),
      PropertySchema(name: 'strokeWidth', label: 'Stroke Width', type: PropertyType.double, defaultValue: 4.0, min: 1, max: 12),
      PropertySchema(
        name: 'color',
        label: 'Color',
        type: PropertyType.enumChoice,
        defaultValue: 'Blue',
        options: ['Blue', 'Red', 'Green', 'Orange', 'Purple', 'Indigo'],
      ),
    ],
    previewBuilder: (props) {
      final isCircular = props['type'] == 'circular';
      final determinate = props['determinate'] == true;
      final value = (props['value'] as num).toDouble().clamp(0.0, 1.0);
      final strokeWidth = (props['strokeWidth'] as num).toDouble();
      final color = presetColors[props['color']] ?? Colors.blue;

      if (isCircular) {
        return SizedBox(
          width: 80,
          height: 80,
          child: CircularProgressIndicator(
            value: determinate ? value : null,
            strokeWidth: strokeWidth,
            color: color,
          ),
        );
      } else {
        return SizedBox(
          width: 260,
          child: LinearProgressIndicator(
            value: determinate ? value : null,
            minHeight: strokeWidth,
            color: color,
          ),
        );
      }
    },
    sourceGenerator: (props) {
      final isCircular = props['type'] == 'circular';
      final determinate = props['determinate'] == true;
      final value = (props['value'] as num).toDouble();
      final strokeWidth = (props['strokeWidth'] as num).toDouble();
      final colorName = props['color'] as String;

      final buf = StringBuffer();
      if (isCircular) {
        buf.writeln("CircularProgressIndicator(");
        if (determinate) buf.writeln("  value: ${_fmt(value)},");
        buf.writeln("  strokeWidth: ${_fmt(strokeWidth)},");
        buf.writeln("  color: ${_colorToCode(colorName)},");
      } else {
        buf.writeln("LinearProgressIndicator(");
        if (determinate) buf.writeln("  value: ${_fmt(value)},");
        buf.writeln("  minHeight: ${_fmt(strokeWidth)},");
        buf.writeln("  color: ${_colorToCode(colorName)},");
      }
      buf.write(")");
      return buf.toString();
    },
  );
}

// ---------------------------------------------------------------------------
// TextField
// ---------------------------------------------------------------------------
WidgetDemo _textFieldDemo() {
  return WidgetDemo(
    id: 'text_field',
    displayName: 'TextField',
    icon: Icons.edit,
    category: 'Input',
    description: 'A Material text input field.',
    properties: const [
      PropertySchema(name: 'label', label: 'Label', type: PropertyType.string, defaultValue: 'Email'),
      PropertySchema(name: 'hint', label: 'Hint', type: PropertyType.string, defaultValue: 'Enter your email'),
      PropertySchema(name: 'prefixIcon', label: 'Prefix Icon', type: PropertyType.bool, defaultValue: true),
      PropertySchema(
        name: 'border',
        label: 'Border Style',
        type: PropertyType.enumChoice,
        defaultValue: 'outline',
        options: ['outline', 'underline', 'none'],
      ),
      PropertySchema(name: 'filled', label: 'Filled', type: PropertyType.bool, defaultValue: false),
      PropertySchema(name: 'enabled', label: 'Enabled', type: PropertyType.bool, defaultValue: true),
    ],
    previewBuilder: (props) {
      final border = props['border'] as String;
      final filled = props['filled'] == true;
      final enabled = props['enabled'] == true;
      final prefixIcon = props['prefixIcon'] == true;

      InputBorder inputBorder;
      switch (border) {
        case 'underline':
          inputBorder = const UnderlineInputBorder();
        case 'none':
          inputBorder = InputBorder.none;
        default:
          inputBorder = OutlineInputBorder(borderRadius: BorderRadius.circular(8));
      }

      return SizedBox(
        width: 280,
        child: TextField(
          enabled: enabled,
          decoration: InputDecoration(
            labelText: props['label'] as String,
            hintText: props['hint'] as String,
            prefixIcon: prefixIcon ? const Icon(Icons.email) : null,
            border: inputBorder,
            filled: filled,
          ),
        ),
      );
    },
    sourceGenerator: (props) {
      final label = (props['label'] as String).replaceAll("'", "\\'");
      final hint = (props['hint'] as String).replaceAll("'", "\\'");
      final border = props['border'] as String;
      final filled = props['filled'] == true;
      final enabled = props['enabled'] == true;
      final prefixIcon = props['prefixIcon'] == true;

      final buf = StringBuffer();
      buf.writeln("TextField(");
      if (!enabled) buf.writeln("  enabled: false,");
      buf.writeln("  decoration: InputDecoration(");
      buf.writeln("    labelText: '$label',");
      buf.writeln("    hintText: '$hint',");
      if (prefixIcon) buf.writeln("    prefixIcon: const Icon(Icons.email),");
      switch (border) {
        case 'underline':
          buf.writeln("    border: const UnderlineInputBorder(),");
        case 'none':
          buf.writeln("    border: InputBorder.none,");
        default:
          buf.writeln("    border: OutlineInputBorder(");
          buf.writeln("      borderRadius: BorderRadius.circular(8),");
          buf.writeln("    ),");
      }
      if (filled) buf.writeln("    filled: true,");
      buf.writeln("  ),");
      buf.write(")");
      return buf.toString();
    },
  );
}

// ---------------------------------------------------------------------------
// Switch
// ---------------------------------------------------------------------------
WidgetDemo _switchDemo() {
  return WidgetDemo(
    id: 'switch_widget',
    displayName: 'Switch',
    icon: Icons.toggle_on_outlined,
    category: 'Input',
    description: 'A Material on/off toggle switch.',
    properties: const [
      PropertySchema(name: 'value', label: 'Value', type: PropertyType.bool, defaultValue: true),
      PropertySchema(name: 'showLabel', label: 'Show Label', type: PropertyType.bool, defaultValue: true),
      PropertySchema(name: 'label', label: 'Label', type: PropertyType.string, defaultValue: 'Enable notifications'),
      PropertySchema(
        name: 'color',
        label: 'Active Color',
        type: PropertyType.enumChoice,
        defaultValue: 'Blue',
        options: ['Blue', 'Red', 'Green', 'Orange', 'Purple', 'Teal', 'Indigo'],
      ),
    ],
    previewBuilder: (props) {
      final value = props['value'] == true;
      final showLabel = props['showLabel'] == true;
      final color = presetColors[props['color']] ?? Colors.blue;

      if (showLabel) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(props['label'] as String, style: const TextStyle(fontSize: 14)),
            const SizedBox(width: 12),
            Switch(value: value, onChanged: (_) {}, activeColor: color),
          ],
        );
      }
      return Switch(value: value, onChanged: (_) {}, activeColor: color);
    },
    sourceGenerator: (props) {
      final value = props['value'] == true;
      final colorName = props['color'] as String;

      final buf = StringBuffer();
      buf.writeln("Switch(");
      buf.writeln("  value: $value,");
      buf.writeln("  onChanged: (bool newValue) {");
      buf.writeln("    setState(() => _value = newValue);");
      buf.writeln("  },");
      if (colorName != 'Blue') buf.writeln("  activeColor: ${_colorToCode(colorName)},");
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
