import 'package:flutter/material.dart';
import 'package:weeklet/core/constants/app_constants.dart';
import 'package:weeklet/core/di/service_locator.dart';
import 'package:weeklet/core/extensions/context_extensions.dart';
import 'package:weeklet/core/utils/number_formatter.dart';
import 'package:weeklet/domain/entities/income.dart';
import 'package:weeklet/presentation/blocs/income/income_bloc.dart';
import 'package:weeklet/presentation/blocs/income/income_event.dart';
import 'package:weeklet/presentation/screens/income/widgets/edit_income_form_view/edit_income_form_view.dart';
import 'package:weeklet/presentation/widgets/common/common_menu_button.dart';
import 'package:weeklet/presentation/widgets/common/deletion_dialog/deletion_dialog.dart';
import 'package:weeklet/presentation/widgets/common/expense_amount_text.dart';
import 'package:weeklet/presentation/widgets/common/expense_details_column.dart';

class IncomeItemView extends StatelessWidget {
  const IncomeItemView({
    super.key,
    required this.income,
    this.currencySymbol = AppConstants.DEFAULT_CURRENCY,
  });

  final Income income;
  final String currencySymbol;

  void _deleteIncome(BuildContext context) {
    sl<IncomeBloc>().add(DeleteIncomeStarted(income.id));
  }

  void _editIncome(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      useSafeArea: true,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => SizedBox(
        height: context.screenHeight * 0.8,
        child: EditIncomeFormView(income),
      ),
    );
  }

  List<MenuItem> _buildMenuItems(BuildContext context) => [
    MenuItem(
      label: 'Edit',
      icon: Icons.edit,
      onPressed: () => _editIncome(context),
      semanticLabel: 'Edit income',
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
        title: 'Delete income?',
        subtitle1: 'Are you sure you want to delete',
        subtitle1AccentText: ' ${income.description.isNotEmpty ? income.description : 'this income'}?',
        subtitle2: 'This action cannot be undone.',
        confirmButtonColor: context.colorScheme.error,
        onConfirm: () => _deleteIncome(context),
        confirmButtonTextColor: Colors.white,
        cancelButtonColor: context.colorScheme.outline,
        cancelButtonTextColor: context.colorScheme.onSurface,
      ),
      semanticLabel: 'Delete income',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final formattedAmount = NumberFormatter.formatCurrencyWithSign(
      income.amount,
      currencySymbol,
      isIncome: true,
    );
    final formattedTime = NumberFormatter.formatTime(income.createdAt);

    return Padding(
      padding: const .symmetric(vertical: 8),
      child: Row(
        spacing: 12,
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: Colors.green.withValues(alpha: 0.15),
            child: const Icon(
              Icons.account_balance_wallet,
              size: 22,
              color: Colors.green,
            ),
          ),
          Expanded(
            child: ExpenseDetailsColumn(
              description: income.description.isNotEmpty
                  ? income.description
                  : 'Income',
              categoryName: 'Income',
              time: formattedTime,
            ),
          ),
          ExpenseAmountText(
            formattedAmount: formattedAmount,
            isIncome: true,
          ),
          CommonMenuButton(menuItems: _buildMenuItems(context)),
        ],
      ),
    );
  }
}
