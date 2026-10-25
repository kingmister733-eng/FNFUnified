# FNF Unified Engine

A Friday Night Funkin' engine repository. The working branch `task/p-slice-base`
brings the **real P-Slice Engine Mobile** source tree into this repository as the
foundation for the Android engine; it is imported verbatim from upstream, not a
prototype, not a stub.

| Item | Value |
| --- | --- |
| Branch | `task/p-slice-base` (based on `main`) |
| Imported engine | P-Slice Engine Mobile (Haxe / HaxeFlixel / OpenFL / Lime) |
| Upstream repository | https://github.com/Moxie-Stuff/P-Slice-Mobile |
| Upstream commit | [`676242263db2389332b22a58fab2a841298c0f29`](https://github.com/Moxie-Stuff/P-Slice-Mobile/commit/676242263db2389332b22a58fab2a841298c0f29) (2024-10-25, `master`) |
| Licence | Apache License 2.0 |
| Import location | [`pslice-mobile/`](pslice-mobile) |

## Repository layout

```
pslice-mobile/          the imported P-Slice Engine Mobile project (buildable Android app)
  Project.xml           Lime/OpenFL project file (app id com.mikolka9144.pslice)
  source/               272 Haxe files, ~76,900 lines
  assets/               base game, shared, week assets, songs, videos, fonts (982 MB)
  art/                  engine icons and documentation images
  example_mods/         example mod
  key.keystore          upstream development signing key
  LICENSE               Apache License 2.0
  UPSTREAM.md           exact upstream commit + import verification record
  .github/workflows/    upstream CI (inactive in this location, see below)

project.xml             FNF Unified menu prototype (legacy, untouched)
source/                 FNF Unified menu prototype sources (legacy, untouched)
assets/                 FNF Unified prototype artwork (legacy, untouched)
.github/workflows/      android.yml — builds the legacy prototype APK
```

## The imported engine

P-Slice Engine Mobile is a crossover between Psych Engine and the newer
"V-Slice" Friday Night Funkin' builds, with Android specifically in mind. It is
the full upstream tree at the pinned commit:

* the complete game/engine source (`source/`: `backend/`, `mobile/`,
  `psychlua/`, `objects/`, `states/`, `substates/`, `cutscenes/`, `options/`,
  `shaders/`, plus `flixel/`, `openfl/`, `lime/` overrides and `external/`);
* the full asset set the engine needs at runtime (base game weeks, songs,
  shared art/audio, videos, fonts, translations, stickers);
* the Lime project configuration `Project.xml`, the Android signing keystore and
  the upstream CI workflows;
* the upstream `LICENSE`, `README.md` and `gitVersion.txt` unchanged.

All 2176 files were verified against the upstream git blob hashes after import
(0 differences). Method and inventory: [`pslice-mobile/UPSTREAM.md`](pslice-mobile/UPSTREAM.md).

## Requirements

* **Haxe 4.3.6** and **Neko** (the version used by upstream CI).
* **JDK 17** (Lime's Android toolchain expects 17).
* **Android SDK** (`platform-tools`, a platform, `build-tools`) and the
  **Android NDK** (the project is compiled with hxcpp through the NDK).
* A C++ toolchain (`g++`, `make`) and ~2 GB of free disk for the build output.
* Haxelib libraries pinned exactly as in `pslice-mobile/.github/workflows/build.yml`:

```
haxelib git     lime                  https://github.com/Psych-Slice/lime-mobile                      # 8.1.2 base
haxelib install hxcpp                 4.3.2
haxelib install openfl                9.3.3
haxelib git     flixel                https://github.com/HaxeFlixel/flixel 5.8.0                  # + one-line patch, below
haxelib install flixel-addons         3.2.2
haxelib install flixel-tools          1.5.1
haxelib install hscript-iris          1.1.0
haxelib install tjson                 1.4.0
haxelib git     flxanimate            https://github.com/Psych-Slice/FlxAnimate.git 18091dfeb629ba2805a5f3e10f5de80433080359
haxelib git     linc_luajit           https://github.com/Psych-Slice/linc_luajit-mobile               # 0.0.8
haxelib git     hxdiscord_rpc         https://github.com/MAJigsaw77/hxdiscord_rpc f9353b9edce10f4605d125dd1bda24ac36898bfb
haxelib install hxvlc                 1.8.2
haxelib git     funkin.vis            https://github.com/FunkinCrew/funkVis 22b1ce089dd924f15cdc4632397ef3504d464e90
haxelib git     grig.audio            https://gitlab.com/haxe-grig/grig.audio.git cbf91e2180fd2e374924fe74844086aab7891666
haxelib git     FlxPartialSound       https://github.com/FunkinDroidTeam/FlxPartialSound 3d1da83cca3863174ca6a56827cd95c2020754bc
```

`linc_luajit` is declared with `<haxedef name="LINC_LUA_RELATIVE_DYNAMIC_LIB"/>` in
`Project.xml`, so the project expects the relative-dynamic-library build of that
library (the upstream fork above).

### Dependency substitutions (verified 2026-10-25)

Four repositories listed above no longer exist (GitHub answers 404 / asks for
credentials when cloning them). Public replacements were found under the
Psych-Slice organisation, and with them the Android build succeeds:

| Upstream CI pin | Unavailable | Used instead | Why it works |
| --- | --- | --- | --- |
| `mcagabe19-stuff/lime` | 404 | `Psych-Slice/lime-mobile` @ `fff2ffb` (Lime 8.1.2 base) | ships the nine `android.*` externs used by `source/import.hx` (`Context`, `Toast`, `Environment`, `Build`, `BatteryManager`, `Permissions`, `Settings`, `Tools`, `callback/CallBack`) plus `lime.utils.JNISafety`, and already bundles `extension-androidtools` |
| `MobilePorting/flixel` @ `p-slice` | 404 | `HaxeFlixel/flixel` 5.8.0 + one-line `include.xml` patch | the engine compiles against the 5.8.0 API; the patch only drops a version guard, see below |
| `mcagabe19-stuff/linc_luajit-rewriten` | 404 | `Psych-Slice/linc_luajit-mobile` @ `bc8cb0b` (0.0.8) | same `llua` API, including `sendErrorsToLua` used by `source/psychlua/CallbackHandler.hx` |
| `mcagabe19-stuff/hxcpp` | 404 | haxelib `hxcpp` 4.3.2 | builds the engine without changes |

`extension-androidtools` is no longer requested by `pslice-mobile/Project.xml`: it
is bundled inside `lime-mobile`, and adding it again makes Lime abort with
"You cannot add extension-androidtools to this Lime because it is already
included". The engine never imports `extension.androidtools.*`.

**Required flixel patch.** `flixel/include.xml` injects
`<application android:appCategory="game" if="${lime &ge; 8.2.0}" />`. Lime only
evaluates `${…}` conditions from 8.2.0 on, so 8.1.2 writes the guard into the
manifest and `&ge;` (not a predefined XML entity) makes the manifest
unparseable. Replace that line with
`<application android:appCategory="game" />`; it is a launcher hint, not a
feature used by the engine. Details, logs and rejected alternatives:
[`pslice-mobile/ANDROID-BUILD.md`](pslice-mobile/ANDROID-BUILD.md).

## Building the Android APK

```bash
haxelib setup ~/haxelib

# 1. libraries (see the list above; same pins as upstream CI)
haxelib git hxcpp https://github.com/mcagabe19-stuff/hxcpp --quiet
# … the remaining entries of the list …

# 2. point Lime at the Android toolchain
haxelib run lime config ANDROID_SDK        "$ANDROID_HOME"
haxelib run lime config ANDROID_NDK_ROOT   "$ANDROID_NDK_ROOT"
haxelib run lime config JAVA_HOME          "$JAVA_HOME"
haxelib run lime config ANDROID_SETUP      true

# 3. build (must run from the project directory — it contains Project.xml)
cd pslice-mobile
haxelib run lime build android -ONLY_ARMV7          # quicker, armv7 only (upstream CI "main")
# or, the signed release configuration used by upstream releases:
haxelib run lime build android -final -D officialBuild

# result:
# pslice-mobile/export/release/android/bin/app/build/outputs/apk/release/PSliceEngine-release.apk
```

Notes:

* Always run `lime build` from **inside `pslice-mobile/`**; `Project.xml` is the
  project file and paths inside it are relative to that directory.
* `-ONLY_ARMV7` is what upstream's `main.yml` uses for its Android artifact; drop
  it to build the additional ABIs (much slower on a small machine).
* Release builds are signed with the upstream development keystore
  `key.keystore` (alias `psliceport`, password `pslice`, as configured in
  `Project.xml`). It is a development key published by upstream — replace it
  before distributing anything.
* The upstream workflows under `pslice-mobile/.github/workflows/` are preserved
  but **inactive**: GitHub only runs workflows from the repository root, and they
  are also path-relative to the project root. To build the engine on GitHub
  Actions, mirror `build.yml`'s steps in a root workflow that sets
  `working-directory: pslice-mobile` (see "Current state" below).

## Changes relative to the original P-Slice Mobile

1. The project was placed in `pslice-mobile/` instead of the repository root.
   No upstream file was edited, deleted or renamed — all 2176 files are
   byte-identical to commit `6762422`.
2. This root `README.md` was rewritten to describe the combined repository, the
   build procedure and the verification results.
3. `pslice-mobile/UPSTREAM.md` was added to record the exact upstream commit and
   the import/verification procedure.
4. The pre-existing FNF Unified prototype files at the root were left untouched.

Nothing else was added: no engine code was written, no Psych/V-Slice support was
re-implemented, and no demo substitutes the imported sources.

## Existing FNF Unified prototype: compatibility assessment

`main` already contained a small FNF Unified menu prototype:

* `source/Main.hx`, `source/core/Engine.hx`, `source/mods/ModInfo.hx`;
* `project.xml` (Lime legacy schema: `<meta>`, `<source path>`, `<assets path>`);
* `assets/images/menu_bg.png`;
* `.github/workflows/android.yml`, which installs current `lime`/`openfl` from
  haxelib and builds that prototype.

It is **not compatible** with the imported engine and was deliberately not
merged into it:

* it is plain OpenFL (Lime + OpenFL only), while P-Slice needs HaxeFlixel plus
  ~16 pinned haxelib forks and native extensions;
* both trees define `project.xml`/`Project.xml`, `source/Main.hx` and
  `assets/` — merging at the root would have overwritten one `Main.hx` with the
  other and silently mixed two incompatible project files;
* the prototype's `android.yml` builds `project.xml` at the root, so leaving it
  in place keeps the prototype buildable and untouched.

Keeping the prototype in its own place therefore preserves it for reference
(menu layout, artwork, mod-info sketch) without risking the engine build.

## Licence and credits

* `pslice-mobile/` — **Apache License 2.0**, see
  [`pslice-mobile/LICENSE`](pslice-mobile/LICENSE). Imported unmodified.
* P-Slice Engine: mikolka9144 and the P-Slice contributors
  (https://github.com/Psych-Slice/P-Slice), mobile port by Moxie-Stuff /
  MobilePorting (https://github.com/Moxie-Stuff/P-Slice-Mobile).
* Psych Engine: Shadow Mario and contributors (https://github.com/ShadowMario/FNF-PsychEngine).
* Friday Night Funkin' and its assets: FunkinCrew (https://funkincrew.com).
  The bundled `assets/` are the upstream game assets and remain subject to their
  own rights; upstream distributes them under the same Apache-2.0 repository
  terms, but review the asset rights before any public release.
* `pslice-mobile/README.md`, `LICENSE` and `gitVersion.txt` are kept exactly as
  upstream shipped them.

## Build verification (executed in a Linux cloud VM on 2026-10-25)

Toolchain used: JDK 17.0.21 (Temurin), Haxe 4.3.6, Neko 2.3.0, Android SDK
`platforms;android-34` + `build-tools;34.0.0` + `ndk;21.4.7075529`, g++ 13.3.
Libraries: `lime` 8.1.2 from `Psych-Slice/lime-mobile`, `openfl` 9.3.3, `hxcpp`
4.3.2, `flixel` 5.8.0 (patched `include.xml`), `flixel-addons` 3.2.2, `flxanimate`,
`hxdiscord_rpc`, `hxvlc` 1.8.2, `funkin.vis`, `grig.audio`, `FlxPartialSound`,
`linc_luajit` from `Psych-Slice/linc_luajit-mobile`.

1. **Project configuration check — PASSED.**

   ```
   haxelib run lime config ANDROID_SDK … / ANDROID_NDK_ROOT … / JAVA_HOME …
   cd pslice-mobile && haxelib run lime display android
   ```

   Lime resolved the project (app `com.mikolka9144.pslice`, main class `Main`) and
   the expected Android defines: `android mobile lime-opengles lime-cairo
   MODS_ALLOWED LUA_ALLOWED HSCRIPT_ALLOWED BASE_GAME_FILES VIDEOS_ALLOWED …`.

2. **APK build — PASSED.**

   ```
   cd pslice-mobile && haxelib run lime build android -ONLY_ARMV7
   ```

   ```
   Link: libApplicationMain-v7.so
   …
   > Task :app:packageRelease
   > Task :app:assembleRelease

   BUILD SUCCESSFUL in 3m 51s
   122 actionable tasks: 122 executed
   ```

   Result:
   `pslice-mobile/export/release/android/bin/app/build/outputs/apk/release/PSliceEngine-release.apk`
   — 718 MiB, 2582 entries (1704 under `assets/`), ABI `armeabi-v7a`,
   `package=com.mikolka9144.pslice`, `versionName=0.1`, `minSdk=21`,
   `targetSdk=35`, signed with the repository keystore
   (`CN=Lily Ross, O=MobilePorting`).

   Earlier runs, kept for the record, failed further upstream in the same
   dependency problem: with stock Lime 8.1.2 the compile died on
   `Type not found : android.content.Context` (8 root errors, 2260 blocks) and
   `lime.ui._Window.WindowBackend has no field setVSync`; with `flixel` 6.1.2 or
   4.11.0 `flixel-addons` 3.2.2 refused the version; and before the `include.xml`
   patch the build reached Gradle but `:app:processReleaseMainManifest` could not
   parse the generated manifest. All three are resolved by the substitutions in
   the table above.

3. **Import integrity — PASSED.** 2176/2176 files match the upstream git blob
   hashes (re-checked with `git ls-files -s` against the upstream tree).

## Known issues and incompatibilities

1. **The build needs a patched haxelib.** `flixel` must be installed from a git
   checkout and its `include.xml` patched once (see "Dependency substitutions");
   a plain `haxelib install flixel` will not do. `lime` must be
   `Psych-Slice/lime-mobile`, not a release from lib.haxe.org.
2. **The engine was never validated against upstream CI here.** Upstream builds
   Android on `macos-14` with `-ONLY_ARMV7` / `android -final -D officialBuild`;
   the verified build used Linux + NDK 21.4, so the upstream CI path itself
   remains unproven.
3. **Only `armv7` was attempted.** Other ABIs (`arm64`, `x86_64`) were not built;
   `-ONLY_ARMV7` is what upstream's `main.yml` publishes.
4. **Signing uses the upstream development keystore** (`key.keystore`, alias
   `psliceport`, password `pslice`). Replace it before distributing builds.
5. **Root workflows do not build the engine.** `.github/workflows/android.yml`
   still builds the legacy prototype only; upstream's engine workflows sit in
   `pslice-mobile/.github/workflows/`, where GitHub does not run them.
6. **Repository size.** The import is ~1 GB (982 MB of game assets). Pushing this
   branch is slow and GitHub warns above 1 GB of repository size; the assets
   could later be split into a release artifact if that becomes a problem.
7. **Platform integration is not ported.** The old prototype's `core/` and
   `mods/` sketches are not wired into the engine; no Psych/V-Slice feature work
   was started, as requested.

## Current state

* Import of the upstream tree: **done and verified** (2176/2176 files match the
  upstream git blob hashes).
* `lime display android` (project configuration): **passes**.
* Android APK build: **passes** with the substitution set above —
  `PSliceEngine-release.apk`, 718 MiB, armv7. See "Build verification".
* Not verified yet: other ABIs, a real device run, and building the engine from
  GitHub Actions (the root workflow still targets the old prototype).

