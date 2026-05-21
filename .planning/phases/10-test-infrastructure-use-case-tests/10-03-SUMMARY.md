# Phase 10 Plan 03: Filter Utils Tests Summary

**Status:** Complete
**Completed:** 2026-05-21

## What Was Done

- Extended `test/domain/utils/expense_filter_utils_test.dart` with 6 new tests:
  - `extractAvailableYears`: empty list returns current year, sorted descending, deduplication
  - `extractAvailableMonthsForYear`: sorted ascending, wrong year returns empty, deduplication
- Created `test/domain/utils/income_filter_utils_test.dart` with 6 tests providing equivalent coverage for `IncomeFilterUtils`
- Income tests correctly use `income.date` field (not `createdAt`) for year/month filtering, matching the production logic in `IncomeFilterUtils`

## Tests Passing

- `expense_filter_utils_test.dart`: 10 total (4 existing + 6 new), all GREEN
- `income_filter_utils_test.dart`: 6 tests, all GREEN
- Full suite `fvm flutter test test/ --no-pub` passes with 60 tests, zero failures

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 1 - Bug] Removed `const` from `Expense` constructors in new test groups**
- **Found during:** Task 1 — first test run
- **Issue:** The plan's code snippets used `const Expense(...)` with `DateTime(...)` arguments. `DateTime` has no `const` constructor in Dart, so the compiler rejected `const Expense(...)` when any field is a non-const `DateTime`.
- **Fix:** Removed `const` keyword from all `Expense` instantiations in the new test groups. `DateTime` literals are still efficient — no behavioural change.
- **Files modified:** `test/domain/utils/expense_filter_utils_test.dart`
- **Commit:** 67bdb8a (same commit as the passing tests)

## Requirements Satisfied

TEST-05, TEST-06

## Self-Check

- [x] `test/domain/utils/expense_filter_utils_test.dart` exists and contains 10 tests
- [x] `test/domain/utils/income_filter_utils_test.dart` exists and contains 6 tests
- [x] Commit 67bdb8a present in git log
- [x] Full suite: 60 tests, 0 failures
