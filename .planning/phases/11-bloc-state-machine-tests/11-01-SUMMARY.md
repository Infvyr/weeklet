---
phase: 11
plan: "01"
subsystem: testing
tags: [bloc-test, unit-tests, category-bloc, stats-bloc, export-bloc]
dependency_graph:
  requires: []
  provides: [test/helpers/fake_blocs.dart, export-bloc-tests, category-bloc-tests, stats-bloc-tests]
  affects: [test-suite]
tech_stack:
  added: []
  patterns: [blocTest, isA matchers, stub-repository, subclass-stub-use-case]
key_files:
  created:
    - test/helpers/fake_blocs.dart
    - test/presentation/blocs/export/export_bloc_test.dart
    - test/presentation/blocs/category/category_bloc_test.dart
    - test/presentation/blocs/stats/stats_bloc_test.dart
  modified: []
decisions:
  - "CategoryBloc uses isA<> matchers because CategoryState does not extend Equatable"
  - "StatsBloc no-flicker test seeds with touchedIndex=2 so copyWith(touchedIndex:-1) produces a distinct state that BLoC will emit"
  - "ExportBloc stubs subclass ExportExpensesUseCase/ExportIncomeUseCase (not just UseCase<>) to satisfy typed constructor params"
  - "setUpAll initializes intl date formatting because ExportBloc uses DateFormat.yMMMM in _onExportExpenses/_onExportIncome"
  - "CategoryBloc test wires real use cases against a stub repository (matches canonical stub pattern from add_expense_usecase_test.dart)"
  - "FakeBloc classes in test/helpers/fake_blocs.dart are public (no underscore) for cross-file import in Wave 2+3"
metrics:
  duration: "327 seconds"
  completed_date: "2026-05-21"
  tasks_completed: 1
  files_count: 4
---

# Phase 11 Plan 01: Foundation + CategoryBloc, ExportBloc, StatsBloc Tests Summary

BLoC unit tests for ExportBloc, CategoryBloc, and StatsBloc using `bloc_test` blocTest() API, plus shared fake BLoC helpers for Wave 2+3 GetIt registration.

## What Was Done

- Created `test/helpers/fake_blocs.dart` — public `FakeStatsBloc`, `FakeExpenseBloc`, `FakeIncomeBloc`, `FakeCategoryBloc` classes that absorb events without crashing, for Wave 2+3 widget test GetIt registration
- Created `test/presentation/blocs/export/export_bloc_test.dart` — 6 tests covering: initial state, expenses success/failure, income success/failure, reset from seed
- Created `test/presentation/blocs/category/category_bloc_test.dart` — 12 tests covering: GetAll success/failure, Add success/validation error/generic error, Update success/error, Delete success/error, GetById found/not-found
- Created `test/presentation/blocs/stats/stats_bloc_test.dart` — 8 tests covering: initial state, LoadMonthlyStats initial load, failure, no-flicker reload from seed, ChangeStatsTab from loaded/initial, ChartTouchInteraction from loaded/initial

## Tests Passing

Full suite: 86 tests total — all passing.
- Prior tests: 60
- New tests: 26 (6 export + 12 category + 8 stats)

## Key Technical Decisions

**ExportBloc stubs** — stub classes extend `ExportExpensesUseCase` / `ExportIncomeUseCase` rather than just implementing `UseCase<String, Params>`, because `ExportBloc` constructor fields are typed to the concrete use case classes. `setUpAll` initializes `intl` locale data because `ExportBloc` calls `DateFormat.yMMMM('en').format(...)` in the BLoC handler itself (not just in the use case).

**CategoryBloc matchers** — `CategoryState` does not extend `Equatable`, so all matchers use `isA<TypeName>()` with `.having()` for field assertions. Direct equality (`==`) would always mismatch.

**CategoryBloc CRUD 4-state sequence** — after CRUD success, the bloc calls `add(GetAllCategoriesEvent())` internally, producing `CategoryLoading → CategorySuccess → CategoryLoading → CategoriesLoaded`.

**StatsBloc no-flicker test** — seeding with an identical `MonthlyStatsLoaded` and then reloading would produce an equal state that BLoC refuses to emit (Equatable). The test seeds with `touchedIndex: 2`; the reload always calls `copyWith(touchedIndex: -1)`, guaranteeing a new distinct state is emitted — proving `StatsLoading` is NOT in the sequence.

**CategoryBloc test strategy** — uses a single configurable `_StubCategoryRepository` with `shouldThrow`, `returnedCategories`, and `returnedCategory` flags. Real use cases are instantiated from the stub, matching the canonical pattern used in domain use case tests.

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 1 - Bug] intl locale not initialized for ExportBloc**
- **Found during:** Running export tests
- **Issue:** `ExportBloc._onExportExpenses` and `_onExportIncome` call `DateFormat.yMMMM('en').format(...)` to build the email subject. This requires `initializeDateFormatting('en')` to be called before the test.
- **Fix:** Added `setUpAll(() async { await initializeDateFormatting('en'); })` at the top of the export test group.
- **Files modified:** `test/presentation/blocs/export/export_bloc_test.dart`

**2. [Rule 1 - Bug] StatsBloc no-flicker test emitted nothing**
- **Found during:** Running stats tests
- **Issue:** Seeding with `_fakeLoadedState()` (touchedIndex: -1) and reloading with same data produced an Equatable-equal state, which BLoC does not emit — resulting in `[]` instead of `[MonthlyStatsLoaded]`.
- **Fix:** Seeded with `touchedIndex: 2`; the BLoC's `copyWith(touchedIndex: -1)` produces a distinct state, verifying the no-flicker behavior (no `StatsLoading` in the output).
- **Files modified:** `test/presentation/blocs/stats/stats_bloc_test.dart`

## Requirements Satisfied

TEST-12 (CategoryBloc), TEST-13 (StatsBloc), TEST-15 (ExportBloc)

## Self-Check: PASSED
