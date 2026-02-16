import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weeklet/core/extensions/context_extensions.dart';
import 'package:weeklet/domain/utils/expense_filter_utils.dart';
import 'package:weeklet/presentation/blocs/stats/stats_bloc.dart';
import 'package:weeklet/presentation/blocs/stats/stats_event.dart';
import 'package:weeklet/presentation/blocs/stats/stats_state.dart';
import 'package:weeklet/presentation/widgets/common/common_dropdown_button.dart';

class StatsFilterBar extends StatelessWidget {
  const StatsFilterBar({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<StatsBloc>().state;

    if (state is! MonthlyStatsLoaded) {
      return const SizedBox.shrink();
    }

    // Generate years for now, ideally this comes from AvailableYears/Months logic
    // similar to ExpenseBloc, but for now we stick to fixed list or current year
    // extended.
    final List<int> years = List.generate(
      5,
      (index) => DateTime.now().year - 2 + index,
    );
    final List<int> months = List.generate(12, (index) => index + 1);

    return Container(
      color: context.colorScheme.surface,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        spacing: 12,
        children: [
          // Month Dropdown
          Expanded(
            child: CommonDropdownButton<int>(
              items: months,
              selectedItem: state.month,
              itemBuilder: (month) => Text(
                ExpenseFilterUtils.getMonthName(month),
              ),
              hint: 'Select Month',
              onChanged: (month) {
                if (month != null) {
                  context.read<StatsBloc>().add(
                    LoadMonthlyStats(
                      month: month,
                      year: state.year,
                    ),
                  );
                }
              },
            ),
          ),

          // Year Dropdown
          Expanded(
            child: CommonDropdownButton<int>(
              items: years,
              selectedItem: state.year,
              itemBuilder: (year) => Text(year.toString()),
              hint: 'Select Year',
              onChanged: (year) {
                if (year != null) {
                  context.read<StatsBloc>().add(
                    LoadMonthlyStats(
                      month: state.month,
                      year: year,
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
