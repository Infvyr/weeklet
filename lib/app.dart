import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart'
    show
        GlobalMaterialLocalizations,
        GlobalWidgetsLocalizations,
        GlobalCupertinoLocalizations;
import 'package:weeklet/core/di/service_locator.dart' show sl;
import 'package:weeklet/core/theme/theme.dart';
import 'package:weeklet/core/utils/locale_manager.dart';
import 'package:weeklet/presentation/app_initializer.dart';
import 'package:weeklet/presentation/blocs/category/category_bloc.dart';
import 'package:weeklet/presentation/blocs/expense/expense_bloc.dart';
import 'package:weeklet/presentation/blocs/income/income_bloc.dart';
import 'package:weeklet/presentation/blocs/stats/stats_bloc.dart';

import 'core/router/app_routes.dart';
import 'core/utils/scroll_behavior.dart';

class WeekletApp extends StatelessWidget {
  const WeekletApp({super.key});

  @override
  Widget build(
    BuildContext context,
  ) => MultiBlocProvider(
    providers: [
      BlocProvider<CategoryBloc>.value(value: sl<CategoryBloc>()),
      BlocProvider<ExpenseBloc>.value(value: sl<ExpenseBloc>()),
      BlocProvider<IncomeBloc>.value(value: sl<IncomeBloc>()),
      BlocProvider<StatsBloc>.value(value: sl<StatsBloc>()),
    ],
    child: AppInitializer(
      child: MaterialApp(
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
        locale: LocaleManager().currentLocale,
        supportedLocales: LocaleManager.supportedLocales,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
      ),
    ),
  );
}
