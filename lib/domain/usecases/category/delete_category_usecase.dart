import 'package:weeklet/domain/repositories/category_repository.dart';
import 'package:weeklet/domain/usecases/base/use_case.dart';

class DeleteCategoryUseCase implements UseCase<void, String> {
  DeleteCategoryUseCase(this.repository);

  final CategoryRepository repository;

  @override
  Future<void> call(String params) async {
    if (params.trim().isEmpty) {
      throw ArgumentError('Category ID cannot be empty');
    }
    return repository.deleteCategory(params);
  }
}
