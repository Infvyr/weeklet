import 'package:flutter/material.dart';
import 'package:weeklet/core/extensions/category_extensions.dart';
import 'package:weeklet/core/extensions/context_extensions.dart';
import 'package:weeklet/domain/entities/category.dart';

class CategoryItemView extends StatelessWidget {
  const CategoryItemView(this.category, {super.key});

  final Category category;

  @override
  Widget build(BuildContext context) => Stack(
    children: [
      Card(
        semanticContainer: false,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minHeight: 80,
            maxHeight: 120,
            minWidth: double.infinity,
          ),
          child: Tooltip(
            message: category.name,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 5,
              children: [
                _IconView(category),
                _IconNameView(category),
              ],
            ),
          ),
        ),
      ),
      const _MoreOptionsView(),
    ],
  );
}

class _IconView extends StatelessWidget {
  const _IconView(
    this.category, {
    Key? key,
  }) : super(key: key);

  final Category category;

  @override
  Widget build(BuildContext context) => CircleAvatar(
    radius: 22,
    backgroundColor: context.colorScheme.primary,
    child: Icon(
      category.toIcon().icon,
      size: 24,
      color: Colors.white,
    ),
  );
}

class _IconNameView extends StatelessWidget {
  const _IconNameView(
    this.category, {
    Key? key,
  }) : super(key: key);

  final Category category;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 5),
    child: Text(
      category.name,
      style: context.textTheme.labelMedium?.copyWith(
        fontWeight: FontWeight.w400,
      ),
      textAlign: TextAlign.center,
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
    ),
  );
}

class _MoreOptionsView extends StatelessWidget {
  const _MoreOptionsView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Positioned(
    right: 5,
    top: 5,
    child: MenuAnchor(
      alignmentOffset: const Offset(-58, 4),
      consumeOutsideTap: true,
      builder: (context, controller, ___) => IconButton(
        padding: EdgeInsets.zero,
        visualDensity: VisualDensity.compact,
        tooltip: 'More options',
        style: IconButton.styleFrom(
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () {
          if (controller.isOpen) {
            controller.close();
          } else {
            controller.open();
          }
        },
        icon: Icon(
          Icons.more_vert,
          size: 16,
          color: context.colorScheme.onSurfaceVariant,
        ),
      ),
      menuChildren: [
        MenuItemButton(
          onPressed: () {},
          child: const ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(
              Icons.edit,
              size: 16,
            ),
            title: Text('Edit'),
            visualDensity: VisualDensity(horizontal: -4, vertical: -4),
            dense: true,
          ),
        ),
        MenuItemButton(
          onPressed: () {},
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(
              Icons.delete,
              size: 16,
              color: context.colorScheme.error,
            ),
            title: Text(
              'Delete',
              style: TextStyle(
                color: context.colorScheme.error,
              ),
            ),
            visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
            dense: true,
          ),
        ),
      ],
    ),
  );
}
