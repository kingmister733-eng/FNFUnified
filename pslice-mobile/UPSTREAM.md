# Upstream provenance — P-Slice Engine Mobile

This directory is a verbatim import of the upstream **P-Slice Mobile** project.
No source file, asset, licence or configuration file was edited during the import.

## Exact upstream commit

| Field | Value |
| --- | --- |
| Repository | https://github.com/Moxie-Stuff/P-Slice-Mobile |
| Upstream fork of | https://github.com/Psych-Slice/P-Slice (Apache-2.0) |
| Branch | `master` |
| Commit | `676242263db2389332b22a58fab2a841298c0f29` |
| Commit date | 2024-10-25T18:58:09Z |
| Commit subject | `Merge branch 'master' of https://github.com/MobilePorting/P-Slice-Mobile` |
| Commit author | Lily <egzozu.be.bas@gmail.com> |
| Licence | Apache License 2.0 (see [`LICENSE`](LICENSE)) |
| Upstream `gitVersion.txt` | `2.0` |

The commit above is the tip of `master` in the upstream repository at import time
(`git ls-remote` reported `refs/heads/master = 6762422…`, verified on 2026-10-25).

## How the import was performed and verified

1. The file tree of the commit was read through the GitHub tree API
   (`/git/trees/676242263db2389332b22a58fab2a841298c0f29?recursive=1`).
2. Every blob (2176 files, 996,942,842 bytes) was downloaded from
   `raw.githubusercontent.com` pinned to that commit and cached locally.
3. Each downloaded file was checked against the git blob SHA-1 from the tree
   before being copied into this directory (`blob <size>\0<content>` hash).
4. After `git add`, every staged path in this directory was compared against the
   upstream tree again: **2176/2176 files match, 0 missing, 0 extra, 0 hash
   mismatches.**
5. File modes from the upstream tree were preserved (`100644` / `100755`).

The import therefore contains the actual upstream working tree at that commit —
engine sources, Android project configuration, assets, artwork, example mods,
CI workflows and the signing keystore — and not a re-implementation or a stub.

## Inventory

| Path | Files | Size | Contents |
| --- | --- | --- | --- |
| `source/` | 274 | 2.2 MB | 272 Haxe files, ~76,900 lines: `backend/`, `mobile/`, `psychlua/`, `objects/`, `states/`, `substates/`, `cutscenes/`, `options/`, `shaders/`, `flixel/`/`openfl/`/`lime/` overrides, `external/` |
| `assets/` | 1868 | 982.9 MB | `base_game/`, `shared/`, `week_assets/`, `songs/`, `videos/`, `fonts/`, `embed/`, `translations/`, `secrets/` |
| `art/` | 17 | 11.8 MB | icons, splash art, documentation screenshots |
| `example_mods/` | 2 | — | example mod shipped with the engine |
| `.github/` | 5 | — | upstream CI: `build.yml`, `main.yml`, `mobile-release.yml` |
| root files | 8 | — | `Project.xml`, `LICENSE`, `README.md`, `gitVersion.txt`, `hxformat.json`, `key.keystore`, `.gitignore`, `.gitattributes` |

## What was deliberately not imported

* The upstream git history (`.git/`). This repository records the upstream
  commit in this file and in the root `README.md` instead; there are no
  submodules in the upstream tree.
* Nothing else. No upstream file was removed or modified, including `LICENSE`
  and the upstream `README.md`; this `UPSTREAM.md` is the only file added.

## Differences from the original repository

* The project now lives in `pslice-mobile/` instead of the repository root, so
  the existing FNF Unified prototype files at the root stay intact.
* Upstream CI workflows are kept at `pslice-mobile/.github/workflows/`, but
  GitHub only runs workflows from the repository root, so they are **inactive**
  in that location. See the root `README.md` for the build instructions used by
  this repository.
* Everything else is byte-identical to commit `6762422`.
