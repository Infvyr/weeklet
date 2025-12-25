sealed class CategoryEvent {
  const CategoryEvent();
}

final class AddCategoryEvent extends CategoryEvent {
  const AddCategoryEvent({
    required this.name,
    required this.icon,
  });

  final String name;
  final String icon;
}

final class UpdateCategoryEvent extends CategoryEvent {
  const UpdateCategoryEvent({
    required this.id,
    required this.name,
    required this.icon,
    required this.createdAt,
  });

  final String id;
  final String name;
  final String icon;
  final DateTime createdAt;
}

final class DeleteCategoryEvent extends CategoryEvent {
  const DeleteCategoryEvent({
    required this.id,
  });

  final String id;
}

final class GetAllCategoriesEvent extends CategoryEvent {
  const GetAllCategoriesEvent();
}

final class GetCategoryByIdEvent extends CategoryEvent {
  const GetCategoryByIdEvent({
    required this.id,
  });

  final String id;
}
