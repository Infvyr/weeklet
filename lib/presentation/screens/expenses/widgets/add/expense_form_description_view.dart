import 'package:flutter/services.dart' show TextInputAction;
import 'package:flutter/widgets.dart';
import 'package:weeklet/presentation/widgets/input_view.dart';
import 'package:weeklet/presentation/widgets/label_view.dart';

class ExpenseFormDescriptionView extends StatelessWidget {
  const ExpenseFormDescriptionView({super.key});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: .start,
    spacing: 8,
    children: [
      const LabelView(
        text: 'Description',
      ),
      InputView(
        // controller: controller,
        hintText: 'For ex.: Grocery shopping',
        textInputAction: TextInputAction.next,
        validator: (value) => null,
      ),
    ],
  );
}
