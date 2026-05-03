---
phase: 09-localization
plan: '02'
subsystem: domain-exceptions
tags: [localization, typed-exceptions, domain, bloc, refactor]

requires:
  - phase: 09-localization
    plan: '00'
    provides: Wave 0 RED test contracts for ExpenseValidationException and IncomeValidationException

provides:
  - lib/domain/exceptions/ with 3 pure-Dart typed exception files
  - All 9 use cases throw typed exceptions (no ArgumentError/Exception strings)
  - ExpenseBloc, IncomeBloc, CategoryBloc emit short string codes for localization

affects:
  - lib/domain/exceptions/expense_exceptions.dart
  - lib/domain/exceptions/income_exceptions.dart
  - lib/domain/exceptions/category_exceptions.dart
  - lib/domain/usecases/expense/add_expense_usecase.dart
  - lib/domain/usecases/expense/update_expense_usecase.dart
  - lib/domain/usecases/expense/delete_expense_usecase.dart
  - lib/domain/usecases/income/add_income_use_case.dart
  - lib/domain/usecases/income/update_income_use_case.dart
  - lib/domain/usecases/category/add_category_usecase.dart
  - lib/domain/usecases/category/update_category_usecase.dart
  - lib/domain/usecases/category/delete_category_usecase.dart
  - lib/domain/usecases/category/get_single_category_usecase.dart
  - lib/presentation/blocs/expense/expense_bloc.dart
  - lib/presentation/blocs/income/income_bloc.dart
  - lib/presentation/blocs/category/category_bloc.dart

tech-stack:
  added: []
  patterns:
    - "Typed domain exception: class XxxValidationException implements Exception { const XxxValidationException(this.error); final XxxValidationError error; }"
    - "BLoC typed catch: on XxxValidationException catch (e) { emit(state.copyWith(actionError: e.error.name)); }"
    - "BLoC generic catch emits 'genericError' string code instead of English prose"
    - "CategoryBloc success states emit ARB key codes (categoryAddedSuccess, etc.) instead of English"

key-files:
  created:
    - lib/domain/exceptions/expense_exceptions.dart
    - lib/domain/exceptions/income_exceptions.dart
    - lib/domain/exceptions/category_exceptions.dart
  modified:
    - lib/domain/usecases/expense/add_expense_usecase.dart
    - lib/domain/usecases/expense/update_expense_usecase.dart
    - lib/domain/usecases/expense/delete_expense_usecase.dart
    - lib/domain/usecases/income/add_income_use_case.dart
    - lib/domain/usecases/income/update_income_use_case.dart
    - lib/domain/usecases/category/add_category_usecase.dart
    - lib/domain/usecases/category/update_category_usecase.dart
    - lib/domain/usecases/category/delete_category_usecase.dart
    - lib/domain/usecases/category/get_single_category_usecase.dart
    - lib/presentation/blocs/expense/expense_bloc.dart
    - lib/presentation/blocs/income/income_bloc.dart
    - lib/presentation/blocs/category/category_bloc.dart

key-decisions:
  - "Typed exceptions use const constructor pattern matching the plan spec — enum-typed error code, implements Exception, pure Dart"
  - "CategoryBloc retains CategoryError(message:) pattern (not actionError) per existing state architecture; codes are e.error.name strings"
  - "Pre-existing constant_identifier_names warning in app_constants.dart (DEFAULT_CURRENCY) is out of scope — not touched"

metrics:
  duration: 5min
  completed: '2026-05-03'
---

# Phase 09 Plan 02: Typed Domain Exceptions Summary

**Three pure-Dart domain exception classes with enum error codes + full use-case and BLoC refactor to eliminate English error strings from the domain layer**

## Performance

- **Duration:** ~5 min
- **Started:** 2026-05-03T06:18:53Z
- **Completed:** 2026-05-03T06:24:12Z
- **Tasks:** 2
- **Files modified:** 15 (3 created, 12 refactored)

## Accomplishments

### Task 1: Typed exception files + use case refactor

Created `lib/domain/exceptions/` directory with three pure-Dart exception files:

- `expense_exceptions.dart` — `ExpenseValidationError` enum (`invalidAmount`, `emptyDescription`, `emptyCategory`, `emptyExpenseId`) + `ExpenseValidationException`
- `income_exceptions.dart` — `IncomeValidationError` enum (`invalidAmount`, `emptyDescription`, `emptyIncomeId`) + `IncomeValidationException`
- `category_exceptions.dart` — `CategoryValidationError` enum (`emptyName`, `emptyIcon`, `emptyId`, `emptyCategoryId`) + `CategoryValidationException`

All three exception files: zero Flutter imports, `const` constructor, `implements Exception`.

Refactored 9 use cases to throw typed exceptions instead of `ArgumentError`/`Exception`:
- 3 expense use cases (add, update, delete) — 7 throw sites
- 2 income use cases (add, update) — 2 throw sites
- 4 category use cases (add, update, delete, getSingle) — 7 throw sites

Wave 0 RED tests turned GREEN: all 11 tests in `add_expense_usecase_test.dart` and `add_income_use_case_test.dart` pass.

### Task 2: BLoC typed catch + string code emission

Updated `ExpenseBloc`, `IncomeBloc`, `CategoryBloc`:

- Added typed-then-generic catch pattern in all 3 CRUD handlers per BLoC
- `ExpenseBloc` and `IncomeBloc`: emit `actionError: e.error.name` for typed exceptions, `actionError: 'genericError'` for generic
- `CategoryBloc`: emit `CategoryError(message: e.error.name)` for typed, `CategoryError(message: 'genericError')` for generic
- `CategoryBloc` success messages replaced with ARB key codes: `categoryAddedSuccess`, `categoryUpdatedSuccess`, `categoryDeletedSuccess`
- `CategoryBloc` null-category case replaced with `errorCategoryNotFound`
- No BLoC imports `AppLocalizations` — architecture boundary preserved

## Task Commits

Each task was committed atomically:

1. **Task 1: Create typed domain exceptions and refactor all use cases** - `b1adecc` (feat)
2. **Task 2: Update BLoCs to catch typed exceptions and emit string codes** - `4aa708a` (feat)

## Files Created/Modified

### Created
- `lib/domain/exceptions/expense_exceptions.dart` — `ExpenseValidationError` enum + `ExpenseValidationException`
- `lib/domain/exceptions/income_exceptions.dart` — `IncomeValidationError` enum + `IncomeValidationException`
- `lib/domain/exceptions/category_exceptions.dart` — `CategoryValidationError` enum + `CategoryValidationException`

### Modified
- `lib/domain/usecases/expense/add_expense_usecase.dart` — 3 typed throws replacing ArgumentError
- `lib/domain/usecases/expense/update_expense_usecase.dart` — 3 typed throws replacing ArgumentError
- `lib/domain/usecases/expense/delete_expense_usecase.dart` — 1 typed throw replacing ArgumentError
- `lib/domain/usecases/income/add_income_use_case.dart` — 1 typed throw replacing ArgumentError
- `lib/domain/usecases/income/update_income_use_case.dart` — 1 typed throw replacing Exception
- `lib/domain/usecases/category/add_category_usecase.dart` — 2 typed throws replacing ArgumentError
- `lib/domain/usecases/category/update_category_usecase.dart` — 3 typed throws replacing ArgumentError
- `lib/domain/usecases/category/delete_category_usecase.dart` — 1 typed throw replacing ArgumentError
- `lib/domain/usecases/category/get_single_category_usecase.dart` — 1 typed throw replacing ArgumentError
- `lib/presentation/blocs/expense/expense_bloc.dart` — typed catch in 3 handlers, 'genericError' fallback
- `lib/presentation/blocs/income/income_bloc.dart` — typed catch in 3 handlers, 'genericError' fallback
- `lib/presentation/blocs/category/category_bloc.dart` — typed catch in 4 handlers, ARB codes for success/error

## Decisions Made

- **Typed exception pattern**: const constructor, enum field, implements Exception, pure Dart — no additional packages, no Flutter imports
- **CategoryBloc retains CategoryError(message:)**: existing state architecture uses a separate error state class rather than `actionError` on a success state; the `message` field now carries the string code instead of English text
- Pre-existing `constant_identifier_names` warning in `app_constants.dart` (`DEFAULT_CURRENCY`) is out of scope for this plan

## Deviations from Plan

None — plan executed exactly as written.

## Issues Encountered

The test runner run from the main project root failed because the exception files don't exist there (worktree has its own `lib/`). Running `fvm flutter test` from the worktree directory resolved this correctly.

## User Setup Required

None — no external service configuration required.

## Next Phase Readiness

- Wave 0 expense + income use-case tests are GREEN
- Plan 03 (ARB string extraction and widget localization) can proceed — BLoCs now emit string codes that widgets will translate via `AppLocalizations`
- No blockers

## Known Stubs

None — all exception types are fully implemented with real enum values.

## Threat Flags

None — no new network endpoints, auth paths, file access patterns, or schema changes introduced.

## Self-Check: PASSED

- FOUND: lib/domain/exceptions/expense_exceptions.dart
- FOUND: lib/domain/exceptions/income_exceptions.dart
- FOUND: lib/domain/exceptions/category_exceptions.dart
- FOUND commit: b1adecc (Task 1)
- FOUND commit: 4aa708a (Task 2)
- Wave 0 tests: 11 passed, 0 failed

---
*Phase: 09-localization*
*Completed: 2026-05-03*
