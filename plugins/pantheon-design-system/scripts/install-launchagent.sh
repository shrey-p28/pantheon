#!/usr/bin/env bash
# One-command LaunchAgent installer for the weekly Pantheon sync.
#
# Intended for Claude Code terminal users on macOS. Not for Cowork users —
# Cowork has its own scheduled-tasks MCP which /pantheon-bootstrap uses.
#
# This script is idempotent: safe to re-run. It will overwrite any prior
# install of the same LaunchAgent so you always get the current paths.
#
# Usage:
#   # Invoked automatically by /pantheon-bootstrap when running in Claude
#   # Code terminal, or run manually:
#   bash "${CLAUDE_PLUGIN_ROOT:-$HOME/.claude/plugins/cache/pantheon-design-system}/scripts/install-launchagent.sh"

set -euo pipefail

# --- macOS check ----------------------------------------------------------
if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "install-launchagent.sh is macOS-only. On other platforms, rely on the" >&2
  echo "in-session UserPromptSubmit hook for weekly auto-sync (it triggers"  >&2
  echo "/sync-pantheon on your first visual prompt of the week)."             >&2
  exit 1
fi

# --- Resolve where the plugin lives ---------------------------------------
# Priority:
#   1. $CLAUDE_PLUGIN_ROOT if the installer was called from within Claude.
#   2. $HOME/.claude/plugins/cache/pantheon-design-system — marketplace install
#      default for both Claude Code terminal and Cowork.
#   3. $HOME/.claude/skills/pantheon-design-system — legacy user-skill install.
resolve_plugin_root() {
  if [[ -n "${CLAUDE_PLUGIN_ROOT:-}" && -f "${CLAUDE_PLUGIN_ROOT}/scripts/scheduled-sync.sh" ]]; then
    echo "${CLAUDE_PLUGIN_ROOT}"
    return
  fi
  for candidate in \
      "${HOME}/.claude/plugins/cache/pantheon-design-system" \
      "${HOME}/.claude/skills/pantheon-design-system"; do
    if [[ -f "${candidate}/scripts/scheduled-sync.sh" ]]; then
      echo "${candidate}"
      return
    fi
  done
  return 1
}

if ! PLUGIN_ROOT=$(resolve_plugin_root); then
  echo "ERROR: cannot find the Pantheon plugin on this machine." >&2
  echo "Looked for scripts/scheduled-sync.sh under:" >&2
  echo "  - \$CLAUDE_PLUGIN_ROOT (if set)" >&2
  echo "  - ~/.claude/plugins/cache/pantheon-design-system" >&2
  echo "  - ~/.claude/skills/pantheon-design-system" >&2
  echo "Install or reinstall the plugin before running this script." >&2
  exit 1
fi

SCRIPT_PATH="${PLUGIN_ROOT}/scripts/scheduled-sync.sh"

# --- Prep log directory ---------------------------------------------------
LOG_DIR="${HOME}/.claude/logs"
mkdir -p "${LOG_DIR}"

# --- Template the plist ---------------------------------------------------
LAUNCH_AGENTS_DIR="${HOME}/Library/LaunchAgents"
mkdir -p "${LAUNCH_AGENTS_DIR}"

PLIST_LABEL="com.petpooja.pantheon-sync"
PLIST_PATH="${LAUNCH_AGENTS_DIR}/${PLIST_LABEL}.plist"

# Unload any prior version before rewriting (idempotency).
if launchctl list | grep -q "${PLIST_LABEL}"; then
  launchctl unload -w "${PLIST_PATH}" 2>/dev/null || true
fi

cat > "${PLIST_PATH}" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>${PLIST_LABEL}</string>

    <key>ProgramArguments</key>
    <array>
        <string>/bin/bash</string>
        <string>${SCRIPT_PATH}</string>
    </array>

    <key>StartCalendarInterval</key>
    <dict>
        <key>Weekday</key>
        <integer>1</integer>
        <key>Hour</key>
        <integer>9</integer>
        <key>Minute</key>
        <integer>0</integer>
    </dict>

    <key>RunAtLoad</key>
    <false/>

    <key>StandardOutPath</key>
    <string>${LOG_DIR}/pantheon-sync.stdout.log</string>

    <key>StandardErrorPath</key>
    <string>${LOG_DIR}/pantheon-sync.stderr.log</string>

    <key>EnvironmentVariables</key>
    <dict>
        <key>HOME</key>
        <string>${HOME}</string>
        <key>PATH</key>
        <string>${HOME}/.local/bin:/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin</string>
    </dict>
</dict>
</plist>
PLIST

# --- Load it --------------------------------------------------------------
launchctl load -w "${PLIST_PATH}"

echo "Pantheon weekly sync installed."
echo "  Plugin root:     ${PLUGIN_ROOT}"
echo "  Script:          ${SCRIPT_PATH}"
echo "  LaunchAgent:     ${PLIST_PATH}"
echo "  Schedule:        Mondays 09:00 local time (runs on next wake if the Mac is asleep)"
echo "  Logs:            ${LOG_DIR}/pantheon-sync.stdout.log"
echo ""
echo "Next run will be the coming Monday at 09:00. To test immediately:"
echo "  launchctl start ${PLIST_LABEL}"
echo "  tail -f ${LOG_DIR}/pantheon-sync.stdout.log"
