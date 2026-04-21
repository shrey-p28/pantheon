#!/usr/bin/env bash
# Pantheon scheduled sync — runs Claude Code in headless (print) mode with the
# /sync-pantheon slash command. Intended to be invoked by the LaunchAgent at
# ~/Library/LaunchAgents/com.petpooja.pantheon-sync.plist once a week.
#
# What it does:
#   1. Confirms the Claude CLI is on PATH.
#   2. Invokes `claude -p "/sync-pantheon"` with the skill's Figma MCP tools
#      allowed so the headless run can actually read Figma.
#   3. Logs stdout + stderr with a timestamped banner to ~/.claude/logs/.
#
# If Claude can't reach the Figma MCP (Figma desktop not running, Dev Mode MCP
# off), the /sync-pantheon prompt itself handles it — it will write a log
# entry noting the sync failed and exit cleanly.

set -euo pipefail

LOG_DIR="${HOME}/.claude/logs"
LOG_FILE="${LOG_DIR}/pantheon-sync.log"
mkdir -p "${LOG_DIR}"

echo "=======================================================" >>"${LOG_FILE}"
echo "Pantheon scheduled sync — $(date '+%Y-%m-%d %H:%M:%S %Z')" >>"${LOG_FILE}"
echo "=======================================================" >>"${LOG_FILE}"

# LaunchAgents get a minimal PATH. Add the common install locations.
export PATH="${HOME}/.local/bin:/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:${PATH}"

if ! command -v claude >/dev/null 2>&1; then
  echo "ERROR: claude CLI not on PATH" >>"${LOG_FILE}"
  exit 1
fi

# Scheduled headless runs can't respond to permission prompts. The slash
# command itself scopes tool access via its `allowed-tools:` frontmatter,
# and the only MCP server in play is the local Figma Dev Mode server running
# on your own machine. Skip interactive permission checks so the run doesn't
# hang on "Blocked on MCP permission".
#
# Slash commands must be piped via stdin when using --print; passing them as
# a positional argument errors out with "Input must be provided either through
# stdin or as a prompt argument".
echo "/sync-pantheon" | claude --print \
  --dangerously-skip-permissions \
  >>"${LOG_FILE}" 2>&1 || {
    echo "Pantheon sync exited non-zero — see log above" >>"${LOG_FILE}"
    exit 1
  }

echo "Pantheon sync completed — $(date '+%Y-%m-%d %H:%M:%S %Z')" >>"${LOG_FILE}"
