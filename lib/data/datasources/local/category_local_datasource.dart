import 'package:hive_flutter/hive_flutter.dart';
import 'package:weeklet/domain/entities/category.dart';

abstract class CategoryLocalDataSource {
  Future<void> addCategory(Category category);
  Future<void> deleteCategory(String id);
  Future<void> updateCategory(Category category);
  Future<List<Category>> getAllCategories();
  Future<Category?> getCategoryById(String id);
}

class CategoryLocalDataSourceImpl implements CategoryLocalDataSource {
  CategoryLocalDataSourceImpl(this.categoryBox);
  final Box<Category> categoryBox;

  @override
  Future<void> addCategory(Category category) async {
    await categoryBox.put(category.id, category);
  }

  @override
  Future<void> deleteCategory(String id) async {
    await categoryBox.delete(id);
  }

  @override
  Future<void> updateCategory(Category category) async {
    await categoryBox.put(category.id, category);
  }

  @override
  Future<List<Category>> getAllCategories() async => categoryBox.values.toList();

  @override
  Future<Category?> getCategoryById(String id) async => categoryBox.get(id);
}
