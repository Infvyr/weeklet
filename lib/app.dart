import 'package:flutter/material.dart';

import 'app/router/app_router.dart';
import 'app/theme/theme.dart';
import 'core/utils/scroll_behavior.dart';

class WeekletApp extends StatelessWidget {
  const WeekletApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp.router(
    title: 'Weeklet',
    debugShowCheckedModeBanner: false,
    theme: AppTheme.lightTheme,
    darkTheme: AppTheme.darkTheme,
    routerConfig: appRouter,
    builder: (context, child) => ScrollConfiguration(
      behavior: WeekletScrollBehavior(),
      child: child!,
    ),
  );
}
