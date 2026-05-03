---
phase: 09-localization
reviewed: 2026-05-03T00:00:00Z
depth: standard
files_reviewed: 30
files_reviewed_list:
  - lib/app.dart
  - lib/core/utils/locale_manager.dart
  - lib/domain/exceptions/category_exceptions.dart
  - lib/domain/exceptions/expense_exceptions.dart
  - lib/domain/exceptions/income_exceptions.dart
  - lib/domain/usecases/category/add_category_usecase.dart
  - lib/domain/usecases/expense/add_expense_usecase.dart
  - lib/domain/usecases/income/add_income_use_case.dart
  - lib/presentation/app_initializer.dart
  - lib/presentation/blocs/category/category_bloc.dart
  - lib/presentation/blocs/expense/expense_bloc.dart
  - lib/presentation/blocs/income/income_bloc.dart
  - lib/presentation/blocs/settings/settings_bloc.dart
  - lib/presentation/blocs/settings/settings_event.dart
  - lib/presentation/navigation/main_navigation.dart
  - lib/presentation/screens/categories/add_category_screen.dart
  - lib/presentation/screens/categories/categories_screen.dart
  - lib/presentation/screens/expenses/expenses_screen.dart
  - lib/presentation/screens/income/income_screen.dart
  - lib/presentation/screens/settings/settings_screen.dart
  - lib/presentation/screens/settings/widgets/language_selection_sheet.dart
  - lib/presentation/screens/settings/widgets/theme_selection_sheet.dart
  - lib/presentation/screens/settings/widgets/currency_selection_sheet.dart
  - lib/presentation/screens/stats/stats_screen.dart
  - lib/presentation/widgets/common/form/amount_field_view.dart
  - lib/presentation/widgets/common/deletion_dialog/deletion_dialog.dart
  - lib/l10n/app_en.arb
  - lib/l10n/app_ro.arb
  - lib/l10n/app_ru.arb
  - test/core/utils/locale_manager_test.dart
  - test/domain/usecases/expense/add_expense_usecase_test.dart
  - test/domain/usecases/income/add_income_use_case_test.dart
findings:
  critical: 2
  warning: 5
  info: 4
  total: 11
status: issues_found
---

# Phase 09: Code Review Report

**Reviewed:** 2026-05-03
**Depth:** standard
**Files Reviewed:** 30
**Status:** issues_found

## Summary

This phase delivered localization infrastructure (ARB files for en/ro/ru, `AppLocalizations` integration, `LocaleManager` singleton, typed exception enums, and `SettingsBloc` locale/theme/currency persistence). The core design is sound — the domain layer stays Flutter-free, BLoCs translate enum names to localized strings in widgets, and `LocaleManager` correctly seeds `Intl.defaultLocale`. However, two behavioral bugs were found that will cause incorrect runtime behavior: a locale comparison mismatch that breaks the active-language highlight in the language picker, and a hardcoded English error string in the biometric-disable path that bypasses the localization system. Five warnings cover missing validation, swallowed errors, and unguarded unawaited futures.

---

## Critical Issues

### CR-01: Language selection sheet uses country-coded `Locale` objects but persisted locales have no country code — active selection never highlights

**File:** `lib/presentation/screens/settings/widgets/language_selection_sheet.dart:28-30`

**Issue:** The `options` list constructs locales with country codes — `Locale('en', 'US')`, `Locale('ro', 'RO')`, `Locale('ru', 'RU')` — then compares them with `groupValue: currentLocale` (the persisted value from `SettingsBloc`). The persisted locale is saved and restored as a bare language locale (`Locale('en')`, `Locale('ro')`, `Locale('ru')`) because `LocaleManager.supportedLocales` contains no country codes and `SaveLocaleUseCase`/`GetSettingsUseCase` round-trip the locale as stored. `Locale('en') != Locale('en', 'US')` in Dart's `Locale.==`, so no radio button is ever selected after the initial "System default" — every explicit language selection appears unselected the next time the sheet opens, making the current language invisible to the user.

**Fix:**
```dart
final options = [
  (label: l10n.languageSystemDefault, locale: null),
  (label: l10n.languageEnglish, locale: const Locale('en')),
  (label: l10n.languageRomanian, locale: const Locale('ro')),
  (label: l10n.languageRussian, locale: const Locale('ru')),
];
```
Match the bare-language form used everywhere else in the system.

---

### CR-02: Hardcoded English error string in `SettingsBloc._onBiometricToggled` bypasses localization

**File:** `lib/presentation/blocs/settings/settings_bloc.dart:174`

**Issue:** When biometric authentication fails during the enable flow, the bloc emits:
```dart
emit(st.copyWith(
  settings: st.settings.copyWith(biometricEnabled: false),
  actionError: 'Biometric authentication could not be verified.',
));
```
This is a literal English sentence placed directly into `actionError`, which is then displayed verbatim in the settings screen snackbar via `context.showErrorSnackBar(state.actionError!)`. The ARB files define the key `errorBiometricFailed` for exactly this message across all three locales; it is never used here. Romanian and Russian users will see English in this error path.

The CLAUDE.md convention for `actionError` is to store a translation key (e.g., `'genericError'`), not a translated string, so that the widget layer can look it up via `AppLocalizations`. The BLoC must not contain Flutter/localization imports.

**Fix:**
```dart
// In settings_bloc.dart line ~174 — emit a key, not a sentence:
emit(st.copyWith(
  settings: st.settings.copyWith(biometricEnabled: false),
  actionError: 'errorBiometricFailed',
));
```
Then in `SettingsScreen`'s `BlocConsumer` listener, translate it:
```dart
listener: (context, state) {
  if (state is SettingsLoaded && state.actionError != null) {
    final msg = switch (state.actionError!) {
      'errorBiometricFailed' => l10n.errorBiometricFailed,
      _ => state.actionError!,
    };
    context.showErrorSnackBar(msg);
  }
},
```

---

## Warnings

### WR-01: `AddIncomeUseCase` does not validate empty description — silent acceptance diverges from `AddExpenseUseCase` and leaves stale ARB key

**File:** `lib/domain/usecases/income/add_income_use_case.dart:31-46`

**Issue:** `_buildAndValidate` validates `parsedAmount` but never checks `params.description.trim().isEmpty`. `AddExpenseUseCase` throws `ExpenseValidationError.emptyDescription` for the same condition. The income exception enum (`IncomeValidationError`) includes `emptyDescription`, the ARB files define `errorEmptyDescription` in all three locales, and the income BLoC's `_onAddIncome` would handle it correctly — but the use case never throws it. An income with an empty description is silently accepted and persisted.

**Fix:**
```dart
Income _buildAndValidate(AddIncomeParams params) {
  final parsedAmount = double.tryParse(params.amount);
  if (parsedAmount == null || parsedAmount <= 0) {
    throw const IncomeValidationException(IncomeValidationError.invalidAmount);
  }
  if (params.description.trim().isEmpty) {
    throw const IncomeValidationException(IncomeValidationError.emptyDescription);
  }
  // ...
}
```

---

### WR-02: `IncomeScreen` only maps `'invalidAmount'` in the `actionError` switch — all other income errors silently fall through to `errorGeneric`

**File:** `lib/presentation/screens/income/income_screen.dart:129-132`

**Issue:**
```dart
final message = switch (err) {
  'invalidAmount' => l10n.errorInvalidAmount,
  _ => l10n.errorGeneric,
};
```
The income BLoC can emit `'emptyDescription'` (once WR-01 is fixed) and `'emptyIncomeId'` via `IncomeValidationError.name`. Both are mapped in the ARB files (`errorEmptyDescription`) but the switch does not handle them. Compare with `ExpensesScreen` which correctly maps all three expense error codes. If income validation gains additional error types, they will all display the generic message.

**Fix:**
```dart
final message = switch (err) {
  'invalidAmount' => l10n.errorInvalidAmount,
  'emptyDescription' => l10n.errorEmptyDescription,
  _ => l10n.errorGeneric,
};
```

---

### WR-03: `CurrencySelectionSheet._options` labels are hardcoded English — not localized

**File:** `lib/presentation/screens/settings/widgets/currency_selection_sheet.dart:21-27`

**Issue:**
```dart
static const List<({String symbol, String label})> _options = [
  (symbol: 'MDL', label: 'Moldovan Leu (MDL)'),
  (symbol: 'RON', label: 'Romanian Leu (RON)'),
  // ...
];
```
The label strings `'Moldovan Leu (MDL)'`, `'Romanian Leu (RON)'`, etc., are English literals baked into a `static const` field. The ARB files define `currencyMDL`, `currencyRON`, `currencyEUR`, `currencyUSD`, `currencyRUB` — but those keys only contain the symbol abbreviation (e.g., `"MDL"`), not the full name. The sheet title and all option labels will read English to Romanian and Russian users. Either localize the full currency names in ARB files and look them up in `build()`, or (at minimum) do not bake English-only descriptive text into a const field.

**Fix:** Move `_options` to `build()` and construct from `l10n`:
```dart
@override
Widget build(BuildContext context) {
  final l10n = AppLocalizations.of(context);
  final options = [
    (symbol: 'MDL', label: l10n.currencyMDLLabel),
    // or use the symbol-only ARB keys and format locally:
    (symbol: 'MDL', label: 'MDL'),
    ...
  ];
  // ...
}
```
If full translated names are not required, remove the descriptive English portion entirely and show only the symbol code, which is already locale-neutral.

---

### WR-04: `SettingsBloc._onLoadSettings` emits hardcoded English string on failure

**File:** `lib/presentation/blocs/settings/settings_bloc.dart:71`

**Issue:**
```dart
emit(const SettingsFailure('Settings could not be loaded.'));
```
This is a literal English sentence. The ARB key `settingsLoadError` exists in all three locales for this exact message. `SettingsScreen` displays `l10n.settingsLoadError` in the failure branch — but only because it reads directly from `l10n`, ignoring the `SettingsFailure.message` field. The `SettingsFailure` message field is unused in the UI today, but if any other consumer ever reads it the user will see English. Emit a key for consistency:
```dart
emit(const SettingsFailure('settingsLoadError'));
```

---

### WR-05: `unawaited` share-plus calls in `ExpensesScreen` and `IncomeScreen` use `unawaited()` wrapper correctly, but nested `.then()` captures a stale `mounted` check

**File:** `lib/presentation/screens/expenses/expenses_screen.dart:143-157`, `lib/presentation/screens/income/income_screen.dart:145-158`

**Issue:** The pattern:
```dart
unawaited(
  SharePlus.instance.share(...).then((_) {
    if (!mounted) return;
    exportBloc.add(const ResetExportRequested());
  }),
);
```
`mounted` inside `.then()` is evaluated at callback time (after the share sheet closes), which is correct. However, `exportBloc` is captured from `context.read<ExportBloc>()` executed before the async gap in the `BlocListener`. If the widget is disposed between the share sheet opening and closing, `exportBloc` still holds a reference to the closed BLoC — calling `add()` on a closed BLoC throws a `StateError` in flutter_bloc. The `if (!mounted) return` guard prevents `context.read` after dispose, but `exportBloc` was already captured before that check.

**Fix:** Check `mounted` before calling `add`:
```dart
unawaited(
  SharePlus.instance.share(...).then((_) {
    if (!mounted) return;
    context.read<ExportBloc>().add(const ResetExportRequested());
  }),
);
```
(Remove the pre-captured `exportBloc` local; read from context only after confirming `mounted`.)

---

## Info

### IN-01: `LocaleManager` `_currentLocale` is `late` — accessing `currentLocale` before `initialize()` throws a `LateInitializationError`

**File:** `lib/core/utils/locale_manager.dart:27`

**Issue:** `_currentLocale` is declared `late Locale _currentLocale`. In production, `main()` calls `LocaleManager().initialize(deviceLocale)` before `runApp`, so this is safe. However, in unit tests that construct classes depending on `LocaleManager().currentLocale` or `currentLocaleString` without calling `initialize()` first, a `LateInitializationError` is thrown with no useful message. The test file `locale_manager_test.dart` only tests `supportedLocales` (a static const) and avoids calling instance methods, so it does not exercise this path — but future tests could silently break.

Consider providing a default: `Locale _currentLocale = const Locale('en');`

---

### IN-02: `AddCategoryScreen` uses `unawaited` `Future.delayed` for navigation-after-success without a lint suppression

**File:** `lib/presentation/screens/categories/add_category_screen.dart:76-83`

**Issue:**
```dart
Future.delayed(
  const Duration(seconds: 2),
  () {
    if (context.mounted) context.pop();
  },
);
```
`Future.delayed(...)` returns a `Future<void>` that is not awaited. The `unawaited_futures` lint is enabled in this project (`unawaited_futures: true`). This will trigger a lint warning at analysis time. Wrap with `unawaited(...)` from `dart:async` or add `// ignore: unawaited_futures` with a reason.

---

### IN-03: `CategoriesScreen` error handler does not map `'emptyIcon'` or `'genericError'` codes emitted by `CategoryBloc`

**File:** `lib/presentation/screens/categories/categories_screen.dart:51-55`

**Issue:**
```dart
final msg = switch (state.message) {
  'emptyName' => l10n.categoryNameValidationRequired,
  'errorCategoryNotFound' => l10n.errorCategoryNotFound,
  _ => l10n.errorGeneric,
};
```
The wildcard catches `'emptyIcon'` and `'genericError'` and shows the generic message, which is acceptable. However, `'emptyIcon'` corresponds to a specific user-facing error (no icon selected) that could have a more helpful message. This is a UX gap, not a bug, but worth noting as ARB strings for icon validation do not currently exist.

---

### IN-04: `AddIncomeUseCase` constructor is `const` but `AddCategoryUseCase` constructor is not — inconsistency

**File:** `lib/domain/usecases/category/add_category_usecase.dart:20` vs `lib/domain/usecases/income/add_income_use_case.dart:19`

**Issue:** `AddExpenseUseCase` and `AddIncomeUseCase` both use `const` constructors, consistent with the use case pattern described in CLAUDE.md. `AddCategoryUseCase` does not:
```dart
// Missing const:
AddCategoryUseCase(this.repository, this.uuid);
```
This is inconsistent with the rest of the codebase and prevents `const` instantiation at call sites.

**Fix:**
```dart
const AddCategoryUseCase(this.repository, this.uuid);
```

---

_Reviewed: 2026-05-03_
_Reviewer: Claude (gsd-code-reviewer)_
_Depth: standard_
