import 'package:flutter_test/flutter_test.dart';
import 'package:flutterby/models/property_interpolator.dart';
import 'package:flutterby/models/widget_demo.dart';

void main() {
  group('interpolateProperties', () {
    final schemas = [
      const PropertySchema(name: 'width', label: 'Width', type: PropertyType.double, defaultValue: 100.0),
      const PropertySchema(name: 'count', label: 'Count', type: PropertyType.int, defaultValue: 3),
      const PropertySchema(name: 'enabled', label: 'Enabled', type: PropertyType.bool, defaultValue: true),
      const PropertySchema(name: 'color', label: 'Color', type: PropertyType.enumChoice, defaultValue: 'Blue', options: ['Blue', 'Red']),
    ];

    test('t=0 returns snapshot A values', () {
      final a = {'width': 100.0, 'count': 2, 'enabled': true, 'color': 'Blue'};
      final b = {'width': 200.0, 'count': 8, 'enabled': false, 'color': 'Red'};
      final result = interpolateProperties(a, b, 0.0, schemas);

      expect(result['width'], 100.0);
      expect(result['count'], 2);
      expect(result['enabled'], true);
      expect(result['color'], 'Blue');
    });

    test('t=1 returns snapshot B values', () {
      final a = {'width': 100.0, 'count': 2, 'enabled': true, 'color': 'Blue'};
      final b = {'width': 200.0, 'count': 8, 'enabled': false, 'color': 'Red'};
      final result = interpolateProperties(a, b, 1.0, schemas);

      expect(result['width'], 200.0);
      expect(result['count'], 8);
      expect(result['enabled'], false);
      expect(result['color'], 'Red');
    });

    test('t=0.5 interpolates numeric values and snaps discrete', () {
      final a = {'width': 100.0, 'count': 2, 'enabled': true, 'color': 'Blue'};
      final b = {'width': 200.0, 'count': 8, 'enabled': false, 'color': 'Red'};
      final result = interpolateProperties(a, b, 0.5, schemas);

      expect(result['width'], closeTo(150.0, 0.01));
      expect(result['count'], 5); // lerp(2,8,0.5)=5
      expect(result['enabled'], false); // t < 0.5 is false at 0.5 → B
      expect(result['color'], 'Red'); // t < 0.5 is false at 0.5 → B
    });

    test('t=0.75 snaps discrete to B', () {
      final a = {'width': 100.0, 'count': 2, 'enabled': true, 'color': 'Blue'};
      final b = {'width': 200.0, 'count': 8, 'enabled': false, 'color': 'Red'};
      final result = interpolateProperties(a, b, 0.75, schemas);

      expect(result['width'], closeTo(175.0, 0.01));
      expect(result['enabled'], false);
      expect(result['color'], 'Red');
    });
  });
}
