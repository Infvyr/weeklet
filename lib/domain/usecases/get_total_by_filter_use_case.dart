import 'package:weeklet/domain/repositories/expense_repository.dart';
import 'package:weeklet/domain/usecases/base/use_case.dart';

class TotalByFilterParams {
  TotalByFilterParams({required this.type, this.year, this.month, this.category});

  final String type;
  final int? year;
  final int? month;
  final String? category;
}

class GetTotalByFilterUseCase extends UseCase<double, TotalByFilterParams> {
  GetTotalByFilterUseCase(this.repository);
  final ExpenseRepository repository;

  @override
  Future<double> call(TotalByFilterParams params) => repository.getTotalAmountByFilter(
    type: params.type,
    year: params.year,
    month: params.month,
    category: params.category,
  );
}
