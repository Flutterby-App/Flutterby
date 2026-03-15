import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'url_state_stub.dart' if (dart.library.js_interop) 'url_state_web.dart'
    as platform;

class UrlStateService {
  /// Encodes widget id + property values (only non-default) to a URL-safe string.
  static String encode(
    String widgetId,
    Map<String, dynamic> values,
    Map<String, dynamic> defaults,
  ) {
    // Only include properties that differ from defaults
    final diff = <String, dynamic>{};
    for (final entry in values.entries) {
      final defaultVal = defaults[entry.key];
      if (entry.value != defaultVal) {
        diff[entry.key] = entry.value;
      }
    }

    final payload = <String, dynamic>{
      'w': widgetId,
      if (diff.isNotEmpty) 'p': diff,
    };

    final json = jsonEncode(payload);
    return 's=${base64Url.encode(utf8.encode(json))}';
  }

  /// Decodes a URL fragment into widget id and property overrides.
  /// Returns null if the fragment is not a valid share link.
  static ({String widgetId, Map<String, dynamic>? properties})? decode(
    String fragment,
  ) {
    if (!fragment.startsWith('s=')) return null;
    try {
      final encoded = fragment.substring(2);
      final json = utf8.decode(base64Url.decode(encoded));
      final map = jsonDecode(json) as Map<String, dynamic>;
      final widgetId = map['w'] as String?;
      if (widgetId == null) return null;
      final props = map['p'] as Map<String, dynamic>?;
      return (widgetId: widgetId, properties: props);
    } catch (_) {
      return null;
    }
  }

  /// Reads the current URL fragment (web only).
  static String? readFragment() {
    if (!kIsWeb) return null;
    return platform.readUrlFragment();
  }

  /// Writes a fragment to the URL bar without navigation (web only).
  static void writeFragment(String fragment) {
    if (!kIsWeb) return;
    platform.writeUrlFragment(fragment);
  }
}
