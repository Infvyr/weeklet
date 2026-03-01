import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weeklet/core/theme/sizes.dart';
import 'package:weeklet/presentation/blocs/income/income_bloc.dart';
import 'package:weeklet/presentation/blocs/income/income_state.dart';

class IncomeFormSubmitView extends StatelessWidget {
  const IncomeFormSubmitView({
    super.key,
    required this.onPressed,
    this.isEnabled = false,
  });

  final VoidCallback onPressed;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) => BlocBuilder<IncomeBloc, IncomeState>(
    builder: (context, state) {
      final isLoading = state is IncomeLoading;
      final canSubmit = isEnabled && !isLoading;

      return AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: isLoading ? 0.6 : 1.0,
        child: Padding(
          padding: const .symmetric(horizontal: 16, vertical: 12),
          child: ElevatedButton(
            onPressed: canSubmit ? onPressed : null,
            style: ElevatedButton.styleFrom(
              minimumSize: const .fromHeight(kButtonHeight),
              elevation: 0,
              shadowColor: Colors.transparent,
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Visibility(
                visible: isLoading,
                replacement: const Text(
                  'Save Income',
                  style: TextStyle(color: Colors.white),
                ),
                child: const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator.adaptive(),
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}
