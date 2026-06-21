---
phase: 12-widget-component-tests
plan: "01"
subsystem: test-infrastructure
tags: [testing, widget-tests, helpers, mocktail, bloc_test]
one_liner: "Shared widget-test foundation: mocktail dev_dep + pumpApp localization helper + 6 entity factory functions"

dependency_graph:
  requires: []
  provides:
    - test/helpers/test_app.dart (pumpApp helper)
    - test/helpers/test_data.dart (fakeExpense, fakeCategory, fakeIncome, fakeExpenseSuccess, fakeIncomeSuccess, fakeMonthlyStatsLoaded)
  affects:
    - All 8 subsequent widget test files (plans 12-02 through 12-05)

tech_stack:
  added:
    - mocktail: ^1.0.5 (direct dev_dependency, was transitive via bloc_test)
    - bloc_test: ^10.0.0 (direct dev_dependency, previously uncommitted working-tree change)
  patterns:
    - pumpApp helper pattern (MultiBlocProvider wrapping MaterialApp + AppLocalizations)
    - Shared entity factory functions (top-level, public, optional named params)

key_files:
  created:
    - test/helpers/test_app.dart
    - test/helpers/test_data.dart
  modified:
    - pubspec.yaml (dev_dependencies)
    - pubspec.lock (resolved dependencies)

decisions:
  - "bloc_test added alongside mocktail (Rule 3 deviation): worktree pubspec was at base commit without bloc_test which was only present as uncommitted working-tree change in main repo"
  - "MultiBlocProvider wraps MaterialApp (outer/inner order from PLAN action section)"
  - "fakeExpense/fakeCategory/fakeIncome use named optional params with defaults per plan spec"

metrics:
  duration: "~8 minutes"
  completed_date: "2026-06-21"
  tasks_completed: 2
  tasks_total: 2
  files_created: 2
  files_modified: 2
---

# Phase 12 Plan 01: Widget Test Foundation Summary

**One-liner:** Shared widget-test foundation: mocktail dev_dep + pumpApp localization helper + 6 entity factory functions

## What Was Built

### Task 1: Add dev_dependencies to pubspec.yaml
Added `bloc_test: ^10.0.0` and `mocktail: ^1.0.5` as direct dev_dependencies. The worktree was at the base commit (`2173c5d`) where `bloc_test` was only present as an uncommitted working-tree change in the main repo checkout; both packages were added in a single atomic change to keep the dependency set consistent.

`fvm flutter pub get` resolved successfully; `pubspec.lock` updated with 29 dependency changes.

### Task 2: Create test/helpers/test_app.dart and test/helpers/test_data.dart

**test/helpers/test_app.dart** — exports `pumpApp(WidgetTester, Widget, {List<BlocProvider>})`:
- Wraps child in `MultiBlocProvider(providers: providers, child: MaterialApp(...))`
- `MaterialApp` includes `AppLocalizations.localizationsDelegates`, `AppLocalizations.supportedLocales`, `locale: const Locale('en')`
- Required by all 8 widget test files in plans 12-02 through 12-05

**test/helpers/test_data.dart** — exports 6 public top-level factory functions:
- `fakeExpense({id, amount, categoryId})` — constructs Expense with fixed description and createdAt
- `fakeCategory({id, name})` — constructs Category with icon='fastfood' and fixed createdAt
- `fakeIncome({id, amount})` — constructs Income with both `date` and `createdAt` fields
- `fakeExpenseSuccess({expenses})` — builds ExpenseSuccess with selectedYear=now, selectedMonth=null, availableMonths=[5]
- `fakeIncomeSuccess({incomes})` — mirrors fakeExpenseSuccess pattern for IncomeSuccess
- `fakeMonthlyStatsLoaded()` — builds MonthlyStatsLoaded with totalIncome=1000, totalExpenses=500, balance=500

## Verification

- `grep 'mocktail' pubspec.yaml` → `mocktail: ^1.0.5` confirmed
- `fvm flutter pub get` → exit 0
- `fvm flutter analyze test/helpers/ --no-pub` → **No issues found**
- `fvm flutter test --no-pub` → **130 tests passed, 0 failures**

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 3 - Blocking] Added bloc_test alongside mocktail**
- **Found during:** Task 1
- **Issue:** The worktree pubspec.yaml was at the base git commit (`2173c5d`) which predates the `bloc_test` addition. The `bloc_test: ^10.0.0` entry only existed as an uncommitted working-tree change in the main repo checkout — it was not in the committed history. Without `bloc_test`, the test helper files would fail to compile (`MockBloc` is from `bloc_test`).
- **Fix:** Added `bloc_test: ^10.0.0` alongside `mocktail: ^1.0.5` in pubspec.yaml dev_dependencies. Also commented out `hive_generator` (conflicts with bloc_test's analyzer version) — matching the pattern from the main repo's uncommitted change.
- **Files modified:** `pubspec.yaml`, `pubspec.lock`
- **Commit:** 06758a2

## Known Stubs

None. This plan creates test infrastructure only — no stubs in production code.

## Threat Flags

No new production code written. No new network endpoints, auth paths, file access patterns, or schema changes. The only new dependency surface is mocktail 1.0.5 (already resolved as a transitive dep of bloc_test; authored by Felix Angell from the official bloc ecosystem on pub.dev).

## Self-Check: PASSED

- [x] `test/helpers/test_app.dart` exists
- [x] `test/helpers/test_data.dart` exists
- [x] `pubspec.yaml` contains `mocktail: ^1.0.5`
- [x] Commits 06758a2 and 5996a2f exist in git log
- [x] All 130 tests pass
