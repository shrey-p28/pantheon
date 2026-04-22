---
description: Re-digest Pantheon from Figma and patch the local skill with any changes (tokens, components, ramps). Runs in evidence-only mode — every claimed patch must cite a literal MCP value and a literal pre-patch file value.
allowed-tools: Read, Edit, Write, Glob, Grep, Bash, mcp__figma-local__get_metadata, mcp__figma-local__get_variable_defs, mcp__figma-local__get_screenshot
---

You are syncing the local **pantheon-design-system** skill against the live Pantheon Figma file. Your job is to detect drift between what's in the skill's reference files and what's in Figma right now, then patch the skill — but only with evidence.

## Why this command is strict

A previous version of this command was permissive — it accepted natural-language summaries like "Primary went cyan→blue" without proof. That's how a model fakes a sync: by inventing plausible-sounding diffs that don't correspond to anything in Figma. This version refuses to do that. Every claim of a patch must be backed by a literal value pulled from an MCP call AND a literal value read from the current reference file. If you can't show both as exact strings (hexes for colors, full variable names for paths, exact font-family strings for typography), you don't have a diff — you have a hunch, and hunches do not get patched.

If you ever feel the urge to write "the primary color shifted slightly" or "fonts look mostly Inter with some Poppins," stop. That's the failure mode this command exists to prevent. Either you have a literal before-value AND a literal after-value, or you have nothing.

## Source of truth

- Figma file: `https://www.figma.com/design/l8qALS4HQUMbSTyP8BTGRL/Pantheon`
- File key: `l8qALS4HQUMbSTyP8BTGRL`
- Skill location (resolve via `${CLAUDE_PLUGIN_ROOT}/skills/pantheon-design-system/`): if `CLAUDE_PLUGIN_ROOT` is unset, fall back to `~/.claude/plugins/cache/pantheon-design-system/skills/pantheon-design-system/`
- Reference files to compare against:
  - `references/tokens.md` — primitive ramps, semantic aliases, typography composites, sizing/elevation
  - `references/components.md` — component inventory, variants, states
  - `references/full_inventory.md` — node IDs, variant counts, page structure
  - `references/raw_variables_extraction.md` — last raw dump of variable defs, kept for diffing

## Phases

This command runs in four strict phases. Don't skip phases. Don't patch in phase 2.

### Phase 1 — Collect raw evidence (no diffing yet)

1. **Confirm Figma MCP is reachable.** Call `mcp__figma-local__get_metadata` with `nodeId="0:0"` and `depth=1`. If it errors, stop — tell the user to open the Pantheon Figma file in Figma desktop with Dev Mode MCP enabled, then re-run.

2. **Create a scratch directory** at `/tmp/pantheon-sync-<UTC-timestamp>/` to hold raw MCP responses for this run. Every MCP call in phase 1 writes its full response to a file there. Do not summarize, do not parse — just save the raw bytes.

3. **Full-file metadata dump.** Call `mcp__figma-local__get_metadata` on `nodeId="0:0"`. Save full response to `<scratch>/metadata-root.json`. The result is large (>1M chars); spawn a subagent to extract a structured manifest into `<scratch>/manifest.json` containing:
   - Every page name + node ID
   - Per page: every component set name + variant count + node ID
   - Every swatch frame on the Colors page with the literal hex it displays (top-to-bottom = step 100→900)

4. **Variable defs per page.** For each token-rich page (Colors, Typography, Buttons, Text Input, Cards, Icons, Spacing/Sizing), call `mcp__figma-local__get_variable_defs` with the page node ID from the manifest. Save each raw response to `<scratch>/vars-<page-name>.json`.

5. **Phase 1 gate.** Before moving on, confirm in your working notes:
   - The scratch directory exists and contains `metadata-root.json`, `manifest.json`, and one `vars-*.json` per token-rich page.
   - Every value you'll cite in phase 2 came from one of these files. If a value isn't traceable to a saved MCP response, you can't use it.

### Phase 2 — Diff with literal values (no patching yet)

For each comparison, build a row with these exact fields. Write the rows to `<scratch>/diff-candidates.tsv` so the patch phase has a reviewable artifact.

| field | meaning |
|---|---|
| `path` | The fully qualified variable or component path (e.g., `Colors/Primitives/Primary/500`, `Typography/Prometheus/Body/Medium/font-family`, `Component:Button/variant=primary,size=md`) |
| `current_in_file` | The literal value currently in `tokens.md` / `components.md` / `full_inventory.md`. Quote it exactly — hex string, font-family string, variant count, etc. If the file doesn't have a value for this path, write `<absent>`. |
| `figma_value` | The literal value from the saved MCP response. Quote it exactly. If MCP didn't return a value, write `<unresolved>`. |
| `evidence_file` | The scratch filename + line range where `figma_value` came from. |
| `kind` | `match` / `drift` / `new` / `removed` / `unresolved` |

Rules:
- **Colors are hex strings.** `#1770ee`, never `"blue"`, `"cyan"`, `"primary blue"`.
- **Fonts are full family strings.** `"Inter"`, `"Poppins"`, never `"sans-serif looking"`.
- **Variable paths use Figma's literal naming.** Don't normalize, don't translate.
- A row only counts as `drift` if both `current_in_file` and `figma_value` are present AND they differ as literals. `<absent>` vs anything is `new`. Anything vs `<absent>` is `removed`. `<unresolved>` is always `unresolved`, never `drift`.

If a primitive ramp appears `<unresolved>` from `get_variable_defs`, retry with `mcp__figma-local__get_screenshot` on the swatch frame and read the hexes off the swatches — but record the screenshot path under `evidence_file` and make clear it was visually read.

### Phase 3 — Patch only with evidence

Open `<scratch>/diff-candidates.tsv`. For every row where `kind == drift`, `new`, or `removed`:

1. Read the relevant section of the reference file with `Read`. Confirm `current_in_file` is actually present as written. If not, the row is invalid — drop it, log to phase-4 report under "rejected (file value not found as quoted)."

2. Apply the change with `Edit`. Use a surgical edit — `old_string` is the line containing the literal `current_in_file`, `new_string` is the same line with the literal `figma_value` swapped in. Don't reformat surrounding rows.

3. Append a structured row to `references/skill-update-log.md` under today's date with: `path | before | after | evidence_file`.

For `unresolved` rows, do not patch. Append them to the log under "needs human review" with the path and the reason it couldn't be resolved.

### Phase 4 — Verify by re-reading

After all patches in phase 3 are applied:

1. For every patched path, `Read` the reference file again and confirm `figma_value` now appears at that path. If it doesn't, the patch failed — revert by applying the inverse `Edit`, and log a failure row.
2. Verify `references/skill-update-log.md` has exactly one entry per patched path plus one section per unresolved path.

### Final report

Print a structured summary, no prose narrative:

```
Sync run <UTC timestamp>
Figma user: <whoami from manifest, if available>
Pages dumped: <count>
Diff candidates: <total> (drift: <n>, new: <n>, removed: <n>, unresolved: <n>)
Patched: <n>
Rejected (file value not found): <n>
Verified: <n>/<patched count>
Needs review: <list of paths>
```

Then list each patched row as `path  before → after  [evidence: <file>]`.

## Hard guardrails

- **Never invent a hex.** If MCP returns no value and screenshot reading fails, the row is `unresolved`. Never extrapolate from neighbors.
- **Never use color names or font categories as values.** Only literals from MCP responses.
- **Never patch without a verification re-read.** A patch you can't verify by re-reading the file must be reverted.
- **Never delete a section of `tokens.md` or `components.md` because MCP returned nothing.** Staleness in the connection is not evidence of removal — it's `unresolved`.
- **If nothing drifted, still append to `skill-update-log.md`.** Use today's date and "no drift detected — N values verified against Figma." This resets the staleness clock so the weekly hook doesn't re-fire.
- **If you find yourself summarizing in prose mid-run, stop.** Go back to phase 2 and produce literal rows. The whole point of this command is that the report is mechanically derivable from the scratch evidence.

$ARGUMENTS
