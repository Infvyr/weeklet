import 'package:flutter/material.dart';
import 'package:weeklet/core/extensions/date_time_extensions.dart';
import 'package:weeklet/core/extensions/locale_date_extesnions.dart';
import 'package:weeklet/core/utils/locale_manager.dart';
import 'package:weeklet/presentation/widgets/input_view.dart';
import 'package:weeklet/presentation/widgets/label_view.dart';

class ExpenseFormDateView extends StatefulWidget {
  const ExpenseFormDateView({super.key});

  @override
  State<ExpenseFormDateView> createState() => _ExpenseFormDateViewState();
}

class _ExpenseFormDateViewState extends State<ExpenseFormDateView> {
  DateTime? selectedDate;

  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      locale: LocaleManager().currentLocale,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      barrierDismissible: false,
    );

    if (pickedDate != null) {
      setState(() => selectedDate = pickedDate.toDateOnly());
    }
  }

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: .start,
    spacing: 8,
    children: [
      const LabelView(
        text: 'Date',
      ),
      InputView(
        hintText: selectedDate != null
            ? selectedDate!.format(style: DateFormatStyle.long)
            : LocaleDate.getFormattedDateInLocale(
                DateTime.now(),
                style: DateFormatStyle.long,
              ),
        readOnly: true,
        onTap: _selectDate,
      ),
    ],
  );
}
