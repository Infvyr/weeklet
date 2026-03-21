import 'package:flutter/material.dart';
import 'package:weeklet/presentation/widgets/common/empty_state_view.dart';

class CategoriesEmptyView extends StatelessWidget {
  const CategoriesEmptyView({super.key});

  @override
  Widget build(BuildContext context) => const EmptyStateView(
    icon: Icons.category_outlined,
    title: 'No categories yet',
    subtitle: 'Tap + to add your first category',
  );
}
