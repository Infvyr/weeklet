import 'package:weeklet/domain/entities/category.dart';

class CategoryModel {
  CategoryModel({
    required this.id,
    required this.name,
    required this.icon,
  });

  factory CategoryModel.fromEntity(Category entity) => CategoryModel(
    id: entity.id,
    name: entity.name,
    icon: entity.icon,
  );
  final String id;
  final String name;
  final String icon;

  Category toEntity() => Category(
    id: id,
    name: name,
    icon: icon,
  );

  CategoryModel copyWith({
    String? id,
    String? name,
    String? icon,
  }) => CategoryModel(
    id: id ?? this.id,
    name: name ?? this.name,
    icon: icon ?? this.icon,
  );

  @override
  String toString() => 'CategoryModel(id: $id, name: $name, icon: $icon)';
}
