import 'package:flutter/material.dart';
import 'package:weeklet/core/di/service_locator.dart';
import 'package:weeklet/core/extensions/category_extensions.dart';
import 'package:weeklet/core/extensions/context_extensions.dart';
import 'package:weeklet/domain/entities/category.dart';
import 'package:weeklet/presentation/blocs/category/category_bloc.dart';
import 'package:weeklet/presentation/blocs/category/category_event.dart';
import 'package:weeklet/presentation/screens/categories/widgets/edit_category_form_view.dart';
import 'package:weeklet/presentation/widgets/deletion_dialog.dart';

class CategoryItemView extends StatelessWidget {
  const CategoryItemView(
    this.category, {
    super.key,
  });

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
            minWidth: .infinity,
          ),
          child: Tooltip(
            message: category.name,
            child: Column(
              mainAxisAlignment: .center,
              spacing: 5,
              children: [
                _IconView(category),
                _IconNameView(
                  category,
                ),
              ],
            ),
          ),
        ),
      ),
      _MoreOptionsView(category),
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
    padding: const .symmetric(
      horizontal: 5,
    ),
    child: Text(
      category.name,
      style: context.textTheme.labelMedium?.copyWith(
        fontWeight: .w400,
      ),
      textAlign: .center,
      overflow: .ellipsis,
      maxLines: 1,
    ),
  );
}

class _MoreOptionsView extends StatelessWidget {
  const _MoreOptionsView(
    this.category, {
    Key? key,
  }) : super(key: key);

  final Category category;

  void _deleteCategory(
    BuildContext context,
  ) {
    sl<CategoryBloc>().add(
      DeleteCategoryEvent(
        id: category.id,
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Positioned(
    right: 5,
    top: 5,
    child: MenuAnchor(
      alignmentOffset: const Offset(-65, 4),
      consumeOutsideTap: true,
      builder: (context, controller, ___) => IconButton(
        padding: .zero,
        visualDensity: .compact,
        tooltip: 'More options',
        style: IconButton.styleFrom(
          tapTargetSize: .shrinkWrap,
          shape: RoundedRectangleBorder(
            borderRadius: .circular(12),
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
          onPressed: () => showModalBottomSheet<void>(
            context: context,
            useRootNavigator: true,
            useSafeArea: true,
            isScrollControlled: true,
            showDragHandle: true,
            builder: (_) => SizedBox(
              height: context.screenHeight * 0.8,
              child: EditCategoryFormView(category),
            ),
          ),
          semanticsLabel: 'Edit category',
          leadingIcon: const Icon(
            Icons.edit,
            size: 16,
          ),
          child: const Text('Edit'),
        ),
        MenuItemButton(
          onPressed: () async => CustomConfirmationDialog.show(
            context: context,
            icon: Icons.delete,
            iconBackgroundColor: context.colorScheme.error,
            title: 'Delete category?',
            subtitle1: 'Are you sure you want to delete',
            subtitle1AccentText: ' ${category.name}?',
            subtitle2: 'This action cannot be undone.',
            confirmButtonColor: context.colorScheme.error,
            onConfirm: () => _deleteCategory(context),
            confirmButtonTextColor: Colors.white,
            cancelButtonColor: context.colorScheme.outline,
            cancelButtonTextColor: context.colorScheme.onSurface,
          ),
          semanticsLabel: 'Delete category',
          leadingIcon: Icon(
            Icons.delete,
            size: 16,
            color: context.colorScheme.error,
          ),
          style: TextButton.styleFrom(
            overlayColor: context.colorScheme.error,
          ),
          child: Text(
            'Delete',
            style: TextStyle(
              color: context.colorScheme.error,
            ),
          ),
        ),
      ],
    ),
  );
}
