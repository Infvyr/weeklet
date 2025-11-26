import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weeklet/core/enums/category_enum.dart';
import 'package:weeklet/core/enums/transaction_type_enum.dart';
import 'package:weeklet/presentation/blocs/transaction_form/transaction_form_cubit.dart';
import 'package:weeklet/presentation/blocs/transaction_form/transaction_form_state.dart';
import 'package:weeklet/presentation/widgets/add_transaction_amount.dart';
import 'package:weeklet/presentation/widgets/add_transaction_date.dart';
import 'package:weeklet/presentation/widgets/add_transaction_dropdown.dart';
import 'package:weeklet/presentation/widgets/add_transaction_notes.dart';
import 'package:weeklet/presentation/widgets/add_transaction_save_button.dart';
import 'package:weeklet/presentation/widgets/transaction_type_toggle.dart';

class AddTransactionForm extends StatefulWidget {
  const AddTransactionForm(
    this.categories,
    this.transactionTypes, {
    super.key,
  });

  final List<CategoryType> categories;
  final List<TransactionType> transactionTypes;

  @override
  State<AddTransactionForm> createState() => _AddTransactionFormState();
}

class _AddTransactionFormState extends State<AddTransactionForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final cubit = context.read<TransactionFormCubit>();
    if (cubit.state.category.isEmpty) {
      cubit.setCategory(widget.categories.first);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<TransactionFormCubit>();
    final state = context.watch<TransactionFormCubit>().state;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: .stretch,
          spacing: 15,
          children: [
            Align(
              alignment: Alignment.center,
              child: TransactionTypeToggle(
                cubit: cubit,
                transactionTypes: widget.transactionTypes,
                selectedTypeDbValue: state.type,
              ),
            ),
            const SizedBox(height: 10),

            AmountField(cubit),

            DateField(cubit, date: state.date),

            CategoryDropdown(
              cubit,
              categories: widget.categories,
              selectedCategoryDbValue: state.category,
            ),

            NotesField(cubit),

            const SizedBox(height: 15),

            SaveNewTransactionButton(
              isLoading: state.status == FormStatus.loading,
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  cubit.saveTransaction();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
