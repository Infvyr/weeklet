import 'package:flutter/material.dart';

class SaveNewTransactionButton extends StatelessWidget {
  const SaveNewTransactionButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
  });

  final bool isLoading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => ElevatedButton(
    style: ElevatedButton.styleFrom(
      minimumSize: const Size(double.infinity, 50),
    ),
    onPressed: isLoading ? null : onPressed,

    child: isLoading
        ? const CircularProgressIndicator.adaptive()
        : const Text(
            'Save Transaction',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
  );
}
