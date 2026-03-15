/// Named Flutter curve presets mapped to cubic Bézier control points.
class CurvePreset {
  final String name;
  final String code;
  final double x1, y1, x2, y2;

  const CurvePreset(this.name, this.code, this.x1, this.y1, this.x2, this.y2);
}

const List<CurvePreset> curvePresets = [
  CurvePreset('linear', 'Curves.linear', 0.0, 0.0, 1.0, 1.0),
  CurvePreset('ease', 'Curves.ease', 0.25, 0.1, 0.25, 1.0),
  CurvePreset('easeIn', 'Curves.easeIn', 0.42, 0.0, 1.0, 1.0),
  CurvePreset('easeOut', 'Curves.easeOut', 0.0, 0.0, 0.58, 1.0),
  CurvePreset('easeInOut', 'Curves.easeInOut', 0.42, 0.0, 0.58, 1.0),
  CurvePreset('easeInSine', 'Curves.easeInSine', 0.47, 0.0, 0.745, 0.715),
  CurvePreset('easeOutSine', 'Curves.easeOutSine', 0.39, 0.575, 0.565, 1.0),
  CurvePreset('easeInOutSine', 'Curves.easeInOutSine', 0.445, 0.05, 0.55, 0.95),
  CurvePreset('easeInQuad', 'Curves.easeInQuad', 0.55, 0.085, 0.68, 0.53),
  CurvePreset('easeOutQuad', 'Curves.easeOutQuad', 0.25, 0.46, 0.45, 0.94),
  CurvePreset('easeInOutQuad', 'Curves.easeInOutQuad', 0.455, 0.03, 0.515, 0.955),
  CurvePreset('easeInCubic', 'Curves.easeInCubic', 0.55, 0.055, 0.675, 0.19),
  CurvePreset('easeOutCubic', 'Curves.easeOutCubic', 0.215, 0.61, 0.355, 1.0),
  CurvePreset('easeInOutCubic', 'Curves.easeInOutCubic', 0.645, 0.045, 0.355, 1.0),
  CurvePreset('fastOutSlowIn', 'Curves.fastOutSlowIn', 0.4, 0.0, 0.2, 1.0),
  CurvePreset('decelerate', 'Curves.decelerate', 0.0, 0.0, 0.2, 1.0),
];

/// Epsilon for matching control points to presets.
const double curveEpsilon = 0.015;

/// Find a matching preset for the given control points, or null.
CurvePreset? findMatchingPreset(double x1, double y1, double x2, double y2) {
  for (final preset in curvePresets) {
    if ((preset.x1 - x1).abs() < curveEpsilon &&
        (preset.y1 - y1).abs() < curveEpsilon &&
        (preset.x2 - x2).abs() < curveEpsilon &&
        (preset.y2 - y2).abs() < curveEpsilon) {
      return preset;
    }
  }
  return null;
}
