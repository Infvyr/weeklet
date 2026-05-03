import 'package:flutter/material.dart';
import 'package:weeklet/core/extensions/date_time_extensions.dart';
import 'package:weeklet/core/utils/date_picker_config.dart';
import 'package:weeklet/core/utils/locale_manager.dart';
import 'package:weeklet/l10n/app_localizations.dart';
import 'package:weeklet/presentation/widgets/input_view.dart';
import 'package:weeklet/presentation/widgets/label_view.dart';

class DateFieldView extends StatelessWidget {
  const DateFieldView({
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
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        LabelView(text: l10n.dateFieldLabel),
        InputView(
          hintText: selectedDate != null
              ? selectedDate!.format(style: .long)
              : l10n.dateFieldHint,
          readOnly: true,
          onTap: () => _selectDate(context),
          errorText: errorText,
          suffixIcon: const Icon(Icons.calendar_today_outlined, size: 20),
        ),
      ],
    );
  }
}
