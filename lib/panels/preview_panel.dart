import 'package:flutter/material.dart';

class PreviewPanel extends StatelessWidget {
  final String widgetName;
  final Widget child;

  const PreviewPanel({
    super.key,
    required this.widgetName,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
            child: Text(
              'Preview — $widgetName',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: Center(
              child: Container(
                margin: const EdgeInsets.all(32),
                constraints: const BoxConstraints(maxWidth: 500, maxHeight: 400),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Center(child: child),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
