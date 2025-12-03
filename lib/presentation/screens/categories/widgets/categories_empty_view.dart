import 'package:flutter/material.dart';

class CategoriesEmptyView extends StatelessWidget {
  const CategoriesEmptyView({super.key});

  @override
  Widget build(BuildContext context) => const Center(
    child: Text.rich(
      TextSpan(
        text: "There's no categories. Add new one by pressing ",
        children: [
          TextSpan(text: 'the floating button in the bottom right corner.'),
        ],
      ),
      textAlign: TextAlign.center,
    ),
  );
}
