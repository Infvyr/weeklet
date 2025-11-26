import 'package:flutter/material.dart';
import 'package:weeklet/core/enums/category_enum.dart';
import 'package:weeklet/presentation/blocs/transaction_form/transaction_form_cubit.dart';

class CategoryDropdown extends StatelessWidget {
  const CategoryDropdown(
    this.cubit, {
    super.key,
    required this.categories,
    required this.selectedCategoryDbValue,
  });

  final TransactionFormCubit cubit;
  final List<CategoryType> categories;
  final String selectedCategoryDbValue;

  @override
  Widget build(BuildContext context) {
    final initialValue = categories.firstWhere(
      (e) => e.dbValue == selectedCategoryDbValue,
      orElse: () => categories.first,
    );

    return DropdownButtonFormField<CategoryType>(
      decoration: const InputDecoration(
        labelText: 'Categorie',
        prefixIcon: Icon(Icons.category),
        border: OutlineInputBorder(),
      ),
      initialValue: initialValue,
      items: categories
          .map(
            (c) => DropdownMenuItem(
              value: c,
              child: Text(c.displayName),
            ),
          )
          .toList(),
      onChanged: (value) {
        if (value != null) {
          cubit.setCategory(value);
        }
      },
      validator: (value) => value == null ? 'Select a category.' : null,
    );
  }
}
