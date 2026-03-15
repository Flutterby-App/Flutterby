import 'package:flutter/material.dart';

enum DeviceType { none, iPhone, pixel, iPad, desktop }

class DeviceSpec {
  final String name;
  final DeviceType type;
  final double screenWidth;
  final double screenHeight;
  final double bezelRadius;
  final double topSafeArea;
  final double bottomSafeArea;

  const DeviceSpec({
    required this.name,
    required this.type,
    required this.screenWidth,
    required this.screenHeight,
    this.bezelRadius = 40,
    this.topSafeArea = 0,
    this.bottomSafeArea = 0,
  });

  Size get screenSize => Size(screenWidth, screenHeight);
}

const List<DeviceSpec> devicePresets = [
  DeviceSpec(
    name: 'None',
    type: DeviceType.none,
    screenWidth: 0,
    screenHeight: 0,
  ),
  DeviceSpec(
    name: 'iPhone 16 Pro',
    type: DeviceType.iPhone,
    screenWidth: 393,
    screenHeight: 852,
    bezelRadius: 55,
    topSafeArea: 59,
    bottomSafeArea: 34,
  ),
  DeviceSpec(
    name: 'Pixel 8',
    type: DeviceType.pixel,
    screenWidth: 412,
    screenHeight: 915,
    bezelRadius: 40,
    topSafeArea: 36,
    bottomSafeArea: 20,
  ),
  DeviceSpec(
    name: 'iPad Air',
    type: DeviceType.iPad,
    screenWidth: 820,
    screenHeight: 1180,
    bezelRadius: 20,
    topSafeArea: 24,
    bottomSafeArea: 20,
  ),
  DeviceSpec(
    name: 'Desktop',
    type: DeviceType.desktop,
    screenWidth: 800,
    screenHeight: 600,
    bezelRadius: 8,
    topSafeArea: 32,
    bottomSafeArea: 0,
  ),
];
