import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:weeklet/presentation/blocs/transaction_form/transaction_form_cubit.dart';

class DateField extends StatelessWidget {
  const DateField(
    this.cubit, {
    super.key,
    required this.date,
  });

  final TransactionFormCubit cubit;
  final DateTime date;

  @override
  Widget build(BuildContext context) => TextFormField(
    readOnly: true,
    decoration: InputDecoration(
      labelText: 'Date',
      prefixIcon: const Icon(Icons.calendar_today),
      border: const OutlineInputBorder(),
      hintText: DateFormat('dd.MM.yyyy').format(date),
    ),
    onTap: () async {
      final newDate = await showDatePicker(
        context: context,
        initialDate: date,
        firstDate: DateTime(2000),
        lastDate: DateTime.now().add(const Duration(days: 365 * 10)),
      );
      if (newDate != null) {
        cubit.setDate(newDate);
      }
    },
  );
}
