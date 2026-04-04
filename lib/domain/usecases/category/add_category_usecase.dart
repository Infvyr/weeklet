import 'package:uuid/uuid.dart';
import 'package:weeklet/domain/entities/category.dart';
import 'package:weeklet/domain/repositories/category_repository.dart';
import 'package:weeklet/domain/usecases/base/use_case.dart';

class AddCategoryParams {
  const AddCategoryParams({
    required this.name,
    required this.icon,
    required this.createdAt,
  });

  final String name;
  final String icon;
  final DateTime createdAt;
}

class AddCategoryUseCase implements UseCase<void, AddCategoryParams> {
  AddCategoryUseCase(this.repository, this.uuid);

  final CategoryRepository repository;
  final Uuid uuid;

  @override
  Future<void> call(AddCategoryParams params) async {
    if (params.name.trim().isEmpty) {
      throw ArgumentError('Category name cannot be empty');
    }
    if (params.icon.trim().isEmpty) {
      throw ArgumentError('Category icon cannot be empty');
    }
    return repository.addCategory(
      Category(
        id: uuid.v4(),
        name: params.name,
        icon: params.icon,
        createdAt: params.createdAt,
      ),
    );
  }
}
