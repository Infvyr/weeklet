import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weeklet/domain/entities/transaction.dart';

class RecentTransactionsList extends StatelessWidget {
  const RecentTransactionsList({
    required this.transactions,
    super.key,
  });

  final List<Transaction> transactions;

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return const SizedBox();
    }

    final displayTransactions = transactions.take(5).toList();
    final formatter = NumberFormat.currency(locale: 'ro_RO', symbol: ' MDL');
    final dateFormatter = DateFormat('dd MMM');

    return Card(
      elevation: 4,
      child: Column(
        crossAxisAlignment: .start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 16.0, left: 16.0),
            child: Text(
              'Recent Transactions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: .bold,
              ),
            ),
          ),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: displayTransactions.length,
            itemBuilder: (context, index) {
              final tx = displayTransactions[index];
              final isExpense = tx.type == 'Expense';

              return ListTile(
                leading: Icon(
                  isExpense ? Icons.arrow_downward : Icons.arrow_upward,
                  color: isExpense ? Colors.red : Colors.green,
                ),
                title: Text(tx.category),
                subtitle: Text(dateFormatter.format(tx.date)),
                trailing: Text(
                  formatter.format(tx.amount),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: isExpense ? Colors.red[600] : Colors.green[600],
                  ),
                ),
                onTap: () {
                  // context.go('/editTx/${tx.id}')
                },
              );
            },
          ),

          if (transactions.length > 5)
            TextButton(
              onPressed: () {
                // context.go(AppRoute.journal.path);
              },
              child: const Text('View all transactions'),
            ),
        ],
      ),
    );
  }
}
