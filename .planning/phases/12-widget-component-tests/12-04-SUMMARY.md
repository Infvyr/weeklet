---
phase: 12-widget-component-tests
plan: "04"
subsystem: test-presentation-screens
tags: [testing, widget-tests, stats-screen, settings-screen, biometric, mocktail, bloc_test]
one_liner: "StatsScreen and SettingsScreen widget tests with sealed-class mock pattern, AppTheme fixture, and PackageInfo stub"

dependency_graph:
  requires:
    - 12-01 (pumpApp helper, test_data factories)
  provides:
    - test/presentation/screens/stats/stats_screen_test.dart (TEST-20: 4 widget tests)
    - test/presentation/screens/settings/settings_screen_test.dart (TEST-21: 4 widget tests)
  affects:
    - test/helpers/test_app.dart (extended with optional theme parameter)

tech_stack:
  added: []
  patterns:
    - "MockBloc implements ConcreteBloc pattern: class MockXxxBloc extends MockBloc<E,S> implements XxxBloc — satisfies BlocProvider<XxxBloc>.value() strict type check"
    - "Sealed class fallback values: registerFallbackValue(const ConcreteSubclass()) instead of Fake implements SealedClass (invalid outside sealed library)"
    - "pumpApp theme parameter: optional ThemeData param added for screens using context.theme.appBarTheme.backgroundColor! (null-assertion crash without full theme)"
    - "PackageInfo.setMockInitialValues in setUpAll: prevents MissingPluginException from SettingsScreen initState PackageInfo.fromPlatform()"

key_files:
  created:
    - test/presentation/screens/stats/stats_screen_test.dart
    - test/presentation/screens/settings/settings_screen_test.dart
  modified:
    - test/helpers/test_app.dart (added optional theme: ThemeData? parameter)

decisions:
  - "MockBloc implements ConcreteBloc (not Fake): sealed BLoC Event/State classes cannot be implemented outside their library; using concrete subclasses as fallback values instead"
  - "AppTheme.lightTheme passed for StatsScreen: StatsTabsSection uses context.theme.appBarTheme.backgroundColor! with null assertion — crashes without proper AppBarTheme"
  - "pumpApp extended with optional theme param (Rule 2 deviation): test infrastructure lacked theme support required by stats screen widgets"
  - "GetIt registration skipped for StatsScreen: confirmed StatelessWidget with no sl<> calls; registration not needed"
  - "SettingsLoaded (not SettingsInitial) as default setUp seed: ensures biometric switch is visible for dispatch verification test"

metrics:
  duration: "~25 minutes"
  completed_date: "2026-06-21"
  tasks_completed: 2
  tasks_total: 2
  files_created: 2
  files_modified: 1
---

# Phase 12 Plan 04: StatsScreen and SettingsScreen Widget Tests Summary

**One-liner:** StatsScreen and SettingsScreen widget tests with sealed-class mock pattern, AppTheme fixture, and PackageInfo stub

## What Was Built

Two test files covering TEST-20 (StatsScreen) and TEST-21 (SettingsScreen):

**stats_screen_test.dart (4 tests):**
- `shows CircularProgressIndicator when state is StatsInitial` — default loading state
- `shows CircularProgressIndicator when state is StatsLoading` — explicit loading state
- `renders CustomScrollView when MonthlyStatsLoaded` — chart branch rendered, CircularProgressIndicator absent
- `shows error content when state is StatsFailure` — error branch rendered without chart

**settings_screen_test.dart (4 tests):**
- `shows CircularProgressIndicator when state is SettingsInitial` — loading state
- `shows CircularProgressIndicator when state is SettingsLoading` — explicit loading state
- `renders settings list when SettingsLoaded` — ListView and Switch visible
- `dispatches BiometricToggled when biometric switch is tapped` — D-02 event dispatch verified via `verify(() => bloc.add(any(that: isA<BiometricToggled>()))).called(1)`

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 1 - Bug] Sealed class cannot be implemented with Fake outside library**
- **Found during:** Task 1
- **Issue:** `class FakeStatsEvent extends Fake implements StatsEvent {}` fails with `invalid_use_of_type_outside_library` — sealed classes restrict external implementation
- **Fix:** Replaced `Fake` fallback classes with concrete subclasses: `registerFallbackValue(const LoadMonthlyStats(year: 2025))`, `registerFallbackValue(const StatsInitial())`, etc.
- **Files modified:** test/presentation/screens/stats/stats_screen_test.dart, test/presentation/screens/settings/settings_screen_test.dart

**2. [Rule 1 - Bug] MockBloc type mismatch with BlocProvider<ConcreteBloc>**
- **Found during:** Task 1
- **Issue:** `MockBloc<StatsEvent, StatsState>` does not extend `StatsBloc`, causing `BlocProvider<StatsBloc>.value(value: mockStatsBloc)` to fail type check
- **Fix:** Declared `class MockStatsBloc extends MockBloc<StatsEvent, StatsState> implements StatsBloc {}` — the `implements` clause satisfies the type requirement; `Mock`'s `noSuchMethod` handles concrete fields via dynamic dispatch
- **Files modified:** Both test files

**3. [Rule 2 - Missing Critical Functionality] StatsTabsSection crashes with null appBarTheme**
- **Found during:** Task 1 (test run)
- **Issue:** `StatsTabsSection` uses `context.theme.appBarTheme.backgroundColor!` (null assertion) which crashes with the default test `MaterialApp` that has no `appBarTheme` set
- **Fix:** Added optional `theme: ThemeData?` parameter to `pumpApp` helper, then passed `AppTheme.lightTheme` in `pumpStatsScreen` helper
- **Files modified:** test/helpers/test_app.dart (Rule 2 — missing critical test infrastructure), test/presentation/screens/stats/stats_screen_test.dart

**4. [Rule 1 - Bug] Wrong relative import path (4 levels instead of 3)**
- **Found during:** Task 1 (first test run)
- **Issue:** Plan specified `../../../../helpers/test_app.dart` (4 levels up) but the file lives at `test/helpers/` which is only 3 levels up from `test/presentation/screens/stats/`
- **Fix:** Corrected to `../../../helpers/test_app.dart`
- **Files modified:** Both test files

## Threat Flags

None. Test files only — no production code modified.

## Known Stubs

None. All test assertions verify real behavior.

## Self-Check: PASSED

Files created:
- test/presentation/screens/stats/stats_screen_test.dart: FOUND
- test/presentation/screens/settings/settings_screen_test.dart: FOUND

Commits:
- 3d06c57: FOUND (feat(12-04): add StatsScreen widget tests)
- a641aaf: FOUND (feat(12-04): add SettingsScreen widget tests)

Test run: 138 tests passed, 0 failures (full suite including all Phase 11 and Phase 12 tests)
Lint: 0 issues on both new test files
