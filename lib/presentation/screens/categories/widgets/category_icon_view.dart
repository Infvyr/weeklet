import 'package:flutter/material.dart';
import 'package:weeklet/core/extensions/context_extensions.dart';
import 'package:weeklet/core/utils/icons_utils.dart';

class CategoryIconView extends StatelessWidget {
  const CategoryIconView({
    super.key,
    required this.iconString,
    required this.isSelected,
    required this.onSelected,
  });

  final String iconString;
  final bool isSelected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    final selectedBgColor = context.colorScheme.primary;
    final unselectedBgColor = context.colorScheme.outline;
    final iconColor = isSelected
        ? context.colorScheme.onPrimary
        : context.colorScheme.onSurfaceVariant;

    return IconButton(
      onPressed: onSelected,
      icon: Icon(
        getIconDataFromString(iconString),
        size: 32,
        color: iconColor,
      ),
      color: context.colorScheme.secondary,
      style: IconButton.styleFrom(
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        side: BorderSide(
          color: context.colorScheme.outline,
        ),
        backgroundColor: isSelected ? selectedBgColor : unselectedBgColor,
      ),
    );
  }
}
