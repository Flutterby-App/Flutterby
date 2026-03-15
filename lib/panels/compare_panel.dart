import 'package:flutter/material.dart';

import '../models/property_interpolator.dart';
import '../models/widget_demo.dart';

class ComparePanel extends StatelessWidget {
  final WidgetDemo demo;
  final Map<String, dynamic> snapshotA;
  final Map<String, dynamic> snapshotB;
  final double morphT;
  final ValueChanged<double> onMorphChanged;

  const ComparePanel({
    super.key,
    required this.demo,
    required this.snapshotA,
    required this.snapshotB,
    required this.morphT,
    required this.onMorphChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final interpolated = interpolateProperties(
      snapshotA,
      snapshotB,
      morphT,
      demo.properties,
    );

    return Column(
      children: [
        // Preview area
        Expanded(
          child: Row(
            children: [
              // A label
              RotatedBox(
                quarterTurns: 3,
                child: Text('A', style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.primary.withValues(alpha: 0.6),
                )),
              ),
              const SizedBox(width: 4),
              // Morphed preview
              Expanded(
                child: Center(
                  child: demo.previewBuilder(interpolated),
                ),
              ),
              const SizedBox(width: 4),
              RotatedBox(
                quarterTurns: 1,
                child: Text('B', style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.tertiary.withValues(alpha: 0.6),
                )),
              ),
            ],
          ),
        ),
        // Morph slider
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text('A', style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onPrimaryContainer,
                )),
              ),
              Expanded(
                child: Slider(
                  value: morphT,
                  onChanged: onMorphChanged,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: colorScheme.tertiaryContainer,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text('B', style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onTertiaryContainer,
                )),
              ),
            ],
          ),
        ),
        // Property diff summary
        Container(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                't = ${morphT.toStringAsFixed(2)}',
                style: TextStyle(
                  fontFamily: 'JetBrains Mono, monospace',
                  fontSize: 11,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CompareControls extends StatelessWidget {
  final bool hasSnapshotA;
  final bool hasSnapshotB;
  final bool compareMode;
  final VoidCallback onSetA;
  final VoidCallback onSetB;
  final VoidCallback onCompare;
  final VoidCallback onExit;

  const CompareControls({
    super.key,
    required this.hasSnapshotA,
    required this.hasSnapshotB,
    required this.compareMode,
    required this.onSetA,
    required this.onSetB,
    required this.onCompare,
    required this.onExit,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (compareMode) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
        child: FilledButton.tonalIcon(
          onPressed: onExit,
          icon: const Icon(Icons.close, size: 16),
          label: const Text('Exit Compare', style: TextStyle(fontSize: 12)),
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 8),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: onSetA,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 8),
                side: BorderSide(color: hasSnapshotA ? colorScheme.primary : colorScheme.outline),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (hasSnapshotA) Icon(Icons.check, size: 14, color: colorScheme.primary),
                  if (hasSnapshotA) const SizedBox(width: 4),
                  const Text('Set A', style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: OutlinedButton(
              onPressed: onSetB,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 8),
                side: BorderSide(color: hasSnapshotB ? colorScheme.tertiary : colorScheme.outline),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (hasSnapshotB) Icon(Icons.check, size: 14, color: colorScheme.tertiary),
                  if (hasSnapshotB) const SizedBox(width: 4),
                  const Text('Set B', style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
          ),
          if (hasSnapshotA && hasSnapshotB) ...[
            const SizedBox(width: 8),
            FilledButton(
              onPressed: onCompare,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              ),
              child: const Text('Compare', style: TextStyle(fontSize: 12)),
            ),
          ],
        ],
      ),
    );
  }
}
