import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/dartpad_service.dart';

// VS Code dark+ inspired colors for Dart syntax highlighting.
const _codeBg = Color(0xFF1E1E1E);
const _codePlain = Color(0xFFD4D4D4);
const _codeKeyword = Color(0xFF569CD6); // blue — const, final, etc.
const _codeClass = Color(0xFF4EC9B0); // teal — class names
const _codeString = Color(0xFFCE9178); // orange — strings
const _codeNumber = Color(0xFFB5CEA8); // green — numbers
const _codePunctuation = Color(0xFFD4D4D4); // grey — parens, commas
const _codeProperty = Color(0xFF9CDCFE); // light blue — property names
const _codeEnumValue = Color(0xFFDCDCAA); // yellow — enum values / methods

class SourceCodePanel extends StatelessWidget {
  final String source;

  const SourceCodePanel({super.key, required this.source});

  @override
  Widget build(BuildContext context) {
    final lines = source.split('\n');
    final lineCount = lines.length;

    return Container(
      color: _codeBg,
      child: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(0, 16, 20, 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Line numbers gutter
                SizedBox(
                  width: 44,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 1),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        for (int i = 1; i <= lineCount; i++)
                          SizedBox(
                            height: 20.8, // matches line height 13 * 1.6
                            child: Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: Text(
                                '$i',
                                style: const TextStyle(
                                  fontFamily: 'JetBrains Mono, Fira Code, Menlo, Consolas, monospace',
                                  fontSize: 13,
                                  height: 1.6,
                                  color: Color(0xFF858585),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                // Code content
                Expanded(child: _buildHighlightedCode()),
              ],
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _DartPadButton(source: source),
                const SizedBox(width: 6),
                _CopyButton(source: source),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHighlightedCode() {
    final spans = _highlightDart(source);
    return SelectableText.rich(
      TextSpan(
        style: const TextStyle(
          fontFamily: 'JetBrains Mono, Fira Code, Menlo, Consolas, monospace',
          fontSize: 13,
          height: 1.6,
          color: _codePlain,
        ),
        children: spans,
      ),
    );
  }
}

class _CopyButton extends StatefulWidget {
  final String source;
  const _CopyButton({required this.source});

  @override
  State<_CopyButton> createState() => _CopyButtonState();
}

class _CopyButtonState extends State<_CopyButton> {
  bool _copied = false;

  void _copy() {
    Clipboard.setData(ClipboardData(text: widget.source));
    setState(() => _copied = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _copied = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(6),
      child: InkWell(
        borderRadius: BorderRadius.circular(6),
        onTap: _copy,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _copied ? Icons.check : Icons.copy,
                size: 14,
                color: _copied ? const Color(0xFF4EC9B0) : Colors.white70,
              ),
              const SizedBox(width: 6),
              Text(
                _copied ? 'Copied!' : 'Copy',
                style: TextStyle(
                  fontSize: 12,
                  color: _copied ? const Color(0xFF4EC9B0) : Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DartPadButton extends StatelessWidget {
  final String source;
  const _DartPadButton({required this.source});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(6),
      child: InkWell(
        borderRadius: BorderRadius.circular(6),
        onTap: () => DartPadService.openInDartPad(source),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.open_in_new, size: 14, color: Colors.white70),
              SizedBox(width: 6),
              Text(
                'DartPad',
                style: TextStyle(fontSize: 12, color: Colors.white70),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Simple Dart syntax highlighter (no dependencies)
// ---------------------------------------------------------------------------

final _dartKeywords = {
  'const', 'final', 'var', 'void', 'null', 'true', 'false',
  'return', 'if', 'else', 'for', 'while', 'do', 'switch', 'case',
  'break', 'continue', 'new', 'this', 'super', 'class', 'extends',
  'implements', 'with', 'abstract', 'static', 'late', 'required',
};

// Regex-based tokenizer — good enough for generated Flutter code.
final _tokenPattern = RegExp(
  r"('(?:[^'\\]|\\.)*')" // single-quoted strings
  r'|("(?:[^"\\]|\\.)*")' // double-quoted strings
  r'|(\b\d+\.?\d*\b)' // numbers
  r'|(\b[A-Z][a-zA-Z0-9]*\b)' // PascalCase — class names
  r'|(\b[a-z_][a-zA-Z0-9_]*\b)' // identifiers
  r'|([:,\(\)\[\]\{\}\.;])' // punctuation
  r'|(\s+)' // whitespace
  r'|(.)', // anything else
);

List<TextSpan> _highlightDart(String code) {
  final spans = <TextSpan>[];

  for (final match in _tokenPattern.allMatches(code)) {
    final text = match.group(0)!;

    if (match.group(1) != null || match.group(2) != null) {
      // String literal
      spans.add(TextSpan(text: text, style: const TextStyle(color: _codeString)));
    } else if (match.group(3) != null) {
      // Number
      spans.add(TextSpan(text: text, style: const TextStyle(color: _codeNumber)));
    } else if (match.group(4) != null) {
      // PascalCase — class / type name
      spans.add(TextSpan(text: text, style: const TextStyle(color: _codeClass)));
    } else if (match.group(5) != null) {
      // Identifier — check if keyword or property
      if (_dartKeywords.contains(text)) {
        spans.add(TextSpan(text: text, style: const TextStyle(color: _codeKeyword)));
      } else if (_isPropertyName(code, match.start, text)) {
        spans.add(TextSpan(text: text, style: const TextStyle(color: _codeProperty)));
      } else if (_isAfterDot(code, match.start)) {
        spans.add(TextSpan(text: text, style: const TextStyle(color: _codeEnumValue)));
      } else {
        spans.add(TextSpan(text: text, style: const TextStyle(color: _codePlain)));
      }
    } else if (match.group(6) != null) {
      // Punctuation
      spans.add(TextSpan(text: text, style: const TextStyle(color: _codePunctuation)));
    } else {
      // Whitespace or other
      spans.add(TextSpan(text: text));
    }
  }

  return spans;
}

/// Check if this identifier is followed by `:` (named parameter).
bool _isPropertyName(String code, int start, String ident) {
  final afterEnd = start + ident.length;
  if (afterEnd >= code.length) return false;
  // Skip whitespace
  var i = afterEnd;
  while (i < code.length && code[i] == ' ') {
    i++;
  }
  return i < code.length && code[i] == ':';
}

/// Check if preceded by `.` (enum value or method call).
bool _isAfterDot(String code, int start) {
  if (start == 0) return false;
  var i = start - 1;
  while (i >= 0 && code[i] == ' ') {
    i--;
  }
  return i >= 0 && code[i] == '.';
}
