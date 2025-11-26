import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart' show Uuid;
import 'package:weeklet/data/models/transaction_model.dart';
import 'package:weeklet/data/repositories/expense_repository_impl.dart';
import 'package:weeklet/domain/repositories/expense_repository.dart';
import 'package:weeklet/domain/usecases/add_transaction_use_case.dart';
import 'package:weeklet/domain/usecases/get_total_by_filter_use_case.dart';
import 'package:weeklet/domain/usecases/get_transactions_by_month_use_case.dart';
import 'package:weeklet/domain/usecases/get_weekly_expense_summary_use_case.dart';
import 'package:weeklet/presentation/blocs/expense/expense_cubit.dart';
import 'package:weeklet/presentation/blocs/transaction_form/transaction_form_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  final appDocumentDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);

  Hive.registerAdapter(TransactionModelAdapter());

  final transactionBox = await Hive.openBox<TransactionModel>('transactions');
  sl.registerSingleton<Box<TransactionModel>>(transactionBox);

  sl.registerLazySingleton(() => const Uuid());

  // DATA layer
  sl.registerLazySingleton<ExpenseRepository>(
    () => ExpenseRepositoryImpl(sl()),
  );

  // DOMAIN
  sl.registerFactory(() => GetTotalByFilterUseCase(sl()));
  sl.registerFactory(() => GetTransactionsByMonthUseCase(sl()));
  sl.registerFactory(() => AddTransactionUseCase(sl()));
  sl.registerFactory(() => GetWeeklyExpenseSummaryUseCase(sl()));

  // PRESENTATION
  sl.registerFactory(
    () => ExpenseCubit(
      getTotalByFilter: sl(),
      getTransactionsByMonth: sl(),
      getWeeklyExpenseSummary: sl(),
    ),
  );
  sl.registerFactory(
    () => TransactionFormCubit(
      addTransaction: sl(),
      uuid: sl(),
    ),
  );
}
