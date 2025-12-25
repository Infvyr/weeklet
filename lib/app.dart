import 'package:flutter/material.dart';
import 'package:weeklet/core/theme/theme.dart';

import 'core/router/app_routes.dart';
import 'core/utils/scroll_behavior.dart';

class WeekletApp extends StatelessWidget {
  const WeekletApp({super.key});

  @override
  Widget build(
    BuildContext context,
  ) => MaterialApp(
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
