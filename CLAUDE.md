# Claude Code Rules for Weeklet Project

## Architecture

Clean Architecture with Flutter BLoC, GetIt DI, and Hive local storage.

```
lib/
├── core/        # DI, router, theme, extensions, utils
├── domain/      # entities, repository interfaces, use cases, domain utils
├── data/        # Hive models, data sources, repository implementations
└── presentation/ # BLoC, screens, widgets
```

### Layer Separation Rules

**Widgets** — UI and user interaction only:
- Dispatch BLoC events; never call repositories or use cases directly
- Never contain validation, calculations, or formatting logic
- Use `NumberFormatter` for amounts, domain utils for grouping — no raw logic
- Receive data as constructor parameters; don't dig into BLoC state deep in the tree

**BLoC** — orchestration only:
- Call use cases, never repositories directly
- Manage filter/pagination state (`selectedYear`, `selectedMonth`, etc.)
- Emit loading → success/failure; catch use case exceptions into error states
- No business rules or data formatting

**Use Cases** — all business logic:
- Validate inputs and throw exceptions on failure
- Call repository methods for data operations
- No UI, no Hive, no Flutter dependencies

**Repositories** — data abstraction only:
- Convert Models ↔ Entities; this is the only place this happens
- Delegate storage to data sources; no business logic

**Data Sources** — storage only:
- Work with Hive Models exclusively; no entity conversion

---

## Rules & Conventions

### Use Cases
- Every business operation needs a dedicated use case in `lib/domain/usecases/<feature>/`
- Implement `UseCase<ReturnType, Params>` from `lib/domain/usecases/base/use_case.dart`
- File naming: `add_expense_usecase.dart` (single word `usecase`, no underscore)
- Class naming: `AddExpenseUseCase`, `GetSingleCategoryUseCase`
- Throw exceptions for validation errors — BLoC catches them

### Data Layer
- **Data sources** work with Models only (Hive operations, no conversion)
- **Repositories** do all Model ↔ Entity conversion — nowhere else
- `StatisticsRepository` is composite: takes `ExpenseRepository`, `IncomeRepository`, `CategoryRepository`

### BLoC
- Sealed classes + `final class` subtypes for events and states
- Event handlers are private: `_onAddExpense`
- Success states carry filter state: `selectedYear`, `selectedMonth`, `availableYears`, `availableMonths`, `allExpenses`, `filteredExpenses`
- `actionError` field on success states for CRUD failures that don't leave the screen — use `copyWith(actionError: e.toString())`
- State class names: `ExpenseInitial`, `ExpenseLoading`, `ExpenseSuccess`, `ExpenseFailure` (not `ExpenseError`)

### Dependency Injection
- All registrations in [lib/core/di/service_locator.dart](lib/core/di/service_locator.dart)
- Registration order: Hive init → box singletons → utilities → data sources → repositories → use cases → BLoCs
- `StatsBloc` is registered before other BLoCs
- Always use `sl<Type>()` — never `new` or constructor calls for services
- `registerSingleton` for Hive boxes, `registerLazySingleton` for everything else

### Widgets
- Use `NumberFormatter` for all amount display — never format raw doubles in widgets
- Use domain utils for grouping: `ExpenseGrouping`, `IncomeGrouping`, `ExpenseFilterUtils`
- Use `export.dart` barrel files in widget subdirectories

### App Initialization
- `AppInitializer` (`lib/presentation/app_initializer.dart`) triggers initial data loads in `initState`
- Add new BLoC initial events there if data is needed on startup

---

## Available Utilities

**Context extensions** (`lib/core/extensions/context_extensions.dart`): `context.theme`, `context.colorScheme`, `context.textTheme`, `context.screenWidth/Height`, `context.isDarkMode`, `context.push()`, `context.pop()`, `context.showSnackBar()`, `context.showErrorSnackBar()`, `context.showSuccessSnackBar()`, `context.showCustomDialog()`, `context.unfocus()`, `context.locale`

**FormValidators** (`lib/core/utils/form_validators.dart`): `required`, `amountFormat`, `minLength`, `maxLength`, `compose([...])`

**NumberFormatter** (`lib/core/utils/number_formatter.dart`): `formatCurrency`, `formatCurrencyWithSign`

**Domain utils** (`lib/domain/utils/`): `ExpenseGrouping.groupByWeek/Day`, `IncomeGrouping.groupByWeek/Day`, `ExpenseFilterUtils.extractAvailableYears/Months`, `IncomeFilterUtils`

**Routes** (`lib/core/router/app_routes.dart`): `home`, `expensesScreen`, `incomeScreen`, `categoriesScreen`, `addCategoryScreen`, `statsScreen`, `settingsScreen`

---

## New Feature Checklist

- [ ] Entity in `lib/domain/entities/`
- [ ] Repository interface in `lib/domain/repositories/`
- [ ] Use cases in `lib/domain/usecases/<feature>/`
- [ ] Hive model in `lib/data/models/` with `fromEntity`/`toEntity`
- [ ] Data source in `lib/data/datasources/local/`
- [ ] Repository impl in `lib/data/repositories/`
- [ ] BLoC (events, states, bloc) in `lib/presentation/blocs/<feature>/`
- [ ] Register adapter, boxes, data source, repo, use cases, BLoC in `service_locator.dart`
- [ ] Screen + widgets in `lib/presentation/screens/<feature>/`
- [ ] Route in `app_routes.dart` if needed
- [ ] `BlocProvider.value(value: sl<FeatureBloc>())` in [lib/app.dart](lib/app.dart)
- [ ] Initial load event in `app_initializer.dart` if needed

---

## Reference Patterns

Follow existing code for concrete examples:
- Screen structure → [lib/presentation/screens/expenses/](lib/presentation/screens/expenses/)
- BLoC patterns → [lib/presentation/blocs/expense/](lib/presentation/blocs/expense/)
- Use case examples → [lib/domain/usecases/expense/](lib/domain/usecases/expense/)
- DI registration → [lib/core/di/service_locator.dart](lib/core/di/service_locator.dart)
