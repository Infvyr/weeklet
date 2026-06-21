---
phase: 12-widget-component-tests
plan: "02"
subsystem: testing
tags: [testing, widget-tests, mocktail, bloc_test, expenses, form-validation]

dependency_graph:
  requires:
    - phase: 12-01
      provides: "pumpApp helper (test_app.dart) and 6 entity factory functions (test_data.dart)"
  provides:
    - test/presentation/screens/expenses/expenses_screen_test.dart (TEST-16, 4 tests)
    - test/presentation/screens/expenses/add_expense_form_view_test.dart (TEST-17, 3 tests)
  affects:
    - Plans 12-03, 12-04, 12-05 (established MockBloc implements pattern + LocaleManager init)

tech-stack:
  added: []
  patterns:
    - "MockBloc implements ConcreteBloc — extends MockBloc<E,S> and implements XxxBloc for type-system compatibility with BlocProvider<XxxBloc>.value() and GetIt.registerSingleton<XxxBloc>()"
    - "LocaleManager().initialize(const Locale('en')) in setUpAll — required for ExpenseDayGroupView date formatting"
    - "registerFallbackValue with concrete leaf-class instances — sealed classes cannot be extended outside their library; use LoadExpensesRequested() etc. not Fake subclasses"
    - "ExpenseInitial (not ExpenseLoading) as default mock state — keep save button canSubmit=true during form tests"
    - "Stub use case classes registered in GetIt — prevents StateError from _onSave alternate path"
    - "Finite pump() durations instead of pumpAndSettle() — avoids CommonDropdownButton addPostFrameCallback infinite pump loop"

key-files:
  created:
    - test/presentation/screens/expenses/expenses_screen_test.dart
    - test/presentation/screens/expenses/add_expense_form_view_test.dart
  modified: []

key-decisions:
  - "MockBloc implements ConcreteBloc pattern: Dart's sealed-class constraint prevents Fake subclasses for event/state types; concrete instances (LoadExpensesRequested etc.) used as registerFallbackValue arguments"
  - "LocaleManager must be initialized in setUpAll for any screen that renders ExpenseDayGroupView (late field _currentLocale throws otherwise)"
  - "ExpenseInitial state for default ExpenseBloc mock in form tests: ExpenseLoading makes canSubmit=false, blocking save button interactions"
  - "pumpAndSettle avoided for date picker: CommonDropdownButton addPostFrameCallback loop causes infinite settle; use pump(Duration) instead"
  - "4 tests in expenses_screen_test (not 3): added filter bar rendering test to verify ExpenseFilterBar CommonDropdownButton presence"

patterns-established:
  - "MockXxxBloc extends MockBloc<E, S> implements XxxBloc — use this pattern in all future widget test files (Plans 12-03, 12-04, 12-05)"
  - "setUpAll LocaleManager init — add to all screen tests that use date-aware widgets"
  - "stub use case GetIt registrations alongside mock blocs — guard _onSave / initState alternate sl<> paths"

requirements-completed: [TEST-16, TEST-17]

duration: ~25min
completed: 2026-06-21
---

# Phase 12 Plan 02: ExpensesScreen + AddExpenseFormView Widget Tests Summary

**ExpensesScreen (4 tests) and AddExpenseFormView (3 tests) using MockBloc-implements pattern with LocaleManager init and sealed-class-safe fallback values**

## Performance

- **Duration:** ~25 min
- **Started:** 2026-06-21T00:00:00Z
- **Completed:** 2026-06-21T00:00:00Z
- **Tasks:** 2
- **Files modified:** 2 created

## Accomplishments

- `expenses_screen_test.dart` (TEST-16): 4 tests — loading indicator, empty state view, non-empty list rendering, filter bar dropdown rendering; all 4 pass
- `add_expense_form_view_test.dart` (TEST-17): 3 tests — form field rendering, empty amount validation error, AddExpenseStarted dispatch verified (D-02 satisfied); all 3 pass
- 130 original tests still passing — no regressions

## Task Commits

1. **Task 1: ExpensesScreen tests (TEST-16)** — `5e0ca3c` (test)
2. **Task 2: AddExpenseFormView tests (TEST-17)** — `58921cb` (test)

## Files Created/Modified

- `test/presentation/screens/expenses/expenses_screen_test.dart` — 4 widget tests for ExpensesScreen (loading/empty/list/filter-bar states)
- `test/presentation/screens/expenses/add_expense_form_view_test.dart` — 3 widget tests for AddExpenseFormView (rendering/validation/dispatch)

## Decisions Made

- Used `MockExpenseBloc extends MockBloc<ExpenseEvent, ExpenseState> implements ExpenseBloc` pattern — satisfies both `BlocProvider<ExpenseBloc>.value(value: ...)` type check and GetIt `registerSingleton<ExpenseBloc>(...)` type check. `implements` works because `Mock` intercepts all calls via `noSuchMethod`.
- `registerFallbackValue` uses concrete leaf instances (`LoadExpensesRequested()`, `CategoryLoading()`, etc.) not `Fake` subclasses — sealed classes in Dart cannot be implemented outside their defining library.
- `LocaleManager().initialize(const Locale('en'))` added in `setUpAll` — `ExpenseDayGroupView` uses `LocaleManager().currentLocaleString` which throws `LateInitializationError` if not initialized before widget rendering.
- `ExpenseInitial` (not `ExpenseLoading`) as the default expense bloc state in add_expense_form_view tests — `isLoading = state is ExpenseLoading` in `ExpenseFormSubmitView`, so `ExpenseLoading` disables the button (`canSubmit = false`) making it impossible to tap and trigger validation.
- Finite `pump(Duration)` calls instead of `pumpAndSettle()` in the date picker interaction — `CommonDropdownButton` has an `addPostFrameCallback` that calls `setState` whenever button width changes, creating a frame loop that causes `pumpAndSettle` to time out.

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 1 - Bug] MockBloc implements ConcreteBloc pattern replaces Fake subclass pattern**
- **Found during:** Task 1
- **Issue:** The plan spec says `class FakeExpenseEvent extends Fake implements ExpenseEvent {}` — this fails because `ExpenseEvent` is a `sealed class` and cannot be implemented outside its library. Separately, `MockExpenseBloc extends MockBloc<ExpenseEvent, ExpenseState>` alone does not satisfy `BlocProvider<ExpenseBloc>.value(value: ...)` or `GetIt.registerSingleton<ExpenseBloc>(...)` type constraints because `MockBloc` does not extend `ExpenseBloc`.
- **Fix:** Changed mock declarations to `class MockExpenseBloc extends MockBloc<ExpenseEvent, ExpenseState> implements ExpenseBloc {}`. Used concrete leaf-class instances for `registerFallbackValue` instead of Fake subclasses. This pattern is now established for all remaining plans (12-03 through 12-05).
- **Files modified:** expenses_screen_test.dart, add_expense_form_view_test.dart
- **Verification:** `fvm flutter analyze` exits 0; all tests pass
- **Committed in:** 5e0ca3c, 58921cb

**2. [Rule 1 - Bug] LocaleManager initialization in setUpAll**
- **Found during:** Task 1 (test 3 — shows expense list)
- **Issue:** `ExpenseDayGroupView` accesses `LocaleManager().currentLocaleString` which throws `LateInitializationError: Field '_currentLocale' has not been initialized` — `LocaleManager.initialize()` is normally called in `main()` during app startup, which doesn't run in tests.
- **Fix:** Added `LocaleManager().initialize(const Locale('en'))` in `setUpAll`.
- **Files modified:** expenses_screen_test.dart, add_expense_form_view_test.dart
- **Committed in:** 5e0ca3c, 58921cb

**3. [Rule 1 - Bug] ExpenseInitial instead of ExpenseLoading as default bloc state**
- **Found during:** Task 2 (test 2 — validation error)
- **Issue:** `ExpenseFormSubmitView` sets `canSubmit = isEnabled && !isLoading` where `isLoading = state is ExpenseLoading`. With `ExpenseLoading` as the mock state, the save button was always disabled (`onPressed: null`), making `tester.tap` a no-op and preventing any validation from running.
- **Fix:** Changed default expense state to `const ExpenseInitial()`.
- **Files modified:** add_expense_form_view_test.dart
- **Committed in:** 58921cb

**4. [Rule 1 - Bug] CommonDropdownButton addPostFrameCallback causes pumpAndSettle timeout**
- **Found during:** Task 2 (test 3 — dispatch)
- **Issue:** `CommonDropdownButton._updateButtonWidth()` uses `WidgetsBinding.instance.addPostFrameCallback` which fires each frame and calls `setState` if width changes — in the test environment this creates an infinite pump cycle, causing `pumpAndSettle` to time out after 100 frames.
- **Fix:** Replaced `pumpAndSettle()` with finite `pump(const Duration(...))` calls after date picker interactions.
- **Files modified:** add_expense_form_view_test.dart
- **Committed in:** 58921cb

**5. [Rule 1 - Bug] DropdownButton<int> finder replaced with CommonDropdownButton predicate**
- **Found during:** Task 1 (test 4 — filter bar)
- **Issue:** `ExpenseFilterBar` uses `CommonDropdownButton<int?>` and `CommonDropdownButton<int>` which renders a `MenuAnchor`, not a `DropdownButton<int>`. The plan's suggested assertion `find.byType(DropdownButton<int>)` finds nothing.
- **Fix:** Used `find.byWidgetPredicate((w) => w is CommonDropdownButton)` instead.
- **Files modified:** expenses_screen_test.dart
- **Committed in:** 5e0ca3c

---

**Total deviations:** 5 auto-fixed (all Rule 1 bugs — Dart type system constraints and test environment initialization requirements)
**Impact on plan:** All fixes necessary for correctness. The MockBloc implements pattern established here supersedes the Fake class pattern in the plan and MUST be used in plans 12-03 through 12-05.

## Issues Encountered

- Worktree does not have `.fvmrc` (not committed). Added it temporarily for `fvm flutter` invocation from worktree directory. Tests were ultimately run from main project directory via absolute path with `--no-pub`.

## Known Stubs

None. This plan creates test files only — no production code stubs introduced.

## Threat Flags

No production code written. No new network endpoints, auth paths, or schema changes. Test-only files.

## Next Phase Readiness

- Plans 12-03 through 12-05 should use `MockXxxBloc extends MockBloc<E, S> implements XxxBloc` pattern
- Plans 12-03 through 12-05 should add `LocaleManager().initialize(const Locale('en'))` in setUpAll if any date-aware widgets are tested
- Plans 12-03 through 12-05 should avoid `pumpAndSettle()` when `CommonDropdownButton` is in the widget tree

## Self-Check: PASSED

- [x] `test/presentation/screens/expenses/expenses_screen_test.dart` exists
- [x] `test/presentation/screens/expenses/add_expense_form_view_test.dart` exists
- [x] `.planning/phases/12-widget-component-tests/12-02-SUMMARY.md` exists
- [x] Commit `5e0ca3c` exists (TEST-16 expenses_screen_test)
- [x] Commit `58921cb` exists (TEST-17 add_expense_form_view_test)
- [x] All 7 new tests pass (4 + 3)
- [x] All 130 original tests still pass
