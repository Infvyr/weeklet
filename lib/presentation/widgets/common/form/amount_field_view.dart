import 'package:flutter/services.dart'
    show FilteringTextInputFormatter, TextInputAction;
import 'package:flutter/widgets.dart';
import 'package:weeklet/core/constants/app_constants.dart';
import 'package:weeklet/core/utils/form_validators.dart';
import 'package:weeklet/l10n/app_localizations.dart';
import 'package:weeklet/presentation/widgets/input_view.dart';
import 'package:weeklet/presentation/widgets/label_view.dart';

class AmountFieldView extends StatelessWidget {
  const AmountFieldView({
    super.key,
    required this.controller,
    this.currencySymbol = AppConstants.DEFAULT_CURRENCY,
  });

  final TextEditingController controller;
  final String currencySymbol;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        LabelView(
          text: l10n.amountFieldLabel(currencySymbol),
        ),
        InputView(
          controller: controller,
          hintText: '0.00',
          keyboardType: const TextInputType.numberWithOptions(
            decimal: true,
          ),
          textInputAction: TextInputAction.next,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*')),
          ],
          validator: FormValidators.amountFormat,
        ),
      ],
    );
  }
}
