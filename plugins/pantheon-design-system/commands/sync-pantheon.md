---
description: Re-digest Pantheon from Figma and patch the local skill with any changes (tokens, components, ramps).
allowed-tools: Read, Edit, Write, Glob, Grep, Bash, mcp__figma-local__get_metadata, mcp__figma-local__get_variable_defs, mcp__figma-local__get_screenshot
---

You are syncing the local **pantheon-design-system** skill against the current state of Figma. The goal is to detect drift between what's in the skill's reference files and what's live in the Pantheon Figma file, then patch the skill.

## Source of truth

- Figma file: `https://www.figma.com/design/l8qALS4HQUMbSTyP8BTGRL/Pantheon`
- File key: `l8qALS4HQUMbSTyP8BTGRL`
- Skill location: `~/.claude/skills/pantheon-design-system/`
- Key reference files to compare against:
  - `references/tokens.md` — tokens, ramps, typography, sizing
  - `references/components.md` — component inventory, variants, states
  - `references/full_inventory.md` — node IDs, variant counts

## Steps

1. **Confirm the Figma MCP is connected.** If `mcp__figma-local__get_metadata` is unavailable, stop and tell Shrey to run the Figma desktop app with Dev Mode MCP enabled. Nothing else in this flow works without it.

2. **Full-file metadata dump.** Call `mcp__figma-local__get_metadata` with `nodeId=0:0`. The result is huge (>1M chars) — spawn a subagent to parse it. Ask the subagent for:
   - A list of every page and its node ID.
   - Per page: every top-level frame name + node ID.
   - Every component set name + variant count + node ID.
   - Every swatch frame on the Colors page with the full hex list (top-to-bottom = step 100 → 900).

3. **Pull variables per page.** For each token-rich page (Colors, Typography, Buttons, Text Input, Cards, Icons, Spacing/Sizing), call `mcp__figma-local__get_variable_defs` with the page node ID. Save the raw output to a scratch file.

4. **Diff against the skill.**
   - Compare the page / component-set / token inventory to `references/full_inventory.md` and `references/components.md`. Flag any new, removed, or renamed pages, component sets, or variants.
   - Compare every swatch hex against `references/tokens.md`. Flag any primitive ramp hex that no longer matches.
   - Compare every semantic alias (`Text/*`, `Surface/*`, `Border/*`, `Icon/*`, `Buttons/*`, `Chips/*`, `Card/*`, `Notch/*`) against `references/tokens.md`. Flag any resolution change.
   - Compare Prometheus composites (font, size, line-height, weight) against `references/tokens.md`.

5. **If a primitive ramp is missing hexes** (swatch frame absent — this is what happened with Pink/Purple/Orange/Navy Blue originally), try `get_variable_defs` on the Colors page. If that still doesn't resolve it, call `get_screenshot` on the Variables panel region and read the hexes visually. Flag any ramp you still can't recover.

6. **Patch the skill.** Apply every confirmed diff to the reference files with `Edit`. Prefer surgical edits; don't rewrite sections unnecessarily. Keep the established table formatting.

7. **Update `SKILL.md` cheat-sheet** only if a semantic alias that appears on the cheat-sheet (e.g. `Surface/Primary`, `Text/Brand`, `Border/Error`) changed. Otherwise leave `SKILL.md` alone.

8. **Append to `references/skill-update-log.md`.** Use today's date, trigger (`/sync-pantheon` manual or scheduled), a bullet list of what changed, and what gaps remain.

9. **Report back to Shrey.** Short summary: what was checked, what changed, what was patched, what still needs human attention. No walls of text — a punch list is fine.

## Guardrails

- Don't invent hexes. If Figma doesn't resolve a value, log it and flag it — don't fill it in by extrapolation.
- Don't delete sections of `tokens.md` that resolved correctly last time just because this run couldn't reach them. Staleness in the Figma MCP connection shouldn't wipe good data.
- If nothing changed, still append an entry to `skill-update-log.md` with "no changes detected" so the staleness clock resets.

$ARGUMENTS
