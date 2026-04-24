---
phase: 01-architecture-cleanup
plan: 02
subsystem: domain
tags: [flutter, bloc, use-case, uuid, validation, dart]

# Dependency graph
requires:
  - phase: 01-architecture-cleanup plan 01
    provides: Test stubs for AddExpenseUseCase and AddIncomeUseCase (AddExpenseParams, AddIncomeParams types expected)
provides:
  - AddExpenseParams class and refactored AddExpenseUseCase(repository, uuid) with amount validation and UUID generation
  - AddIncomeParams class and refactored AddIncomeUseCase(repository, uuid) implementing UseCase<void, AddIncomeParams>
  - AddCategoryParams class and refactored AddCategoryUseCase(repository, uuid) with UUID generation
  - ExpenseBloc, IncomeBloc, CategoryBloc with uuid field removed; pure orchestrators passing raw event data to use cases
  - DI updated: sl<Uuid>() injected into the three Add use cases, removed from all BLoC registrations
affects: [phase 02, phase 03, phase 04]

# Tech tracking
tech-stack:
  added: []
  patterns: [ArgumentError for validation in use cases, Params value objects for use case inputs, UseCase interface implemented by AddIncomeUseCase]

key-files:
  created: []
  modified:
    - lib/domain/usecases/expense/add_expense_usecase.dart
    - lib/domain/usecases/income/add_income_use_case.dart
    - lib/domain/usecases/category/add_category_usecase.dart
    - lib/presentation/blocs/expense/expense_bloc.dart
    - lib/presentation/blocs/income/income_bloc.dart
    - lib/presentation/blocs/category/category_bloc.dart
    - lib/core/di/service_locator.dart
    - lib/presentation/screens/expenses/widgets/add_expense_form_view.dart

key-decisions:
  - "Standardized AddIncomeUseCase to throw ArgumentError (not Exception) to match ARCH-01 convention"
  - "AddIncomeUseCase now implements UseCase<void, AddIncomeParams> fixing the pre-existing interface inconsistency"
  - "After AddCategoryUseCase signature change (void return, UUID internal), fix add_expense_form_view.dart to query GetAllCategoriesUseCase post-creation to retrieve the new Daily category ID"

patterns-established:
  - "Params pattern: each Add use case has a corresponding XxxParams value class with raw String fields mirroring event fields"
  - "Use case validation order: amount parsing first, then description, then categoryId (consistent across expense/income/category)"
  - "BLoC ArgumentError catch: separate on ArgumentError block forwarding e.message to actionError, generic catch emitting 'Could not add the X'"

requirements-completed: [ARCH-01, ARCH-02]

# Metrics
duration: 25min
completed: 2026-04-04
---

# Phase 01 Plan 02: Validation and UUID Refactor Summary

**Amount validation (string parse + <= 0 check) and UUID generation moved from BLoCs into AddExpenseUseCase, AddIncomeUseCase, and AddCategoryUseCase via new Params value objects**

## Performance

- **Duration:** ~25 min
- **Started:** 2026-04-04
- **Completed:** 2026-04-04
- **Tasks:** 2
- **Files modified:** 8

## Accomplishments

- All three Add use cases now own amount validation and UUID generation (ARCH-01, ARCH-02 complete)
- BLoCs are pure orchestrators: pass raw event strings directly to use cases, catch ArgumentError for inline validation feedback
- AddIncomeUseCase now implements `UseCase<void, AddIncomeParams>` and throws `ArgumentError` (not `Exception`), fixing the pre-existing inconsistency
- 11 unit tests pass covering amount validation and UUID generation for expense and income use cases
- Zero analyzer errors across the entire `lib/` directory

## Task Commits

1. **Task 1: Refactor AddExpenseUseCase and AddIncomeUseCase with Params types** - `7a86d66` (feat)
2. **Task 2: Refactor AddCategoryUseCase, update all BLoCs and DI** - `613babd` (feat)

## Files Created/Modified

- `lib/domain/usecases/expense/add_expense_usecase.dart` - AddExpenseParams + refactored use case; accepts (repository, uuid)
- `lib/domain/usecases/income/add_income_use_case.dart` - AddIncomeParams + refactored use case; implements UseCase interface; ArgumentError
- `lib/domain/usecases/category/add_category_usecase.dart` - AddCategoryParams + refactored use case; accepts (repository, uuid)
- `lib/presentation/blocs/expense/expense_bloc.dart` - uuid field/import removed; _onAddExpense uses AddExpenseParams; catches ArgumentError
- `lib/presentation/blocs/income/income_bloc.dart` - uuid field/import removed; _onAddIncome uses AddIncomeParams; catches ArgumentError
- `lib/presentation/blocs/category/category_bloc.dart` - uuid field/import removed; _onAddCategory uses AddCategoryParams
- `lib/core/di/service_locator.dart` - sl<Uuid>() injected into Add use cases; removed from BLoC registrations
- `lib/presentation/screens/expenses/widgets/add_expense_form_view.dart` - Fixed to use AddCategoryParams; retrieves Daily category ID via GetAllCategoriesUseCase post-creation

## Decisions Made

- Standardized AddIncomeUseCase exception type to ArgumentError (matching AddExpenseUseCase and ARCH-01 convention)
- AddIncomeUseCase now properly implements UseCase<void, AddIncomeParams> (pre-existing inconsistency fixed)
- After AddCategoryUseCase API change (void return, UUID generated internally), the widget that pre-computed the ID for the auto-created 'Daily' category was updated to query GetAllCategoriesUseCase after creation to retrieve the generated ID

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 3 - Blocking] Fixed add_expense_form_view.dart type error caused by AddCategoryUseCase signature change**
- **Found during:** Task 2 (full analyze run)
- **Issue:** The widget called `sl<AddCategoryUseCase>().call(categoryEntity)` passing a `Category` entity directly. After the use case switched to `AddCategoryParams`, this caused two `argument_type_not_assignable` errors and an unresolved `Uuid` import.
- **Fix:** Replaced direct `Category` construction + `sl<Uuid>().v4()` with `AddCategoryParams` call, then used `GetAllCategoriesUseCase` to retrieve the newly created Daily category's UUID.
- **Files modified:** `lib/presentation/screens/expenses/widgets/add_expense_form_view.dart`
- **Verification:** `fvm flutter analyze lib/ --no-pub` exits 0 with no issues
- **Committed in:** `613babd` (Task 2 commit)

---

**Total deviations:** 1 auto-fixed (Rule 3 - blocking)
**Impact on plan:** The fix was necessary to unblock analyzer completion. The widget was a pre-existing ARCH violation (calling use case directly from widget) but the type error was directly caused by this plan's changes.

## Issues Encountered

- Native assets build issue with `objective_c` package prevented running `fvm flutter test --no-pub` as a background task; tests ran successfully with the standard `fvm flutter test` command (no `--no-pub`).

## Known Stubs

None - all refactored code is fully wired.

## Next Phase Readiness

- ARCH-01 and ARCH-02 complete. Use cases are now the single source of truth for validation and UUID generation.
- Pre-existing ARCH violation in add_expense_form_view.dart (widget calling use case directly instead of dispatching BLoC event) was patched but not fully resolved — this is documented as a known concern.
- Ready for Plan 03 (stats preloading in AppInitializer).

## Self-Check: PASSED

- FOUND: lib/domain/usecases/expense/add_expense_usecase.dart
- FOUND: lib/domain/usecases/income/add_income_use_case.dart
- FOUND: lib/domain/usecases/category/add_category_usecase.dart
- FOUND: .planning/phases/01-architecture-cleanup/01-02-SUMMARY.md
- FOUND commit 7a86d66 (Task 1)
- FOUND commit 613babd (Task 2)
- FOUND commit b9e2dde (metadata)

---
*Phase: 01-architecture-cleanup*
*Completed: 2026-04-04*
