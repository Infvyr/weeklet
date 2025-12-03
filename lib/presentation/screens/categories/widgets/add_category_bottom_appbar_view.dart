import 'package:flutter/material.dart';
import 'package:weeklet/core/extensions/context_extensions.dart';
import 'package:weeklet/core/theme/sizes.dart';

class AddCategoryBottomAppBarView extends StatelessWidget {
  const AddCategoryBottomAppBarView({
    super.key,
    required this.isLoading,
    required this.onSave,
    required this.isEnabled,
  });

  final bool isLoading;
  final VoidCallback onSave;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    child: Row(
      spacing: 16,
      children: [
        Expanded(
          child: _CancelButton(isLoading: isLoading),
        ),
        Expanded(
          child: _SaveButton(
            isLoading: isLoading,
            onSave: onSave,
            isEnabled: isEnabled,
          ),
        ),
      ],
    ),
  );
}

class _CancelButton extends StatelessWidget {
  const _CancelButton({
    Key? key,
    required this.isLoading,
  }) : super(key: key);

  final bool isLoading;

  @override
  Widget build(BuildContext context) => ElevatedButton(
    onPressed: isLoading ? null : () => context.pop(),
    style: ElevatedButton.styleFrom(
      minimumSize: const Size.fromHeight(kButtonHeight),
      backgroundColor: context.colorScheme.outline,
    ),
    child: const Text(
      'Cancel',
      style: TextStyle(
        color: Colors.white,
      ),
    ),
  );
}

class _SaveButton extends StatelessWidget {
  const _SaveButton({
    Key? key,
    required this.isLoading,
    required this.onSave,
    required this.isEnabled,
  }) : super(key: key);

  final bool isLoading;
  final VoidCallback onSave;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) => ElevatedButton(
    onPressed: isLoading || !isEnabled ? null : onSave,
    style: ElevatedButton.styleFrom(
      minimumSize: const Size.fromHeight(kButtonHeight),
    ),
    child: AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator.adaptive(),
            )
          : const Text(
              'Save',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
    ),
  );
}
