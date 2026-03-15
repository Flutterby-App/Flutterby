import 'package:flutter/material.dart';
import 'app.dart';
import 'services/persistence_service.dart';
import 'services/url_state_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PersistenceService.init();

  // Read URL state if on web
  String? initialWidgetId;
  Map<String, dynamic>? initialProperties;

  final fragment = UrlStateService.readFragment();
  if (fragment != null) {
    final decoded = UrlStateService.decode(fragment);
    if (decoded != null) {
      initialWidgetId = decoded.widgetId;
      initialProperties = decoded.properties;
    }
  }

  runApp(FlutterbyApp(
    initialWidgetId: initialWidgetId,
    initialProperties: initialProperties,
  ));
}
