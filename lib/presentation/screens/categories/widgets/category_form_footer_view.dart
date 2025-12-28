import 'package:flutter/material.dart';
import 'package:weeklet/core/constants/category_icons.dart';
import 'package:weeklet/core/extensions/context_extensions.dart';
import 'package:weeklet/core/theme/sizes.dart';

class CategoryFormFooterView extends StatelessWidget {
  const CategoryFormFooterView({
    super.key,
    required this.isLoading,
    required this.onSave,
    required this.nameController,
    required this.selectedIconNotifier,
  });

  /// Whether the form is currently in a loading state.
  final bool isLoading;

  /// Callback invoked when the Save button is pressed.
  final VoidCallback onSave;

  /// The controller for the category name input.
  final TextEditingController nameController;

  /// The notifier for the selected icon.
  final ValueNotifier<CategoryIcon?> selectedIconNotifier;

  @override
  Widget build(BuildContext context) => AnimatedOpacity(
    duration: const Duration(milliseconds: 300),
    opacity: isLoading ? 0.6 : 1.0,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        spacing: 16,
        children: [
          Expanded(child: _CancelButton(isLoading: isLoading)),
          Expanded(
            child: _SaveButton(
              isLoading: isLoading,
              onSave: onSave,
              nameController: nameController,
              selectedIconNotifier: selectedIconNotifier,
            ),
          ),
        ],
      ),
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
      shadowColor: Colors.transparent,
      elevation: 0,
    ),
    child: Text(
      'Cancel',
      style: TextStyle(
        color: context.colorScheme.onSurface,
      ),
    ),
  );
}

class _SaveButton extends StatelessWidget {
  const _SaveButton({
    Key? key,
    required this.isLoading,
    required this.onSave,
    required this.nameController,
    required this.selectedIconNotifier,
  }) : super(key: key);

  final bool isLoading;
  final VoidCallback onSave;
  final TextEditingController nameController;
  final ValueNotifier<CategoryIcon?> selectedIconNotifier;

  @override
  Widget build(BuildContext context) =>
      ValueListenableBuilder<TextEditingValue>(
        valueListenable: nameController,
        builder: (context, nameValue, ___) =>
            ValueListenableBuilder<CategoryIcon?>(
              valueListenable: selectedIconNotifier,
              builder: (context, selectedIcon, ___) {
                final isEnabled =
                    nameValue.text.trim().isNotEmpty && selectedIcon != null;

                return ElevatedButton(
                  onPressed: isLoading || !isEnabled ? null : onSave,
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
                );
              },
            ),
      );
}
