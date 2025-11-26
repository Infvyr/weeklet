import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MonthYearSelector extends StatelessWidget {
  const MonthYearSelector({
    required this.currentYear,
    required this.currentMonth,
    required this.onDateChanged,
    super.key,
  });

  final int currentYear;
  final int currentMonth;
  final void Function(int year, int month) onDateChanged;

  @override
  Widget build(BuildContext context) {
    final years = List.generate(5, (i) => DateTime.now().year - 2 + i);
    final months = List.generate(12, (i) => i + 1);

    return Row(
      mainAxisAlignment: .spaceBetween,
      children: [
        DropdownButton<int>(
          value: currentYear,
          items: years
              .map(
                (year) => DropdownMenuItem(
                  value: year,
                  child: Text(
                    year.toString(),
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              )
              .toList(),
          onChanged: (newYear) {
            if (newYear != null) {
              onDateChanged(newYear, currentMonth);
            }
          },
        ),

        DropdownButton<int>(
          value: currentMonth,
          items: months.map((month) {
            final monthName = DateFormat.MMMM().format(
              DateTime(currentYear, month),
            );

            return DropdownMenuItem(
              value: month,
              child: Text(
                monthName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: .bold,
                ),
              ),
            );
          }).toList(),
          onChanged: (newMonth) {
            if (newMonth != null) {
              onDateChanged(currentYear, newMonth);
            }
          },
        ),
      ],
    );
  }
}
