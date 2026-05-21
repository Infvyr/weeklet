---
phase: 11
plan: 3
subsystem: testing
tags: [bloc-test, settings, biometric, getit, locale]
dependency_graph:
  requires: [11-01, 11-02]
  provides: [settings-bloc-coverage]
  affects: [test/helpers/fake_blocs.dart]
tech_stack:
  added: []
  patterns: [blocTest-seed, TestWidgetsFlutterBinding, GetIt-reset-per-test, concrete-fake-blocs]
key_files:
  created:
    - test/presentation/blocs/settings/settings_bloc_test.dart
  modified:
    - test/helpers/fake_blocs.dart
decisions:
  - LocaleChanged(null) test seeded with locale=Locale('ro') so the null transition produces a distinct state (Equatable deduplication prevention)
  - FakeExpenseBloc/FakeIncomeBloc/FakeCategoryBloc updated to extend concrete BLoC types (Rule 2) to satisfy GetIt.registerSingleton<ConcreteType>() calls in ResetAllDataRequested handler
metrics:
  duration: "~12 minutes"
  completed: "2026-05-21T10:53:00Z"
  tasks_completed: 1
  files_changed: 2
---

# Phase 11 Plan 3: SettingsBloc Tests Summary

SettingsBloc unit tests covering all 7 events with BiometricService stub and GetIt isolation per test group for ResetAllDataRequested sl<> calls.

## What Was Built

Created `test/presentation/blocs/settings/settings_bloc_test.dart` with 14 blocTest cases across 8 groups:

- Initial state assertion
- Load: success + failure paths
- Theme: update + ignored-when-not-loaded
- Locale: explicit locale + null (system default) with proper equatable-aware seeding
- Currency: symbol update
- Biometric disable: no auth required path
- Biometric enable: auth success + auth failure (errorBiometricFailed)
- Clear preferences: triggers reload (SettingsLoading → SettingsLoaded)
- Reset all data: 4 fake BLoCs registered in GetIt + use case error sets actionError

## Commits

| Task | Commit | Files |
|------|--------|-------|
| 1 - Write settings_bloc_test.dart | 9a724ae | test/presentation/blocs/settings/settings_bloc_test.dart, test/helpers/fake_blocs.dart |

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 2 - Missing Critical Functionality] FakeExpenseBloc/FakeIncomeBloc/FakeCategoryBloc updated to extend concrete types**

- **Found during:** Task 1 — first test run
- **Issue:** `FakeExpenseBloc`, `FakeIncomeBloc`, `FakeCategoryBloc` in `fake_blocs.dart` extended `Bloc<Event, State>` directly and could not be registered as `ExpenseBloc`, `IncomeBloc`, `CategoryBloc` in GetIt (type incompatibility). The `_onResetAllData` handler in `SettingsBloc` calls `sl<ExpenseBloc>()`, `sl<IncomeBloc>()`, `sl<CategoryBloc>()`, `sl<StatsBloc>()` — requiring exact concrete-type registration.
- **Fix:** Converted all three fake blocs to extend their concrete BLoC types (matching the existing `FakeStatsBloc extends StatsBloc` pattern). Added private stub use cases for each bloc's constructor requirements.
- **Files modified:** `test/helpers/fake_blocs.dart`

**2. [Rule 1 - Bug] LocaleChanged(null) test seeded with non-null locale**

- **Found during:** Task 1 — second test run (1 failure)
- **Issue:** The original `LocaleChanged(null)` test seeded with `_loadedSeed()` (locale=null). After dispatch, the bloc emits `SettingsLoaded(locale: null)` — identical to the seed. Equatable prevented the duplicate state from being emitted by bloc_test, resulting in empty `[]` vs expected `[isA<SettingsLoaded>...]`.
- **Fix:** Changed seed to `SettingsLoaded(settings: Settings(locale: Locale('ro'), ...))` so the null transition produces a genuinely different state.
- **Files modified:** `test/presentation/blocs/settings/settings_bloc_test.dart`

## Test Results

- Settings bloc: **14/14** tests pass
- Full suite: **130/130** tests pass (116 prior + 14 new)
- Lint: **0 issues** (`fvm flutter analyze test/helpers/ test/presentation/blocs/settings/`)

## Known Stubs

None — all stub use cases satisfy the BLoC constructors without impacting production code.

## Threat Flags

None — test-only files; no new network endpoints, auth paths, or schema changes introduced.

## Self-Check: PASSED

- `test/presentation/blocs/settings/settings_bloc_test.dart` — FOUND
- `test/helpers/fake_blocs.dart` — FOUND (modified)
- Commit `9a724ae` — FOUND (`git log --oneline -1` confirms)
