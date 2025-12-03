import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weeklet/core/constants/category_icons.dart';
import 'package:weeklet/core/di/service_locator.dart' show sl;
import 'package:weeklet/core/extensions/context_extensions.dart';
import 'package:weeklet/presentation/blocs/category/category_bloc.dart';
import 'package:weeklet/presentation/blocs/category/category_event.dart';
import 'package:weeklet/presentation/blocs/category/category_state.dart';
import 'package:weeklet/presentation/screens/categories/widgets/add_category_bottom_appbar_view.dart';
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
  bool _isSaveButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _nameController.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    _nameController.removeListener(_updateButtonState);
    _nameController.dispose();
    super.dispose();
  }

  void _updateButtonState() {
    final newEnabledState =
        _nameController.text.trim().isNotEmpty && _selectedIcon != null;

    if (newEnabledState != _isSaveButtonEnabled) {
      setState(() => _isSaveButtonEnabled = newEnabledState);
    }
  }

  void _onIconSelected(CategoryIcon icon) {
    setState(() {
      _selectedIcon = icon;
      _isSaveButtonEnabled =
          _nameController.text.trim().isNotEmpty && _selectedIcon != null;
    });
  }

  void _saveCategory() {
    if (_formKey.currentState!.validate() && _selectedIcon != null) {
      sl<CategoryBloc>().add(
        AddCategoryEvent(
          name: _nameController.text.trim(),
          icon: _selectedIcon!.name,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) => BlocProvider<CategoryBloc>.value(
    value: sl<CategoryBloc>(),
    child: BlocListener<CategoryBloc, CategoryState>(
      listener: (context, state) {
        if (state is CategorySuccess) {
          context.showSnackBar(state.message);
          Future.delayed(const Duration(seconds: 2), () {
            if (context.mounted) {
              context.pop();
            }
          });
          // context.pop();
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
                autovalidateMode: AutovalidateMode.onUnfocus,
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: 20,
                  children: [
                    CategoryName(controller: _nameController),
                    ValueListenableBuilder<TextEditingValue>(
                      valueListenable: _nameController,
                      builder: (context, searchTerm, ___) => SelectedIconView(
                        selectedIcon: _selectedIcon,
                        categoryName: searchTerm.text,
                      ),
                    ),
                    CategoryIconsView(
                      onIconSelected: _onIconSelected,
                    ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: AddCategoryBottomAppBarView(
              isLoading: isLoading,
              onSave: _saveCategory,
              isEnabled: _isSaveButtonEnabled,
            ),
          );
        },
      ),
    ),
  );
}
