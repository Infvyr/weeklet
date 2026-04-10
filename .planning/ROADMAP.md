# Roadmap: Weeklet

## Overview

Weeklet is a working personal finance app with expenses and categories already shipped. This milestone completes the remaining features (income, statistics, settings, export) and polishes the app for public release on App Store and Google Play. Architecture cleanup comes first to fix layer violations and centralize currency display, then the two WIP screens are finished in dependency order, followed by the new settings screen, PDF export, and final release assets.

## Phases

**Phase Numbering:**
- Integer phases (1, 2, 3): Planned milestone work
- Decimal phases (2.1, 2.2): Urgent insertions (marked with INSERTED)

Decimal phases appear between their surrounding integers in numeric order.

- [x] **Phase 1: Architecture Cleanup** - Fix layer violations, centralize currency, preload stats (completed 2026-04-04)
- [ ] **Phase 2: Income Screen** - Complete the WIP income screen with modern UI and correct data flow
- [ ] **Phase 3: Statistics Screen** - Finish statistics modernization with correct totals and annual overview
- [ ] **Phase 4: Settings Screen** - Build the full settings experience (biometrics, theme, data, legal, language)
- [ ] **Phase 5: Data Export** - PDF export for expense and income records
- [ ] **Phase 6: Release Polish** - App icon, splash screen, final pre-release quality pass

## Phase Details

### Phase 1: Architecture Cleanup
**Goal**: The codebase follows Clean Architecture rules -- business logic lives in use cases, not BLoCs; currency display reads from a single source; stats preload on app startup
**Depends on**: Nothing (first phase)
**Requirements**: ARCH-01, ARCH-02, ARCH-03, ARCH-04, REL-03
**Success Criteria** (what must be TRUE):
  1. Adding an expense or income with an invalid amount is rejected by the use case layer, not the BLoC -- BLoCs pass raw form strings through without parsing
  2. Entity IDs are generated inside use cases -- BLoC constructors no longer depend on Uuid
  3. Navigating to the statistics screen shows data immediately (no spinner) because StatsBloc is preloaded in AppInitializer
  4. Chart month abbreviations display in the correct language when the app locale is Romanian or Russian
  5. Every screen in the app shows the same currency symbol, read from a single centralized source -- no hardcoded MDL/lei/RON in widget files
**Plans**: 4 plans

Plans:
- [x] 01-01-PLAN.md — Test scaffolding (Wave 0): create test/ directory and 4 failing test files covering ARCH-01, ARCH-02, ARCH-04, REL-03
- [x] 01-02-PLAN.md — Use case refactoring (Wave 1): move validation + UUID generation from BLoCs into AddExpenseUseCase, AddIncomeUseCase, AddCategoryUseCase; update DI
- [x] 01-03-PLAN.md — Currency centralization (Wave 1): create AppConstants.DEFAULT_CURRENCY, update 14 widget files to reference it
- [x] 01-04-PLAN.md — Stats preload + locale months + dead code (Wave 2): AppInitializer preloads StatsBloc, locale-aware month abbreviations, delete GetExpensesByMonthYearUseCase

### Phase 2: Income Screen
**Goal**: Users can fully manage income entries with a polished, consistent UI that matches the expense screen
**Depends on**: Phase 1
**Requirements**: INC-01, INC-02, INC-03, INC-04
**Success Criteria** (what must be TRUE):
  1. Income list displays entries grouped by week within the selected month, matching the expense screen grouping pattern
  2. Income screen visual style (cards, typography, spacing, icons) is consistent with the modernized expense screen
  3. User can add, edit, and delete an income entry and return to the list without stale or missing data
  4. Income totals entered on the income screen are accurately reflected on the statistics screen
**Plans**: 2 plans

Plans:
- [ ] 02-01-PLAN.md — String fixes + StatsBloc sync (Wave 1): replace Romanian strings with English, add LoadMonthlyStats dispatch to 3 IncomeBloc CRUD handlers
- [ ] 02-02-PLAN.md — Human verification checkpoint (Wave 2): verify INC-01 through INC-04 in running app

### Phase 3: Statistics Screen
**Goal**: Users can view accurate, complete financial statistics with a modern UI -- monthly summaries and annual category breakdowns
**Depends on**: Phase 2
**Requirements**: STAT-01, STAT-02, STAT-03, STAT-04
**Success Criteria** (what must be TRUE):
  1. Statistics screen shows no WIP artifacts -- all sections are complete and visually polished
  2. Monthly expense and income totals displayed on the statistics screen match the sum of entries visible on their respective list screens
  3. Annual overview shows a full 12-month expense and income breakdown by category for the selected year
  4. Statistics screen loads without redundant Hive reads -- getEvolutionStats fetches incomes and categories once, not per-iteration
**Plans**: TBD
**UI hint**: yes

### Phase 4: Settings Screen
**Goal**: Users can configure app behavior -- security, appearance, data management, legal info, and language -- from a dedicated settings screen
**Depends on**: Phase 1
**Requirements**: SET-01, SET-02, SET-03, SET-04, SET-05, SET-06, SET-07, SET-08
**Success Criteria** (what must be TRUE):
  1. User can toggle biometric authentication on or off, and when enabled, Face ID or Touch ID is required to open the app
  2. User can switch between Light, Dark, and System theme and the change applies immediately without restarting
  3. User can clear cache (with confirmation) and reset all data (with destructive confirmation dialog) from the settings screen
  4. User can view privacy policy, terms and conditions, and the current app version number from the settings screen
  5. User can change the display language to Romanian, Russian, or System default, and the change applies across all screens
**Plans**: TBD
**UI hint**: yes

### Phase 5: Data Export
**Goal**: Users can generate and share formatted PDF reports of their financial data
**Depends on**: Phase 2, Phase 3
**Requirements**: EXP-01, EXP-02
**Success Criteria** (what must be TRUE):
  1. User can export expense records as a formatted PDF that opens correctly in a standard PDF viewer
  2. User can export income records as a formatted PDF that opens correctly in a standard PDF viewer
  3. Exported PDFs contain accurate totals that match the amounts displayed in the app
**Plans**: TBD

### Phase 6: Release Polish
**Goal**: The app has professional launch assets and is ready for App Store and Google Play submission
**Depends on**: Phase 1, Phase 2, Phase 3, Phase 4, Phase 5
**Requirements**: REL-01, REL-02
**Success Criteria** (what must be TRUE):
  1. App launcher icon displays correctly on both iOS and Android home screens -- no default Flutter icon visible
  2. Native splash screen displays on cold launch for both iOS and Android -- no blank white screen before app renders
**Plans**: TBD

## Progress

**Execution Order:**
Phases execute in numeric order: 1 → 2 → 3 → 4 → 5 → 6
Note: Phase 4 (Settings) depends only on Phase 1, so it could theoretically run in parallel with Phases 2-3. Sequential ordering is recommended for solo execution.

| Phase | Plans Complete | Status | Completed |
|-------|----------------|--------|-----------|
| 1. Architecture Cleanup | 4/4 | Complete   | 2026-04-04 |
| 2. Income Screen | 0/2 | Not started | - |
| 3. Statistics Screen | 0/? | Not started | - |
| 4. Settings Screen | 0/? | Not started | - |
| 5. Data Export | 0/? | Not started | - |
| 6. Release Polish | 0/? | Not started | - |
