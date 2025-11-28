import 'package:flutter/material.dart';

import 'app/router/app_routes.dart';
import 'app/theme/theme.dart';
import 'core/utils/scroll_behavior.dart';

class WeekletApp extends StatelessWidget {
  const WeekletApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Weeklet',
    debugShowCheckedModeBanner: false,
    theme: AppTheme.lightTheme,
    darkTheme: AppTheme.darkTheme,
    onGenerateRoute: AppRoutes.onGenerateRoute,
    initialRoute: AppRoutes.home,
    builder: (context, child) => ScrollConfiguration(
      behavior: WeekletScrollBehavior(),
      child: child!,
    ),
  );
}
