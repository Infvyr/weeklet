import 'package:flutter/widgets.dart';
import 'package:weeklet/core/utils/form_validators.dart';
import 'package:weeklet/presentation/widgets/input_view.dart';
import 'package:weeklet/presentation/widgets/label_view.dart';

class ExpenseFormDescriptionView extends StatelessWidget {
  const ExpenseFormDescriptionView({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: .start,
    spacing: 8,
    children: [
      const LabelView(
        text: 'Description',
      ),
      InputView(
        controller: controller,
        hintText: 'For ex.: Grocery shopping',
        textInputAction: .next,
        validator: FormValidators.required,
      ),
    ],
  );
}
