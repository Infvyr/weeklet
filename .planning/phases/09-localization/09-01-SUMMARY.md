---
phase: 09-localization
plan: '01'
subsystem: localization
tags: [localization, gen-l10n, arb, flutter-localizations, locale-manager]

requires:
  - phase: 09-00
    provides: Wave 0 RED test contracts for locale_manager_test.dart

provides:
  - l10n.yaml gen-l10n config (arb-dir=lib/l10n, output-dir=lib/l10n, nullable-getter=false)
  - lib/l10n/app_en.arb template ARB with 144 user-visible string keys and @key metadata
  - lib/l10n/app_ro.arb with idiomatic Romanian translations for all 144 keys
  - lib/l10n/app_ru.arb with idiomatic Russian translations for all 144 keys
  - LocaleManager.supportedLocales trimmed to exactly [Locale('en'), Locale('ro'), Locale('ru')]
  - AppLocalizations.delegate registered first in MaterialApp.localizationsDelegates
  - localeResolutionCallback returning Locale('en') for null/unsupported locales (LOC-01)
  - Generated AppLocalizations class at package:weeklet/l10n/app_localizations.dart for Wave 2

affects: [09-02-typed-exceptions, 09-03-string-extraction, 09-04-string-extraction, 09-05-verify]

tech-stack:
  added:
    - gen-l10n (built-in Flutter tool, flutter: generate: true in pubspec.yaml)
  patterns:
    - "ARB file format: @@locale first key, @key metadata for all keys, placeholders for parameterized strings"
    - "AppLocalizations import: package:weeklet/l10n/app_localizations.dart (not flutter_gen/gen_l10n — synthetic-package deprecated)"
    - "localeResolutionCallback: iterate supportedLocales by languageCode, fallback to Locale('en') for unknown"
    - "Generated files gitignored: lib/l10n/app_localizations*.dart added to .gitignore"

key-files:
  created:
    - l10n.yaml
    - lib/l10n/app_en.arb
    - lib/l10n/app_ro.arb
    - lib/l10n/app_ru.arb
  modified:
    - lib/core/utils/locale_manager.dart
    - lib/app.dart
    - pubspec.yaml
    - .gitignore

key-decisions:
  - "Added flutter: generate: true to pubspec.yaml — required for fvm flutter gen-l10n (deviation Rule 3 auto-fix: blocking issue)"
  - "144 ARB keys covering all user-visible strings from complete RESEARCH.md string inventory"
  - "Generated app_localizations*.dart files gitignored — regenerated at build time, not committed"

patterns-established:
  - "ARB template (app_en.arb): every key has @key metadata block with description; parameterized keys add placeholders map"
  - "Translation ARBs (app_ro.arb, app_ru.arb): no @key metadata, just translated values; placeholder tokens verbatim"
  - "Wave 2 import pattern: import 'package:weeklet/l10n/app_localizations.dart'; final l10n = AppLocalizations.of(context);"

requirements-completed: [LOC-01]

duration: 7min
completed: '2026-05-03'
---

# Phase 09 Plan 01: Localization Infrastructure Summary

**gen-l10n infrastructure with l10n.yaml, three ARB files (144 keys, EN/RO/RU), trimmed LocaleManager.supportedLocales to [en, ro, ru], and MaterialApp wired with AppLocalizations.delegate + localeResolutionCallback English fallback**

## Performance

- **Duration:** ~7 min
- **Started:** 2026-05-03T06:17:44Z
- **Completed:** 2026-05-03T06:24:49Z
- **Tasks:** 3
- **Files modified:** 7

## Accomplishments

- Created l10n.yaml config at project root (arb-dir=lib/l10n, output-dir=lib/l10n, nullable-getter=false)
- Created app_en.arb template with 144 keys covering AppBar titles, empty states, error messages, action buttons, tooltips, form labels, filter bars, navigation, settings, dialogs, stats labels, income labels, biometric gate, export errors, action error codes, and form validation messages
- Created app_ro.arb with idiomatic Romanian translations for all 144 keys; app_ru.arb with idiomatic Russian translations for all 144 keys
- Trimmed LocaleManager.supportedLocales from 8 locales (en-US, en-GB, ro-RO, ru-RU, de, fr, es, it) to exactly [Locale('en'), Locale('ro'), Locale('ru')] — locale_manager_test.dart now green
- Wired MaterialApp in app.dart: AppLocalizations.delegate added first, localeResolutionCallback returns Locale('en') for null or unsupported locales
- Ran fvm flutter gen-l10n successfully; generated app_localizations*.dart files gitignored

## Task Commits

Each task was committed atomically:

1. **Task 1: Create l10n.yaml + three ARB files** - `5d030e0` (feat)
2. **Task 2: Trim LocaleManager.supportedLocales to [en, ro, ru]** - `9197f92` (feat)
3. **Task 3: Wire AppLocalizations + localeResolutionCallback in app.dart and run gen-l10n** - `5008a26` (feat)

**Plan metadata:** (docs commit — see below)

## Files Created/Modified

- `l10n.yaml` — gen-l10n config: arb-dir, template-arb-file, output-dir, nullable-getter
- `lib/l10n/app_en.arb` — Template ARB with 144 keys and @key metadata; 2 parameterized keys (amountFieldLabel, incomeTotalForMonth)
- `lib/l10n/app_ro.arb` — Romanian translations for all 144 keys; {currency} and {month} placeholders preserved verbatim
- `lib/l10n/app_ru.arb` — Russian translations for all 144 keys; {currency} and {month} placeholders preserved verbatim
- `lib/core/utils/locale_manager.dart` — supportedLocales trimmed to 3 bare-language locales; fallbacks updated; doc comments updated
- `lib/app.dart` — AppLocalizations.delegate added first; localeResolutionCallback added; import added
- `pubspec.yaml` — flutter: generate: true added (required for gen-l10n)
- `.gitignore` — lib/l10n/app_localizations.dart and lib/l10n/app_localizations_*.dart added

## Decisions Made

- Added `flutter: generate: true` to pubspec.yaml — required for `fvm flutter gen-l10n` to run (auto-fix for blocking issue encountered during Task 3)
- 144 ARB keys chosen to cover every user-visible string from the RESEARCH.md complete string inventory
- Generated files gitignored to avoid committing build outputs — regenerated at build time

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 3 - Blocking] Added flutter: generate: true to pubspec.yaml**
- **Found during:** Task 3 (run gen-l10n)
- **Issue:** `fvm flutter gen-l10n` failed with "Attempted to generate localizations code without having the flutter: generate flag turned on"
- **Fix:** Added `generate: true` under the `flutter:` section in pubspec.yaml
- **Files modified:** pubspec.yaml
- **Verification:** `fvm flutter gen-l10n` ran successfully; generated files exist
- **Committed in:** `5008a26` (Task 3 commit)

---

**Total deviations:** 1 auto-fixed (1 blocking issue)
**Impact on plan:** Auto-fix essential for gen-l10n to run. No scope creep — pubspec.yaml flag is the standard Flutter requirement for gen-l10n.

## Issues Encountered

None beyond the `flutter: generate: true` blocking issue documented as deviation above.

## User Setup Required

None — no external service configuration required.

## Next Phase Readiness

- Wave 1 infrastructure complete: AppLocalizations class available at `package:weeklet/l10n/app_localizations.dart`
- Plan 02 (typed exceptions) can proceed — creates ExpenseValidationException, IncomeValidationException, CategoryValidationException
- Plans 03 and 04 (string extraction in presentation widgets) can now import AppLocalizations
- Plan 05 (verification) can run after Wave 2 completes
- locale_manager_test.dart passes all 3 LOC-01 contract tests

## Known Stubs

None — all 144 ARB keys have real, idiomatic translations in all three locales. No placeholder or stub values.

## Threat Flags

No new security-relevant surface introduced. ARB files are static bundled assets. localeResolutionCallback maps untrusted device input to a finite set of three supported locales.

## Self-Check: PASSED

- FOUND: l10n.yaml
- FOUND: lib/l10n/app_en.arb
- FOUND: lib/l10n/app_ro.arb
- FOUND: lib/l10n/app_ru.arb
- FOUND: lib/core/utils/locale_manager.dart (modified)
- FOUND: lib/app.dart (modified)
- FOUND: lib/l10n/app_localizations.dart (generated, gitignored)
- FOUND commit: 5d030e0 (Task 1)
- FOUND commit: 9197f92 (Task 2)
- FOUND commit: 5008a26 (Task 3)

---
*Phase: 09-localization*
*Completed: 2026-05-03*
