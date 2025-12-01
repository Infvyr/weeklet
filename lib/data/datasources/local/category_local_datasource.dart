import 'package:hive_flutter/hive_flutter.dart';
import 'package:weeklet/data/models/category_model.dart';

abstract class CategoryLocalDataSource {
  Future<void> addCategory(CategoryModel model);
  Future<void> deleteCategory(String id);
  Future<void> updateCategory(CategoryModel model);
  Future<List<CategoryModel>> getAllCategories();
  Future<CategoryModel?> getCategoryById(String id);
}

class CategoryLocalDataSourceImpl implements CategoryLocalDataSource {
  CategoryLocalDataSourceImpl(this.categoryBox);

  final Box<CategoryModel> categoryBox;

  @override
  Future<void> addCategory(CategoryModel model) async => categoryBox.put(
    model.id,
    model,
  );

  @override
  Future<void> deleteCategory(String id) async => categoryBox.delete(id);

  @override
  Future<void> updateCategory(CategoryModel model) async => categoryBox.put(
    model.id,
    model,
  );

  @override
  Future<List<CategoryModel>> getAllCategories() async => categoryBox.values.toList();

  @override
  Future<CategoryModel?> getCategoryById(String id) async => categoryBox.get(id);
}
