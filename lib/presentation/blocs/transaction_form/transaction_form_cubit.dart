import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'package:weeklet/core/enums/category_enum.dart';
import 'package:weeklet/core/enums/transaction_type_enum.dart';
import 'package:weeklet/domain/entities/transaction.dart';
import 'package:weeklet/domain/usecases/add_transaction_use_case.dart';

import 'transaction_form_state.dart';

class TransactionFormCubit extends Cubit<TransactionFormState> {
  TransactionFormCubit({
    required this.addTransaction,
    required this.uuid,
  }) : super(TransactionFormState.initial());

  final AddTransactionUseCase addTransaction;
  final Uuid uuid;

  void setType(TransactionType newType) => emit(
    state.copyWith(type: newType.dbValue),
  );
  void setAmount(double newAmount) => emit(
    state.copyWith(amount: newAmount),
  );
  void setDate(DateTime newDate) => emit(
    state.copyWith(date: newDate),
  );
  void setCategory(CategoryType newCategory) => emit(
    state.copyWith(category: newCategory.dbValue),
  );
  void setNotes(String notes) => emit(
    state.copyWith(notes: notes),
  );

  Future<void> saveTransaction() async {
    if (state.category.isEmpty) {
      emit(
        state.copyWith(
          errorMessage: 'Category must be choosen',
          status: FormStatus.failure,
        ),
      );
      return;
    }
    if (state.amount <= 0) {
      emit(
        state.copyWith(
          errorMessage: 'Amount must be > 0',
          status: FormStatus.failure,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        status: FormStatus.loading,
        errorMessage: null,
      ),
    );

    try {
      final newTransaction = Transaction(
        id: uuid.v4(),
        date: state.date,
        amount: state.amount,
        category: state.category,
        notes: state.notes,
        type: state.type,
      );

      await addTransaction(newTransaction);

      emit(TransactionFormState.initial());
      emit(
        state.copyWith(status: FormStatus.success),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: FormStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
