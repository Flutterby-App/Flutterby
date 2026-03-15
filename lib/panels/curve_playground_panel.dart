import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/curve_preset.dart';

class CurvePlaygroundPanel extends StatefulWidget {
  const CurvePlaygroundPanel({super.key});

  @override
  State<CurvePlaygroundPanel> createState() => _CurvePlaygroundPanelState();
}

class _CurvePlaygroundPanelState extends State<CurvePlaygroundPanel>
    with SingleTickerProviderStateMixin {
  double _x1 = 0.25, _y1 = 0.1, _x2 = 0.25, _y2 = 1.0; // ease
  int? _dragging; // 1 or 2
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  String get _codeString {
    final match = findMatchingPreset(_x1, _y1, _x2, _y2);
    if (match != null) return 'curve: ${match.code}';
    return 'curve: Cubic(${_x1.toStringAsFixed(2)}, ${_y1.toStringAsFixed(2)}, ${_x2.toStringAsFixed(2)}, ${_y2.toStringAsFixed(2)})';
  }

  void _copyCode() {
    Clipboard.setData(ClipboardData(text: _codeString));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Curve code copied'), duration: Duration(seconds: 1)),
    );
  }

  void _selectPreset(CurvePreset preset) {
    setState(() {
      _x1 = preset.x1;
      _y1 = preset.y1;
      _x2 = preset.x2;
      _y2 = preset.y2;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final matchedPreset = findMatchingPreset(_x1, _y1, _x2, _y2);

    return Container(
      color: colorScheme.surfaceContainerLowest,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 10),
            child: Row(
              children: [
                Text(
                  'Animation Curve Playground',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
                const Spacer(),
                if (matchedPreset != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      matchedPreset.name,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.copy, size: 18),
                  tooltip: 'Copy curve code',
                  onPressed: _copyCode,
                ),
              ],
            ),
          ),
          Divider(height: 1, color: colorScheme.outlineVariant),
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Preset dropdown
                  SizedBox(
                    width: double.infinity,
                    child: Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: curvePresets.map((preset) {
                        final isSelected = matchedPreset?.name == preset.name;
                        return ChoiceChip(
                          label: Text(preset.name, style: const TextStyle(fontSize: 11)),
                          selected: isSelected,
                          onSelected: (_) => _selectPreset(preset),
                          visualDensity: VisualDensity.compact,
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Curve graph
                  AspectRatio(
                    aspectRatio: 1,
                    child: LayoutBuilder(builder: (context, constraints) {
                      final graphSize = constraints.biggest.shortestSide;
                      return GestureDetector(
                        onPanStart: (d) => _onDragStart(d.localPosition, graphSize),
                        onPanUpdate: (d) => _onDragUpdate(d.localPosition, graphSize),
                        onPanEnd: (_) => setState(() => _dragging = null),
                        child: AnimatedBuilder(
                          animation: _animController,
                          builder: (context, _) {
                            return CustomPaint(
                              size: Size.square(graphSize),
                              painter: _CurveGraphPainter(
                                x1: _x1,
                                y1: _y1,
                                x2: _x2,
                                y2: _y2,
                                t: _animController.value,
                                primaryColor: colorScheme.primary,
                                gridColor: colorScheme.outlineVariant,
                                handleColor: colorScheme.tertiary,
                                ballColor: colorScheme.error,
                                isDark: theme.brightness == Brightness.dark,
                              ),
                            );
                          },
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 16),
                  // Animation preview bar
                  AnimatedBuilder(
                    animation: _animController,
                    builder: (context, _) {
                      final curve = Cubic(_x1, _y1, _x2, _y2);
                      final curvedT = curve.transform(_animController.value);
                      return Column(
                        children: [
                          SizedBox(
                            height: 40,
                            child: Align(
                              alignment: Alignment(curvedT * 2 - 1, 0),
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: colorScheme.primary,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            height: 24,
                            child: Align(
                              alignment: Alignment(curvedT * 2 - 1, 0),
                              child: Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: colorScheme.tertiary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  // Code output
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _codeString,
                      style: TextStyle(
                        fontFamily: 'JetBrains Mono, Fira Code, monospace',
                        fontSize: 13,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onDragStart(Offset pos, double graphSize) {
    final margin = 40.0;
    final plotSize = graphSize - margin * 2;

    double toGraphX(double v) => margin + v * plotSize;
    double toGraphY(double v) => margin + (1 - v) * plotSize;

    final p1 = Offset(toGraphX(_x1), toGraphY(_y1));
    final p2 = Offset(toGraphX(_x2), toGraphY(_y2));

    final d1 = (pos - p1).distance;
    final d2 = (pos - p2).distance;

    const hitRadius = 24.0;
    if (d1 < hitRadius && d1 < d2) {
      _dragging = 1;
    } else if (d2 < hitRadius) {
      _dragging = 2;
    }
  }

  void _onDragUpdate(Offset pos, double graphSize) {
    if (_dragging == null) return;
    final margin = 40.0;
    final plotSize = graphSize - margin * 2;

    final x = ((pos.dx - margin) / plotSize).clamp(0.0, 1.0);
    final y = 1 - ((pos.dy - margin) / plotSize).clamp(-0.5, 1.5);

    setState(() {
      if (_dragging == 1) {
        _x1 = x;
        _y1 = y;
      } else {
        _x2 = x;
        _y2 = y;
      }
    });
  }
}

class _CurveGraphPainter extends CustomPainter {
  final double x1, y1, x2, y2, t;
  final Color primaryColor, gridColor, handleColor, ballColor;
  final bool isDark;

  _CurveGraphPainter({
    required this.x1,
    required this.y1,
    required this.x2,
    required this.y2,
    required this.t,
    required this.primaryColor,
    required this.gridColor,
    required this.handleColor,
    required this.ballColor,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final margin = 40.0;
    final plotSize = size.width - margin * 2;

    double toX(double v) => margin + v * plotSize;
    double toY(double v) => margin + (1 - v) * plotSize;

    // Grid
    final gridPaint = Paint()
      ..color = gridColor
      ..strokeWidth = 0.5;
    for (int i = 0; i <= 4; i++) {
      final f = i / 4;
      canvas.drawLine(Offset(toX(f), toY(0)), Offset(toX(f), toY(1)), gridPaint);
      canvas.drawLine(Offset(toX(0), toY(f)), Offset(toX(1), toY(f)), gridPaint);
    }

    // Axis labels
    final labelStyle = TextStyle(
      fontSize: 10,
      color: gridColor,
      fontFamily: 'JetBrains Mono, monospace',
    );
    _drawText(canvas, '0', Offset(margin - 16, toY(0) - 6), labelStyle);
    _drawText(canvas, '1', Offset(margin - 16, toY(1) - 6), labelStyle);
    _drawText(canvas, '0', Offset(toX(0) - 4, toY(0) + 8), labelStyle);
    _drawText(canvas, '1', Offset(toX(1) - 4, toY(0) + 8), labelStyle);

    // Control point lines (dashed)
    final dashedPaint = Paint()
      ..color = handleColor.withValues(alpha: 0.5)
      ..strokeWidth = 1.5;
    _drawDashedLine(canvas, Offset(toX(0), toY(0)), Offset(toX(x1), toY(y1)), dashedPaint);
    _drawDashedLine(canvas, Offset(toX(1), toY(1)), Offset(toX(x2), toY(y2)), dashedPaint);

    // Bézier curve
    final curvePaint = Paint()
      ..color = primaryColor
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final path = Path()
      ..moveTo(toX(0), toY(0))
      ..cubicTo(toX(x1), toY(y1), toX(x2), toY(y2), toX(1), toY(1));
    canvas.drawPath(path, curvePaint);

    // Control point handles
    for (final cp in [(x1, y1), (x2, y2)]) {
      canvas.drawCircle(
        Offset(toX(cp.$1), toY(cp.$2)),
        8,
        Paint()..color = handleColor,
      );
      canvas.drawCircle(
        Offset(toX(cp.$1), toY(cp.$2)),
        8,
        Paint()
          ..color = isDark ? Colors.white : Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
    }

    // Animated ball on curve
    final curve = Cubic(x1, y1, x2, y2);
    final ct = curve.transform(t);
    canvas.drawCircle(
      Offset(toX(t), toY(ct)),
      6,
      Paint()..color = ballColor,
    );
  }

  void _drawDashedLine(Canvas canvas, Offset p1, Offset p2, Paint paint) {
    final dx = p2.dx - p1.dx;
    final dy = p2.dy - p1.dy;
    final dist = math.sqrt(dx * dx + dy * dy);
    final dashLen = 6.0;
    final gapLen = 4.0;
    final count = (dist / (dashLen + gapLen)).floor();
    for (int i = 0; i < count; i++) {
      final startT = i * (dashLen + gapLen) / dist;
      final endT = (i * (dashLen + gapLen) + dashLen) / dist;
      canvas.drawLine(
        Offset(p1.dx + dx * startT, p1.dy + dy * startT),
        Offset(p1.dx + dx * endT.clamp(0, 1), p1.dy + dy * endT.clamp(0, 1)),
        paint,
      );
    }
  }

  void _drawText(Canvas canvas, String text, Offset offset, TextStyle style) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(_CurveGraphPainter old) => true;
}
