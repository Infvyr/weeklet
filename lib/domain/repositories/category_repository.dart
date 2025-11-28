import 'package:weeklet/domain/entities/category.dart';

abstract class CategoryRepository {
  Future<void> addCategory(Category category);
  Future<void> deleteCategory(String id);
  Future<void> updateCategory(Category category);
  Future<List<Category>> getAllCategories();
  Future<Category?> getCategoryById(String id);
}
