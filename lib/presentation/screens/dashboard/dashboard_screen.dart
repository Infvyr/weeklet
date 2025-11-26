import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weeklet/app/di/injection_container.dart';
import 'package:weeklet/presentation/blocs/expense/expense_cubit.dart';

import 'dashboard_view.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider<ExpenseCubit>(
    create: (context) => sl<ExpenseCubit>()
      ..loadMonthlySummary(
        DateTime.now().year,
        DateTime.now().month,
      ),
    child: const DashboardView(),
  );
}
