# Android build status: dependencies and remaining blocker

Audit of `haxelib run lime build android` for the imported P-Slice Mobile tree.
Environment used for every result below (Linux x86_64):

| Tool | Version |
|---|---|
| Haxe | 4.3.6 |
| Neko | 2.3.0 |
| hxcpp | 4.3.2 |
| JDK | 17.0.21 |
| Android SDK / build-tools | 34 / 34.0.0 |
| Android NDK | 21.4.7075529 |
| g++ | 13.3 |

Build command:

```
haxelib run lime build android -ONLY_ARMV7
```

## 1. Where the build stands

With the dependencies below and the one-line flixel patch from §3, the Android
build now completes end to end:

```
Link: libApplicationMain-v7.so
...
> Task :app:packageRelease
> Task :app:assembleRelease

BUILD SUCCESSFUL in 3m 51s
122 actionable tasks: 122 executed
```

Artifact: `export/release/android/bin/app/build/outputs/apk/release/PSliceEngine-release.apk`
(718 MiB, 2582 entries, 1704 files under `assets/`), signed with the keystore
shipped in the repository (`CN=Lily Ross, O=MobilePorting`),
`package=com.mikolka9144.pslice`, `versionName=0.1`, `minSdk=21`,
`targetSdk=35`, ABI `armeabi-v7a` (`-ONLY_ARMV7`).

sha256: `d5584c0605c999584d7986233beff71d00c84f1e69f07e6094e7e4c8cca296f0`

Before the flixel patch the build died one step earlier, in
`:app:processReleaseMainManifest` (`Error parsing .../AndroidManifest.xml`);
see §3. No source file of P-Slice Mobile was changed to make the build pass and
no Android feature was removed.

## 2. Dependency matrix

| `Project.xml` entry | Resolution used | State |
|---|---|---|
| `lime` (`git`) | `Psych-Slice/lime-mobile` @ `fff2ffb1b036c1c865cfade5889fea81c7424314` | **works** — this is the fork that replaces `mcagabe19-stuff/lime`; it supplies the `android.*` externs and `JNISafety` |
| `flixel` (`git`) | upstream `HaxeFlixel/flixel` tag `5.8.0` | **works**, but its `include.xml` breaks the manifest (see §3) |
| `linc_luajit` (`git`) | `Psych-Slice/linc_luajit-mobile` @ `bc8cb0b` | **works** — public repo, `Lua.sendErrorsToLua` is present |
| `extension-androidtools` | removed from `Project.xml` | **fixed** — already bundled inside `lime-mobile` |
| `flixel-addons` | `3.2.2` | works |
| `tjson` / `hscript-iris` / `hxvlc` / `flxanimate` | `1.4.0` / `1.1.0` / `1.8.2` / lib.haxe.org release | works |
| `FlxPartialSound`, `grig.audio`, `funkin.vis` | `git` / lib.haxe.org | works |

### Why the three named forks were "missing"

* They are not published to lib.haxe.org under the names the project uses, so a
  plain `haxelib install` cannot resolve them.
* `mcagabe19-stuff/*` forks referenced by the original tree are gone or private;
  the maintained replacements live under the Psych-Slice organisation and are
  public, so `haxelib git` on them is enough.
* `lime` needs a fork at all, not just any release: the engine's own overrides
  (`source/lime/*`, `source/mobile/backend/PsychJNI.hx` with
  `implements JNISafety`) and the `android.*` externs only exist in
  `lime-mobile`. A stock Lime 8.1.2 aborts with
  `lime.ui._Window.WindowBackend has no field setVSync` and
  `Type not found : android.content.Context`.

### `android.*` externs

`lime-mobile` ships exactly the nine extern files the engine imports:

```
android/Permissions.hx   android/Settings.hx   android/Tools.hx
android/callback/CallBack.hx      android/content/Context.hx
android/os/BatteryManager.hx      android/os/Build.hx
android/os/Environment.hx         android/widget/Toast.hx
```

## 3. Remaining blocker: `appCategory` attribute in the manifest

`flixel/include.xml` (all maintained branches: 5.6.2, 5.7.2, 5.8.0) contains:

```xml
<config:android>
    <application android:appCategory="game" if="${lime &ge; 8.2.0}" />
</config:android>
```

Lime evaluates `${...}` conditions only from 8.2.0 on. `lime-mobile` is based on
8.1.2, so the attribute is copied verbatim into the generated manifest:

```xml
<application ... if="lime &ge; 8.2.0" android:appCategory="game" ... >
```

`&ge;` is not a predefined XML entity, so `aapt`/manifest-merger cannot parse
the file — this is the `processReleaseMainManifest` failure.

### Fix applied (one line)

In the installed flixel haxelib, replace that line with:

```xml
<application android:appCategory="game" />
```

`android:appCategory` is a launcher hint for Android TV/leanback on API 26+. It
is not read anywhere in the engine source and dropping the version guard keeps
the attribute intact on devices that support it.

Because `flixel` is declared `version="git"`, the patch has to be applied after
`haxelib git flixel ...`; make it part of the dependency setup step:

```sh
sed -i 's|if="${lime &ge; 8.2.0}" ||' "$(haxelib path flixel | head -1)/include.xml"
```

Alternative (not recommended): move to Lime ≥ 8.2 so the guard is honoured —
`lime-mobile` has a single `master` branch based on 8.1.2, and the engine's
`source/lime/*` overrides and `JNISafety` usage are tied to it.

### Rejected alternatives

* Downgrading flixel — the same line exists back to 5.6.2; 5.9.0 emits
  `appCategory` unconditionally.
* Dropping `<application>`/Android code to make the build pass — out of scope:
  the aim is a real APK of the unmodified engine.

## 4. Reproducing the current state

```sh
# JDK 17, Android SDK 34 + build-tools 34.0.0 + NDK 21.4.7075529 must be exported
haxelib git lime https://github.com/Psych-Slice/lime-mobile
haxelib git linc_luajit https://github.com/Psych-Slice/linc_luajit-mobile
haxelib git flixel https://github.com/HaxeFlixel/flixel 5.8.0
haxelib git FlxPartialSound https://github.com/...        # as declared in Project.xml
haxelib run lime build android -ONLY_ARMV7
```

Then apply the one-line flixel patch from §3 and re-run the build.

## 5. What is still not covered

* Only `armeabi-v7a` is built (`-ONLY_ARMV7`). `-ONLY_ARM64`, `x86` and the
  fat build have not been verified.
* The build is a local one-shot: nothing in `.github/workflows` builds this tree
  (the engine workflows live in `pslice-mobile/.github`, which GitHub does not
  run, and the root workflow still targets the old prototype).
* Dependency pins are still `version="git"` in `Project.xml`; the exact
  fork+commit combination that works is recorded here and in §2, not enforced
  by the project file.
* Nothing was tested on a real device or emulator, so runtime behaviour of the
  engine is unverified.
