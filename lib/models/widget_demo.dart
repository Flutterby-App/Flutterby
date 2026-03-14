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

/// A demo widget entry in the explorer.
class WidgetDemo {
  final String id;
  final String displayName;
  final IconData icon;
  final String category;
  final List<PropertySchema> properties;
  final Widget Function(Map<String, dynamic> props) previewBuilder;
  final String Function(Map<String, dynamic> props) sourceGenerator;

  const WidgetDemo({
    required this.id,
    required this.displayName,
    required this.icon,
    this.category = 'Layout',
    required this.properties,
    required this.previewBuilder,
    required this.sourceGenerator,
  });

  /// Returns a map of property name → default value.
  Map<String, dynamic> defaultValues() {
    return {for (final p in properties) p.name: p.defaultValue};
  }
}
