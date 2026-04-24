---
phase: 06-release-polish
plan: '01'
subsystem: infra
tags: [flutter_launcher_icons, flutter_native_splash, ios, android, branding, icon, splash]

# Dependency graph
requires: []
provides:
  - 'Branded 1024x1024 source icon PNG at assets/icon/icon.png (#1447E6 brand blue)'
  - 'All iOS AppIcon.appiconset sizes generated from source (22 files)'
  - 'Android launcher icons for all mipmap densities (mdpi-xxxhdpi), plus adaptive icon XML'
  - 'Android splash screens for pre-12 (drawable/launch_background.xml) and API 31+ (values-v31/styles.xml)'
  - 'iOS LaunchImage.imageset and LaunchScreen.storyboard updated with brand colour'
  - 'pubspec.yaml configured with flutter_launcher_icons: and flutter_native_splash: top-level blocks'
affects: [06-02, 06-03, release]

# Tech tracking
tech-stack:
  added: []
  patterns:
    - 'flutter_launcher_icons config as top-level pubspec.yaml key with adaptive_icon_background + remove_alpha_ios: true'
    - 'flutter_native_splash config with android_12: sub-block for API 31+ windowSplashScreen attributes'

key-files:
  created:
    - 'assets/icon/icon.png — 1024x1024 opaque PNG, brand blue #1447E6 background, white W lettermark'
    - 'android/app/src/main/res/values-v31/styles.xml — Android 12+ splash style with windowSplashScreenBackground #1447E6'
    - 'android/app/src/main/res/values-night-v31/styles.xml — Android 12+ dark splash with icon_background_color #1447E6'
    - 'android/app/src/main/res/values/colors.xml — ic_launcher_background color #1447E6'
    - 'android/app/src/main/res/mipmap-anydpi-v26/launcher_icon.xml — adaptive icon descriptor'
    - 'ios/Runner/Assets.xcassets/LaunchBackground.imageset/ — brand-coloured iOS launch background'
  modified:
    - 'pubspec.yaml — added assets/icon/ declaration + flutter_launcher_icons: + flutter_native_splash: blocks'
    - 'ios/Runner/Assets.xcassets/AppIcon.appiconset/Contents.json — regenerated icon set'
    - 'ios/Runner/Base.lproj/LaunchScreen.storyboard — updated with brand-coloured background'
    - 'android/app/src/main/res/drawable/launch_background.xml — brand splash background'
    - 'android/app/src/main/res/drawable-v21/launch_background.xml — API 21+ splash'
    - 'android/app/src/main/AndroidManifest.xml — launcher icon name updated to launcher_icon'

key-decisions:
  - 'Used adaptive_icon_background: "#1447E6" so Android API 26+ devices render the icon with brand colour — no separate background PNG required'
  - 'remove_alpha_ios: true ensures iOS App Store submission is not rejected due to alpha channel'
  - 'android_12 sub-block in flutter_native_splash uses windowSplashScreenBackground and windowSplashScreenIconBackgroundColor for full API 31+ compliance'
  - 'Icon file committed at 4557 bytes (solid colour compresses heavily) — correct, not a quality issue'

patterns-established:
  - 'Icon source at assets/icon/icon.png — single source of truth for all platform icon generation'
  - 'Generator configs as sibling top-level YAML keys after flutter: section, never nested inside it'

requirements-completed: [REL-01, REL-02]

# Metrics
duration: 18min
completed: '2026-04-24'
---

# Phase 06 Plan 01: App Icon & Splash Screen Summary

**Branded launcher icons and native splash screens generated for iOS and Android using #1447E6 brand blue, with adaptive icon support (API 26+) and Android 12 windowSplashScreen compliance (API 31+)**

## Performance

- **Duration:** ~18 min
- **Started:** 2026-04-24
- **Completed:** 2026-04-24
- **Tasks:** 4/4 complete
- **Files modified:** 74 (pubspec.yaml + generated icon/splash assets across iOS and Android)

## Accomplishments

- Configured pubspec.yaml with both generator config blocks as validated top-level YAML keys
- Generated 22 iOS icon size variants in AppIcon.appiconset from the 1024x1024 source PNG
- Generated adaptive Android launcher icons (mipmap-anydpi-v26 XML + all density PNGs) with brand blue background
- Generated native splash screens for Android pre-12 (drawable XML), Android 12+ (values-v31 styles), and iOS (LaunchImage.imageset + LaunchScreen.storyboard)
- All 28 unit tests pass after generation — zero regressions

## Task Commits

Each task was committed atomically:

1. **Task 1: Provide source icon PNG** — pre-completed (icon generated via Python stdlib in prior session)
2. **Task 2: Configure pubspec.yaml** — `8bd833c` (chore)
3. **Task 3: Run flutter_launcher_icons generator** — `e7f81fa` (feat)
4. **Task 4: Run flutter_native_splash generator** — `f7503af` (feat)

## Files Created/Modified

- `pubspec.yaml` — Added `assets/icon/` under `flutter:`, added `flutter_launcher_icons:` and `flutter_native_splash:` top-level config blocks
- `assets/icon/icon.png` — Source 1024x1024 opaque PNG, #1447E6 background with white W lettermark
- `ios/Runner/Assets.xcassets/AppIcon.appiconset/` — All icon sizes regenerated (22 files)
- `ios/Runner/Assets.xcassets/LaunchImage.imageset/` — Brand-coloured launch images (3 sizes)
- `ios/Runner/Assets.xcassets/LaunchBackground.imageset/` — Background image asset set for iOS splash
- `ios/Runner/Base.lproj/LaunchScreen.storyboard` — Updated launch screen with brand background
- `ios/Runner/Info.plist` — Updated for splash screen configuration
- `android/app/src/main/AndroidManifest.xml` — Launcher icon name updated to `launcher_icon`
- `android/app/src/main/res/mipmap-*/launcher_icon.png` — Icon at all Android densities (mdpi-xxxhdpi)
- `android/app/src/main/res/mipmap-anydpi-v26/launcher_icon.xml` — Adaptive icon descriptor
- `android/app/src/main/res/drawable-*/ic_launcher_foreground.png` — Adaptive foreground layer
- `android/app/src/main/res/drawable/launch_background.xml` — Pre-API-21 splash background
- `android/app/src/main/res/drawable-v21/launch_background.xml` — API 21+ splash background
- `android/app/src/main/res/drawable-night/launch_background.xml` — Dark mode splash background
- `android/app/src/main/res/drawable-*/splash.png` — Splash images at all densities
- `android/app/src/main/res/drawable-*/android12splash.png` — Android 12 splash images at all densities
- `android/app/src/main/res/values-v31/styles.xml` — API 31+ splash style (windowSplashScreenBackground: #1447E6)
- `android/app/src/main/res/values-night-v31/styles.xml` — API 31+ dark splash style
- `android/app/src/main/res/values/colors.xml` — ic_launcher_background: #1447E6
- `android/app/src/main/res/values/styles.xml` — Updated splash theme reference
- `android/app/src/main/res/values-night/styles.xml` — Dark mode splash theme reference

## Decisions Made

- `adaptive_icon_background: '#1447E6'` used so API 26+ devices apply brand colour without a separate background PNG
- `remove_alpha_ios: true` set to ensure Apple App Store icon validation passes (alpha channel rejection)
- `android_12:` sub-block included for full API 31+ compliance using `windowSplashScreenBackground` and `windowSplashScreenIconBackgroundColor`
- Adaptive icon uses `launcher_icon` name (not the default `ic_launcher`) to coexist cleanly with existing default icon files

## Deviations from Plan

None — plan executed exactly as written.

## Issues Encountered

None. Both generators ran cleanly on the first attempt. The `flutter_native_splash` generator uses `@color/` resource references in drawable XMLs rather than inline hex values — brand colour `#1447E6` is stored in `values/colors.xml` and `values-v31/styles.xml` as expected by the Android resource system.

## Known Stubs

None. All generated files are real platform assets wired to the generator configuration.

## User Setup Required

None — no external service configuration required.

## Next Phase Readiness

- iOS and Android icons are ready for TestFlight and Play Store internal testing uploads
- Splash screens are production-ready for both pre-12 and API 31+ Android devices
- iOS LaunchScreen.storyboard is updated; no Xcode manual steps required
- Phase 06-02 (release checks) can proceed

## Self-Check: PASSED

- `assets/icon/icon.png` — FOUND (committed in e7f81fa)
- `ios/Runner/Assets.xcassets/AppIcon.appiconset/` — FOUND (22 files)
- `android/app/src/main/res/mipmap-hdpi/launcher_icon.png` — FOUND
- `android/app/src/main/res/values-v31/styles.xml` — FOUND (contains #1447E6)
- Commits: 8bd833c, e7f81fa, f7503af — all verified in git log
- `fvm flutter test` — 28/28 pass

---
*Phase: 06-release-polish*
*Completed: 2026-04-24*
