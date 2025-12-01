import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weeklet/core/extensions/context_extensions.dart';
import 'package:weeklet/presentation/blocs/category/category_bloc.dart';
import 'package:weeklet/presentation/blocs/category/category_event.dart';
import 'package:weeklet/presentation/blocs/category/category_state.dart';
import 'package:weeklet/presentation/screens/categories/widgets/category_form_view.dart';

class AddCategoryDialog extends StatefulWidget {
  const AddCategoryDialog({super.key});

  @override
  State<AddCategoryDialog> createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends State<AddCategoryDialog> {
  late TextEditingController _nameController;
  late TextEditingController _iconController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _iconController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _iconController.dispose();
    super.dispose();
  }

  void _onAddCategory() {
    context.read<CategoryBloc>().add(
      AddCategoryEvent(
        name: _nameController.text,
        icon: _iconController.text,
      ),
    );
    context.pop();
  }

  @override
  Widget build(BuildContext context) => BlocListener<CategoryBloc, CategoryState>(
    listener: (context, state) {
      if (state is CategoryError) {
        context.showSnackBar(state.message);
      }
    },
    child: AlertDialog(
      title: const Text('Add Category'),
      content: CategoryForm(
        nameController: _nameController,
        iconController: _iconController,
      ),
      actions: [
        TextButton(
          onPressed: () => context.pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _onAddCategory,
          child: const Text('Add'),
        ),
      ],
    ),
  );
}
