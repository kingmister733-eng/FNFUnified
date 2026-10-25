# Mod Formats

## Psych Engine
- Typically contains a `data/` folder with charts/songs.
- May contain `scripts/` (Lua/HScript) — not yet supported.
- Detected when `data/` is present.

## V-Slice (official FNF)
- Typically contains a manifest (`manifest.json`/`_meta.json`) and `assets/`.
- Detected when manifest + assets are present.

Detection is best-effort (`mods.ModFormatTools.detect`).
