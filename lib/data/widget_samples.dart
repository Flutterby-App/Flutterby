import '../models/flutter_widget.dart';

class WidgetSamples {
  static const List<FlutterWidget> additionalWidgets = [
    // More Layout Widgets
    FlutterWidget(
      id: 'stack',
      name: 'Stack',
      categoryId: 'layout',
      subcategory: 'Multi-child',
      description: 'A widget that positions its children relative to the edges of its box.',
      documentation: '''Stack allows you to overlay multiple children widgets.
      
This class is useful if you want to overlap several children in a simple way, for example having some text and an image, overlaid with a gradient and a button attached to the bottom.''',
      exampleCode: '''Stack(
  children: <Widget>[
    Container(
      width: 200,
      height: 200,
      color: Colors.red,
    ),
    Container(
      width: 150,
      height: 150,
      color: Colors.green,
    ),
    Container(
      width: 100,
      height: 100,
      color: Colors.blue,
    ),
  ],
)''',
      properties: [
        WidgetProperty(
          name: 'children',
          type: 'List<Widget>',
          description: 'The widgets to display in the stack',
          isRequired: true,
        ),
        WidgetProperty(
          name: 'alignment',
          type: 'AlignmentGeometry',
          description: 'How to align the non-positioned children',
          defaultValue: 'AlignmentDirectional.topStart',
        ),
      ],
      relatedWidgets: ['Positioned', 'Row', 'Column'],
    ),
    FlutterWidget(
      id: 'expanded',
      name: 'Expanded',
      categoryId: 'layout',
      subcategory: 'Single-child',
      description: 'Expands a child of a Row, Column, or Flex to fill available space.',
      documentation: '''Using an Expanded widget makes a child of a Row, Column, or Flex expand to fill the available space along the main axis.
      
If multiple children are expanded, the available space is divided among them according to the flex factor.''',
      exampleCode: '''Row(
  children: <Widget>[
    Container(
      color: Colors.red,
      height: 100,
      width: 100,
    ),
    Expanded(
      flex: 2,
      child: Container(
        color: Colors.blue,
        height: 100,
      ),
    ),
    Expanded(
      flex: 1,
      child: Container(
        color: Colors.green,
        height: 100,
      ),
    ),
  ],
)''',
      properties: [
        WidgetProperty(
          name: 'child',
          type: 'Widget',
          description: 'The widget to expand',
          isRequired: true,
        ),
        WidgetProperty(
          name: 'flex',
          type: 'int',
          description: 'The flex factor for this child',
          defaultValue: '1',
        ),
      ],
      relatedWidgets: ['Flexible', 'Row', 'Column'],
    ),
    FlutterWidget(
      id: 'wrap',
      name: 'Wrap',
      categoryId: 'layout',
      subcategory: 'Multi-child',
      description: 'A widget that displays its children in multiple horizontal or vertical runs.',
      documentation: '''A Wrap lays out each child and attempts to place the child adjacent to the previous child in the main axis, given by direction, leaving spacing space in between.
      
If there is not enough space to fit the child, Wrap creates a new run adjacent to the existing children in the cross axis.''',
      exampleCode: '''Wrap(
  spacing: 8.0, // gap between adjacent chips
  runSpacing: 4.0, // gap between lines
  children: <Widget>[
    Chip(label: Text('Hamilton')),
    Chip(label: Text('Lafayette')),
    Chip(label: Text('Mulligan')),
    Chip(label: Text('Laurens')),
  ],
)''',
      properties: [
        WidgetProperty(
          name: 'children',
          type: 'List<Widget>',
          description: 'The widgets to display',
          isRequired: true,
        ),
        WidgetProperty(
          name: 'spacing',
          type: 'double',
          description: 'Gap between adjacent children',
          defaultValue: '0.0',
        ),
        WidgetProperty(
          name: 'runSpacing',
          type: 'double',
          description: 'Gap between runs',
          defaultValue: '0.0',
        ),
      ],
      relatedWidgets: ['Row', 'Column', 'Flow'],
    ),
    
    // More Input Widgets
    FlutterWidget(
      id: 'checkbox',
      name: 'Checkbox',
      categoryId: 'input',
      subcategory: 'Selection',
      description: 'A Material Design checkbox.',
      documentation: '''A checkbox is a type of input component which holds the boolean value.
      
It is a GUI element that allows the user to choose multiple options from several selections.''',
      exampleCode: '''bool isChecked = false;

Checkbox(
  value: isChecked,
  onChanged: (bool? value) {
    setState(() {
      isChecked = value!;
    });
  },
)''',
      properties: [
        WidgetProperty(
          name: 'value',
          type: 'bool',
          description: 'Whether this checkbox is checked',
          isRequired: true,
        ),
        WidgetProperty(
          name: 'onChanged',
          type: 'ValueChanged<bool?>?',
          description: 'Called when the value changes',
          isRequired: true,
        ),
      ],
      relatedWidgets: ['Switch', 'Radio', 'CheckboxListTile'],
      isMaterial: true,
    ),
    FlutterWidget(
      id: 'switch',
      name: 'Switch',
      categoryId: 'input',
      subcategory: 'Selection',
      description: 'A Material Design switch.',
      documentation: '''A switch is a two-state user interface element used to toggle between ON (Checked) or OFF (Unchecked) states.
      
Typically, it is a button with a thumb slider where the user can drag back and forth to choose an option.''',
      exampleCode: '''bool isSwitched = false;

Switch(
  value: isSwitched,
  onChanged: (bool value) {
    setState(() {
      isSwitched = value;
    });
  },
  activeColor: Colors.green,
)''',
      properties: [
        WidgetProperty(
          name: 'value',
          type: 'bool',
          description: 'Whether this switch is on',
          isRequired: true,
        ),
        WidgetProperty(
          name: 'onChanged',
          type: 'ValueChanged<bool>?',
          description: 'Called when the user toggles the switch',
          isRequired: true,
        ),
      ],
      relatedWidgets: ['Checkbox', 'Radio', 'SwitchListTile'],
      isMaterial: true,
    ),
    FlutterWidget(
      id: 'slider',
      name: 'Slider',
      categoryId: 'input',
      subcategory: 'Selection',
      description: 'A Material Design slider for selecting from a range of values.',
      documentation: '''A slider can be used to select from either a continuous or a discrete set of values.
      
The default is to use a continuous range of values from min to max.''',
      exampleCode: '''double _currentSliderValue = 20;

Slider(
  value: _currentSliderValue,
  max: 100,
  divisions: 5,
  label: _currentSliderValue.round().toString(),
  onChanged: (double value) {
    setState(() {
      _currentSliderValue = value;
    });
  },
)''',
      properties: [
        WidgetProperty(
          name: 'value',
          type: 'double',
          description: 'The current value of the slider',
          isRequired: true,
        ),
        WidgetProperty(
          name: 'onChanged',
          type: 'ValueChanged<double>?',
          description: 'Called when the user changes the slider value',
          isRequired: true,
        ),
        WidgetProperty(
          name: 'min',
          type: 'double',
          description: 'The minimum value',
          defaultValue: '0.0',
        ),
        WidgetProperty(
          name: 'max',
          type: 'double',
          description: 'The maximum value',
          defaultValue: '1.0',
        ),
      ],
      relatedWidgets: ['RangeSlider', 'CupertinoSlider'],
      isMaterial: true,
    ),
    
    // Navigation Widgets
    FlutterWidget(
      id: 'appbar',
      name: 'AppBar',
      categoryId: 'navigation',
      subcategory: 'App Structure',
      description: 'A Material Design app bar with title, actions, and navigation.',
      documentation: '''An app bar consists of a toolbar and potentially other widgets, such as a TabBar and a FlexibleSpaceBar.
      
App bars typically expose one or more common actions with IconButtons which are optionally followed by a PopupMenuButton for less common operations.''',
      exampleCode: '''AppBar(
  title: Text('My App'),
  leading: IconButton(
    icon: Icon(Icons.menu),
    onPressed: () {},
  ),
  actions: <Widget>[
    IconButton(
      icon: Icon(Icons.search),
      onPressed: () {},
    ),
    IconButton(
      icon: Icon(Icons.more_vert),
      onPressed: () {},
    ),
  ],
  backgroundColor: Colors.blue,
  elevation: 4,
)''',
      properties: [
        WidgetProperty(
          name: 'title',
          type: 'Widget?',
          description: 'The primary widget displayed in the app bar',
        ),
        WidgetProperty(
          name: 'leading',
          type: 'Widget?',
          description: 'Widget to display before the title',
        ),
        WidgetProperty(
          name: 'actions',
          type: 'List<Widget>?',
          description: 'Widgets to display after the title',
        ),
      ],
      relatedWidgets: ['Scaffold', 'BottomNavigationBar', 'TabBar'],
      isMaterial: true,
    ),
    FlutterWidget(
      id: 'bottomnavbar',
      name: 'BottomNavigationBar',
      categoryId: 'navigation',
      subcategory: 'App Structure',
      description: 'A Material Design bottom navigation bar.',
      documentation: '''A bottom navigation bar is usually used in conjunction with a Scaffold, where it is provided as the Scaffold.bottomNavigationBar argument.
      
The bottom navigation bar consists of multiple items in the form of text labels, icons, or both, laid out on top of a piece of material.''',
      exampleCode: '''int _selectedIndex = 0;

BottomNavigationBar(
  items: const <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.business),
      label: 'Business',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.school),
      label: 'School',
    ),
  ],
  currentIndex: _selectedIndex,
  selectedItemColor: Colors.amber[800],
  onTap: (int index) {
    setState(() {
      _selectedIndex = index;
    });
  },
)''',
      properties: [
        WidgetProperty(
          name: 'items',
          type: 'List<BottomNavigationBarItem>',
          description: 'The items to display',
          isRequired: true,
        ),
        WidgetProperty(
          name: 'currentIndex',
          type: 'int',
          description: 'The index of the selected item',
          defaultValue: '0',
        ),
        WidgetProperty(
          name: 'onTap',
          type: 'ValueChanged<int>?',
          description: 'Called when an item is tapped',
        ),
      ],
      relatedWidgets: ['NavigationBar', 'NavigationRail', 'TabBar'],
      isMaterial: true,
    ),
    
    // Display Widgets
    FlutterWidget(
      id: 'icon',
      name: 'Icon',
      categoryId: 'display',
      subcategory: 'Icons',
      description: 'A Material Design icon.',
      documentation: '''A graphical icon widget drawn with a glyph from a font described in an IconData such as material's predefined IconDatas in Icons.
      
Icons are not interactive. For an interactive icon, consider using IconButton.''',
      exampleCode: '''Icon(
  Icons.favorite,
  color: Colors.pink,
  size: 24.0,
  semanticLabel: 'Favorite',
)''',
      properties: [
        WidgetProperty(
          name: 'icon',
          type: 'IconData',
          description: 'The icon to display',
          isRequired: true,
        ),
        WidgetProperty(
          name: 'size',
          type: 'double?',
          description: 'The size of the icon',
        ),
        WidgetProperty(
          name: 'color',
          type: 'Color?',
          description: 'The color of the icon',
        ),
      ],
      relatedWidgets: ['IconButton', 'ImageIcon', 'Icons'],
    ),
    FlutterWidget(
      id: 'card',
      name: 'Card',
      categoryId: 'material',
      subcategory: 'Containers',
      description: 'A Material Design card with elevation and rounded corners.',
      documentation: '''A card is a sheet of Material used to represent some related information, for example an album, a geographical location, a meal, contact details, etc.
      
Cards are most commonly used to present a collection of similar items in a way that is easy for users to scan.''',
      exampleCode: '''Card(
  elevation: 4,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
  ),
  child: Padding(
    padding: EdgeInsets.all(16),
    child: Column(
      children: [
        Text('Card Title', style: TextStyle(fontSize: 20)),
        SizedBox(height: 8),
        Text('Card content goes here'),
      ],
    ),
  ),
)''',
      properties: [
        WidgetProperty(
          name: 'child',
          type: 'Widget?',
          description: 'The widget below this widget in the tree',
        ),
        WidgetProperty(
          name: 'elevation',
          type: 'double?',
          description: 'The z-coordinate of the card',
        ),
        WidgetProperty(
          name: 'shape',
          type: 'ShapeBorder?',
          description: 'The shape of the card',
        ),
      ],
      relatedWidgets: ['Container', 'Material', 'ListTile'],
      isMaterial: true,
    ),
    
    // Animation Widgets
    FlutterWidget(
      id: 'animatedcontainer',
      name: 'AnimatedContainer',
      categoryId: 'animation',
      subcategory: 'Implicit',
      description: 'Animated version of Container that gradually changes its values.',
      documentation: '''The AnimatedContainer will automatically animate between the old and new values of properties when they change using the provided curve and duration.
      
Properties that are null are not animated. Its child and descendants are not animated.''',
      exampleCode: '''bool selected = false;

AnimatedContainer(
  width: selected ? 200.0 : 100.0,
  height: selected ? 100.0 : 200.0,
  color: selected ? Colors.red : Colors.blue,
  alignment: selected ? Alignment.center : AlignmentDirectional.topCenter,
  duration: Duration(seconds: 2),
  curve: Curves.fastOutSlowIn,
  child: Text('Tap me!'),
)''',
      properties: [
        WidgetProperty(
          name: 'duration',
          type: 'Duration',
          description: 'The duration of the animation',
          isRequired: true,
        ),
        WidgetProperty(
          name: 'curve',
          type: 'Curve',
          description: 'The curve to apply to the animation',
          defaultValue: 'Curves.linear',
        ),
      ],
      relatedWidgets: ['Container', 'AnimatedOpacity', 'AnimatedPadding'],
    ),
  ];
}