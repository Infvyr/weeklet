import 'package:flutter/material.dart';
import 'package:weeklet/core/extensions/context_extensions.dart';
import 'package:weeklet/core/theme/sizes.dart';

/// Custom confirmation dialog widget
class CustomConfirmationDialog extends StatelessWidget {
  const CustomConfirmationDialog({
    super.key,
    required this.icon,
    required this.iconBackgroundColor,
    required this.title,
    required this.subtitle1,
    this.subtitle1AccentText,
    required this.subtitle2,
    required this.confirmButtonColor,
    required this.confirmButtonTextColor,
    required this.cancelButtonColor,
    required this.cancelButtonTextColor,
    this.iconColor = Colors.red,
    this.confirmButtonText = 'Delete',
    this.cancelButtonText = 'Cancel',
    this.onConfirm,
    this.onCancel,
  });

  /// Icon to display at the top
  final IconData icon;

  /// Background color for the icon circle
  final Color iconBackgroundColor;

  /// Color of the icon itself
  final Color iconColor;

  /// Main title text
  final String title;

  /// First subtitle text
  final String subtitle1;

  /// First subtitle accented text
  final String? subtitle1AccentText;

  /// Second subtitle text
  final String subtitle2;

  /// Color for the confirm button
  final Color confirmButtonColor;

  /// Color for the text confirm button
  final Color confirmButtonTextColor;

  /// Text for the confirm button (default: "Delete")
  final String confirmButtonText;

  /// Text for the cancel button (default: "Cancel")
  final String cancelButtonText;

  /// Color for the cancel button
  final Color cancelButtonColor;

  /// Color for the text cancel button
  final Color cancelButtonTextColor;

  /// Callback when confirm button is pressed
  final VoidCallback? onConfirm;

  /// Callback when cancel button is pressed
  final VoidCallback? onCancel;

  /// Helper method to show the dialog
  static Future<bool?> show({
    required BuildContext context,
    required IconData icon,
    required Color iconBackgroundColor,
    required String title,
    required String subtitle1,
    String? subtitle1AccentText,
    required String subtitle2,
    required Color confirmButtonColor,
    required Color confirmButtonTextColor,
    required Color cancelButtonColor,
    required Color cancelButtonTextColor,
    Color iconColor = Colors.white,
    String confirmButtonText = 'Delete',
    String cancelButtonText = 'Cancel',
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) => showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) => CustomConfirmationDialog(
      icon: icon,
      iconBackgroundColor: iconBackgroundColor,
      iconColor: iconColor,
      title: title,
      subtitle1: subtitle1,
      subtitle1AccentText: subtitle1AccentText,
      subtitle2: subtitle2,
      confirmButtonColor: confirmButtonColor,
      confirmButtonTextColor: confirmButtonTextColor,
      confirmButtonText: confirmButtonText,
      cancelButtonText: cancelButtonText,
      cancelButtonColor: cancelButtonColor,
      cancelButtonTextColor: cancelButtonTextColor,
      onConfirm: onConfirm,
      onCancel: onCancel,
    ),
  );

  @override
  Widget build(
    BuildContext context,
  ) => AlertDialog(
    backgroundColor: context.colorScheme.surface,
    shape: RoundedRectangleBorder(
      borderRadius: .circular(24),
    ),
    contentPadding: const .all(20),
    content: Column(
      mainAxisSize: .min,
      crossAxisAlignment: .start,
      children: [
        // Icon with circular background
        _DialogIcon(
          icon: icon,
          backgroundColor: iconBackgroundColor,
          iconColor: iconColor,
        ),

        const SizedBox(height: 16),

        // Title
        _DialogTitle(title: title),

        const SizedBox(height: 8),

        // First subtitle
        _DialogSubtitle(
          text: subtitle1,
          accentedText: subtitle1AccentText,
        ),

        const SizedBox(height: 4),

        // Second subtitle
        _DialogSubtitle(
          text: subtitle2,
        ),
      ],
    ),
    actions: [
      _DialogButtons(
        cancelButtonText: cancelButtonText,
        confirmButtonText: confirmButtonText,
        confirmButtonColor: confirmButtonColor,
        confirmButtonTextColor: confirmButtonTextColor,
        cancelButtonColor: cancelButtonColor,
        cancelButtonTextColor: cancelButtonTextColor,
        onCancel: onCancel,
        onConfirm: onConfirm,
      ),
    ],
  );
}

/// Widget for the dialog icon with circular background
class _DialogIcon extends StatelessWidget {
  const _DialogIcon({
    required this.icon,
    required this.backgroundColor,
    required this.iconColor,
  });

  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 50,
    height: 50,
    child: DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: .circle,
      ),
      child: Icon(
        icon,
        color: iconColor,
        size: 28,
      ),
    ),
  );
}

/// Widget for the dialog title
class _DialogTitle extends StatelessWidget {
  const _DialogTitle({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) => Text(
    title,
    style: context.titleMedium,
  );
}

/// Widget for dialog subtitle text
class _DialogSubtitle extends StatelessWidget {
  const _DialogSubtitle({
    Key? key,
    required this.text,
    this.accentedText,
  }) : super(key: key);

  final String text;
  final String? accentedText;

  @override
  Widget build(BuildContext context) => Text.rich(
    TextSpan(
      children: [
        TextSpan(text: text),
        if (accentedText != null)
          TextSpan(
            text: accentedText,
            style: TextStyle(
              fontWeight: .w700,
              color: context.colorScheme.onSurface.withValues(
                alpha: .8,
              ),
            ),
          ),
      ],
    ),
    style: context.bodyMedium?.copyWith(
      color: context.colorScheme.onSurfaceVariant,
    ),
  );
}

/// Widget for the action buttons row
class _DialogButtons extends StatelessWidget {
  const _DialogButtons({
    required this.cancelButtonText,
    required this.confirmButtonText,
    required this.confirmButtonColor,
    required this.confirmButtonTextColor,
    required this.cancelButtonColor,
    required this.cancelButtonTextColor,
    this.onCancel,
    this.onConfirm,
  });

  final String cancelButtonText;
  final String confirmButtonText;
  final Color confirmButtonColor;
  final Color confirmButtonTextColor;
  final Color cancelButtonColor;
  final Color cancelButtonTextColor;
  final VoidCallback? onCancel;
  final VoidCallback? onConfirm;

  @override
  Widget build(
    BuildContext context,
  ) => Row(
    spacing: 16,
    children: [
      // Cancel button
      Expanded(
        child: _DialogCancelButton(
          text: cancelButtonText,
          onPressed: onCancel,
          cancelButtonColor: cancelButtonColor,
          cancelButtonTextColor: cancelButtonTextColor,
        ),
      ),

      // Confirm button
      Expanded(
        child: _DialogConfirmButton(
          text: confirmButtonText,
          bgColor: confirmButtonColor,
          fgColor: confirmButtonTextColor,
          onPressed: onConfirm,
        ),
      ),
    ],
  );
}

/// Cancel button widget
class _DialogCancelButton extends StatelessWidget {
  const _DialogCancelButton({
    required this.text,
    required this.cancelButtonColor,
    required this.cancelButtonTextColor,
    this.onPressed,
  });
  final String text;
  final Color cancelButtonColor, cancelButtonTextColor;
  final VoidCallback? onPressed;

  @override
  Widget build(
    BuildContext context,
  ) => ElevatedButton(
    onPressed: () {
      onPressed?.call();
      context.pop(false);
    },
    style: ElevatedButton.styleFrom(
      backgroundColor: cancelButtonColor,
      foregroundColor: cancelButtonTextColor,
      minimumSize: const .fromHeight(
        kButtonHeight,
      ),
      elevation: 0,
      shadowColor: Colors.transparent,
    ),
    child: Text(
      text,
      style: context.labelMedium?.copyWith(fontWeight: .w400),
    ),
  );
}

/// Confirm button widget
class _DialogConfirmButton extends StatelessWidget {
  const _DialogConfirmButton({
    required this.text,
    required this.bgColor,
    required this.fgColor,
    this.onPressed,
  });
  final String text;
  final Color bgColor, fgColor;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => ElevatedButton(
    onPressed: () {
      onPressed?.call();
      context.pop(true);
    },
    style: ElevatedButton.styleFrom(
      backgroundColor: bgColor,
      minimumSize: const .fromHeight(
        kButtonHeight,
      ),
      elevation: 0,
    ),
    child: Text(
      text,
      style: context.labelMedium?.copyWith(
        color: fgColor,
      ),
    ),
  );
}
