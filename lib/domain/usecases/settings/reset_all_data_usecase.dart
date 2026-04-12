import 'package:weeklet/domain/repositories/category_repository.dart';
import 'package:weeklet/domain/repositories/expense_repository.dart';
import 'package:weeklet/domain/repositories/income_repository.dart';
import 'package:weeklet/domain/repositories/settings_repository.dart';
import 'package:weeklet/domain/usecases/base/use_case.dart';

class ResetAllDataUseCase implements UseCase<void, NoParams> {
  const ResetAllDataUseCase({
    required this.expenseRepository,
    required this.incomeRepository,
    required this.categoryRepository,
    required this.settingsRepository,
  });

  final ExpenseRepository expenseRepository;
  final IncomeRepository incomeRepository;
  final CategoryRepository categoryRepository;
  final SettingsRepository settingsRepository;

  @override
  Future<void> call(NoParams params) async {
    await expenseRepository.clearAll();
    await incomeRepository.clearAll();
    await categoryRepository.clearAll();
    await settingsRepository.clearAll();
  }
}
