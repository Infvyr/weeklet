import 'package:flutter/material.dart';

class MonthYearFilter extends StatelessWidget {
  const MonthYearFilter({
    super.key,
    required this.selectedMonth,
    required this.selectedYear,
    required this.onMonthChanged,
    required this.onYearChanged,
  });

  final int selectedMonth;
  final int selectedYear;
  final ValueChanged<int?> onMonthChanged;
  final ValueChanged<int?> onYearChanged;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    color: const Color(0xFF1E222D), // Dark background matching design
    child: Row(
      children: [
        Expanded(
          flex: 2,
          child: _DropdownButton(
            value: selectedMonth,
            items: List.generate(12, (index) => index + 1),
            itemLabelBuilder: _getMonthName,
            onChanged: onMonthChanged,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 1,
          child: _DropdownButton(
            value: selectedYear,
            items: const [2024, 2025, 2026, 2027], // Dynamic later
            itemLabelBuilder: (value) => value.toString(),
            onChanged: onYearChanged,
          ),
        ),
      ],
    ),
  );

  String _getMonthName(int month) {
    const months = [
      'Ianuarie',
      'Februarie',
      'Martie',
      'Aprilie',
      'Mai',
      'Iunie',
      'Iulie',
      'August',
      'Septembrie',
      'Octombrie',
      'Noiembrie',
      'Decembrie',
    ];
    if (month < 1 || month > 12) return '';
    return months[month - 1];
  }
}

class _DropdownButton<T> extends StatelessWidget {
  const _DropdownButton({
    required this.value,
    required this.items,
    required this.itemLabelBuilder,
    required this.onChanged,
  });

  final T value;
  final List<T> items;
  final String Function(T) itemLabelBuilder;
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12),
    decoration: BoxDecoration(
      color: const Color(0xFF2A2E3B), // Slightly lighter implementation
      borderRadius: BorderRadius.circular(8),
    ),
    child: DropdownButtonHideUnderline(
      child: DropdownButton<T>(
        value: value,
        icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white70),
        dropdownColor: const Color(0xFF2A2E3B),
        style: const TextStyle(color: Colors.white),
        items: items
            .map(
              (item) => DropdownMenuItem<T>(
                value: item,
                child: Text(itemLabelBuilder(item)),
              ),
            )
            .toList(),
        onChanged: onChanged,
      ),
    ),
  );
}
