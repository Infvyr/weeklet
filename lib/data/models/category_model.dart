import 'package:hive_flutter/hive_flutter.dart';
import 'package:weeklet/domain/entities/category.dart';

part 'category_model.g.dart';

@HiveType(typeId: 0)
class CategoryModel {
  CategoryModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.createdAt,
  });

  factory CategoryModel.fromEntity(
    Category entity,
  ) => CategoryModel(
    id: entity.id,
    name: entity.name,
    icon: entity.icon,
    createdAt: entity.createdAt,
  );

  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String icon;

  @HiveField(3)
  final DateTime createdAt;

  Category toEntity() => Category(
    id: id,
    name: name,
    icon: icon,
    createdAt: createdAt,
  );

  CategoryModel copyWith({
    String? id,
    String? name,
    String? icon,
    DateTime? createdAt,
  }) => CategoryModel(
    id: id ?? this.id,
    name: name ?? this.name,
    icon: icon ?? this.icon,
    createdAt: createdAt ?? this.createdAt,
  );

  @override
  String toString() =>
      'CategoryModel(id: $id, name: $name, icon: $icon, createdAt: $createdAt)';
}
