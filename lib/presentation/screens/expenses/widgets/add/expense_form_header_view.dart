import 'package:flutter/material.dart';
import 'package:weeklet/core/extensions/context_extensions.dart';

class ExpenseFormHeaderView extends StatelessWidget {
  const ExpenseFormHeaderView({
    super.key,
    this.title = 'Add Expense',
    this.onClose,
  });

  final String title;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        title,
        style: context.titleLarge,
      ),
      IconButton(
        onPressed: onClose ?? () => context.pop(true),
        icon: Icon(
          Icons.close,
          color: context.colorScheme.onSurfaceVariant,
        ),
      ),
    ],
  );
}
