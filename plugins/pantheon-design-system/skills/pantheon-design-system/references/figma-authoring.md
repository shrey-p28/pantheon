# Figma-authoring playbook

This is the reference file that converts SKILL.md §1 ("Figma-authoring path") into concrete tool sequences. Load it whenever the deliverable lives in a Figma file.

The MCP server prefix throughout is `mcp__c4f7c44c-626e-4e6c-8756-6fc81e947d15__`. For brevity below, that prefix is shortened to `figma__`. So `figma__use_figma` means `mcp__c4f7c44c-626e-4e6c-8756-6fc81e947d15__use_figma`.

**Pantheon constants** (verified live, 2026-04-29):
- File key: `l8qALS4HQUMbSTyP8BTGRL`
- Library key: `lk-e668811788fb5b438ff0a2abb7aef68c6d641138b51a91d88632b2e6b725462df96674d94af000be5e7eeb211c7fd8189c84e25da686ed4f3878eb9dd81794f0`

**Identifier discipline** (the #1 source of bugs):
- File key → URL parameter for `get_libraries`, `get_metadata`, `get_variable_defs`, `get_screenshot`, `use_figma`
- Library key → scope for `search_design_system` via `includeLibraryKeys`
- Component key → argument to `figma.importComponentSetByKeyAsync()` / `figma.importComponentByKeyAsync()` (40-char hex hash from `search_design_system` results, NOT a local node ID)

**Skill-loading prerequisite:** if a `/figma-use` skill is available in your Claude session, load it before any `use_figma` call. The Figma MCP's tool docs require it.

## Why this file exists

Claude has a strong default to "describe what the file would look like" or to redraw shapes that resemble Pantheon components. Both are wrong when the user asked for Figma. The deliverable in Figma is *real instances bound to real library variables*. This file gives the exact tool sequence for each common scenario so Claude has no excuse to substitute drawing for inserting.

If you're about to do anything Figma-shaped and you haven't read SKILL.md §1 in this session, go read it first.

---

## Scenario 0 — Pre-flight (do this before any other scenario)

Run these in order. If any fails, stop and resolve with the user before authoring.

### 0a. ASK WHERE THE DESIGN GOES — before any MCP call

Default: never call `create_new_file`. Default: ask the user where the design lands.

Phrasing:

> "Where should this go?
> (a) An existing Figma file — paste the file URL plus the page or frame.
> (b) A new page in an existing file — file URL + new page name.
> (c) A new file in a specific Petpooja project folder — project folder URL or ID.
> (d) Just a reference (screenshot of a Pantheon component, no file changes)."

Inference shortcuts:
- User pasted a Figma URL? Treat as (a), confirm the page/frame in one line.
- User explicitly said "create a new file"? Go to (c), ask which Petpooja project folder.
- Ambiguous prompt? Ask. Never guess.

NEVER use drafts. The shared-Cowork constraint (one Cowork, many teammates, one rotating Figma identity on the connector) means drafts land in whoever-currently-holds-the-Figma-token's account — invisible to other teammates the moment the connector reconnects. Always shared Petpooja project folders.

### 0b. MCP pre-flight calls

```text
1. figma__whoami
   Expect: { email, handle, plans: [...] }. Save the user's plan key for the
   Petpooja team (e.g., team::1299299951002632114) — needed if Scenario A
   applies (and only if the user explicitly asked for a new file).

   IDENTITY SURFACING (informational, not a gate):
   Tell the user in one line:
     "Figma MCP authenticated as <email> (<handle>). All file creation /
      editing runs under this identity. If a different teammate should be
      the author of record, reconnect the Figma MCP first."
   Don't try to validate the identity against a "correct" teammate — the
   Cowork is shared and Claude can't tell which human is active.

2. figma__get_libraries
     fileKey: <user's working file key>   ← NOT the Pantheon file key
   Expect: response.libraries_added_to_file contains an entry with
     name: "Pantheon"
     libraryKey: "lk-e668811788fb5b438ff0a2abb7aef68c6d641138b51a91d88632b2e6b725462df96674d94af000be5e7eeb211c7fd8189c84e25da686ed4f3878eb9dd81794f0"
   If Pantheon is in libraries_available_to_add but NOT libraries_added_to_file:
     the file hasn't enabled Pantheon yet. Either ask the user to enable it
     in the Libraries dialog, OR enable it programmatically with figma__use_figma:
       (async () => {
         await figma.teamLibrary.getAvailableLibrariesAsync(); // refresh cache
         // Note: enabling a library programmatically requires Plugin API
         // permissions that may not be available; if it errors, fall back
         // to asking the user.
       })();

3. figma__get_design_context  (only if extending an existing file)
   Pass the user's working file URL or key + the node they pointed to.
   Expect: existing tokens / styles / components in use.
   Use this to keep new content consistent with what's already on canvas.

4. figma__get_variable_defs  (Pantheon library, page-level)
   Pull at least these Pantheon page IDs:
     - Colors:     66:689
     - Typography: 66:686
     - Buttons:    36:1881
     - Text Input: 66:685
     - Cards:      2:113
   Save the returned variable name → variable_key map. You'll pass these
   keys to figma.variables.importVariableByKeyAsync() inside use_figma.

5. figma__search_design_system
     query: "<component name>"
     fileKey: <user's working file key>
     includeLibraryKeys: ["lk-e668811788fb5b438ff0a2abb7aef68c6d641138b51a91d88632b2e6b725462df96674d94af000be5e7eeb211c7fd8189c84e25da686ed4f3878eb9dd81794f0"]
     includeStyles: false
     includeVariables: false
   For each Pantheon component you plan to insert. Pick the result where
     libraryName === "Pantheon" AND assetType === "component_set" (or
     "component" for icons / singular components).
   Save the componentKey for the use_figma step.
```

Only after pre-flight passes do you proceed.

---

## Scenario A — Create a brand-new Figma file with a Pantheon UI

**ONLY use this scenario when the user explicitly asks for a new file.** Phrases like "make a Figma file," "create a new file," "spin up a fresh file." If the user asked for a "Pantheon login screen" or "Pricing page mock," that's almost always Scenario B (insert into an existing file) — confirm with them before reaching for `create_new_file`.

When this scenario applies, the file MUST land in a shared Petpooja project folder via `projectId`. Drafts are forbidden — they land in the connector's currently-auth'd Figma account, which won't be visible to other teammates. Ask for the project folder URL or ID before proceeding.

```text
A1. Run pre-flight (Scenario 0) — but for step 2 you don't have the user's
    file yet. Defer step 2 until A2 returns the new fileKey.

A2. Confirm the user explicitly asked for a NEW FILE (not "design something
    in Figma," which is Scenario B). If unsure, ASK before calling
    create_new_file. The cost of accidentally creating a file is ongoing
    Drafts/folder pollution; the cost of asking is one extra turn.

    Then ask for the Petpooja project folder if not already provided:
      "Which Petpooja project folder should this file live in? Paste the
       folder URL (looks like figma.com/files/team/.../project/<id>) or
       give me the project ID."

    figma__create_new_file
      fileName:   "<descriptive name from user prompt>"
      planKey:    <Petpooja team key from whoami, e.g. team::1299299951002632114>
      editorType: "design"
      projectId:  <REQUIRED — Petpooja shared project folder ID>
    Returns: { fileKey, url } for the new file.

    DO NOT omit projectId. The default (drafts) is forbidden under the
    shared-Cowork constraint — files there are invisible to other
    teammates as soon as the Figma connector reconnects.

    After A2, tell the user where the file landed in one short line:
      "Created '<fileName>' in Petpooja project '<folder name>'. URL: <file_url>"

A3. Now run Scenario 0 step 2 (get_libraries) against the new fileKey.
    Pantheon may need to be added to the file — the new-file default doesn't
    automatically subscribe to all team libraries.

A4. figma__use_figma
      fileKey: <new fileKey from A2>
      code:    <see below>
      description: "Set up Pantheon-compliant page with <components>"
      skillNames: "figma-use"

    Skeleton code (trial-verified 2026-04-29 — `loadAllPagesAsync` is NOT
    supported in the use_figma runtime, don't call it. ALSO don't use
    `figma.currentPage` as your append target — it resolves to whatever
    page is active in the user's desktop and creates orphans. Always
    look up the target page by ID):

    (async () => {
      // Look up the user's intended page (NOT figma.currentPage!)
      const page = await figma.getNodeByIdAsync("<target-page-id>");
      if (!page || page.type !== "PAGE") throw new Error("page not found");
      page.name = "Pricing v1"; // rename if creating new file
      page.name = "Pricing v1";

      // Import each component set you'll need from Pantheon by componentKey.
      // (Keys come from SKILL.md §1.6 or from search_design_system results.)
      const primaryButton = await figma.importComponentSetByKeyAsync(
        "fc6d6cde9cd8018b2e74edc081c8b81e336e92db" // Pantheon › Primary
      );
      const card = await figma.importComponentSetByKeyAsync(
        "3abc4532bdd32303c6e2d255211177c4889aa956" // Pantheon › Cards
      );

      // Import the variables you'll bind to.
      const surfacePrimary = await figma.variables.importVariableByKeyAsync(
        "<variable_key for Surface/Primary from get_variable_defs>"
      );
      const borderPrimary = await figma.variables.importVariableByKeyAsync(
        "<variable_key for Border/Primary from get_variable_defs>"
      );

      // Import the Text Styles.
      const titleLargeBold = await figma.importStyleByKeyAsync(
        "<style_key for Prometheus/Title/Large-Bold from get_variable_defs>"
      );
      const bodyMediumRegular = await figma.importStyleByKeyAsync(
        "<style_key for Prometheus/Body/Medium-Regular>"
      );

      // Compose the layout.
      const section = figma.createFrame();
      section.name = "Section / Pricing Cards";
      section.layoutMode = "HORIZONTAL";
      section.itemSpacing = 24;
      section.paddingLeft = section.paddingRight = 32;
      section.paddingTop = section.paddingBottom = 32;
      section.primaryAxisSizingMode = "AUTO";
      section.counterAxisSizingMode = "AUTO";
      section.fills = [
        figma.variables.setBoundVariableForPaint(
          { type: "SOLID", color: { r: 1, g: 1, b: 1 } },
          "color",
          surfacePrimary
        ),
      ];

      // Insert three card instances side by side
      for (const tier of ["Starter", "Pro", "Enterprise"]) {
        const cardInstance = card.defaultVariant.createInstance();
        cardInstance.setProperties({
          // variant axes for Cards — confirm via figma__get_metadata on the
          // component-set node ID before going wide.
        });
        cardInstance.name = `Card / ${tier}`;
        section.appendChild(cardInstance);
      }

      page.appendChild(section);
      section.x = 0;
      section.y = 0;
      figma.viewport.scrollAndZoomIntoView([section]);

      return { sectionId: section.id };
    })();

A5. Final pass: verify SKILL.md §1.5 hard-gate checklist. Run
    figma__get_design_context against the new file to confirm every layer
    cites a Pantheon component or a flagged composed group.

A6. End your turn with the §1.9 delivery footer.
```

---

## Scenario B — DEFAULT PATH: insert into an existing file/page (or new page in existing file)

This is the path most asks resolve to. Use cases:
- "Add a confirmation popup to the existing checkout frame."
- "Design a Pantheon login screen" (in <some existing file the user named>)
- "Mock up a settings page on a new page in <existing file>"
- "Update the cards on the dashboard frame"

```text
B0. Confirm placement from the user (Scenario 0a). You should already have:
    - The target file's URL or fileKey
    - One of: a target page name, a target frame node ID, or a "create a
      new page named X" instruction
    Ask if any of the above is missing. Don't guess.

B1. Pre-flight (Scenario 0b: whoami + get_libraries on the target fileKey +
    get_variable_defs on the Pantheon page IDs you'll need).

B2. If the user pointed at a specific frame, run figma__get_design_context
    on that frame. Note which Pantheon components are already in use and
    which Variables are already bound. Match the existing palette of
    choices — don't introduce a new accent family or theme unless the user
    asked.

B3. Configure the placement target inside use_figma:

    (async () => {
      // Find or create the target page.
      let page = figma.root.children.find(p => p.name === "<TARGET_PAGE_NAME>");
      if (!page) {
        // Only create a new page if the user explicitly asked for one.
        page = figma.createPage();
        page.name = "<TARGET_PAGE_NAME>";
      }
      // For modifications to an existing frame, use page.findOne to locate
      // the target by name or by node ID. Don't iterate the whole page tree
      // unnecessarily — pages can be huge.

      // ... import componentSets, create instances, build frame, append to
      // page (or to the target frame if extending). Per §1.4 in SKILL.md.
    })();

B4. If the existing frame uses non-Pantheon shapes (rectangles styled to look
    like Pantheon), call those out explicitly in your response — don't
    replicate the violation. Insert the real Pantheon component next to the
    offending shape and tell the user the existing shape should be replaced.

B5. End with the §1.9 delivery footer. Include one row under "Pre-existing
    issues" if you spotted any non-Pantheon shapes during B4.
```

---

## Scenario C — "Fix" a non-Pantheon mock the user shows you

Use case: "Here's a screenshot from a developer — make a clean Pantheon version of this in Figma."

```text
C1. Pre-flight (Scenario 0).

C2. Read the screenshot/mockup. For every visible element, identify which
    Pantheon component (and variant) maps to it. Build the mapping table in
    your scratch reasoning before writing any tool call. Use SKILL.md §1.6
    for componentKeys.

C3. If an element doesn't map cleanly, decide:
    - Is it a Pantheon-equivalent in disguise? (E.g., the dev built a "search
      bar" that's really Text Input + leading icon. Map it to Text Input.)
    - Is it a not-in-Pantheon component the user explicitly wants? (E.g.,
      "Avatar" — no Pantheon equivalent. Compose from circle + Outline icon
      and label the group "Composed / not-in-Pantheon / Avatar".)
    - Is it an invention you can omit? (E.g., decorative gradient banner.
      Omit and flag in your closing line.)

C4. Author the new frame per Scenario A4. Place it next to the original
    screenshot/mockup so the user can compare.

C5. Closing line: list every element from the source mock that didn't survive
    (omitted as not-in-Pantheon, or composed from primitives, or replaced
    with a different Pantheon component than the source).
```

---

## Scenario D — Build a chart or dashboard tile in Figma

Use case: "Make a sales dashboard with bar and line charts in Figma."

```text
D1. Pre-flight (Scenario 0).

D2. Insert Pantheon Cards (componentKey 3abc4532bdd32303c6e2d255211177c4889aa956)
    as the tile container. Bind:
      - fill ← Surface/Primary
      - stroke ← Border/Primary, 1px
      - radius ← Square/Medium (10px) — confirm the Cards default variant
        has this radius; if not, set explicitly via instance properties.

D3. Inside the card, place text instances (no plain text layers — apply Text
    Styles via importStyleByKeyAsync + textStyleId):
    - Tile title ← Prometheus/Title/Small-Medium
    - Big number / KPI ← Prometheus/Display/Medium-Bold or Display/Small-Bold
    - Caption / delta ← Prometheus/Label/Small-Medium

D4. Chart series colors cycle through the 8 accent families IN THIS ORDER:
      Aqua → Beige → Green → Yellow → Navy Blue → Orange → Pink → Purple
    Bind series fills to Chips/Accent-<family> or the matching Card/Accent
    slot. NEVER cycle through a single ramp's 100/300/500/700 — that's
    monochrome saturation, not Pantheon.

D5. For status colors (success / warning / error) use the Status surface
    tokens:
      Surface/Success (#eefff5), Surface/Warning (#fef5d3), Surface/Error
      (#fbeae9)
    paired with their Text/* and Border/* counterparts. Don't mix status
    with accent families.

D6. Grid lines / axis ticks: Border/Primary at reduced opacity (or just
    Border/Primary if the chart is dense).

D7. Charts themselves: Pantheon does not ship a Chart component set.
    Compose from auto-layout frames + the colors above. Label the parent
    frame "Composed / not-in-Pantheon / Chart-Bar" so the gap is visible.

D8. End with the §1.9 delivery footer. List the accent families used and
    declare the chart frame as composed-not-in-Pantheon.
```

---

## Scenario E — User points at a specific Pantheon component and asks about it

Use case: "What variants does Text Input have?" / "Show me all the Button states." / "Insert just one of each Pantheon Chip variant."

```text
E1. Pre-flight (lighter — only whoami + get_libraries against Pantheon's own
    fileKey l8qALS4HQUMbSTyP8BTGRL).

E2. figma__get_screenshot
      fileKey: l8qALS4HQUMbSTyP8BTGRL
      nodeId:  <component-set ID from SKILL.md §1.6 right column or
               full_inventory.md>
    Returns a flattened image of the full variant matrix. Best for "show me
    everything."

E3. figma__get_metadata
      fileKey: l8qALS4HQUMbSTyP8BTGRL
      nodeId:  <component-set ID>
    Returns the variant axes and the per-variant child node IDs.

E4. If the user wants instances inserted into their working file, switch to
    Scenario A from step A4 onward, picking the variants they asked for.

E5. End with the §1.9 footer if you authored anything; otherwise paste the
    screenshot + a compact variant table from get_metadata.
```

---

## Scenario F — Code Connect mapping (when a Pantheon component should map to an existing code component)

Use case: "Wire our React `<Button>` component up to the Pantheon Button so Dev Mode shows the right code." / "Add Code Connect for the Text Input."

```text
F1. Pre-flight (Scenario 0).

F2. figma__get_code_connect_suggestions
      fileKey: l8qALS4HQUMbSTyP8BTGRL
      nodeId:  <component-set ID — e.g. for Pantheon Primary Button, get its
               local node ID from full_inventory.md or via get_metadata
               using the componentKey>
    Returns suggestions based on the codebase context.

F3. figma__get_context_for_code_connect
    Pull surrounding usage in the codebase the user pointed at.

F4. figma__add_code_connect_map
      fileKey:       l8qALS4HQUMbSTyP8BTGRL
      nodeId:        <Pantheon component-set node ID>
      componentName: "<code component name, e.g. Button>"
      source:        "<path in the user's repo, e.g. src/components/Button.tsx>"
      label:         "React"   (or Vue, Swift, Compose, …)
    Add one mapping per variant you care about, OR a single mapping with
    template + templateDataJson if your component takes props.

F5. figma__send_code_connect_mappings
    Sync to Figma so Dev Mode renders the mapping.

F6. figma__get_code_connect_map  (verify)
    Confirm the mapping appears for the component-set node ID you targeted.

F7. End with a compact table:
      Pantheon component → code component path → variant → prop mapping
```

---

## Scenario G — When the user asks for something Pantheon doesn't ship

Use case: "Add an Avatar component." / "Add a stepper." / "Build a Banner."

```text
G1. Pre-flight (Scenario 0).

G2. figma__search_design_system  for the requested component.
    If a real Pantheon component exists with a different name (e.g., the user
    said "snackbar" and Pantheon has Tooltip with Title+CTA variant), use
    that and explain the substitution.

G3. If nothing matches:
    - Confirm the user actually wants this component (re-read their prompt).
    - If they do: compose from Pantheon primitives (Card + Surface tokens +
      Icon + Text Style). Wrap the composed group in a frame named
      "Composed / not-in-Pantheon / <name>" so the gap is visible in the
      file outline.
    - If the component is decorative chrome they didn't explicitly request,
      omit and mention the gap in one closing line.

G4. NEVER ship a hand-drawn-looking Pantheon-component-equivalent without
    the "Composed / not-in-Pantheon" frame name.

G5. End with the §1.9 footer + a "Composed (not-in-Pantheon, flagged)" row.
```

---

## Hard rules (read once, then file away)

1. **Insertion is via `importComponentSetByKeyAsync(componentKey)` against the Pantheon library.** Period. If your tool call inserts something whose source file isn't Pantheon, the call is wrong.
2. **Variables and Text Styles are bound via `setBoundVariableForPaint` and `textStyleId`, never duplicated.** Don't copy a hex into a fill. Don't set fontName on a text layer manually. The library is the source of truth.
3. **No detached instances.** If you find yourself wanting to detach to "tweak," change the variant property or bind a different variable instead.
4. **No emoji. No invented icons. No off-grid spacing. No off-scale radii. No drop shadows except `Elevation/3` on Pop Up.**
5. **Every artifact ends with the §1.9 delivery footer.** No exceptions.
6. **If the Figma authoring MCP is not connected, do not silently fall back to drawing or to producing an SVG/HTML mockup as a substitute.** Tell the user explicitly that the MCP isn't connected and ask them to connect it.
7. **If a step fails mid-flow** (e.g., `search_design_system` returns nothing matching what you expect for "Tabs"), STOP. Do not proceed with a hand-drawn fallback. Report the failure to the user with the literal error and let them resolve it.
8. **Variant property names and values are case-sensitive strings.** When `setProperties` rejects a value, look at the component's `componentPropertyDefinitions` (visible in the Plugin API) for the exact accepted strings.

---

## Common variant defaults — quick reference

When the user asks for the obvious version of a component, these are the variant settings that match Pantheon's visual defaults. Confirm at runtime via `componentPropertyDefinitions` if `setProperties` errors.

- **Button (Primary CTA):** componentKey `fc6d6cde9cd8018b2e74edc081c8b81e336e92db`, `{ Size: "Medium", State: "Enabled", Type: "Square", "Show Icon": "None" }` (verified live)
- **Button (Tonal — secondary action):** componentKey `f28a0b2655bbbd43c7e23f4633c9b166364120e0`, `{ Size: "Medium", State: "Enabled", Type: "Square", "Show Icon": "None" }` (likely same axes as Primary — verify at runtime via instance.componentProperties before going wide)
- **Button (Outline — cancel/ghost):** componentKey `62d4fbda14a6548a4bfcc767c35403a5a5229070`. **Outline has DIFFERENT axes than Primary/Tonal:** `Show Icon` (False/True — not None/Leading/Trailing), plus a SEPARATE `Icon Position` axis (Leading/Trailing). Default props: `{ "Show Icon": "False", State: "Enabled", Type: "Square", Size: "Medium", "Icon Position": "Leading" }`
- **Text Input (basic field):** componentKey `cb39becb31c861d5c74a66d1fe72de085d4ddffc`. Likely axes: `Size, State, Label, Icon`. Verify exact axis names + values at runtime via `instance.componentProperties` before `setProperties` — Pantheon Buttons use `"Show Icon"` (with space) and `State: Enabled/Disabled/Pressed`, so Text Input likely follows the same convention. Don't assume `State=Default`.
- **Text Input (search-in-row):** same componentKey, configure as above + leading icon. Swap the nested icon to the `search` Outline symbol at 20px.
- **Cards (info tile):** componentKey `3abc4532bdd32303c6e2d255211177c4889aa956`. Verify variant axes at runtime.
- **Chips (filter-tag):** componentKey `462cd5372288dcffd7f8966361c5a88b539cb299`. Likely axes: `Type, State, Accent, Size, Icon`. Set `Type=Round, Accent=<family from the 8 accent ramps>, Size=Medium`. Other values verified at runtime.
- **Tabs (top-level nav):** componentKey `5314230198c65e0ff0fc52e488e2ff7a6a29b84d`. Verify axes at runtime.
- **Switch (binary toggle):** componentKey `b7bcfb3ccbce7271d0eaae7af39d2a99a662e4fc`. Verify axes at runtime; likely `Size, State, Value` with values verified live.
- **Tooltip (hint):** componentKey `b600d9b2933180dc153099e9b963f8051ccf4d23`. Likely axes: `Type, Icon, Position`. Verify at runtime.
- **Pop Up (modal):** componentKey `d41eb324764197f57477497e8022fa1f268e2752`. Place a Primary + Tonal Button in the footer.
- **Bottom Sheet (mobile):** componentKey `a964ddc633407ccc9dd3153b5c6c06fdc6c0521c`. Configure with Header + Handle visible (verify property names at runtime).
- **Side Drawer (settings panel):** componentKey `4e7a68536754b38879d5a7e4bdf56e026d2fcb1d`. Likely `Side=Right, Width=Medium` — verify axis names at runtime.

**Pattern:** for any component you haven't behaviorally trialed, do *not* hard-code variant property values from prose documentation. Always run a 2-line probe first:

```js
const set = await figma.importComponentSetByKeyAsync("<componentKey>");
return { axes: set.variantGroupProperties, defaultVariant: set.defaultVariant.name };
```

Use the response to construct your `setProperties` call. This is faster than guessing wrong four times in a row.

When the user wants something different, they'll say so. Default is the boring version.

---

## When in doubt, search

If you're not sure which Pantheon component matches what the user asked for, the right call is `figma__search_design_system` (with `includeLibraryKeys: [<Pantheon library key>]`) — not "I'll draw something close." Search is cheap; redrawing is expensive and produces non-Pantheon output. Reach for search by reflex.
