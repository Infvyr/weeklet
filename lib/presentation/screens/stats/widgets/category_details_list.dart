import 'package:flutter/material.dart';
import 'package:weeklet/core/utils/category_color_utils.dart';
import 'package:weeklet/domain/entities/statistics.dart';

class CategoryDetailsList extends StatelessWidget {
  const CategoryDetailsList({
    super.key,
    required this.categoryStats,
  });

  final List<CategoryStats> categoryStats;

  @override
  Widget build(BuildContext context) {
    if (categoryStats.isEmpty) return const SizedBox.shrink();

    return Card(
      color: const Color(0xFF1E222D),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Detalii categorii',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 16),
            ...categoryStats.map((stat) => _CategoryItem(stat: stat)),
          ],
        ),
      ),
    );
  }
}

class _CategoryItem extends StatelessWidget {
  const _CategoryItem({required this.stat});

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
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
              Text(
                '${stat.totalAmount.toStringAsFixed(2)} lei',
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: stat.percentage,
              backgroundColor: const Color(0xFF2A2E3B),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
}
