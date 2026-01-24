import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weeklet/core/extensions/category_extensions.dart';
import 'package:weeklet/core/extensions/context_extensions.dart';
import 'package:weeklet/domain/entities/category.dart';
import 'package:weeklet/presentation/blocs/category/category_bloc.dart';
import 'package:weeklet/presentation/blocs/category/category_state.dart';
import 'package:weeklet/presentation/widgets/label_view.dart';

class ExpenseFormCategoryView extends StatelessWidget {
  const ExpenseFormCategoryView({
    super.key,
    required this.selectedCategory,
    required this.onChanged,
  });
  final Category? selectedCategory;
  final ValueChanged<Category?> onChanged;

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<CategoryBloc, CategoryState>(
        builder: (context, state) {
          List<Category> categories = [];
          String? loadingError;

          if (state is CategoriesLoaded) {
            categories = state.categories;
          } else if (state is CategoryError) {
            loadingError = 'Could not load categories';
          }

          return Column(
            crossAxisAlignment: .start,
            spacing: 8,
            children: [
              const LabelView(text: 'Category'),
              DropdownButtonFormField<Category>(
                initialValue: selectedCategory,
                hint: Text(
                  state is CategoryLoading ? 'Loading...' : 'Select Category',
                  style: context.bodyLarge?.copyWith(
                    fontWeight: .w400,
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                ),
                isExpanded: true,
                validator: (value) {
                  if (value == null) {
                    return 'Please select a category';
                  }
                  return null;
                },
                items: categories
                    .map(
                      (category) => DropdownMenuItem<Category>(
                        value: category,
                        child: Row(
                          spacing: 10,
                          children: [
                            category.toIcon(size: 20),
                            Text(category.name, style: context.bodyLarge),
                          ],
                        ),
                      ),
                    )
                    .toList(),
                onChanged: onChanged,
                decoration: InputDecoration(errorText: loadingError),
              ),
            ],
          );
        },
      );
}
