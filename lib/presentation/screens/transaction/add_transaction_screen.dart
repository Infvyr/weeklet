import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:weeklet/app/di/injection_container.dart';
import 'package:weeklet/core/enums/category_enum.dart';
import 'package:weeklet/core/enums/transaction_type_enum.dart';
import 'package:weeklet/presentation/blocs/expense/expense_cubit.dart';
import 'package:weeklet/presentation/blocs/transaction_form/transaction_form_cubit.dart';
import 'package:weeklet/presentation/blocs/transaction_form/transaction_form_state.dart';
import 'package:weeklet/presentation/widgets/add_transaction_form.dart';

class AddTransactionScreen extends StatelessWidget {
  const AddTransactionScreen({super.key});

  final List<CategoryType> categories = CategoryType.values;
  final List<TransactionType> transactionTypes = TransactionType.values;

  @override
  Widget build(BuildContext rootContext) {
    final expenseCubit = rootContext.read<ExpenseCubit>();

    return BlocProvider<TransactionFormCubit>(
      create: (_) => sl<TransactionFormCubit>(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Add New Transaction')),
        body: BlocListener<TransactionFormCubit, TransactionFormState>(
          listener: (context, state) {
            if (state.status == FormStatus.success) {
              expenseCubit.refreshData();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Transaction successfully saved!')),
              );
              context.pop();
            }
            if (state.errorMessage != null && state.status == FormStatus.failure) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage.toString()),
                ),
              );
            }
          },
          child: AddTransactionForm(categories, transactionTypes),
        ),
      ),
    );
  }
}
