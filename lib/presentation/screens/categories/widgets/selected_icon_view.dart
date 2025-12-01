import 'package:flutter/material.dart';
import 'package:weeklet/core/extensions/context_extensions.dart';
import 'package:weeklet/presentation/widgets/label_view.dart';

class SelectedIconView extends StatelessWidget {
  const SelectedIconView({super.key});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: .start,
    spacing: 8,
    children: [
      const LabelView(text: 'Selected Icon'),
      Card(
        margin: EdgeInsets.zero,
        semanticContainer: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: context.colorScheme.outline,
          ),
        ),
        child: const Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            spacing: 12,
            children: [
              _SelectedIcon(),
              _SelectedIconMeta(),
            ],
          ),
        ),
      ),
    ],
  );
}

class _SelectedIcon extends StatelessWidget {
  const _SelectedIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Ink(
    width: 40,
    height: 40,
    decoration: BoxDecoration(
      color: context.colorScheme.primary,
      borderRadius: BorderRadius.circular(6),
    ),
    child: const Icon(
      Icons.help_outline,
      size: 24,
      color: Colors.white,
      semanticLabel: 'Selected icon name',
    ),
  );
}

class _SelectedIconMeta extends StatelessWidget {
  const _SelectedIconMeta({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: .start,
    children: [
      Text(
        'No icon selected',
        style: context.textTheme.bodyMedium,
        semanticsLabel: 'Selected icon description',
      ),
      Text(
        'Shopping',
        style: context.textTheme.bodySmall?.copyWith(
          color: context.colorScheme.onSurfaceVariant,
        ),
        semanticsLabel: 'Category name',
      ),
    ],
  );
}
