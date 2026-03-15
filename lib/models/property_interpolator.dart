import 'dart:ui';

import '../models/widget_demo.dart';

/// Interpolates property values between two snapshots based on t (0.0 to 1.0).
Map<String, dynamic> interpolateProperties(
  Map<String, dynamic> a,
  Map<String, dynamic> b,
  double t,
  List<PropertySchema> schemas,
) {
  final result = <String, dynamic>{};
  for (final s in schemas) {
    final va = a[s.name];
    final vb = b[s.name];
    if (va == null || vb == null) {
      result[s.name] = t < 0.5 ? va : vb;
      continue;
    }
    result[s.name] = switch (s.type) {
      PropertyType.double => lerpDouble(va as num, vb as num, t),
      PropertyType.int => lerpDouble(va as num, vb as num, t)!.round(),
      PropertyType.bool => t < 0.5 ? va : vb,
      PropertyType.enumChoice => t < 0.5 ? va : vb,
      PropertyType.string => t < 0.5 ? va : vb,
      PropertyType.color => t < 0.5 ? va : vb,
    };
  }
  return result;
}
