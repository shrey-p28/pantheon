# Pantheon skill — update log

Append-only audit trail. Every time the skill is re-synced against Figma — manually, via `/sync-pantheon`, or via the scheduled LaunchAgent — drop an entry here with the date, the trigger, what changed, and who ran it.

The hook reads the most recent `date:` line to compute staleness and may remind Claude if the skill is older than 14 days.

---

## 2026-04-20 — Manual patch (v1.1)
- **Trigger:** Grish delivered Variables-panel screenshots for the four previously-unrecoverable accent ramps (Pink, Purple Light, Purple Dark, Orange, Navy Blue).
- **Who:** Claude + Grish, Cowork session.
- **Changes:**
  - `references/tokens.md`: added full 9-step ramps for Pink, Purple (Light + Dark), Orange, Navy Blue. Added POS Dark column to Gray ramp (`Gray-0 = #0E0E19`, `Gray-1000 = #FFFFFF`). Rewrote Surface / Text / Border / Icon / Notch / Chips / Card semantic tables with accent variants. Expanded Success ramp from 3 steps to 9 steps. Corrected per-alias steps (`Text/Accent-Pink` → Pink-600; `Notch/Accent-Green` → Green-600; `Border/Accent-Purple` → Purple-500).
  - `SKILL.md`: replaced "only 4 accent families" claim with correct 8-family palette. Added pre-flight checklist. Added component-first rule + anti-patterns block. Added theme-awareness section.
- **Gaps closed:** Pink / Purple / Orange / Navy Blue accent ramps, POS Dark Gray inversion, Success ramp full range.
- **Gaps remaining:** none known. If Figma adds a new component set, `/sync-pantheon` will catch it.

## 2026-04-15 — Initial extraction (v1.0)
- **Trigger:** First build of the skill.
- **Who:** Claude, from `get_metadata` full-file dump.
- **Changes:** Baseline extraction of 23 pages, 47 component sets, 1,655 variants, all semantic tokens, primary primitive ramps.
- **Gaps remaining at the time:** Pink / Purple / Orange / Navy Blue ramps (not in swatch frames), Success ramp placeholder rows.
