import 'package:flutter/material.dart';
import 'package:weeklet/presentation/screens/expenses/widgets/add/export.dart';

class AddExpenseFormView extends StatefulWidget {
  const AddExpenseFormView({super.key});

  @override
  State<AddExpenseFormView> createState() => _AddExpenseFormViewState();
}

class _AddExpenseFormViewState extends State<AddExpenseFormView> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SingleChildScrollView(
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: 24,
      ),
      child: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: _formKey,
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 20,
          children: [
            ExpenseFormHeaderView(),
            ExpenseFormAmountView(),
            ExpenseFormDescriptionView(),
            ExpenseFormCategoryView(),
            ExpenseFormDateView(),
          ],
        ),
      ),
    ),
    bottomNavigationBar: const ExpenseFormSubmitView(),
  );
}
