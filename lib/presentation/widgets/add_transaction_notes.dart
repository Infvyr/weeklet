import 'package:flutter/material.dart';
import 'package:weeklet/presentation/blocs/transaction_form/transaction_form_cubit.dart';

class NotesField extends StatelessWidget {
  const NotesField(this.cubit, {super.key});

  final TransactionFormCubit cubit;

  @override
  Widget build(BuildContext context) => TextFormField(
    decoration: const InputDecoration(
      labelText: 'Note (Optional)',
      prefixIcon: Icon(Icons.description),
      border: OutlineInputBorder(),
    ),
    maxLines: 2,
    onChanged: cubit.setNotes,
  );
}
