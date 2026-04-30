---
name: pantheon-design-system
description: Apply Petpooja's Pantheon design system to every visual or branded output. Use this skill whenever the task involves UI, web/app components, mockups, wireframes, **Figma files**, documents (docx/pdf), presentations (pptx), posters, marketing assets, brand content, dashboards, data viz, or anything where colors, typography, spacing, or components are chosen — even if the user doesn't explicitly say "Pantheon," "brand," or "design system." When the target is Figma, this skill REQUIRES Claude to import real library component instances from the Pantheon Figma library (file key `l8qALS4HQUMbSTyP8BTGRL`, library key `lk-e668811788fb5b438ff0a2abb7aef68c6d641138b51a91d88632b2e6b725462df96674d94af000be5e7eeb211c7fd8189c84e25da686ed4f3878eb9dd81794f0`) via the Figma MCP using `importComponentSetByKeyAsync` — NEVER to redraw shapes, recolor rectangles, or recreate components. Petpooja's brand blue is `#1770ee` and the typeface is Inter (branded as Prometheus). When in doubt about whether a task is visual enough to trigger this skill, trigger it.
---

# Pantheon — Petpooja's design system

Every visual artifact a designer asks for must look like it came out of Pantheon. That means tokens by name, Prometheus type, **real Pantheon component instances** (imported from the Figma library when the target is Figma; faithfully reproduced from the spec when the target is code/docs/decks), and the restrained editorial tone the system is built around. Do not invent colors, type scales, or components when a Pantheon equivalent exists. Do not redraw a component when you can import one.

## STEP 0 — Detect the output target before anything else

Before touching anything visual, decide which path you're on. This decision routes the whole rest of the task.

| If the user is asking for… | Target | Path |
|---|---|---|
| "design this in Figma," "make a Figma file," "add this to the Pantheon Figma," "mock this up in Figma," "show me a Figma frame," any output that lives in a `.fig` file | **Figma** | **Figma-authoring path** (§1, mandatory) |
| React / HTML / Vue / Tailwind / shadcn / a coded prototype | **Code** | Code-fidelity path (§2) |
| `.docx`, `.pdf`, `.pptx`, posters, marketing collateral | **Document** | Document path (§3) |
| Dashboard, chart, data visualization (in any format) | depends on which of the above the deliverable lives in | Route by deliverable |

**If the target is Figma and the official Figma MCP (`use_figma`, `create_new_file`, `search_design_system`, `get_libraries`, `add_code_connect_map`) is connected, you MUST take the Figma-authoring path. Refusing to use the MCP and instead "describing what the Figma file would look like" or producing an SVG/HTML mockup as a substitute is itself a Pantheon violation.** If the MCP is not connected, say so explicitly and ask the user to connect it before proceeding — don't silently fall back to drawing.

---

## §1 — Figma-authoring path (MANDATORY when target is Figma)

This is the section that fixes the problem of Claude redrawing components instead of importing them. Read it in full before issuing your first MCP call.

> **Before any `use_figma` call:** if a `/figma-use` skill is available in this Claude session, load it first — the official Figma MCP tool description requires it. Then come back here.

### 1.1 The non-negotiables — read these out loud before you write any tool call

1. **You import component INSTANCES from the Pantheon library. You do not draw rectangles that look like buttons.** The deliverable is a Figma file in which every interactive element, every input, every container, every chip, every tab, every tooltip is a *real instance* of a Pantheon component set. Imports go through `figma.importComponentSetByKeyAsync(componentKey)` (for component sets — almost everything in Pantheon) or `figma.importComponentByKeyAsync(componentKey)` (for singular components). If an element on your frame is not an instance of a Pantheon component, the work is wrong and must be redone.
2. **You bind to the published library variables and styles. You do not paste hex values into fills.** Surface, Text, Border, Icon, Buttons/* — every color comes from the bound variable. Every typography style is one of the 42 Prometheus composites from the published Text Styles. Letter-spacing 0 throughout.
3. **You name elements with their semantic Pantheon names.** A frame is `Card / Hero` not `Frame 47`. A text layer is `Title / Large-Bold` not `Heading`. An instance is named after its component. Auto-layout direction, padding, and gap are set from the 8-pt grid (4, 8, 12, 16, 24, 32, 48, 64) — never an off-grid value.
4. **You publish nothing. You insert from the published library.** Pantheon is the source of truth. The teammate's working file consumes the library; it doesn't republish to it. If you find yourself about to detach an instance "to tweak a color," stop — bind a different variable instead, or change the variant property.

### 1.2 Three identifiers — keep them straight

The single biggest source of bugs in Figma authoring is conflating these three. Get this right and most of §1 follows mechanically.

| Identifier | What it is | Looks like | Used for |
|---|---|---|---|
| **File key** | The Figma URL identifier for a `.fig` file | `l8qALS4HQUMbSTyP8BTGRL` (22 chars) | URL parameter for `get_libraries`, `get_metadata`, `get_variable_defs`, `get_screenshot`, `get_design_context`, `use_figma` |
| **Library key** | A globally-unique key for a published team library | `lk-e668811788fb5b438ff0a2abb7aef68c6d641138b51a91d88632b2e6b725462df96674d94af000be5e7eeb211c7fd8189c84e25da686ed4f3878eb9dd81794f0` (`lk-` prefix + 128 hex) | Scoping `search_design_system` via `includeLibraryKeys` |
| **Component key** | A globally-unique key for a published component / component set | `fc6d6cde9cd8018b2e74edc081c8b81e336e92db` (40 hex) | The argument to `figma.importComponentByKeyAsync()` / `figma.importComponentSetByKeyAsync()` |

For Pantheon, the constants are:
- **File key:** `l8qALS4HQUMbSTyP8BTGRL`
- **Library key:** `lk-e668811788fb5b438ff0a2abb7aef68c6d641138b51a91d88632b2e6b725462df96674d94af000be5e7eeb211c7fd8189c84e25da686ed4f3878eb9dd81794f0`
- **Component keys:** see the lookup table in §1.6.

Local node IDs (like `2657:2898`, `45:303`) are NOT importable across files. They identify nodes inside the Pantheon file itself and are useful for `get_metadata` / `get_screenshot` / `get_variable_defs` calls *against the Pantheon file* — never as the argument to `importComponentByKeyAsync`.

### 1.3 Pre-flight — run these MCP calls BEFORE inserting anything

Skipping these is how Claude ends up "describing" instead of authoring. Do them in order, and don't proceed past a step that fails. Throughout, the MCP server prefix is `mcp__c4f7c44c-626e-4e6c-8756-6fc81e947d15__`. Tool names below are abbreviated to `figma__<name>` for brevity.

#### Constraint: Claude cannot differentiate teammates in a shared Cowork

Petpooja runs ONE shared Cowork account for the team. The Cowork user identity, the connector ID, and (consequently) the Figma MCP token are all shared — they're identical regardless of which human teammate is sitting at Cowork right now. **Claude has no way to know whether Rutvij, Shrey, or anyone else is the active human.**

The only signal Claude has is the Figma account that whoever-last-connected-the-Figma-MCP authenticated as. That single identity governs every Figma authoring action. Implications:

1. **Personal drafts are unsafe.** Files in account X's drafts are invisible to teammate Y in the Figma UI. Across a shared Cowork, "the auth'd account" rotates whenever the connector is reconnected — so anything dropped in drafts can become orphaned for everyone except whoever held the connector at the time.
2. **Shared Petpooja team-project folders are the only safe destination.** Anyone on the Petpooja team can find and edit files in shared project folders regardless of whose Figma account created them. This is what we use.
3. **Identity surfacing is informational, not a gate.** Claude must still tell the user which Figma identity is connected (so they can reconnect if needed), but Claude cannot meaningfully validate whether it "matches" the teammate currently using Cowork — because Claude doesn't know the teammate.

#### Step 0 — Ask where the design goes BEFORE doing anything

Default behavior: **never call `create_new_file` unless the user explicitly said "create a new file."** Most asks ("design a Pantheon login screen," "mock up a settings page") are about adding content to an existing working file, not spawning a new file. Asking where it goes prevents Claude from littering the team's Figma with throwaway files.

Before any other MCP call, ask the user:

> "Where should this design go?
> (a) An existing Figma file — give me the file URL or fileKey, plus the page or frame name.
> (b) A new page in an existing file — give me the file URL plus the page name to create.
> (c) A new file in a specific Petpooja team project folder — give me the project folder URL or projectId.
> (d) Something else (e.g., I just want a screenshot of a Pantheon component for reference)."

Three rules around this question:

- If the user's prompt already named a file or pasted a Figma URL, infer (a) and confirm in one line — don't re-ask.
- If the user explicitly said "create a new file," infer (c) and ask only for the project folder. **Never default to drafts. Never default to a folder Claude picked. The user names the folder.**
- If the user is ambiguous, ask. Don't guess. Spawning a new file when the user wanted to extend an existing one is a hard-to-reverse mistake (the file litters Drafts; the team has to chase it down later).

```text
1. figma__whoami
   → confirms the Figma MCP is reachable. Returns { email, handle, plans: [...] }.

   IDENTITY SURFACING (informational):
   Tell the user in one line which Figma identity will author this work:

     "Figma MCP is currently authenticated as <email> (<handle>). All file
      creation and editing will run under this identity. If a different
      teammate is supposed to author this, reconnect the Figma MCP first
      (Cowork → Settings → Connectors → Figma)."

   Do NOT try to validate whether the identity is "correct" — the shared-
   Cowork constraint above means Claude can't know who the active human
   is. Just surface the fact and proceed.

   If whoami fails entirely: tell the user the Figma MCP isn't connected.

2. figma__get_libraries with fileKey = <user's working file key>
   (NOT the Pantheon file key — pass whatever file the user is editing.)
   → returns libraries_added_to_file and libraries_available_to_add.
     Pantheon must appear in libraries_added_to_file with
       libraryKey = "lk-e668811788fb5b438ff0a2abb7aef68c6d641138b51a91d88632b2e6b725462df96674d94af000be5e7eeb211c7fd8189c84e25da686ed4f3878eb9dd81794f0"
   If Pantheon is in libraries_available_to_add but not libraries_added_to_file:
     the file hasn't enabled Pantheon. Tell the user to enable it before you
     proceed (use_figma can also enable it programmatically — see scenario A
     in figma-authoring.md).
   If Pantheon doesn't appear at all: stop. The team doesn't have access.

3. figma__search_design_system
     query: "<component name>"
     fileKey: <user's working file key>
     includeLibraryKeys: ["lk-e668811788fb5b438ff0a2abb7aef68c6d641138b51a91d88632b2e6b725462df96674d94af000be5e7eeb211c7fd8189c84e25da686ed4f3878eb9dd81794f0"]
     includeStyles: false        (unless you're searching for a Text Style)
     includeVariables: false     (unless you're searching for a Variable)
   → returns matching components/sets with their componentKey. Cross-check
     against the table in §1.6. If the table is silent on what you need,
     trust the live result. Save the componentKey for step 5.
   Pantheon's published library has some junk (game_button_*, *_alt 1, and
   thousands of icon symbols leak into search). Filter to results where
     libraryName == "Pantheon" AND assetType == "component_set"
   for top-level components like Button/Text Input/Card; "component" for
   icons.

4. figma__get_variable_defs
     fileKey: l8qALS4HQUMbSTyP8BTGRL
     nodeId:  <one of the page IDs below>
   Token-rich pages (call once per page you'll use):
     - Colors:     66:689
     - Typography: 66:686
     - Buttons:    36:1881
     - Text Input: 66:685
     - Cards:      2:113
   Save the returned variable name → ID map. You'll bind via these in step 5.

5. figma__get_design_context  (only if extending an existing frame)
     fileKey: <user's working file key>
     nodeId:  <existing frame they pointed to>
   → reveals what tokens / components are already used so you stay
     consistent. Skip when creating a brand-new file.
```

Only after these steps return clean evidence do you proceed to insert.

### 1.4 The insertion protocol — real `use_figma` JS, not pseudocode

`use_figma` is a JavaScript executor, not a structured "insert instance" API. It runs JS against Figma's Plugin API. The skeleton below is the canonical pattern. Adapt it to the components you're inserting; do not improvise the imports.

```js
// Description: insert Pantheon Primary Button + Text Input on the user's target page
(async () => {
  // NOTE: figma.loadAllPagesAsync() is NOT supported in the use_figma runtime
  // (verified by trial 2026-04-29). Don't call it — pages are already loaded.
  //
  // GOTCHA: NEVER use `figma.currentPage` as your append target unless the user
  // explicitly confirmed it. currentPage resolves to whatever page is active in
  // the desktop app, which is rarely where the user wants the work. Look up the
  // target page by ID (from the URL the user pasted) and append there:
  //
  //   const page = await figma.getNodeByIdAsync("297:12382"); // user's target
  //   if (!page || page.type !== "PAGE") throw new Error("page not found");
  //   await figma.setCurrentPageAsync(page); // optional, but helps the user see it
  //
  // Then use `page` as your append target throughout. Never `figma.currentPage`.
  const page = await figma.getNodeByIdAsync("<target-page-id-from-user>");

  // Import the component sets from Pantheon by their componentKeys (§1.6).
  // ALWAYS use Async variants — sync versions don't exist in this API surface.
  const buttonSet = await figma.importComponentSetByKeyAsync(
    "fc6d6cde9cd8018b2e74edc081c8b81e336e92db" // Pantheon › Primary
  );
  const textInputSet = await figma.importComponentSetByKeyAsync(
    "cb39becb31c861d5c74a66d1fe72de085d4ddffc" // Pantheon › Text Input
  );

  // IMPORTANT: do not trust `buttonSet.defaultVariant` to be the "obvious"
  // default. For Pantheon Primary, defaultVariant is
  //   "Show Icon=Leading, State=Enabled, Type=Square, Size=Extra Small"
  // — NOT a plain Medium button. Always call setProperties explicitly to
  // get the variant you actually want.
  //
  // Variant axis names and values are case-sensitive and listed in §1.6.
  // For Buttons (verified live):
  //   "Show Icon": None | Leading | Trailing      (note the SPACE in the name)
  //   State:      Enabled | Disabled | Pressed    (NOT Default)
  //   Type:       Square | Round
  //   Size:       Extra Small | Small | Medium | Large
  const buttonInstance = buttonSet.defaultVariant.createInstance();
  buttonInstance.setProperties({
    "Show Icon": "None",
    State: "Enabled",
    Type: "Square",
    Size: "Medium",
  });

  // For other components, inspect the live axes via instance.componentProperties
  // (or buttonSet.variantGroupProperties on the set) before guessing values.
  const inputInstance = textInputSet.defaultVariant.createInstance();
  // Confirm Text Input's actual axes at runtime — names may differ from prose
  // documentation. setProperties errors with a clear "Unable to find a variant
  // with those property values" if you pass the wrong key/value.

  // Override the visible label using the 3-tier fallback. Pantheon components
  // are inconsistent about how they expose text — some have named TEXT props,
  // some have only an unnamed TEXT prop, some have nested sub-instances where
  // direct mutation works but property-based override doesn't. This helper
  // tries all three in order:
  async function setText(instance, fuzzyKey, value) {
    const props = instance.componentProperties || {};
    // Tier 1: named TEXT property matching the fuzzy key
    let propKey = Object.keys(props).find(k =>
      props[k] && props[k].type === "TEXT" &&
      k.toLowerCase().includes((fuzzyKey || "").toLowerCase())
    );
    // Tier 2: any TEXT property (Pantheon Tabs, Badges fall here)
    if (!propKey) propKey = Object.keys(props).find(k => props[k] && props[k].type === "TEXT");
    if (propKey) {
      try { instance.setProperties({ [propKey]: value }); return true; } catch (e) {}
    }
    // Tier 3: first descendant TEXT node (Pantheon Chips fall here)
    const node = instance.findOne(n => n.type === "TEXT");
    if (node) {
      try { await figma.loadFontAsync(node.fontName); node.characters = value; return true; } catch (e) {}
    }
    return false;
  }
  await setText(inputInstance, "label", "Email address");

  // Compose with auto-layout. Padding/gap from the 8-pt grid only.
  const frame = figma.createFrame();
  frame.name = "Section / Sign-in";
  frame.layoutMode = "VERTICAL";
  frame.itemSpacing = 16;
  frame.paddingLeft = frame.paddingRight = 24;
  frame.paddingTop = frame.paddingBottom = 24;
  frame.primaryAxisSizingMode = "AUTO";
  frame.counterAxisSizingMode = "AUTO";
  // Bind the frame fill to a Pantheon library variable, NOT a hex.
  // Library variables come from get_variable_defs (step 4 above) — they're
  // already-published variables in the Pantheon library, so you bind by
  // looking them up via figma.variables.importVariableByKeyAsync().
  // Example:
  const surfacePrimary = await figma.variables.importVariableByKeyAsync(
    "<variable_key_for_Surface/Primary_from_get_variable_defs>"
  );
  frame.fills = [
    figma.variables.setBoundVariableForPaint(
      { type: "SOLID", color: { r: 1, g: 1, b: 1 } },
      "color",
      surfacePrimary
    ),
  ];

  // GOTCHA: layoutSizingHorizontal = "FILL" only works AFTER the node is in
  // an auto-layout parent. Pattern is APPEND FIRST, then set sizing:
  page.appendChild(frame);
  // (no FILL here — frame is at top level, give it explicit width via resize)
  frame.resize(560, frame.height);
  frame.appendChild(inputInstance);
  inputInstance.layoutSizingHorizontal = "FILL"; // now works — parent is auto-layout
  frame.appendChild(buttonInstance);

  // Position somewhere not on top of existing content
  frame.x = 200;
  frame.y = 200;

  figma.viewport.scrollAndZoomIntoView([frame]);
  return { frameId: frame.id, frameName: frame.name };
})();
```

Notes that bite if you skip them (every one of these is trial-verified):

- **Always `await figma.loadFontAsync(fontName)` before setting `characters` on a TEXT node.** The font for Pantheon Text Styles is Inter — but the *style* is `"Inter Semi Bold"` (with a space), `"Inter Extra Bold"` — not `"Inter SemiBold"` / `"Inter ExtraBold"`.
- **Don't call `figma.loadAllPagesAsync()`** — not supported in the `use_figma` runtime. Pages are already loaded.
- **Don't use `figma.currentPage` as your append target.** Look up the user's intended page by ID (`figma.getNodeByIdAsync(pageId)`) and append there. `currentPage` resolves to whatever page the user happened to have active in Figma desktop and creates orphaned work.
- **`layoutSizingHorizontal = "FILL"` requires the node to already be in an auto-layout parent.** Pattern: `parent.appendChild(child); child.layoutSizingHorizontal = "FILL";` — never the reverse.
- **`textStyleId` does NOT bind text color.** Text Styles in Figma carry typography only (font family, size, weight, line-height). Color is a separate `fills` property and must be bound explicitly to a `Text/*` semantic variable via `setBoundVariableForPaint`. After every `t.textStyleId = ...`, also do `t.fills = [setBoundVariableForPaint({type:"SOLID",color:{r:0,g:0,b:0}}, "color", textPrimaryVariable)]`.
- **Setting `figma.currentPage` directly is unsupported.** Use `await figma.setCurrentPageAsync(page)` instead.
- **`getPluginData` / `setPluginData` don't work in `use_figma`.** Use `getSharedPluginData("petpooja_pantheon", key)` / `setSharedPluginData(...)` if you need metadata.
- **Variant property values are case-sensitive strings** (`"Medium"` not `"medium"`). When `setProperties` rejects a value, read the component's `variantGroupProperties` for the exact accepted strings — don't trust prose docs (most v1.4.x prose tables for variant axes were wrong; see §1.6 footnotes).
- **Pantheon `defaultVariant.createInstance()` is not the obvious default.** For Primary Button it's `Show Icon=Leading, State=Enabled, Type=Square, Size=Extra Small`. Always `setProperties` explicitly to the variant you want.
- **Text Styles are imported via `figma.importStyleByKeyAsync(styleKey)`** and applied via `node.textStyleId = style.id` — same key model as components.

If you don't know the variable_key or style_key for a token at runtime, the cleanest path is to call `get_variable_defs` (step 4) and pull the keys from there, then pass those keys into your `use_figma` script as constants.

### 1.5 The Figma-authoring hard gate (the part most likely to be skipped)

Before issuing any `use_figma` call that creates content, answer these aloud:

- ❑ Have I called `get_libraries` with the user's working `fileKey` and confirmed Pantheon (`libraryKey: lk-e6688117…`) is in `libraries_added_to_file`?
- ❑ For every component on my plan, have I called `search_design_system` with `includeLibraryKeys: [<Pantheon library key>]` and captured the real `componentKey`?
- ❑ Have I called `get_variable_defs` for the Colors and Typography pages so my variable bindings can resolve?
- ❑ Does my `use_figma` script use `importComponentSetByKeyAsync` (or `importComponentByKeyAsync` for singular components) — never `figma.createRectangle()` styled to look like a Pantheon component?
- ❑ Are all my fills/strokes/text bound to library variables and Text Styles via the `setBoundVariableForPaint` / `textStyleId` patterns above, not raw hex / font-family?
- ❑ **Are TEXT FILLS explicitly bound** to `Text/Primary` / `Text/Secondary` / `Text/Tertiary` variables? `textStyleId` alone leaves text color unbound.
- ❑ Am I appending to the **user's intended page** (looked up by ID), not `figma.currentPage`?
- ❑ For every node where I use `layoutSizingHorizontal = "FILL"`, did I `appendChild` to an auto-layout parent **first**?
- ❑ Have I picked a theme (POS Light default, POS Dark, Billing, Payroll) and locked the page to it?

If any answer is "no" or "I'll fix it after," **stop and fix it now.** A frame that ships with two real components and a hand-drawn button-shaped rectangle is worse than a frame that ships with two real components and a clearly-labeled empty placeholder, because the rectangle will get copied forward and treated as canon.

### 1.6 Component → componentKey lookup table (Pantheon library, verified 2026-04-29)

Insert by these componentKeys via `importComponentSetByKeyAsync`. Local node IDs in the right column are for inspection / screenshots / variable lookups against the Pantheon file itself — they are NOT importable.

**Buttons family** — note Pantheon has 7 separate sets, not one with a Hierarchy variant. Pick the one that matches the hierarchy you need:

| Component set | componentKey | Pantheon node ID |
|---|---|---|
| Primary | `fc6d6cde9cd8018b2e74edc081c8b81e336e92db` | (Buttons page `36:1881`) |
| Tonal | `f28a0b2655bbbd43c7e23f4633c9b166364120e0` | (Buttons page) |
| Outline | `62d4fbda14a6548a4bfcc767c35403a5a5229070` | `45:303` |
| Text Buttons | `764776856db0f6b72b0b6346d49d90fe58a59e48` | (Buttons page) |
| Primary Icon Button | `2b3f906be0fae763386e40978f844a80b8b5e311` | (Buttons page) |
| Tonal Icon Button | `fa3558969c2f4d3f09f696d350c7cdbf9252f354` | (Buttons page) |
| Outline Icon Button | `31f5286a7eeed0006c913b3feba9da765648579d` | `45:413` |

Variant axes on each Buttons set (verified live 2026-04-29 against Pantheon Primary):
- **`Size`:** `Extra Small` · `Small` · `Medium` · `Large`
- **`State`:** `Enabled` · `Disabled` · `Pressed` *(NOT `Default` — that's a common mis-guess)*
- **`Type`:** `Square` · `Round`
- **`Show Icon`:** `None` · `Leading` · `Trailing` *(note the SPACE in the property name; values are NOT `False/True/Only`)*

The set also exposes a `Icon #43:0` instance-swap property for the actual icon symbol — overriding the `Show Icon` variant axis to `Leading`/`Trailing` doesn't change which icon is shown; for that, swap the nested icon instance to a Material Symbol from the Outline / Filled set. Each Button hierarchy (Tonal, Outline, etc.) likely uses the same axis names — confirm via `instance.componentProperties` or `componentSet.variantGroupProperties` at runtime.

**Caveat on `defaultVariant`:** for Pantheon Primary, the set's `defaultVariant` is `Show Icon=Leading, State=Enabled, Type=Square, Size=Extra Small` — NOT a plain Medium button. Always `setProperties` explicitly to get the variant you actually want; never assume `defaultVariant` is the "obvious" version.

**Segments:**

| Component set | componentKey |
|---|---|
| Segment Buttons | `53a13f12bdf20cac1f2dd65182a8e1bbd7ae8129` |
| Segment Navigation | `b6e7c92a42e6855bd2f4e5b13d6cf73b21c90924` |
| Segment Nav Left-End | `401ec096c2da78df18da25ee780af35ece42bfb0` |
| Segment Nav Middle | `12f30b76be409f2a2c9ebf1a36aceed536b234c0` |
| Segment Nav Right-End | `fe4627090259fce524070b07fb7d674e90d7bae8` |

**Inputs** (variant axes trial-verified 2026-04-29 — earlier prose docs were wrong on most):

| Component set | componentKey | Variant axes (verified) |
|---|---|---|
| Text Input | `cb39becb31c861d5c74a66d1fe72de085d4ddffc` | `Size` (Small/Medium/Large), `State` (Default/Input/Active/Error/Disabled), `Type` (Default/Prefix/Suffix), `Leading Icon` (True/False), `Trailing Icon` (True/False), `Supporting text` (True/False), `CTA` (True/False). NO Label axis — floating notched label is inherent. |
| Chips | `462cd5372288dcffd7f8966361c5a88b539cb299` | `State` (Active/Pressed/Selected — no Default/Enabled), `Size`, `Shape` (Square/Round — NOT "Type"), `Icons` (No Icons/Leading/Trailing/Both — note plural axis name). NO Accent axis. |
| Checkbox | `85778d74c46ac7717457c562a299a372a7ba24a5` | (verify at runtime) |
| Radio Button | `6a6707d577bee85e7d8a96aa0eab1ff7a150c4d1` | `Selected` (True/False), `State` (Enabled/Disabled). NO Size axis. |
| Switch | `b7bcfb3ccbce7271d0eaae7af39d2a99a662e4fc` | `Selected` (True/False), `Type` (Default/Disabled — Disabled is a Type, not a State!), `Size` (Small/Large), `Icon` (True/False). |
| Dropdown | `96ea9a0edcfb4bde123e056055dde85512e8f859` | (verify at runtime) |

**Containers / structural** (axes trial-verified 2026-04-29):

| Component set | componentKey | Verified axes / notes |
|---|---|---|
| Cards | `3abc4532bdd32303c6e2d255211177c4889aa956` | `State` (Default/Pressed), `Type` (Stacked/Horizontal). **TILE component** (image+text), NOT a section wrapper — section wrappers are styled auto-layout frames matching the Card spec, not Cards instances. No Density axis (older docs were wrong). |
| Pop Up | `d41eb324764197f57477497e8022fa1f268e2752` | (verify at runtime) |
| Bottom Sheet | `a964ddc633407ccc9dd3153b5c6c06fdc6c0521c` | (verify at runtime) |
| Side Drawer | `4e7a68536754b38879d5a7e4bdf56e026d2fcb1d` | (verify at runtime) |
| Tabs | `5314230198c65e0ff0fc52e488e2ff7a6a29b84d` | `Type` (Icon + Text/Text Only/Icon Only), `Size`, `Tabs` (2/3/4/5). Per-tab labels are nested sub-instances — top-level findOne mutation can't reach them; you'd need each sub-instance's own componentProperties to override individual tab labels. |
| Tooltip | `b600d9b2933180dc153099e9b963f8051ccf4d23` | (verify at runtime) |
| Badges | `9f4d61d11a98b62929a9127554aa9ea9a96629e9` | ONE axis: `Size` (Large/Small). **`Size=Small` is a tiny dot indicator with NO text. `Size=Large` is the labeled pill (38×18) — that's what you want for "Draft" / "Active" / status pills.** No Type or Accent axis. |

**Tabs sub-variants** (use these for finer control over a tab strip):

| Component set | componentKey |
|---|---|
| Label Only (tab) | `c1583b764d6f98d2e930b51cb0c8579528d00083` |
| Icon Only (tab) | `08d3284f1e63fb1b7b7edf736395fb1389073354` |
| Label and Icon (tab) | `1f05dc638ee920ca54cb3b371ce9ae7698232f3d` |

**Tables** (parent–child relationship — Table is the container, Header/Body Block are cells that go INSIDE it):

| Component | componentKey | Role |
|---|---|---|
| Table | `44fbe81dab152e17045008882df9f38bc4ef437c` | **Slot-based container** (singular component). Has `Slot#2481:29` (SLOT prop), `Show Header#2508:0` (BOOLEAN — bulk-action bar), `Show Footer#2508:1` (BOOLEAN — pagination chrome). Wraps Header Block + Body Block instances. |
| Table Header Block | `3df286c67fc091fa24e115f761ddc423d92242a7` | **Cell** — `Type` (Collapsible/Checkbox/Text/Numbers/CTA/Text + CTA/Sort). Belongs INSIDE Table's Slot. |
| Table Body Block | `1fb1db3a3c7bd44e14ddacdeddfe0eb4540d34fc` | **Cell** — `State` (Default/Selected/Hover), `Type` (Collapsible/Checkbox/Link/Text/Numbers/CTA/Text + CTA), `Line Size` (Single Line/Double Line). Belongs INSIDE Table's Slot. |
| Sort States | `1518416c6710910d91ccb70a52d77e20bbe84b97` | Auxiliary component for sort indicators |

**Composing into the Table Slot** — Header/Body Block cells are NOT used standalone in a hand-composed frame. They go inside a real Table instance via its Slot. Pattern:

```js
// Create the Table instance and hide chrome you don't need
const tableInst = (await figma.importComponentByKeyAsync(
  "44fbe81dab152e17045008882df9f38bc4ef437c"
)).createInstance();
tableInst.setProperties({
  "Show Header#2508:0": false, // hide bulk-action bar
  "Show Footer#2508:1": false, // hide pagination
});

// Find the SLOT-typed node inside the instance tree
const slot = tableInst.findOne(n => n.type === "SLOT");

// Compose your rows (each row = a horizontal auto-layout of Header/Body Block instances)
const headerRow = figma.createFrame();
headerRow.layoutMode = "HORIZONTAL";
slot.appendChild(headerRow); // append into the SLOT, then set sizing
headerRow.layoutSizingHorizontal = "FILL";
for (const colName of ["Employee", "Type", "Date", "Status"]) {
  const cell = headerBlockSet.defaultVariant.createInstance();
  cell.setProperties({ Type: "Text" });
  await setText(cell, "label", colName);
  headerRow.appendChild(cell);
  cell.layoutSizingHorizontal = "FILL";
}

// ...repeat for each body row using Table Body Block cells (Type=Text/Numbers/CTA/etc.)
```

The same Slot pattern applies to any other Pantheon component that has a SLOT-typed property (discover them via `instance.componentProperties` — `props[k].type === "SLOT"`).

**List + building blocks:**

| Component set | componentKey |
|---|---|
| List | `faa9e1b54e3d3b027e3785b6553475d5d97c28a0` |
| Building Block | `cff7af78c410b231ac62f3eabdddffad7b97d9fb` |
| Building Block - Switch | `1908929108ed431362e4ede244ae14c4bf879bd5` |
| Building Block - Checkbox | `694cff6addfbe6f775ac103ecacfd47757e1d777` |
| Building Block - Image | `0b290e28993761461de9a9a6b94856f919bbd8ca` |
| Building Block - Icon | `9655d2b6da53a300a1892bf3ed07d615b28dc9c4` |
| Building Block - None | `337b4d24d80cd45ac0de1f84dddff713c1112573` |
| Sub Building Blocks - Checkbox | `df3c546c1a425c136621604dc42b6056e29174a2` |
| Sub Building Blocks - Labels | `4fc49f129dfa4c020668dd602532fa61349a5152` |

**Icons:**

Icons are individual `component` (not `component_set`) entries in the library, several thousand of them. Don't pre-cache keys — call `figma__search_design_system` at runtime with `query: "<material symbol name>"`, `includeLibraryKeys: [<Pantheon library key>]`, and pick the result whose `name` exactly matches your symbol (e.g., `search`, `close`, `chevron_right`). Filter for `assetType: "component"` and `libraryName: "Pantheon"`.

For the icon-set wrapper frames inside the Pantheon file (used for `get_metadata` / `get_screenshot`):

- **Outline set wrapper:** Pantheon node `2890:13060` (~3,857 Material Symbols outline)
- **Filled set wrapper:** Pantheon node `2890:28423` (~3,845 Material Symbols filled)
- **Depreciated Icons (DO NOT USE):** Pantheon node `2896:12975`

**Library hygiene flag (for Shrey, not the skill):** the Pantheon library has junk leaking into search results — `game_button_*`, `*_alt 1`, raw component duplicates. Likely test/legacy components that ended up Published. Worth a one-time cleanup pass in Figma's Assets panel; until then, the `assetType + libraryName + exact-name` filter in step 3 above is the workaround.

### 1.7 What "redraw" looks like — anti-patterns to never ship in a Figma file

- ❌ A `Rectangle` with fill `#1770ee`, corner radius 10, plus a `Text` layer reading "Continue" inside it. ✅ An instance of Pantheon `Primary` (componentKey `fc6d6cde9cd8018b2e74edc081c8b81e336e92db`) with `Size=Medium, State=Enabled, Type=Square, "Show Icon"="None"`, label overridden via the instance's text property.
- ❌ A `Frame` with stroke `#e5e5e5`, radius 8, plus a `Text` layer reading "Email" inside it. ✅ An instance of Pantheon `Text Input` (componentKey `cb39becb31c861d5c74a66d1fe72de085d4ddffc`) with `Size=Medium, State=<verify via instance.componentProperties; likely Enabled>, Label=Floating`, label property set to "Email".
- ❌ Eight rectangles in a row, alternating fills, used as a "table." ✅ Pantheon `Table Header Block` + `Table Body Block` instances composed in an auto-layout frame.
- ❌ A custom pill-shaped toggle for "Monthly / Annual." ✅ Pantheon `Switch` for binary, `Segment Buttons` for 2–4 exclusive options, or `Tabs` for view-switching. **If the user did not explicitly request this control, omit it.**
- ❌ A hand-drawn star or chevron SVG. ✅ The matching Material Symbol from the Outline or Filled set, fetched via `search_design_system`.
- ❌ Detaching an instance to "tweak a color." ✅ Bind a different variable, or change the variant property.
- ❌ Pasting a hex into a fill (`#fafafa`). ✅ Bind the `Surface/Secondary` library variable via `setBoundVariableForPaint`.
- ❌ Setting `fontName` to `{ family: "Inter", style: "Regular" }` manually on a Text layer. ✅ Apply a Prometheus Text Style (e.g., `Prometheus/Body/Medium-Regular`) via `textStyleId = (await figma.importStyleByKeyAsync(styleKey)).id`.
- ❌ A drop shadow on a card "for depth." ✅ A 1px stroke bound to `Border/Primary`. Shadow is reserved for `Pop Up` (`Elevation/3`).
- ❌ Frame name `Frame 47`. ✅ Frame name `Card / Hero` or `Section / Order Summary`.
- ❌ Calling `figma.importComponentByKeyAsync("2657:2898")` (passing a node ID where a componentKey is required). ✅ Look up the componentKey in §1.6 or via `search_design_system`.

### 1.8 If a needed component is missing from Pantheon

Don't invent it. Confirm via `search_design_system` that nothing matches; then either compose from the closest Pantheon primitives **and label the composed group's frame with `Composed / not-in-Pantheon / <name>`** so the gap is visible later, or omit and flag in one closing line. Never silently ship a custom component as if it were Pantheon.

### 1.9 Traceability — every Figma-authoring task ends with a delivery note

After the file or frame is published, end your turn with this exact format:

```
Pantheon Figma delivery
- File: <link to the user's working file>
- Library used: Pantheon (file l8qALS4HQUMbSTyP8BTGRL, library lk-e668811788fb…)
- Theme: POS Light  (or POS Dark / Billing / Payroll)
- Components inserted (name → componentKey → variant):
  - Primary → fc6d6cde9cd8018b2e74edc081c8b81e336e92db → Size=Medium, State=Enabled, Type=Square, "Show Icon"=None
  - Text Input → cb39becb31c861d5c74a66d1fe72de085d4ddffc → Size=Medium, State=<verified at runtime>, Label=Floating, Icon=None
  - Cards → 3abc4532bdd32303c6e2d255211177c4889aa956 → <variants verified at runtime>
  - Chips → 462cd5372288dcffd7f8966361c5a88b539cb299 → Type=Round, Accent=Green, Size=Medium, <other axes verified at runtime>
  - Icon `search` (Outline) → <componentKey from search_design_system>
- Variables bound: Surface/Primary, Surface/Secondary, Text/Primary, Text/Brand, Border/Primary, Border/Brand, Buttons/Primary, Icon/Primary
- Text Styles applied: Prometheus/Title/Large-Bold, Prometheus/Body/Medium-Regular, Prometheus/Label/Small-Medium
- Composed (not-in-Pantheon, flagged): <list, or "none">
```

If any row of "Components inserted" can't be cited as a real componentKey, **the file isn't ready** — go back and replace the redrawn element.

---

## §2 — Code path (React / HTML / Vue / Tailwind)

When the deliverable is code, you can't import Figma library instances — but you must reproduce the Pantheon spec faithfully. The rules below are unchanged from prior versions of this skill, with the addition of "before you start, decide which token names you'll alias to CSS variables."

### 2.1 Pre-flight — before writing a line of code, answer these silently

1. **Which theme?** POS Light (default), POS Dark, Billing, or Payroll. Decides the Gray ramp, Surface primitives, and whether Purple resolves Light or Dark.
2. **Which semantic tokens?** Every color must be a named Pantheon token — `Surface/Primary`, `Text/Brand`, `Border/Error`. Aliased as CSS variables: `--surface-primary`, `--text-brand`, `--border-error`. Never raw hex outside the variable definition block.
3. **Which Prometheus type composites?** Name them (`Prometheus/Title/Large-Bold`, `Body/Medium-Regular`). Letter-spacing 0 everywhere.
4. **Which Pantheon components?** List the components you'll compose with (Button, Text Input, Chips, Card, Table, Segment, Switch, Tabs).
5. **Component mapping test — the hard gate.** Enumerate every distinct element you're about to render (header, card, pill, divider, toggle, nav, badge — everything) and name the specific Pantheon component each one resolves to. If any element doesn't map cleanly to a Pantheon component, **omit it or replace it with a Pantheon-native alternative before writing a single line.**

If any answer is "I'll wing it," stop and read `references/tokens.md` or `references/components.md` first.

### 2.2 Strict non-invention

If a component isn't in Pantheon's library, either use a Pantheon equivalent or leave it out. Never silently invent a new one, and never invent one just because flagging the gap feels like enough permission — it isn't. Two failure modes to watch for:

1. **Pattern-matching from the wider web.** "Pricing pages usually have a monthly/annual toggle." That's not a reason to add one. If Pantheon has the right primitive (`Switch`, `Segment`, `Chips`, `Tabs`), use it. If none fits the user's actual ask, omit and mention the gap in one closing line.
2. **Treating "call out the gap" as permission to build it.** It isn't. Flagging replaces shipping the invented component; it doesn't accompany it.

The only exception: if the user's prompt explicitly requests something outside Pantheon, compose it from the closest Pantheon primitives, name which primitives you borrowed from, and keep styling inside Pantheon's token + typography grammar. Never introduce new visual primitives (gradients, custom shadows, off-scale pill shapes, decorative dividers, icon-in-circle ornaments).

### 2.3 Three hot spots that get botched in code

#### Text Input — outlined notched-label, never stacked-label

Pantheon's `Text Input` is Material Design 3's outlined text field with a floating notched label. The label sits inside the field as placeholder when empty, and floats up to notch through the top border when focused / filled / errored / disabled. **It is never a separate `<label>` row stacked above the field.** That stacked-label pattern (shadcn / Tailwind default) is the most common Pantheon-violation in generated UI.

- **Height by Size:** Small 36 · Medium 40 (default) · Large 48.
- **Radius:** `Square/Small` = 8px. Never 4, never 6, never pill unless the prompt called for a search-pill.
- **Border:** 1px solid `Border/*`, applied as an outlined rectangle. The top edge has a gap (notch) wherever the floated label sits.
- **Fill:** `Surface/Primary` (`#ffffff`) in every state except Disabled.

| State | Label position | Label style | Border |
|---|---|---|---|
| Default (empty + unfocused) | inside the field, vertically centered | `Body/Medium-Regular` in `Text/Tertiary` | `Border/Primary` |
| Active (focused) | floated up, notched through top border, 12px inset from left | `Label/Small-Medium` in `Text/Brand` | `Border/Brand`, 1px flat — no glow, no 2px ring |
| Input (has value, unfocused) | floated up, notched | `Label/Small-Medium` in `Text/Secondary` | `Border/Primary` |
| Error | floated up, notched | `Label/Small-Medium` in `Text/Error` | `Border/Error`; supporting text in `Text/Error` |
| Disabled | floated up, notched (or inside if empty-and-disabled) | `Label/Small-Medium` in `Text/Disabled` | `Border/Disabled`; fill `Surface/Tertiary` |

Composition skeleton — adapt the markup to your framework, do not approximate with a stacked-label fallback:

```html
<div class="field field--md is-active">
  <fieldset class="field__outline">
    <legend class="field__notch"><span>Label</span></legend>
  </fieldset>
  <div class="field__row">
    <span class="field__icon">{leadingIcon}</span>
    <input value="Text" />
    <span class="field__icon">{trailingIcon}</span>
  </div>
  {supportingText && <p class="field__support">Supporting text</p>}
</div>
```

The `<fieldset>` + `<legend>` pattern is the cleanest way to get a real notched border in HTML — the legend's background covers the border line behind the label. Material Web Components, MUI's `OutlinedInput`, and Pantheon all use this approach.

#### Icons — Pantheon Outline / Filled sets only, by name

Every icon must come from Pantheon's two Material Symbols sets:

- **Outline** (`2890:13060`) — ~3,857 symbols — default.
- **Filled** (`2890:28423`) — ~3,845 symbols — for selected/active states and inside filled containers (Primary Button, etc.).
- **Depreciated** (`2896:12975`) — 1,318 legacy 16×16 — never use.

Rules:
1. Name the icon by its Material Symbols name (`close`, `search`, `add`, `chevron_right`, `check`, `error`, `arrow_back`, `person`, `shopping_cart`, `edit`, `delete`, `visibility`).
2. Reference the set ("Outline" or "Filled").
3. Color from `Icon/*` tokens only (`Icon/Primary`, `Icon/Secondary`, `Icon/Brand`, `Icon/Invert`, `Icon/Error`, `Icon/Success`, `Icon/Warning`, `Icon/Disabled`).
4. Width from {16, 18, 20, 24}. Match parent: button S → 18, button M → 20, button L → 24.
5. Never invent an icon as an SVG shape.

#### Emoji — never. Anywhere. In any visual output.

No emoji symbols (rocket, sparkles, chart, pointing finger, check, cross). Pantheon is editorial; emoji are the opposite. Replace with the matching Outline / Filled icon. Only exception: when the user's prompt explicitly asks for emoji (e.g., "write a Slack message with emoji"), in which case emoji are a *content* choice, not a *visual design* choice, and the surrounding visual treatment stays emoji-free.

### 2.4 Component-first rule for code

Use Pantheon component names, not generic HTML / Material / shadcn / Bootstrap equivalents. The reference spec lives in `references/components.md`. Anti-patterns to avoid:

- ❌ A raw `<button style="...">`. ✅ Pantheon Button (or a faithful CSS reproduction: height from the button-height scale, `Buttons/Primary` fill, `Label/Medium-Medium` type, corner `Square/Medium`).
- ❌ Custom `<input>` with `border: 1px solid #ccc`. ✅ Pantheon Text Input as specified above.
- ❌ Cards invented ad-hoc. ✅ Pantheon Card composition — `Surface/Primary` fill, 1px `Border/Primary`, `Square/Medium` radius, no drop shadow.
- ❌ Chips with arbitrary pastels. ✅ Pantheon Chips with the matching accent slot (`Chips/Accent-Green`, `Chips/Accent-Pink`).
- ❌ A "search bar" component. ✅ Compose from Text Input + leading icon — Pantheon doesn't ship a Search Bar. If the user didn't ask for search, omit.
- ❌ Adding components the prompt didn't request "because this kind of page usually has them." ✅ Build only what was asked. One closing line can suggest additions; don't ship them.
- ❌ Material / shadcn `Avatar`, `Accordion`, `Banner`, `Pagination`, `Breadcrumb`, `Stepper`, `Loader`. ✅ Omit unless the prompt explicitly required it; if required, compose from Pantheon primitives and flag the gap.
- ❌ Inline `color: #1770ee`. ✅ `var(--text-brand)`.
- ❌ `font-family: "Helvetica"` / `"SF Pro"`. ✅ Inter / Prometheus.
- ❌ `border-radius: 6px` / `10.5px`. ✅ `Square/Small` (8) · `Square/Medium` (10) · `Square/Large` (12) · `Round/Rounded` (200).
- ❌ Drop shadows on cards. ✅ 1px `Border/Primary`. Shadow is `Elevation/3`, used only on `Pop Up`.

---

## §3 — Document path (.docx, .pdf, .pptx, posters, marketing)

Same brand rules; different format constraints. Inter throughout. Body in `Text/Primary`. Headings use the Title hierarchy. Callouts and links in `Text/Brand`. Tables: `Border/Primary` dividers, `Surface/Secondary` alternating rows. No color blocks for their own sake.

- **Slide decks (.pptx).** 16:9, white master. Section tints use `Surface/Accent-Navy Blue` (`#d7e6ff`). Titles `Display/Medium-Bold` or `Title/Large-Bold`. Body `Body/Medium-Regular`. Chart series cycle through the 8 accent families (Aqua → Beige → Green → Yellow → Navy Blue → Orange → Pink → Purple). One concept per slide.
- **Posters / marketing.** One hero image, one accent color (usually `Text/Brand`), typographic emphasis via Display scale. No gradients. No drop shadows.
- **Dashboards / data viz.** Big numbers in `Display/Medium-Bold` or `Display/Small-Bold`. Labels in `Label/Small-Medium`. Chart lines/bars cycle through the 8 accent families. Grid lines `Border/Primary` at reduced opacity.

---

## Reference files (load on demand)

- **`references/figma-authoring.md`** — every Figma-authoring scenario (new file, extend a frame, fix a non-Pantheon mock, build a chart) with the exact MCP tool sequence. Load this whenever §1 applies.
- **`references/tokens.md`** — every color token with hex, full Prometheus type scale, sizing, radius, elevation. Load whenever you need a specific hex or a token not on the cheat-sheet below.
- **`references/components.md`** — every component: variant axes, states, sizes, composition tips, when-to-use guidance, gotchas. Load whenever you're choosing or building a component.
- **`references/full_inventory.md`** — raw 1,785-line file inventory with every node ID, variant count, dimensions. Load when you need an exotic node ID or to sanity-check a structural question.
- **`references/raw_variables_extraction.md`** — raw `get_variable_defs` output, per-page token counts, collision notes. Load when debugging a token discrepancy.

The extraction is comprehensive: 23 pages, 47 component sets, 1,655 variants, every semantic token, every primitive ramp, every Prometheus composite. What's in the references is what's in Pantheon.

---

## Brand identity (non-negotiable)

- **Brand color:** `#1770ee`. Drives `Buttons/Primary`, `Text/Brand`, `Border/Brand`, `Icon/Brand`.
- **Typeface:** Inter, called **Prometheus** inside Pantheon tokens. Letter-spacing 0 everywhere. Web fallback: `"Inter", -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif`.
- **Tone:** clean, editorial, generous whitespace, restrained palette, single strong accent. Avoid gradients, drop shadows (except `Elevation/3` on Pop Up), decorative patterns, skeuomorphism.

## Color tokens — name, not hex (cheat sheet)

Pantheon ships four parallel scales for every semantic role: **Surface** (fills), **Text**, **Icon**, **Border**. Always pair them — don't put `Text/Error` on a random red; pair it with `Surface/Error` + `Border/Error`.

The 90% set:

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

For any other token, read `references/tokens.md`.

### Accent palette (charts, categorization, status)

Eight accent families, each with a 9-step ramp (100–900): **Aqua, Beige, Green, Yellow, Navy Blue, Orange, Pink, Purple**. Every family has Surface / Text / Border / Icon / Notch / Chips / Card semantic slots. For multi-series charts, cycle through families in the order listed; don't double up on a ramp until you've exhausted all eight. `Purple` has a Dark-theme variant for POS Dark.

### Themes — POS Light / POS Dark / Billing / Payroll

Pantheon is theme-aware. Semantic tokens resolve to different primitives per theme — most notably the Gray ramp is inverted under POS Dark (`Gray-0` becomes near-black, `Gray-1000` becomes white). Default to POS Light unless the user says otherwise.

### Known gotchas

- `Text/Disabled` resolves to the same hex as `Text/Tertiary` (`#999999`). Keep the semantic distinction in code; they render identically today.
- Aqua labels in the swatch frame read `100–108` (off-by-one typo). Tokens are `Aqua-100 … Aqua-900` in Variables.
- Warning ramp === Yellow ramp, pixel-for-pixel.
- Error ramp defines only `100 / 500 / 600`.
- Gray ramp uses `Gray-0` (white in Light / near-black in Dark) and `Gray-1000` (black in Light / white in Dark) — not `Gray-100` / `Gray-900`.
- The "Primary" frame on the Colors page is an Atlas-legacy cyan ramp, not the brand blue. For UI primary, use `Buttons/Primary` / `Text/Brand` / `Border/Brand` (`#1770ee`).
- A handful of accent aliases skip the expected step (`Text/Accent-Pink` → Pink-600, `Notch/Accent-Green` → Green-600, `Border/Accent-Purple` → Purple-500). Look up the specific alias in `references/tokens.md`.

## Typography — Prometheus

Four families × three sizes. Sizes below are `font-size / line-height` in px. Letter-spacing 0 throughout.

| Family | Large | Medium | Small |
|---|---|---|---|
| Display | 32 / 40 | 24 / 32 | 20 / 28 |
| Title | 18 / 26 | 16 / 24 | 14 / 22 |
| Body | 16 / 24 | 14 / 22 | 12 / 20 |
| Label | 14 / 22 | 12 / 20 | 10 / 18 |

Weights: Regular 400, Medium 500, SemiBold 600, Bold 700. Labels only use Medium and SemiBold.

Defaults that rarely need questioning:

- Body copy → `Prometheus/Body/Medium-Regular`
- Section heading → `Prometheus/Title/Large-Bold` (→ `Title/Medium-SemiBold` → `Title/Small-Medium`)
- Hero / splash → `Prometheus/Display/Large-Bold`
- Button label → `Prometheus/Label/Medium-Medium` (or `Label/Large-Medium` on POS screens)
- Caption / metadata → `Prometheus/Label/Small-Medium` or `Body/Small-Regular`

Full Prometheus matrix (42 composites) in `references/tokens.md`.

## Sizing, radius, grid, elevation

- **Corner radius:** `Square/Small` 8 · `Square/Medium` 10 · `Square/Large` 12 · `Round/Rounded` 200 (pill). Default Medium for cards / most buttons; Small for chips / inputs; Large for modals and bottom sheets.
- **Icon / element widths:** 16 (XS) · 18 (S) · 20 (M, default) · 24 (L).
- **Button heights:** Extra Small 32 · Small 36 · Medium 40 · Large 48.
- **Spacing:** No dedicated token collection — use the **8-pt grid** (4, 8, 12, 16, 24, 32, 48, 64). Don't invent 13px or 17px gaps.
- **Elevation:** one named shadow — `Elevation/3` (composite of `0 1px 3px 0 rgba(0,0,0,0.30)` + `0 4px 8px 3px rgba(0,0,0,0.15)`), used only on Pop Up. For cards prefer a 1px `Border/Primary`.

## Components — use these, don't build alternatives

The canonical Pantheon library:

- **Actions:** Buttons (Primary, Tonal, Outline, Text, Icon-only), Segment + Segment Navigation family (8 sets).
- **Inputs:** Text Input, Chips, Dropdown, Checkbox, Radio Button, Switch.
- **Navigation / structure:** Tabs (4 sets), Tooltip, Badges.
- **Containers:** Cards, Bottom Sheet, Side Drawer, Pop Up.
- **Collections:** Table (with Header Block / Body Block), List (with building blocks: Switch / Checkbox / Radio / Image / None / Icon).
- **Icons:** Outline (~3,857 Material Symbols), Filled (~3,845), Depreciated Icons (~1,318, avoid).

Button states are Enabled / Pressed / Disabled. There's no Hover — on web, map `:hover` to the Pressed visual.

For variant axes, sizes, compositional structure, DOM shape — load `references/components.md`.

### Not in Pantheon — don't reach for Material / iOS / shadcn

Avatar, Banner, Accordion, Pagination, Breadcrumb, Stepper, Loader/Spinner, Search Bar, pill-shaped segmented toggles beyond what Segment / Segment Navigation already provide. Date Picker page exists but is empty. **Default action when one of these would "fit": omit it.** Only compose from primitives if the user's ask explicitly requires it; in that case use Pantheon primitives, keep styling inside the token + typography grammar, and call out the gap in one closing line.

## Resolving unknown tokens / IDs live from Figma

If a specific token, variant, or component prop isn't covered in the references and the Figma MCP is connected, resolve live rather than guessing.

For the **Figma-authoring path** (you're producing in Figma), use the `mcp__c4f7c44c-...__*` tools listed in §1.2.

For the **read-only Dev Mode MCP** (you're producing code/docs and only need to look something up):

- File: https://www.figma.com/design/l8qALS4HQUMbSTyP8BTGRL/Pantheon
- File key: `l8qALS4HQUMbSTyP8BTGRL`
- Full-file dump: `mcp__figma-local__get_metadata` with `nodeId=0:0` (1.67M chars — use a subagent to parse).
- Variables resolve at page level. Token-rich pages to query with `get_variable_defs`:
  - Typography → `66:686`
  - Text Input → `66:685`
  - Cards → `2:113`
  - Buttons → `36:1881`
  - Colors → `66:689`
- For a visual reference of a component: `get_screenshot` on its node ID (IDs in `references/full_inventory.md`).

If neither Figma MCP is connected, use the reference files — never silently invent values.

## Traceability footers — one per artifact, no exceptions

After every visual artifact, end with a compact footer so the maintainer can verify at a glance that everything traces back to Pantheon. Choose the footer that matches the path:

**Figma-authoring path** — see §1.8 for the full format.

**Code path:**

```
Pantheon components used:
- Button (Primary, Medium, Square) — Pantheon `Button` set
- Text Input (Medium, Default, Floating label) — Pantheon `Text Input` set
- Chips (Medium, Round, Accent-Green) — Pantheon `Chips` set
- Icons: search, close (Outline), check (Filled, in selected chip) — Pantheon Outline / Filled sets

Tokens: Surface/Primary, Border/Primary, Text/Primary, Buttons/Primary, Border/Brand
Typography: Prometheus/Title/Large-Bold, Body/Medium-Regular, Label/Small-Medium
```

**Document path:** name the Pantheon Text Styles, the accent families used in any chart, and the section tint if a color block was used.

If the artifact uses a composition of primitives for a not-in-Pantheon pattern (e.g., a Banner composed from Card + status tokens), list it as `Composed from: Card + Surface/Success + Icon/Success — no dedicated component in Pantheon`. Flagging is never a substitute for adding to Pantheon later; it is the substitute for building it as a one-off today.

## Working style

When a designer asks for something visual, don't narrate the design system at them — they wrote it. Apply it. A good response ships the artifact; a weak response explains it. If a decision is ambiguous (e.g., "Title/Large or Display/Small?"), pick the one that fits the information density and move on.

If a task clearly falls outside Pantheon's coverage, **first decide whether the user actually asked for it.** If they didn't, omit it and mention the gap in one closing line. If they did, compose from Pantheon primitives — staying inside the token and typography grammar — and still flag the gap so it can be fed back into the system. Flagging never substitutes for adding it to Pantheon later; it substitutes for building it as a one-off today.
