import 'package:flutter/material.dart';

import 'package:weeklet/presentation/widgets/common/empty_state_view.dart';

class StatsEmptyView extends StatelessWidget {
  const StatsEmptyView({super.key});

  @override
  Widget build(BuildContext context) => const Padding(
    padding: EdgeInsets.symmetric(vertical: 40.0),
    child: EmptyStateView(
      icon: Icons.query_stats_outlined,
      title: 'No stats available',
      subtitle: 'Add some income or expenses to see your statistics',
    ),
  );
}
