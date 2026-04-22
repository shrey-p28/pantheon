# Pantheon — Component Reference

Working reference for picking a component and knowing its variant axes, state model, sizes, defaults, and composition. For each component, Claude needs: what it's for, what axes exist, state model, sizes, default, gotchas, and DOM shape. Not meant to be read end-to-end — grep for the component name.

Scope: 23 pages / 47 component sets / 1,655 variants. Hidden `Internal Only Canvas` copies (stale `Button`, `Tooltip` with typo'd `Postiton` axis, `_Supporting Text`) are ignored — the visible pages are canonical.

## Table of contents

- [Badges](#badges)
- [Bottom Sheet](#bottom-sheet)
- [Buttons](#buttons)
- [Cards](#cards)
- [Checkbox](#checkbox)
- [Chips](#chips)
- [Dropdown](#dropdown)
- [Icons](#icons)
- [List](#list)
- [Pop Up](#pop-up)
- [Radio Button](#radio-button)
- [Segment & Segment Navigation family](#segment--segment-navigation-family)
- [Side Drawer](#side-drawer)
- [Switch](#switch)
- [Table](#table)
- [Tabs](#tabs)
- [Text Input](#text-input)
- [Tooltip](#tooltip)
- [Not in Pantheon](#not-in-pantheon)

---

## Badges

**Node id:** `50:155` (page: Badges `50:222`)
**What it is:** Small status/count pill. Used next to titles, on nav items, on list rows.
**Component sets:** 1 — `Badges`.
**Variant axes:** `Size`: Large | Small.
**State:** None — purely decorative. Color is set by the surrounding context (success/warning/error/info) using semantic text + surface tokens, not a variant.
**Size:** Large | Small. No Medium.
**Default:** Small.
**Typography:** `Label/Small-Medium` (Small), `Label/Medium-Medium` (Large).
**Tokens used:** Surface accents (`Surface/Success`, `Surface/Warning`, `Surface/Error`, `Surface/Info`), `Text/Invert`, `Text/Primary`. 7 unique tokens on the page.
**When to use:** Counters (unread, new items), status pills (Active, Draft), short labels next to a title. For longer text or interactive filters, use Chips.
**Composition / code shape:** `<span class="badge badge--small">3</span>` — inline span with background + text color + radius. No icon slot in the component set; if a color-dot is needed, compose as `<span><i class="dot" /> Label</span>`.
**Gotchas:** Only two sizes. Don't use Badges as buttons — they're not focusable. Color is caller-supplied, not a variant.

---

## Bottom Sheet

**Node id:** `3562:1459` (page: Bottom Sheets `66:687`)
**What it is:** Mobile bottom-anchored modal surface for forms, pickers, destructive confirms.
**Component sets:** 1 — `Bottom Sheet`.
**Variant axes:** `State`: Default | Subtitle | Zero State.
**State meaning:** `Default` = title + content. `Subtitle` = title + subtitle + content. `Zero State` = empty/error illustration + message + CTA.
**Size:** Single width (1213 on spec, fluid to viewport on web/mobile). Content height flexes.
**Default:** Default state.
**Typography:** Title `Title/Medium-SemiBold`, Subtitle `Body/Medium-Regular`, Body `Body/Medium-Regular`.
**Tokens used:** `Surface/Primary`, `Border/Primary`, `Text/Primary`, `Text/Secondary`, `Square/Large` radius (top corners only), button tokens for CTAs. 24 unique tokens.
**When to use:** Mobile-first flows: filters, pickers, confirmation, item detail. On tablet/desktop, escalate to Pop Up or Side Drawer.
**Composition / code shape:**
```
<div role="dialog" aria-modal="true" class="sheet">
  <div class="sheet__grabber" />
  <header><h2>Title</h2><p>Subtitle?</p><button aria-label="Close">×</button></header>
  <div class="sheet__body">...</div>
  <footer class="sheet__ctas">...</footer>
</div>
```
**Gotchas:** Top corners radius `Square/Large` (12); bottom corners flush to viewport. Always include a grabber/handle and a close affordance. Lock body scroll when open.

---

## Buttons

**Node id:** `36:1881` (page: Buttons)
**What it is:** All CTAs — Primary, Tonal, Outline, Text, Icon-only. Segment buttons live under the Segment family below.
**Component sets (canonical, 5 + icon variants + text):**
1. `Primary` (`42:383`) — 72 variants
2. `Tonal` (`45:238`) — 72 variants
3. `Outline` (`45:303`) — 72 variants
4. `Primary Icon Button` (`45:355`) — 16 variants
5. `Tonal Icon Button` (`45:384`) — 16 variants
6. `Outline Icon Button` (`45:413`) — 16 variants
7. `Text Buttons` (`54:1035`) — 12 variants

**Variant axes:**
- Primary / Tonal: `Show Icon`: Leading | Trailing | None x `State`: Enabled | Pressed | Disabled x `Type`: Square | Round x `Size`: Extra Small | Small | Medium | Large
- Outline: same as Primary/Tonal but splits icon into `Show Icon`: True | False x `Icon Position`: Leading | Trailing
- Icon-only (Primary/Tonal/Outline Icon Button): `State`: Enabled | Disabled x `Type`: Square | Round x `Size`: XS | S | M | L. **No Pressed axis on Icon-only** — tap feedback is native.
- Text Buttons: `Icons`: Leading | Trailing | No Icons x `Size`: XS | S | M | L. **No State axis** — state flows from text color token.

**State model:** Enabled | Pressed | Disabled. **No Hover state.** On web, style `:hover` to match Pressed; style `:focus-visible` with a 2px `Border/Brand` outline.
**Size (heights):** Extra Small 32 | Small 36 | Medium 40 | Large 48. Icon size per button size: XS 16, S 18, M 20, L 24.
**Shape:** `Square` = `Square/Medium` (10) radius. `Round` = `Round/Rounded` (200 -> pill).
**Default:** Primary, Medium, Square, Enabled, no icon.
**Typography:** `Label/Medium-Medium` (most). POS screens: `Label/Large-Medium`.
**Tokens used:** `Buttons/Primary`, `Buttons/Primary Pressed`, `Buttons/Tonal`, `Buttons/Tonal Pressed`, `Buttons/Tertiary`, `Buttons/Disabled`, `Text/Invert`, `Text/Brand`, `Text/Disabled`, `Border/Brand`, `Border/Disabled`. 46 tokens on page.
**When to use which:**
- **Primary** — top CTA in a flow. One per screen. Solid brand fill, invert text.
- **Tonal** — secondary action (Save vs. Save & Close). Subtle brand-tinted fill, brand text.
- **Outline** — tertiary, modal dismiss, destructive-cancel. Transparent fill, brand border+text.
- **Text** — inline/row actions, "Forgot password?", toolbar tertiary.
- **Icon Only** — toolbar buttons, row actions, close (x). Always provide `aria-label`.
**Composition / code shape:**
```
<button type="button" class="btn btn--primary btn--md" aria-disabled={disabled}>
  {leadingIcon && <Icon name={...} size={20} />}
  <span>Label</span>
  {trailingIcon && <Icon name={...} size={20} />}
</button>
```
Icon-only: `<button aria-label="Close"><Icon name="close" /></button>`.
**Gotchas:**
- No Hover state in Figma -> map CSS `:hover` to Pressed tokens.
- Icon-only has no Pressed variant — lean on `:active` CSS.
- Text Buttons have no State variant — handle disabled via `color: Text/Disabled` + `pointer-events:none`.
- Don't mix Round and Square within the same screen cluster.

---

## Cards

**Node id:** `204:692` (page: Cards `2:113`)
**What it is:** Container for a single content unit — list items, summary tiles, clickable records.
**Component sets:** 1 — `Cards`.
**Variant axes:** `State`: Default | Pressed x `Type`: Stacked | Horizontal.
**State:** Default | Pressed. No Disabled, no Hover. Map CSS `:hover` and `:focus-visible` to Pressed.
**Type:** `Stacked` = image on top, content below (typical listing card). `Horizontal` = image left, content right (row layout).
**Default:** Stacked, Default.
**Typography:** Title `Title/Small-SemiBold`, Body `Body/Small-Regular`, Meta `Label/Small-Regular`.
**Tokens used:** `Surface/Primary`, `Border/Primary`, `Text/Primary`, `Text/Secondary`, `Square/Medium` radius. 22 unique tokens.
**When to use:** Any bounded content unit. For horizontal rows of mixed controls, use List Building Blocks instead.
**Composition / code shape:**
```
<article class="card card--stacked" tabindex="0">
  <img class="card__media" />
  <div class="card__body">
    <h3>Title</h3>
    <p>Body</p>
    <footer>...meta / CTAs...</footer>
  </div>
</article>
```
**Gotchas:** Use a 1px `Border/Primary` for separation — Pantheon prefers borders over shadows. If the whole card is clickable, wrap in `<a>` or give `role="button"` + keyboard handlers.

---

## Checkbox

**Node id:** `2334:225` (page: Checkbox `2331:76`)
**What it is:** Boolean / tri-state checkbox.
**Component sets:** 1 — `Checkbox`.
**Variant axes:** `Type`: Unselected | Indeterminate | Selected x `State`: Enabled | Disabled.
**State:** Enabled | Disabled. No Hover/Pressed — checkboxes rely on native focus ring.
**Size:** Single size only (no Size axis). Renders at 20x20 with 4px radius.
**Default:** Unselected, Enabled.
**Tokens used:** `Border/Primary`, `Border/Brand`, `Surface/Brand`, `Icon/Invert`, `Border/Disabled`. 4 tokens on page.
**When to use:** Multi-select. For single-choice use Radio Button. For on/off settings use Switch.
**Composition / code shape:**
```
<label class="checkbox">
  <input type="checkbox" checked={checked} indeterminate={mixed} disabled={disabled} />
  <span class="checkbox__box" aria-hidden="true" />
  <span class="checkbox__label">Label</span>
</label>
```
For React, set `indeterminate` via ref (`el.indeterminate = true`) — there's no JSX prop.
**Gotchas:** Indeterminate is a visual-only state; `checked` is still boolean underneath. Always pair with a `<label>` — the box alone is not a tap target.

---

## Chips

**Node id:** `57:448` (page: Chips `57:165`)
**What it is:** Filter / selection / tag pill. Can be toggled on/off, dismissable, or navigable.
**Component sets:** 1 — `Chips` (96 variants).
**Variant axes:** `State`: Active | Pressed | Selected x `Size`: XS | S | M | L x `Shape`: Round | Square x `Icons`: Leading | Trailing | Both | No Icons.
**State:** `Active` = default unselected, `Pressed` = tap/hover feedback, `Selected` = on. No Disabled variant — if you need disabled, gray out via `Text/Disabled` + `pointer-events:none`.
**Size:** XS 24h / S 28h / M 32h / L 36h (approximate from spec).
**Shape:** Round = pill radius (`Round/Rounded` 200). Square = `Square/Small` (8).
**Default:** Medium, Round, Active, no icons.
**Typography:** `Label/Small-Medium` (S/XS), `Label/Medium-Medium` (M/L).
**Tokens used:** `Surface/Primary`, `Surface/Brand Subtle`, `Border/Primary`, `Border/Brand`, `Text/Primary`, `Text/Brand`. 31 unique tokens.
**When to use:** Filter bars, tag inputs, quick-select chips. For exclusive single-select, use Segment. For destructive/permanent actions, use Buttons.
**Composition / code shape:**
```
<button role="checkbox" aria-checked={selected} class="chip chip--md chip--round">
  {leadingIcon && <Icon size={16}/>}
  <span>Label</span>
  {trailingIcon && <Icon size={16} aria-label="Remove"/>}
</button>
```
Trailing icon is usually an `x` remove affordance — wire it as a nested `<button>` with its own label.
**Gotchas:** A single chip uses `role="checkbox"`; a multi-select group should be wrapped in `role="group"`. For single-select exclusive groups, prefer Segment.

---

## Dropdown

**Node ids:** `2982:213` (main), `2788:132` (Labels block), `3034:567` (Checkbox block), `3034:1108` (Building Block) — page: Dropdown `2768:141`
**What it is:** Select / combobox / multi-select menu with optional search + CTA footer.
**Component sets:** 4 total:
1. `Dropdown` (`2982:213`) — the open menu surface. Axes: `Search`: True | False x `CTA`: False | True.
2. `Sub Building Blocks - Labels` (`2788:132`) — single row. Axes: `State`: Default | Selected | Hover x `Leading Icon`: True | False x `Trailing Icon`: True | False.
3. `Sub Building Blocks - Checkbox` (`3034:567`) — multi-select row. Axes: `State`: Default | Hover.
4. `Building Block` (`3034:1108`) — wrapper. Axes: `Type`: Default | Checkbox.

**State:** Rows have Default | Selected | Hover (Labels) or Default | Hover (Checkbox). The trigger itself is a Text Input — use Text Input state model.
**Size:** Single menu width (1112 spec). Row height 40.
**Default:** No search, no CTA, single-select (Labels rows).
**Typography:** Row label `Body/Medium-Regular`, section headers `Label/Small-Medium`.
**Tokens used:** `Surface/Primary`, `Surface/Brand Subtle`, `Border/Primary`, `Text/Primary`, `Text/Brand`, `Elevation/3`. 19 unique tokens.
**When to use:** Single- or multi-select from a finite list. For long free-text or multi-word entries, use Text Input with autocomplete. For exclusive visible options, use Segment.
**Composition / code shape:**
```
<div class="dropdown">
  <TextInput role="combobox" aria-expanded={open} aria-controls="menu" />
  {open && (
    <ul id="menu" role="listbox" class="dropdown__menu">
      {search && <li class="dropdown__search"><TextInput/></li>}
      {items.map(i => <li role="option" aria-selected={i.selected}>...</li>)}
      {cta && <li class="dropdown__cta"><button>Add new</button></li>}
    </ul>
  )}
</div>
```
Use `role="option"` (single-select) or a nested `<input type="checkbox">` (multi-select).
**Gotchas:** The dropdown trigger reuses Text Input — inherit its error/disabled states. Menu should float (use portal or `position: absolute`) and close on outside-click / Escape.

---

## Icons

**Node id:** page `2884:15439`
**What it is:** Full icon library. Three sets.
**Sets:**
1. **Outline** (`2890:13060`) — ~3,857 Material Symbols outline icons. Use as default.
2. **Filled** (`2890:28425`) — ~3,845 Material Symbols filled icons. Use for selected/active states, filled surfaces.
3. **Depreciated Icons** (`2896:12975`) — 1,318 legacy custom icons, 16x16 only. **Do not use in new work** — they're kept for backwards compat only.

**Widths (from tokens):** 16 (X Small), 18 (Small), 20 (Medium), 24 (Large). These map 1:1 to Button/Chip sizes.
**Variant axes:** None — individual icons are non-variant symbols. Pick by name.
**Tokens used:** `Icon/Primary`, `Icon/Secondary`, `Icon/Brand`, `Icon/Invert`, `Icon/Disabled`, `Icon/Error`, `Icon/Success`, `Icon/Warning`, status-specific icon tokens. 11 tokens on page.
**When to use:** Always pair icons with labels unless the icon is universally understood (close, search, add). Use Outline by default; Filled when the icon is selected or inside a filled container.
**Composition / code shape:**
```
<svg class="icon icon--md" aria-hidden="true" focusable="false" width="20" height="20"><use href="#icon-add"/></svg>
```
Icon-only interactive element: add `aria-label`. Decorative icon next to text: `aria-hidden="true"`.
**Gotchas:**
- Don't enumerate names — query the Figma library by name.
- Outline vs Filled is a stylistic choice, not a state variant. Most tap-states flip Outline->Filled.
- Never use Depreciated Icons in new surfaces. They are 16x16 fixed and have inconsistent stroke weights.

---

## List

**Node ids:** `3463:6582` (main), `3463:6529..6534` (building blocks) — page: List `3461:3`
**What it is:** Vertical stack of rows. Pantheon composes List from 6 building blocks by leading element, then a top-level `List` set switches between them.

**Component sets:** 7 total.
- **Main:** `List` (`3463:6582`) — 5 variants. `Type`: Switch | Checkbox | Radio | Image | None.
- **Building blocks (leading element):**
  1. `Building Block - Switch` (`3463:6529`) — 6 variants. `Text`: Default | 2 Lines | 3 Lines x `Trailing`: True | False.
  2. `Building Block - Checkbox` (`3463:6530`) — 6 variants. Same axes as Switch.
  3. `Building Block - Radio` (`3463:6531`) — 6 variants. Same axes.
  4. `Building Block - Image` (`3463:6532`) — 15 variants. `Text` x `Trailing`: None | Radio | Switch | Checkbox | Icon.
  5. `Building Block - None` (`3463:6533`) — 15 variants. Same as Image.
  6. `Building Block - Icon` (`3463:6534`) — 15 variants. Same as Image.

**Variant axes:** `Type` (which leading), `Text` (1/2/3 lines of text), `Trailing` (what's on the right side).
**State:** No explicit state axis on rows — interactive state comes from the leading control (Switch/Checkbox/Radio) or from wrapping the row in a button. For hover/pressed styling, use `Surface/Hover` and `Surface/Pressed` tokens.
**Size:** Row min-height 48. Multi-line expands up to ~96.
**Default:** Type=None, Text=Default (1 line), Trailing=None.
**Typography:** Primary `Body/Medium-Regular`, Secondary `Body/Small-Regular`, Tertiary `Label/Small-Regular`.
**Tokens used:** `Surface/Primary`, `Border/Primary` (row divider), `Text/Primary`, `Text/Secondary`, `Text/Tertiary`. 17 unique tokens.
**When to use:** Settings, menus, selection lists, nav drawers. Mix leading types within one list sparingly — pick one pattern per list.
**Composition / code shape:**
```
<ul role="list" class="list">
  <li role="listitem" class="list__row">
    <span class="list__leading">{/* Switch | Checkbox | Radio | img | Icon | nothing */}</span>
    <div class="list__content">
      <div class="list__title">Primary</div>
      <div class="list__subtitle">Secondary (optional)</div>
      <div class="list__tertiary">Tertiary (optional, 3-line)</div>
    </div>
    <span class="list__trailing">{/* Icon | control | nothing */}</span>
  </li>
</ul>
```
For selection lists, put the `<input type="checkbox|radio">` in the leading slot and wrap the row in `<label>`.
**Gotchas:** Building blocks are canonical — the "main" `List` set is a thin switcher. Always compose rows from the building blocks, not raw divs, to inherit spacing/dividers. Don't nest interactive elements in both leading and trailing slots without clear affordance.

---

## Pop Up

**Node id:** `3576:3149` (page: Pop Up `66:688`)
**What it is:** Center-anchored modal dialog for confirmation, info, destructive action.
**Component sets:** 1 — `Pop Up`.
**Variant axes:** `Type`: Default | Image.
**State:** No state axis — open or closed only.
**Size:** 540x756 on spec; content height flexes. Single width.
**Default:** Default (no image).
**Typography:** Title `Title/Medium-SemiBold`, Body `Body/Medium-Regular`.
**Tokens used:** `Surface/Primary`, `Border/Primary`, `Text/Primary`, `Text/Secondary`, `Square/Large` (12) radius, `Elevation/3`. 15 unique tokens. **Only component that uses `Elevation/3`.**
**When to use:** Destructive confirmation ("Delete this?"), critical info, small forms. For mobile flows prefer Bottom Sheet. For larger multi-step content use Side Drawer.
**Composition / code shape:**
```
<div class="backdrop" onClick={close}>
  <div role="dialog" aria-modal="true" aria-labelledby="t" class="popup" onClick={stopProp}>
    {variant === "Image" && <img class="popup__image" />}
    <h2 id="t">Title</h2>
    <p>Body</p>
    <footer class="popup__ctas">
      <Button variant="outline">Cancel</Button>
      <Button variant="primary">Confirm</Button>
    </footer>
  </div>
</div>
```
**Gotchas:** Trap focus inside; restore focus on close; close on Escape. Image variant puts illustration above the title — use for empty-state / celebratory modals. Destructive Pop Ups should still use Primary for the confirm CTA (color is not swapped to red — destructive semantics come from copy).

---

## Radio Button

**Node id:** `2382:184` (page: Radio Buttons `2381:1299`)
**What it is:** Single-choice exclusive selector.
**Component sets:** 1 — `Radio Button`.
**Variant axes:** `Selected`: False | True x `State`: Enabled | Disabled.
**State:** Enabled | Disabled. No Hover/Pressed variant.
**Size:** Single size (20x20). No size axis.
**Default:** Unselected, Enabled.
**Tokens used:** `Border/Primary`, `Border/Brand`, `Surface/Brand`, `Border/Disabled`. 4 tokens on page.
**When to use:** 2-5 mutually exclusive options visible at once. For >5 options or when space is tight, use Dropdown. For on/off, use Switch.
**Composition / code shape:**
```
<fieldset class="radio-group">
  <legend>Question?</legend>
  <label class="radio">
    <input type="radio" name="group" value="a" />
    <span class="radio__dot" aria-hidden="true"/>
    <span>Option A</span>
  </label>
  ...
</fieldset>
```
Always give all radios in a group the same `name` attribute and wrap in `<fieldset>` + `<legend>`.
**Gotchas:** No tri-state. Pair with `<label>`; never style a bare radio — the visible dot is a pseudo-element on a custom `span`.

---

## Segment & Segment Navigation family

Two parallel families — **Segmented Buttons** (form/filter exclusive toggles) and **Segment Navigation** (tab-like persistent nav). Each family ships three "end" building blocks (Left-End / Middle / Right-End) plus a composed top-level set.

**Page:** Buttons `36:1881` (sections "Segmented Buttons" `2114:600` and "Segmented Navigation" `39:148`).

**Component sets:** 8 total.

### Segmented Buttons family (4 sets)
Use for mutually-exclusive filter/toggle choices inside a form.
1. **`Segment Left-End`** (`36:1978`) — 48 variants. Axes: `Configuration`: Text + Icon | Text Only | Icon Only x `Shape`: Square | Round x `Selected`: True | False x `Size`: XS | S | M | L.
2. **`Segment Middle`** (`2133:366`) — 48 variants. Same axes.
3. **`Segment Right-End`** (`2134:1075`) — 48 variants. Same axes.
4. **`Segment Buttons`** (`2146:944`) — 32 variants (composed). Axes: `Segments`: 2 | 3 | 4 | 5 x `Type`: Round | Square x `Size`: XS | S | M | L.

### Segment Navigation family (4 sets)
Use for persistent page-level navigation (tabs alternative with a fuller fill style).
1. **`Segment Nav Left-End`** (`2100:1114`) — 24 variants. Axes: `Configuration`: Text + Icon | Text Only | Icon Only x `Selected`: False | True x `Size`: XS | S | M | L. (No Shape axis — Segment Nav is always square.)
2. **`Segment Nav Middle`** (`2110:356`) — 24 variants. Same axes.
3. **`Segment Nav Right-End`** (`2110:495`) — 24 variants. Same axes.
4. **`Segment Navigation`** (`2114:430`) — 16 variants (composed). Axes: `Segments`: 2 | 3 | 4 | 5 x `Size`: XS | S | M | L.

**State:** `Selected`: True | False only. No Disabled, no Hover/Pressed (apply via CSS).
**Size:** XS | S | M | L — heights match buttons (32/36/40/48).
**Shape (Segment Buttons only):** Square (`Square/Medium` 10) | Round (pill outer, square inner dividers).
**Default:** Segment Buttons — Size=Medium, Shape=Square, Configuration=Text Only. Segment Navigation — Size=Medium.
**Typography:** `Label/Medium-Medium`.
**When to use which:**
- **Segment Buttons** — short exclusive filters inside a form/toolbar ("All / Active / Archived"). 2-5 items max.
- **Segment Navigation** — persistent subsection switching on a page header. Visually heavier than Tabs; use when selection needs to feel like a filled control, not a tab.
- If you have >5 items or need overflow, use Tabs instead.

**Composition / code shape:**
```
<div role="tablist" aria-orientation="horizontal" class="segment segment--md">
  <button role="tab" aria-selected="true" class="segment__item segment__item--left">All</button>
  <button role="tab" aria-selected="false" class="segment__item segment__item--middle">Active</button>
  <button role="tab" aria-selected="false" class="segment__item segment__item--right">Archived</button>
</div>
```
Compose N-segment rows from Left-End + (N-2) Middle + Right-End. The composed `Segment Buttons` / `Segment Navigation` sets are convenience wrappers — you can use them directly when N is 2-5.
**Gotchas:** Only the composed top-level sets expose a `Segments` count axis — the end building blocks are meant to be assembled. Keep the count 2-5; above that, Tabs scroll/overflow better. Segment Navigation has no Shape axis (square only).

---

## Side Drawer

**Node id:** `3973:1956` (page: Side Drawer `2400:18`)
**What it is:** Right-anchored sheet for detail views, multi-step forms, secondary navigation.
**Component sets:** 1 — `Side Drawer`.
**Variant axes:** `State`: Default | Custom | Zero State.
**State meaning:** `Default` = standard header + body + footer. `Custom` = bring-your-own layout slot. `Zero State` = empty/loading illustration + message.
**Size:** 1818x808 on spec (desktop). On narrower viewports, fills to edge.
**Default:** Default.
**Typography:** Title `Title/Medium-SemiBold`, Body `Body/Medium-Regular`.
**Tokens used:** `Surface/Primary`, `Border/Primary`, `Text/Primary`, button tokens, `Square/Large` radius on left corners. 30 unique tokens (one of the token-heaviest components).
**When to use:** Desktop detail panels, edit forms, filters with many fields. For short confirmations use Pop Up. For mobile prefer Bottom Sheet.
**Composition / code shape:**
```
<aside role="dialog" aria-modal="true" aria-labelledby="t" class="drawer drawer--right">
  <header><h2 id="t">Title</h2><button aria-label="Close">x</button></header>
  <div class="drawer__body">...</div>
  <footer class="drawer__ctas"><Button variant="outline">Cancel</Button><Button>Save</Button></footer>
</aside>
```
**Gotchas:** Left-side corners use `Square/Large` (12); right side flush. Trap focus; close on Escape. Custom state is a blank slot — you own the padding inside it.

---

## Switch

**Node id:** `2546:1022` (page: Switch `2382:278`)
**What it is:** On/off toggle for settings.
**Component sets:** 1 — `Switch`.
**Variant axes:** `Selected`: True | False x `Type`: Default | Disabled x `Size`: Large | Small x `Icon`: False | True.
**State:** Default | Disabled. (`Selected` is value, not state.)
**Size:** Large | Small. No Medium. Large ~56x32, Small ~40x24.
**Icon:** Optional check/dash glyph in the thumb — use for higher-feedback toggles.
**Default:** Small, Selected=False, Type=Default, Icon=False.
**Tokens used:** `Surface/Brand`, `Surface/Tertiary`, `Surface/Primary` (thumb), `Border/Disabled`. 9 tokens on page.
**When to use:** Instant on/off settings (notifications, visibility). For multi-step / submit-on-save, use Checkbox.
**Composition / code shape:**
```
<label class="switch">
  <input type="checkbox" role="switch" aria-checked={on} disabled={disabled} />
  <span class="switch__track"><span class="switch__thumb" /></span>
  <span class="switch__label">Label</span>
</label>
```
**Gotchas:** Changes apply immediately — never require a Save button to commit a Switch. Use `role="switch"` for SR announcement of on/off (not just checkbox semantics).

---

## Table

**Node ids:** `2475:1461` (Body Block), `2480:1524` (Header Block), `2481:2093` (Sort States), `2481:2380` (sample Table) — page: Table `2436:798`
**What it is:** Data table with typed cells and sortable header blocks.
**Component sets:** 3 + 1 singular assembly.
1. **`Table Body Block`** (`2475:1461`) — 42 variants. Axes: `State`: Default | Selected | Hover x `Type`: Checkbox | Collapsible | Link | Text | Numbers | CTA | Text + CTA x `Line Size`: Single Line | Double Line.
2. **`Table Header Block`** (`2480:1524`) — 7 variants. Axes: `Type`: Checkbox | Collapsible | Sort | Text | Numbers | CTA | Text + CTA.
3. **`Sort States`** (`2481:2093`) — 3 variants. Axes: `State`: Default | Ascending | Descending.
4. **`Table`** (`2481:2380`) — singular (non-variant) sample assembly.

**State:** Row level — Default | Selected | Hover. No Disabled row.
**Cell Type:** 7 types. Match to data: numbers right-align, text left-align, CTA triggers row action, Collapsible expands detail, Link navigates.
**Line Size:** Single (default, ~48 row) | Double (~64 row, subtitle under primary).
**Default:** Body — State=Default, Type=Text, Line Size=Single Line. Header — Type=Text.
**Typography:** Header `Label/Small-SemiBold`, Body `Body/Medium-Regular`, Numbers `Body/Medium-Regular` tabular-nums.
**Tokens used:** `Surface/Primary`, `Surface/Hover`, `Surface/Selected`, `Border/Primary`, `Text/Primary`, `Text/Secondary`. 26 unique tokens.
**When to use:** Tabular data with comparison across rows. For single records use Cards or List.
**Composition / code shape:**
```
<table>
  <thead>
    <tr>
      <th><input type="checkbox" aria-label="Select all"/></th>
      <th aria-sort="ascending"><button>Name <SortIcon/></button></th>
      <th class="num">Amount</th>
      <th><span class="sr-only">Actions</span></th>
    </tr>
  </thead>
  <tbody>
    <tr aria-selected="true">
      <td><input type="checkbox"/></td>
      <td>Row</td>
      <td class="num">Rs 1,200</td>
      <td><Button variant="text">Edit</Button></td>
    </tr>
  </tbody>
</table>
```
Compose rows from Body Blocks; compose header from Header Blocks + Sort States (for sortable columns).
**Gotchas:** Sort States is a separate tiny component set — the sort arrow's three states (Default/Asc/Desc) are variants there, not inside Header Block. For numbers, enable `font-variant-numeric: tabular-nums`. Double Line wraps subtitle under primary text — pick per column, not per table.

---

## Tabs

**Node ids:** `52:508` (Label and Icon), `2210:1116` (Icon Only), `2202:1543` (Label Only), `2210:2737` (composed) — page: Tabs `47:626`
**What it is:** Horizontal tab bar for switching views within a screen. Underline-style selection.
**Component sets:** 4 total.
1. **`Label and Icon`** (`52:508`) — 12 variants. Axes: `State`: Enabled | Selected | Hover x `Size`: XS | S | M | L.
2. **`Icon Only`** (`2210:1116`) — 12 variants. Same axes.
3. **`Label Only`** (`2202:1543`) — 12 variants. Same axes.
4. **`Tabs`** (`2210:2737`) — 48 variants (composed). Axes: `Type`: Icon + Text | Icon Only | Text Only x `Size`: XS | S | M | L x `Tabs`: 2 | 3 | 4 | 5.

**State:** Enabled | Selected | Hover. **Tabs is the only component family with a real Hover variant** — use it.
**Size:** XS | S | M | L (heights ~32/36/40/48).
**Default:** Label Only (Text Only), Medium, Enabled.
**Typography:** `Label/Medium-Medium`.
**Tokens used:** `Text/Primary`, `Text/Brand`, `Border/Brand` (underline), `Surface/Hover`. 25 unique tokens.
**When to use:** Switching sibling views that share a parent context (e.g., Profile -> Orders / Reviews / Settings). For filled-pill nav use Segment Navigation. For page-level nav use top-bar navigation.
**Composition / code shape:**
```
<div role="tablist" class="tabs">
  <button role="tab" aria-selected="true" aria-controls="p1" id="t1" class="tab tab--selected">
    <Icon/> <span>Orders</span>
  </button>
  ...
</div>
<section role="tabpanel" id="p1" aria-labelledby="t1">...</section>
```
**Gotchas:** Selected indicator is a 2px `Border/Brand` underline, not a filled background. Arrow-key navigation between tabs is expected. Unlike Segment, Tabs has Hover state baked in — leverage it directly.

---

## Text Input

**Node id:** `2657:2898` (page: Text Input `66:685`)
**What it is:** Text field. Also used as the trigger for Dropdown and as search inputs.
**Component sets:** 1 — `Text Input` (480 variants, the largest set).
**Variant axes:**
- `Size`: Small | Medium | Large
- `State`: Active | Error | Input | Disabled | Default
- `Type`: Default | Suffix | Prefix
- `Leading Icon`: False | True
- `Trailing Icon`: False | True
- `Supporting text`: False | True
- `CTA`: False | True

**State meaning:**
- `Default` = empty, not focused.
- `Input` = has user value, not focused.
- `Active` = focused (with or without value).
- `Error` = validation failed (red border + error supporting text).
- `Disabled` = non-interactive.
(No "Hover" — hover is cosmetic via CSS.)

**Size:** Small 36 | Medium 40 | Large 48.
**Type:** `Prefix` = fixed text on the left (e.g., `https://`). `Suffix` = fixed text on the right (e.g., `.com`, units). `Default` = neither.
**Supporting text:** Helper or error message below the field (booleans True/False).
**CTA:** Inline trailing button (e.g., "Apply", "Send"). Uses Tonal-style fill.
**Default:** Medium, Default state, Type=Default, no icons, no supporting text, no CTA.
**Typography:** Value `Body/Medium-Regular` (14/22). Label `Label/Small-Medium` (12/20) when floated, `Body/Medium-Regular` in `Text/Tertiary` when acting as placeholder inside the empty field. Supporting text `Label/Small-Regular`.
**Tokens used:** `Surface/Primary`, `Border/Primary`, `Border/Brand`, `Border/Error`, `Text/Primary`, `Text/Secondary`, `Text/Tertiary`, `Text/Brand`, `Text/Error`, `Text/Disabled`, `Square/Small` (8) radius. 32 unique tokens.
**When to use:** Any free-text entry. For multi-select from a known list, use Dropdown (which uses Text Input as its trigger). Multi-line: no separate component — stretch this one's height and set `rows` on the textarea.

**Label behavior — this is Material Design 3 "outlined text field", NOT a stacked label.**
The label lives INSIDE the field's border. When the field is empty and unfocused, the label sits at vertical center and acts as the placeholder. When the field is focused or has a value, the label floats up and notches through the top border (the border breaks to accommodate the label at 12px inset from the left). Label position is state-dependent:

| State | Label position | Label style | Border |
|-------|----------------|-------------|--------|
| Default (empty + unfocused) | Inside, vertical center | `Body/Medium-Regular` in `Text/Tertiary` | `Border/Primary`, 1px |
| Active (focused) | Floated up, notched through top border, inset 12px from left | `Label/Small-Medium` in `Text/Brand` | `Border/Brand`, 1px flat — no glow |
| Input (has value, unfocused) | Floated up, notched | `Label/Small-Medium` in `Text/Secondary` | `Border/Primary`, 1px |
| Error | Floated up, notched | `Label/Small-Medium` in `Text/Error` | `Border/Error`, 1px |
| Disabled | Floated up, notched (or inside if empty-and-disabled) | `Label/Small-Medium` in `Text/Disabled` | `Border/Disabled`, 1px; fill `Surface/Tertiary` |

**Notch geometry:** Label inset 12px from the left edge. ~4px horizontal padding inside the notch gap. Label vertical center sits ON the top border line (so half the label is above, half is below — the border is "cut" around the text). 150ms ease-out animation between states.

**Composition / code shape:** Use `<fieldset>` + `<legend>` to get the native notched border — the legend's background color covers the top border exactly where the label appears, producing the cut-through automatically. This is how MUI's `OutlinedInput` and Material Web Components render the pattern.

```
<div class="field field--md field--active">
  <fieldset class="field__outline">
    <legend class="field__notch"><span>Email</span></legend>
    <div class="field__control">
      {leadingIcon && <Icon/>}
      {prefix && <span class="field__prefix">https://</span>}
      <input id="email" type="email" placeholder=" " aria-invalid={error} aria-describedby={error ? "email-err" : undefined}/>
      {suffix && <span class="field__suffix">.com</span>}
      {trailingIcon && <Icon/>}
      {cta && <Button variant="tonal" size="sm">Apply</Button>}
    </div>
  </fieldset>
  {supportingText && <div id="email-err" class="field__support">{message}</div>}
</div>
```
The legend renders inside the fieldset's top border; when empty, toggle a class that positions the label back inside via CSS. For multi-line, swap `<input>` for `<textarea rows={N}>` — same notched outline.
**Gotchas:**
- 480 variants — don't try to enumerate, compose by axis.
- **Do NOT render the label as a separate `<label>` row above the field** — that's the shadcn / Tailwind stacked pattern and it's the most common Pantheon-violation in generated UI. Pantheon is notched outline, always.
- Never use the Material "filled" variant (grey fill + bottom underline). Pantheon is strictly the outlined variant.
- Never add a focus glow ring (no `box-shadow` on focus). Focus is communicated by `Border/Brand` color + the label color change, nothing else.
- No dedicated multi-line variant. Use `<textarea>` with the same visual tokens.
- Error state must be paired with `Supporting text: True` (otherwise the user sees a red box with no reason). Wire `aria-describedby` to the supporting text.
- Prefix/Suffix are visual-only — the underlying `<input value>` should NOT include them.

---

## Tooltip

**Node id:** `4427:5058` (canonical, page: Tooltip `2380:1293`)
**What it is:** Floating text label triggered on hover/focus/long-press. 12 arrow positions.
**Component sets:** 1 canonical — `Tooltip`. (A stale duplicate with typo'd `Postiton` axis exists on the hidden `Internal Only Canvas` — ignore it.)
**Variant axes:** `Position`: Bottom-center | Top-center | Top-right | Top-left | Right-center | Left-center | Left-top | Left-bottom | Right-top | Right-bottom | Bottom-right | Bottom-left x `Title`: true | False x `Icon`: True | False x `CTA`: False | True. (72 variants)
**State:** No state axis — tooltip is either visible or not.
**Size:** Content-driven; single style.
**Default:** Bottom-center, no title, no icon, no CTA.
**Typography:** Body `Label/Small-Regular`, Title `Label/Small-SemiBold`.
**Tokens used:** `Surface/Inverse` (dark), `Text/Invert`, `Square/Small` (8) radius. 17 unique tokens.
**When to use:** Supplemental info for icon-only buttons, form labels, truncated text. Not for critical info (users can miss it) and not on mobile (no hover).
**Composition / code shape:**
```
<button aria-describedby="tip-1">...</button>
<div id="tip-1" role="tooltip" class="tooltip tooltip--bottom-center">
  {title && <div class="tooltip__title">Title</div>}
  <div class="tooltip__body">{icon && <Icon/>}Message</div>
  {cta && <button class="tooltip__cta">Action</button>}
</div>
```
**Gotchas:**
- The canonical axis is `Position` (correctly spelled). The hidden dup has `Postiton` — do not query that.
- Show on hover AND focus (keyboard users). Hide on Escape.
- Position token names (e.g., `Top-left`) mean the tooltip appears ABOVE the target, with its arrow at the left of the tooltip body.

---

## Not in Pantheon

Components Claude may be asked for that don't have dedicated sets. Compose from primitives.

- **Avatar** — compose from a `<span>` with `Round/Rounded` (200) radius, size = icon Width scale (16/20/24/40/64), `Surface/Brand Subtle` fill, `Text/Brand` initials.
- **Banner / Alert / Inline Notification** — compose from Cards + status tokens (`Surface/Success/Warning/Error/Info` + matching `Icon/*` + `Text/*`). 1px `Border/*` variant.
- **Accordion** — compose from List `Building Block - Icon` (chevron trailing) + collapsible content panel below. Animate max-height.
- **Pagination** — compose from Text Buttons (prev/next) + Icon Only Buttons (numbered) + a "x of y" `Label/Small-Regular`.
- **Breadcrumb** — compose from Text Buttons separated by `chevron-right` Outline icons at size 16.
- **Stepper / Wizard progress** — compose from numbered circles (Primary Icon Button, Round) + connecting 1px `Border/Primary` lines.
- **Loader / Spinner** — no component. Use a CSS animation on a `Border/Brand` circle segment, or an SVG spinner. No size tokens ship.
- **Search Bar** — use Text Input with `Leading Icon: True` (search glyph), `Type: Default`, optional `Trailing Icon: True` (clear x), `Size: Medium`.
- **Date Picker** — page exists (`3980:641`) but is empty / not yet built. Compose a trigger from Text Input with trailing calendar icon + a custom calendar Pop Up or Dropdown surface until the component ships.
- **Toast / Snackbar** — no component. Compose from a Card-shaped surface with status tokens; auto-dismiss after 4-6s; place bottom-center (mobile) or bottom-right (desktop).
- **Progress Bar** — no component. Compose from two 4px-tall divs: track `Surface/Tertiary`, fill `Surface/Brand`, both with `Square/Small` radius.
- **Skeleton** — no component. Compose from shimmer-animated `Surface/Tertiary` blocks at the same dimensions as the target.

---

## Cross-component gotchas

- **No Hover state** on Buttons, Cards, Chips, Segment. Only Tabs and some dropdown/list sub-blocks have a Hover variant. Map CSS `:hover` to Pressed/Selected tokens elsewhere.
- **Spacing is not tokenized.** Use the 8-pt grid (4/8/12/16/20/24/32/48/64). Never 13/17/21 px.
- **Shadows are rare.** Only `Elevation/3` exists (Pop Up). Prefer 1px `Border/Primary` for separation.
- **Hidden `Internal Only Canvas`** has stale copies of Button (with Hover + color-hierarchy axes), Tooltip (typo'd `Postiton`), and `_Supporting Text`. Ignore them — the visible pages are source of truth.
- **Icon widths** (16/18/20/24) map 1:1 to button/chip size (XS/S/M/L). Keep them in sync.
- **Date Picker** and **Toast / Snackbar** / **Loader** are not in Pantheon. Composable from primitives as noted above.
