---
phase: 07-integration-gap-closure
reviewed: 2026-04-27T00:00:00Z
depth: standard
files_reviewed: 14
files_reviewed_list:
  - lib/presentation/screens/expenses/expenses_screen.dart
  - lib/presentation/screens/income/income_screen.dart
  - lib/presentation/screens/stats/stats_screen.dart
  - lib/presentation/screens/stats/widgets/stats_summary_cards/stats_summary_cards.dart
  - lib/presentation/screens/stats/widgets/stats_summary_cards/stats_balance_card.dart
  - lib/presentation/screens/stats/widgets/stats_summary_cards/stats_small_card.dart
  - lib/presentation/screens/stats/widgets/category_details_list/category_details_list.dart
  - lib/presentation/screens/stats/widgets/category_details_list/category_details_item.dart
  - lib/presentation/screens/stats/widgets/monthly_item/monthly_item.dart
  - lib/presentation/screens/stats/widgets/monthly_item/monthly_bar_row.dart
  - lib/presentation/screens/stats/widgets/monthly_expenses_list.dart
  - lib/presentation/screens/stats/widgets/modern_donut_chart.dart
  - lib/presentation/screens/stats/widgets/annual_grouped_bar_chart.dart
  - lib/presentation/blocs/stats/stats_bloc.dart
findings:
  critical: 2
  warning: 4
  info: 2
  total: 8
status: issues_found
---

# Phase 07: Code Review Report

**Reviewed:** 2026-04-27T00:00:00Z
**Depth:** standard
**Files Reviewed:** 14
**Status:** issues_found

## Summary

Phase 07 threaded `currencySymbol` reactively from `SettingsBloc` through all
screen and widget files, and removed the stale-cache guard
(`shouldRefetchEvolution`) from `stats_bloc.dart` so evolution stats always
re-fetch on every `LoadMonthlyStats` event.

The reactive wiring is mostly correct. However, two blockers stand out: a
busy-loop in the pull-to-refresh implementation that will spin forever when the
widget is disposed during loading, and a broken `getMaxTotal` computation in
`EvolutionStatsUtils` that inflates bar-chart Y-axis scaling by summing
category amounts on top of income instead of taking the max of income vs
expenses. Three additional warnings address hardcoded fallback strings that
bypass the project constant, a `StatsLoading` dead-fall state that leaves the
screen blank on reload, and a tab-switch that fires a redundant `StatsBloc`
rebuild from inside `ModernDonutChart`.

---

## Critical Issues

### CR-01: `_onRefresh` busy-loop can spin forever if the widget is disposed mid-load

**File:** `lib/presentation/screens/expenses/expenses_screen.dart:76-80`
**Also:** `lib/presentation/screens/income/income_screen.dart:75-79`

**Issue:** Both screens implement pull-to-refresh with `Future.doWhile`. The
body of the loop checks `!mounted` and returns `false` (stop) correctly — but
only when `mounted` is already `false` at the top of each iteration. If the
widget is disposed between the `return true` of one iteration and the very next
`mounted` check, the loop re-enters, sees `mounted == false`, and stops cleanly.
However, between each iteration `Future.doWhile` waits for the inner
`Future<bool>` to complete. Because the inner future is an `async` closure with
no `await` or sleep, it resolves in a microtask queue tick — effectively a
tight CPU spin — not a real poll. On slow devices or when Hive takes time, this
will run hundreds of thousands of iterations per second, blocking the event loop
and making the UI unresponsive. There is also no timeout: if `ExpenseBloc`
(or `IncomeBloc`) gets stuck in a state other than `ExpenseSuccess` or
`ExpenseFailure` — e.g. if an unhandled exception leaves it in `ExpenseLoading`
permanently — the loop never exits and the pull-to-refresh spinner hangs
indefinitely.

**Fix:** Replace with a `StreamSubscription`-based approach or add an explicit
`await Future.delayed(const Duration(milliseconds: 50))` with a timeout guard:

```dart
Future<void> _onRefresh() async {
  if (!mounted) return;
  context.read<ExpenseBloc>().add(const LoadExpensesRequested());

  const timeout = Duration(seconds: 10);
  final deadline = DateTime.now().add(timeout);

  while (mounted) {
    final state = context.read<ExpenseBloc>().state;
    if (state is ExpenseSuccess || state is ExpenseFailure) break;
    if (DateTime.now().isAfter(deadline)) break;
    await Future<void>.delayed(const Duration(milliseconds: 50));
  }
}
```

---

### CR-02: `EvolutionStatsUtils.getMaxTotal` computes a wrong maximum, corrupting bar-chart Y-axis scale

**File:** `lib/presentation/screens/stats/widgets/annual_grouped_bar_chart.dart:29`
**Root cause:** `lib/domain/utils/evolution_stats_utils.dart:41-53`

**Issue:** `AnnualGroupedBarChart` calls `EvolutionStatsUtils.getMaxTotal` to
obtain `maxY` for the bar chart. The implementation of `getMaxTotal` does NOT
compute `max(totalIncome, totalExpenses)` for each snapshot. Instead it starts
from `totalIncome` and then **adds** each category's `totalAmount` on top of it:

```dart
double monthMax = snapshot.totalIncome;
for (final catStat in snapshot.categoryStats) {
  monthMax += catStat.totalAmount;  // ← adds expenses on top of income
}
```

`totalExpenses` on the snapshot is the sum of all category amounts, so
`monthMax` ends up as roughly `income + expenses` rather than `max(income,
expenses)`. For a month with 3,000 MDL income and 2,500 MDL expenses this
yields `5,500 * 1.1 = 6,050` as `maxY` instead of the correct `3,300`. The
bars are rendered at approximately half their intended visual height, making the
chart misleading — high-expense months look identical to low-expense months.

Note: `getMaxTotal` is referenced only from `AnnualGroupedBarChart`, so the
other utilities (`getMaxIncome`, `getMaxExpenses`) are not affected.

**Fix:** Replace the loop with a simple max over income and expenses:

```dart
static double getMaxTotal(EvolutionStats evolutionStats) {
  if (evolutionStats.snapshots.isEmpty) return 0;
  double max = 0;
  for (final snapshot in evolutionStats.snapshots) {
    final monthMax = snapshot.totalIncome > snapshot.totalExpenses
        ? snapshot.totalIncome
        : snapshot.totalExpenses;
    if (monthMax > max) max = monthMax;
  }
  return max * 1.1;
}
```

---

## Warnings

### WR-01: Hardcoded `'MDL'` fallback in `_onExportTapped` bypasses `AppConstants.DEFAULT_CURRENCY`

**File:** `lib/presentation/screens/expenses/expenses_screen.dart:100`
**Also:** `lib/presentation/screens/income/income_screen.dart:94`

**Issue:** The `build` method correctly falls back to
`AppConstants.DEFAULT_CURRENCY` when `SettingsBloc` is not yet in
`SettingsLoaded`, but `_onExportTapped` (called from a button press, not from
`build`) reads `SettingsBloc` imperatively and falls back to the string literal
`'MDL'`. If the default currency is ever changed in `AppConstants`, the export
path will silently use the stale literal while the UI displays the updated
default. The two fallbacks will diverge.

```dart
// expenses_screen.dart line 98-100
final settingsState = context.read<SettingsBloc>().state;
final currencySymbol = settingsState is SettingsLoaded
    ? settingsState.currencySymbol
    : 'MDL';  // ← should be AppConstants.DEFAULT_CURRENCY
```

**Fix:**

```dart
final currencySymbol = settingsState is SettingsLoaded
    ? settingsState.currencySymbol
    : AppConstants.DEFAULT_CURRENCY;
```

Apply the same change in `income_screen.dart` line 94.

---

### WR-02: `StatsLoading` falls through to `_ => SizedBox.shrink()` during background reloads, blanking the screen

**File:** `lib/presentation/screens/stats/stats_screen.dart:44-114`

**Issue:** `_onLoadMonthlyStats` in `stats_bloc.dart` only emits `StatsLoading`
when `isInitialLoad` is true (i.e. the previous state is not
`MonthlyStatsLoaded`). This is intentional — it avoids flickering on reload.
However, if the app restores from background or `StatsBloc` is recreated and
the state resets to `StatsInitial`, any `LoadMonthlyStats` event will emit
`StatsLoading`. The `switch` in `StatsView.build` matches `StatsLoading` and
shows a spinner, then falls directly to `_ => SizedBox.shrink()` for
`StatsInitial` — that case is already handled. But the `StatsLoading` arm never
has a path back to content if a `StatsFailure` is emitted after a prior
`MonthlyStatsLoaded` state (because `isInitialLoad` would be `false`, so
`StatsLoading` is NOT emitted — instead the state stays as `MonthlyStatsLoaded`
while re-fetching, and the old data stays visible). This is actually the correct
behaviour described in the bloc comment.

The real issue is the reverse scenario: `StatsFailure` → user taps "Retry" →
`LoadMonthlyStats` emitted → `isInitialLoad = true` (because current state is
`StatsFailure`, not `MonthlyStatsLoaded`) → `StatsLoading` emitted → spinner
shown → then if the use case throws again → `StatsFailure` emitted →
`StatsErrorView` shown. So the round-trip is correct. However, `StatsInitial`
(the very first state) is handled by the `_ => SizedBox.shrink()` fallback,
meaning there is a brief single-frame blank screen on startup before the bloc
transitions to `StatsLoading`. This is a visual glitch, not a crash, but it is
worth noting.

More importantly: if `StatsBloc` emits `StatsLoading` (e.g., on initial load)
and then a second event arrives that is processed before the first completes
(because `on<LoadMonthlyStats>` has no `transformer`), the state can oscillate
between `StatsLoading` and old states unpredictably. Without a `droppable` or
`restartable` transformer, concurrent `LoadMonthlyStats` events are processed
sequentially but queued, so a rapid double-fire will produce two full network
round-trips and the second result will overwrite the first.

**Fix (minimal):** Treat `StatsInitial` the same as `StatsLoading` to eliminate
the blank frame:

```dart
StatsLoading _ || StatsInitial _ => const Center(
  child: CircularProgressIndicator.adaptive(),
),
```

For the concurrent-event issue, add a `droppable` transformer to
`on<LoadMonthlyStats>`:

```dart
on<LoadMonthlyStats>(
  _onLoadMonthlyStats,
  transformer: droppable(),  // import from bloc_concurrency
);
```

---

### WR-03: `MonthlyStatsLoaded.copyWith` does not reset `touchedIndex` on data reload, leaving stale pie-chart selection

**File:** `lib/presentation/blocs/stats/stats_bloc.dart:66-76`

**Issue:** When `_onLoadMonthlyStats` calls `st.copyWith(...)` after a
successful reload, it does not pass `touchedIndex`. The `copyWith` method
defaults to `touchedIndex ?? this.touchedIndex`, so the previously touched
chart segment index is preserved across reloads. If the user had touched segment
index 2, then data is reloaded (e.g. after adding an expense that removes a
category), the new category list may have fewer than 3 items. The
`ModernDonutChart` will call `_generateSections` with `touchedIndex = 2` but
only 2 sections exist, so section at index 2 is rendered as "touched" only when
`i == 2` — which never matches — so visually nothing breaks. However, the
legend opacity logic at line 116 (`lib/presentation/screens/stats/widgets/modern_donut_chart.dart`)
uses `isAnythingTouched = touchedIndex != -1`, which evaluates to `true` with
the stale index. This causes all legend items to render at 40% opacity
(`opacity = 0.4`) when none of them is actually selected, making the legend look
faded for no user-visible reason.

**Fix:** Reset `touchedIndex` to -1 in the reload path:

```dart
emit(
  st.copyWith(
    stats: stats,
    month: selectedMonth,
    clearMonth: selectedMonth == null,
    year: event.year,
    evolutionStats: evolutionStats,
    availablePeriods: availablePeriods,
    touchedIndex: -1,   // ← add this
  ),
);
```

---

### WR-04: `StatsSmallCard` multiplies `percentage` by 100 but `MonthlyStats` field semantics are ambiguous — risk of double-scaling if the use case changes the unit

**File:** `lib/presentation/screens/stats/widgets/stats_summary_cards/stats_small_card.dart:80`

**Issue:** `StatsSmallCard` formats the growth percentage as:

```dart
'${(percentage * 100).abs().toStringAsFixed(1)}%'
```

This treats `percentage` as a fraction in `[0, 1]`. The `MonthlyStats` entity
documents `incomeGrowthPercentage` and `expenseGrowthPercentage` only with the
comment `// Compared to last month` — no unit is stated. The `CategoryStats`
entity similarly documents `percentage` as `// 0.0 to 1.0`. If the producing
use case (`GetMonthlyStatsUseCase`) ever changes to return values already in
`[0, 100]` (a common source of confusion), the display will show `4500%` instead
of `45%`. There is no assertion, clamp, or documented contract at the
`MonthlyStats` entity boundary.

This is not currently broken — a review of the growth-percentage computation in
`GetMonthlyStatsUseCase` is assumed correct — but the lack of a documented
unit contract at the entity boundary is a latent defect trigger.

**Fix:** Add explicit unit documentation to `MonthlyStats`:

```dart
/// Growth percentage as a fraction, e.g. 0.12 means 12% growth.
/// Negative values indicate a decrease.
final double incomeGrowthPercentage;

/// Growth percentage as a fraction, e.g. -0.05 means 5% decrease.
final double expenseGrowthPercentage;
```

---

## Info

### IN-01: `StatsView` is a superfluous wrapper `StatelessWidget` with no added value

**File:** `lib/presentation/screens/stats/stats_screen.dart:30-118`

**Issue:** `StatsScreen` delegates entirely to `StatsView`:

```dart
class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});
  @override
  Widget build(BuildContext context) => const StatsView();
}
```

`StatsView` is private in intent but `StatsView` is public and adds zero
abstraction — it is not reused anywhere, takes no parameters, and contains all
the real build logic. The split adds indirection without benefit and creates an
inconsistency with the other screens (`ExpensesScreen`, `IncomeScreen`) which
are single-class files.

**Fix:** Merge `StatsView` into `StatsScreen` and delete the wrapper class.

---

### IN-02: `BlocBuilder<StatsBloc, StatsState>` inside `ModernDonutChart.build` adds a redundant subscription

**File:** `lib/presentation/screens/stats/widgets/modern_donut_chart.dart:25-169`

**Issue:** `ModernDonutChart` is a `StatelessWidget` that receives
`categoryStats`, `totalExpenses`, and `currencySymbol` as constructor
parameters — all the data it needs. However, it also wraps its entire subtree in
a `BlocBuilder<StatsBloc, StatsState>` to read `state.touchedIndex`. This means
every `StatsBloc` state emission (including `LoadMonthlyStats` reload, tab
changes, and every chart touch) triggers a full rebuild of the entire donut chart
subtree via two separate paths: once from the parent's `BlocBuilder` in
`StatsView`, and once from its own nested `BlocBuilder`. The `touchedIndex`
could instead be passed as a constructor parameter from the parent, making
`ModernDonutChart` a pure presentation widget and eliminating the redundant
subscription.

**Fix:** Add `touchedIndex` as a constructor parameter and remove the internal
`BlocBuilder`:

```dart
class ModernDonutChart extends StatelessWidget {
  const ModernDonutChart({
    super.key,
    required this.categoryStats,
    required this.totalExpenses,
    required this.currencySymbol,
    required this.touchedIndex,   // ← new
  });

  final List<CategoryStats> categoryStats;
  final double totalExpenses;
  final String currencySymbol;
  final int touchedIndex;

  @override
  Widget build(BuildContext context) {
    // Remove BlocBuilder wrapper; use this.touchedIndex directly
    ...
  }
}
```

In `stats_screen.dart`, pass `loaded.touchedIndex` from the already-resolved
`MonthlyStatsLoaded` state.

---

_Reviewed: 2026-04-27T00:00:00Z_
_Reviewer: Claude (gsd-code-reviewer)_
_Depth: standard_
