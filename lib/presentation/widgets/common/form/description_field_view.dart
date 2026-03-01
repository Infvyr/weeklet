import 'package:flutter/widgets.dart';
import 'package:weeklet/core/utils/form_validators.dart';
import 'package:weeklet/presentation/widgets/input_view.dart';
import 'package:weeklet/presentation/widgets/label_view.dart';

class DescriptionFieldView extends StatelessWidget {
  const DescriptionFieldView({
    super.key,
    required this.controller,
    this.isRequired = true,
  });

  final TextEditingController controller;
  final bool isRequired;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    spacing: 8,
    children: [
      const LabelView(
        text: 'Description',
      ),
      InputView(
        controller: controller,
        hintText: 'For ex.: Grocery shopping',
        textInputAction: .next,
        validator: isRequired ? FormValidators.required : null,
      ),
    ],
  );
}
