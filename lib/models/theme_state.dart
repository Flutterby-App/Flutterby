import 'package:flutter/material.dart';

class ThemeState {
  final Color seedColor;
  final Brightness brightness;

  const ThemeState({
    this.seedColor = Colors.indigo,
    this.brightness = Brightness.light,
  });

  ThemeState copyWith({Color? seedColor, Brightness? brightness}) {
    return ThemeState(
      seedColor: seedColor ?? this.seedColor,
      brightness: brightness ?? this.brightness,
    );
  }

  ColorScheme get colorScheme =>
      ColorScheme.fromSeed(seedColor: seedColor, brightness: brightness);
}
