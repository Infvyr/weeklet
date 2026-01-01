import 'package:flutter/material.dart';
import 'package:weeklet/core/extensions/context_extensions.dart';
import 'package:weeklet/presentation/screens/expenses/widgets/add_expense_form_view.dart';

class ExpensesScreen extends StatelessWidget {
  const ExpensesScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      automaticallyImplyLeading: false,
      title: const Text('My Expenses'),
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
      tooltip: 'Add new expense',
      onPressed: () => showModalBottomSheet<void>(
        context: context,
        useRootNavigator: true,
        useSafeArea: true,
        isScrollControlled: true,
        showDragHandle: true,
        builder: (_) => SizedBox(
          height: context.screenHeight * 0.8,
          child: const AddExpenseFormView(),
        ),
      ),
      child: const Icon(Icons.add),
    ),
  );
}
