import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

class DartPadService {
  /// Wraps widget source code in a runnable main.dart template.
  static String wrapInTemplate(String widgetSource) {
    final buf = StringBuffer();
    buf.writeln("import 'package:flutter/material.dart';");
    buf.writeln();
    buf.writeln('void main() {');
    buf.writeln('  runApp(const MyApp());');
    buf.writeln('}');
    buf.writeln();
    buf.writeln('class MyApp extends StatelessWidget {');
    buf.writeln('  const MyApp({super.key});');
    buf.writeln();
    buf.writeln('  @override');
    buf.writeln('  Widget build(BuildContext context) {');
    buf.writeln('    return MaterialApp(');
    buf.writeln("      title: 'Flutterby Preview',");
    buf.writeln('      theme: ThemeData(');
    buf.writeln('        colorSchemeSeed: Colors.indigo,');
    buf.writeln('        useMaterial3: true,');
    buf.writeln('      ),');
    buf.writeln('      home: const Scaffold(');
    buf.writeln('        body: Center(');
    buf.writeln('          child: Preview(),');
    buf.writeln('        ),');
    buf.writeln('      ),');
    buf.writeln('    );');
    buf.writeln('  }');
    buf.writeln('}');
    buf.writeln();
    buf.writeln('class Preview extends StatelessWidget {');
    buf.writeln('  const Preview({super.key});');
    buf.writeln();
    buf.writeln('  @override');
    buf.writeln('  Widget build(BuildContext context) {');
    buf.writeln('    return $widgetSource;');
    buf.writeln('  }');
    buf.writeln('}');
    return buf.toString();
  }

  /// Opens DartPad with the given source code pre-loaded.
  static Future<void> openInDartPad(String widgetSource) async {
    final fullSource = wrapInTemplate(widgetSource);
    // DartPad accepts code via a query parameter
    final encoded = base64Url.encode(utf8.encode(fullSource));
    final uri = Uri.parse('https://dartpad.dev/?code=$encoded');

    if (kIsWeb) {
      // On web, launch in a new tab
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      // On desktop/mobile, use url_launcher
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    }
  }
}
