import 'package:weeklet/data/datasources/local/category_local_datasource.dart';
import 'package:weeklet/domain/entities/category.dart';
import 'package:weeklet/domain/repositories/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  CategoryRepositoryImpl(this.localDataSource);

  final CategoryLocalDataSource localDataSource;

  @override
  Future<void> addCategory(Category category) => localDataSource.addCategory(category);

  @override
  Future<void> deleteCategory(String id) => localDataSource.deleteCategory(id);

  @override
  Future<void> updateCategory(Category category) =>
      localDataSource.updateCategory(category);

  @override
  Future<List<Category>> getAllCategories() => localDataSource.getAllCategories();

  @override
  Future<Category?> getCategoryById(String id) => localDataSource.getCategoryById(id);
}
