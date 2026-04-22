# Pantheon Design System plugin

Petpooja's Pantheon design system as a Claude plugin. Install once and every visual or branded task Claude produces — UI mockups, docs, decks, dashboards, marketing assets — automatically follows Pantheon: tokens by name, Prometheus typography, Pantheon components, and the restrained editorial tone the system is built around.

The plugin also keeps itself fresh: every teammate's first visual prompt each week (and/or a real scheduled weekly task, depending on runtime) silently re-runs `/sync-pantheon` against their own local Figma. Whatever you add, edit, or delete in the Pantheon Figma file shows up in everyone's Claude within a week — no manual handoff.

## What's inside

- **Skill `pantheon-design-system`** — the full Pantheon cheat-sheet (tokens, Prometheus type, 47 component sets, 8 accent families, theme-awareness, pre-flight checklist, component-first rules, anti-patterns, strict non-invention). Loads automatically on visual / UI / brand prompts. Reference files (tokens, components, inventory, raw variable dumps, sync log) load on demand.
- **Slash command `/sync-pantheon`** — re-digests the Pantheon Figma file and patches the reference files. Run it whenever a component or token changes in Figma, or let the hook auto-run it for you once a week.
- **Slash command `/pantheon-bootstrap`** — one-time setup for new teammates. Verifies the Figma MCP is reachable, runs the first sync, then schedules the weekly auto-update (Cowork scheduled task or macOS LaunchAgent).
- **UserPromptSubmit hook `pantheon-enforce.sh`** — fires on every prompt. On visual/branded prompts it injects a Pantheon reminder so the skill never silently skips. It also checks the sync log: if Pantheon hasn't been re-synced in more than 7 days, it instructs Claude to run `/sync-pantheon` silently before answering. Self-regulating — the sync writes a dated entry which resets the timer for another week.
- **`scripts/install-launchagent.sh`** — one-command macOS LaunchAgent installer for Claude Code terminal users. Creates a Monday-09:00 headless sync. Idempotent.

## Install

For distribution via the `pantheon` repo, follow the **team README** at the repo root. Short version:

```
/plugin marketplace add <owner>/pantheon
/plugin install pantheon-design-system@pantheon
/pantheon-bootstrap
```

Then start a new Claude conversation and ask for anything visual.

For local dev, drag the `.plugin` zip into Cowork or unpack into `~/.claude/plugins/cache/pantheon-design-system/`.

## Updating Pantheon from Figma

1. **Automatic weekly (recommended).** On each teammate's first visual prompt of the week, the hook auto-triggers `/sync-pantheon`. In Cowork you can also schedule it as a real recurring task via `/pantheon-bootstrap`. In Claude Code terminal a LaunchAgent runs it Monday 09:00.
2. **Ad-hoc.** Run `/sync-pantheon` any time. Takes ~20s.
3. **Push from the system side.** When you ship a Pantheon change, bump the plugin version and push to the marketplace repo. Teammates pull via `/plugin marketplace update`. See `MAINTAIN.md` in the marketplace repo.

## Brand identity (non-negotiable)

- Brand color `#1770ee` (Petpooja blue)
- Typeface Inter (branded as Prometheus). Letter-spacing 0 everywhere.
- 8 accent families: Aqua, Beige, Green, Yellow, Navy Blue, Orange, Pink, Purple
- 4 themes: POS Light (default), POS Dark, Billing, Payroll
- Tone: clean, editorial, generous whitespace, restrained palette. No gradients, no drop shadows (except `Elevation/3` on Pop Up).

## Maintainer

Pantheon design system maintained by Shrey, Senior Product Designer, Petpooja · shrey@petpooja.com

## Version

1.3.2 — fix Text Input label rendering pattern. Pantheon's `Text Input` is Material Design 3's **outlined text field with a floating notched label**, not a stacked `<label>` row above the field. The label lives inside the field's border: when the field is empty and unfocused it sits at vertical center and acts as the placeholder; when the field is focused or has a value, the label floats up and notches through the top border at 12px inset from the left. The stacked-label pattern (shadcn / Tailwind default) was the most common Pantheon-violation in generated UI. Corrected in SKILL.md ("Three hot spots" Text Input subsection, new state-dependent label position table, notch geometry, fieldset/legend HTML skeleton, new anti-patterns: stacked label row, continuous top border with external label, Material "filled" variant, focus glow ring). `references/components.md` Text Input spec rewritten to match — composition now uses `<fieldset>` + `<legend>` so the native notched border renders automatically (same approach MUI `OutlinedInput` and Material Web Components use).

1.3.1 — fix Text Input Small height: 36, not 32. `Text Input` Size scale is 36 / 40 / 48 (Small / Medium / Large). Corrected in both SKILL.md "Three hot spots" section and `references/components.md` Text Input spec. The 32px height is Button Extra Small, not Text Input Small — they don't share a scale.

1.3.0 — SKILL.md tightened around three recurring failure modes. Dedicated "Three hot spots" section now spells out the `Text Input` spec exactly as it ships in Figma (height 32/40/48 by Size, 8px radius via `Square/Small`, 1px flat border with per-state token, label always above in `Label/Small-Medium`, supporting text below, no glowing focus rings, no pill shape, no placeholder-as-label) so Claude stops shipping generic HTML-ish inputs. Icons are now required to come from the Pantheon Outline (3,857) or Filled (3,845) sets, named by their Material Symbols key, sized from the 16/18/20/24 Width scale, coloured from `Icon/*` tokens — never invented as ad-hoc SVG, never from the Depreciated set. Emoji are forbidden in every visual output (React/HTML, docx, pdf, pptx, posters, dashboards, marketing); where an emoji is the quick habit, the matching Outline icon replaces it. Every artifact must end with a compact `Pantheon components used:` footer listing the component sets, icon names/sets, tokens, and Prometheus composites pulled from the Figma library, making traceability mechanical. `references/components.md` Text Input section already carried the spec; the change is lifting it into SKILL.md so it's read on every visual prompt.

1.2.3 — `/pantheon-bootstrap` drops the Figma identity/auth check entirely. It was originally added to help teammates notice if the Figma connector had been OAuth'd on someone else's token, but in practice the check added noise (false mismatches against Cowork email, stale warnings) without catching meaningful problems. Teammates confirm the account when they connect the Figma MCP in Cowork; no need to re-verify on every bootstrap. Bootstrap is now three jobs: Figma MCP reachability, first sync, schedule weekly auto-sync.

1.2.2 — `/pantheon-bootstrap` no longer programmatically compares the Figma MCP identity against the teammate's Cowork / SSO email. A mismatch there is normal (Cowork login, Figma login, SSO email, and GitHub handle often differ for the same person) and the previous auto-compare was producing false-alarm `⚠️` flags. The bootstrap now surfaces the Figma identity + the teams-on-file list and trusts the teammate to eyeball it.

1.2.1 — maintainer + ownership rename: all references to the previous owner replaced with Shrey (senior product designer, Petpooja · shrey@petpooja.com) across SKILL.md, READMEs, marketplace manifest, and the sync log. No behavior change.

1.2.0 — `/sync-pantheon` runs in evidence-only mode (every patched value cites a literal MCP source + a literal pre-patch file value, no narrative summaries, mandatory verification re-read). `/pantheon-bootstrap` now surfaces the authenticated Figma user prominently and asks the teammate to confirm it's their account before relying on sync output.

1.1.0 — adds automatic weekly re-sync (hook + /pantheon-bootstrap + LaunchAgent installer) and strict non-invention enforcement.
