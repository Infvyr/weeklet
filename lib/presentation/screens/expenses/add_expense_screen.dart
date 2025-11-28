import 'package:flutter/material.dart';

class AddExpenseScreen extends StatelessWidget {
  const AddExpenseScreen({super.key});

  @override
  Widget build(BuildContext rootContext) => Scaffold(
    appBar: AppBar(
      title: const Text('Add new expense'),
    ),
    body: const Center(
      child: Text('Add expense'),
    ),
  );
}
