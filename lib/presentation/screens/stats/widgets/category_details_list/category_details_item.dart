import 'package:flutter/material.dart';
import 'package:weeklet/core/constants/app_constants.dart';
import 'package:weeklet/core/extensions/context_extensions.dart';
import 'package:weeklet/core/utils/category_color_utils.dart';
import 'package:weeklet/core/utils/number_formatter.dart';
import 'package:weeklet/domain/entities/statistics.dart';

class CategoryDetailsItem extends StatelessWidget {
  const CategoryDetailsItem({super.key, required this.stat});

  final CategoryStats stat;

  @override
  Widget build(BuildContext context) {
    // Use the utility for consistent colors
    final color = CategoryColorUtils.getColor(stat.category.name);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  stat.category.name,
                  style: context.bodyMedium,
                ),
              ),
              Text(
                NumberFormatter.formatCurrency(
                  stat.totalAmount,
                  AppConstants.DEFAULT_CURRENCY,
                ),
                style: context.bodyMedium,
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: stat.percentage,
              backgroundColor: context.colorScheme.outline,
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
}
