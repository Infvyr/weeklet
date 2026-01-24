# Claude Code Rules for Weeklet Project

This document defines rules and conventions for Claude Code when working with the Weeklet Flutter project.

## Architecture Overview

This project follows **Clean Architecture** with three distinct layers:
- **Domain Layer** (`lib/domain/`) - Business logic and entities (framework-independent)
- **Data Layer** (`lib/data/`) - Data sources, models, and repository implementations
- **Presentation Layer** (`lib/presentation/`) - UI, BLoC state management, and screens

**State Management**: Flutter BLoC pattern
**Dependency Injection**: GetIt service locator
**Local Storage**: Hive (NoSQL database)

---

## Core Principles

### 1. Separation of Concerns

**ALWAYS** maintain strict layer separation:

- **Widgets** (`lib/presentation/screens/`, `lib/presentation/widgets/`)
  - Contain ONLY UI code and user interaction handlers
  - NO business logic, validation, or data manipulation
  - Dispatch BLoC events for any state changes
  - Use BlocBuilder/BlocListener to react to state

- **Business Logic** (`lib/domain/usecases/`)
  - All validation, calculations, and business rules
  - Pure functions with no UI or framework dependencies
  - Return success/failure results to BLoC layer

- **Data Layer** (`lib/data/`)
  - Database operations and external API calls only
  - Convert between Models (Hive) and Entities (domain)
  - NO business logic or validation

### 2. Flutter BLoC Pattern

**Event-Driven Architecture**:

```dart
// User interaction in widget
onPressed: () => context.read<ExpenseBloc>().add(
  AddExpenseStarted(amount: amount, description: description)
)

// BLoC handles event
Future<void> _onAddExpense(event, emit) async {
  emit(const ExpenseLoading());
  try {
    await addExpenseUseCase(expense);
    emit(const ExpenseSuccess(...));
  } catch (e) {
    emit(ExpenseError(message: e.toString()));
  }
}

// Widget reacts to state
BlocBuilder<ExpenseBloc, ExpenseState>(
  builder: (context, state) => switch (state) {
    ExpenseLoading _ => const CircularProgressIndicator(),
    ExpenseSuccess success => ExpenseList(expenses: success.expenses),
    ExpenseError error => ErrorView(message: error.message),
    _ => const SizedBox.shrink(),
  },
)
```

**Rules**:
- Use **sealed classes** for all Events and States (enables exhaustive pattern matching)
- Event handlers should be **private** (`_onEventName`)
- Always emit **loading state** before async operations
- Emit **success/error states** after operations complete
- BLoCs should ONLY orchestrate use cases, not contain business logic

### 3. Use Cases Pattern

**Every business operation must have a dedicated use case**:

```dart
// lib/domain/usecases/expense/add_expense_use_case.dart
class AddExpenseUseCase implements UseCase<void, Expense> {
  const AddExpenseUseCase(this.repository);

  final ExpenseRepository repository;

  @override
  Future<void> call(Expense params) async {
    // Validation logic here
    if (params.amount <= 0) {
      throw Exception('Amount must be greater than 0');
    }
    if (params.description.trim().isEmpty) {
      throw Exception('Description cannot be empty');
    }

    // Delegate to repository
    await repository.addExpense(params);
  }
}
```

**Rules**:
- Implement `UseCase<ReturnType, ParametersType>` base class
- Place in `lib/domain/usecases/<feature>/`
- Name pattern: `<Verb><Entity>UseCase` (e.g., `GetCategoryByIdUseCase`)
- Contain validation and business logic
- Call repository methods for data operations
- Throw exceptions for error handling

### 4. Dependency Injection with GetIt

**All dependencies must be registered in** [lib/core/di/service_locator.dart](lib/core/di/service_locator.dart)

**Registration order**:
1. External dependencies (Hive boxes, utilities)
2. Data sources (`registerLazySingleton`)
3. Repositories (`registerLazySingleton`)
4. Use cases (`registerLazySingleton`)
5. BLoCs (`registerLazySingleton`)

**Example**:
```dart
// 1. Data source
sl.registerLazySingleton<ExpenseLocalDataSource>(
  () => ExpenseLocalDataSourceImpl(sl<Box<ExpenseModel>>()),
);

// 2. Repository
sl.registerLazySingleton<ExpenseRepository>(
  () => ExpenseRepositoryImpl(sl<ExpenseLocalDataSource>()),
);

// 3. Use cases
sl.registerLazySingleton(() => AddExpenseUseCase(sl<ExpenseRepository>()));

// 4. BLoC with all dependencies
sl.registerLazySingleton(
  () => ExpenseBloc(
    addExpenseUseCase: sl<AddExpenseUseCase>(),
    updateExpenseUseCase: sl<UpdateExpenseUseCase>(),
    // ... other use cases
  ),
);
```

**Access in code**:
```dart
// Import the service locator
import 'package:weeklet/core/di/service_locator.dart' as di;

// Access registered instances
di.sl<ExpenseBloc>().add(const LoadExpensesRequested());
```

**Rules**:
- Use `registerLazySingleton` for most services (created on first use)
- Use `registerSingleton` only for instances created during initialization
- NEVER instantiate BLoCs, repositories, or use cases directly with `new` or constructors
- Always inject dependencies through constructor parameters

### 5. Widget Structure

**Widgets should be small, composable, and single-purpose**:

```dart
// BAD: Monolithic widget with business logic
class ExpenseItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final expense = context.watch<ExpenseBloc>().state.expense;
    final formattedAmount = '\$${expense.amount.toStringAsFixed(2)}';

    // Business logic in widget - BAD!
    if (expense.amount > 100) {
      showWarning();
    }

    return Row(/* ... lots of nested widgets ... */);
  }
}

// GOOD: Composed widgets, no business logic
class ExpenseItemView extends StatelessWidget {
  const ExpenseItemView({
    required this.expense,
    required this.category,
  });

  final Expense expense;
  final Category? category;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      CategoryIconCircle(category: category),
      Expanded(
        child: ExpenseDetailsColumn(
          description: expense.description,
          categoryName: category?.name ?? 'Unknown',
        ),
      ),
      ExpenseAmountText(amount: expense.amount),
      ExpenseMenuButton(expense: expense),
    ],
  );
}
```

**Rules**:
- Break complex widgets into smaller, reusable components
- Pass data as **constructor parameters**, not through context.watch in deep widgets
- NO calculations, formatting, or business logic in widgets
- Use domain utilities for grouping/filtering (e.g., `ExpenseGrouping.groupByWeek()`)
- Name widgets descriptively: `<Feature><Purpose>View` (e.g., `ExpenseItemView`, `CategoryIconCircle`)
- Place reusable widgets in `lib/presentation/widgets/common/`
- Place feature-specific widgets in `lib/presentation/screens/<feature>/widgets/`

### 6. Data Layer Patterns

**Repository Implementation Pattern**:

```dart
// Abstract repository in domain layer
// lib/domain/repositories/expense_repository.dart
abstract class ExpenseRepository {
  Future<void> addExpense(Expense expense);
  Future<List<Expense>> getAllExpenses();
  Future<Expense?> getExpenseById(String id);
  Future<void> updateExpense(Expense expense);
  Future<void> deleteExpense(String id);
}

// Implementation in data layer
// lib/data/repositories/expense_repository_impl.dart
class ExpenseRepositoryImpl implements ExpenseRepository {
  const ExpenseRepositoryImpl(this.localDataSource);

  final ExpenseLocalDataSource localDataSource;

  @override
  Future<void> addExpense(Expense expense) async {
    final model = ExpenseModel.fromEntity(expense);
    await localDataSource.addExpense(model);
  }

  @override
  Future<List<Expense>> getAllExpenses() async {
    final models = await localDataSource.getAllExpenses();
    return models.map((model) => model.toEntity()).toList();
  }
}
```

**Model Conversion Pattern**:

```dart
@HiveType(typeId: 1)
class ExpenseModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final double amount;

  // ... other fields

  // Convert from domain entity
  factory ExpenseModel.fromEntity(Expense entity) => ExpenseModel(
    id: entity.id,
    amount: entity.amount,
    // ... map all fields
  );

  // Convert to domain entity
  Expense toEntity() => Expense(
    id: id,
    amount: amount,
    // ... map all fields
  );
}
```

**Rules**:
- Repository interfaces MUST be in `lib/domain/repositories/`
- Repository implementations MUST be in `lib/data/repositories/`
- Always convert Models ↔ Entities at repository boundary
- Data sources work with Models, domain layer works with Entities
- Use Hive TypeAdapters for all models (register in service_locator.dart)

### 7. File Organization

**Naming Conventions**:
- Files: `snake_case.dart`
- Classes: `PascalCase`
- Variables/functions: `camelCase`
- Constants: `camelCase` or `SCREAMING_SNAKE_CASE` for compile-time constants
- Private members: prefix with `_`

**Directory Structure for New Features**:

```
lib/
├── domain/
│   ├── entities/
│   │   └── feature_name.dart
│   ├── repositories/
│   │   └── feature_name_repository.dart
│   └── usecases/
│       └── feature_name/
│           ├── add_feature_name_use_case.dart
│           ├── get_feature_name_use_case.dart
│           └── delete_feature_name_use_case.dart
├── data/
│   ├── models/
│   │   └── feature_name_model.dart
│   ├── datasources/
│   │   └── local/
│   │       └── feature_name_local_data_source.dart
│   └── repositories/
│       └── feature_name_repository_impl.dart
└── presentation/
    ├── blocs/
    │   └── feature_name/
    │       ├── feature_name_bloc.dart
    │       ├── feature_name_event.dart
    │       └── feature_name_state.dart
    └── screens/
        └── feature_name/
            ├── feature_name_screen.dart
            └── widgets/
                ├── feature_name_item_view.dart
                └── feature_name_list_view.dart
```

### 8. State Management Patterns

**Loading States**:
```dart
BlocBuilder<ExpenseBloc, ExpenseState>(
  builder: (context, state) => switch (state) {
    ExpenseLoading _ => const Center(
      child: CircularProgressIndicator.adaptive(),
    ),
    ExpenseSuccess success => ExpenseContent(data: success.expenses),
    ExpenseError error => ErrorView(message: error.message),
    _ => const SizedBox.shrink(),
  },
)
```

**Multiple BLoC Dependencies**:
```dart
@override
Widget build(BuildContext context) {
  final expenseState = context.watch<ExpenseBloc>().state;
  final categoryState = context.watch<CategoryBloc>().state;

  return switch ((expenseState, categoryState)) {
    (ExpenseLoading _, _) || (_, CategoryLoading _) =>
      const LoadingView(),

    (final ExpenseSuccess expSuccess, final CategoriesLoaded catLoaded) =>
      ContentView(
        expenses: expSuccess.expenses,
        categories: catLoaded.categories,
      ),

    _ => const SizedBox.shrink(),
  };
}
```

**Form Validation**:
- Use case layer for business validation
- Widget layer for UI validation (TextFormField validators)
- Show validation errors via BLoC error states

### 9. Common Utilities

**Available Extensions** (in `lib/core/extensions/`):
- `context.theme` - Access theme data
- `context.colorScheme` - Access color scheme
- `context.textTheme` - Access text theme
- `context.screenWidth` / `context.screenHeight` - Screen dimensions
- `context.showSnackBar(message)` - Show snackbar
- DateTime extensions for date manipulation

**Domain Utilities** (in `lib/domain/utils/`):
- `ExpenseGrouping.groupByWeek(expenses)` - Group expenses by ISO week
- `ExpenseGrouping.groupByDay(expenses)` - Group expenses by day
- Use these for data presentation, NOT custom widget logic

### 10. Error Handling

**Pattern**:
```dart
// In use case
if (params.amount <= 0) {
  throw Exception('Amount must be greater than 0');
}

// In BLoC
try {
  await useCase(params);
  emit(const FeatureSuccess(message: 'Operation successful'));
} catch (e) {
  emit(FeatureError(message: e.toString()));
}

// In widget
BlocListener<FeatureBloc, FeatureState>(
  listener: (context, state) {
    if (state is FeatureError) {
      context.showSnackBar(state.message);
    }
    if (state is FeatureSuccess) {
      context.showSnackBar(state.message);
      Navigator.pop(context);
    }
  },
  child: /* ... */,
)
```

**Rules**:
- Use cases throw exceptions for validation/business errors
- BLoC catches exceptions and emits error states
- Widgets listen to error states and show UI feedback
- Use `BlocListener` for side effects (navigation, snackbars)
- Use `BlocBuilder` for UI updates

### 11. Testing Strategy

When writing tests:
- **Unit tests** for use cases (test business logic in isolation)
- **Widget tests** for UI components (test rendering and interactions)
- **BLoC tests** for state management (test event → state transitions)
- Mock repositories and data sources using test doubles
- Use `mockito` or `mocktail` for mocking

---

## Quick Checklist for New Features

- [ ] Create domain entity in `lib/domain/entities/`
- [ ] Create repository interface in `lib/domain/repositories/`
- [ ] Create use cases in `lib/domain/usecases/<feature>/`
- [ ] Create Hive model in `lib/data/models/` with `fromEntity/toEntity`
- [ ] Create data source in `lib/data/datasources/local/`
- [ ] Implement repository in `lib/data/repositories/`
- [ ] Create BLoC (events, states, bloc) in `lib/presentation/blocs/<feature>/`
- [ ] Register all dependencies in [lib/core/di/service_locator.dart](lib/core/di/service_locator.dart)
- [ ] Create screen in `lib/presentation/screens/<feature>/`
- [ ] Create widgets in `lib/presentation/screens/<feature>/widgets/`
- [ ] Add route in `lib/core/router/` if needed
- [ ] Provide BLoC in [lib/app.dart](lib/app.dart) MultiBlocProvider

---

## Anti-Patterns to Avoid

### DON'T: Business Logic in Widgets
```dart
// BAD
class ExpenseForm extends StatelessWidget {
  void _submit() {
    if (amount <= 0) {  // Validation in widget
      showError('Invalid amount');
      return;
    }
    // Direct repository access in widget
    repository.addExpense(expense);
  }
}
```

### DON'T: Direct Repository Access in BLoC
```dart
// BAD
class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  Future<void> _onAddExpense(event, emit) async {
    // Direct repository call without use case
    await repository.addExpense(expense);
  }
}
```

### DON'T: Creating BLoCs with Constructors
```dart
// BAD
BlocProvider(
  create: (_) => ExpenseBloc(
    addExpenseUseCase: AddExpenseUseCase(...),  // Manual instantiation
  ),
)

// GOOD
BlocProvider.value(
  value: di.sl<ExpenseBloc>(),  // Use GetIt service locator
)
```

### DON'T: Mixing Layers
```dart
// BAD - Data model in presentation layer
class ExpenseListView extends StatelessWidget {
  final List<ExpenseModel> expenses;  // Should be List<Expense> (entity)
}

// BAD - Hive box in widget
class CategoryScreen extends StatelessWidget {
  void _loadData() {
    final box = Hive.box<CategoryModel>('categories');  // Data access in UI
  }
}
```

---

## Summary

**Golden Rules**:
1. **Widgets = UI only** - No business logic, validation, or data access
2. **Use Cases = Business logic** - All validation and rules
3. **BLoCs = Orchestration** - Connect UI events to use cases
4. **Repositories = Data abstraction** - Hide implementation details
5. **GetIt = Dependency provider** - No manual instantiation
6. **Sealed classes** - Type-safe events and states
7. **Model ↔ Entity conversion** - At repository boundary only

When in doubt, follow the existing patterns in:
- [lib/presentation/screens/expenses/](lib/presentation/screens/expenses/) for screen structure
- [lib/presentation/blocs/expense/](lib/presentation/blocs/expense/) for BLoC patterns
- [lib/domain/usecases/expense/](lib/domain/usecases/expense/) for use case examples
- [lib/core/di/service_locator.dart](lib/core/di/service_locator.dart) for dependency injection
