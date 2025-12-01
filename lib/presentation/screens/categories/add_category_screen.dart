import 'package:flutter/material.dart';
import 'package:weeklet/core/extensions/context_extensions.dart';
import 'package:weeklet/core/theme/sizes.dart';
import 'package:weeklet/presentation/screens/categories/widgets/category_icons_view.dart';
import 'package:weeklet/presentation/screens/categories/widgets/category_name_view.dart';
import 'package:weeklet/presentation/screens/categories/widgets/selected_icon_view.dart';

class AddCategoryScreen extends StatefulWidget {
  const AddCategoryScreen({super.key});

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Icon? _selectedIcon;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _saveCategory() {
    if (_formKey.currentState!.validate() && _selectedIcon != null) {
      debugPrint('Name: ${_nameController.text}');
      debugPrint('Icon (FontFamily): ${_selectedIcon?.icon}');

      // Save to database or state management solution here
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Category "${_nameController.text}" has been added!'),
        ),
      );
    } else if (_selectedIcon == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You should pick an icon.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Add New Category'),
    ),
    body: SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: _formKey,
        child: Column(
          crossAxisAlignment: .stretch,
          spacing: 20,
          children: [
            CategoryName(controller: _nameController),
            const SelectedIconView(),
            const CategoryIconsView(),
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
            child: OutlinedButton(
              onPressed: () => context.pop(),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(kButtonHeight),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Back'),
            ),
          ),
          Expanded(
            child: ElevatedButton(
              onPressed: _saveCategory,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(kButtonHeight),
              ),
              child: const Text(
                'Add category',
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
