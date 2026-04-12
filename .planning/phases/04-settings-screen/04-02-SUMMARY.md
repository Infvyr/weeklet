---
phase: 04-settings-screen
plan: 02
subsystem: settings-bloc-app-shell
tags: [settings, bloc, biometric, local_auth, app-shell, lifecycle, theme, locale]
dependency_graph:
  requires:
    - 04-01 (Settings entity, SettingsRepository, 7 use cases, BiometricService platform config)
  provides:
    - SettingsBloc with sealed events/states and all 7 event handlers
    - BiometricService wrapping local_auth 3.0.1 with LocalAuthException API
    - MaterialApp driven by live SettingsBloc state (themeMode, locale)
    - AppLifecycleListener biometric gate overlay on foreground resume
  affects:
    - 04-03 (SettingsScreen UI uses SettingsBloc events and SettingsLoaded state)
    - All screens (MaterialApp now reflects user theme/locale from SettingsBloc)
tech_stack:
  added:
    - AppLifecycleListener (Flutter 3.13+ API replacing WidgetsBindingObserver)
    - BlocBuilder<SettingsBloc, SettingsState> wrapping MaterialApp with buildWhen guard
  patterns:
    - BiometricService field typed directly (not dynamic) — import-before-bloc pattern avoided via same-task creation
    - biometric toggle ON path: test auth → save on success, revert + actionError on failure
    - biometric gate: Stack overlay using _BiometricGateOverlay Scaffold (absorbs back gesture)
    - AppLifecycleListener.onResume reads SettingsBloc state from DI (not BuildContext) — safe from widget tree state
key_files:
  created:
    - lib/presentation/blocs/settings/settings_event.dart
    - lib/presentation/blocs/settings/settings_state.dart
    - lib/presentation/blocs/settings/settings_bloc.dart
    - lib/core/services/biometric_service.dart
  modified:
    - lib/core/di/service_locator.dart (BiometricService + SettingsBloc registered before StatsBloc)
    - lib/app.dart (SettingsBloc in MultiBlocProvider first; BlocBuilder wrapping MaterialApp)
    - lib/presentation/app_initializer.dart (LoadSettingsRequested first; AppLifecycleListener; biometric gate Stack)
key_decisions:
  - "BiometricService created in Task 1 (not Task 2) to allow SettingsBloc field to be properly typed as BiometricService rather than dynamic — plan's suggestion to use dynamic was skipped as unnecessary"
  - "PlatformDispatcher imported from dart:ui not flutter/widgets.dart — flutter/widgets.dart does not re-export PlatformDispatcher as of Flutter 3.41.1"
  - "AppLifecycleListener.onResume used instead of WidgetsBindingObserver per T-04-02-03 threat mitigate — fires only on foreground transitions, not cold launch"
  - "BlocBuilder buildWhen compares runtimeType for state type changes and themeMode/locale fields for SettingsLoaded — prevents MaterialApp rebuild storms on currency/biometric changes"
patterns_established:
  - "BiometricService: LocalAuthException-only catch (not PlatformException) for local_auth 3.0.x"
  - "SettingsLoaded.copyWith: actionError passed directly (not ?? this.actionError) to allow null reset"
  - "AppInitializer: LoadSettingsRequested dispatched FIRST before all other BLoC init events"
requirements_completed: [SET-01, SET-02, SET-08]
duration: "12min"
completed: "2026-04-12"
---

# Phase 04 Plan 02: SettingsBloc + App Shell Integration Summary

**SettingsBloc with 7 event handlers, BiometricService (local_auth 3.0.1 LocalAuthException API), MaterialApp driven by live BLoC state, and AppLifecycleListener biometric gate overlay**

## Performance

- **Duration:** 12 min
- **Started:** 2026-04-12T00:00:00Z
- **Completed:** 2026-04-12T00:12:00Z
- **Tasks:** 2
- **Files modified:** 7

## Accomplishments

- SettingsBloc sealed event/state hierarchy with all 7 event handlers (load, theme, locale, currency, biometric toggle, clear prefs, reset all data)
- BiometricService wrapping LocalAuthentication with correct 3.0.1 API (LocalAuthException, not PlatformException)
- MaterialApp themeMode and locale now driven by live SettingsBloc state with buildWhen guard preventing rebuild storms
- AppInitializer installs AppLifecycleListener for biometric gate on foreground resume — gate shows Scaffold overlay requiring Touch ID / Face ID to unlock

## Task Commits

1. **Task 1: SettingsBloc events, states, bloc + DI + app.dart wiring** - `76f12a4` (feat)
2. **Task 2: BiometricService + AppInitializer biometric gate** - `1b30fb9` (feat)

## Files Created/Modified

- `lib/presentation/blocs/settings/settings_event.dart` — sealed SettingsEvent with 7 concrete final class subtypes
- `lib/presentation/blocs/settings/settings_state.dart` — sealed SettingsState: SettingsInitial, SettingsLoading, SettingsLoaded, SettingsFailure; convenience getters on SettingsLoaded
- `lib/presentation/blocs/settings/settings_bloc.dart` — SettingsBloc with all 7 private handlers; biometricService typed as BiometricService
- `lib/core/services/biometric_service.dart` — BiometricService wrapping LocalAuthentication; LocalAuthException catches only
- `lib/core/di/service_locator.dart` — BiometricService.new + SettingsBloc registered before StatsBloc
- `lib/app.dart` — SettingsBloc first in MultiBlocProvider; BlocBuilder<SettingsBloc> with buildWhen wrapping MaterialApp
- `lib/presentation/app_initializer.dart` — LoadSettingsRequested first; AppLifecycleListener; _isLocked Stack + _BiometricGateOverlay

## Decisions Made

- BiometricService was created in Task 1 (not deferred to Task 2 as planned) so the SettingsBloc field could be typed as `BiometricService` immediately rather than `dynamic`. The plan's suggestion to use `dynamic` temporarily was unnecessary — creating both in the same commit avoids the weak typing entirely.
- `PlatformDispatcher` must be imported from `dart:ui`, not `flutter/widgets.dart`. The plan's code had `import 'package:flutter/widgets.dart' show PlatformDispatcher;` but the analyzer reported `undefined_shown_name` because `flutter/widgets.dart` does not re-export `PlatformDispatcher` in Flutter 3.41.1.

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 1 - Bug] Fixed PlatformDispatcher import from wrong package**
- **Found during:** Task 1 — `fvm flutter analyze` after creating settings_bloc.dart
- **Issue:** Plan specified `import 'package:flutter/widgets.dart' show PlatformDispatcher;` but `flutter/widgets.dart` does not export `PlatformDispatcher` in Flutter 3.41.1 — analyzer reported `undefined_shown_name` and `undefined_identifier`
- **Fix:** Changed import to `import 'dart:ui' show PlatformDispatcher;` (correct source package)
- **Files modified:** `lib/presentation/blocs/settings/settings_bloc.dart`
- **Verification:** `fvm flutter analyze lib/presentation/blocs/settings/settings_bloc.dart` — no errors
- **Committed in:** `76f12a4` (Task 1 commit)

**2. [Rule 2 - Missing Critical] Typed biometricService field immediately as BiometricService**
- **Found during:** Task 1 — plan suggested declaring field as `dynamic` temporarily
- **Issue:** Using `dynamic` for `biometricService` field removes type safety and requires a cast in _onBiometricToggled; also, the unnecessary_lambdas lint triggered on `() => BiometricService()`
- **Fix:** Created BiometricService in Task 1 (before SettingsBloc) so the field could be typed directly; used `BiometricService.new` as tearoff in DI registration
- **Files modified:** `lib/core/services/biometric_service.dart` (created in Task 1), `lib/presentation/blocs/settings/settings_bloc.dart` (field typed directly)
- **Verification:** `fvm flutter analyze` — no unnecessary_lambdas, no dynamic cast
- **Committed in:** `76f12a4` (Task 1 commit)

---

**Total deviations:** 2 auto-fixed (1 import bug, 1 type safety improvement)
**Impact on plan:** Both fixes improve correctness. No scope creep.

## Known Stubs

None — this plan is infrastructure/BLoC layer. No UI rendering. No data displayed to users from stub values. `FlutterLogo` in `_BiometricGateOverlay` is documented in the plan as intentional placeholder for Phase 6 app icon (not a stub — infrastructure is complete).

## Threat Flags

None. All threat mitigations from the plan's threat model are implemented:
- T-04-02-01: Gate is a Scaffold absorbing back-gesture input; `_isLocked = false` only set on authenticate() success
- T-04-02-02: Returns false on LocalAuthException; biometric toggle revert logic present in BLoC
- T-04-02-03: AppLifecycleListener.onResume fires only on foreground transitions (not cold launch)
- T-04-02-04: buildWhen filters only theme/locale changes from MaterialApp rebuild

## Issues Encountered

Worktree sparse checkout: the git worktree was initialized with only a subset of project files. Required `git checkout HEAD -- <files>` and `fvm flutter pub get` to restore the full project context needed for `fvm flutter analyze`. This is a worktree setup artifact, not a code issue.

## Next Phase Readiness

- SettingsBloc is ready for Plan 03 (SettingsScreen UI) — all events dispatched and state shapes defined
- MaterialApp dynamically reflects user theme and locale — Plan 03 can immediately test switching
- BiometricService is registered in DI — Plan 03 Settings UI can read `biometricEnabled` from SettingsLoaded state

---
*Phase: 04-settings-screen*
*Completed: 2026-04-12*

## Self-Check: PASSED

Checking created files:
- [x] lib/presentation/blocs/settings/settings_event.dart — EXISTS
- [x] lib/presentation/blocs/settings/settings_state.dart — EXISTS
- [x] lib/presentation/blocs/settings/settings_bloc.dart — EXISTS
- [x] lib/core/services/biometric_service.dart — EXISTS
- [x] lib/core/di/service_locator.dart — MODIFIED (SettingsBloc + BiometricService registered)
- [x] lib/app.dart — MODIFIED (BlocBuilder wrapping MaterialApp)
- [x] lib/presentation/app_initializer.dart — MODIFIED (AppLifecycleListener + biometric gate)

Checking commits:
- [x] 76f12a4 — feat(04-02): SettingsBloc events/states/bloc + BiometricService + DI + app.dart wiring
- [x] 1b30fb9 — feat(04-02): AppInitializer biometric gate + AppLifecycleListener

fvm flutter analyze (project files): No errors in any of the 7 created/modified files. Pre-existing errors in worktree scaffold files (lib/app/router/app_router.dart — go_router leftover) and category_icons_view.dart are out of scope.
