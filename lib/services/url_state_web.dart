import 'dart:js_interop';

import 'package:web/web.dart' as web;

String? readUrlFragment() {
  final hash = web.window.location.hash;
  if (hash.isEmpty) return null;
  // Strip leading '#'
  return hash.substring(1);
}

void writeUrlFragment(String fragment) {
  web.window.history.replaceState(
    ''.toJS,
    '',
    '#$fragment',
  );
}
