# Weeklet

## What This Is

Weeklet is a Flutter app for simple personal finance management. Users track weekly expenses by category, record income, and view annual statistics. The app is local-first with no cloud dependency, targeting Romanian and Russian-speaking users who want financial control without complexity.

## Core Value

Users can always see where their money went — fast entry, accurate totals, no friction.

## Current State

**v1.1 milestone complete 2026-05-03.** Phase 9 (Localization) delivered LOC-01 — full English/Romanian/Russian support with runtime language switching. All 9 phases of v1.1 are complete.

### What Ships in v1.0

- Expense tracking — add, edit, delete; weekly grouping by category; monthly totals
- Category management — create, edit, delete with icon/color picker
- Income screen — full CRUD with weekly grouping, stats sync, UI matching expense screen
- Statistics screen — monthly and annual breakdowns; correct totals; chart refreshes on CRUD
- Settings screen — biometric auth, theme (light/dark/system), language (ro/ru/system), cache clear, full data reset, privacy policy, terms, app version
- PDF export — expense and income PDF generation via share sheet
- Branded launcher icon (#1447E6) and native splash screen — iOS and Android
- Currency reactive — user-selected symbol propagated from `SettingsBloc` to all screens and widgets
- Multi-language: Romanian, Russian, system default

### Architecture (v1.0 Baseline)

- Flutter 3.41.1 (pinned via FVM), Dart ^3.11.0
- Clean Architecture: BLoC + GetIt DI + Hive local storage
- Validation and UUID generation in use cases (not BLoCs)
- `AppConstants.DEFAULT_CURRENCY` — single source of truth for currency symbol
- `StatsBloc` preloaded in `AppInitializer` — instant stats on navigation
- Locale-aware month abbreviations via `intl`

---

## Current Milestone: v1.1 UX Polish

**Goal:** Fix six UX rough edges across the app — layout, navigation, readability, scrolling, and localization.

**Target features:**
- Centered empty state on expenses screen
- PDF export hidden when list is empty (expenses + income)
- Categories moved to expenses AppBar icon button; removed from bottom navigation
- Annual evolution amounts displayed in a single row (stats screen)
- Scrollbar on all scrollable screens
- Full RO/RU/EN localization; non-ro/ru/en system locale falls back to EN

### Active Requirements

- [ ] **UX-01**: User sees a centered empty state when the expenses list is empty
- [ ] **UX-02**: PDF export action is hidden when the expenses or income list is empty
- [ ] **UX-03**: Categories accessible via icon button in expenses AppBar; removed from bottom navigation
- [ ] **UX-04**: Annual evolution amount fits on a single row (stats screen)
- [ ] **UX-05**: Scrollbar visible on all scrollable screens
- [ ] **LOC-01**: All strings translated to RO, RU, and EN; system locales outside ro/ru/en fall back to EN

---

### Deferred (carry-forward from v1.0)

- **QUAL-01/02** — Unit + BLoC tests (test stubs exist; no implementation tests shipped)
- **BUDG-01/02** — Monthly spending limits per category
- **AUTO-01** — Recurring transactions
- **EXP-03/04** — CSV export (expense + income)

---

## Constraints

- **Tech stack:** Flutter 3.41.1 (pinned via FVM); Dart ^3.11.0
- **Architecture:** Clean Architecture with BLoC must be maintained; layer separation is non-negotiable
- **Storage:** Hive only; no SQLite migration, no network calls
- **Platform:** iOS and Android primary; macOS/Linux/Windows folders present but not target platforms

## Key Decisions

| Decision | Rationale | Outcome |
|----------|-----------|---------|
| Local-first with Hive | Simplicity — no backend infrastructure, no auth, no sync | Validated — shipped |
| BLoC for all state management | Established pattern, enforced by CLAUDE.md | Validated — shipped |
| Romanian + Russian + system locale | Core user base; `intl` already a dependency | Validated — shipped |
| `AppConstants.DEFAULT_CURRENCY` | Single source of truth; eliminates scattered string literals | Validated — Phase 1 |
| `StatsBloc` preloaded in `AppInitializer` | Instant stats screen — no spinner on navigation | Validated — Phase 1 |
| Settings screen modeled on screenshot | User provided exact reference design (dark, grouped sections, icons) | Validated — Phase 4 |

## Out of Scope

- Cloud sync / backend — local-first is a core product constraint; no network infrastructure planned
- Web target — only iOS and Android are primary targets
- Multi-currency — single currency per user; currency is a display setting, not multi-currency accounting
- Onboarding flow — not needed for personal-use launch; revisit if user acquisition becomes a goal

## Evolution

This document evolves at phase transitions and milestone boundaries.

**After each phase transition** (via `/gsd-next`):
1. Requirements invalidated? → Move to Out of Scope with reason
2. Requirements validated? → Move to Validated with phase reference
3. New requirements emerged? → Add to Active
4. Decisions to log? → Add to Key Decisions
5. "What This Is" still accurate? → Update if drifted

**After each milestone** (via `/gsd-complete-milestone`):
1. Full review of all sections
2. Core Value check — still the right priority?
3. Audit Out of Scope — reasons still valid?
4. Update Context with current state

---
*Last updated: 2026-04-29 — v1.1 milestone started*
