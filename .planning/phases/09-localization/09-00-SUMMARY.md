---
phase: 09-localization
plan: '00'
subsystem: testing
tags: [localization, typed-exceptions, flutter-test, wave-0, red-tests]

requires:
  - phase: 08-ui-polish
    provides: stable codebase with existing expense/income use-case tests

provides:
  - Wave 0 RED test contracts for typed exceptions (ExpenseValidationException, IncomeValidationException)
  - LOC-01 supportedLocales contract test (locale_manager_test.dart)

affects: [09-01-locale-manager-trim, 09-02-typed-exceptions]

tech-stack:
  added: []
  patterns:
    - "Typed exception test pattern: isA<XxxValidationException>().having((e) => e.error, 'error', XxxValidationError.enumValue)"
    - "LOC-01 contract test: assert supportedLocales length, language codes, and absence of country codes"

key-files:
  created:
    - test/core/utils/locale_manager_test.dart
  modified:
    - test/domain/usecases/expense/add_expense_usecase_test.dart
    - test/domain/usecases/income/add_income_use_case_test.dart

key-decisions:
  - "Wave 0 RED state is intentional — tests import exception classes that do not yet exist; this locks the API contract before implementation"
  - "Typed exception tests assert on enum values (e.error == XxxValidationError.invalidAmount), not string messages — enforces D-04 and D-05"
  - "locale_manager_test.dart tests three invariants: length=3, no de/fr/es/it codes, no country codes — all required by LOC-01"

patterns-established:
  - "Test typed domain exceptions via isA<XxxValidationException>().having((e) => e.error, 'error', EnumValue)"
  - "LOC-01 supportedLocales contract: exactly [en, ro, ru] with bare language codes (no country suffix)"

requirements-completed: [LOC-01]

duration: 2min
completed: '2026-05-03'
---

# Phase 09 Plan 00: Wave 0 RED Tests Summary

**RED test contracts locking typed exception API (ExpenseValidationException, IncomeValidationException) and LOC-01 supportedLocales invariants before Wave 1 implementation**

## Performance

- **Duration:** ~2 min
- **Started:** 2026-05-03T06:11:56Z
- **Completed:** 2026-05-03T06:13:21Z
- **Tasks:** 2
- **Files modified:** 3

## Accomplishments

- Updated `add_expense_usecase_test.dart`: replaced 5 `isA<ArgumentError>().having()` matchers with `isA<ExpenseValidationException>().having()` targeting `ExpenseValidationError` enum values
- Updated `add_income_use_case_test.dart`: replaced 2 `isA<ArgumentError>().having()` matchers with `isA<IncomeValidationException>().having()` targeting `IncomeValidationError.invalidAmount`
- Created `test/core/utils/locale_manager_test.dart` with 3 LOC-01 contract tests asserting supportedLocales contains exactly [en, ro, ru] with no country codes and excludes de/fr/es/it

## Task Commits

Each task was committed atomically:

1. **Task 1: Rewrite expense use-case test matchers to typed exception contract** - `0f8d997` (test)
2. **Task 2: Rewrite income use-case test matchers and add locale_manager_test** - `c1108b1` (test)

**Plan metadata:** (docs commit — see below)

## Files Created/Modified

- `test/domain/usecases/expense/add_expense_usecase_test.dart` — 5 exception matchers updated; import for `expense_exceptions.dart` added; UUID group preserved
- `test/domain/usecases/income/add_income_use_case_test.dart` — 2 exception matchers updated; import for `income_exceptions.dart` added; UUID group preserved
- `test/core/utils/locale_manager_test.dart` — NEW: 3 tests for LOC-01 supportedLocales contract

## Decisions Made

None — followed plan as specified. Wave 0 RED state is intentional by design.

## Deviations from Plan

None — plan executed exactly as written.

## Issues Encountered

None. Test files accepted the new imports and matchers without lint issues. The tests are intentionally RED at this point — `lib/domain/exceptions/expense_exceptions.dart` and `lib/domain/exceptions/income_exceptions.dart` do not yet exist (created in Plan 02). `LocaleManager.supportedLocales` still lists 7 locales (trimmed in Plan 01), so the locale_manager_test.dart will also fail until Plan 01 lands.

## User Setup Required

None — no external service configuration required.

## Next Phase Readiness

- Wave 0 RED test contracts are committed and locked
- Plan 01 (LocaleManager trim) can proceed — will turn locale_manager_test.dart green
- Plan 02 (typed exception classes) can proceed — will turn both use-case test files green
- No blockers

## Self-Check: PASSED

- FOUND: test/core/utils/locale_manager_test.dart
- FOUND: test/domain/usecases/expense/add_expense_usecase_test.dart
- FOUND: test/domain/usecases/income/add_income_use_case_test.dart
- FOUND: .planning/phases/09-localization/09-00-SUMMARY.md
- FOUND commit: 0f8d997 (Task 1)
- FOUND commit: c1108b1 (Task 2)

---
*Phase: 09-localization*
*Completed: 2026-05-03*
