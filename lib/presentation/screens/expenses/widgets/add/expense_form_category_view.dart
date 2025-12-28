import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weeklet/core/di/service_locator.dart' show sl;
import 'package:weeklet/core/extensions/category_extensions.dart';
import 'package:weeklet/core/extensions/context_extensions.dart';
import 'package:weeklet/domain/entities/category.dart';
import 'package:weeklet/presentation/blocs/category/category_bloc.dart';
import 'package:weeklet/presentation/blocs/category/category_event.dart';
import 'package:weeklet/presentation/blocs/category/category_state.dart';

class ExpenseFormCategoryView extends StatefulWidget {
  const ExpenseFormCategoryView({super.key});

  @override
  State<ExpenseFormCategoryView> createState() =>
      _ExpenseFormCategoryViewState();
}

class _ExpenseFormCategoryViewState extends State<ExpenseFormCategoryView> {
  Category? _selectedCategory;

  @override
  void initState() {
    super.initState();
    sl<CategoryBloc>().add(const GetAllCategoriesEvent());
  }

  @override
  Widget build(BuildContext context) => BlocProvider<CategoryBloc>.value(
    value: sl<CategoryBloc>(),
    child: BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        List<Category> categories = [];

        if (state is CategoriesLoaded) {
          categories = state.categories;
        }

        return DropdownButtonFormField<Category>(
          initialValue: _selectedCategory,
          hint: Text(
            'Select Category',
            style: context.bodyLarge?.copyWith(
              fontWeight: FontWeight.w400,
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
          isExpanded: true,
          enableFeedback: true,
          validator: (value) {
            if (value == null) {
              return 'This field is required';
            }
            return null;
          },
          items: categories
              .map(
                (category) => DropdownMenuItem<Category>(
                  value: category,
                  child: Row(
                    children: [
                      category.toIcon(size: 20),
                      const SizedBox(width: 10),
                      Text(category.name, style: context.bodyLarge),
                    ],
                  ),
                ),
              )
              .toList(),
          onChanged: (newValue) {
            setState(() => _selectedCategory = newValue);
            // Send to the bloc
          },
        );
      },
    ),
  );
}
