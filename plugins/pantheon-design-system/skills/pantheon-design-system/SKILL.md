---
name: pantheon-design-system
description: Apply Petpooja's Pantheon design system (tokens, Prometheus typography, component library) to every visual or branded output produced for Grish. Use this skill whenever the task involves UI, web/app components, mockups, wireframes, Figma-style layouts, documents (docx/pdf), presentations (pptx), posters, marketing assets, brand content, dashboards, data viz, or anything where colors, typography, spacing, or components are chosen — even if the user doesn't explicitly say "Pantheon," "brand," or "design system." Petpooja's brand blue is #1770ee and the typeface is Inter (branded as Prometheus). When in doubt about whether a task is visual enough to trigger this skill, trigger it.
---

# Pantheon — Petpooja's design system

Every visual artifact Grish (grishma.shah@petpooja.com, design lead at Petpooja) asks for should look like it came out of Pantheon. That means tokens by name, Prometheus type, Pantheon components, and the restrained editorial tone the system is built around. Do not invent colors, type scales, or components when a Pantheon equivalent exists.

## Pre-flight checklist — run this before writing any visual output

Before producing a mockup, component, document, deck, or any artifact with visual choices, answer these five questions silently. If you can't answer any of them from the reference files, read the relevant reference before starting.

1. **Which theme?** POS Light (default), POS Dark, Billing, or Payroll. This decides the Gray ramp, Surface primitives, and whether Purple resolves Light or Dark.
2. **Which semantic tokens?** Every color must be a named Pantheon token — `Surface/Primary`, `Text/Brand`, `Border/Error`, etc. Never a raw hex that isn't already resolved from a token.
3. **Which Prometheus type styles?** Name the composite (`Prometheus/Title/Large-Bold`, `Body/Medium-Regular`, etc.). Letter-spacing 0 everywhere.
4. **Which Pantheon components?** List the component(s) you'll compose with (Button, Text Input, Chips, Card, Table, Segment, Switch, Tabs, etc.).
5. **Component mapping test — the hard gate.** Enumerate every distinct element you're about to place on the page (header, card, pill, divider, toggle, nav, badge — everything) and name the specific Pantheon component each one resolves to. If any element doesn't map cleanly to a Pantheon component, **delete it or replace it with a Pantheon-native alternative before writing a single line of code.** No "I'll improvise this one." No "this is just a small touch." If it's on the page, it has a Pantheon name.

If any answer is "I'll wing it," stop and read `references/tokens.md` or `references/components.md` first.

## Strict non-invention — if it's not in Pantheon, don't ship it

This is the rule that overrides every "it would look nicer with…" instinct: **if a component isn't in Pantheon's library, either use a Pantheon equivalent or leave it out. Never silently invent a new one, and never invent one just because flagging the gap feels like enough permission — it isn't.**

Two failure modes to watch for, both common:

1. **Pattern-matching from the wider web.** "Pricing pages usually have a monthly/annual toggle." "Dashboards usually have a filter bar." "Landing pages usually have a hero banner." That is not a reason to add one. Grish asked for a pricing card — build a pricing card out of Pantheon components. If the page *might* benefit from a switcher, check first: Pantheon ships `Switch` (binary), `Segment` and `Segment Navigation` (8 component sets for 2–4 exclusive options), `Chips` (filter/tag selection), and `Tabs` (view switching). One of those is almost always the right answer. If none of them fits, **omit the control entirely** and mention the gap in one closing line.

2. **Treating "call out the gap" as permission to build it.** It isn't. Flagging the gap replaces shipping the invented component, not accompanies it. If Pantheon doesn't have a pill-shaped billing-period toggle and you build one anyway with a note saying "Pantheon doesn't ship this natively," you've still shipped a non-Pantheon component. Flag **and** omit.

The only exception: if the user's prompt explicitly requests something outside Pantheon (e.g., "add a banner even though Pantheon doesn't have one"), compose it from the closest Pantheon primitives, name which primitives you borrowed from, and keep the styling inside Pantheon's token and typography grammar. Never introduce new visual primitives (gradients, custom shadows, pill shapes outside `Round/Rounded`, decorative dividers, icon-in-circle ornaments) that aren't already defined in Pantheon.

## Component-first rule — reuse, don't reinvent

**Use Pantheon components, not generic HTML / Material / shadcn / Bootstrap equivalents.** A page that needs a submit control uses the Pantheon `Button` (Primary / Tonal / Outline / Text / Icon-only variants) — not a styled `<button>` element built from scratch. A page that needs a text field uses Pantheon `Text Input` — not a custom `<input>` with arbitrary padding.

Anti-patterns to avoid on every task:

- ❌ A raw `<button style="...">` in React / HTML. ✅ The Pantheon Button component (or a faithful CSS reproduction of its spec: height from the button-height scale, `Buttons/Primary` fill, `Label/Medium-Medium` type, corner `Square/Medium`).
- ❌ A custom input with `border: 1px solid #ccc`. ✅ Pantheon Text Input (`Border/Primary` default, `Border/Brand` focus, `Border/Error` error, 40px height, `Square/Small` radius).
- ❌ Cards invented ad-hoc. ✅ Pantheon Card composition — `Surface/Primary` fill, 1px `Border/Primary`, `Square/Medium` radius, no drop shadow.
- ❌ Chips / pills styled with arbitrary pastels. ✅ Pantheon Chips with the matching accent family slot (`Chips/Accent-Green`, `Chips/Accent-Pink`, etc.).
- ❌ A "search bar" component. ✅ Compose from Text Input + leading icon — Pantheon doesn't ship a Search Bar. If the user didn't explicitly ask for search, leave it out.
- ❌ A pill-shaped "Monthly / Annually" or "Tab A / Tab B" switcher built from scratch. ✅ Pantheon `Switch` (binary on/off), `Segment` / `Segment Navigation` (2–4 exclusive options — 8 sets exist in Pantheon), or `Tabs` (view switching). **If the prompt didn't ask for a switcher, don't add one at all** — that's inventing chrome the design system doesn't authorize.
- ❌ Adding components the prompt didn't request "because this kind of page usually has them" (billing toggles on pricing pages, filter bars on lists, hero banners on landing pages, decorative dividers). ✅ Build only what was asked using Pantheon components. One line at the end can *suggest* additions — don't ship them.
- ❌ Material / shadcn `Avatar`, `Accordion`, `Banner`, `Pagination`, `Breadcrumb`, `Stepper`, `Loader`. ✅ Omit unless the prompt explicitly required it. If required, compose from Pantheon primitives (see `references/components.md` for recipes) and flag the gap in a single closing line.
- ❌ Inline `color: #1770ee`. ✅ `var(--text-brand)` / `Text/Brand` token.
- ❌ `font-family: "Helvetica"` / `"Arial"` / `"SF Pro"`. ✅ Inter / Prometheus.
- ❌ `border-radius: 6px` / `10.5px` / any off-scale value. ✅ `Square/Small` (8) · `Square/Medium` (10) · `Square/Large` (12) · `Round/Rounded` (200).
- ❌ Drop shadows on cards "for depth." ✅ 1px `Border/Primary`. Shadow is reserved for Pop Up (`Elevation/3`).

When composing in React / HTML, if no component library is imported, **faithfully reproduce the Pantheon component spec** (exact height, exact border, exact radius, exact token, exact Prometheus composite) rather than approximating. The reference spec lives in `references/components.md`.

The skill ships with four reference files — load whichever matches the lookup:

- **`references/tokens.md`** — every color token with hex, full Prometheus type scale, sizing, radius, elevation. **Load whenever you need a specific hex or a token that isn't on the cheat-sheet below.**
- **`references/components.md`** — every component: variant axes, states, sizes, composition tips, when-to-use guidance, gotchas. **Load whenever you're choosing or building a component.**
- **`references/full_inventory.md`** — raw 1,785-line file inventory with node IDs, variant counts, dimensions. Only load when you need specific node IDs or to sanity-check an exotic structural question.
- **`references/raw_variables_extraction.md`** — raw `get_variable_defs` output, per-page token counts, collision notes. Only load when debugging a token discrepancy.

The extraction is **comprehensive**: all 23 pages, 47 component sets, 1,655 variants, every semantic token, every primitive ramp (recovered directly from the Colors page swatch frames), and every Prometheus composite. What's in the reference files is what's in Pantheon.

## Brand identity (non-negotiable)

- **Brand color:** `#1770ee` (Petpooja blue). Drives `Buttons/Primary`, `Text/Brand`, `Border/Brand`, `Icon/Brand`.
- **Typeface:** Inter, called **Prometheus** inside Pantheon tokens. Letter-spacing 0 everywhere. Web fallback stack: `"Inter", -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif`.
- **Tone:** clean, editorial, generous whitespace, restrained palette, a single strong accent. Avoid gradients, drop shadows (except `Elevation/3` on Pop Up), decorative patterns, skeuomorphism. When in doubt, pull back.

## Color tokens — use the name, not the hex (cheat sheet)

Pantheon ships four parallel scales for every semantic role: **Surface** (fills), **Text**, **Icon**, **Border**. Always pair them — don't put `Text/Error` on a random red; pair it with `Surface/Error` + `Border/Error`.

The tokens you'll use 90% of the time:

| Token | Hex | Where |
|---|---|---|
| `Surface/Primary` | `#ffffff` | Page/card backgrounds |
| `Surface/Secondary` | `#fafafa` | Subtle fill, alternating rows |
| `Surface/Tertiary` | `#f0f0f0` | Deeper neutral fill |
| `Surface/Brand` | `#e8f1fd` | Tonal-brand fill, selected rows |
| `Surface/Brand Secondary` | `#f9e9ea` | Soft brand-secondary tint |
| `Surface/Accent-Navy Blue` | `#d7e6ff` | Hero blocks, callouts |
| `Surface/Error` / `Warning` / `Success` | `#fbeae9` / `#fef5d3` / `#eefff5` | Status tints |
| `Text/Primary` | `#000000` | Body copy, headings |
| `Text/Secondary` | `#666666` | Metadata, secondary copy |
| `Text/Tertiary` | `#999999` | Placeholder, low-emphasis |
| `Text/Invert` | `#ffffff` | Text on dark surfaces / on `Buttons/Primary` |
| `Text/Brand` | `#1770ee` | Links, brand callouts |
| `Text/Error` | `#d92d20` | Error messages |
| `Border/Primary` | `#e5e5e5` | Default dividers, card borders |
| `Border/Strong` | `#999999` | Emphasis borders |
| `Border/Brand` | `#1770ee` | Focus ring, selected state |
| `Border/Error` | `#d92d20` | Error inputs |
| `Border/Disabled` | `#cccccc` | Disabled |
| `Icon/Primary` | `#000000` | Default icon |
| `Buttons/Primary` | `#1770ee` | Primary CTA fill |
| `Buttons/Primary Pressed` | `#125abe` | Primary active |
| `Buttons/Tonal` | `#e8f1fd` | Tonal button |
| `Buttons/Tonal Pressed` | `#d1e2fc` | Tonal active |
| `Buttons/Tertiary` | `#ffffff` | Outline/ghost fill |
| `Buttons/Disabled` | `#f5f5f5` | Disabled button fill |

For any other token (opacity-state overlays, primitive ramp steps, status shades), read `references/tokens.md`.

### Accent palette for charts, categorization, status
Pantheon ships **eight** accent families, each with a full 9-step ramp (100–900): **Aqua, Beige, Green, Yellow, Navy Blue, Orange, Pink, Purple**. Every accent family has Surface / Text / Border / Icon / Notch / Chips / Card semantic slots (see `references/tokens.md`). For multi-series charts cycle through the families in the order listed; don't double-up on a ramp until you've exhausted all eight. `Purple` additionally has a theme-specific Dark variant used under POS Dark — when the target theme is POS Dark, read Purple from its Dark ramp.

### Themes — POS Light / POS Dark / Billing / Payroll
Pantheon is theme-aware. Four themes exist: **POS Light** (default), **POS Dark**, **Billing**, **Payroll**. Semantic tokens resolve to different primitives per theme — most notably the **Gray ramp is inverted under POS Dark** (`Gray-0` becomes near-black `#0E0E19`, `Gray-1000` becomes white). Unless Grish specifies otherwise, target POS Light. If the ask mentions "dark mode," a POS screen shown at night, or a Payroll / Billing surface, load the theme-specific columns from `references/tokens.md`.

### Known gotchas (read once, then file away)
- `Text/Disabled` resolves to the same hex as `Text/Tertiary` (`#999999`). Keep the semantic distinction in code; they render identically today.
- Aqua labels in the swatch frame read `100–108` (off-by-one typo). The tokens are `Aqua-100 … Aqua-900` in Variables.
- Warning ramp === Yellow ramp, pixel-for-pixel. Treat as aliases.
- Error ramp defines only `100 / 500 / 600`. If you need an intermediate shade, flag the gap rather than inventing.
- Gray ramp uses canonical names `Gray-0` (white in Light / near-black in Dark) and `Gray-1000` (black in Light / white in Dark). Not `Gray-100` and `Gray-900`.
- Pantheon's "Primary" frame on the Colors page is an Atlas-legacy cyan ramp, not the brand blue. For UI primary, use `Buttons/Primary` / `Text/Brand` / `Border/Brand` (all `#1770ee`).
- A handful of semantic aliases skip the expected step (e.g. `Text/Accent-Pink` → Pink-**600**, not -500; `Notch/Accent-Green` → Green-**600**; `Border/Accent-Purple` → Purple-**500**). When composing an accent family, look up the specific alias in `references/tokens.md` rather than assuming `-500/-700`.

## Typography — Prometheus

Four families × three sizes. Sizes below are `font-size / line-height` in px. Letter-spacing 0 throughout.

| Family | Large | Medium | Small |
|---|---|---|---|
| Display | 32 / 40 | 24 / 32 | 20 / 28 |
| Title | 18 / 26 | 16 / 24 | 14 / 22 |
| Body | 16 / 24 | 14 / 22 | 12 / 20 |
| Label | 14 / 22 | 12 / 20 | 10 / 18 |

Weights: Regular 400, Medium 500, SemiBold 600, Bold 700. **Labels only use Medium and SemiBold.**

Defaults that rarely need questioning:
- Body copy → `Prometheus/Body/Medium-Regular`
- Section heading → `Prometheus/Title/Large-Bold` (→ `Title/Medium-SemiBold` → `Title/Small-Medium`)
- Hero / splash → `Prometheus/Display/Large-Bold`
- Button label → `Prometheus/Label/Medium-Medium` (or `Label/Large-Medium` on POS screens)
- Caption / metadata → `Prometheus/Label/Small-Medium` or `Body/Small-Regular`

Full Prometheus matrix (42 composite styles) is in `references/tokens.md`.

## Sizing, radius, grid, elevation

- **Corner radius:** `Square/Small` 8 · `Square/Medium` 10 · `Square/Large` 12 · `Round/Rounded` 200 (pill). Default `Medium` for cards / most buttons, `Small` for chips / inputs, `Large` for modals and bottom sheets.
- **Icon / element widths:** `X Small/Width` 16 · `Small/Width` 18 · `Medium/Width` 20 · `Large/Width` 24.
- **Button heights:** Extra Small 32 · Small 36 · Medium 40 · Large 48.
- **Spacing:** No dedicated token collection — use the **8-pt grid** (4, 8, 12, 16, 24, 32, 48, 64). Don't invent 13px or 17px gaps.
- **Elevation:** only one named shadow — `Elevation/3` (composite of `0 1px 3px 0 rgba(0,0,0,0.30)` + `0 4px 8px 3px rgba(0,0,0,0.15)`), used on Pop Up. For cards, prefer a 1px `Border/Primary` over any shadow.

## Components — use these, don't build alternatives

The canonical Pantheon library:

**Actions:** Buttons (Primary, Tonal, Outline, Text, Icon-only), Segment + Segment Navigation family (8 sets).
**Inputs:** Text Input, Chips, Dropdown, Checkbox, Radio Button, Switch.
**Navigation / structure:** Tabs (4 sets), Tooltip, Badges.
**Containers:** Cards, Bottom Sheet, Side Drawer, Pop Up.
**Collections:** Table (with Header Block / Body Block), List (with building blocks: Switch / Checkbox / Radio / Image / None / Icon).
**Icons:** Outline set (~3,857 Material Symbols), Filled set (~3,845), plus a `Depreciated Icons` group (1,318 legacy custom icons — avoid).

**Button states are Enabled / Pressed / Disabled.** There's no Hover — on web, map `:hover` to the Pressed visual.

For any component decision (variant axes, sizes, compositional structure, DOM shape), load `references/components.md` — it has every component with axes, states, defaults, token usage, and a composition tip.

### Not in Pantheon — don't reach for Material / iOS / shadcn

Avatar, Banner, Accordion, Pagination, Breadcrumb, Stepper, Loader/Spinner, Search Bar, pill-shaped segmented toggles beyond what Segment / Segment Navigation already provide. Date Picker page exists but is empty. **Default action when one of these would "fit" the page: omit it.** Only compose from primitives if the user's ask genuinely requires it (e.g., they explicitly said "add a banner"). In that case, use Pantheon Building Blocks, Chips, Text Input, Pop Up as the parts, keep styling inside Pantheon's token/typography grammar, and call out the gap in one closing line so Grish can feed it back to the design team. `references/components.md` has recipe hints for each.

## Output conventions by format

**Web / React.** Declare tokens as CSS variables (`--surface-primary`, `--text-brand`, `--border-primary`, etc.) and use `var(--text-brand)` instead of hardcoded hex. Font-family `"Inter", -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif`. Borders 1px solid `var(--border-primary)`. Corner radii from the Square scale. Button heights from the scale above. No custom shadows.

**Word documents (.docx).** Inter throughout. Body in `Text/Primary`. Headings use the Title hierarchy. Callouts / links in `Text/Brand`. Tables: `Border/Primary` dividers, `Surface/Secondary` alternating rows. No color blocks for their own sake.

**PDFs.** Same rules as docx. For data-heavy PDFs, numeric columns right-aligned, headers in `Title/Small-SemiBold`.

**Slide decks (.pptx).** 16:9, white master. Section tints use `Surface/Accent-Navy Blue` (`#d7e6ff`). Titles `Display/Medium-Bold` or `Title/Large-Bold`. Body `Body/Medium-Regular`. Chart series cycle through the eight accent families (Aqua → Beige → Green → Yellow → Navy Blue → Orange → Pink → Purple). One concept per slide.

**Posters / marketing.** One hero image, one accent color (usually `Text/Brand`), typographic emphasis via Display scale. No gradients. No drop shadows.

**Dashboards / data viz.** Big numbers in `Display/Medium-Bold` or `Display/Small-Bold`. Labels in `Label/Small-Medium`. Chart lines/bars cycle through the eight accent families. Grid lines `Border/Primary` at reduced opacity.

## Resolving unknown tokens live from Figma

If a specific token, variant, or component prop isn't covered in the reference files and the Figma MCP is connected, resolve it live rather than guessing:

- File: https://www.figma.com/design/l8qALS4HQUMbSTyP8BTGRL/Pantheon
- File key: `l8qALS4HQUMbSTyP8BTGRL`
- Full-file dump: `mcp__figma-local__get_metadata` with `nodeId=0:0` (1.67M chars — use a subagent to parse)
- Variables resolve at page level. Token-rich pages to query with `get_variable_defs`:
  - Typography → `66:686`
  - Text Input → `66:685`
  - Cards → `2:113`
  - Buttons → `36:1881`
  - Colors → `66:689`
- For a visual reference of a component, `get_screenshot` on its node id (IDs are in `references/full_inventory.md`).

If the Figma MCP isn't connected, use the reference files — don't silently invent values.

## Working style

When Grish asks for something visual, don't narrate the design system at her — she wrote it. Apply it. A good response ships the artifact; a weak response explains it. If a decision is ambiguous (e.g., "Title/Large or Display/Small?"), pick the one that fits the information density and move on — she'll redirect if needed.

If a task clearly falls outside Pantheon's current coverage (a component that doesn't exist, a novel chart type, a new surface), **first decide whether Grish actually asked for it.** If she didn't, omit it and mention the gap in one closing line. If she did, compose it from Pantheon primitives — staying inside the token and typography grammar — and still flag the gap so it can be fed back into the system. Flagging is never a substitute for adding it to Pantheon later; it is the substitute for building it as a one-off today.
