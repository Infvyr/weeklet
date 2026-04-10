---
phase: 03-statistics-screen
plan: "01"
subsystem: statistics
tags: [statistics, bloc, repository, tdd, refactor]
dependency_graph:
  requires: []
  provides:
    - StatisticsRepository.getEvolutionStats(int year) — year-only signature
    - StatisticsRepositoryImpl — 12-month Jan–Dec iteration with hoisted Hive reads
    - GetEvolutionStatsParams — year-only params class
    - StatsFailure — renamed from StatsError (STAT-01 naming convention)
  affects:
    - lib/presentation/blocs/stats/stats_bloc.dart
    - lib/presentation/screens/stats/stats_screen.dart
tech_stack:
  added: []
  patterns:
    - TDD (RED/GREEN) for repository implementation
    - Fake repository stubs with call counters (no Mockito)
key_files:
  created:
    - test/data/repositories/statistics_repository_impl_test.dart
  modified:
    - lib/domain/repositories/statistics_repository.dart
    - lib/domain/usecases/stats/get_evolution_stats_use_case.dart
    - lib/data/repositories/statistics_repository_impl.dart
    - lib/presentation/blocs/stats/stats_state.dart
    - lib/presentation/blocs/stats/stats_bloc.dart
    - lib/presentation/screens/stats/stats_screen.dart
decisions:
  - "Removed month parameter from GetEvolutionStatsParams — evolution stats are always annual (Jan–Dec), month selection is irrelevant"
  - "Hoisted getIncomes() and getAllCategories() outside the 12-iteration loop — reduces Hive reads from 24 to 2 per getEvolutionStats call"
  - "Removed unused statistics.dart import from stats_bloc.dart — exposed by removing EvolutionStats? type annotation"
metrics:
  duration: ~10 min
  completed: 2026-04-10T17:27:00Z
  tasks_completed: 2
  tasks_total: 2
  files_modified: 6
  files_created: 1
---

# Phase 03 Plan 01: Fix Evolution Stats Pipeline + StatsFailure Rename Summary

Fix 12-month Jan–Dec iteration with hoisted Hive reads and rename StatsError to StatsFailure across domain, BLoC, and screen layers.

## Tasks Completed

| # | Task | Commit | Files |
|---|------|--------|-------|
| 1 | Test scaffold + repository + use case pipeline (STAT-03, STAT-04) | `4965773` | test/data/repositories/statistics_repository_impl_test.dart, lib/domain/repositories/statistics_repository.dart, lib/domain/usecases/stats/get_evolution_stats_use_case.dart, lib/data/repositories/statistics_repository_impl.dart |
| 2 | StatsFailure rename + BLoC call-site cleanup (D-11, STAT-01) | `49c0e07` | lib/presentation/blocs/stats/stats_state.dart, lib/presentation/blocs/stats/stats_bloc.dart, lib/presentation/screens/stats/stats_screen.dart |

## What Was Built

**Task 1 — Repository + use case pipeline fix (TDD):**

- `StatisticsRepository` interface updated: `getEvolutionStats(int month, int year)` → `getEvolutionStats(int year)`
- `GetEvolutionStatsParams` simplified: removed `month` field; `props` now `[year]` only
- `GetEvolutionStatsUseCase.call` updated to pass `params.year` only
- `StatisticsRepositoryImpl.getEvolutionStats` fully rewritten:
  - Signature changed from `(int month, int year)` to `(int year)`
  - Fixed 12-month iteration: `for (int m = 1; m <= 12; m++)`
  - `getIncomes()` and `getAllCategories()` hoisted outside loop
  - All 12 `MonthlySnapshot` objects carry correct `year`
- New unit test file with 5 tests (all pass): count of snapshots, months 1–12 present, year correctness, getIncomes called once, getAllCategories called once

**Task 2 — StatsFailure rename + BLoC cleanup:**

- `StatsError` renamed to `StatsFailure` in `stats_state.dart`
- `stats_bloc.dart` changes:
  - Deleted `evolutionMonth` dead-code variable
  - Updated `GetEvolutionStatsParams(year: event.year)` — no `month:` arg
  - `emit(StatsFailure(e.toString()))` — was `emit(StatsError(...))`
  - Removed unused `statistics.dart` import
- `stats_screen.dart`: `final StatsError error =>` → `final StatsFailure error =>`

## Success Criteria Verification

- [x] STAT-03: `getEvolutionStats` produces 12 MonthlySnapshots (Jan–Dec) — verified by Test 1+2
- [x] STAT-04: `getIncomes()` and `getAllCategories()` called once per `getEvolutionStats` — verified by Test 4+5
- [x] STAT-01 (partial): `StatsFailure` naming convention matches CLAUDE.md standard
- [x] All 5 new unit tests pass
- [x] Zero analyzer errors on modified files
- [x] Full test suite (21 tests) passes

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 1 - Bug] Removed unused import in stats_bloc.dart**
- **Found during:** Task 2 — analyzer run
- **Issue:** After removing `EvolutionStats? evolutionStats` explicit type annotation (replaced with `final evolutionStats = await ...`), the `statistics.dart` import became unused
- **Fix:** Removed `import 'package:weeklet/domain/entities/statistics.dart'` from `stats_bloc.dart`
- **Files modified:** `lib/presentation/blocs/stats/stats_bloc.dart`
- **Commit:** `49c0e07`

## Known Stubs

None — all data is wired through real repository calls.

## Threat Flags

No new network endpoints, auth paths, file access patterns, or schema changes introduced. All reads remain local Hive storage operations.
