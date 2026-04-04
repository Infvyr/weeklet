import 'package:flutter/material.dart';
import 'package:weeklet/core/extensions/context_extensions.dart';

/// A confirmation dialog that asks the user if they want to discard unsaved changes.
///
/// Returns `true` if the user confirms they want to leave without saving,
/// returns `false` if they want to stay and continue editing.
class UnsavedChangesDialog extends StatelessWidget {
  const UnsavedChangesDialog({super.key});

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Discard changes?'),
    content: const Text(
      'You have unsaved changes. Are you sure you want to leave without saving?',
    ),
    actions: [
      TextButton(
        onPressed: () => context.pop(false),
        child: const Text('Cancel'),
      ),
      TextButton(
        onPressed: () => context.pop(true),
        style: TextButton.styleFrom(
          foregroundColor: context.colorScheme.error,
        ),
        child: const Text('Discard'),
      ),
    ],
  );

  /// Shows the unsaved changes dialog and returns a `Future<bool>`.
  ///
  /// Returns `true` if the user wants to discard changes and leave,
  /// returns `false` if they want to stay.
  static Future<bool> show(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => const UnsavedChangesDialog(),
    );
    return result ?? false;
  }
}
