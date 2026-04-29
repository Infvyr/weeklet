# Roadmap: Weeklet

## Milestones

- **[v1.0 — Shipped 2026-04-27](.planning/milestones/v1.0-ROADMAP.md)** — Architecture cleanup, income screen, statistics, settings, PDF export, release assets, integration gap closure (7 phases, 21 plans, 25/25 requirements)

---

## v1.1 — UX Polish

**Goal:** Fix six UX rough edges — layout, navigation, readability, scrolling, and localization.
**Status:** In progress
**Requirements:** 6 | **Phases:** 2

| # | Phase | Goal | Requirements | Success Criteria |
|---|-------|------|--------------|-----------------|
| 8 | UI Polish | Tighten layout, navigation, and visual polish across the app | UX-01, UX-02, UX-03, UX-04, UX-05 | 5 |
| 9 | Localization | Full RO/RU/EN coverage with EN fallback for unknown locales | LOC-01 | 2 |

---

### Phase Details

**Phase 8: UI Polish**
Goal: Tighten layout, navigation, and visual polish across the app
Requirements: UX-01, UX-02, UX-03, UX-04, UX-05
Success criteria:
1. Expenses empty state is visually centered on screen
2. PDF export icon/button is absent when expenses list is empty; absent when income list is empty
3. Bottom navigation has no Categories tab; expenses AppBar has a categories icon that opens the categories screen
4. Annual evolution row shows amount on one line without wrapping
5. A scrollbar track appears alongside any scrollable list or page

**Phase 9: Localization**
Goal: Full RO/RU/EN coverage with EN fallback for unknown locales
Requirements: LOC-01
Success criteria:
1. Every visible string in the app appears in Romanian, Russian, and English ARB files with no missing keys
2. Running the app with a system locale outside ro/ru/en (e.g., fr, de) displays all text in English
