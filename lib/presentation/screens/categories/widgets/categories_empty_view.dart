import 'package:flutter/material.dart';

class CategoriesEmptyView extends StatelessWidget {
  const CategoriesEmptyView({super.key});

  @override
  Widget build(BuildContext context) => const Center(
    child: Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 24.0,
      ),
      child: Text.rich(
        TextSpan(
          text: "There's no categories.\n",
          children: [
            TextSpan(
              text:
                  'Add new one by pressing the floating button in the bottom right corner.',
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    ),
  );
}
