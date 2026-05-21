# Roadmap: Weeklet

## Milestones

- **[v1.0 — Shipped 2026-04-27](.planning/milestones/v1.0-ROADMAP.md)** — Architecture cleanup, income screen, statistics, settings, PDF export, release assets, integration gap closure (7 phases, 21 plans, 25/25 requirements)
- **[v1.1 — Shipped 2026-05-03](.planning/milestones/v1.1-ROADMAP.md)** — UX polish and full RO/RU/EN localization (2 phases, 12 plans, 6/6 requirements)
- **[v1.2 — In Progress](.planning/milestones/v1.2-ROADMAP.md)** — Comprehensive test infrastructure and coverage (4 phases, TBD plans, 27/27 requirements)

---

## Phases

<details>
<summary>✅ v1.0 MVP (Phases 1–7) — SHIPPED 2026-04-27</summary>

See [v1.0-ROADMAP.md](.planning/milestones/v1.0-ROADMAP.md) for full details.

</details>

<details>
<summary>✅ v1.1 UX Polish (Phases 8–9) — SHIPPED 2026-05-03</summary>

- [x] Phase 8: UI Polish — formatCompact, scrollbars, 4-tab nav, PDF hide, empty state (6/6 plans) — completed 2026-04-30
- [x] Phase 9: Localization — gen-l10n, ARB files (EN/RO/RU), typed exceptions, full widget tree localization (6/6 plans) — completed 2026-05-03

</details>

<details>
<summary>⏳ v1.2 Testing (Phases 10–13) — IN PROGRESS</summary>

- [x] Phase 10: Test Infrastructure & Use Case Tests — Use case unit tests for all business logic (validation, filtering, error handling) and infrastructure setup (completed 2026-05-21)
  **Plans:** 3 plans
  Plans:
  - [x] 10-01-PLAN.md — TEST-03 TDD: AddCategoryUseCase duplicate prevention (enum + use case + tests)
  - [x] 10-02-PLAN.md — TEST-04: Delete use case tests for expense, income, and category
  - [x] 10-03-PLAN.md — TEST-05 + TEST-06: ExpenseFilterUtils and IncomeFilterUtils filtering tests
- [ ] Phase 11: BLoC State Machine Tests — BLoC event handlers, state transitions, and mutation side effects for all 6 BLoCs
  **Plans:** 3 plans
  Plans:
  - [ ] 11-01-PLAN.md — TEST-12 + TEST-13 + TEST-15: Shared helpers (fake_blocs, collectStates) + CategoryBloc, StatsBloc, ExportBloc tests
  - [ ] 11-02-PLAN.md — TEST-09 + TEST-11: ExpenseBloc and IncomeBloc tests (GetIt isolation for CRUD handlers)
  - [ ] 11-03-PLAN.md — TEST-14: SettingsBloc tests (BiometricService stub + all 4 fake BLoCs in GetIt)
- [ ] Phase 12: Widget Component Tests — Screen and component unit tests for rendering, interaction, and form validation
- [ ] Phase 13: Integration & Critical Path Tests — End-to-end user workflows and file operations (PDF generation)

</details>

---

## Progress

| Phase | Milestone | Plans | Status   | Completed  |
|-------|-----------|-------|----------|------------|
| 1–7   | v1.0      | 21/21 | Complete | 2026-04-27 |
| 8     | v1.1      | 6/6   | Complete | 2026-04-30 |
| 9     | v1.1      | 6/6   | Complete | 2026-05-03 |
| 10    | v1.2      | 3/3 | Complete   | 2026-05-21 |
| 11    | v1.2      | 3/3   | Not started | — |
| 12    | v1.2      | TBD   | Not started | — |
| 13    | v1.2      | TBD   | Not started | — |
