import 'package:flutter/material.dart';

/// Describes the type of a property for the editor UI.
enum PropertyType {
  string,
  double,
  bool,
  enumChoice,
  color,
  int,
}

/// Schema for a single editable property.
class PropertySchema {
  final String name;
  final String label;
  final PropertyType type;
  final dynamic defaultValue;

  /// For enum properties: list of allowed string values.
  final List<String>? options;

  /// For double/int properties.
  final double? min;
  final double? max;

  const PropertySchema({
    required this.name,
    required this.label,
    required this.type,
    required this.defaultValue,
    this.options,
    this.min,
    this.max,
  });
}

/// A property reference entry for the Docs tab (name, type, required, default).
class WidgetPropertyRef {
  final String name;
  final String type;
  final String description;
  final bool isRequired;
  final String? defaultValue;

  const WidgetPropertyRef({
    required this.name,
    required this.type,
    required this.description,
    this.isRequired = false,
    this.defaultValue,
  });
}

/// A demo widget entry in the explorer.
class WidgetDemo {
  final String id;
  final String displayName;
  final IconData icon;
  final String category;
  final String description;
  final List<PropertySchema> properties;
  final Widget Function(Map<String, dynamic> props) previewBuilder;
  final String Function(Map<String, dynamic> props) sourceGenerator;

  /// Extended documentation shown in the Docs tab.
  final String? documentation;

  /// Full property reference table for the Docs tab.
  final List<WidgetPropertyRef>? propertyReference;

  /// IDs of related widgets (tappable chips in Docs tab).
  final List<String>? relatedWidgetIds;

  /// Whether this is a Material Design widget.
  final bool isMaterial;

  /// Whether this is a Cupertino (iOS-style) widget.
  final bool isCupertino;

  const WidgetDemo({
    required this.id,
    required this.displayName,
    required this.icon,
    this.category = 'Layout',
    this.description = '',
    required this.properties,
    required this.previewBuilder,
    required this.sourceGenerator,
    this.documentation,
    this.propertyReference,
    this.relatedWidgetIds,
    this.isMaterial = true,
    this.isCupertino = false,
  });

  /// Returns a map of property name → default value.
  Map<String, dynamic> defaultValues() {
    return {for (final p in properties) p.name: p.defaultValue};
  }
}
