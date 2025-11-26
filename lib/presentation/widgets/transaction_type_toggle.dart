import 'package:flutter/material.dart';
import 'package:weeklet/core/enums/transaction_type_enum.dart';
import 'package:weeklet/presentation/blocs/transaction_form/transaction_form_cubit.dart';

class TransactionTypeToggle extends StatelessWidget {
  const TransactionTypeToggle({
    required this.cubit,
    required this.transactionTypes,
    required this.selectedTypeDbValue,
    super.key,
  });

  final TransactionFormCubit cubit;
  final List<TransactionType> transactionTypes;
  final String selectedTypeDbValue;

  @override
  Widget build(BuildContext context) {
    final Map<TransactionType, Widget> children = {
      for (final type in transactionTypes)
        type: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            type.displayName,
            style: TextStyle(
              color: type == TransactionType.income
                  ? Colors.green.shade700
                  : Colors.red.shade700,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
    };

    final currentType = transactionTypes.firstWhere(
      (e) => e.dbValue == selectedTypeDbValue,
      orElse: () => transactionTypes.first,
    );

    return Column(
      crossAxisAlignment: .start,
      spacing: 8,
      children: [
        const Text(
          'Transaction type',
          style: TextStyle(
            fontSize: 16,
            fontWeight: .w600,
          ),
        ),
        Center(
          child: SegmentedButton<TransactionType>(
            segments: children.entries
                .map(
                  (entry) => ButtonSegment<TransactionType>(
                    value: entry.key,
                    label: entry.value,
                  ),
                )
                .toList(),
            selected: {currentType},
            onSelectionChanged: (newSelection) {
              if (newSelection.isNotEmpty) {
                cubit.setType(newSelection.first);
              }
            },
          ),
        ),
      ],
    );
  }
}
