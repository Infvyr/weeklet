import 'package:flutter/services.dart'
    show TextInputAction, FilteringTextInputFormatter;
import 'package:flutter/widgets.dart';
import 'package:weeklet/presentation/widgets/input_view.dart';
import 'package:weeklet/presentation/widgets/label_view.dart';

class ExpenseFormAmountView extends StatelessWidget {
  const ExpenseFormAmountView({super.key});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: .start,
    spacing: 8,
    children: [
      const LabelView(
        text: 'Amount (MDL)', // TODO: set currency based on user preference
      ),
      InputView(
        // controller: controller,
        hintText: '0.00',
        keyboardType: const TextInputType.numberWithOptions(
          decimal: true,
        ),
        textInputAction: TextInputAction.next,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*')),
        ],
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'This field is required';
          }

          // Regex that checks:
          // ^[0-9]+  -> must start with at least one digit (prevents .5)
          // (\.[0-9]+)? -> optional, a dot followed by at least one digit (prevents 5.)
          final regExp = RegExp(r'^[0-9]+(\.[0-9]+)?$');

          if (!regExp.hasMatch(value)) {
            return 'Invalid format(e.g., 10.50)';
          }
          return null;
        },
      ),
    ],
  );
}
