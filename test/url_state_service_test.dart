import 'package:flutter_test/flutter_test.dart';
import 'package:flutterby/services/url_state_service.dart';

void main() {
  group('UrlStateService', () {
    test('encode produces a fragment starting with s=', () {
      final fragment = UrlStateService.encode(
        'container',
        {'width': 200.0, 'color': 'Blue'},
        {'width': 200.0, 'color': 'Blue', 'height': 120.0},
      );
      expect(fragment, startsWith('s='));
    });

    test('encode only includes non-default values', () {
      final fragment = UrlStateService.encode(
        'container',
        {'width': 300.0, 'color': 'Blue'},
        {'width': 200.0, 'color': 'Blue'},
      );
      final decoded = UrlStateService.decode(fragment);
      expect(decoded, isNotNull);
      expect(decoded!.widgetId, 'container');
      expect(decoded.properties!['width'], 300.0);
      expect(decoded.properties!.containsKey('color'), isFalse);
    });

    test('encode with no changes produces no properties', () {
      final fragment = UrlStateService.encode(
        'text',
        {'fontSize': 16.0},
        {'fontSize': 16.0},
      );
      final decoded = UrlStateService.decode(fragment);
      expect(decoded, isNotNull);
      expect(decoded!.widgetId, 'text');
      expect(decoded.properties, isNull);
    });

    test('decode returns null for invalid fragment', () {
      expect(UrlStateService.decode('invalid'), isNull);
      expect(UrlStateService.decode('x=abc'), isNull);
      expect(UrlStateService.decode('s=!!!invalid!!!'), isNull);
    });

    test('roundtrip encode/decode preserves state', () {
      final values = {'width': 250.0, 'color': 'Red', 'borderRadius': 12.0};
      final defaults = {'width': 200.0, 'color': 'Blue', 'borderRadius': 0.0};
      final fragment = UrlStateService.encode('container', values, defaults);
      final decoded = UrlStateService.decode(fragment);

      expect(decoded, isNotNull);
      expect(decoded!.widgetId, 'container');
      expect(decoded.properties!['width'], 250.0);
      expect(decoded.properties!['color'], 'Red');
      expect(decoded.properties!['borderRadius'], 12.0);
    });
  });
}
