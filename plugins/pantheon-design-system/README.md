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

For distribution via the `petpooja-design` marketplace repo, follow the **team README** at the repo root. Short version:

```
/plugin marketplace add <owner>/<repo>
/plugin install pantheon-design-system@petpooja-design
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

Pantheon design system created and maintained by Shrey.

## Version

1.1.0 — adds automatic weekly re-sync (hook + /pantheon-bootstrap + LaunchAgent installer) and strict non-invention enforcement.
