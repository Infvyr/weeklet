# Milestones

## v1.1 UX Polish (Shipped: 2026-05-03)

**Phases completed:** 9 phases, 33 plans, 47 tasks

**Key accomplishments:**

- Four failing RED test files covering use case validation (ARCH-01), UUID generation (ARCH-02), locale-aware month abbreviations (ARCH-04), and MDL currency constant (REL-03)
- Amount validation (string parse + <= 0 check) and UUID generation moved from BLoCs into AddExpenseUseCase, AddIncomeUseCase, and AddCategoryUseCase via new Params value objects
- One-liner:
- StatsBloc preloaded at startup via AppInitializer, chart month labels made locale-aware via DateFormat('MMM', locale), and dead GetExpensesByMonthYearUseCase deleted from disk and DI
- Romanian strings eliminated from income screen and StatsBloc dispatched after all three CRUD operations to keep statistics totals accurate
- All four INC requirements verified in running app — English strings visible, weekly grouping correct, CRUD with auto-close, stats screen syncs after income mutations
- Task 1 — Repository + use case pipeline fix (TDD):
- Dynamic 'Annual'/'Monthly' card labels wired via isAnnual flag; all hardcoded 'RON'/'lei' replaced with NumberFormatter; Romanian strings replaced with English across 9 stats files
- 1. [Rule 1 - Bug] Fixed test mocks missing clearAll() after interface extension
- SettingsBloc with 7 event handlers, BiometricService (local_auth 3.0.1 LocalAuthException API), MaterialApp driven by live BLoC state, and AppLifecycleListener biometric gate overlay
- SettingsScreen
- Failing test stubs for ExportExpensesUseCase (4 cases) and ExportIncomeUseCase (3 cases) — both RED via compile error because implementation files do not yet exist
- Both export use cases implement full PDF generation per UI-SPEC (header, summary row, data table, totals) via dart-pdf; ExportBloc wired into DI and app.dart; all 7 Wave 0 tests GREEN
- Both ExpensesScreen and IncomeScreen have functional PDF export icon buttons, BlocListeners for share sheet / error handling, and null-month guards — completing EXP-01 and EXP-02
- PathNotFoundException on macOS
- Branded launcher icons and native splash screens generated for iOS and Android using #1447E6 brand blue, with adaptive icon support (API 26+) and Android 12 windowSplashScreen compliance (API 31+)
- Branded icon and brand-blue (#1447E6) splash screen confirmed on Android emulator (API 33) — no white flash observed, no Dart changes required
- One-liner:
- Unconditional getEvolutionStatsUseCase call replacing year-equality guard in StatsBloc, so annual bar chart always reflects latest data after same-year CRUD operations
- Result: PASS
- Failing unit tests establishing formatCompact contract: K notation for amounts >= 1000, delegation to formatCurrency for amounts < 1000
- Utility additions completing TDD GREEN step and global scrollbar injection.
- 4-tab navigation and 4 targeted ExpensesScreen improvements.
- Income PDF conditional hide, sheet scroll opt-out, compact stat formatting.
- All remaining 6 modal bottom sheet builders wrapped with ScrollConfiguration.
- All 5 UX requirements verified by developer. Two gap fixes applied during visual inspection.
- RED test contracts locking typed exception API (ExpenseValidationException, IncomeValidationException) and LOC-01 supportedLocales invariants before Wave 1 implementation
- gen-l10n infrastructure with l10n.yaml, three ARB files (144 keys, EN/RO/RU), trimmed LocaleManager.supportedLocales to [en, ro, ru], and MaterialApp wired with AppLocalizations.delegate + localeResolutionCallback English fallback
- Three pure-Dart domain exception classes with enum error codes + full use-case and BLoC refactor to eliminate English error strings from the domain layer
- String extraction for Expenses, Categories, Settings, and Common widget trees: every hardcoded English literal replaced with AppLocalizations lookups; AmountFieldView refactored to accept currencySymbol; expense and category BLoC error codes translated via switch statements
- Complete localization of income, stats, navigation, and biometric gate widget trees — all hardcoded English strings replaced with AppLocalizations lookups; both income AmountFieldView callsites pass currencySymbol; income action-error switch translates BLoC codes to localized snackbars
- Result: PASS

---
