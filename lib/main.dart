import 'package:flutter/material.dart';
import 'package:weeklet/app/injection_container.dart' as di;

import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependencies
  await di.init();

  runApp(const WeekletApp());
}
