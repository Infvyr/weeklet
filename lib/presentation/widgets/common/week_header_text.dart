import 'package:flutter/material.dart';
import 'package:weeklet/core/extensions/context_extensions.dart';

/// Header text for displaying week number
class WeekHeaderText extends StatelessWidget {
  const WeekHeaderText({
    super.key,
    required this.weekNumber,
  });

  final int weekNumber;

  @override
  Widget build(BuildContext context) => Text(
    'Week $weekNumber',
    style: context.titleMedium?.copyWith(
      fontWeight: .w400,
      fontStyle: .italic,
      color: context.colorScheme.onSurfaceVariant,
    ),
  );
}
