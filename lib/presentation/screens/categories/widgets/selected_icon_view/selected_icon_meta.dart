import 'package:flutter/material.dart';
import 'package:weeklet/core/constants/category_icons.dart';
import 'package:weeklet/core/extensions/context_extensions.dart';

class SelectedIconMeta extends StatelessWidget {
  const SelectedIconMeta(
    this.categoryIcon,
    this.categoryName, {
    super.key,
  });

  final CategoryIcon? categoryIcon;
  final String? categoryName;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        categoryIcon?.label ?? 'No icon selected',
        style: context.textTheme.bodyMedium,
      ),
      Text(
        categoryName?.isNotEmpty == true
            ? categoryName!
            : 'Category name not set',
        style: context.textTheme.bodySmall?.copyWith(
          color: context.colorScheme.onSurfaceVariant,
        ),
      ),
    ],
  );
}
