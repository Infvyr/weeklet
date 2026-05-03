# Project Retrospective

*A living document updated after each milestone. Lessons feed forward into future planning.*

---

## Milestone: v1.1 — UX Polish

**Shipped:** 2026-05-03
**Phases:** 2 (08, 09) | **Plans:** 12 | **Sessions:** 3

### What Was Built

- **Phase 8 — UI Polish:** `formatCompact` (K-notation for amounts ≥ 1000), global `ScrollConfiguration` injection, 4-tab bottom navigation (Categories moved to AppBar icon), expenses empty state centering, PDF export hidden when list is empty, compact stats amounts.
- **Phase 9 — Localization:** `gen-l10n` infrastructure with `l10n.yaml` and 3 ARB files (145 keys × EN/RO/RU), trimmed `LocaleManager`, `localeResolutionCallback` English fallback, typed domain exceptions replacing all English error strings in the domain layer, full widget tree localization across 60+ files.

### What Worked

- **Parallel worktree execution:** Plans 09-03 and 09-04 ran in parallel worktrees without conflicts — they touched entirely different file sets. The post-merge gate caught the one overlap (`amount_field_view.dart`) cleanly.
- **TDD RED→GREEN discipline for Phase 9:** Wave 0 committed failing tests before implementation; all three test files turned GREEN exactly as planned.
- **Typed exception pattern:** Replacing use-case `ArgumentError`/English strings with enum-coded exceptions made the BLoC→widget translation switch clean and testable.
- **ARB parity enforced by automation:** Python parity check in plan 09-05 caught missing keys before human review.

### What Was Inefficient

- **Agent stream timeout (09-03):** The 09-03 executor stalled on the stream watchdog after committing expenses files but before completing categories and settings. Recovery required manually merging the worktree, resolving a conflict in `amount_field_view.dart`, and committing the leftover category files separately — ~30 min of cleanup.
- **09-04 agent committed to main branch directly:** The 09-04 agent bypassed its worktree and committed directly to `dev`. This created an unusual state where one worktree had uncommitted but valid changes while its worktree branch was at base. Root cause unclear (likely worktree lock during sequential dispatch).
- **REQUIREMENTS.md checkboxes not auto-ticked:** The SDK marks phases complete but leaves `REQUIREMENTS.md` checkbox state unchanged. Required manual tick at milestone close.

### Patterns Established

- **BLoC emits error codes, widgets translate:** `actionError` carries ARB key names (e.g., `'errorBiometricFailed'`), never English sentences. Widget listeners use a `switch` to call `l10n.{key}`.
- **Bare `Locale` objects (no country codes):** `LocaleManager.supportedLocales` and all persisted locales use `Locale('en')` not `Locale('en', 'US')`. `Locale.==` requires exact match — country codes cause silent UI bugs (CR-01).
- **Required button labels in dialogs:** `CustomConfirmationDialog` `confirmButtonText`/`cancelButtonText` are `required` — callers must pass l10n strings. No English defaults.
- **`currencySymbol` passed explicitly:** `AmountFieldView` takes `required this.currencySymbol`. Forces all call sites to be intentional about the currency label shown.

### Key Lessons

1. **Stream watchdog timeouts are recoverable.** When an agent stalls mid-plan, check `git log` first — committed work is safe in the worktree. Run the merge manually, resolve conflicts, and commit leftover unstaged changes. Don't re-execute the full plan.
2. **Wave 2 parallel plans must have zero `files_modified` overlap.** The overlap check is critical — even a single shared file forces sequential execution. `amount_field_view.dart` was in both 09-03 and 09-04 plans but the overlap was caught at merge time, not planning time.
3. **Locale equality in Flutter is exact.** `Locale('en', 'US') != Locale('en')`. Use bare language codes everywhere — in `supportedLocales`, persisted state, and option lists.
4. **Code review found 2 critical bugs post-execution.** CR-01 (locale mismatch) and CR-02 (hardcoded English in BLoC) would have shipped to users without the review gate. The gsd-code-review step is worth keeping mandatory.

### Cost Observations

- Model: Claude Sonnet 4.6 (1M context) throughout
- Sessions: ~3 sessions across 4 days (limits hit during Phase 9 execution)
- Notable: 1M context window allowed rich prior-wave SUMMARY context to be passed to executor agents without trimming

---

## Cross-Milestone Trends

### Process Evolution

| Milestone | Phases | Plans | Key Change |
|-----------|--------|-------|------------|
| v1.0 | 7 | 21 | Initial GSD setup; single-agent sequential execution |
| v1.1 | 2 | 12 | Parallel worktree execution for Wave 2; mandatory code review gate |

### Cumulative Quality

| Milestone | Tests | Zero-Dep Domain | Typed Errors |
|-----------|-------|-----------------|--------------|
| v1.0 | 34 (use case + export) | ✓ | ArgumentError (partial) |
| v1.1 | 34 (stable) | ✓ | Typed exception enums (complete) |

### Top Lessons (Verified Across Milestones)

1. **Domain layer must stay Flutter-free.** Any Flutter import in `lib/domain/` is a red flag — it breaks testability and localization.
2. **Code review gate catches production bugs.** Two milestones, two mandatory reviews — both found critical issues that automated tests missed.
3. **Stream timeouts are recoverable, not catastrophic.** Committed work survives; the recovery path (manual merge + leftover commit) is well-understood.
