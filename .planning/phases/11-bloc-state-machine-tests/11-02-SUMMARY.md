---
phase: 11
plan: 02
subsystem: presentation/blocs
tags: [testing, bloc_test, expense, income, getit, isolation]
dependency_graph:
  requires: [11-01]
  provides: [expense_bloc_test, income_bloc_test]
  affects: [test/helpers/fake_blocs.dart]
tech_stack:
  added: []
  patterns: [blocTest seed, GetIt setUp/tearDown isolation, noSuchMethod stubs]
key_files:
  created:
    - test/presentation/blocs/expense/expense_bloc_test.dart
    - test/presentation/blocs/income/income_bloc_test.dart
  modified:
    - test/helpers/fake_blocs.dart
decisions:
  - FakeStatsBloc must extend StatsBloc (not bare Bloc<StatsEvent,StatsState>) so GetIt can register it as StatsBloc; stub use cases satisfy constructor via noSuchMethod
  - Stubs for concrete use case classes use noSuchMethod to satisfy repository field constraint without needing a real repository
  - Income use case stubs are plain classes (no UseCase<T,P> interface) matching the codebase inconsistency
metrics:
  duration: ~15 min
  completed: 2026-05-21
---

# Phase 11 Plan 02: ExpenseBloc + IncomeBloc Tests Summary

**One-liner:** BLoC unit tests for ExpenseBloc and IncomeBloc using blocTest seed, per-test GetIt isolation for StatsBloc, and noSuchMethod stubs for concrete use case classes.

## What Was Done

- Created `test/presentation/blocs/expense/expense_bloc_test.dart` — 15 tests covering:
  - Initial state
  - Load (success and failure paths)
  - Filter by year and month, no-op when not in ExpenseSuccess
  - Add with reload, validation exception, generic exception, and no-op guard
  - Update with reload and error
  - Delete with reload and error
  - ClearActionErrorRequested clearing actionError

- Created `test/presentation/blocs/income/income_bloc_test.dart` — 15 tests mirroring
  the ExpenseBloc structure with Income types, `IncomeFilterDateChanged`, and income-specific
  events and states.

- Updated `test/helpers/fake_blocs.dart`:
  - Added `_StubGetMonthlyStatsUseCase`, `_StubGetEvolutionStatsUseCase`,
    `_StubGetAvailablePeriodsUseCase` using `noSuchMethod` to satisfy the concrete use
    case class interface (including their `repository` fields).
  - Changed `FakeStatsBloc` from `extends Bloc<StatsEvent, StatsState>` to
    `extends StatsBloc` — required so GetIt can register it as `StatsBloc` type
    (concrete class, not abstract; `sl<StatsBloc>()` is called in production CRUD handlers).

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 1 - Bug] FakeStatsBloc could not be registered as StatsBloc in GetIt**
- **Found during:** Task execution — first compile attempt
- **Issue:** Plan specified `GetIt.instance.registerSingleton<StatsBloc>(FakeStatsBloc())` but `FakeStatsBloc` extended `Bloc<StatsEvent,StatsState>`, not `StatsBloc`. Dart's type system rejects the registration.
- **Fix:** Updated `FakeStatsBloc` to extend `StatsBloc` by providing stub implementations of the three required use cases using `noSuchMethod` stubs.
- **Files modified:** `test/helpers/fake_blocs.dart`
- **Commit:** 0078763

**2. [Rule 1 - Bug] Concrete use case stubs missing noSuchMethod for repository field**
- **Found during:** First compile of expense_bloc_test.dart
- **Issue:** Implementing a concrete use case class (e.g. `AddExpenseUseCase`) via `implements` requires satisfying all its members including the `final ExpenseRepository repository` field.
- **Fix:** Added `noSuchMethod` overrides to all stub classes in both test files and fake_blocs.dart.
- **Files modified:** `test/presentation/blocs/expense/expense_bloc_test.dart`, `test/presentation/blocs/income/income_bloc_test.dart`, `test/helpers/fake_blocs.dart`
- **Commit:** 0078763

## Tests Passing

- Expense bloc: 15/15
- Income bloc: 15/15
- Full suite: 116/116 (86 pre-existing + 30 new)

## Known Stubs

None — all tests assert real BLoC behavior with in-memory stub use cases.

## Self-Check: PASSED

- `test/presentation/blocs/expense/expense_bloc_test.dart` — exists and verified
- `test/presentation/blocs/income/income_bloc_test.dart` — exists and verified
- Commit 0078763 — verified via git log
