---
phase: 12-widget-component-tests
reviewed: 2026-06-21T00:00:00Z
depth: standard
files_reviewed: 10
files_reviewed_list:
  - test/helpers/test_app.dart
  - test/helpers/test_data.dart
  - test/presentation/screens/categories/categories_screen_test.dart
  - test/presentation/screens/expenses/add_expense_form_view_test.dart
  - test/presentation/screens/expenses/expenses_screen_test.dart
  - test/presentation/screens/income/income_screen_test.dart
  - test/presentation/screens/settings/settings_screen_test.dart
  - test/presentation/screens/stats/stats_screen_test.dart
  - test/presentation/widgets/common/form/amount_field_view_test.dart
  - test/presentation/widgets/common/form/date_field_view_test.dart
findings:
  critical: 1
  warning: 2
  info: 2
  total: 5
status: issues_found
---

# Phase 12: Code Review Report

**Reviewed:** 2026-06-21
**Depth:** standard
**Files Reviewed:** 10
**Status:** issues_found

## Summary

Reviewed the full phase-12 widget/component test suite: two shared helpers
(`test_app.dart`, `test_data.dart`) and eight screen/widget tests. The helpers
are correct and well-factored. The screen-level tests generally follow the
project's BLoC mock pattern correctly — `MockBloc + whenListen + BlocProvider.value`
— and the GetIt lifecycle (`registerSingleton` in `setUp`, `reset()` in
`tearDown`) is handled consistently across all files that need it.

Two quality failures require attention before this phase is signed off:
one test assertion is vacuously true in all states (a BLOCKER for test
reliability), and one test has an unguarded conditional that silently turns a
verifiable path into a no-op when the date-picker OK button is absent.

---

## Critical Issues

### CR-01: Vacuous assertion in `StatsFailure` test makes it pass unconditionally

**File:** `test/presentation/screens/stats/stats_screen_test.dart:144-148`

**Issue:** The test `'shows error content when state is StatsFailure'` asserts
only `find.byType(Scaffold)` which is always satisfied regardless of the BLoC
state — `Scaffold` is the unconditional root of `StatsView`. The intent of
the test is to verify that `StatsErrorView` is rendered when the bloc emits
`StatsFailure`, but that widget is never asserted. As written, the test would
pass even if the screen were wired to ignore `StatsFailure` entirely and show
a blank body, because `Scaffold` is still present. This means a regression in
the `StatsFailure` branch cannot be caught by this test.

The source widget (`stats_screen.dart:51`) renders `StatsErrorView` in the
failure branch, but that fact is not exercised by the assertion.

**Fix:**
```dart
// Replace the vacuous Scaffold assertion:
expect(find.byType(Scaffold), findsOneWidget);

// With a positive assertion on the actual error widget:
expect(find.byType(StatsErrorView), findsOneWidget);
// And import StatsErrorView at the top of the test file:
// import 'package:weeklet/presentation/screens/stats/widgets/stats_error_view.dart';

// Optionally verify no loading/success widgets are shown:
expect(find.byType(CircularProgressIndicator), findsNothing);
expect(find.byType(CustomScrollView), findsNothing);
```

---

## Warnings

### WR-01: Conditional date-picker tap makes `dispatches AddExpenseStarted` flaky

**File:** `test/presentation/screens/expenses/add_expense_form_view_test.dart:233-238`

**Issue:** The test gates the date-picker OK tap behind
`if (okButton.evaluate().isNotEmpty)`. If the OK button is absent — because
the dialog did not appear, was rendered with different text in the test
environment, or the animation frame count changed — the tap is silently skipped.
The widget's `_onSave` then calls `_validateDate()` which returns `false`
(because `_selectedDate == null`) and returns early before dispatching
`AddExpenseStarted`. The subsequent `verify()` then fails.

This is a fragile pattern: an unchecked conditional transforms a verifiable
event-dispatch path into a silent no-op, making the test both potentially flaky
and unreliable as a regression guard.

```dart
// Current (fragile):
final okButton = find.text('OK');
if (okButton.evaluate().isNotEmpty) {
  await tester.tap(okButton);
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 500));
}

// Fix — assert the dialog and OK button are present before tapping:
await tester.tap(find.byIcon(Icons.calendar_today_outlined));
await tester.pump();
await tester.pump(const Duration(seconds: 1));

// Assert the dialog appeared (fail fast if not)
expect(find.byType(Dialog), findsOneWidget);
final okButton = find.text('OK');
expect(okButton, findsOneWidget);
await tester.tap(okButton);
await tester.pump();
await tester.pump(const Duration(milliseconds: 500));
```

### WR-02: `'shows income list when filteredIncomes is non-empty'` asserts nothing about list presence

**File:** `test/presentation/screens/income/income_screen_test.dart:101-117`

**Issue:** The test verifies only that `CircularProgressIndicator` is absent
when `IncomeSuccess` has a non-empty list. Any widget — including a blank
container, an error view, or an empty-state view — would pass this assertion.
The test provides no positive evidence that the income list widget is actually
rendered. A regression that routes non-empty `IncomeSuccess` to the wrong branch
(e.g., always shows `EmptyStateView`) would not be caught.

**Fix:** Add a positive assertion on the list or a representative list widget:
```dart
// After expect(find.byType(CircularProgressIndicator), findsNothing);
// Add (replace 'IncomeDayGroupView' or 'ListView' with the actual root list widget):
expect(find.byType(EmptyStateView), findsNothing);
// If there is a named list-container widget (e.g., IncomeListView):
// expect(find.byType(IncomeListView), findsOneWidget);
// Or find the income amount text from fakeIncome():
// expect(find.textContaining('500'), findsWidgets);
```

---

## Info

### IN-01: `StatsLoading` not registered as fallback value in `stats_screen_test.dart`

**File:** `test/presentation/screens/stats/stats_screen_test.dart:40-47`

**Issue:** `setUpAll` registers `StatsInitial` but not `StatsLoading` as a
mocktail fallback value. `StatsLoading` is used as `initialState` in
`whenListen` at lines 99-101. While this currently works (mocktail only requires
`registerFallbackValue` for `any()` matchers, not for concrete values used in
`whenListen`), adding it alongside `StatsInitial` is consistent with the
registration style used across all other test files in this phase, and guards
against future use of `any()` matchers against state types.

**Fix:**
```dart
setUpAll(() {
  registerFallbackValue(const LoadMonthlyStats(year: 2025));
  registerFallbackValue(const StatsInitial());
  registerFallbackValue(const StatsLoading()); // add this
  registerFallbackValue(const LoadSettingsRequested());
  registerFallbackValue(const SettingsInitial());
});
```

### IN-02: `GetIt.instance.reset()` in `stats_screen_test.dart` tearDown is a no-op

**File:** `test/presentation/screens/stats/stats_screen_test.dart:69`

**Issue:** The file comment at lines 21-23 explicitly states that `StatsScreen`
is a `StatelessWidget` with no `sl<>` calls, so nothing is registered in GetIt
inside `setUp`. The `tearDown(() async => GetIt.instance.reset())` therefore
resets an always-empty container. While harmless, it is misleading: it creates
the impression that cleanup is needed, and it silently masks the actual reason
`GetIt` is imported (the import at line 5 has no functional purpose in this
file). Remove the import and tearDown, or add an explanatory comment explaining
the reset is kept as a defensive pattern for future additions.

**Fix:**
```dart
// Option A — remove both (simplest):
// Remove: import 'package:get_it/get_it.dart';
// Remove: tearDown(() async => GetIt.instance.reset());

// Option B — add a comment if defensive pattern is intentional:
// tearDown kept as safety net in case sl<> calls are added to sub-widgets.
tearDown(() async => GetIt.instance.reset());
```

---

_Reviewed: 2026-06-21_
_Reviewer: Claude (gsd-code-reviewer)_
_Depth: standard_
