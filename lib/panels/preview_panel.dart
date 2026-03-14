import 'package:flutter/material.dart';

class PreviewPanel extends StatelessWidget {
  final String widgetName;
  final String description;
  final Widget child;

  const PreviewPanel({
    super.key,
    required this.widgetName,
    this.description = '',
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      color: colorScheme.surfaceContainerLowest,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 10),
            child: Row(
              children: [
                Text(
                  'Preview — $widgetName',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                ),
                if (description.isNotEmpty) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      description,
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Divider(height: 1, color: colorScheme.outlineVariant),
          Expanded(
            child: Center(
              child: Container(
                margin: const EdgeInsets.all(32),
                constraints: const BoxConstraints(maxWidth: 500, maxHeight: 400),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: colorScheme.outlineVariant),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CustomPaint(
                    painter: _CheckerboardPainter(isDark: isDark),
                    child: Center(child: child),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Subtle checkerboard background — helps visualize widget bounds and transparency.
class _CheckerboardPainter extends CustomPainter {
  final bool isDark;
  _CheckerboardPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    const cellSize = 12.0;
    final colorA = isDark ? const Color(0xFF2A2A2A) : const Color(0xFFFFFFFF);
    final colorB = isDark ? const Color(0xFF272727) : const Color(0xFFFAFAFA);

    final paintA = Paint()..color = colorA;
    final paintB = Paint()..color = colorB;

    // Fill with base color first
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paintA);

    // Draw alternate cells
    for (double y = 0; y < size.height; y += cellSize) {
      for (double x = 0; x < size.width; x += cellSize) {
        final col = (x / cellSize).floor();
        final row = (y / cellSize).floor();
        if ((col + row) % 2 == 1) {
          canvas.drawRect(
            Rect.fromLTWH(x, y, cellSize, cellSize),
            paintB,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(_CheckerboardPainter oldDelegate) => oldDelegate.isDark != isDark;
}
