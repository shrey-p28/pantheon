# Maintainer's guide — the `pantheon` repo

This is for Grish (and whoever inherits this). It covers how to publish plugin updates and how the whole thing fits together.

Everyday design work in Figma needs no action from you here — teammates' plugins auto-sync themselves against the Figma file once a week. This guide is for the cases where you change **the plugin** itself: the skill's wording, the reference doc layout, the hook's keyword list, adding a new slash command, etc. Basically anything in this repo.

---

## Repo layout

```
pantheon/
├── .claude-plugin/
│   └── marketplace.json             ← tells Claude "this repo contains plugins" + lists them
│                                      (filename is fixed by Claude's plugin spec; the word
│                                      "marketplace" appears nowhere user-facing)
├── plugins/
│   └── pantheon-design-system/      ← the plugin itself
│       ├── .claude-plugin/
│       │   └── plugin.json          ← plugin manifest (name, version, description)
│       ├── skills/
│       │   └── pantheon-design-system/
│       │       ├── SKILL.md
│       │       └── references/      ← tokens, components, inventory, sync log
│       ├── commands/
│       │   ├── sync-pantheon.md
│       │   └── pantheon-bootstrap.md
│       ├── hooks/
│       │   ├── hooks.json
│       │   └── pantheon-enforce.sh
│       ├── scripts/
│       │   ├── install-launchagent.sh
│       │   ├── scheduled-sync.sh
│       │   └── com.petpooja.pantheon-sync.plist
│       └── README.md
├── README.md                        ← team-facing install + usage
└── MAINTAIN.md                      ← this file
```

One repo, one plugin. Adding more plugins later (e.g. a `petpooja-brand-voice` plugin) is just adding another entry under `plugins:` in `marketplace.json` and another subdir under `plugins/`.

---

## How teammates subscribe

They run once:

```
/plugin marketplace add <owner>/pantheon
/plugin install pantheon-design-system@pantheon
/pantheon-bootstrap
```

After that, Claude pulls updates from this repo automatically on new sessions (or when the user runs `/plugin marketplace update`). The important piece: **teammates never need to re-install**. Version bumps propagate on the next session start.

---

## Shipping a plugin update

There are three kinds of update:

### 1. Reference-data update (tokens.md, components.md changed in Figma)

**Don't do this by hand.** The whole point of the weekly `/sync-pantheon` auto-run is that teammates pull reference-data changes from Figma themselves, on their own machines. You don't need to ship anything.

The only reason to manually bump the plugin for a Figma change is if you restructured Pantheon in a way the sync skill itself can't handle yet (e.g. added a whole new page with a new kind of primitive the skill doesn't know to look for). In that case, update the skill → see case 3.

### 2. Content edit to the skill / README / docs

Small wording change, typo fix, new anti-pattern added to SKILL.md, clearer example, etc.

Steps:

1. Edit the file(s) in `plugins/pantheon-design-system/`.
2. Bump the **patch** version in `plugins/pantheon-design-system/.claude-plugin/plugin.json`. Example: `1.1.0` → `1.1.1`. Also bump `version` on the plugin entry in `.claude-plugin/marketplace.json` to match.
3. Commit with a clear message: `pantheon-design-system v1.1.1 — tighten non-invention rule`.
4. Push. Done.

Teammates pick it up on their next `/plugin marketplace update` or session start.

### 3. Structural change (new slash command, new hook behavior, new reference file, etc.)

Anything that changes what the plugin *does*.

Steps:

1. Edit / add / delete files as needed.
2. Bump the **minor** version (`1.1.1` → `1.2.0`) in both `plugin.json` and `marketplace.json`.
3. If you added a new command that needs extra MCP tools (e.g. a new `mcp__foo__bar`), update the command's frontmatter `allowed-tools:` list.
4. If the hook's keyword list or cadence changed, call it out in the commit and in the plugin README's "Version" section.
5. Commit + push.

For **breaking** changes (e.g. you renamed `/sync-pantheon` to `/pantheon-sync`, or changed the format of `skill-update-log.md`), bump the **major** version (`1.2.0` → `2.0.0`) and write a short migration note in the commit body. Teammates will see the new version on update.

---

## Version bumping cheat-sheet

```
<major>.<minor>.<patch>

patch — wording, typos, clarifying examples                    1.1.0 → 1.1.1
minor — new commands, new hook behavior, new refs              1.1.0 → 1.2.0
major — renames, removed commands, incompatible ref formats    1.2.0 → 2.0.0
```

Always bump both places:
- `plugins/pantheon-design-system/.claude-plugin/plugin.json` → `version`
- `.claude-plugin/marketplace.json` → `plugins[0].version`

(The two should always match. If they drift, the repo manifest wins for the subscription UI but the plugin manifest wins at runtime — confusing. Keep them in sync.)

---

## Testing a change before pushing

The safest loop is:

1. Make the edit locally.
2. In your own Claude Code or Cowork: uninstall the current plugin (`/plugin uninstall pantheon-design-system`), then install from your local working copy:
   ```
   /plugin install <absolute-path-to>/plugins/pantheon-design-system
   ```
   (Claude Code accepts a local path; Cowork can drag-and-drop the folder.)
3. Try a handful of prompts that exercise the change:
   - Change to the hook keywords? Try a visual prompt that uses one of the new keywords.
   - Change to SKILL.md? Ask for something where the change would matter (e.g. a pricing card, if you tightened the non-invention rule).
   - Change to `/sync-pantheon`? Run it and check the log entry + diff.
4. If all good, uninstall your local copy, push the commit, and verify by re-installing via `/plugin marketplace update` and `/plugin update pantheon-design-system`.

---

## Forcing a teammate to upgrade

If you ship a critical fix and want everyone on it now (rather than whenever their next session is):

1. Push the update.
2. Ping the team: "Run `/plugin marketplace update && /plugin update pantheon-design-system` next time you open Claude." That's it.

You can't remotely force an update — Claude plugins are per-machine and pull-based by design. But since the team is small and you can Slack them, this is fine.

---

## Publishing the repo

Any Git host works. Recommended options:

- **GitHub private repo** under a Petpooja org (or your personal account) — simplest. Teammates subscribe via `/plugin marketplace add <owner>/pantheon`.
- **GitLab / Bitbucket / self-hosted Git** — use the full URL form: `/plugin marketplace add https://gitlab.petpooja.com/design/pantheon.git`.
- **Tarball on an internal file server** — also possible but rarer; use `/plugin marketplace add <url-to-marketplace.json>`.

The team README assumes GitHub-style `<owner>/<repo>`. Adjust it once you've picked a host.

---

## Rotating the owner

If you ever hand this off, update:

1. `.claude-plugin/marketplace.json` → `owner.name` and `owner.email`.
2. `plugins/pantheon-design-system/.claude-plugin/plugin.json` → `author.name` and `author.email`.
3. `README.md` and `plugins/pantheon-design-system/README.md` → contact section.
4. Bump the plugin **minor** version so the change propagates.

---

## One-line mental model

*"The repo is how you deliver changes to the plugin framework. The weekly auto-sync is how Pantheon's own content stays fresh. The two are independent — you only touch this repo when the plugin itself needs to change."*
