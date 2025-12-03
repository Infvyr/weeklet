import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart' show Uuid;
import 'package:weeklet/domain/entities/category.dart';
import 'package:weeklet/domain/usecases/base/use_case.dart';
import 'package:weeklet/domain/usecases/category/add_category_usecase.dart';
import 'package:weeklet/domain/usecases/category/delete_category_usecase.dart';
import 'package:weeklet/domain/usecases/category/get_all_categories_usecase.dart';
import 'package:weeklet/domain/usecases/category/get_single_category_usecase.dart';
import 'package:weeklet/domain/usecases/category/update_category_usecase.dart';
import 'package:weeklet/presentation/blocs/category/category_event.dart';
import 'package:weeklet/presentation/blocs/category/category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  CategoryBloc({
    required this.addCategoryUseCase,
    required this.updateCategoryUseCase,
    required this.deleteCategoryUseCase,
    required this.getAllCategoriesUseCase,
    required this.getCategoryByIdUseCase,
    required this.uuid,
  }) : super(const CategoryInitial()) {
    on<AddCategoryEvent>(_onAddCategory);
    on<UpdateCategoryEvent>(_onUpdateCategory);
    on<DeleteCategoryEvent>(_onDeleteCategory);
    on<GetAllCategoriesEvent>(_onGetAllCategories);
    on<GetCategoryByIdEvent>(_onGetCategoryById);
  }

  final AddCategoryUseCase addCategoryUseCase;
  final UpdateCategoryUseCase updateCategoryUseCase;
  final DeleteCategoryUseCase deleteCategoryUseCase;
  final GetAllCategoriesUseCase getAllCategoriesUseCase;
  final GetSingleCategoryUseCase getCategoryByIdUseCase;
  final Uuid uuid;

  Future<void> _onAddCategory(
    AddCategoryEvent event,
    Emitter<CategoryState> emit,
  ) async {
    emit(const CategoryLoading());
    try {
      final category = Category(
        id: uuid.v4(),
        name: event.name,
        icon: event.icon,
      );
      await addCategoryUseCase(category);
      emit(const CategorySuccess(message: 'Category added successfully'));
      add(const GetAllCategoriesEvent());
    } catch (e) {
      debugPrint('error in _onAddCategory: $e');
      emit(CategoryError(message: e.toString()));
    }
  }

  Future<void> _onUpdateCategory(
    UpdateCategoryEvent event,
    Emitter<CategoryState> emit,
  ) async {
    emit(const CategoryLoading());
    try {
      final category = Category(
        id: event.id,
        name: event.name,
        icon: event.icon,
      );
      await updateCategoryUseCase(category);
      emit(const CategorySuccess(message: 'Category updated successfully'));
      add(const GetAllCategoriesEvent());
    } catch (e) {
      debugPrint('error in _onUpdateCategory: $e');
      emit(CategoryError(message: e.toString()));
    }
  }

  Future<void> _onDeleteCategory(
    DeleteCategoryEvent event,
    Emitter<CategoryState> emit,
  ) async {
    emit(const CategoryLoading());
    try {
      await deleteCategoryUseCase(event.id);
      emit(const CategorySuccess(message: 'Category deleted successfully'));
      add(const GetAllCategoriesEvent());
    } catch (e) {
      debugPrint('error in _onDeleteCategory: $e');
      emit(CategoryError(message: e.toString()));
    }
  }

  Future<void> _onGetAllCategories(
    GetAllCategoriesEvent event,
    Emitter<CategoryState> emit,
  ) async {
    emit(const CategoryLoading());
    try {
      final categories = await getAllCategoriesUseCase(NoParams());
      emit(CategoriesLoaded(categories: categories));
    } catch (e) {
      debugPrint('error in _onGetAllCategories: $e');
      emit(CategoryError(message: e.toString()));
    }
  }

  Future<void> _onGetCategoryById(
    GetCategoryByIdEvent event,
    Emitter<CategoryState> emit,
  ) async {
    emit(const CategoryLoading());
    try {
      final category = await getCategoryByIdUseCase(event.id);
      if (category != null) {
        emit(CategoryLoaded(category: category));
      } else {
        emit(const CategoryError(message: 'Category not found'));
      }
    } catch (e) {
      debugPrint('error in _onGetCategoryById: $e');
      emit(CategoryError(message: e.toString()));
    }
  }
}
