import 'package:flutter/services.dart' show FilteringTextInputFormatter;
import 'package:flutter/widgets.dart';
import 'package:weeklet/core/utils/form_validators.dart';
import 'package:weeklet/presentation/widgets/input_view.dart';
import 'package:weeklet/presentation/widgets/label_view.dart';

class AmountFieldView extends StatelessWidget {
  const AmountFieldView({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    spacing: 8,
    children: [
      const LabelView(
        text: 'Amount (MDL)', // TODO: set currency based on user preference
      ),
      InputView(
        controller: controller,
        hintText: '0.00',
        keyboardType: const TextInputType.numberWithOptions(
          decimal: true,
        ),
        textInputAction: .next,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*')),
        ],
        validator: FormValidators.amountFormat,
      ),
    ],
  );
}
