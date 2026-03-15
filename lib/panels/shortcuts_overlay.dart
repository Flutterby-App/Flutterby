import 'package:flutter/material.dart';

class ShortcutsOverlay extends StatelessWidget {
  final VoidCallback onDismiss;

  const ShortcutsOverlay({super.key, required this.onDismiss});

  static const _shortcuts = [
    ('?', 'Show/hide shortcuts'),
    ('/', 'Focus search'),
    ('Esc', 'Clear search / close overlay'),
    ('↑ ↓', 'Previous/next widget'),
    ('1 2 3', 'Properties / Source / Docs tab'),
    ('r', 'Reset to defaults'),
    ('c', 'Copy source code'),
    ('t', 'Toggle dark/light theme'),
    ('⌘Z', 'Undo property change'),
    ('⌘⇧Z', 'Redo property change'),
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onDismiss,
      child: Container(
        color: Colors.black54,
        child: Center(
          child: GestureDetector(
            onTap: () {}, // absorb taps on the card
            child: Card(
              elevation: 16,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Container(
                width: 360,
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.keyboard, color: colorScheme.primary, size: 22),
                        const SizedBox(width: 10),
                        Text(
                          'Keyboard Shortcuts',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.close, size: 18),
                          onPressed: onDismiss,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    for (final (key, desc) in _shortcuts) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 72,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: colorScheme.surfaceContainerHighest,
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(color: colorScheme.outlineVariant),
                                  ),
                                  child: Text(
                                    key,
                                    style: TextStyle(
                                      fontFamily: 'JetBrains Mono, Fira Code, Menlo, monospace',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: colorScheme.onSurface,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                desc,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
