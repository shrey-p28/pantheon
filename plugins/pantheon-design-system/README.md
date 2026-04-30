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

For distribution via the `pantheon` repo, follow the **team README** at the repo root. Short version:

```
/plugin marketplace add <owner>/pantheon
/plugin install pantheon-design-system@pantheon
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

Pantheon design system maintained by Shrey, Senior Product Designer, Petpooja · shrey@petpooja.com

## Version

1.4.5 — runtime gotchas patched after a real 3-frame rebuild trial. SKILL.md §1.4 JS skeleton + §1.5 hard-gate + §1.6 component table all corrected for: (1) `figma.currentPage` is a footgun — use `getNodeByIdAsync(pageId)`, (2) `layoutSizingHorizontal=FILL` requires append-first, (3) `textStyleId` does not bind text color — explicitly bind text fills to `Text/*` variables, (4) variant axes were systematically wrong on Cards/Outline/Text Input/Radio/Switch/Badges/Chips — corrected to trial-verified values, (5) `Badges Size=Small` is a dot indicator, `Size=Large` is the labeled pill, (6) `get_design_context` requires a layer selection in Figma desktop, (7) 3-tier text-override fallback (named TEXT prop → any TEXT prop → first descendant TEXT) for nested-instance text overrides, (8) Pantheon Cards is a tile, not a section wrapper, (9) Pantheon Tabs labels are nested sub-instances and can't be overridden via top-level findOne, (10) Pantheon Table is a Slot-based container — Header/Body Block cells go INSIDE Table's Slot, not in a hand-composed frame.

1.4.4 — file-placement policy. Default behavior is "ask the user where the design goes" (existing file / new page / new file in a Petpooja folder / screenshot reference); `create_new_file` is now reserved for prompts that explicitly say "create a new file." When a new file is warranted, it MUST land in a shared Petpooja project folder via `projectId` — drafts are forbidden because they rotate with whoever-last-connected-the-Figma-MCP in a shared-Cowork setup and become invisible to other teammates. Reframed identity surfacing around the shared-Cowork constraint: Claude can't differentiate teammates (Cowork user ID + connector ID are shared across the team), so the connected Figma identity is now surfaced as informational, not validated.

1.4.3 — adds identity surfacing for shared-Cowork environments. At Petpooja, multiple teammates share one Cowork install while each has their own Figma account; the Figma MCP is auth'd to one identity which may not match whoever is actively using Cowork. The skill now requires Claude to (1) surface the connected Figma identity in one line after every `whoami` call so the user can confirm it before authoring, and (2) decide explicitly between drafts (with a warning naming whose drafts) and a shared Petpooja project folder (via `projectId` on `create_new_file`) before creating a new file — never fall back to drafts silently for real-authoring tasks.

1.4.2 — passed end-to-end behavioral trial. A throwaway file in Petpooja drafts confirmed `figma.importComponentSetByKeyAsync(<Pantheon componentKey>)` → `createInstance` → `setProperties` → `appendChild` works as documented. Three runtime gotchas patched: `loadAllPagesAsync` is not supported in the `use_figma` runtime (removed from skeleton); Pantheon Button variant axis is `"Show Icon"` (with space) with values `None/Leading/Trailing` not `Icon` with `False/True/Only`; `State` values are `Enabled/Disabled/Pressed` not `Default/Pressed/Disabled`. Added a caveat that `defaultVariant` is not the "obvious" default (Pantheon Primary's defaultVariant is `Show Icon=Leading, State=Enabled, Type=Square, Size=Extra Small` — Extra Small with a leading icon, not what most callers want). Documented the `Icon #43:0` instance-swap property used to pick the Material Symbol that fills a Button's icon slot.

1.4.1 — corrects the Figma-authoring path after a live MCP trial caught 4 critical bugs in v1.4.0. SKILL.md §1 now documents the three-identifier model (file key vs library key vs component key) and Pantheon's verified componentKeys for all 25 canonical component sets. The Button "family" is now correctly described as 7 separate component sets (`Primary`, `Tonal`, `Outline`, `Text Buttons`, `Primary Icon Button`, `Tonal Icon Button`, `Outline Icon Button`) rather than one set with a Hierarchy variant. `use_figma` is now described accurately as a JavaScript executor with real Plugin API code skeletons (`importComponentSetByKeyAsync`, `setBoundVariableForPaint`, `importStyleByKeyAsync`), not pseudocode. Tool call signatures for `get_libraries` and `search_design_system` are corrected (both require `fileKey`; search uses `includeLibraryKeys` to scope to Pantheon). The `/figma-use` skill load prerequisite is now mentioned. References file `figma-authoring.md` rewritten with real JS for all 7 authoring scenarios. Hook reminder updated to cite componentKey-based imports.

1.4.0 — adds the **Figma-authoring path** (superseded by 1.4.1 same day). When the deliverable lives in a Figma file, the skill now hard-gates Claude into using the official Figma MCP (`use_figma`, `create_new_file`, `search_design_system`, `get_libraries`, `add_code_connect_map`) to import REAL component instances from the Pantheon library file (`l8qALS4HQUMbSTyP8BTGRL`) — never to redraw shapes, recolor rectangles, or substitute SVG/HTML mocks. SKILL.md was restructured around an explicit STEP 0 target-detection table that routes to one of three paths: Figma-authoring (§1, mandatory MCP-driven import), Code (§2, faithful spec reproduction), Document (§3, .docx/.pdf/.pptx). §1 includes a pre-flight MCP sequence, insertion protocol, hard-gate checklist, anti-patterns ("rectangle styled to look like a button" is now an explicit failure case), a component → node ID lookup table for all 25 canonical Pantheon component sets, and a delivery footer format that's mechanically auditable. New `references/figma-authoring.md` documents seven authoring scenarios with the exact tool sequences (new file, extend frame, fix non-Pantheon mock, dashboard, component inspection, Code Connect mapping, missing-from-Pantheon asks). Hook reminder updated to lead with STEP 0. Originated from designer feedback that Claude was redrawing instead of importing.

1.3.2 — fix Text Input label rendering pattern. Pantheon's `Text Input` is Material Design 3's **outlined text field with a floating notched label**, not a stacked `<label>` row above the field. The label lives inside the field's border: when the field is empty and unfocused it sits at vertical center and acts as the placeholder; when the field is focused or has a value, the label floats up and notches through the top border at 12px inset from the left. The stacked-label pattern (shadcn / Tailwind default) was the most common Pantheon-violation in generated UI. Corrected in SKILL.md ("Three hot spots" Text Input subsection, new state-dependent label position table, notch geometry, fieldset/legend HTML skeleton, new anti-patterns: stacked label row, continuous top border with external label, Material "filled" variant, focus glow ring). `references/components.md` Text Input spec rewritten to match — composition now uses `<fieldset>` + `<legend>` so the native notched border renders automatically (same approach MUI `OutlinedInput` and Material Web Components use).

1.3.1 — fix Text Input Small height: 36, not 32. `Text Input` Size scale is 36 / 40 / 48 (Small / Medium / Large). Corrected in both SKILL.md "Three hot spots" section and `references/components.md` Text Input spec. The 32px height is Button Extra Small, not Text Input Small — they don't share a scale.

1.3.0 — SKILL.md tightened around three recurring failure modes. Dedicated "Three hot spots" section now spells out the `Text Input` spec exactly as it ships in Figma (height 32/40/48 by Size, 8px radius via `Square/Small`, 1px flat border with per-state token, label always above in `Label/Small-Medium`, supporting text below, no glowing focus rings, no pill shape, no placeholder-as-label) so Claude stops shipping generic HTML-ish inputs. Icons are now required to come from the Pantheon Outline (3,857) or Filled (3,845) sets, named by their Material Symbols key, sized from the 16/18/20/24 Width scale, coloured from `Icon/*` tokens — never invented as ad-hoc SVG, never from the Depreciated set. Emoji are forbidden in every visual output (React/HTML, docx, pdf, pptx, posters, dashboards, marketing); where an emoji is the quick habit, the matching Outline icon replaces it. Every artifact must end with a compact `Pantheon components used:` footer listing the component sets, icon names/sets, tokens, and Prometheus composites pulled from the Figma library, making traceability mechanical. `references/components.md` Text Input section already carried the spec; the change is lifting it into SKILL.md so it's read on every visual prompt.

1.2.3 — `/pantheon-bootstrap` drops the Figma identity/auth check entirely. It was originally added to help teammates notice if the Figma connector had been OAuth'd on someone else's token, but in practice the check added noise (false mismatches against Cowork email, stale warnings) without catching meaningful problems. Teammates confirm the account when they connect the Figma MCP in Cowork; no need to re-verify on every bootstrap. Bootstrap is now three jobs: Figma MCP reachability, first sync, schedule weekly auto-sync.

1.2.2 — `/pantheon-bootstrap` no longer programmatically compares the Figma MCP identity against the teammate's Cowork / SSO email. A mismatch there is normal (Cowork login, Figma login, SSO email, and GitHub handle often differ for the same person) and the previous auto-compare was producing false-alarm `⚠️` flags. The bootstrap now surfaces the Figma identity + the teams-on-file list and trusts the teammate to eyeball it.

1.2.1 — maintainer + ownership rename: all references to the previous owner replaced with Shrey (senior product designer, Petpooja · shrey@petpooja.com) across SKILL.md, READMEs, marketplace manifest, and the sync log. No behavior change.

1.2.0 — `/sync-pantheon` runs in evidence-only mode (every patched value cites a literal MCP source + a literal pre-patch file value, no narrative summaries, mandatory verification re-read). `/pantheon-bootstrap` now surfaces the authenticated Figma user prominently and asks the teammate to confirm it's their account before relying on sync output.

1.1.0 — adds automatic weekly re-sync (hook + /pantheon-bootstrap + LaunchAgent installer) and strict non-invention enforcement.
