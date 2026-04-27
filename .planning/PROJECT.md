# Weeklet

## What This Is

Weeklet is a Flutter app for simple personal finance management. Users track weekly expenses by category, record income, and view annual statistics. The app is local-first with no cloud dependency, targeting Romanian and Russian-speaking users who want financial control without complexity.

## Core Value

Users can always see where their money went — fast entry, accurate totals, no friction.

## Requirements

### Validated

- ✓ Expense tracking — add, edit, delete; weekly grouping by category; monthly totals — existing
- ✓ Category management — create, edit, delete with icon/color picker — existing
- ✓ Multi-language support — Romanian (ro), Russian (ru), system locale as default — existing
- ✓ Material 3 design with automatic light/dark theme — existing
- ✓ Local-first storage via Hive — no network/cloud dependency — existing
- ✓ Clean Architecture: BLoC + GetIt DI + Hive — established pattern — existing
- ✓ Validation and UUID generation in use cases (not BLoCs) — ARCH-01, ARCH-02 — validated in Phase 01
- ✓ Currency consistency — AppConstants.DEFAULT_CURRENCY = 'MDL'; zero scattered literals — REL-03 — validated in Phase 01, reactive propagation closed in Phase 07
- ✓ StatsBloc preloaded in AppInitializer; locale-aware month abbreviations — ARCH-03, ARCH-04 — validated in Phase 01

### Active

- [ ] Income screen modernization — component refresh and data sync fixes
- [ ] Statistics screen completion — UI modernization, correct data display, annual category overview
- [ ] Settings screen full design — biometric auth (Face/Touch ID), theme switching (light/dark/system), data management (clear cache, clear all data), legal (privacy policy, terms), localization (language), about (app version)
- [ ] Data export — expenses and income as CSV and PDF
- ✓ App icon & splash screen — branded #1447E6 icon + native splash on iOS/Android — REL-01, REL-02 — validated in Phase 06

### Out of Scope

- Cloud sync / backend — local-first is a core product constraint; no network infrastructure planned
- Budget limits per category — valuable; deferred to next milestone
- Recurring transactions — deferred to next milestone
- Web target — only iOS and Android are primary targets
- Test suite — acknowledged gap; deferred (no tests exist today)

## Context

- Target users: Romanian and Russian speakers; UI language follows system locale with ro/ru explicit support
- Statistics screen has a performance issue: `getEvolutionStats` runs 12 redundant Hive reads per load (calls `getIncomes()` and `getAllCategories()` inside a 6-iteration loop)
- Phase 01 complete — architecture baseline established: validation in use cases, UUID in use cases, StatsBloc preloaded, locale-aware month labels, DEFAULT_CURRENCY constant
- Phase 07 complete (2026-04-27) — Milestone v1.0 audit gaps closed: REL-03 (reactive currency threading through all screens/widgets) and STAT-03 (annual bar chart always refreshes after CRUD) both verified on device
- App is targeting public release on App Store and Google Play

## Constraints

- **Tech stack:** Flutter 3.41.1 (pinned via FVM); Dart ^3.11.0; no Flutter upgrades during this milestone
- **Architecture:** Clean Architecture with BLoC must be maintained; layer separation is non-negotiable
- **Storage:** Hive only; no SQLite migration, no network calls
- **Platform:** iOS and Android primary; macOS/Linux/Windows folders present but not target platforms
- **Release:** Targeting public App Store / Play Store — requires proper icon, splash, localization completeness, stability

## Key Decisions

| Decision | Rationale | Outcome |
|----------|-----------|---------|
| Local-first with Hive | Simplicity — no backend infrastructure, no auth, no sync | — Pending |
| BLoC for all state management | Established pattern, enforced by CLAUDE.md | — Pending |
| Romanian + Russian + system locale | Core user base; `intl` already a dependency | — Pending |
| Settings screen modeled on screenshot | User provided exact reference design (dark, grouped sections, icons) | — Pending |

## Evolution

This document evolves at phase transitions and milestone boundaries.

**After each phase transition** (via `/gsd:transition`):
1. Requirements invalidated? → Move to Out of Scope with reason
2. Requirements validated? → Move to Validated with phase reference
3. New requirements emerged? → Add to Active
4. Decisions to log? → Add to Key Decisions
5. "What This Is" still accurate? → Update if drifted

**After each milestone** (via `/gsd:complete-milestone`):
1. Full review of all sections
2. Core Value check — still the right priority?
3. Audit Out of Scope — reasons still valid?
4. Update Context with current state

---
*Last updated: 2026-04-24 after Phase 06 (release-polish) completion — milestone v1.0 complete*
