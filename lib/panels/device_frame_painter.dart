import 'package:flutter/material.dart';

import '../models/device_spec.dart';

class DeviceFrameWrapper extends StatelessWidget {
  final DeviceSpec device;
  final Widget child;
  final bool showSafeArea;

  const DeviceFrameWrapper({
    super.key,
    required this.device,
    required this.child,
    this.showSafeArea = false,
  });

  @override
  Widget build(BuildContext context) {
    if (device.type == DeviceType.none) return child;

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return FittedBox(
      fit: BoxFit.contain,
      child: CustomPaint(
        painter: _DeviceFramePainter(
          device: device,
          isDark: isDark,
          showSafeArea: showSafeArea,
        ),
        child: Padding(
          padding: _getFramePadding(),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(device.bezelRadius - 8),
            child: SizedBox(
              width: device.screenWidth,
              height: device.screenHeight,
              child: Stack(
                children: [
                  Positioned.fill(child: child),
                  // Status bar
                  if (device.type == DeviceType.iPhone || device.type == DeviceType.pixel)
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      height: device.topSafeArea,
                      child: _StatusBar(device: device),
                    ),
                  if (device.type == DeviceType.desktop)
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      height: device.topSafeArea,
                      child: _DesktopTitleBar(isDark: isDark),
                    ),
                  // Home indicator
                  if (device.type == DeviceType.iPhone)
                    Positioned(
                      bottom: 8,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          width: 134,
                          height: 5,
                          decoration: BoxDecoration(
                            color: isDark ? Colors.white54 : Colors.black38,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                    ),
                  // Gesture bar (Pixel)
                  if (device.type == DeviceType.pixel)
                    Positioned(
                      bottom: 6,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          width: 100,
                          height: 4,
                          decoration: BoxDecoration(
                            color: isDark ? Colors.white38 : Colors.black26,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ),
                  // Safe area visualization
                  if (showSafeArea && device.topSafeArea > 0)
                    Positioned(
                      top: device.topSafeArea,
                      left: 0,
                      right: 0,
                      height: 1,
                      child: CustomPaint(painter: _DashedLinePainter(color: Colors.red.withValues(alpha: 0.5))),
                    ),
                  if (showSafeArea && device.bottomSafeArea > 0)
                    Positioned(
                      bottom: device.bottomSafeArea,
                      left: 0,
                      right: 0,
                      height: 1,
                      child: CustomPaint(painter: _DashedLinePainter(color: Colors.red.withValues(alpha: 0.5))),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  EdgeInsets _getFramePadding() {
    return switch (device.type) {
      DeviceType.none => EdgeInsets.zero,
      DeviceType.iPhone => const EdgeInsets.all(14),
      DeviceType.pixel => const EdgeInsets.all(12),
      DeviceType.iPad => const EdgeInsets.all(18),
      DeviceType.desktop => const EdgeInsets.fromLTRB(6, 6, 6, 6),
    };
  }
}

class _DeviceFramePainter extends CustomPainter {
  final DeviceSpec device;
  final bool isDark;
  final bool showSafeArea;

  _DeviceFramePainter({
    required this.device,
    required this.isDark,
    required this.showSafeArea,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final bodyColor = isDark ? const Color(0xFF1A1A1A) : const Color(0xFF2D2D2D);
    final bodyPaint = Paint()..color = bodyColor;
    final borderPaint = Paint()
      ..color = isDark ? const Color(0xFF444444) : const Color(0xFF555555)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(device.bezelRadius),
    );

    canvas.drawRRect(rrect, bodyPaint);
    canvas.drawRRect(rrect, borderPaint);

    // Dynamic island (iPhone)
    if (device.type == DeviceType.iPhone) {
      final padding = _framePadding;
      final cx = size.width / 2;
      final cy = padding + 16;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset(cx, cy), width: 90, height: 25),
          const Radius.circular(12),
        ),
        Paint()..color = Colors.black,
      );
    }

    // Camera punch hole (Pixel)
    if (device.type == DeviceType.pixel) {
      final padding = _framePadding;
      canvas.drawCircle(
        Offset(size.width / 2, padding + 14),
        7,
        Paint()..color = const Color(0xFF111111),
      );
    }

    // Desktop resize grip
    if (device.type == DeviceType.desktop) {
      final gripPaint = Paint()
        ..color = isDark ? Colors.white24 : Colors.black26
        ..strokeWidth = 1;
      for (int i = 0; i < 3; i++) {
        canvas.drawLine(
          Offset(size.width - 14 + i * 4.0, size.height - 6),
          Offset(size.width - 6, size.height - 14 + i * 4.0),
          gripPaint,
        );
      }
    }
  }

  double get _framePadding => switch (device.type) {
        DeviceType.iPhone => 14.0,
        DeviceType.pixel => 12.0,
        DeviceType.iPad => 18.0,
        DeviceType.desktop => 6.0,
        DeviceType.none => 0.0,
      };

  @override
  bool shouldRepaint(_DeviceFramePainter old) =>
      device != old.device || isDark != old.isDark || showSafeArea != old.showSafeArea;
}

class _StatusBar extends StatelessWidget {
  final DeviceSpec device;
  const _StatusBar({required this.device});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        device.type == DeviceType.iPhone ? 32 : 16,
        device.type == DeviceType.iPhone ? 14 : 8,
        device.type == DeviceType.iPhone ? 32 : 16,
        0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '9:41',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.signal_cellular_4_bar, size: 14, color: Colors.white.withValues(alpha: 0.9)),
              const SizedBox(width: 4),
              Icon(Icons.wifi, size: 14, color: Colors.white.withValues(alpha: 0.9)),
              const SizedBox(width: 4),
              Icon(Icons.battery_full, size: 14, color: Colors.white.withValues(alpha: 0.9)),
            ],
          ),
        ],
      ),
    );
  }
}

class _DesktopTitleBar extends StatelessWidget {
  final bool isDark;
  const _DesktopTitleBar({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFE8E8E8),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          // Traffic lights
          _dot(const Color(0xFFFF5F57)),
          const SizedBox(width: 6),
          _dot(const Color(0xFFFFBD2E)),
          const SizedBox(width: 6),
          _dot(const Color(0xFF28C840)),
          const Spacer(),
          Text(
            'Preview',
            style: TextStyle(
              fontSize: 12,
              color: isDark ? Colors.white60 : Colors.black54,
            ),
          ),
          const Spacer(),
          const SizedBox(width: 48), // Balance the traffic lights
        ],
      ),
    );
  }

  Widget _dot(Color color) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  final Color color;
  _DashedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;
    const dashLen = 4.0;
    const gapLen = 3.0;
    double x = 0;
    while (x < size.width) {
      canvas.drawLine(Offset(x, 0), Offset((x + dashLen).clamp(0, size.width), 0), paint);
      x += dashLen + gapLen;
    }
  }

  @override
  bool shouldRepaint(_DashedLinePainter old) => color != old.color;
}
