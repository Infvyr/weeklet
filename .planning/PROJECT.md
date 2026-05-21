# Weeklet

## What This Is

Weeklet is a Flutter app for simple personal finance management. Users track weekly expenses by category, record income, and view annual statistics. The app is local-first with no cloud dependency, targeting Romanian and Russian-speaking users who want financial control without complexity.

## Core Value

Users can always see where their money went — fast entry, accurate totals, no friction.

## Current Milestone: v1.2 Testing

**Goal:** Establish comprehensive test infrastructure covering use cases, BLoCs, and widgets with complete feature coverage.

**Target areas:**
- Use Case unit tests (validation, error handling, edge cases)
- BLoC tests (state transitions, event handling)
- Widget tests (component rendering, interaction)
- Full coverage: Expenses, Income, Categories, Stats, Settings, PDF Export, Localization

## Current State

**v1.1 UX Polish shipped 2026-05-03.** All 9 phases complete across 2 milestones. The app is feature-complete for its initial public release scope — full CRUD for expenses/income/categories, PDF export, statistics, settings (biometric, theme, language, currency), and complete EN/RO/RU localization with runtime language switching and EN fallback for unsupported locales.

### What Ships in v1.1

- Everything from v1.0, plus:
- Centered empty state on expenses screen
- PDF export hidden when list is empty (expenses + income)
- Categories moved to expenses AppBar icon; removed from bottom navigation
- Annual evolution amounts compact-formatted and single-row in stats
- Scrollbars on all scrollable screens
- Full EN/RO/RU localization — 145 ARB keys × 3 locales, runtime language switching, EN fallback for all other locales

### Architecture (v1.1 Baseline)

- Flutter 3.41.1 (pinned via FVM), Dart ^3.11.0
- Clean Architecture: BLoC + GetIt DI + Hive local storage
- Typed domain exceptions — `ExpenseValidationException`, `IncomeValidationException`, `CategoryValidationException` with enum codes; no English strings in domain layer
- `AppLocalizations` in presentation layer only; BLoCs emit string error codes, widgets translate via switch
- `LocaleManager.supportedLocales` = [en, ro, ru]; bare `Locale` objects (no country codes)
- `localeResolutionCallback` returns `Locale('en')` for unsupported locales
- 16,789 LOC (Dart)

---

## Requirements

### Validated

- ✓ **ARCH-01** — Use cases validate inputs and throw on failure — v1.0
- ✓ **ARCH-02** — UUID generation in use cases, not BLoCs — v1.0
- ✓ **ARCH-03** — StatsBloc preloaded at startup via AppInitializer — v1.0
- ✓ **ARCH-04** — Locale-aware month abbreviations via intl — v1.0
- ✓ **INC-01–04** — Income CRUD, weekly grouping, stats sync — v1.0
- ✓ **STATS-01–03** — Monthly/annual breakdowns, chart refresh on CRUD — v1.0
- ✓ **SET-01–05** — Biometric auth, theme, language, currency, data reset — v1.0
- ✓ **EXP-01–02** — PDF export for expenses and income — v1.0
- ✓ **REL-01–04** — Branded icon, splash screen, branded colors — v1.0
- ✓ **UX-01** — Centered empty state on expenses list — v1.1
- ✓ **UX-02** — PDF export hidden when list is empty — v1.1
- ✓ **UX-03** — Categories via AppBar icon; removed from bottom nav — v1.1
- ✓ **UX-04** — Annual evolution amounts fit on one line — v1.1
- ✓ **UX-05** — Scrollbar on all scrollable screens — v1.1
- ✓ **LOC-01** — Full EN/RO/RU localization, EN fallback for unsupported locales — v1.1

### Active

- **TEST-01–04** — Use case unit tests for validation, error handling, and edge cases
- **TEST-05–08** — BLoC state transition and event handler tests
- **TEST-09–12** — Widget component and interaction tests
- **TEST-13–15** — Integration tests for critical user flows

### Deferred

- **QUAL-01/02** — Unit + BLoC tests (use-case stubs exist; no BLoC tests shipped)
- **BUDG-01/02** — Monthly spending limits per category
- **AUTO-01** — Recurring transactions
- **EXP-03/04** — CSV export (expense + income)

---

## Constraints

- **Tech stack:** Flutter 3.41.1 (pinned via FVM); Dart ^3.11.0; no Flutter upgrades until next milestone
- **Architecture:** Clean Architecture with BLoC must be maintained; layer separation is non-negotiable
- **Storage:** Hive only; no SQLite migration, no network calls
- **Platform:** iOS and Android primary; macOS/Linux/Windows folders present but not target platforms

## Key Decisions

| Decision | Rationale | Outcome |
|----------|-----------|---------|
| Local-first with Hive | Simplicity — no backend, no auth, no sync | ✓ Validated v1.0 |
| BLoC for all state management | Established pattern, enforced by CLAUDE.md | ✓ Validated v1.0 |
| Romanian + Russian + system locale | Core user base; `intl` already a dependency | ✓ Validated v1.1 |
| `AppConstants.DEFAULT_CURRENCY` | Single source of truth for currency symbol | ✓ Validated v1.0 |
| `StatsBloc` preloaded in `AppInitializer` | Instant stats — no spinner on navigation | ✓ Validated v1.0 |
| Settings screen modeled on screenshot | User provided exact reference design | ✓ Validated v1.0 |
| Typed domain exceptions with enum codes | BLoCs emit codes, widgets translate — no English in domain | ✓ Validated v1.1 |
| Bare `Locale` objects (no country codes) | Matches `LocaleManager.supportedLocales`; avoids `Locale.==` mismatch | ✓ Validated v1.1 |
| `currencySymbol` passed to `AmountFieldView` | Required param prevents stale default; forces explicit passing | ✓ Validated v1.1 |
| `deletionDialog` button labels required (not defaulted) | Callers must pass l10n strings; no hardcoded English defaults | ✓ Validated v1.1 |

## Out of Scope

- Cloud sync / backend — local-first is a core product constraint
- Web target — iOS and Android only
- Multi-currency — single currency per user; display setting only
- Onboarding flow — personal-use app; revisit if user acquisition becomes a goal
- Empty state centering for income/categories screens — expenses only per UX-01

---

## Evolution

This document evolves at phase transitions and milestone boundaries.

**After each phase:** Move requirements, log decisions, check "What This Is" accuracy.
**After each milestone:** Full review — core value check, Out of Scope audit, context update.

---
*Last updated: 2026-05-21 — v1.2 Testing milestone started*
