import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weeklet/core/extensions/context_extensions.dart';
import 'package:weeklet/presentation/blocs/stats/stats_bloc.dart';
import 'package:weeklet/presentation/blocs/stats/stats_event.dart';
import 'package:weeklet/presentation/blocs/stats/stats_tab.dart';

class StatsTabsSection extends StatelessWidget {
  const StatsTabsSection({
    super.key,
    required this.currentTab,
  });

  final StatsTab currentTab;

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: context.colorScheme.surface,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      children: [
        Expanded(
          child: StatsTabButton(
            title: 'Monthly',
            isSelected: currentTab == StatsTab.monthly,
            onTap: () {
              context.read<StatsBloc>().add(
                const ChangeStatsTab(StatsTab.monthly),
              );
            },
          ),
        ),
        Expanded(
          child: StatsTabButton(
            title: 'Annual Evolution',
            isSelected: currentTab == StatsTab.annual,
            onTap: () {
              context.read<StatsBloc>().add(
                const ChangeStatsTab(StatsTab.annual),
              );
            },
          ),
        ),
      ],
    ),
  );
}

class StatsTabButton extends StatelessWidget {
  const StatsTabButton({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: isSelected ? context.colorScheme.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            color: isSelected
                ? context.colorScheme.onPrimary
                : context.colorScheme.onSurfaceVariant,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    ),
  );
}
