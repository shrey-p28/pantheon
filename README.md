# Pantheon — Petpooja's design system for Claude

This repo ships **Pantheon**, Petpooja's design system, as a Claude plugin. Install it once and every visual or branded thing Claude makes for you — UI mockups, docs, decks, dashboards, marketing assets — automatically comes out on-brand: Pantheon tokens, Prometheus typography, the right components, the restrained editorial tone.

You set it up once and then forget about it. It keeps itself in sync with the Pantheon Figma file every week, automatically.

The repo currently contains one plugin:

- **`pantheon-design-system`** — the full Pantheon cheat-sheet Claude reads before producing anything visual. Tokens, Prometheus type, 47-component library, 8 accent families, 4 themes, strict non-invention, weekly auto-sync against the Figma file.

---

## Quick install (new teammate, ~2 minutes)

**Prerequisites:**
- Claude Code OR Cowork (the desktop app). Both work.
- Figma desktop with the Pantheon file opened at least once, and **Dev Mode MCP enabled** (Figma → Preferences → "Enable Dev Mode MCP Server").
- macOS or Linux. (Windows works for the plugin itself — just no weekly scheduled task; the in-session auto-sync still runs.)

**Steps:**

1. Open Claude Code or start a new Cowork conversation.

2. Subscribe to this repo:
   ```
   /plugin marketplace add petpooja/pantheon
   ```
   Replace `petpooja/pantheon` with wherever Shrey pushed the repo (e.g. `gitlab:petpooja-internal/pantheon` or a full Git URL). Ask if unsure.

3. Install the plugin:
   ```
   /plugin install pantheon-design-system@pantheon
   ```

4. Restart your Claude session (plugins load at session start).

5. Run the one-time bootstrap:
   ```
   /pantheon-bootstrap
   ```
   It verifies your Figma MCP is reachable, runs the first sync against the Pantheon Figma file, and schedules the weekly auto-update on your machine. If anything fails it tells you exactly what to fix (usually just "open the Pantheon Figma file and enable Dev Mode MCP").

That's it. You're done.

> **Note on the `/plugin marketplace` command.** That's just Claude's CLI wording for "subscribe to a plugin repo" — you only type the word once, during install. Day-to-day you'll never see it again.

---

## Using it day-to-day

Just ask Claude for anything visual, branded, design-adjacent, or documenty. The skill triggers automatically on keywords like UI, component, mockup, dashboard, Figma, design, brand, token, color, typography, Pantheon, and dozens more (including component names like Button, Card, Chips, Segment). You don't have to say "Pantheon" — the plugin does that for you.

Examples that will auto-apply Pantheon:

- "Draft a pricing card in React for our POS upsell"
- "Write a product-launch one-pager for Pay"
- "Make a dashboard showing weekly MRR with a chart"
- "Draft the slides for the Monday leadership review"
- "Write the error copy for a failed payment"

If Claude ever misses on a visual task (shouldn't happen, but), just say "use Pantheon" or "make it on-brand" and it will snap in.

---

## Weekly auto-update — how it works

Shrey maintains Pantheon in Figma. That's the only source of truth. The plugin pulls from Figma on each teammate's machine, on a rolling weekly cadence:

- **In-session auto-sync (default, works everywhere).** On your **first visual prompt each week**, the `pantheon-enforce` hook notices the sync log is more than 7 days old and silently runs `/sync-pantheon` before answering. The sync queries your local Figma Dev Mode MCP, diffs against the plugin's reference files, and patches anything that changed. It logs a dated entry — which resets the clock for another week. Average overhead on the triggering prompt: ~15–25 seconds, once per week. Other prompts in the same week have zero overhead.

- **Real scheduled task (Cowork).** `/pantheon-bootstrap` also registers a Cowork scheduled task named `pantheon-weekly-sync` that runs `/sync-pantheon` every Monday 09:00 local. Redundant with the hook, but means the sync also happens on weeks when you never sent a visual prompt.

- **Real scheduled task (Claude Code terminal on macOS).** `/pantheon-bootstrap` installs a macOS LaunchAgent (`com.petpooja.pantheon-sync`) that runs the sync headlessly every Monday 09:00 via Claude Code's non-interactive mode. Logs live in `~/.claude/logs/pantheon-sync.stdout.log`.

If the Figma MCP is unreachable when a sync kicks off (Figma closed, Dev Mode MCP disabled), the sync logs a clean failure and bows out — no crash, no nagging popup. Next time you open Figma and send a visual prompt, the hook retries.

---

## What you're not in charge of

You (the teammate) don't have to:
- Re-install the plugin when Pantheon changes.
- Manually pull reference files.
- Remember to run a sync command.

All of that's automated.

---

## What to do if something looks off

1. **Claude is using an old token or missing a new component.** Your local sync hasn't run yet this week (or Figma wasn't open when it tried). Open the Pantheon Figma file in Figma desktop, then run `/sync-pantheon` manually. Takes ~20s.

2. **Claude invented a component that's not in Pantheon.** The skill is configured to refuse this and ask for a Pantheon-native alternative, but if it slips through: reply with "use a Pantheon-native alternative — don't invent new components", and ping Shrey so we can tighten the skill.

3. **Auto-sync keeps failing.** Check the log: `cat ~/.claude/logs/pantheon-sync.stderr.log` (terminal users) or the scheduled task's last-run details in Cowork. Most common cause: Figma desktop not open when the task fired. Open Figma, then `/sync-pantheon`.

4. **I want to update to a newer plugin version.**
   ```
   /plugin marketplace update
   /plugin update pantheon-design-system
   ```
   Or wait for it — Cowork refreshes plugins on session start.

5. **I want to uninstall.**
   ```
   /plugin uninstall pantheon-design-system
   /plugin marketplace remove pantheon
   ```
   For terminal users, also remove the LaunchAgent: `launchctl unload -w ~/Library/LaunchAgents/com.petpooja.pantheon-sync.plist && rm ~/Library/LaunchAgents/com.petpooja.pantheon-sync.plist`

---

## Brand identity at a glance

- Brand color `#1770ee` (Petpooja blue)
- Typeface Inter (branded Prometheus). Letter-spacing 0 everywhere.
- 8 accent families: Aqua, Beige, Green, Yellow, Navy Blue, Orange, Pink, Purple
- 4 themes: POS Light (default), POS Dark, Billing, Payroll
- Tone: clean, editorial, generous whitespace, restrained palette. No gradients, no drop shadows except `Elevation/3` on Pop Ups.

---

## Contact

- **Owner / maintainer:** Shrey, Senior Product Designer, Petpooja — shrey@petpooja.com
- **Updating the plugin itself:** see `MAINTAIN.md`.
- **Pantheon Figma file:** https://www.figma.com/design/l8qALS4HQUMbSTyP8BTGRL/Pantheon
