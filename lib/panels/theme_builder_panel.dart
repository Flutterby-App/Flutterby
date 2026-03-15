import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ThemeBuilderPanel extends StatefulWidget {
  final Color seedColor;
  final Brightness brightness;
  final ValueChanged<Color> onSeedColorChanged;
  final ValueChanged<Brightness> onBrightnessChanged;

  const ThemeBuilderPanel({
    super.key,
    required this.seedColor,
    required this.brightness,
    required this.onSeedColorChanged,
    required this.onBrightnessChanged,
  });

  @override
  State<ThemeBuilderPanel> createState() => _ThemeBuilderPanelState();
}

class _ThemeBuilderPanelState extends State<ThemeBuilderPanel> {
  late HSLColor _hsl;

  @override
  void initState() {
    super.initState();
    _hsl = HSLColor.fromColor(widget.seedColor);
  }

  @override
  void didUpdateWidget(ThemeBuilderPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.seedColor != widget.seedColor) {
      _hsl = HSLColor.fromColor(widget.seedColor);
    }
  }

  void _updateColor(HSLColor hsl) {
    setState(() => _hsl = hsl);
    widget.onSeedColorChanged(hsl.toColor());
  }

  String _colorToHex(Color c) {
    return '#${c.toARGB32().toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';
  }

  void _copyThemeCode() {
    final hex = _colorToHex(_hsl.toColor());
    final isDark = widget.brightness == Brightness.dark;
    final code = '''ThemeData(
  colorSchemeSeed: Color(0xFF${hex.substring(1)}),
  useMaterial3: true,
  brightness: Brightness.${isDark ? 'dark' : 'light'},
)''';
    Clipboard.setData(ClipboardData(text: code));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('ThemeData code copied'), duration: Duration(seconds: 1)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _hsl.toColor(),
      brightness: widget.brightness,
    );
    final theme = Theme.of(context);

    return Container(
      color: theme.colorScheme.surfaceContainerLowest,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 10),
            child: Row(
              children: [
                Text(
                  'Theme Builder',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: _hsl.toColor(),
                    shape: BoxShape.circle,
                    border: Border.all(color: theme.colorScheme.outlineVariant),
                  ),
                ),
                const Spacer(),
                SegmentedButton<Brightness>(
                  segments: const [
                    ButtonSegment(value: Brightness.light, icon: Icon(Icons.light_mode, size: 16)),
                    ButtonSegment(value: Brightness.dark, icon: Icon(Icons.dark_mode, size: 16)),
                  ],
                  selected: {widget.brightness},
                  onSelectionChanged: (s) => widget.onBrightnessChanged(s.first),
                  style: SegmentedButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.copy, size: 18),
                  tooltip: 'Copy ThemeData code',
                  onPressed: _copyThemeCode,
                ),
              ],
            ),
          ),
          Divider(height: 1, color: theme.colorScheme.outlineVariant),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // HSL Hue Ring
                  Center(
                    child: SizedBox(
                      width: 240,
                      height: 240,
                      child: _HueRing(
                        hue: _hsl.hue,
                        saturation: _hsl.saturation,
                        lightness: _hsl.lightness,
                        onHueChanged: (h) => _updateColor(_hsl.withHue(h)),
                        onSLChanged: (s, l) => _updateColor(
                          _hsl.withSaturation(s).withLightness(l),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Seed: ${_colorToHex(_hsl.toColor())}',
                    style: TextStyle(
                      fontFamily: 'JetBrains Mono, Fira Code, monospace',
                      fontSize: 13,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'COLOR SCHEME',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.0,
                      color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildSwatchGrid(colorScheme),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwatchGrid(ColorScheme cs) {
    final roles = <(String, Color, Color)>[
      ('primary', cs.primary, cs.onPrimary),
      ('onPrimary', cs.onPrimary, cs.primary),
      ('primaryContainer', cs.primaryContainer, cs.onPrimaryContainer),
      ('onPrimaryContainer', cs.onPrimaryContainer, cs.primaryContainer),
      ('secondary', cs.secondary, cs.onSecondary),
      ('onSecondary', cs.onSecondary, cs.secondary),
      ('secondaryContainer', cs.secondaryContainer, cs.onSecondaryContainer),
      ('onSecondaryContainer', cs.onSecondaryContainer, cs.secondaryContainer),
      ('tertiary', cs.tertiary, cs.onTertiary),
      ('onTertiary', cs.onTertiary, cs.tertiary),
      ('tertiaryContainer', cs.tertiaryContainer, cs.onTertiaryContainer),
      ('onTertiaryContainer', cs.onTertiaryContainer, cs.tertiaryContainer),
      ('error', cs.error, cs.onError),
      ('onError', cs.onError, cs.error),
      ('errorContainer', cs.errorContainer, cs.onErrorContainer),
      ('surface', cs.surface, cs.onSurface),
      ('onSurface', cs.onSurface, cs.surface),
      ('surfaceContainerHighest', cs.surfaceContainerHighest, cs.onSurface),
      ('outline', cs.outline, cs.surface),
      ('outlineVariant', cs.outlineVariant, cs.onSurface),
      ('inversePrimary', cs.inversePrimary, cs.inverseSurface),
      ('inverseSurface', cs.inverseSurface, cs.onInverseSurface),
    ];

    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: roles.map((role) {
        final (name, bg, fg) = role;
        return Tooltip(
          message: '${_colorToHex(bg)}\n$name',
          child: Container(
            width: 80,
            height: 48,
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Theme.of(context).colorScheme.outlineVariant,
                width: 0.5,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              name.length > 12 ? '${name.substring(0, 10)}...' : name,
              style: TextStyle(fontSize: 8, color: fg, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        );
      }).toList(),
    );
  }
}

/// HSL hue ring + saturation/lightness square.
class _HueRing extends StatelessWidget {
  final double hue;
  final double saturation;
  final double lightness;
  final ValueChanged<double> onHueChanged;
  final void Function(double saturation, double lightness) onSLChanged;

  const _HueRing({
    required this.hue,
    required this.saturation,
    required this.lightness,
    required this.onHueChanged,
    required this.onSLChanged,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final size = constraints.biggest.shortestSide;
      final ringWidth = size * 0.12;
      final center = Offset(size / 2, size / 2);
      final outerRadius = size / 2;
      final innerRadius = outerRadius - ringWidth;

      return GestureDetector(
        onPanStart: (d) => _handleDrag(d.localPosition, center, innerRadius, outerRadius, ringWidth, size),
        onPanUpdate: (d) => _handleDrag(d.localPosition, center, innerRadius, outerRadius, ringWidth, size),
        child: CustomPaint(
          size: Size.square(size),
          painter: _HueRingPainter(
            hue: hue,
            saturation: saturation,
            lightness: lightness,
            ringWidth: ringWidth,
          ),
        ),
      );
    });
  }

  void _handleDrag(Offset pos, Offset center, double innerRadius, double outerRadius, double ringWidth, double size) {
    final delta = pos - center;
    final dist = delta.distance;

    if (dist > innerRadius - 4) {
      // Hue ring
      final angle = (math.atan2(delta.dy, delta.dx) * 180 / math.pi + 360) % 360;
      onHueChanged(angle);
    } else {
      // SL square
      final squareSize = (innerRadius - 8) * math.sqrt(2);
      final squareOrigin = center - Offset(squareSize / 2, squareSize / 2);
      final local = pos - squareOrigin;
      final s = (local.dx / squareSize).clamp(0.0, 1.0);
      final l = 1.0 - (local.dy / squareSize).clamp(0.0, 1.0);
      onSLChanged(s, l.clamp(0.05, 0.95));
    }
  }
}

class _HueRingPainter extends CustomPainter {
  final double hue;
  final double saturation;
  final double lightness;
  final double ringWidth;

  _HueRingPainter({
    required this.hue,
    required this.saturation,
    required this.lightness,
    required this.ringWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final outerRadius = size.width / 2;
    final innerRadius = outerRadius - ringWidth;

    // Draw hue ring
    final ringRect = Rect.fromCircle(center: center, radius: (outerRadius + innerRadius) / 2);
    final sweepPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = ringWidth
      ..shader = SweepGradient(
        colors: List.generate(
          13,
          (i) => HSLColor.fromAHSL(1, (i * 30) % 360, 1, 0.5).toColor(),
        ),
      ).createShader(ringRect);
    canvas.drawCircle(center, (outerRadius + innerRadius) / 2, sweepPaint);

    // Hue indicator
    final hueAngle = hue * math.pi / 180;
    final indicatorPos = center +
        Offset(
          math.cos(hueAngle) * (outerRadius + innerRadius) / 2,
          math.sin(hueAngle) * (outerRadius + innerRadius) / 2,
        );
    canvas.drawCircle(
      indicatorPos,
      ringWidth / 2 + 2,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );
    canvas.drawCircle(
      indicatorPos,
      ringWidth / 2 - 1,
      Paint()..color = HSLColor.fromAHSL(1, hue, 1, 0.5).toColor(),
    );

    // SL square inside ring
    final squareSize = (innerRadius - 8) * math.sqrt(2);
    final squareRect = Rect.fromCenter(center: center, width: squareSize, height: squareSize);

    // Saturation gradient (left to right: gray to full color)
    canvas.drawRect(
      squareRect,
      Paint()
        ..shader = LinearGradient(
          colors: [
            HSLColor.fromAHSL(1, hue, 0, 0.5).toColor(),
            HSLColor.fromAHSL(1, hue, 1, 0.5).toColor(),
          ],
        ).createShader(squareRect),
    );

    // Lightness gradient (top to bottom: white to black)
    canvas.drawRect(
      squareRect,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0x80FFFFFF), Color(0x00FFFFFF), Color(0x00000000), Color(0x80000000)],
          stops: [0, 0.5, 0.5, 1],
        ).createShader(squareRect),
    );

    // SL indicator
    final slX = squareRect.left + saturation * squareSize;
    final slY = squareRect.top + (1 - lightness) * squareSize;
    canvas.drawCircle(
      Offset(slX, slY),
      7,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5,
    );
    canvas.drawCircle(
      Offset(slX, slY),
      5,
      Paint()..color = HSLColor.fromAHSL(1, hue, saturation, lightness).toColor(),
    );
  }

  @override
  bool shouldRepaint(_HueRingPainter oldDelegate) =>
      hue != oldDelegate.hue ||
      saturation != oldDelegate.saturation ||
      lightness != oldDelegate.lightness;
}
