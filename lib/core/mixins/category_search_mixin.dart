import 'package:flutter/material.dart';
import 'package:weeklet/core/constants/category_icons.dart';

mixin CategorySearchMixin<T extends StatefulWidget> on State<T> {
  final ValueNotifier<String> searchNotifier = ValueNotifier('');
  final TextEditingController searchController = TextEditingController();

  Map<String, String> filteredIcons = kCategoryIcons;
  String? selectedIconKey;

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
    setState(() {
      final searchTerm = searchNotifier.value.toLowerCase().trim();

      if (searchTerm.isEmpty) {
        filteredIcons = kCategoryIcons;
        return;
      }

      final Map<String, String> results = {};
      kCategoryIcons.forEach((key, value) {
        if (key.contains(searchTerm) || value.contains(searchTerm)) {
          results[key] = value;
        }
      });

      debugPrint('Filtered Icons: $results');

      filteredIcons = results;
    });
  }
}
