import 'package:flutter/material.dart';
import 'package:weeklet/core/extensions/date_time_extensions.dart';
import 'package:weeklet/core/utils/date_picker_config.dart';
import 'package:weeklet/core/utils/locale_manager.dart';
import 'package:weeklet/presentation/widgets/input_view.dart';
import 'package:weeklet/presentation/widgets/label_view.dart';

class ExpenseFormDateView extends StatelessWidget {
  const ExpenseFormDateView({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
    this.errorText,
  });
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onDateSelected;
  final String? errorText;

  Future<void> _selectDate(BuildContext context) async {
    final pickedDate = await DatePickerConfig.showExpenseDatePicker(
      context,
      initialDate: selectedDate,
      locale: LocaleManager().currentLocale,
    );

    if (pickedDate != null) {
      onDateSelected(pickedDate.toDateOnly());
    }
  }

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: .start,
    spacing: 8,
    children: [
      const LabelView(text: 'Date'),
      InputView(
        hintText: selectedDate != null
            ? selectedDate!.format(style: .long)
            : 'Select date',
        readOnly: true,
        onTap: () => _selectDate(context),
        errorText: errorText,
        suffixIcon: const Icon(Icons.calendar_today_outlined, size: 20),
      ),
    ],
  );
}
