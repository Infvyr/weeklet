---
phase: 12-widget-component-tests
plan: "03"
subsystem: test-widget
tags: [testing, widget-tests, income, categories, mocktail, bloc_test]
one_liner: "IncomeScreen and CategoriesScreen widget tests with MockBloc implements pattern and LocaleManager initialization"

dependency_graph:
  requires:
    - test/helpers/test_app.dart (plan 12-01)
    - test/helpers/test_data.dart (plan 12-01)
  provides:
    - test/presentation/screens/income/income_screen_test.dart (TEST-18)
    - test/presentation/screens/categories/categories_screen_test.dart (TEST-19)
  affects:
    - Total test count: 130 -> 137 (+7 new widget tests)

tech_stack:
  added: []
  patterns:
    - MockBloc<Event, State> implements ConcreteBloc — allows BlocProvider<Concrete>.value() assignment
    - LocaleManager().initialize(const Locale('en')) in setUpAll — unblocks IncomeDayGroupView render
    - FLUTTER_ROOT="" prefix for fvm flutter test — bypasses native_assets worktree crash
    - fvm flutter gen-l10n — required before first test run in a fresh worktree

key_files:
  created:
    - test/presentation/screens/income/income_screen_test.dart
    - test/presentation/screens/categories/categories_screen_test.dart
  modified: []

decisions:
  - "MockBloc implements ConcreteBloc (not just MockBloc<Event, State>) — required for BlocProvider<ConcreteBloc>.value() type constraint"
  - "LocaleManager initialized in setUpAll — IncomeDayGroupView calls DateTimeExtension.getWeekdayName which reads LocaleManager singleton; uninitialized singleton throws LateInitializationError"
  - "D-02 event dispatch for IncomeScreen uses retry button tap (IncomeFailure state) rather than pull-to-refresh — pull-to-refresh's _onRefresh awaits bloc.stream.firstWhere() which hangs with a mock empty stream"
  - "GetIt registration omitted for IncomeScreen — initState has no sl<> calls; BlocProvider.value() covers all BLoC dependencies"
  - "GetIt registration kept for CategoriesScreen — CategoryItemView calls sl<CategoryBloc>() in _deleteCategory"
  - "categories_screen_test.dart has no setUpAll/registerFallbackValue — CategoryEvent/CategoryState not used with any() matcher; Fake classes not needed"

metrics:
  duration: "~35 minutes"
  completed_date: "2026-06-21"
  tasks_completed: 2
  tasks_total: 2
  files_created: 2
  files_modified: 0
---

# Phase 12 Plan 03: IncomeScreen and CategoriesScreen Widget Tests Summary

**One-liner:** IncomeScreen and CategoriesScreen widget tests with MockBloc implements pattern and LocaleManager initialization

## What Was Built

### Task 1: income_screen_test.dart (TEST-18)

`test/presentation/screens/income/income_screen_test.dart` — 4 testWidgets covering:

1. **CircularProgressIndicator on IncomeLoading** — default setUp seed; confirms loading indicator is rendered
2. **No loading indicator on IncomeSuccess with incomes** — confirms IncomeListView path is taken
3. **EmptyStateView on IncomeSuccess with empty list** — confirms IncomeListView delegates to EmptyStateView for empty incomes
4. **D-02: LoadIncomesRequested dispatched on retry button tap** — seeds IncomeFailure state; taps the TextButton retry; verifies event dispatch via verify().called(1)

**Key implementation details:**
- `MockIncomeBloc extends MockBloc<IncomeEvent, IncomeState> implements IncomeBloc` — the `implements` makes the mock assignable to `BlocProvider<IncomeBloc>.value()`
- Same pattern for `MockSettingsBloc` and `MockExportBloc`
- `setUpAll` initializes `LocaleManager().initialize(const Locale('en'))` to prevent `LateInitializationError` from `IncomeDayGroupView`
- GetIt registration skipped — IncomeScreen has no `sl<>` calls in `initState`

### Task 2: categories_screen_test.dart (TEST-19)

`test/presentation/screens/categories/categories_screen_test.dart` — 3 testWidgets covering:

1. **CircularProgressIndicator on CategoryLoading** — default setUp seed
2. **GridView + category name text on CategoriesLoaded with items** — seeds `CategoriesLoaded(categories: [fakeCategory()])`, finds GridView and `find.text('Food')`
3. **CategoriesEmptyView on CategoriesLoaded with empty list** — seeds `const CategoriesLoaded(categories: [])`, finds CategoriesEmptyView type

**Key implementation details:**
- `CategoryState` is NOT Equatable; `when(() => mock.state).thenReturn(...)` used instead of equality matchers
- No `setUpAll`/`registerFallbackValue` — CategoryEvent/CategoryState not used with `any()` matchers
- `MockCategoryBloc implements CategoryBloc` with GetIt registration — `CategoryItemView._deleteCategory` calls `sl<CategoryBloc>().add(...)` at runtime

## Verification

- `fvm flutter analyze test/presentation/screens/income/ test/presentation/screens/categories/ --no-pub` -> No issues found
- `FLUTTER_ROOT="" fvm flutter test test/presentation/screens/income/income_screen_test.dart --no-pub` -> 4 tests passed
- `FLUTTER_ROOT="" fvm flutter test test/presentation/screens/categories/categories_screen_test.dart --no-pub` -> 3 tests passed
- `FLUTTER_ROOT="" fvm flutter test --no-pub` -> 137 tests passed, 0 failures

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 1 - Bug] FLUTTER_ROOT="" prefix required for fvm flutter test in worktree**
- **Found during:** Task 1 verification
- **Issue:** `fvm flutter test` crashes with `Bad state: No element` in `testCompilerBuildNativeAssets` when `FLUTTER_ROOT` env var is set. Flutter 3.41.1 native assets tool bug specific to worktree environments with `share_plus`.
- **Fix:** Run `FLUTTER_ROOT="" fvm flutter test` to clear the env var.
- **Files modified:** None (env var only; no code change)
- **Commit:** N/A

**2. [Rule 3 - Blocking] fvm flutter gen-l10n required before first test run**
- **Found during:** Task 1 verification
- **Issue:** The worktree was created from commit `cb6c76a` which does not include generated l10n files. All imports of `package:weeklet/l10n/app_localizations.dart` fail at compile time.
- **Fix:** Ran `FLUTTER_ROOT="" fvm flutter gen-l10n` to regenerate files from `.arb` sources.
- **Files modified:** Generated l10n files (not committed — gitignored)
- **Commit:** N/A

**3. [Rule 1 - Bug] MockBloc requires implements ConcreteBloc**
- **Found during:** Task 1 implementation
- **Issue:** Plan's `class MockIncomeBloc extends MockBloc<IncomeEvent, IncomeState> {}` produces type error at `BlocProvider<IncomeBloc>.value(value: mockIncomeBloc)` — `MockBloc<IncomeEvent, IncomeState>` is not assignable to `IncomeBloc`.
- **Fix:** Added `implements IncomeBloc` (and similarly for SettingsBloc, ExportBloc, CategoryBloc). Dart's MockBloc handles noSuchMethod dispatch.
- **Files modified:** Both test files
- **Commit:** Included in task commits

**4. [Rule 2 - Missing Critical Functionality] LocaleManager initialization in setUpAll**
- **Found during:** Task 1 verification (test 2 failure)
- **Issue:** `IncomeSuccess` renders `IncomeListView -> IncomeWeekGroupView -> IncomeDayGroupView`, which calls `DateTimeExtension.getWeekdayName` -> `LocaleManager().currentLocaleString`. Singleton's `late _currentLocale` throws `LateInitializationError` without prior initialization.
- **Fix:** Added `setUpAll(() { LocaleManager().initialize(const Locale('en')); })`.
- **Files modified:** `income_screen_test.dart`
- **Commit:** Included in Task 1 commit

**5. [Rule 1 - Bug] Pull-to-refresh replaced with retry button tap for D-02**
- **Found during:** Task 1 verification (test 4 failure)
- **Issue:** `RefreshIndicator` drag doesn't dispatch event in tests; `_onRefresh` calls `await bloc.stream.firstWhere(...)` which hangs with a mock empty stream.
- **Fix:** Changed D-02 test to seed `IncomeFailure` state, tap retry `TextButton`, verify `LoadIncomesRequested` dispatch.
- **Files modified:** `income_screen_test.dart`
- **Commit:** Included in Task 1 commit

**6. [Rule 1 - Bug] Import path corrected from ../../../../ to ../../../**
- **Found during:** Task 1 implementation
- **Issue:** Plan documented `../../../../helpers/test_app.dart` which resolves to project root, not test/helpers/.
- **Fix:** Used `../../../helpers/test_app.dart` (3 levels up from test/presentation/screens/income/).
- **Files modified:** Both test files
- **Commit:** Included in task commits

## Known Stubs

None. Both test files test production code without stubs in production paths.

## Threat Flags

No new production code written. Test files only.

## Self-Check: PASSED

- [x] `test/presentation/screens/income/income_screen_test.dart` exists — commit d7bbaaa
- [x] `test/presentation/screens/categories/categories_screen_test.dart` exists — commit cf4a06b
- [x] Both files have 0 lint issues (`fvm flutter analyze`)
- [x] income_screen_test.dart: 4 tests passing
- [x] categories_screen_test.dart: 3 tests passing
- [x] Full suite: 137 tests passing, 0 failures
- [x] No equality matchers for CategoryState
- [x] tearDown calls GetIt.instance.reset() in both files
- [x] No MockCategoryBloc in income_screen_test.dart
