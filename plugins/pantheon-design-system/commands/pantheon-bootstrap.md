---
description: One-time setup for new teammates. Verifies Figma MCP, confirms the authenticated Figma user is correct, runs the first sync, and schedules weekly auto-updates so Pantheon stays fresh without manual intervention.
allowed-tools: Read, Edit, Write, Glob, Grep, Bash, SlashCommand, mcp__figma-local__get_metadata, mcp__figma-local__get_variable_defs, mcp__scheduled-tasks__create_scheduled_task, mcp__scheduled-tasks__list_scheduled_tasks
---

You are running a one-time bootstrap for a teammate who just installed the **pantheon-design-system** plugin. The goal is to leave them in a state where Pantheon updates itself weekly from their own machine's Figma MCP — zero manual effort going forward.

There are **four** jobs to do, in order. Don't stop early unless a hard failure blocks the rest. The auth check (Job 2) is non-negotiable — skip it and the teammate can end up syncing as the wrong user.

## Job 1 — Verify the Figma MCP is reachable

Call `mcp__figma-local__get_metadata` with `nodeId="0:0"` and `depth=1`. We need it to answer; we don't need to parse it deeply.

- **If the tool responds:** note it passed, continue.
- **If the tool is missing or errors:** tell the teammate exactly what to fix — open the Figma desktop app, open the Pantheon file at `https://www.figma.com/design/l8qALS4HQUMbSTyP8BTGRL/Pantheon`, and enable Dev Mode MCP in Figma Preferences. **Stop here** — the rest won't work without MCP access. They can re-run `/pantheon-bootstrap` once Figma is ready.

## Job 2 — Confirm the authenticated Figma user

The Figma Dev Mode MCP authenticates against whoever is signed into Figma desktop on this machine. If the wrong account is signed in (shared laptop, multi-account profile, an old session), every sync will read and report against that user's view of Figma — which can pull from a different team or workspace and produce confusing results.

1. Try to fetch the authenticated identity. The cleanest source is a `whoami`-style tool on the Figma MCP if one is exposed (e.g. `mcp__*__whoami`). If `whoami` isn't available, inspect the response from Job 1's `get_metadata` call for any user/team/owner identifiers and fall back to those. If neither yields a clear identity, mark the auth check as `unverified` and surface that in the summary — don't fabricate an email.

2. **Print the identity prominently in the summary.** The teammate must see something like:

   > Figma authenticated as: **`<email>`** on team **`<team-name>`**

3. **Ask the teammate to confirm it's them**, in a single short prompt at the end of the summary, e.g. "If that's not your account, stop here and run `/pantheon-bootstrap` again after switching Figma desktop to your own login. Otherwise, you're good."

4. If the identity could not be determined, say so plainly: "Auth identity couldn't be read from the Figma MCP — verify in Figma desktop (top-right avatar) that you're signed in as yourself before relying on sync output."

Do **not** silently proceed under the assumption that whoever's signed into Figma is the teammate. Do **not** invent or guess an identity if MCP didn't return one.

## Job 3 — Run the first sync

Invoke the existing `/sync-pantheon` slash command. This validates end-to-end that the sync pipeline works on this machine AND resets the staleness clock so the weekly hook-triggered auto-sync doesn't fire on the very next prompt.

`/sync-pantheon` runs in evidence-only mode — it produces a structured report with literal before/after values for every patched path. Pass that report through to the teammate verbatim in the summary; don't re-narrate it. If `/sync-pantheon` produces an empty diff or only `unresolved` rows, that's still a valid sync — say so plainly.

If `/sync-pantheon` fails outright, surface the failure clearly and stop — don't continue to Job 4 with a broken sync pipeline.

## Job 4 — Schedule the weekly auto-sync

The mechanism depends on the runtime:

### If running in Cowork (scheduled-tasks MCP is available)

Call `mcp__scheduled-tasks__list_scheduled_tasks` first to check if a task called `pantheon-weekly-sync` already exists. If it does, confirm it and skip to the summary — don't create duplicates.

Otherwise create a new task via `mcp__scheduled-tasks__create_scheduled_task` with:
- **Name:** `pantheon-weekly-sync`
- **Prompt body:** `Run /sync-pantheon to re-digest the Pantheon Figma file and patch any changes to the local plugin reference files. This is an automated weekly refresh — pass the full structured sync report through verbatim, do not summarize.`
- **Schedule:** weekly, Monday 09:00 local time.

If the scheduled-tasks MCP is not available, fall back to the Claude Code path below.

### If running in Claude Code terminal (no scheduled-tasks MCP)

Shell out to the LaunchAgent installer that ships with the plugin:

```bash
bash "${CLAUDE_PLUGIN_ROOT:-$HOME/.claude/plugins/cache/pantheon-design-system}/scripts/install-launchagent.sh"
```

The script is idempotent — re-running it is safe. It installs a macOS LaunchAgent that runs `/sync-pantheon` in headless Claude Code every Monday at 09:00.

If the platform isn't macOS, tell the teammate that automated weekly sync requires either Cowork OR macOS Claude Code terminal, and that the in-session auto-sync via the UserPromptSubmit hook will still fire on the first visual prompt each week as a fallback.

## Summary

After all four jobs complete (or gracefully fall back), report a short status to the teammate, in this exact order:

```
Pantheon bootstrap

Figma MCP: reachable / not reachable
Figma authenticated as: <email> on team <team-name>   ← or "unverified" with a note
First sync: <pass-through of /sync-pantheon's structured report>
Weekly automation: scheduled in Cowork / LaunchAgent installed / in-session hook fallback only

Confirm the Figma account above is yours. If not, stop and re-run after switching Figma desktop accounts.
```

Keep everything outside the sync report under 10 lines. The sync report itself can be as long as it needs to be — pass it through verbatim.

$ARGUMENTS
