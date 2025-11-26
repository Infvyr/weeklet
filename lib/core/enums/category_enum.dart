enum CategoryType {
  salary,
  shopping,
  utilities,
  car,
  internetTv,
  other,
  savings,
}

extension CategoryTypeExtension on CategoryType {
  String get displayName => switch (this) {
    CategoryType.salary => 'Salary',
    CategoryType.shopping => 'Shopping',
    CategoryType.utilities => 'Comunals',
    CategoryType.car => 'Vehicle',
    CategoryType.internetTv => 'Internet/TV',
    CategoryType.other => 'Other',
    CategoryType.savings => 'Savings',
  };

  String get dbValue => name;
}
