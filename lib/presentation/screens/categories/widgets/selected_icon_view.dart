import 'package:flutter/material.dart';
import 'package:weeklet/core/constants/category_icons.dart';
import 'package:weeklet/core/extensions/context_extensions.dart';
import 'package:weeklet/presentation/widgets/label_view.dart';

class SelectedIconView extends StatelessWidget {
  const SelectedIconView({
    super.key,
    required this.selectedIcon,
    this.categoryName,
  });

  final CategoryIcon? selectedIcon;
  final String? categoryName;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: .start,
    spacing: 8,
    children: [
      const LabelView(
        text: 'Selected Icon',
      ),
      Card(
        margin: EdgeInsets.zero,
        semanticContainer: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: context.colorScheme.outline,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            spacing: 12,
            children: [
              _SelectedIcon(selectedIcon),
              _SelectedIconMeta(selectedIcon, categoryName),
            ],
          ),
        ),
      ),
    ],
  );
}

class _SelectedIcon extends StatelessWidget {
  const _SelectedIcon(
    this.categoryIcon, {
    Key? key,
  }) : super(key: key);

  final CategoryIcon? categoryIcon;

  @override
  Widget build(BuildContext context) => Ink(
    width: 40,
    height: 40,
    decoration: BoxDecoration(
      color: context.colorScheme.primary,
      borderRadius: BorderRadius.circular(6),
    ),
    child: Icon(
      categoryIcon?.icon ?? Icons.help_outline,
      size: 24,
      color: Colors.white,
      semanticLabel: 'Selected icon preview',
    ),
  );
}

class _SelectedIconMeta extends StatelessWidget {
  const _SelectedIconMeta(
    this.categoryIcon,
    this.categoryName, {
    Key? key,
  }) : super(key: key);

  final CategoryIcon? categoryIcon;
  final String? categoryName;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: .start,
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
