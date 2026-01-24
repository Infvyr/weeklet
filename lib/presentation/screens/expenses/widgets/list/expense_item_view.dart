import 'package:flutter/material.dart';
import 'package:weeklet/core/di/service_locator.dart';
import 'package:weeklet/core/extensions/context_extensions.dart';
import 'package:weeklet/core/utils/number_formatter.dart';
import 'package:weeklet/domain/entities/category.dart';
import 'package:weeklet/domain/entities/expense.dart';
import 'package:weeklet/presentation/blocs/expense/expense_bloc.dart';
import 'package:weeklet/presentation/blocs/expense/expense_event.dart';
import 'package:weeklet/presentation/widgets/common/category_icon_circle.dart';
import 'package:weeklet/presentation/widgets/common/common_menu_button.dart';
import 'package:weeklet/presentation/widgets/common/deletion_dialog.dart';
import 'package:weeklet/presentation/widgets/common/expense_amount_text.dart';
import 'package:weeklet/presentation/widgets/common/expense_details_column.dart';

class ExpenseItemView extends StatelessWidget {
  const ExpenseItemView({
    super.key,
    required this.expense,
    required this.category,
    this.currencySymbol = 'lei',
    this.isIncome = false,
  });

  final Expense expense;
  final Category? category;
  final String currencySymbol;
  final bool isIncome;

  void _deleteExpense(BuildContext context) {
    sl<ExpenseBloc>().add(DeleteExpenseStarted(expense.id));
  }

  void _editExpense(BuildContext context) {
    // TODO: Implement edit expense screen navigation
  }

  List<MenuItem> _buildMenuItems(BuildContext context) => [
    MenuItem(
      label: 'Edit',
      icon: Icons.edit,
      onPressed: () => _editExpense(context),
      semanticLabel: 'Edit expense',
    ),
    MenuItem(
      label: 'Delete',
      icon: Icons.delete,
      iconColor: context.colorScheme.error,
      textColor: context.colorScheme.error,
      overlayColor: context.colorScheme.error,
      onPressed: () => CustomConfirmationDialog.show(
        context: context,
        icon: Icons.delete,
        iconBackgroundColor: context.colorScheme.error,
        title: 'Delete expense?',
        subtitle1: 'Are you sure you want to delete',
        subtitle1AccentText: ' ${expense.description}?',
        subtitle2: 'This action cannot be undone.',
        confirmButtonColor: context.colorScheme.error,
        onConfirm: () => _deleteExpense(context),
        confirmButtonTextColor: Colors.white,
        cancelButtonColor: context.colorScheme.outline,
        cancelButtonTextColor: context.colorScheme.onSurface,
      ),
      semanticLabel: 'Delete expense',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final formattedAmount = NumberFormatter.formatCurrencyWithSign(
      expense.amount,
      currencySymbol,
      isIncome: isIncome,
    );
    final formattedTime = NumberFormatter.formatTime(expense.createdAt);

    return Padding(
      padding: const .symmetric(vertical: 8),
      child: Row(
        children: [
          CategoryIconCircle(
            category: category,
            iconSize: 22,
            useTransparentBackground: true,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ExpenseDetailsColumn(
              description: expense.description,
              categoryName: category?.name ?? 'Unknown',
              time: formattedTime,
            ),
          ),
          ExpenseAmountText(
            formattedAmount: formattedAmount,
            isIncome: isIncome,
          ),
          CommonMenuButton(menuItems: _buildMenuItems(context)),
        ],
      ),
    );
  }
}
