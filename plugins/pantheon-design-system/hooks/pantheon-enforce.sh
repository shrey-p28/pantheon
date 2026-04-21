#!/usr/bin/env bash
# Pantheon UserPromptSubmit hook
#
# Runs on every prompt. If the prompt mentions anything visual / UI / branded,
# it prints a short reminder to stdout — Claude Code injects anything on stdout
# from a UserPromptSubmit hook as additional context for the assistant. This
# guarantees the Pantheon skill is considered even when the user forgets to
# say "Pantheon" or "brand" explicitly.
#
# Second job: check how old the skill is (via references/skill-update-log.md).
# If it's been more than $STALE_DAYS since the last sync, the hook injects
# instructions telling Claude to silently run /sync-pantheon BEFORE answering
# the user, so the design system is always fresh on the first visual prompt
# of the week. This is the mechanism that makes per-teammate weekly
# auto-update work without any setup on their end.
#
# This script is intentionally zero-dependency — pure bash + grep + date.

set -euo pipefail

# --- Config ---------------------------------------------------------------
# Locate the skill update log. Works in both deployment modes:
#   1. Cowork / marketplace plugin install — CLAUDE_PLUGIN_ROOT points at the
#      plugin dir; the log lives at
#      <plugin-root>/skills/pantheon-design-system/references/.
#   2. Claude Code user skill install (legacy) — no CLAUDE_PLUGIN_ROOT; the
#      log lives at ~/.claude/skills/pantheon-design-system/references/.
if [[ -n "${CLAUDE_PLUGIN_ROOT:-}" && -f "${CLAUDE_PLUGIN_ROOT}/skills/pantheon-design-system/references/skill-update-log.md" ]]; then
  LOG_FILE="${CLAUDE_PLUGIN_ROOT}/skills/pantheon-design-system/references/skill-update-log.md"
else
  LOG_FILE="${HOME}/.claude/skills/pantheon-design-system/references/skill-update-log.md"
fi

# Weekly cadence. Change to 14 for fortnightly, 30 for monthly.
STALE_DAYS=7

# Trigger keywords. Deliberately broad — the skill's own description handles
# precision; this hook just makes sure Claude never silently skips Pantheon on
# a visual task.
KEYWORDS='(ui|ux|component|button|input|form|card|chip|badge|tab|modal|dialog|dropdown|checkbox|radio|switch|table|list|sidebar|nav|navigation|header|footer|layout|page|screen|mockup|wireframe|prototype|figma|design|brand|logo|style|color|palette|theme|token|typography|font|prometheus|inter|spacing|radius|shadow|icon|illustration|dashboard|chart|graph|visualization|viz|poster|marketing|asset|banner|thumbnail|hero|landing|cta|html|react|jsx|tsx|tailwind|css|scss|shadcn|material|bootstrap|docx|pdf|pptx|deck|slide|presentation|one-pager|onepager|report|document|pantheon|petpooja|pos|billing|payroll)'

# --- Read prompt ----------------------------------------------------------
# UserPromptSubmit hooks receive the prompt on stdin as JSON.
# We only need the prompt body; pull it with a tiny python one-liner since
# jq may not be available everywhere.
PROMPT=$(python3 -c 'import sys, json; d=json.load(sys.stdin); print(d.get("prompt","") or d.get("user_message","") or "", end="")' 2>/dev/null || true)

if [[ -z "${PROMPT}" ]]; then
  exit 0
fi

# --- Match ---------------------------------------------------------------
shopt -s nocasematch
if ! [[ "${PROMPT}" =~ ${KEYWORDS} ]]; then
  exit 0
fi
shopt -u nocasematch

# --- Staleness check -----------------------------------------------------
# Compute age in days against the most recent dated entry in the sync log.
# If stale, we'll inject an auto-sync instruction block into the prompt
# context. /sync-pantheon's own run writes a new dated entry on success or
# failure, so a successful run resets the timer for another STALE_DAYS, and
# even a failed attempt counts as "tried today" (prevents re-nudging on
# every prompt within the same day).
AGE_DAYS=-1
LAST_DATE=""
if [[ -f "${LOG_FILE}" ]]; then
  LAST_DATE=$(grep -oE '^## [0-9]{4}-[0-9]{2}-[0-9]{2}' "${LOG_FILE}" | head -n1 | awk '{print $2}')
  if [[ -n "${LAST_DATE}" ]]; then
    # macOS date uses -j -f; Linux uses -d. Try both.
    if LAST_TS=$(date -j -f "%Y-%m-%d" "${LAST_DATE}" "+%s" 2>/dev/null); then :;
    else LAST_TS=$(date -d "${LAST_DATE}" "+%s" 2>/dev/null || echo 0); fi
    NOW_TS=$(date "+%s")
    if [[ "${LAST_TS}" -gt 0 ]]; then
      AGE_DAYS=$(( (NOW_TS - LAST_TS) / 86400 ))
    fi
  fi
fi

# --- Build optional auto-sync instruction block ---------------------------
# If the content is stale (>STALE_DAYS old), we instruct Claude to run
# /sync-pantheon silently BEFORE answering. This is the weekly auto-update
# mechanism — every teammate's first visual prompt of the week triggers a
# fresh re-digest from their own local Figma MCP. No scheduled task needed
# for this to work; it self-regulates inside normal conversation.
AUTO_SYNC_BLOCK=""
if [[ "${AGE_DAYS}" -gt "${STALE_DAYS}" || "${AGE_DAYS}" -lt 0 ]]; then
  if [[ "${AGE_DAYS}" -lt 0 ]]; then
    STALE_SUMMARY="the Pantheon sync log has no entries yet — this is the first sync on this machine"
  else
    STALE_SUMMARY="Pantheon was last synced from Figma ${AGE_DAYS} days ago (on ${LAST_DATE}), which is past the ${STALE_DAYS}-day weekly cadence"
  fi
  AUTO_SYNC_BLOCK=$(cat <<SYNC

[Pantheon auto-sync required]
Before addressing the user's request, ${STALE_SUMMARY}. **Run the \`/sync-pantheon\` slash command first to re-digest the Pantheon Figma file against this machine's local Figma MCP.** The command patches any tokens, components, or ramps that have been added / edited / removed since the last sync, and appends a dated entry to the skill-update-log — which resets this prompt for another week.

Guidance for running the sync in the background:
- If the Figma Dev Mode MCP is not reachable (e.g. Figma desktop isn't open, or Dev Mode MCP is disabled), \`/sync-pantheon\` will log a failure entry and exit cleanly. In that case, proceed with the user's request using the current (stale) reference files AND note at the end of your response: "Pantheon content is ${AGE_DAYS}d stale — please open the Pantheon Figma file and re-run \`/sync-pantheon\` when convenient."
- If the sync succeeds, briefly note what changed (cite the skill-update-log entry) and then proceed with the user's request.
- Do NOT ask the user for permission to run the sync — it is pre-authorized by the plugin's design. Just run it.

Once the sync step is resolved (success or graceful failure), continue with the user's original prompt using the now-current reference files.
SYNC
  )
fi

# --- Inject reminder -----------------------------------------------------
cat <<EOF
[Pantheon auto-reminder]
This task looks visual / branded. The **pantheon-design-system** skill applies:
- Use Pantheon tokens by name (no raw hex unless it came from a token).
- Use Pantheon components (Button, Text Input, Chips, Card, Table, Segment, etc.) — never reinvent a \`<button>\` or \`<input>\` from scratch, and never invent a component that isn't in the library.
- Use Prometheus (Inter) type composites only. Letter-spacing 0.
- Cycle chart colors through the 8 accent families: Aqua, Beige, Green, Yellow, Navy Blue, Orange, Pink, Purple.
- Default theme is POS Light unless the user says dark mode / Billing / Payroll.

Run the skill's pre-flight checklist (theme / tokens / components / type / component-mapping test) before producing any visual artifact.${AUTO_SYNC_BLOCK}
EOF
