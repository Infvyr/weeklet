# Weeklet

## What This Is

Weeklet is a Flutter app for simple personal finance management. Users track weekly expenses by category, record income, and view annual statistics. The app is local-first with no cloud dependency, targeting Romanian and Russian-speaking users who want financial control without complexity.

## Core Value

Users can always see where their money went — fast entry, accurate totals, no friction.

## Latest Milestone: v1.2 Testing — ✅ SHIPPED 2026-07-26 (tag `v1.2`)

**Goal:** Establish comprehensive test infrastructure covering use cases, BLoCs, widgets, and integration flows with complete feature coverage.

**Delivered:**
- Phase 10 — Use case unit tests (validation, error handling, filtering) — 3 plans, completed 2026-05-21
- Phase 11 — BLoC state machine tests (all 6 BLoCs) — 3 plans, completed 2026-05-21
- Phase 12 — Widget component tests (5 screens + 2 form components) — 5 plans, completed 2026-06-21
- Phase 13 — Integration & critical path tests (real Hive, real widget-driven CRUD/stats/PDF-export flows) — 5 plans, completed 2026-07-14

**Outcome:** 27/27 requirements satisfied; 169/169 tests passing (fresh full-suite run at audit). Milestone audit status `tech_debt` — no functional gaps; two phases (10, 11) lack formal `VERIFICATION.md`/`VALIDATION.md` artifacts (coverage independently confirmed). See `.planning/v1.2-MILESTONE-AUDIT.md`.

## Next Milestone

Not yet scoped. Run `/gsd:new-milestone` to define v1.3 goals and fresh requirements. Candidate themes from the Deferred list: CSV export (EXP-03/04), monthly category budgets (BUDG), recurring transactions (AUTO), and test-suite maturation (golden/visual regression, a11y, CI integration). The "no Flutter upgrades" constraint was scoped to v1.2 and can now be revisited.

## Current State

**v1.2 Testing shipped 2026-07-14.** All 4 phases complete. Test suite grew from 0 to 169 automated tests (unit, BLoC, widget, and real-Hive integration) with zero regressions. The app remains feature-complete for public release scope from v1.1, now with comprehensive automated coverage backing it.

### What Ships in v1.2

- 169 automated tests: use case unit tests, BLoC state machine tests, widget component tests, and 4 real-Hive widget-driven integration flows (expense CRUD, income CRUD, stats refresh, PDF export with byte-level content verification)
- Shared test infrastructure: `test/helpers/test_hive_env.dart` (real temp-dir Hive + full DI graph mirroring `service_locator.dart`), `fake_share_platform.dart`, `pdf_text_extractor.dart`
- Known test-hygiene follow-ups (non-blocking, see `.planning/phases/13-integration-critical-path-tests/13-REVIEW.md`): teardown-on-assertion-failure risk in one smoke test, BLoC lifecycle not closed by the shared harness's teardown, `FakeSharePlatform` call-log not reset between tests, PDF export temp-file naming has a latent collision risk if a second export test is added later

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
- ✓ **TEST-01–08** — Use case unit tests: validation, error handling, delete cases, filtering/grouping, PDF generation — v1.2 (Phase 10)
- ✓ **TEST-09–15** — BLoC state machine tests: all 6 BLoCs (Expense, Income, Category, Stats, Settings, Export) — v1.2 (Phase 11)
- ✓ **TEST-16–23** — Widget component tests: 5 screens + AmountFieldView/DateFieldView — v1.2 (Phase 12)
- ✓ **TEST-24–27** — Integration tests: expense/income CRUD flows, stats refresh, PDF export — real widget-driven, real Hive persistence — v1.2 (Phase 13)

### Active

None — v1.2 Testing milestone complete, awaiting next milestone scope.

### Deferred

- **QUAL-01/02** — Unit + BLoC tests (use-case stubs exist; no BLoC tests shipped)
- **BUDG-01/02** — Monthly spending limits per category
- **AUTO-01** — Recurring transactions
- **EXP-03/04** — CSV export (expense + income)

---

## Constraints

- **Tech stack:** Flutter 3.41.1 (pinned via FVM); Dart ^3.11.0. The "no Flutter upgrades" constraint was scoped to the v1.2 Testing milestone (now complete 2026-07-14) — an SDK/package upgrade can be revisited now that the milestone has shipped.
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
| Real Hive (temp dir) over fake repositories for integration tests | "Integration" phase should exercise the real persistence layer, not re-verify BLoC logic already covered by unit tests | ✓ Validated v1.2 |
| `LiveTestWidgetsFlutterBinding()` for tests with real Hive writes | `TestWidgetsFlutterBinding.ensureInitialized()` hangs forever on real `dart:io` Hive writes inside `testWidgets` — root-caused in Phase 13 | ✓ Validated v1.2 |
| Hand-rolled PDF text extraction (zlib + Tj/TJ regex) over a new package | No suitable pure-Dart, FFI-free PDF text-extraction package exists on pub.dev; verified working against real production PDF output | ✓ Validated v1.2 |

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
*Last updated: 2026-07-26 — v1.2 Testing milestone shipped and tagged (169/169 tests passing, 27/27 requirements). Ready for /gsd:new-milestone.*
