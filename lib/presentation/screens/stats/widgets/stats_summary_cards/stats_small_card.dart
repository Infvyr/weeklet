import 'package:flutter/material.dart';
import 'package:weeklet/core/extensions/context_extensions.dart';
import 'package:weeklet/core/utils/number_formatter.dart';

class StatsSmallCard extends StatelessWidget {
  const StatsSmallCard({
    super.key,
    required this.title,
    required this.amount,
    required this.percentage,
    required this.isIncome,
    required this.isAnnual,
    required this.icon,
    required this.currencySymbol,
  });

  final String title;
  final double amount;
  final double percentage;
  final bool isIncome;
  final bool isAnnual;
  final IconData icon;
  final String currencySymbol;

  @override
  Widget build(BuildContext context) {
    final isPositive = percentage >= 0;
    final percentageColor = isPositive ? Colors.green : Colors.red;
    final percentageIcon = isPositive
        ? Icons.call_made
        : Icons.call_received; // Arrow up/down

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: context.colorScheme.onSurfaceVariant),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: context.bodySmall?.copyWith(
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),

          Text(
            NumberFormatter.formatCompactWithSign(
              amount,
              currencySymbol,
              isIncome: isIncome,
            ),
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: isIncome ? Colors.green : context.colorScheme.onSurface,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
          ),

          Row(
            children: [
              Icon(percentageIcon, size: 12, color: percentageColor),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  '${(percentage * 100).abs().toStringAsFixed(1)}% ${isAnnual ? 'vs last year' : 'vs last month'}',
                  overflow: TextOverflow.ellipsis,
                  style: context.bodySmall?.copyWith(color: percentageColor),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
