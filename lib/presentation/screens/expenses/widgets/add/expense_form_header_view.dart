import 'package:flutter/material.dart';
import 'package:weeklet/core/extensions/context_extensions.dart';

class ExpenseFormHeaderView extends StatelessWidget {
  const ExpenseFormHeaderView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: .spaceBetween,
    children: [
      Text(
        'Add Expense',
        style: context.titleLarge,
      ),
      IconButton(
        onPressed: () => context.pop(true),
        icon: Icon(
          Icons.close,
          color: context.colorScheme.onSurfaceVariant,
        ),
      ),
    ],
  );
}
