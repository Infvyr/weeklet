import 'package:weeklet/domain/entities/category.dart';
import 'package:weeklet/domain/repositories/category_repository.dart';
import 'package:weeklet/domain/usecases/base/use_case.dart';

class UpdateCategoryUseCase implements UseCase<void, Category> {
  UpdateCategoryUseCase(
    this.repository,
  );
  final CategoryRepository repository;

  @override
  Future<void> call(
    Category params,
  ) async {
    if (params.id.trim().isEmpty) {
      throw ArgumentError(
        'Category ID cannot be empty',
      );
    }
    if (params.name.trim().isEmpty) {
      throw ArgumentError(
        'Category name cannot be empty',
      );
    }
    if (params.icon.trim().isEmpty) {
      throw ArgumentError(
        'Category icon cannot be empty',
      );
    }
    return repository.updateCategory(
      params,
    );
  }
}
