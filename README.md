# Filltron

A [schwung](https://github.com/charlesvestal/schwung) module for the Ableton
Move: Elektron-style **fills** for live audio. Capture a quantized loop,
let seeded randomness glitch it — then hold a pad to drop a second,
stutter-heavy fill pattern over the top, exactly like holding [FILL] on an
Analog Rytm or Syntakt.

Built on [Smack](https://github.com/timncox/schwung-smack)'s loop-glitch
engine; Filltron is the fill-first cut of it.

## The fill

Two seeded pattern layers live on every captured loop:

- the **main pattern** (per-slice effects + slice reorder, at your chosen
  densities) — the "not fill" layer, playing whenever Fill is off
- the **fill pattern** — an independent seeded roll, biased 50% toward
  stutter effects (retrigger, reverse, speed, gate, buzz, repeat,
  reverse-after, tape stop), that sounds **only while Fill is active**

Three ways to fire it, matching the Elektron gestures:

| gesture | result |
|---|---|
| **hold** the Fill pad | fill while held, release = back (momentary) |
| **tap** the Fill pad | fill latched until you tap again |
| **Fill 1x** (knob trigger) | fill through the rest of this loop pass, auto-off at the wrap |

Fill flips are quantized (instant / slice / loop, same gate as A/B), work
over the clean A side too, and re-roll deterministically with the Seed —
the same seed always gives the same fill. **Fill Amt** sets how busy the
fill gets (fx density; slice reordering rides at half of it).

## Everything else

The full Smack feature set underneath: retroactive capture (grab the last
1 step–16 bars you just played) or arm-and-record, clock-synced with
free-run fallback; grid slicing at 1/2-step to 4-step resolution; 22 slice
effects; seeded patterns browsable by number; A/B punch; step-LED pattern
display with playhead chase and per-slice mutes; module presets; on-device
help; screen-reader accessible.

Works in Signal Chain slots **and** Master FX slots (glitch and fill the
whole Move mix).

## Chain UI

- Pads: 68 Capture / 69 Arm / 70 A-B / 71 Re-Roll / 76 Clear /
  **77 Fill** (yellow; tap = latch, hold = momentary)
- Steps 1–16: pattern colors + playhead; the **fill pattern shows while
  Fill is active**; press a step to mute/restore its effect
- Knobs 1–8: FX Density / Order / Loop Len / Slice Res / Wet / Pitch /
  **Fill Amt** / Seed

On Master FX, the knob-page hierarchy is the interface: Main, Perform,
**Fill** (Fill / Fill 1x / Fill Amt), and Setup pages.

## Build

- `make test` — native compile of the engine + a simulated host
  (clock, capture, A/B, fill, preset assertions). No hardware needed.
- `make arm` — Docker cross-compile for the Move (aarch64), produces
  `build/filltron-module.tar.gz`.
- `scripts/deploy.sh` — scp onto the Move for development.

Install on a Move via schwung-manager's **Install Custom Module** with
this repo's URL (it resolves `release.json`), or upload the tarball.

## Setup prerequisite

Set Move's **MIDI Clock to Out** (same as the Arp) so Filltron locks to
the transport. Without it, it free-runs at the project tempo.

MIT.
