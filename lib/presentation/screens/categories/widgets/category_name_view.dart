import 'package:flutter/material.dart';
import 'package:weeklet/presentation/widgets/input_view.dart';
import 'package:weeklet/presentation/widgets/label_view.dart';

class CategoryName extends StatelessWidget {
  const CategoryName({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;

  @override
  Widget build(
    BuildContext context,
  ) => Column(
    crossAxisAlignment: .start,
    spacing: 8,
    children: [
      const LabelView(
        text: 'Category Name *',
      ),
      InputView(
        controller: controller,
        hintText: 'e.g., Shopping',
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Please enter a category name.';
          }
          return null;
        },
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
      ),
    ],
  );
}
