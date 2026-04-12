import 'package:flutter/foundation.dart' show debugPrint;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:weeklet/data/models/category_model.dart';

abstract class CategoryLocalDataSource {
  Future<void> addCategory(CategoryModel model);
  Future<void> deleteCategory(String id);
  Future<void> updateCategory(CategoryModel model);
  Future<List<CategoryModel>> getAllCategories();
  Future<CategoryModel?> getCategoryById(String id);
  Future<void> clearAll();
}

class CategoryLocalDataSourceImpl implements CategoryLocalDataSource {
  CategoryLocalDataSourceImpl(this.categoryBox);

  final Box<CategoryModel> categoryBox;

  @override
  Future<void> addCategory(CategoryModel model) async =>
      categoryBox.put(model.id, model);

  @override
  Future<void> deleteCategory(String id) async => categoryBox.delete(id);

  @override
  Future<void> updateCategory(CategoryModel model) async =>
      categoryBox.put(model.id, model);

  @override
  Future<List<CategoryModel>> getAllCategories() async {
    final List<CategoryModel> list = categoryBox.values.toList();
    list.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return list;
  }

  @override
  Future<CategoryModel?> getCategoryById(String id) async =>
      categoryBox.get(id);

  @override
  Future<void> clearAll() async {
    try {
      await categoryBox.clear();
    } catch (e) {
      debugPrint('[CategoryLocalDataSourceImpl.clearAll] error: $e');
      rethrow;
    }
  }
}
