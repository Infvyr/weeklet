import 'package:weeklet/domain/entities/category.dart';
import 'package:weeklet/domain/repositories/category_repository.dart';
import 'package:weeklet/domain/usecases/base/use_case.dart';

class AddCategoryUseCase implements UseCase<void, Category> {
  AddCategoryUseCase(this.repository);

  final CategoryRepository repository;

  @override
  Future<void> call(Category params) => repository.addCategory(params);
}
