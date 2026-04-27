---
phase: 07-integration-gap-closure
fixed_at: 2026-04-27T21:02:00Z
review_path: .planning/phases/07-integration-gap-closure/07-REVIEW.md
iteration: 1
findings_in_scope: 6
fixed: 6
skipped: 0
status: all_fixed
---

# Phase 07: Code Review Fix Report

**Fixed at:** 2026-04-27T21:02:00Z
**Source review:** .planning/phases/07-integration-gap-closure/07-REVIEW.md
**Iteration:** 1

**Summary:**
- Findings in scope: 6 (CR-01, CR-02, WR-01, WR-02, WR-03, WR-04)
- Fixed: 6
- Skipped: 0

## Fixed Issues

### CR-01: `_onRefresh` busy-loop replaced with stream-based timeout

**Files modified:** `lib/presentation/screens/expenses/expenses_screen.dart`, `lib/presentation/screens/income/income_screen.dart`
**Commit:** 5adc525
**Applied fix:** Replaced `Future.doWhile` tight-spin in `_onRefresh` for both `ExpensesScreen` and `IncomeScreen` with a `bloc.stream.firstWhere(...).timeout(Duration(seconds: 10))` approach. This captures the bloc reference before any `await`, avoids `context.read` after async gaps (eliminating the `use_build_context_synchronously` lint), and guarantees the pull-to-refresh spinner always completes within 10 seconds even if the bloc gets stuck.

---

### CR-02: `EvolutionStatsUtils.getMaxTotal` logic corrected

**Files modified:** `lib/domain/utils/evolution_stats_utils.dart`
**Commit:** cd96ad6
**Applied fix:** Replaced the loop that summed `totalIncome + categoryStats.totalAmount` (which double-counted expenses) with `max(snapshot.totalIncome, snapshot.totalExpenses)` per snapshot. The bar-chart Y-axis scale now reflects the true peak value for the month rather than an inflated income+expenses sum. The 10% padding factor is preserved.

---

### WR-01: Hardcoded `'MDL'` fallback replaced with `AppConstants.DEFAULT_CURRENCY`

**Files modified:** `lib/presentation/screens/expenses/expenses_screen.dart`, `lib/presentation/screens/income/income_screen.dart`
**Commit:** 9a24018
**Applied fix:** In `_onExportTapped` for both screens, replaced the string literal `'MDL'` fallback with `AppConstants.DEFAULT_CURRENCY`. The `build` method already used `AppConstants.DEFAULT_CURRENCY`; this brings the imperative export path into sync with that convention.

---

### WR-02: `StatsInitial` now shows spinner instead of blank frame

**Files modified:** `lib/presentation/screens/stats/stats_screen.dart`
**Commit:** ff95d6b
**Applied fix:** Combined `StatsInitial` and `StatsLoading` in the switch expression using an OR pattern (`StatsLoading _ || StatsInitial _`) so both states render the `CircularProgressIndicator.adaptive`. Also removed the now-dead `_ => SizedBox.shrink()` wildcard arm — it was unreachable after all sealed-class subtypes were explicitly covered, and the analyzer emitted a `[warning]` for it.

---

### WR-03: `touchedIndex` reset to -1 on stats reload

**Files modified:** `lib/presentation/blocs/stats/stats_bloc.dart`
**Commit:** f24e2ba
**Applied fix:** Added `touchedIndex: -1` to the `copyWith` call in `_onLoadMonthlyStats` (the reload-into-existing-state path). This clears any stale chart segment selection on reload, preventing all donut-chart legend items from rendering at 40% opacity when no segment is actually selected.
**Note:** This is a logic fix — requires human verification that resetting `touchedIndex` on every data reload is the desired UX (as opposed to preserving selection across same-period refreshes).

---

### WR-04: Unit contract documented on `MonthlyStats` growth percentage fields

**Files modified:** `lib/domain/entities/statistics.dart`
**Commit:** 57fa34f
**Applied fix:** Replaced the terse `// Compared to last month` inline comments on `incomeGrowthPercentage` and `expenseGrowthPercentage` with explicit `///` doc comments stating the unit is a fraction (e.g. `0.12` = 12% growth). This establishes a documented contract at the entity boundary so a future change in the producing use case cannot silently double-scale the display value.

---

_Fixed: 2026-04-27T21:02:00Z_
_Fixer: Claude (gsd-code-fixer)_
_Iteration: 1_
