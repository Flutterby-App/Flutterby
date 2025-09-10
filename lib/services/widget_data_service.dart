import '../models/widget_category.dart';
import '../models/flutter_widget.dart';
import '../data/widget_samples.dart';
import 'package:flutter/material.dart';

class WidgetDataService {
  static final List<WidgetCategory> categories = [
    const WidgetCategory(
      id: 'layout',
      name: 'Layout',
      description: 'Widgets for arranging other widgets',
      icon: Icons.dashboard,
      subcategories: ['Single-child', 'Multi-child', 'Sliver'],
    ),
    const WidgetCategory(
      id: 'input',
      name: 'Input',
      description: 'Widgets for user input',
      icon: Icons.keyboard,
      subcategories: ['Text Input', 'Selection', 'Buttons'],
    ),
    const WidgetCategory(
      id: 'display',
      name: 'Display',
      description: 'Widgets for displaying information',
      icon: Icons.visibility,
      subcategories: ['Text', 'Images', 'Icons'],
    ),
    const WidgetCategory(
      id: 'navigation',
      name: 'Navigation',
      description: 'Widgets for navigation and routing',
      icon: Icons.navigation,
      subcategories: ['App Structure', 'Route Management'],
    ),
    const WidgetCategory(
      id: 'material',
      name: 'Material',
      description: 'Material Design widgets',
      icon: Icons.android,
      subcategories: ['Containers', 'Controls', 'Indicators'],
    ),
    const WidgetCategory(
      id: 'cupertino',
      name: 'Cupertino',
      description: 'iOS-style widgets',
      icon: Icons.phone_iphone,
      subcategories: ['Controls', 'Containers', 'Indicators'],
    ),
    const WidgetCategory(
      id: 'animation',
      name: 'Animation',
      description: 'Widgets for animations and transitions',
      icon: Icons.animation,
      subcategories: ['Implicit', 'Explicit', 'Transitions'],
    ),
    const WidgetCategory(
      id: 'styling',
      name: 'Styling',
      description: 'Widgets for styling and theming',
      icon: Icons.palette,
      subcategories: ['Decoration', 'Themes', 'Effects'],
    ),
  ];

  static final List<FlutterWidget> widgets = [
    // Layout Widgets
    const FlutterWidget(
      id: 'container',
      name: 'Container',
      categoryId: 'layout',
      subcategory: 'Single-child',
      description: 'A convenience widget that combines common painting, positioning, and sizing widgets.',
      documentation: '''Container is a convenience widget that combines common painting, positioning, and sizing widgets.
      
A container first surrounds the child with padding (inflated by any borders present in the decoration) and then applies additional constraints to the padded extent (incorporating the width and height as constraints, if either is non-null).

The container is then surrounded by additional empty space described from the margin.''',
      exampleCode: '''Container(
  width: 200,
  height: 200,
  padding: EdgeInsets.all(16),
  margin: EdgeInsets.all(8),
  decoration: BoxDecoration(
    color: Colors.blue,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.5),
        spreadRadius: 5,
        blurRadius: 7,
        offset: Offset(0, 3),
      ),
    ],
  ),
  child: Text(
    'Hello Container!',
    style: TextStyle(color: Colors.white),
  ),
)''',
      properties: [
        WidgetProperty(
          name: 'child',
          type: 'Widget?',
          description: 'The widget below this widget in the tree',
        ),
        WidgetProperty(
          name: 'padding',
          type: 'EdgeInsetsGeometry?',
          description: 'Empty space to inscribe inside the decoration',
        ),
        WidgetProperty(
          name: 'color',
          type: 'Color?',
          description: 'The color to paint behind the child',
        ),
        WidgetProperty(
          name: 'decoration',
          type: 'Decoration?',
          description: 'The decoration to paint behind the child',
        ),
        WidgetProperty(
          name: 'width',
          type: 'double?',
          description: 'The width of the container',
        ),
        WidgetProperty(
          name: 'height',
          type: 'double?',
          description: 'The height of the container',
        ),
        WidgetProperty(
          name: 'margin',
          type: 'EdgeInsetsGeometry?',
          description: 'Empty space to surround the decoration and child',
        ),
      ],
      relatedWidgets: ['Padding', 'Center', 'Align', 'SizedBox'],
    ),
    const FlutterWidget(
      id: 'row',
      name: 'Row',
      categoryId: 'layout',
      subcategory: 'Multi-child',
      description: 'A widget that displays its children in a horizontal array.',
      documentation: '''Row is a widget that displays its children in a horizontal array.
      
To cause a child to expand to fill the available horizontal space, wrap the child in an Expanded widget.

The Row widget does not scroll. If you have a line of widgets and want them to be able to scroll if there is insufficient room, consider using a ListView.''',
      exampleCode: '''Row(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  children: <Widget>[
    Icon(Icons.star, size: 50),
    Icon(Icons.star, size: 50),
    Icon(Icons.star, size: 50),
  ],
)''',
      properties: [
        WidgetProperty(
          name: 'children',
          type: 'List<Widget>',
          description: 'The widgets below this widget in the tree',
          isRequired: true,
        ),
        WidgetProperty(
          name: 'mainAxisAlignment',
          type: 'MainAxisAlignment',
          description: 'How the children should be placed along the main axis',
          defaultValue: 'MainAxisAlignment.start',
        ),
        WidgetProperty(
          name: 'crossAxisAlignment',
          type: 'CrossAxisAlignment',
          description: 'How the children should be placed along the cross axis',
          defaultValue: 'CrossAxisAlignment.center',
        ),
      ],
      relatedWidgets: ['Column', 'Stack', 'Wrap', 'ListView'],
    ),
    const FlutterWidget(
      id: 'column',
      name: 'Column',
      categoryId: 'layout',
      subcategory: 'Multi-child',
      description: 'A widget that displays its children in a vertical array.',
      documentation: '''Column is a widget that displays its children in a vertical array.
      
To cause a child to expand to fill the available vertical space, wrap the child in an Expanded widget.

The Column widget does not scroll. If you have a column of widgets and want them to be able to scroll if there is insufficient room, consider using a ListView.''',
      exampleCode: '''Column(
  mainAxisAlignment: MainAxisAlignment.center,
  crossAxisAlignment: CrossAxisAlignment.start,
  children: <Widget>[
    Text('First item'),
    Text('Second item'),
    Text('Third item'),
  ],
)''',
      properties: [
        WidgetProperty(
          name: 'children',
          type: 'List<Widget>',
          description: 'The widgets below this widget in the tree',
          isRequired: true,
        ),
        WidgetProperty(
          name: 'mainAxisAlignment',
          type: 'MainAxisAlignment',
          description: 'How the children should be placed along the main axis',
          defaultValue: 'MainAxisAlignment.start',
        ),
        WidgetProperty(
          name: 'crossAxisAlignment',
          type: 'CrossAxisAlignment',
          description: 'How the children should be placed along the cross axis',
          defaultValue: 'CrossAxisAlignment.center',
        ),
      ],
      relatedWidgets: ['Row', 'Stack', 'Wrap', 'ListView'],
    ),
    
    // Input Widgets
    const FlutterWidget(
      id: 'textfield',
      name: 'TextField',
      categoryId: 'input',
      subcategory: 'Text Input',
      description: 'A text input field that allows users to enter text.',
      documentation: '''TextField is a Material Design text field that lets users enter text via a keyboard.
      
Text fields allow users to type text into an app. They are used to build forms, messaging, search experiences, and more.''',
      exampleCode: '''TextField(
  decoration: InputDecoration(
    border: OutlineInputBorder(),
    labelText: 'Enter your name',
    hintText: 'John Doe',
    prefixIcon: Icon(Icons.person),
  ),
  onChanged: (text) {
    print('Text changed: \$text');
  },
)''',
      properties: [
        WidgetProperty(
          name: 'controller',
          type: 'TextEditingController?',
          description: 'Controls the text being edited',
        ),
        WidgetProperty(
          name: 'decoration',
          type: 'InputDecoration?',
          description: 'The decoration to show around the text field',
        ),
        WidgetProperty(
          name: 'onChanged',
          type: 'ValueChanged<String>?',
          description: 'Called when the user changes the text',
        ),
      ],
      relatedWidgets: ['TextFormField', 'CupertinoTextField'],
      isMaterial: true,
    ),
    const FlutterWidget(
      id: 'elevatedbutton',
      name: 'ElevatedButton',
      categoryId: 'input',
      subcategory: 'Buttons',
      description: 'A Material Design elevated button.',
      documentation: '''ElevatedButton is a Material Design elevated button. 
      
Elevated buttons are high-emphasis buttons that are used for primary actions. They add dimension to mostly flat layouts.''',
      exampleCode: '''ElevatedButton(
  onPressed: () {
    print('Button pressed!');
  },
  child: Text('Click Me'),
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.blue,
    foregroundColor: Colors.white,
    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  ),
)''',
      properties: [
        WidgetProperty(
          name: 'onPressed',
          type: 'VoidCallback?',
          description: 'Called when the button is tapped',
          isRequired: true,
        ),
        WidgetProperty(
          name: 'child',
          type: 'Widget?',
          description: 'The button\'s label',
          isRequired: true,
        ),
        WidgetProperty(
          name: 'style',
          type: 'ButtonStyle?',
          description: 'Defines the button\'s visual properties',
        ),
      ],
      relatedWidgets: ['TextButton', 'OutlinedButton', 'IconButton'],
      isMaterial: true,
    ),
    
    // Display Widgets
    const FlutterWidget(
      id: 'text',
      name: 'Text',
      categoryId: 'display',
      subcategory: 'Text',
      description: 'A widget that displays a string of text with single style.',
      documentation: '''The Text widget displays a string of text with single style.
      
The string might break across multiple lines or might all be displayed on the same line depending on the layout constraints.''',
      exampleCode: '''Text(
  'Hello, Flutter!',
  style: TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.blue,
  ),
  textAlign: TextAlign.center,
  overflow: TextOverflow.ellipsis,
  maxLines: 2,
)''',
      properties: [
        WidgetProperty(
          name: 'data',
          type: 'String',
          description: 'The text to display',
          isRequired: true,
        ),
        WidgetProperty(
          name: 'style',
          type: 'TextStyle?',
          description: 'The style to use for the text',
        ),
        WidgetProperty(
          name: 'textAlign',
          type: 'TextAlign?',
          description: 'How the text should be aligned horizontally',
        ),
      ],
      relatedWidgets: ['RichText', 'SelectableText', 'DefaultTextStyle'],
    ),
    const FlutterWidget(
      id: 'image',
      name: 'Image',
      categoryId: 'display',
      subcategory: 'Images',
      description: 'A widget that displays an image.',
      documentation: '''The Image widget displays an image.
      
Several constructors are provided for common ways to reference an image:
- Image.asset for images from the asset bundle
- Image.network for images from the internet
- Image.file for images from the file system
- Image.memory for images from memory''',
      exampleCode: '''Image.network(
  'https://flutter.dev/images/flutter-logo-sharing.png',
  width: 200,
  height: 200,
  fit: BoxFit.cover,
  loadingBuilder: (context, child, loadingProgress) {
    if (loadingProgress == null) return child;
    return Center(
      child: CircularProgressIndicator(
        value: loadingProgress.expectedTotalBytes != null
            ? loadingProgress.cumulativeBytesLoaded /
                loadingProgress.expectedTotalBytes!
            : null,
      ),
    );
  },
)''',
      properties: [
        WidgetProperty(
          name: 'image',
          type: 'ImageProvider',
          description: 'The image to display',
          isRequired: true,
        ),
        WidgetProperty(
          name: 'width',
          type: 'double?',
          description: 'The width of the image',
        ),
        WidgetProperty(
          name: 'height',
          type: 'double?',
          description: 'The height of the image',
        ),
        WidgetProperty(
          name: 'fit',
          type: 'BoxFit?',
          description: 'How to inscribe the image into the allocated space',
        ),
      ],
      relatedWidgets: ['Icon', 'CircleAvatar', 'FadeInImage'],
    ),
    ...WidgetSamples.additionalWidgets,
  ];

  static List<FlutterWidget> getWidgetsByCategory(String categoryId) {
    return widgets.where((widget) => widget.categoryId == categoryId).toList();
  }

  static List<FlutterWidget> searchWidgets(String query) {
    final lowercaseQuery = query.toLowerCase();
    return widgets.where((widget) {
      return widget.name.toLowerCase().contains(lowercaseQuery) ||
          widget.description.toLowerCase().contains(lowercaseQuery) ||
          widget.categoryId.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  static FlutterWidget? getWidgetById(String id) {
    try {
      return widgets.firstWhere((widget) => widget.id == id);
    } catch (e) {
      return null;
    }
  }

  static WidgetCategory? getCategoryById(String id) {
    try {
      return categories.firstWhere((category) => category.id == id);
    } catch (e) {
      return null;
    }
  }
}