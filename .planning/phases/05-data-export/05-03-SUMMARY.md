---
phase: 05-data-export
plan: 03
subsystem: presentation
tags: [pdf-export, screen-integration, share_plus, bloc-listener, bloc-builder]

requires:
  - phase: 05-data-export
    plan: 02
    provides: ExportBloc, ExportExpensesUseCase, ExportIncomeUseCase, DI registration, BlocProvider in app.dart

provides:
  - ExpensesScreen: export icon button + BlocListener wired to ExportBloc (ExportExpensesStarted)
  - IncomeScreen: export icon button + BlocListener wired to ExportBloc (ExportIncomeStarted)
  - Null-month guard on both screens showing snackbar instead of dispatching

affects:
  - 05-04-PLAN (verification wave — manual testing of export flow end-to-end)

tech-stack:
  added: []
  patterns:
    - BlocListener wrapping Scaffold for side-effect handling (share sheet, error snackbar)
    - BlocBuilder in AppBar actions for icon/loading toggle
    - Capture context.read<T>() before async gap to satisfy use_build_context_synchronously lint
    - const Rect.fromLTWH(0, 0, 1, 1) as iPad-safe sharePositionOrigin fallback

key-files:
  created: []
  modified:
    - lib/presentation/screens/expenses/expenses_screen.dart
    - lib/presentation/screens/income/income_screen.dart

key-decisions:
  - "ExportBloc reference captured before await SharePlus.instance.share() to satisfy use_build_context_synchronously lint — avoids async-gap context use"
  - "const Rect.fromLTWH(0, 0, 1, 1) used for sharePositionOrigin — avoids dart:ui import since Rect is re-exported by flutter/material.dart"
  - "Income screen has no categories lookup — ExportIncomeStarted takes no categories param (use case handles income-only layout)"

metrics:
  duration: ~10min
  completed: 2026-04-12
---

# Phase 05 Plan 03: Screen Integration — Export Icons Wired Summary

**Both ExpensesScreen and IncomeScreen have functional PDF export icon buttons, BlocListeners for share sheet / error handling, and null-month guards — completing EXP-01 and EXP-02**

## Performance

- **Duration:** ~10 min
- **Started:** 2026-04-12T16:23:00Z
- **Completed:** 2026-04-12T16:33:59Z
- **Tasks:** 2
- **Files modified:** 2

## Accomplishments

- Added `ExportBloc` `BlocListener` to `ExpensesScreen` wrapping the entire `Scaffold` — handles `ExportSuccess` (invokes `SharePlus.instance.share` with `XFile` + subject) and `ExportFailure` (error snackbar + reset)
- Added `BlocBuilder<ExportBloc, ExportState>` in `AppBar.actions` — shows `Icons.picture_as_pdf` icon button in idle state, switches to `CircularProgressIndicator.adaptive` with `semanticsLabel: 'Generating PDF…'` during `ExportInProgress`
- Added `_onExportTapped()` in `_ExpensesScreenState` — guards on `selectedMonth == null` (snackbar), reads `CategoryBloc` + `SettingsBloc` for params, dispatches `ExportExpensesStarted`
- Mirrored identical pattern in `IncomeScreen` — dispatches `ExportIncomeStarted` (no categories param), reads `IncomeBloc` state
- Both files: captured `ExportBloc` reference before the `await` gap to comply with `use_build_context_synchronously` lint
- `fvm flutter analyze` — 0 issues on both modified files
- `fvm flutter test` — 28/28 GREEN (no regressions)

## Task Commits

Each task was committed atomically:

1. **Task 1: Wire export icon + BlocListener into ExpensesScreen** - `2fbc30a`
2. **Task 2: Wire export icon + BlocListener into IncomeScreen** - `bc5a87e`

## Files Created/Modified

- `lib/presentation/screens/expenses/expenses_screen.dart` — BlocListener + BlocBuilder + _onExportTapped(), ExportExpensesStarted dispatch, null-month guard
- `lib/presentation/screens/income/income_screen.dart` — BlocListener + BlocBuilder + _onExportTapped(), ExportIncomeStarted dispatch, null-month guard

## Decisions Made

- Captured `context.read<ExportBloc>()` into local `exportBloc` variable before `await SharePlus.instance.share(...)` — required to satisfy `use_build_context_synchronously` lint rule (context must not be used across async gaps without a prior capture)
- Used `const Rect.fromLTWH(0, 0, 1, 1)` for `sharePositionOrigin` — `Rect` is accessible via `flutter/material.dart` without a separate `dart:ui` import; adding `dart:ui` would trigger `unnecessary_import` lint
- Income export has no `CategoriesLoaded` lookup — `ExportIncomeStarted` accepts only `incomes`, `currencySymbol`, `year`, `month`

## Deviations from Plan

None — plan executed exactly as written.

The only fix needed during implementation was cosmetic: the plan's code snippet included `import 'dart:ui' show Rect;` but Flutter's `material.dart` already re-exports `Rect`, making the import unnecessary (lint `unnecessary_import`). The import was omitted from both files — the logic is unchanged.

## Threat Surface Scan

No new threat surface beyond what was documented in the plan's threat model:
- T-05-03-01: OS share sheet — user-initiated, accepted
- T-05-03-02: currencySymbol in ShareParams.subject — no amounts, accepted
- T-05-03-03: null selectedMonth guard — implemented via `if (expenseState.selectedMonth == null)` / `if (incomeState.selectedMonth == null)` checks before dispatch — mitigated

## Known Stubs

None. Both screens wire real BLoC events to real use cases. The export icon is fully functional. No placeholder data flows to UI.

## Self-Check: PASSED

- FOUND: lib/presentation/screens/expenses/expenses_screen.dart (contains ExportExpensesStarted, BlocListener, BlocBuilder, Icons.picture_as_pdf, ResetExportRequested, SharePlus.instance.share, null-month guard)
- FOUND: lib/presentation/screens/income/income_screen.dart (contains ExportIncomeStarted, BlocListener, BlocBuilder, Icons.picture_as_pdf, ResetExportRequested, SharePlus.instance.share, null-month guard)
- COMMIT 2fbc30a: feat(05-03): wire export icon and BlocListener into ExpensesScreen — verified
- COMMIT bc5a87e: feat(05-03): wire export icon and BlocListener into IncomeScreen — verified
- fvm flutter analyze (both files) — 0 issues
- fvm flutter test — 28/28 GREEN

---
*Phase: 05-data-export*
*Completed: 2026-04-12*
