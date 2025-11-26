import 'package:flutter/material.dart';
import 'package:weeklet/presentation/blocs/transaction_form/transaction_form_cubit.dart';

class AmountField extends StatelessWidget {
  const AmountField(
    this.cubit, {
    super.key,
  });

  final TransactionFormCubit cubit;

  @override
  Widget build(BuildContext context) => TextFormField(
    keyboardType: const TextInputType.numberWithOptions(decimal: true),
    decoration: const InputDecoration(
      labelText: 'Amount',
      hintText: 'Ex: 150.50',
      prefixIcon: Icon(Icons.attach_money),
      border: OutlineInputBorder(),
    ),
    onChanged: (value) {
      final amount = double.tryParse(value) ?? 0.0;
      cubit.setAmount(amount);
    },
    validator: (value) {
      if (value == null ||
          double.tryParse(value) == null ||
          double.tryParse(value)! <= 0) {
        return 'Amount must be > 0';
      }
      return null;
    },
  );
}
