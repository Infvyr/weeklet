---
phase: 01-architecture-cleanup
plan: 04
subsystem: ui
tags: [flutter, bloc, stats, intl, locale, DateFormat]

# Dependency graph
requires:
  - phase: 01-03
    provides: TDD RED tests for getMonthAbbreviation locale-aware behavior
  - phase: 01-02
    provides: StatsBloc with LoadMonthlyStats event and isInitialLoad guard

provides:
  - AppInitializer preloads StatsBloc at startup (no spinner on first Stats screen visit)
  - getMonthAbbreviation uses DateFormat('MMM', locale) — locale-aware for en_US, ro_RO, ru_RU
  - GetExpensesByMonthYearUseCase removed from codebase and DI

affects:
  - Phase 03 (stats screen work depends on StatsBloc being preloaded)
  - Any plan that adds new BLoC preloading to AppInitializer

# Tech tracking
tech-stack:
  added: [intl DateFormat for locale-aware month abbreviations, intl date_symbol_data_local for test setup]
  patterns:
    - AppInitializer is the single place for startup BLoC event dispatch
    - DateFormat('MMM', locale) with try/catch fallback for locale-aware chart labels
    - initializeDateFormatting setUpAll in tests that use intl DateFormat with non-default locales

key-files:
  created: []
  modified:
    - lib/presentation/app_initializer.dart
    - lib/presentation/screens/stats/stats_screen.dart
    - lib/domain/utils/expense_filter_utils.dart
    - lib/core/di/service_locator.dart
    - test/domain/utils/expense_filter_utils_test.dart
  deleted:
    - lib/domain/usecases/expense/get_expenses_by_month_year_usecase.dart

key-decisions:
  - "AppInitializer preloads StatsBloc via LoadMonthlyStats(year: DateTime.now().year) — matches StatsScreen retry button pattern"
  - "getMonthAbbreviation uses explicit locale in DateFormat('MMM', locale) to match the existing date_time_extensions.dart pattern"
  - "intl DateFormat with explicit non-default locale requires initializeDateFormatting — added to test setUpAll; production handled by flutter_localizations"
  - "LoadMonthlyStats retained in StatsView retry callback — only removed from initState (duplicate removed, recovery path preserved)"

patterns-established:
  - "AppInitializer pattern: add BLoC preload events here for any BLoC that needs data ready before first navigation"
  - "Test pattern: call initializeDateFormatting(locale) in setUpAll for tests using intl DateFormat with non-default locales"

requirements-completed: [ARCH-03, ARCH-04]

# Metrics
duration: 25min
completed: 2026-04-04
---

# Phase 01 Plan 04: StatsBloc Preload, Locale-Aware Month Labels, Dead Code Removal Summary

**StatsBloc preloaded at startup via AppInitializer, chart month labels made locale-aware via DateFormat('MMM', locale), and dead GetExpensesByMonthYearUseCase deleted from disk and DI**

## Performance

- **Duration:** ~25 min
- **Started:** 2026-04-04T17:10:00Z
- **Completed:** 2026-04-04T17:35:00Z
- **Tasks:** 2
- **Files modified:** 5 (+ 1 deleted)

## Accomplishments
- StatsBloc now preloaded in `AppInitializer._initializeAppData` — statistics screen shows data immediately on first visit without a spinner
- `getMonthAbbreviation` replaced hardcoded Romanian abbreviation list with `DateFormat('MMM', locale)` using `LocaleManager().currentLocaleString` — correctly returns 'Jan' for en_US, 'ian.' for ro_RO, 'янв.' for ru_RU
- `GetExpensesByMonthYearUseCase` deleted from disk and removed from DI — dead code eliminated, `service_locator.dart` cleaner
- All 16 tests pass (`fvm flutter test --no-pub` exits 0); zero analysis errors

## Task Commits

Each task was committed atomically:

1. **Task 1: Preload StatsBloc in AppInitializer and remove duplicate load from StatsScreen** - `40d5029` (feat)
2. **Task 2: Locale-aware month abbreviations and dead code deletion** - `deb8dbf` (feat)

## Files Created/Modified
- `lib/presentation/app_initializer.dart` - Added StatsBloc/StatsEvent imports; added `LoadMonthlyStats(year: DateTime.now().year)` call in `_initializeAppData`
- `lib/presentation/screens/stats/stats_screen.dart` - Removed `LoadMonthlyStats` from `initState` (kept in retry callback in `StatsView`)
- `lib/domain/utils/expense_filter_utils.dart` - Removed `kMonthAbbreviations` list; replaced `getMonthAbbreviation` body with `DateFormat('MMM', locale)` using `LocaleManager`; added `intl`/`LocaleManager` imports
- `lib/core/di/service_locator.dart` - Removed `GetExpensesByMonthYearUseCase` import and `registerLazySingleton` block
- `test/domain/utils/expense_filter_utils_test.dart` - Added `setUpAll` with `initializeDateFormatting` calls for en_US, ro_RO, ru_RU
- **DELETED:** `lib/domain/usecases/expense/get_expenses_by_month_year_usecase.dart`

## Decisions Made
- Retained `LoadMonthlyStats` in `StatsView` retry callback — plan said remove from `initState` only; retry button is necessary for error recovery and was there before this plan
- Used `DateFormat('MMM', locale)` (explicit locale) rather than `DateFormat('MMM')` (default) — more explicit and consistent with `date_time_extensions.dart` pattern
- `initializeDateFormatting` added to test `setUpAll` — in production, `flutter_localizations` handles this; in unit tests, locale data must be initialized explicitly

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 1 - Bug] Test environment missing intl locale data initialization**
- **Found during:** Task 2 (locale-aware month abbreviations)
- **Issue:** `DateFormat('MMM', 'ro_RO')` throws `LocaleDataException: Locale data has not been initialized` in test environment because `flutter_localizations` (which initializes date formatting) is not loaded in unit tests
- **Fix:** Added `setUpAll(() async { await initializeDateFormatting('en_US'); await initializeDateFormatting('ro_RO'); await initializeDateFormatting('ru_RU'); })` to `expense_filter_utils_test.dart`
- **Files modified:** `test/domain/utils/expense_filter_utils_test.dart`
- **Verification:** All 4 locale-aware tests pass after fix
- **Committed in:** `deb8dbf` (Task 2 commit)

**2. [Rule 2 - Scope clarification] LoadMonthlyStats retained in StatsView retry callback**
- **Found during:** Task 1 (remove LoadMonthlyStats from StatsScreen)
- **Issue:** Plan acceptance criteria stated `grep -c 'LoadMonthlyStats' stats_screen.dart` should return 0, but `StatsView` (a different class in the same file) has a legitimate retry callback that uses `LoadMonthlyStats`. Removing it would break error recovery.
- **Fix:** Removed only from `_StatsScreenState.initState` (the actual duplicate). Kept in `StatsView` retry callback.
- **Files modified:** `lib/presentation/screens/stats/stats_screen.dart`
- **Verification:** `initState` has no `LoadMonthlyStats`; retry button still functions
- **Committed in:** `40d5029` (Task 1 commit)

---

**Total deviations:** 2 auto-fixed (1 bug in test setup, 1 scope clarification)
**Impact on plan:** Both fixes essential for correctness. No scope creep. Core objectives fully achieved.

## Issues Encountered
- `DateFormat` with explicit locale requires `initializeDateFormatting` which is async — resolved by `setUpAll` pattern in test. Production code unaffected (flutter_localizations handles initialization).

## Known Stubs
None — all data paths are wired. `getMonthAbbreviation` now uses real locale-aware `DateFormat`; no hardcoded fallback values reach the UI for the happy path.

## Next Phase Readiness
- ARCH-03 and ARCH-04 complete; Phase 01 architecture cleanup fully done
- Phase 03 (stats screen work) can safely assume StatsBloc is pre-populated with current year data on first navigation
- No blockers for subsequent phases

## Self-Check: PASSED

- FOUND: lib/presentation/app_initializer.dart
- FOUND: lib/domain/utils/expense_filter_utils.dart
- FOUND: .planning/phases/01-architecture-cleanup/01-04-SUMMARY.md
- FOUND commit 40d5029 (Task 1)
- FOUND commit deb8dbf (Task 2)

---
*Phase: 01-architecture-cleanup*
*Completed: 2026-04-04*
