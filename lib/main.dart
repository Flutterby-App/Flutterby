import 'package:flutter/material.dart';
import 'app.dart';
import 'services/persistence_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PersistenceService.init();
  runApp(const FlutterbyApp());
}
