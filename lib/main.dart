import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:weeklet/core/di/service_locator.dart' as di;
import 'package:weeklet/core/utils/locale_manager.dart';

import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final locales = ui.PlatformDispatcher.instance.locales;
  final deviceLocale = locales.isNotEmpty
      ? locales.first
      : const Locale('en', 'US');
  LocaleManager().initialize(deviceLocale);

  await di.init();

  runApp(const WeekletApp());
}
