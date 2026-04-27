---
phase: 07-integration-gap-closure
plan: 02
subsystem: ui
tags: [flutter, bloc, stats, hive, evolution-chart]

# Dependency graph
requires:
  - phase: 07-integration-gap-closure
    provides: Research identifying STAT-03 — stale evolution chart after same-year CRUD
provides:
  - Unconditional getEvolutionStatsUseCase call on every LoadMonthlyStats event
affects:
  - stats screen annual bar chart refresh behavior

# Tech tracking
tech-stack:
  added: []
  patterns:
    - "Always re-fetch derived stats on every event — avoid conditional caching that causes staleness"

key-files:
  created: []
  modified:
    - lib/presentation/blocs/stats/stats_bloc.dart

key-decisions:
  - "Remove shouldRefetchEvolution guard entirely rather than patching — simplest fix, negligible Hive read overhead (~1ms local read)"
  - "Remove unused currentState declaration (was only used in the removed ternary)"
  - "Remove dataWasCleared variable (was only used in removed shouldRefetchEvolution logic)"

patterns-established:
  - "StatsBloc: getEvolutionStatsUseCase is unconditional — no year-equality guard"

requirements-completed:
  - STAT-03

# Metrics
duration: 8min
completed: 2026-04-27
---

# Phase 7 Plan 02: Remove StatsBloc Evolution Re-fetch Guard Summary

**Unconditional getEvolutionStatsUseCase call replacing year-equality guard in StatsBloc, so annual bar chart always reflects latest data after same-year CRUD operations**

## Performance

- **Duration:** 8 min
- **Started:** 2026-04-27T17:40:00Z
- **Completed:** 2026-04-27T17:48:00Z
- **Tasks:** 1
- **Files modified:** 1

## Accomplishments

- Removed `shouldRefetchEvolution` ternary that conditionally skipped re-fetching evolution stats when the year hadn't changed
- Removed `dataWasCleared` variable (was only used in the removed condition)
- Removed `currentState` variable declaration (was only used in the removed ternary's fallback branch)
- `getEvolutionStatsUseCase` is now called unconditionally on every `LoadMonthlyStats` event
- All 28 existing tests pass; `fvm flutter analyze` exits 0 with no new warnings

## Task Commits

Each task was committed atomically:

1. **Task 1: Remove shouldRefetchEvolution guard from stats_bloc.dart** - `5f6dc48` (fix)

**Plan metadata:** (committed below with SUMMARY.md)

## Files Created/Modified

- `lib/presentation/blocs/stats/stats_bloc.dart` - Removed shouldRefetchEvolution guard and related variables; getEvolutionStatsUseCase now called unconditionally

## Decisions Made

- Removed the entire `shouldRefetchEvolution` variable and ternary rather than patching, keeping the code minimal
- Also removed the now-unused `currentState` and `dataWasCleared` variable declarations to avoid lint warnings
- The `dataWasCleared` guard for Reset All Data path is no longer needed as an explicit variable — the unconditional call handles the reset case naturally (returns empty results when no data)

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 1 - Bug] Removed unused `currentState` variable**

- **Found during:** Task 1 (after removing the shouldRefetchEvolution guard)
- **Issue:** The plan noted to retain `currentState` for the `if (state case final MonthlyStatsLoaded st)` branch below. However, that branch uses the pattern-binding variable `st`, not `currentState` — so `currentState` became unused after removing the ternary, causing an `unused_local_variable` lint warning
- **Fix:** Removed the `currentState` variable declaration entirely
- **Files modified:** lib/presentation/blocs/stats/stats_bloc.dart
- **Verification:** `fvm flutter analyze` exits 0 with no warnings from stats_bloc.dart
- **Committed in:** 5f6dc48 (Task 1 commit)

---

**Total deviations:** 1 auto-fixed (Rule 1 — lint warning from unused variable)
**Impact on plan:** Necessary cleanup; no scope creep. Final code is cleaner than plan's target snippet.

## Issues Encountered

None — the change was straightforward. The only discovery was that `currentState` had no remaining uses after the ternary was removed (the pattern-match branch uses `st`, not `currentState`).

## User Setup Required

None - no external service configuration required.

## Next Phase Readiness

- STAT-03 is closed — annual bar chart now always reflects latest expense/income data after CRUD
- Plan 07-03 can proceed independently (no dependency on this plan)

---
*Phase: 07-integration-gap-closure*
*Completed: 2026-04-27*

## Self-Check: PASSED

- [x] `lib/presentation/blocs/stats/stats_bloc.dart` exists and modified
- [x] Commit `5f6dc48` exists in git log
- [x] `grep shouldRefetchEvolution stats_bloc.dart` → 0 matches
- [x] `grep 'await getEvolutionStatsUseCase' stats_bloc.dart` → 1 match (unconditional)
- [x] `fvm flutter analyze` exits 0 (no errors, no warnings from modified file)
- [x] `fvm flutter test test/` exits 0 (28 tests passed)
