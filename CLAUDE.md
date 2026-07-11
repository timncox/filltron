---
status: active
last_touched: 2026-07-11
---

# Filltron

Schwung module for the Ableton Move: the fill-first cut of Smack — a
quantized loop glitcher whose headline feature is an Elektron-style Fill
(second seeded, stutter-biased pattern layer on a performance pad, with
momentary/latch/one-pass gestures).

## Lineage — read this first

Extracted 2026-07-11 from `~/tim-os/smack` branch `feat/fill`
(timncox/schwung-smack#1). The engine files keep their `smack_*` names on
purpose — minimal diff from the tested source of truth. Only the module
identity differs: id `filltron`, dsp `filltron.so` (the chain host loads
`modules/audio_fx/<id>/<id>.so`), UI title/announcements, help title.

**Divergence warning:** smack's `main` moved past this snapshot the same
day (dual-mono `smack_lane_t` refactor, smack v0.5.0). Filltron is based
on the pre-lane core + fill. If fill lands in smack (PR #1 rebase) or
filltron should gain dual-mono, port deliberately — the cores are no
longer line-compatible. See `~/tim-os/smack/CLAUDE.md` and memory
`project-smack` for the collision notes.

All Smack engine gotchas apply verbatim (MIDI via
`dlsym("move_audio_fx_on_midi")`, trigger params fire on value change and
read back "0", seed determinism = never change RNG draw counts in
`roll_fxp`/`roll_pattern`, Move MIDI Clock must be Out). Fill design notes
(independent RNG stream, quantize gating, fill_once wrap semantics, fill
never preset-saved) are documented in the smack CLAUDE.md "Fill" section
and mirrored in code comments here.

## Build / test / deploy

- `make test` — native host simulation, includes the fill assertion suite.
- `make arm` (= `scripts/build.sh`) — Docker cross-compile
  (debian:bookworm + gcc-aarch64-linux-gnu) → `build/filltron-module.tar.gz`.
- `scripts/deploy.sh` — scp to `ableton@move.local` for development.

## Release process (single repo)

Source and distribution both live here (timncox/filltron): bump
`modules/audio_fx/filltron/module.json` version + root `release.json`,
`make arm`, commit/push, `gh release create vX` with
`build/filltron-module.tar.gz`. The schwung installer resolves this
repo's `release.json` → the release asset.

Not in the schwung catalog (charlesvestal/schwung PR) — add only after
hardware verification, and note smack/smack-in/oversmack already have
entries in PR #156.

## Not yet verified on hardware

Everything the smack feat/fill branch hadn't verified: chain UI, the Fill
pad's momentary release (needs pad note-off events — 0x80 or 0x90 vel 0 —
to reach onMidiMessageInternal; tap-latch works regardless), and the
v0.3.3+/v0.4.x engine additions it inherited.
