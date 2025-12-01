import 'package:flutter/material.dart';
import 'package:weeklet/core/extensions/context_extensions.dart';

class NoIconsFoundView extends StatelessWidget {
  const NoIconsFoundView({
    required this.searchTerm,
    super.key,
  });

  final String searchTerm;

  @override
  Widget build(BuildContext context) => Center(
    child: Text(
      'No icons found for "$searchTerm"',
      style: context.textTheme.bodyLarge,
    ),
  );
}
