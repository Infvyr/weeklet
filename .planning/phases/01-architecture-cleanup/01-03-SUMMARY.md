---
phase: 01-architecture-cleanup
plan: 03
subsystem: core/constants, presentation/widgets
tags: [currency, constants, refactor, REL-03]
dependency_graph:
  requires: [01-01]
  provides: [AppConstants.DEFAULT_CURRENCY, currency-consistency-layer]
  affects: [Phase 4 Settings - currency will swap single constant]
tech_stack:
  added: [lib/core/constants/app_constants.dart]
  patterns: [single-source-of-truth for currency symbol]
key_files:
  created:
    - lib/core/constants/app_constants.dart
  modified:
    - lib/presentation/screens/expenses/widgets/list/expense_day_group_view.dart
    - lib/presentation/screens/expenses/widgets/list/expense_week_group_view.dart
    - lib/presentation/screens/expenses/widgets/list/expense_list_view.dart
    - lib/presentation/screens/expenses/widgets/list/expense_item_view.dart
    - lib/presentation/screens/income/widgets/list/income_day_group_view.dart
    - lib/presentation/screens/income/widgets/list/income_item_view.dart
    - lib/presentation/screens/income/widgets/list/income_week_group_view.dart
    - lib/presentation/screens/income/widgets/list/income_list_view.dart
    - lib/presentation/screens/income/widgets/income_total_card.dart
    - lib/presentation/widgets/common/form/amount_field_view.dart
    - lib/presentation/screens/stats/widgets/annual_grouped_bar_chart.dart
    - lib/presentation/screens/stats/widgets/modern_donut_chart.dart
    - lib/presentation/screens/stats/widgets/stats_summary_cards/stats_small_card.dart
    - lib/presentation/screens/stats/widgets/stats_summary_cards/stats_balance_card.dart
decisions:
  - "AppConstants uses a private constructor (AppConstants._()) to prevent instantiation — consistent with utility class pattern"
  - "DEFAULT_CURRENCY uses SCREAMING_SNAKE_CASE per CLAUDE.md constants convention, accepted info-level lint"
  - "Worktree required flutter pub get before analysis server could resolve package URIs"
metrics:
  duration: 9 minutes
  completed_date: "2026-04-04"
  tasks_completed: 2
  files_changed: 15
---

# Phase 01 Plan 03: Currency Consolidation Summary

**One-liner:** Introduced `AppConstants.DEFAULT_CURRENCY = 'MDL'` as a single source of truth, replacing 14 scattered hardcoded 'MDL', 'lei', and 'RON' currency literals across expense, income, and stats widgets.

## What Was Built

Created `lib/core/constants/app_constants.dart` with a single `DEFAULT_CURRENCY = 'MDL'` constant. Updated all 14 widget files that previously had hardcoded currency strings to reference this constant.

**Task 1 (committed `751f66c`):** AppConstants file + 10 expense/income list widget updates (including `AmountFieldView`)

**Task 2 (committed `ad4fb8e`):** 4 stats chart widget updates replacing 'RON' literal

## Verification Results

- `grep -rn "'MDL'\|'lei'\|'RON'" lib/presentation/` — 0 matches in widget constructors
- `grep -rn 'AppConstants.DEFAULT_CURRENCY' lib/presentation/` — 14 matches (all files)
- `fvm flutter analyze lib/ --no-pub` — 0 errors
- `fvm flutter test test/core/constants/ --no-pub` — 1 test passed (app_constants_test.dart)

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 3 - Blocking] Worktree missing .dart_tool package config**
- **Found during:** Task 1 verification
- **Issue:** The worktree at `.claude/worktrees/agent-a6999104/` lacked a `.dart_tool/` directory, so `fvm flutter analyze` reported `uri_does_not_exist` for `app_constants.dart` even though the file existed.
- **Fix:** Ran `fvm flutter pub get` inside the worktree to generate `.dart_tool/package_config.json` with the correct package root.
- **Files modified:** `.dart_tool/package_config.json` (generated, not committed)
- **Commit:** N/A (generated file excluded from git)

**2. [Rule 3 - Blocking] Worktree branch was on initial commit**
- **Found during:** Initial setup
- **Issue:** The `worktree-agent-a6999104` branch was at `e11eacc` (init proj commit) while `dev` was at `42862a8`, so the worktree had no project source code.
- **Fix:** `git reset --hard dev` to align worktree with current dev HEAD.
- **Files modified:** All project files (worktree now mirrors dev)
- **Commit:** N/A (structural git worktree fix)

## Known Stubs

None — all 14 files are fully wired to `AppConstants.DEFAULT_CURRENCY`. Phase 4 (Settings) will replace this constant with a user-configurable value from `SettingsRepository`.

## Self-Check: PASSED

- app_constants.dart: FOUND
- expense_day_group_view.dart: FOUND
- annual_grouped_bar_chart.dart: FOUND
- commit 751f66c: FOUND
- commit ad4fb8e: FOUND
