---
phase: 09-localization
plan: '04'
subsystem: presentation-widgets
tags: [localization, widgets, income, stats, navigation, biometric]

requires:
  - phase: 09-localization
    plan: '01'
    provides: Generated AppLocalizations class with 144+ keys
  - phase: 09-localization
    plan: '02'
    provides: IncomeBloc emitting string codes for actionError

provides:
  - Income screen fully localized (income_screen.dart, income_total_card.dart, income_filter_bar.dart, income_item_view.dart, income_list_view.dart)
  - Both income AmountFieldView callsites pass currencySymbol
  - Income action-error switch translating BLoC codes to l10n messages
  - Stats screen fully localized (stats_screen.dart, stats_empty_view.dart, stats_error_view.dart, stats_filter_bar.dart, stats_tabs_section.dart, monthly_expenses_list.dart, monthly_item.dart, stats_summary_cards.dart, stats_balance_card.dart, stats_small_card.dart)
  - Navigation tab labels localized in main_navigation.dart and main_screen.dart
  - AppInitializer biometric gate strings localized
  - SettingsBloc biometric reason delegated via BiometricToggled.reason field
  - AmountFieldView updated with currencySymbol param and l10n label
  - navIncome ARB key added to all three locales (en/ro/ru)

affects:
  - lib/presentation/screens/income/
  - lib/presentation/screens/stats/
  - lib/presentation/screens/main/main_screen.dart
  - lib/presentation/navigation/main_navigation.dart
  - lib/presentation/app_initializer.dart
  - lib/presentation/blocs/settings/settings_bloc.dart
  - lib/presentation/blocs/settings/settings_event.dart
  - lib/presentation/widgets/common/form/amount_field_view.dart
  - lib/l10n/app_en.arb
  - lib/l10n/app_ro.arb
  - lib/l10n/app_ru.arb

tech-stack:
  added: []
  patterns:
    - "Action-error switch: if (state case IncomeSuccess(actionError: final err?)) { switch (err) { 'invalidAmount' => l10n.errorInvalidAmount, _ => l10n.errorGeneric } }"
    - "Parameterized l10n: l10n.incomeTotalForMonth(monthName) for month-specific total; l10n.incomeTotalAllMonths otherwise"
    - "BiometricToggled.reason: optional String field with default '' — supplied by widget (AppLocalizations), used in BLoC handler"
    - "AmountFieldView.currencySymbol: optional param with default AppConstants.DEFAULT_CURRENCY"

key-files:
  modified:
    - lib/presentation/screens/income/income_screen.dart
    - lib/presentation/screens/income/widgets/add_income_form_view.dart
    - lib/presentation/screens/income/widgets/income_filter_bar.dart
    - lib/presentation/screens/income/widgets/income_total_card.dart
    - lib/presentation/screens/income/widgets/add/income_form_submit_view.dart
    - lib/presentation/screens/income/widgets/edit_income_form_view/edit_income_form_view.dart
    - lib/presentation/screens/income/widgets/edit_income_form_view/edit_income_form_footer.dart
    - lib/presentation/screens/income/widgets/list/income_item_view.dart
    - lib/presentation/screens/income/widgets/list/income_list_view.dart
    - lib/presentation/screens/stats/stats_screen.dart
    - lib/presentation/screens/stats/widgets/stats_empty_view.dart
    - lib/presentation/screens/stats/widgets/stats_error_view.dart
    - lib/presentation/screens/stats/widgets/stats_filter_bar.dart
    - lib/presentation/screens/stats/widgets/stats_tabs_section.dart
    - lib/presentation/screens/stats/widgets/monthly_expenses_list.dart
    - lib/presentation/screens/stats/widgets/monthly_item/monthly_item.dart
    - lib/presentation/screens/stats/widgets/stats_summary_cards/stats_summary_cards.dart
    - lib/presentation/screens/stats/widgets/stats_summary_cards/stats_balance_card.dart
    - lib/presentation/screens/stats/widgets/stats_summary_cards/stats_small_card.dart
    - lib/presentation/screens/main/main_screen.dart
    - lib/presentation/navigation/main_navigation.dart
    - lib/presentation/app_initializer.dart
    - lib/presentation/blocs/settings/settings_bloc.dart
    - lib/presentation/blocs/settings/settings_event.dart
    - lib/presentation/widgets/common/form/amount_field_view.dart
    - lib/l10n/app_en.arb
    - lib/l10n/app_ro.arb
    - lib/l10n/app_ru.arb

key-decisions:
  - "navIncome ARB key added (deviation Rule 2): main_navigation.dart has an Income tab label not covered by Plan 01's initial key set; added navIncome with idiomatic translations (EN: Income, RO: Venituri, RU: Доходы)"
  - "AmountFieldView currencySymbol: made optional with DEFAULT_CURRENCY default (not required) to maintain backward compatibility; Plan 03 marks it required — on merge Plan 03 wins"
  - "BiometricToggled.reason fallback sentinel: BLoC uses 'biometricVerifyReason' string when caller passes empty string — Pitfall 3 preserved (BLoC never imports AppLocalizations)"
  - "income_screen.dart BlocListener: added income action-error listener using ClearIncomeActionErrorRequested event (available from Plan 02)"

metrics:
  duration: 15min
  completed: '2026-05-03'
---

# Phase 09 Plan 04: Income Screen Localization Summary

**Complete localization of income, stats, navigation, and biometric gate widget trees — all hardcoded English strings replaced with AppLocalizations lookups; both income AmountFieldView callsites pass currencySymbol; income action-error switch translates BLoC codes to localized snackbars**

## Performance

- **Duration:** ~15 min
- **Started:** 2026-05-03T11:16:23Z
- **Completed:** 2026-05-03T11:31:27Z
- **Tasks:** 2
- **Files modified:** 28

## Accomplishments

### Task 1: Localize Income widget tree

- `income_screen.dart`: AppBar title, PDF export tooltip, add income tooltip, FAB label, failure state messages, retry button, PDF export error snackbar — all localized. Added BlocListener with income action-error switch (`invalidAmount` → `l10n.errorInvalidAmount`, fallback → `l10n.errorGeneric`), dispatching `ClearIncomeActionErrorRequested` after display.
- `income_total_card.dart`: Month-specific total uses `l10n.incomeTotalForMonth(monthName)` (parameterized); all-months total uses `l10n.incomeTotalAllMonths`.
- `income_filter_bar.dart`: Localized `allMonthsLabel`, `selectMonthHint`, `selectYearHint`.
- `add_income_form_view.dart`: Localized `addIncomeSheetTitle`; passes `currencySymbol` to `AmountFieldView`.
- `edit_income_form_view.dart`: Localized `editIncomeSheetTitle`; passes `currencySymbol` to `AmountFieldView`.
- `edit_income_form_footer.dart`: Localized `cancelButtonLabel` and `saveIncomeButtonLabel`.
- `income_form_submit_view.dart`: Localized `saveIncomeButtonLabel`.
- `income_item_view.dart`: Localized edit/delete menu labels and all deletion dialog strings (`deleteIncomeDialogTitle`, `deleteConfirmSubtitle1`, `actionCannotBeUndone`, `deleteIncomeFallbackName`, `deleteButtonLabel`, `cancelButtonLabel`).
- `income_list_view.dart`: Localized empty state `incomeEmptyTitle` / `incomeEmptySubtitle`.
- `amount_field_view.dart`: Added optional `currencySymbol` param; label uses `l10n.amountFieldLabel(currencySymbol)`.

### Task 2: Localize Stats + Navigation + AppInitializer + SettingsBloc

- `stats_screen.dart`: Localized AppBar title.
- `stats_empty_view.dart`: Localized `statsEmptyTitle` / `statsEmptySubtitle`.
- `stats_error_view.dart`: Localized `statsErrorTitle` and `tryAgainButtonLabel`.
- `stats_filter_bar.dart`: Localized `allMonthsLabel`, `selectMonthHint`, `selectYearHint`.
- `stats_tabs_section.dart`: Localized `statsTabMonthly` and `statsTabAnnualEvolution`.
- `monthly_expenses_list.dart`: Localized `statsMonthlyBreakdownTitle`.
- `monthly_item.dart`: Localized `incomeBarLabel` and `expensesBarLabel`.
- `stats_summary_cards.dart`: Localized annual/monthly income and expenses card titles.
- `stats_balance_card.dart`: Localized `statsAnnualBalance` / `statsMonthlyBalance` / `statsRealizedSavings`.
- `stats_small_card.dart`: Localized percentage comparison phrase (`statsVsLastMonth` / `statsVsLastYear`).
- `main_navigation.dart`: Localized all 4 tab labels (`navHome`, `navIncome`, `navStats`, `navSettings`).
- `main_screen.dart`: Localized 3 tab labels (`navExpenses`, `navStats`, `navSettings`).
- `app_initializer.dart`: Localized biometric gate title, subtitle, auth reason, and try-again button.
- `settings_event.dart`: Added `reason` field to `BiometricToggled` with default empty string.
- `settings_bloc.dart`: Uses `event.reason` for biometric auth; falls back to sentinel `'biometricVerifyReason'` if empty — BLoC never imports AppLocalizations.
- `app_en/ro/ru.arb`: Added `navIncome` key (Income / Venituri / Доходы).

## Task Commits

1. **Task 1: Localize income screen widget tree** - `dfe33e4` (feat)
2. **Task 2: Localize stats, navigation, app initializer, and settings biometric** - `e9c9499` (feat)

## Files Modified

**Income (Task 1):** income_screen.dart, add_income_form_view.dart, income_filter_bar.dart, income_total_card.dart, income_form_submit_view.dart, edit_income_form_view.dart, edit_income_form_footer.dart, income_item_view.dart, income_list_view.dart

**Shared form widget (Task 2 scope):** amount_field_view.dart — added `currencySymbol` optional param

**Stats (Task 2):** stats_screen.dart, stats_empty_view.dart, stats_error_view.dart, stats_filter_bar.dart, stats_tabs_section.dart, monthly_expenses_list.dart, monthly_item.dart, stats_summary_cards.dart, stats_balance_card.dart, stats_small_card.dart

**Navigation + AppInit (Task 2):** main_screen.dart, main_navigation.dart, app_initializer.dart

**Settings BLoC (Task 2):** settings_bloc.dart, settings_event.dart

**ARB files (Task 2):** app_en.arb, app_ro.arb, app_ru.arb

## Decisions Made

- `navIncome` ARB key added: Plan 01 did not include this key; `main_navigation.dart` has an Income tab label. Added with EN/RO/RU translations.
- `AmountFieldView.currencySymbol` made optional (default `DEFAULT_CURRENCY`) for this worktree to avoid breaking callers. Plan 03 may make it required — on merge Plan 03 version takes precedence.
- `BiometricToggled.reason` sentinel fallback: When caller passes empty string, BLoC uses `'biometricVerifyReason'` as the native auth dialog reason string. This is documented as imperfect but acceptable until Plan 05 convergence.

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 2 - Missing Critical Functionality] Added navIncome ARB key**
- **Found during:** Task 2
- **Issue:** `main_navigation.dart` has an "Income" tab label but Plan 01 did not define a `navIncome` ARB key; only `navExpenses`, `navStats`, `navSettings`, `navHome` were defined.
- **Fix:** Added `navIncome` with EN ("Income"), RO ("Venituri"), RU ("Доходы") to all three ARB files and regenerated AppLocalizations.
- **Files modified:** lib/l10n/app_en.arb, lib/l10n/app_ro.arb, lib/l10n/app_ru.arb
- **Commit:** `e9c9499`

**2. [Rule 2 - Missing Critical Functionality] Added currencySymbol to AmountFieldView**
- **Found during:** Task 1
- **Issue:** Income form callsites need to pass `currencySymbol` to `AmountFieldView`, but Plan 03 (running in parallel) owns `AmountFieldView`. The current worktree had the original version without this param.
- **Fix:** Updated `amount_field_view.dart` to add optional `currencySymbol` param with default `AppConstants.DEFAULT_CURRENCY`, using `l10n.amountFieldLabel(currencySymbol)` for the label.
- **Files modified:** lib/presentation/widgets/common/form/amount_field_view.dart
- **Commit:** `e9c9499`

## Known Stubs

None — all localization keys use real translations from Plan 01 ARB files. No placeholder text remains in the modified widget tree.

## Threat Flags

- **T-09-04-01 mitigated:** Income action-error switch default branch falls through to `l10n.errorGeneric` for any unknown error code.
- **T-09-04-03 mitigated:** `BiometricToggled.reason` is a non-empty UX phrase from AppLocalizations; no auth state derived from its content; BLoC only passes it to OS native dialog.

## Self-Check: PASSED

- FOUND: lib/presentation/screens/income/income_screen.dart (modified)
- FOUND: lib/presentation/screens/income/widgets/income_total_card.dart (modified)
- FOUND: lib/presentation/screens/stats/stats_screen.dart (modified)
- FOUND: lib/presentation/navigation/main_navigation.dart (modified)
- FOUND: lib/presentation/app_initializer.dart (modified)
- FOUND: lib/l10n/app_en.arb (navIncome added)
- FOUND commit: dfe33e4 (Task 1)
- FOUND commit: e9c9499 (Task 2)

---
*Phase: 09-localization*
*Completed: 2026-05-03*
