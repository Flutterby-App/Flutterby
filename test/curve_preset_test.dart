import 'package:flutter_test/flutter_test.dart';
import 'package:flutterby/models/curve_preset.dart';

void main() {
  group('curvePresets', () {
    test('contains known presets', () {
      expect(curvePresets.any((p) => p.name == 'linear'), isTrue);
      expect(curvePresets.any((p) => p.name == 'ease'), isTrue);
      expect(curvePresets.any((p) => p.name == 'easeInOut'), isTrue);
    });

    test('findMatchingPreset matches ease', () {
      final result = findMatchingPreset(0.25, 0.1, 0.25, 1.0);
      expect(result, isNotNull);
      expect(result!.name, 'ease');
    });

    test('findMatchingPreset matches linear', () {
      final result = findMatchingPreset(0.0, 0.0, 1.0, 1.0);
      expect(result, isNotNull);
      expect(result!.name, 'linear');
    });

    test('findMatchingPreset returns null for custom curve', () {
      final result = findMatchingPreset(0.1, 0.9, 0.9, 0.1);
      expect(result, isNull);
    });
  });
}
