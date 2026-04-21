---
description: One-time setup for new teammates. Verifies Figma MCP, runs the first sync, and schedules weekly auto-updates so Pantheon stays fresh without manual intervention.
allowed-tools: Read, Edit, Write, Glob, Grep, Bash, SlashCommand, mcp__figma-local__get_metadata, mcp__figma-local__get_variable_defs, mcp__scheduled-tasks__create_scheduled_task, mcp__scheduled-tasks__list_scheduled_tasks
---

You are running a one-time bootstrap for a teammate who just installed the **pantheon-design-system** plugin. The goal is to leave them in a state where Pantheon updates itself weekly from their own machine's Figma MCP — zero manual effort going forward.

There are three jobs to do, in order. Do all three; don't stop early unless a hard failure blocks the rest.

## Job 1 — Verify the Figma MCP is reachable

Call `mcp__figma-local__get_metadata` with a small node (e.g. `nodeId="0:0"` and `depth=1`). Don't block on the response — we only need to know the tool answers, not parse it.

- **If the tool responds:** note it passed, continue.
- **If the tool is missing or errors:** tell the teammate exactly what to fix — open the Figma desktop app, open the Pantheon file at `https://www.figma.com/design/l8qALS4HQUMbSTyP8BTGRL/Pantheon`, and enable Dev Mode MCP in the Figma Preferences. **Stop here** — the rest won't work without MCP access. The teammate can re-run `/pantheon-bootstrap` once Figma is ready.

## Job 2 — Run the first sync

Invoke the existing `/sync-pantheon` slash command to re-digest Pantheon against the teammate's local Figma and patch any drift. This both validates end-to-end that the sync pipeline works on their machine AND resets the staleness clock so the weekly hook-triggered auto-sync doesn't fire on their very next prompt.

If `/sync-pantheon` fails, surface the failure clearly and stop — don't continue to Job 3 with a broken sync pipeline. Ask the teammate to share the failure mode so it can be debugged.

## Job 3 — Schedule the weekly auto-sync

This is where the "weekly" part gets wired up. The mechanism depends on the runtime:

### If running in Cowork (scheduled-tasks MCP is available)

Call `mcp__scheduled-tasks__list_scheduled_tasks` first to check if a task called `pantheon-weekly-sync` already exists. If it does, confirm it and skip to the summary — don't create duplicates.

Otherwise create a new task via `mcp__scheduled-tasks__create_scheduled_task` with:
- **Name:** `pantheon-weekly-sync`
- **Prompt body:** `Run /sync-pantheon to re-digest the Pantheon Figma file and patch any changes to the local plugin reference files. This is an automated weekly refresh — report only a short summary of what changed.`
- **Schedule:** weekly, Monday 09:00 local time.

If the scheduled-tasks MCP is not available, fall back to the Claude Code path below.

### If running in Claude Code terminal (no scheduled-tasks MCP)

Shell out to the LaunchAgent installer that ships with the plugin:

```bash
bash "${CLAUDE_PLUGIN_ROOT:-$HOME/.claude/plugins/cache/pantheon-design-system}/scripts/install-launchagent.sh"
```

The script is idempotent — re-running it is safe. It installs a macOS LaunchAgent that runs `/sync-pantheon` in headless Claude Code every Monday at 09:00.

If the platform isn't macOS (the LaunchAgent approach is macOS-only), tell the teammate that automated weekly sync requires either Cowork OR macOS Claude Code terminal, and that the in-session auto-sync via the UserPromptSubmit hook will still fire on the first visual prompt each week as a fallback. They won't lose weekly updates — they'll just happen the first time they ask for something visual after the 7-day window, not on a schedule.

## Summary

After all three jobs complete (or gracefully fall back), report a short status to the teammate:

1. Figma MCP: reachable / not reachable
2. First sync: succeeded / failed (with the log tail if it failed)
3. Weekly automation: scheduled in Cowork / LaunchAgent installed / in-session hook fallback only
4. What they need to do next: nothing, usually. They can run any visual prompt to confirm the skill loads and the tokens apply.

Keep the summary under 10 lines. The teammate should be able to close this conversation and go back to whatever they were doing.

$ARGUMENTS
