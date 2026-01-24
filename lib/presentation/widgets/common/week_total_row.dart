import 'package:flutter/material.dart';
import 'package:weeklet/core/extensions/context_extensions.dart';

/// Row displaying weekly total with label and formatted amount
class WeekTotalRow extends StatelessWidget {
  const WeekTotalRow({
    super.key,
    required this.formattedTotal,
  });

  final String formattedTotal;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: .spaceBetween,
    children: [
      Text(
        'Total week',
        style: context.bodyMedium?.copyWith(
          color: context.colorScheme.onSurfaceVariant,
        ),
      ),
      Text(
        formattedTotal,
        style: context.bodyLarge?.copyWith(
          fontWeight: .w600,
          color: context.colorScheme.primary,
        ),
      ),
    ],
  );
}
