import 'package:weeklet/domain/entities/category.dart';
import 'package:weeklet/domain/repositories/category_repository.dart';
import 'package:weeklet/domain/usecases/base/use_case.dart';

class UpdateCategoryUseCase implements UseCase<void, Category> {
  UpdateCategoryUseCase(this.repository);
  final CategoryRepository repository;

  @override
  Future<void> call(Category params) => repository.updateCategory(params);
}
