import 'package:flutter/material.dart';
import 'package:weeklet/core/theme/sizes.dart';

class ExpenseFormSubmitView extends StatelessWidget {
  const ExpenseFormSubmitView({super.key});

  @override
  Widget build(BuildContext context) {
    final isLoading = false;
    final isEnabled = true;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: isLoading ? 0.6 : 1.0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(kButtonHeight),
            elevation: 0,
            shadowColor: Colors.transparent,
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator.adaptive(),
                  )
                : Text(
                    'Save',
                    style: TextStyle(
                      color: isEnabled ? Colors.white : Colors.white70,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
