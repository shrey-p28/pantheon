# Pantheon — Complete Variable Map
Extracted: 2026-04-20
Pages queried: 23 (all canvases in file `l8qALS4HQUMbSTyP8BTGRL`)
Total unique tokens: 140

Tool used: `mcp__figma-local__get_variable_defs` on each page node id.
Each page returns only the variables referenced by nodes on that page, so this file
is the union of 23 per-page queries.

## Semantic tokens

### Surface
| Token | Value | First seen on |
|---|---|---|
| Surface/Primary | #ffffff | Cover (126:26) |
| Surface/Secondary | #fafafa | Cards (2:113) |
| Surface/Tertiary | #f0f0f0 | Bottom Sheets (66:687) |
| Surface/Brand | #e8f1fd | Dropdown (2768:141) |
| Surface/Brand Secondary | #f9e9ea | Tooltip (2380:1293) |
| Surface/Error | #fbeae9 | Tooltip (2380:1293) |
| Surface/Warning | #fef5d3 | Tooltip (2380:1293) |
| Surface/Success | #eefff5 | Tooltip (2380:1293) |
| Surface/Accent-Navy Blue | #d7e6ff | Cover (126:26) |
| Surface/Background-Accent-Aqua | #d8f3f9 | Table (2436:798) |
| Surface State/Tertiary/Opacity-08 | #cccccc14 | Buttons (36:1881) |
| Surface State/Secondary/Opacity-08 | #3a84ec14 | Chips (57:165) |
| Surface State/Black/Opacity-08 | #00000014 | Switch (2382:278) |
| Surface State/Black/Opacity-10 | #0000001a | Switch (2382:278) |
| Surface State/Black/Opacity-16 | #00000029 | Switch (2382:278) |

### Text
| Token | Value | First seen on |
|---|---|---|
| Text/Primary | #000000 | Bottom Sheets (66:687) |
| Text/Secondary | #666666 | Bottom Sheets (66:687) |
| Text/Tertiary | #999999 | Text Input (66:685) |
| Text/Disabled | #999999 | Buttons (36:1881) |
| Text/Invert | #ffffff | Badges (50:222) |
| Text/Brand | #1770ee | Buttons (36:1881) |
| Text/Error | #d92d20 | Text Input (66:685) |

### Icon
| Token | Value | First seen on |
|---|---|---|
| Icon/Primary | #000000 | Cover (126:26) |
| Icon/Brand | #1770ee | Chips (57:165) |
| Icon/Disabled | #999999 | Chips (57:165) |
| Icon/Invert | #ffffff | Icons (2884:15439) |
| Icon/Success | #10542e | Icons (2884:15439) |
| Icon/Error | #d92d20 | Icons (2884:15439) |
| Icon/Warning | #64520e | Icons (2884:15439) |

### Border
| Token | Value | First seen on |
|---|---|---|
| Border/Primary | #e5e5e5 | Bottom Sheets (66:687) |
| Border/Brand | #1770ee | Buttons (36:1881) |
| Border/Disabled | #cccccc | Buttons (36:1881) |
| Border/Strong | #999999 | Text Input (66:685) |
| Border/Error | #d92d20 | Text Input (66:685) |

### Buttons
| Token | Value | First seen on |
|---|---|---|
| Buttons/Primary | #1770ee | Bottom Sheets (66:687) |
| Buttons/Primary Pressed | #125abe | Buttons (36:1881) |
| Buttons/Tonal | #e8f1fd | Buttons (36:1881) |
| Buttons/Tonal Pressed | #d1e2fc | Buttons (36:1881) |
| Buttons/Tertiary | #ffffff | Bottom Sheets (66:687) |
| Buttons/Disabled | #f5f5f5 | Buttons (36:1881) |

### Notch / Accent seen on components
| Token | Value | First seen on |
|---|---|---|
| Notch/Accent-Purple | #7e00d2 | Badges (50:222) |
| Notch/Accent-Green | #0d9a32 | Icons (2884:15439) |

## Primitive palettes

Only the four ramps below were referenced by any page — the other ramps
(Primary, Secondary, Gray, Aqua, Pink, Beige, Error, Accent/Red, Accent/Blue, etc.)
exist as variable definitions in the file (per prior inventory: 391 tokens on the
hidden `Internal Only Canvas`) but are not *referenced* by any visible page node,
so `get_variable_defs` does not surface them. The Colors page itself only renders
ramp swatches; only Yellow, Green, Warning and Success ramps are actually bound
to variables there.

### Accent / Yellow (Colors page 66:689)
| Token | Value |
|---|---|
| Accents/Yellow/Yellow-100 | #fffbea |
| Accents/Yellow/Yellow-200 | #fef5d3 |
| Accents/Yellow/Yellow-300 | #fdeba7 |
| Accents/Yellow/Yellow-400 | #fcd64f |
| Accents/Yellow/Yellow-500 | #fbcc23 |
| Accents/Yellow/Yellow-600 | #c9a31c |
| Accents/Yellow/Yellow-700 | #64520e |
| Accents/Yellow/Yellow-800 | #322907 |
| Accents/Yellow/Yellow-900 | #191404 |

### Accent / Green (Colors page 66:689)
| Token | Value |
|---|---|
| Accents/Green/Green-100 | #e2f9e8 |
| Accents/Green/Green-200 | #caf2d5 |
| Accents/Green/Green-300 | #9ce6af |
| Accents/Green/Green-400 | #3fcd64 |
| Accents/Green/Green-500 | #10c03e |
| Accents/Green/Green-600 | #0d9a32 |
| Accents/Green/Green-700 | #0a7325 |
| Accents/Green/Green-800 | #064d19 |
| Accents/Green/Green-900 | #053a13 |

### Warning (Colors page 66:689)
| Token | Value |
|---|---|
| Warning/Warning-100 | #fffae9 |
| Warning/Warning-200 | #fef5d3 |
| Warning/Warning-300 | #fdeba7 |
| Warning/Warning-400 | #fcd64f |
| Warning/Warning-500 | #fbcc23 |
| Warning/Warning-600 | #c9a31c |
| Warning/Warning-700 | #64520e |
| Warning/Warning-800 | #322907 |
| Warning/Warning-900 | #191404 |

### Success (Colors page 66:689)
| Token | Value |
|---|---|
| Success/Success-100 | #eefff5 |
| Success/Success-200 | #dcffeb |
| Success/Success-300 | #baffd8 |
| Success/Success-400 | #75ffb1 |
| Success/Success-500 | #52ff9d |
| Success/Success-600 | #42d481 |
| Success/Success-700 | #217f4a |
| Success/Success-800 | #10542e |
| Success/Success-900 | #002912 |

### Other (legacy / non-Pantheon scope)
| Token | Value | First seen on |
|---|---|---|
| Colors/Surface/Black (Text & icons) | #000000 | Pop Up (66:688) |

## Typography (Prometheus collection)

Variable definitions are split into **primitives** (Size, Line Height, Weight name strings)
and **composite `Prometheus/*` font tokens** that reference the primitives. All live in
the Prometheus collection.

### Prometheus font composites
| Token | Value (resolved) | First seen on |
|---|---|---|
| Prometheus/Display/Large-Regular | Inter 32 / 40 / 400 | Typography (66:686) |
| Prometheus/Display/Large-Medium | Inter 32 / 40 / 500 | Typography (66:686) |
| Prometheus/Display/Large-SemiBold | Inter 32 / 40 / 600 | Tabs (47:626) |
| Prometheus/Display/Large-Bold | Inter 32 / 40 / 700 | Typography (66:686) |
| Prometheus/Display/Medium-Regular | Inter 24 / 32 / 400 | Typography (66:686) |
| Prometheus/Display/Medium-Medium | Inter 24 / 32 / 500 | Typography (66:686) |
| Prometheus/Display/Medium-SemiBold | Inter 24 / 32 / 600 | Buttons (36:1881) |
| Prometheus/Display/Medium-Bold | Inter 24 / 32 / 700 | Typography (66:686) |
| Prometheus/Display/Small-Regular | Inter 20 / 28 / 400 | Typography (66:686) |
| Prometheus/Display/Small-Medium | Inter 20 / 28 / 500 | Typography (66:686) |
| Prometheus/Display/Small-SemiBold | Inter 20 / 28 / 600 | Side Drawer (2400:18) |
| Prometheus/Display/Small-Bold | Inter 20 / 28 / 700 | Typography (66:686) |
| Prometheus/Title/Large-Regular | Inter 18 / 26 / 400 | Typography (66:686) |
| Prometheus/Title/Large-Medium | Inter 18 / 26 / 500 | Buttons (36:1881) |
| Prometheus/Title/Large-SemiBold | Inter 18 / 26 / 600 | Bottom Sheets (66:687) |
| Prometheus/Title/Large-Bold | Inter 18 / 26 / 700 | Typography (66:686) |
| Prometheus/Title/Medium-Regular | Inter 16 / 24 / 400 | List (3461:3) |
| Prometheus/Title/Medium-Medium | Inter 16 / 24 / 500 | Buttons (36:1881) |
| Prometheus/Title/Medium-SemiBold | Inter 16 / 24 / 600 | Bottom Sheets (66:687) |
| Prometheus/Title/Medium-Bold | Inter 16 / 24 / 700 | Typography (66:686) |
| Prometheus/Title/Small-Regular | Inter 14 / 22 / 400 | Cards (2:113) |
| Prometheus/Title/Small-Medium | Inter 14 / 22 / 500 | Buttons (36:1881) |
| Prometheus/Title/Small-SemiBold | Inter 14 / 22 / 600 | Buttons (36:1881) |
| Prometheus/Title/Small-Bold | Inter 14 / 22 / 700 | Typography (66:686) |
| Prometheus/Body/Large-Regular | Inter 16 / 24 / 400 | List (3461:3) |
| Prometheus/Body/Large-Medium | Inter 16 / 24 / 500 | Buttons (36:1881) |
| Prometheus/Body/Large-SemiBold | Inter 16 / 24 / 600 | Buttons (36:1881) |
| Prometheus/Body/Large-Bold | Inter 16 / 24 / 700 | Typography (66:686) |
| Prometheus/Body/Medium-Regular | Inter 14 / 22 / 400 | Bottom Sheets (66:687) |
| Prometheus/Body/Medium-Medium | Inter 14 / 22 / 500 | Buttons (36:1881) |
| Prometheus/Body/Medium-SemiBold | Inter 14 / 22 / 600 | Buttons (36:1881) |
| Prometheus/Body/Medium-Bold | Inter 14 / 22 / 700 | Typography (66:686) |
| Prometheus/Body/Small-Regular | Inter 12 / 20 / 400 | Text Input (66:685) |
| Prometheus/Body/Small-Medium | Inter 12 / 20 / 500 | Text Input (66:685) |
| Prometheus/Body/Small-SemiBold | Inter 12 / 20 / 600 | Typography (66:686) |
| Prometheus/Body/Small-Bold | Inter 12 / 20 / 700 | Typography (66:686) |
| Prometheus/Label/Large-Medium | Inter 14 / 22 / 500 | Typography (66:686) |
| Prometheus/Label/Large-SemiBold | Inter 14 / 22 / 600 | Typography (66:686) |
| Prometheus/Label/Medium-Medium | Inter 12 / 20 / 500 | Chips (57:165) |
| Prometheus/Label/Medium-SemiBold | Inter 12 / 20 / 600 | List (3461:3) |
| Prometheus/Label/Small-Medium | Inter 10 / 18 / 500 | Bottom Sheets (66:687) |
| Prometheus/Label/Small-SemiBold | Inter 10 / 18 / 600 | Typography (66:686) |

### Typography primitives (font family, size, line-height, weight names)
| Token | Value | First seen on |
|---|---|---|
| Static/Font/Font | Inter | Bottom Sheets (66:687) |
| Static/Weight/Regular | Regular | Bottom Sheets (66:687) |
| Static/Weight/Medium | Medium | Buttons (36:1881) |
| Static/Weight/Semi Bold | Semi Bold | Buttons (36:1881) |
| Static/Weight/Bold | Bold | Typography (66:686) |
| Display Large/Size | 32 | Tabs (47:626) |
| Display Large/Line Height | 40 | Tabs (47:626) |
| Display Large/Regular | Regular | Typography (66:686) |
| Display Large/Medium | Medium | Typography (66:686) |
| Display Large/Semi Bold | Semi Bold | Tabs (47:626) |
| Display Large/Bold | Bold | Typography (66:686) |
| Display Medium/Size | 24 | Buttons (36:1881) |
| Display Medium/Line Height | 32 | Buttons (36:1881) |
| Display Medium/Regular | Regular | Colors (66:689) |
| Display Medium/Medium | Medium | Typography (66:686) |
| Display Medium/Semi Bold | Semi Bold | Buttons (36:1881) |
| Display Medium/Bold | Bold | Typography (66:686) |
| Display Small/Size | 20 | Side Drawer (2400:18) |
| Display Small/Line Height | 28 | Side Drawer (2400:18) |
| Display Small/Regular | Regular | Typography (66:686) |
| Display Small/Medium | Medium | Typography (66:686) |
| Display Small/Semi Bold | Semi Bold | Side Drawer (2400:18) |
| Display Small/Bold | Bold | Typography (66:686) |
| Title Large/Size | 18 | Bottom Sheets (66:687) |
| Title Large/Line Height | 26 | Bottom Sheets (66:687) |
| Title Large/Regular | Regular | Typography (66:686) |
| Title Large/Medium | Medium | Buttons (36:1881) |
| Title Large/Semi Bold | Semi Bold | Bottom Sheets (66:687) |
| Title Large/Bold | Bold | Typography (66:686) |
| Title Medium/Size | 16 | Bottom Sheets (66:687) |
| Title Medium/Line Height | 24 | Bottom Sheets (66:687) |
| Title Medium/Regular | Regular | List (3461:3) |
| Title Medium/Medium | Medium | Buttons (36:1881) |
| Title Medium/Semi Bold | Semi Bold | Bottom Sheets (66:687) |
| Title Medium/Bold | Bold | Typography (66:686) |
| Title Small/Size | 14 | Buttons (36:1881) |
| Title Small/Line Height | 22 | Buttons (36:1881) |
| Title Small/Regular | Regular | Cards (2:113) |
| Title Small/Medium | Medium | Buttons (36:1881) |
| Title Small/Semi Bold | Semi Bold | Buttons (36:1881) |
| Title Small/Bold | Bold | Typography (66:686) |
| Body Large/Size | 16 | Buttons (36:1881) |
| Body Large/Line Height | 24 | Buttons (36:1881) |
| Body Medium/Size | 14 | Bottom Sheets (66:687) |
| Body Medium/Line Height | 22 | Bottom Sheets (66:687) |
| Body Small/Size | 12 | Text Input (66:685) |
| Body Small/Line Height | 20 | Text Input (66:685) |
| Label Large/Size | 14 | Typography (66:686) |
| Label Large/Line Height | 22 | Typography (66:686) |
| Label Large/Medium | Medium | Typography (66:686) |
| Label Large/Semi Bold | Semi Bold | Typography (66:686) |
| Label Medium/Size | 12 | Chips (57:165) |
| Label Medium/Line Height | 20 | Chips (57:165) |
| Label Medium/Semi Bold | Semi Bold | List (3461:3) |
| Label Small/Size | 10 | Badges (50:222) |
| Label Small/Line Height | 18 | Badges (50:222) |
| Label Small/Medium | Medium | Badges (50:222) |

## Sizing / Radius

### Width (icon/affordance size scale)
| Token | Value | First seen on |
|---|---|---|
| X Small/Width | 16 | Buttons (36:1881) |
| X Small/Height | 16 | Icons (2884:15439) |
| Small/Width | 18 | Buttons (36:1881) |
| Medium/Width | 20 | Bottom Sheets (66:687) |
| Large/Width | 24 | Buttons (36:1881) |

### Radius (Square / Round scales)
| Token | Value | First seen on |
|---|---|---|
| Square/Small | 8 | Bottom Sheets (66:687) |
| Square/Medium | 10 | Bottom Sheets (66:687) |
| Square/Large | 12 | Buttons (36:1881) |
| Round/Rounded | 200 | Buttons (36:1881) |

### Elevation
| Token | Value | First seen on |
|---|---|---|
| Elevation/3 | DROP_SHADOW #0000004D offset(0,1) r3 s0 + #00000026 offset(0,4) r8 s3 | Pop Up (66:688) |

## Other / uncategorized

These appear to be legacy `--sds-*` tokens from the Simple Design System kit,
accidentally referenced on the Colors page.

| Token | Value | First seen on |
|---|---|---|
| var(--sds-size-stroke-border) | 1 | Colors (66:689) |
| var(--sds-size-radius-xl) | 24 | Colors (66:689) |
| var(--sds-color-background-default-default) | #ffffff | Colors (66:689) |
| var(--sds-color-border-default-default) | #d9d9d9 | Colors (66:689) |

## Cross-page collisions (same token, different values)

None. Every repeated token resolved to the same value across all pages where
it appeared. The semantic collection is internally consistent.

## Pages that returned empty

| Page | Node id | Note |
|---|---|---|
| Internal Only Canvas | 0:2 | Hidden shadow library. Holds 404 token *definitions* per metadata dump, but no visible node references them, so `get_variable_defs` returns `{}`. |
| --- (separator) | 126:27 | Empty separator page. |
| Date Picker | 3980:641 | 0 children (placeholder page). |

## Per-page token counts

| Page | Node id | Unique tokens returned |
|---|---|---|
| Cover | 126:26 | 3 |
| --- | 126:27 | 0 |
| Badges | 50:222 | 7 |
| Bottom Sheets | 66:687 | 24 |
| Buttons | 36:1881 | 46 |
| Cards | 2:113 | 22 |
| Checkbox | 2331:76 | 4 |
| Chips | 57:165 | 31 |
| Colors | 66:689 | 42 |
| Date Picker | 3980:641 | 0 |
| Icons | 2884:15439 | 11 |
| List | 3461:3 | 17 |
| Pop Up | 66:688 | 15 |
| Dropdown | 2768:141 | 19 |
| Radio Buttons | 2381:1299 | 4 |
| Side Drawer | 2400:18 | 30 |
| Switch | 2382:278 | 9 |
| Table | 2436:798 | 26 |
| Tabs | 47:626 | 25 |
| Text Input | 66:685 | 32 |
| Tooltip | 2380:1293 | 17 |
| Typography | 66:686 | 66 |
| Internal Only Canvas | 0:2 | 0 |

## Surprises / notes for the skill

1. **Hidden library = silent gap.** `Internal Only Canvas` (hidden) contains 404
   variable definitions per the metadata dump, but `get_variable_defs` only
   surfaces tokens *referenced* on a page's visible nodes. So primitive ramps
   like `Primary/Primary-100..600`, `Secondary/Secondary-500`, `Gray/Gray-0..1000`,
   `Error/*`, full `Accent/Aqua`, `Accent/Pink`, `Accent/Beige` ramps are defined
   but unreachable through this tool. To get them you must open the file and
   inspect Variables → Collections directly, or use the Figma REST API
   `GET /v1/files/:key/variables/local`.
2. **Aqua ramp not surfaced at all** — only `Surface/Background-Accent-Aqua` alias
   is visible (on Table page). Same for Pink, Beige ramps.
3. **Two `#fef5d3` aliases** exist: `Accents/Yellow/Yellow-200` and `Warning/Warning-200`.
   Same hex, different namespaces (no collision since token names differ).
4. **Legacy SDS tokens** (`var(--sds-...)`) on the Colors page — 4 of them.
   Likely copied from a Figma community template. Flag for cleanup.
5. **`Colors/Surface/Black (Text & icons)`** is a legacy token on Pop Up — not in the
   Pantheon `Surface/*` namespace. Probably to be migrated to `Text/Primary`.
6. **Typography weight names are duplicated** across every size scale
   (e.g. `Title Large/Semi Bold`, `Title Medium/Semi Bold`, ...). They all resolve
   to the string `"Semi Bold"`. This is how the Prometheus composite font
   variables reference style names. Redundant-looking but required by the
   composite-variable plumbing.
7. **No explicit spacing/padding collection** surfaced. Spacing values in
   components are hardcoded (8/10/12/16/20/24), matching the `Square/*` and
   `*/Width` scales but not named as spacing tokens.
8. **`Notch/Accent-*` family** (Purple, Green) is a small accent-for-badge collection
   only referenced on Badges and Icons pages.
