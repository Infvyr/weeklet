import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weeklet/core/di/service_locator.dart';
import 'package:weeklet/core/theme/colors.dart';
import 'package:weeklet/presentation/blocs/stats/stats_bloc.dart';
import 'package:weeklet/presentation/blocs/stats/stats_event.dart';
import 'package:weeklet/presentation/blocs/stats/stats_state.dart';
import 'package:weeklet/presentation/blocs/stats/stats_tab.dart';
import 'package:weeklet/presentation/screens/stats/widgets/category_details_list.dart';
import 'package:weeklet/presentation/screens/stats/widgets/category_distribution_chart.dart';
import 'package:weeklet/presentation/screens/stats/widgets/stats_filter_bar.dart';
import 'package:weeklet/presentation/screens/stats/widgets/stats_summary_cards.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => sl<StatsBloc>()
      ..add(
        LoadMonthlyStats(
          month: DateTime.now().month,
          year: DateTime.now().year,
        ),
      ),
    child: const StatsView(),
  );
}

class StatsView extends StatelessWidget {
  const StatsView({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.darkBackground,
    appBar: AppBar(
      title: const Text('Statistics', style: TextStyle(color: Colors.white)),
      backgroundColor: AppColors.darkPrimaryColor,
      elevation: 0,
      centerTitle: false,
    ),
    body: BlocBuilder<StatsBloc, StatsState>(
      builder: (context, state) {
        if (state is StatsLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is StatsError) {
          return Center(
            child: Text(
              'Error: ${state.message}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }
        if (state is MonthlyStatsLoaded) {
          return CustomScrollView(
            slivers: [
              SliverPersistentHeader(
                pinned: true,
                delegate: _StickyFilterHeaderDelegate(
                  child: const StatsFilterBar(),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    spacing: 16,
                    children: [
                      StatsSummaryCards(stats: state.stats),
                      _TabsSection(currentTab: state.currentTab),
                      if (state.currentTab == StatsTab.monthly) ...[
                        CategoryDistributionChart(
                          categoryStats: state.stats.categoryStats,
                        ),
                        CategoryDetailsList(
                          categoryStats: state.stats.categoryStats,
                        ),
                      ] else
                        const _AnnualStatsPlaceholder(),
                    ],
                  ),
                ),
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    ),
  );
}

class _StickyFilterHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _StickyFilterHeaderDelegate({required this.child});

  @override
  double get minExtent => 70;
  @override
  double get maxExtent => 70;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) => Container(
    color: AppColors.darkBackground,
    child: child,
  );

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}

class _TabsSection extends StatelessWidget {
  const _TabsSection({required this.currentTab});

  final StatsTab currentTab;

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: AppColors.darkSurface,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      children: [
        Expanded(
          child: _TabButton(
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
          child: _TabButton(
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

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.darkPrimaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.white70,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}

class _AnnualStatsPlaceholder extends StatelessWidget {
  const _AnnualStatsPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Center(
        child: Text(
          'Annual Evolution Chart\n(Coming Soon)',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
