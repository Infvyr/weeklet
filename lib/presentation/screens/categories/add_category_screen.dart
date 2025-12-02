import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weeklet/core/constants/category_icons.dart';
import 'package:weeklet/core/di/service_locator.dart' show sl;
import 'package:weeklet/core/extensions/context_extensions.dart';
import 'package:weeklet/core/theme/sizes.dart';
import 'package:weeklet/presentation/blocs/category/category_bloc.dart';
import 'package:weeklet/presentation/blocs/category/category_event.dart';
import 'package:weeklet/presentation/blocs/category/category_state.dart';
import 'package:weeklet/presentation/screens/categories/widgets/category_icons_view.dart';
import 'package:weeklet/presentation/screens/categories/widgets/category_name_view.dart';
import 'package:weeklet/presentation/screens/categories/widgets/selected_icon_view.dart';

class AddCategoryScreen extends StatefulWidget {
  const AddCategoryScreen({Key? key}) : super(key: key);

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  late TextEditingController _nameController;
  final _formKey = GlobalKey<FormState>();
  CategoryIcon? _selectedIcon;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _saveCategory() {
    if (_formKey.currentState!.validate() && _selectedIcon != null) {
      sl<CategoryBloc>().add(
        AddCategoryEvent(
          name: _nameController.text.trim(),
          icon: _selectedIcon!.name,
        ),
      );
    } else if (_selectedIcon == null) {
      context.showSnackBar('Please select an icon');
    }
  }

  @override
  Widget build(BuildContext context) => BlocProvider<CategoryBloc>.value(
    value: sl<CategoryBloc>(),
    child: BlocListener<CategoryBloc, CategoryState>(
      listener: (context, state) {
        if (state is CategorySuccess) {
          context.showSnackBar(state.message);
          context.pop();
        }
        if (state is CategoryError) {
          context.showSnackBar(state.message);
        }
      },
      child: BlocBuilder<CategoryBloc, CategoryState>(
        builder: (context, state) {
          final isLoading = state is CategoryLoading;

          return Scaffold(
            appBar: AppBar(
              title: const Text('Add Category'),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: 20,
                  children: [
                    CategoryName(controller: _nameController),
                    SelectedIconView(
                      selectedIcon: _selectedIcon,
                      categoryName: _nameController.text,
                    ),
                    CategoryIconsView(
                      onIconSelected: (icon) {
                        setState(() => _selectedIcon = icon);
                      },
                    ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                spacing: 16,
                children: [
                  Expanded(
                    child: ElevatedButton(
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
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _saveCategory,
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
                                'Add',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    ),
  );
}
