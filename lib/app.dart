import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weeklet/app/di/injection_container.dart' as di;
import 'package:weeklet/presentation/blocs/expense/expense_cubit.dart';

import 'app/router/app_router.dart';
import 'app/theme/theme.dart';
import 'core/utils/scroll_behavior.dart';

class WeekletApp extends StatelessWidget {
  const WeekletApp({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider<ExpenseCubit>(
    create: (_) => di.sl<ExpenseCubit>()..refreshData(),

    child: MaterialApp.router(
      title: 'Weeklet',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      routerConfig: appRouter,
      builder: (context, child) => ScrollConfiguration(
        behavior: WeekletScrollBehavior(),
        child: child!,
      ),
    ),
  );
}
