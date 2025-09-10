class FlutterWidget {
  final String id;
  final String name;
  final String categoryId;
  final String subcategory;
  final String description;
  final String documentation;
  final String exampleCode;
  final List<WidgetProperty> properties;
  final List<String> relatedWidgets;
  final bool isMaterial;
  final bool isCupertino;

  const FlutterWidget({
    required this.id,
    required this.name,
    required this.categoryId,
    this.subcategory = '',
    required this.description,
    required this.documentation,
    required this.exampleCode,
    this.properties = const [],
    this.relatedWidgets = const [],
    this.isMaterial = true,
    this.isCupertino = false,
  });
}

class WidgetProperty {
  final String name;
  final String type;
  final String description;
  final bool isRequired;
  final String? defaultValue;

  const WidgetProperty({
    required this.name,
    required this.type,
    required this.description,
    this.isRequired = false,
    this.defaultValue,
  });
}