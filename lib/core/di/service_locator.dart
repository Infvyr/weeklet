import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:weeklet/data/datasources/local/category_local_datasource.dart';
import 'package:weeklet/data/datasources/local/expense_local_datasource.dart';
import 'package:weeklet/data/models/category_model.dart';
import 'package:weeklet/data/models/expense_model.dart';
import 'package:weeklet/data/repositories/category_repository_impl.dart';
import 'package:weeklet/data/repositories/expense_repository_impl.dart';
import 'package:weeklet/domain/repositories/category_repository.dart';
import 'package:weeklet/domain/repositories/expense_repository.dart';
import 'package:weeklet/domain/usecases/category/add_category_usecase.dart';
import 'package:weeklet/domain/usecases/category/delete_category_usecase.dart';
import 'package:weeklet/domain/usecases/category/get_all_categories_usecase.dart';
import 'package:weeklet/domain/usecases/category/get_single_category_usecase.dart';
import 'package:weeklet/domain/usecases/category/update_category_usecase.dart';
import 'package:weeklet/domain/usecases/expense/add_expense_usecase.dart';
import 'package:weeklet/domain/usecases/expense/delete_expense_usecase.dart';
import 'package:weeklet/domain/usecases/expense/get_all_expenses_usecase.dart';
import 'package:weeklet/domain/usecases/expense/get_expenses_by_month_year_usecase.dart';
import 'package:weeklet/domain/usecases/expense/update_expense_usecase.dart';
import 'package:weeklet/presentation/blocs/category/category_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Initialize Hive
  final appDocumentDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);

  // Register adapters
  Hive.registerAdapter(CategoryModelAdapter());
  Hive.registerAdapter(ExpenseModelAdapter());

  // Open boxes and register singletons
  final categoryBox = await Hive.openBox<CategoryModel>('categories');
  final expenseBox = await Hive.openBox<ExpenseModel>('expenses');

  sl.registerSingleton<Box<CategoryModel>>(categoryBox);
  sl.registerSingleton<Box<ExpenseModel>>(expenseBox);

  sl.registerLazySingleton(() => const Uuid());

  // DATA layer - DataSources
  sl.registerLazySingleton<CategoryLocalDataSource>(
    () => CategoryLocalDataSourceImpl(sl<Box<CategoryModel>>()),
  );

  sl.registerLazySingleton<ExpenseLocalDataSource>(
    () => ExpenseLocalDataSourceImpl(sl<Box<ExpenseModel>>()),
  );

  // DATA layer - Repositories
  sl.registerLazySingleton<CategoryRepository>(
    () => CategoryRepositoryImpl(sl<CategoryLocalDataSource>()),
  );

  sl.registerLazySingleton<ExpenseRepository>(
    () => ExpenseRepositoryImpl(sl<ExpenseLocalDataSource>()),
  );

  // DOMAIN layer - UseCases (Category)
  sl.registerLazySingleton(() => AddCategoryUseCase(sl<CategoryRepository>()));
  sl.registerLazySingleton(() => DeleteCategoryUseCase(sl<CategoryRepository>()));
  sl.registerLazySingleton(() => UpdateCategoryUseCase(sl<CategoryRepository>()));
  sl.registerLazySingleton(() => GetAllCategoriesUseCase(sl<CategoryRepository>()));
  sl.registerLazySingleton(() => GetSingleCategoryUseCase(sl<CategoryRepository>()));

  // DOMAIN layer - UseCases (Expense)
  sl.registerLazySingleton(() => AddExpenseUseCase(sl<ExpenseRepository>()));
  sl.registerLazySingleton(() => DeleteExpenseUseCase(sl<ExpenseRepository>()));
  sl.registerLazySingleton(() => UpdateExpenseUseCase(sl<ExpenseRepository>()));
  sl.registerLazySingleton(() => GetExpensesByMonthYearUseCase(sl<ExpenseRepository>()));
  sl.registerLazySingleton(() => GetAllExpensesUseCase(sl<ExpenseRepository>()));

  // PRESENTATION layer - Blocs (Category)
  sl.registerLazySingleton(
    () => CategoryBloc(
      addCategoryUseCase: sl<AddCategoryUseCase>(),
      updateCategoryUseCase: sl<UpdateCategoryUseCase>(),
      deleteCategoryUseCase: sl<DeleteCategoryUseCase>(),
      getAllCategoriesUseCase: sl<GetAllCategoriesUseCase>(),
      getCategoryByIdUseCase: sl<GetSingleCategoryUseCase>(),
      uuid: sl<Uuid>(),
    ),
  );
}
