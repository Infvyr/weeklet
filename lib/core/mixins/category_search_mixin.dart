import 'package:flutter/material.dart';
import 'package:weeklet/core/constants/category_icons.dart';

mixin CategorySearchMixin<T extends StatefulWidget> on State<T> {
  final ValueNotifier<String> searchNotifier = ValueNotifier('');
  final TextEditingController searchController = TextEditingController();

  List<CategoryIcon> filteredIcons = kCategoryIcons;
  CategoryIcon? selectedIcon;

  @override
  void initState() {
    super.initState();
    searchNotifier.addListener(_filterIcons);
  }

  @override
  void dispose() {
    searchNotifier.removeListener(_filterIcons);
    searchNotifier.dispose();
    searchController.dispose();
    super.dispose();
  }

  void _filterIcons() {
    final searchTerm = searchNotifier.value.toLowerCase().trim();

    setState(() {
      if (searchTerm.isEmpty) {
        filteredIcons = kCategoryIcons;
      } else {
        filteredIcons = kCategoryIcons
            .where(
              (icon) =>
                  icon.label.toLowerCase().contains(searchTerm) ||
                  icon.name.toLowerCase().contains(searchTerm),
            )
            .toList();
      }
    });

    debugPrint('Filtered Icons: ${filteredIcons.map((e) => e.label).toList()}');
  }
}
