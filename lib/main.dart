import 'package:flutter/material.dart';
import 'package:weeklet/core/di/service_locator.dart' as di;

import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const WeekletApp());
}
