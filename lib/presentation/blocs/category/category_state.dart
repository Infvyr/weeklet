import 'package:weeklet/domain/entities/category.dart';

sealed class CategoryState {
  const CategoryState();
}

final class CategoryInitial extends CategoryState {
  const CategoryInitial();
}

final class CategoryLoading extends CategoryState {
  const CategoryLoading();
}

final class CategoriesLoaded extends CategoryState {
  const CategoriesLoaded({required this.categories});

  final List<Category> categories;
}

final class CategoryLoaded extends CategoryState {
  const CategoryLoaded({required this.category});

  final Category category;
}

final class CategorySuccess extends CategoryState {
  const CategorySuccess({required this.message});

  final String message;
}

final class CategoryError extends CategoryState {
  const CategoryError({required this.message});

  final String message;
}
