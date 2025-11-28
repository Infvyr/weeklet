import 'package:flutter/material.dart';
import 'package:weeklet/app/router/app_routes.dart';
import 'package:weeklet/core/extensions/context_extensions.dart';

class ExpensesView extends StatelessWidget {
  const ExpensesView({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      automaticallyImplyLeading: false,
      title: const Text('Expenses'),
    ),
    body: const SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: .start,
        spacing: 20,
        children: [
          Text('Widgets here'),
        ],
      ),
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: () => context.pushNamed(AppRoutes.addExpenseScreen),
      child: const Icon(Icons.add),
    ),
  );
}
