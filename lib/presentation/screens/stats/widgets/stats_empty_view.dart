import 'package:flutter/material.dart';
import 'package:weeklet/core/extensions/context_extensions.dart';

class StatsEmptyView extends StatelessWidget {
  const StatsEmptyView({super.key});

  @override
  Widget build(BuildContext context) => Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    child: SizedBox(
      height: 300,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.info_outline,
            size: 48,
            color: context.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
          ),
          const SizedBox(height: 16),
          Text(
            'No data available',
            style: context.bodyMedium?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'No transactions recorded for this period',
            style: context.bodySmall?.copyWith(
              color: context.colorScheme.onSurfaceVariant
                  .withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}
