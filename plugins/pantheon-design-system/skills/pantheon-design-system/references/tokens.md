# Pantheon — Complete Token Reference

Source: Figma file `l8qALS4HQUMbSTyP8BTGRL` (Pantheon)
Extraction method: `mcp__figma-local__get_variable_defs` across all 23 pages + `get_metadata` on swatch frames + direct Variables panel screenshots for Pink/Purple/Orange/Navy Blue (which have no rendered swatches).
Last extracted: 2026-04-20 (ramps backfilled from screenshots of the Variables panel)

This file is the full token dump. Load when you need a specific hex value, line height, or radius that isn't in SKILL.md. For a quick token lookup, `Ctrl-F` the token name.

## Themes — critical

Pantheon ships **four themes** as columns in the Variables panel: `POS Light`, `POS Dark`, `Billing`, `Payroll`. POS Light / Billing / Payroll are visually identical (same values); POS Dark flips Gray and applies a separate Purple ramp. **Never hardcode a gray hex — always use the semantic token** (`Text/Primary`, `Surface/Secondary`, etc.) so the theme swap resolves correctly. See "Cross-collection gotchas" for the full theme-divergence list.

## Semantic color tokens

Pantheon ships four parallel scales for every role: **Surface** (fills), **Text**, **Icon**, **Border** — always pair them.

### Surface
| Token | Hex | First referenced on |
|---|---|---|
| `Surface/Primary` | `Gray-0` (Light `#FFFFFF`, Dark `#0E0E19`) | Cover |
| `Surface/Secondary` | `Gray-100` (Light `#FAFAFA`, Dark `#13131E`) | Cards |
| `Surface/Tertiary` | `Gray-300` (Light `#F0F0F0`, Dark `#1B1B2A`) | Bottom Sheets |
| `Surface/Brand` | `Primary-100` `#E0F7FA` | Dropdown |
| `Surface/Brand Secondary` | `Secondary-100` `#F0E3E5` | Tooltip |
| `Surface/Error` | `Error-100` `#FBEAE9` | Tooltip |
| `Surface/Warning` | `Warning-100` (Light `#FFFAE9`, Dark `#FFFAE9`) | Tooltip |
| `Surface/Success` | `Success-100` `#EEFFF5` | Tooltip |
| `Surface/Disabled` | `Gray-200` | Button disabled |
| `Surface/Accent-Aqua` | `Aqua-200` `#D8F3F9` | Table |
| `Surface/Accent-Beige` | `Beige-200` `#FDF5EA` | — |
| `Surface/Accent-Green` | `Green-200` `#CAF2D5` | — |
| `Surface/Accent-Navy Blue` | `Navy Blue-200` `#D7E6FF` | Cover |
| `Surface/Accent-Orange` | `Orange-200` `#FEE4D2` | — |
| `Surface/Accent-Pink` | `Pink-200` `#FED3EF` | — |
| `Surface/Accent-Purple` | `Purple-100` `#F0E2FB` (Dark `#F5EBFB`) | — |
| `Surface/Accent-Yellow` | `Yellow-200` `#FEF5D3` | — |

#### Surface State (interactive overlays)
| Token | Hex (with alpha) |
|---|---|
| `Surface State/Tertiary/Opacity-08` | `#cccccc14` |
| `Surface State/Secondary/Opacity-08` | `#3a84ec14` |
| `Surface State/Black/Opacity-08` | `#00000014` |
| `Surface State/Black/Opacity-10` | `#0000001a` |
| `Surface State/Black/Opacity-16` | `#00000029` |

### Text
| Token | Resolves to | Notes |
|---|---|---|
| `Text/Primary` | `Gray-1000` (Light `#000000`, Dark `#FFFFFF`) | Body, headings |
| `Text/Secondary` | `Gray-700` (Light `#666666`, Dark `#5A5A61`) | Subtext |
| `Text/Tertiary` | `Gray-600` in Light/Billing/Payroll, `Gray-800` in POS Dark | Tertiary subtext |
| `Text/Invert` | `Gray-0` (always inverse of primary) | Text on colored/dark fills |
| `Text/Brand` | `Primary-500` `#1770ee` | Petpooja blue |
| `Text/Brand Secondary` | `Secondary-500` | — |
| `Text/Error` | `Error-500` `#D92D20` | |
| `Text/Warning` | `Warning-700` `#64520E` | |
| `Text/Success` | `Success-800` `#10542E` | (was Success-600 in older extract — Figma shows Success-800) |
| `Text/Disabled` | `Gray-600` (`#999999`) | collision with Tertiary in Light; see gotchas |
| `Text/Accent-Aqua` | `Aqua-500` · `Text/Accent-Aqua-Dark` → `Aqua-700` | |
| `Text/Accent-Beige` | `Beige-600` · `Text/Accent-Beige-Dark` → `Beige-800` | |
| `Text/Accent-Green` | `Green-600` · `Text/Accent-Green-Dark` → `Green-800` | |
| `Text/Accent-Navy Blue` | `Navy Blue-500` · `Text/Accent-Navy Blue-Dark` → `Navy Blue-700` | |
| `Text/Accent-Orange` | `Orange-500` · `Text/Accent-Orange-Dark` → `Orange-600` ⚠ | Orange-Dark is **-600** not **-700** — one-off |
| `Text/Accent-Pink` | `Pink-600` ⚠ · `Text/Accent-Pink-Dark` → `Pink-700` | Pink default is **-600** not **-500** — one-off |
| `Text/Accent-Purple` | `Purple-500` · `Text/Accent-Purple-Dark` → `Purple-700` | |
| `Text/Accent-Yellow` | `Yellow-500` · `Text/Accent-Yellow-Dark` → `Yellow-700` | |

### Icon
| Token | Hex |
|---|---|
| `Icon/Primary` | `#000000` |
| `Icon/Brand` | `#1770ee` |
| `Icon/Disabled` | `#999999` |
| `Icon/Invert` | `#ffffff` |
| `Icon/Success` | `#10542e` |
| `Icon/Error` | `#d92d20` |
| `Icon/Warning` | `#64520e` |

### Border
| Token | Resolves to |
|---|---|
| `Border/Primary` | `Gray-400` `#E5E5E5` |
| `Border/Secondary` | `Gray-300` (POS Dark: `Gray-500`) |
| `Border/Tertiary` | `Gray-200` |
| `Border/Strong` | `Gray-600` `#999999` |
| `Border/Brand` | `Primary-500` `#1770EE` |
| `Border/Brand Secondary` | `Secondary-500` |
| `Border/Disabled` | `Gray-500` `#CCCCCC` (POS Dark: `Gray-800`) |
| `Border/Error` | `Error-500` `#D92D20` |
| `Border/Warning` | `Warning-500` |
| `Border/Success` | `Success-800` (POS Dark: `Success-700`) |
| `Border/Accent-Aqua` | `Aqua-700` |
| `Border/Accent-Beige` | `Beige-800` |
| `Border/Accent-Green` | `Green-800` |
| `Border/Accent-Navy Blue` | `Navy Blue-700` |
| `Border/Accent-Orange` | `Orange-700` |
| `Border/Accent-Pink` | `Pink-600` |
| `Border/Accent-Purple` | `Purple-500` |
| `Border/Accent-Yellow` | `Yellow-700` |

### Buttons
| Token | Hex | Usage |
|---|---|---|
| `Buttons/Primary` | `#1770ee` | Primary CTA fill |
| `Buttons/Primary Pressed` | `#125abe` | Primary CTA active state |
| `Buttons/Tonal` | `#e8f1fd` | Tonal button fill |
| `Buttons/Tonal Pressed` | `#d1e2fc` | Tonal button active |
| `Buttons/Tertiary` | `#ffffff` | Outline/ghost fill |
| `Buttons/Disabled` | `#f5f5f5` | Disabled fill |

### Icon (accent variants — add to the core Icon table)
| Token | Resolves to |
|---|---|
| `Icon/Accent-Aqua` | `Aqua-500` · `Icon/Accent-Aqua-Dark` → `Aqua-700` |
| `Icon/Accent-Beige` | `Beige-600` · `Icon/Accent-Beige-Dark` → `Beige-800` |
| `Icon/Accent-Green` | `Green-600` · `Icon/Accent-Green-Dark` → `Green-800` |
| `Icon/Accent-Navy Blue` | `Navy Blue-500` · `Icon/Accent-Navy Blue-Dark` → `Navy Blue-700` |
| `Icon/Accent-Orange` | `Orange-500` · `Icon/Accent-Orange-Dark` → `Orange-600` ⚠ |
| `Icon/Accent-Pink` | `Pink-600` ⚠ · `Icon/Accent-Pink-Dark` → `Pink-700` |
| `Icon/Accent-Purple` | `Purple-500` · `Icon/Accent-Purple-Dark` → `Purple-700` |
| `Icon/Accent-Yellow` | `Yellow-500` · `Icon/Accent-Yellow-Dark` → `Yellow-700` |

### Notch / Accent (badge accents — uses the -500 step across all accents)
| Token | Resolves to |
|---|---|
| `Notch/Primary` | `Primary-500` `#1770EE` |
| `Notch/Secondary` | `Secondary-500` |
| `Notch/Accent-Aqua` | `Aqua-500` |
| `Notch/Accent-Beige` | `Beige-500` |
| `Notch/Accent-Green` | `Green-600` (one-off: -600 not -500) |
| `Notch/Accent-Navy Blue` | `Navy Blue-500` |
| `Notch/Accent-Orange` | `Orange-500` |
| `Notch/Accent-Pink` | `Pink-500` |
| `Notch/Accent-Purple` | `Purple-500` `#7E00D2` |
| `Notch/Accent-Yellow` | `Yellow-500` |

### Chips
Chips use the -200 "tonal" fill for accent variants and the -100/-200 steps for primary/secondary. Reference:

| Token | Resolves to |
|---|---|
| `Chips/Tonal` | `Primary-100` |
| `Chips/Tonal Pressed` | `Primary-200` |
| `Chips/Tonal Secondary` | `Secondary-100` |
| `Chips/Tonal Secondary Pressed` | `Secondary-200` |
| `Chips/Inverted` | `Gray-0` |
| `Chips/Success` | `Success-300` |
| `Chips/Disabled` | `Gray-200` |
| `Chips/Accent-Aqua` | `Aqua-200` |
| `Chips/Accent-Beige` | `Beige-200` |
| `Chips/Accent-Green` | `Green-200` |
| `Chips/Accent-Navy Blue` | `Navy Blue-200` |
| `Chips/Accent-Orange` | `Orange-200` |
| `Chips/Accent-Pink` | `Pink-200` |
| `Chips/Accent-Purple` | `Purple-100` |
| `Chips/Accent-Yellow` | `Yellow-200` |

### Card backgrounds
| Token | Resolves to |
|---|---|
| `Card/Background-Primary` | `Gray-0` (Light) / `Gray-100` (Dark) |
| `Card/Background-Secondary` | `Gray-100` (Light) / `Gray-200` (Dark) |
| `Card/Background-Tertiary` | `Gray-200` (Light) / `Gray-300` (Dark) |
| `Card/Accent-*` | `<accent>-200` across all accent families (Purple uses `-100`) |

## Primitive color ramps

Extracted directly from the swatch frames on the Colors page (`66:689`). Names below reflect what's rendered in Figma; the "Primary" and "Secondary" frames are ramp-level (not to be confused with the semantic `Surface/Primary` tokens).

### Primary (cyan — Pantheon's brand cyan ramp)
> Frame `97:173`. Note: in the semantic system, `Buttons/Primary` and `Text/Brand` use the brand blue `#1770ee` — this cyan ramp is the Atlas legacy "Primary" and is rarely the right choice for brand-aligned UI. Prefer the `Surface/Brand` family.

| Step | Hex |
|---|---|
| 100 | `#E0F7FA` |
| 200 | `#B2EBF2` |
| 300 | `#80DEEA` |
| 400 | `#26C6DA` |
| 500 | `#00BCD4` |
| 600 | `#00ACC1` |
| 700 | `#0097A7` |
| 800 | `#00838F` |
| 900 | `#006064` |

### Secondary (rose-brown neutral ramp)
Frame `96:172`.

| Step | Hex |
|---|---|
| 100 | `#F0E3E5` |
| 200 | `#E3D4D6` |
| 300 | `#D6C5C7` |
| 400 | `#C9B6B8` |
| 500 | `#BDA7A9` |
| 600 | `#B09D9F` |
| 700 | `#A49294` |
| 800 | `#978686` |
| 900 | `#8B7B7D` |

### Gray (neutral scale — 11 stops, theme-swapped in POS Dark)
Frame `97:260`. Variables panel confirms the correct step names are `Gray-0, Gray-100, Gray-200, ..., Gray-900, Gray-1000`.

**POS Light / Billing / Payroll use the normal ramp. POS Dark flips it** — Gray-0 becomes near-black (`#0E0E19`), Gray-1000 becomes white (`#FFFFFF`), and every step in between is remapped. This is why you must always use semantic tokens (`Text/Primary`, `Surface/Primary`, etc.) — they automatically resolve to the theme-correct gray.

| Step | Light / Billing / Payroll | POS Dark | Also mapped to |
|---|---|---|---|
| `Gray-0` | `#FFFFFF` | `#0E0E19` | `Surface/Primary`, `Text/Invert`, `Chips/Inverted` |
| `Gray-100` | `#FAFAFA` | `#13131E` | `Surface/Secondary` |
| `Gray-200` | `#F5F5F5` | `#181822` | `Surface/Disabled`, `Chips/Disabled` |
| `Gray-300` | `#F0F0F0` | `#1B1B2A` | `Surface/Tertiary`, `Border/Secondary` (Light) |
| `Gray-400` | `#E5E5E5` | `#1C1C27` | `Border/Primary` |
| `Gray-500` | `#CCCCCC` | `#21212B` | `Border/Disabled` (Light) |
| `Gray-600` | `#999999` | `#292932` | `Text/Tertiary`, `Text/Disabled`, `Icon/Disabled`, `Border/Strong` |
| `Gray-700` | `#666666` | `#5A5A61` | `Text/Secondary` |
| `Gray-800` | `#333333` | `#71727A` | `Text/Tertiary` (POS Dark), `Border/Disabled` (POS Dark) |
| `Gray-900` | `#1E1E1E` | `#F5F5F5` | — (mid-tone neutral) |
| `Gray-1000` | `#000000` | `#FFFFFF` | `Text/Primary`, `Icon/Primary` |

### Accent / Aqua
Frame `2027:404`. Uses the unusual `100–108` numbering (not `100–900`).

| Step | Hex |
|---|---|
| 100 | `#ECF9FC` |
| 101 | `#D8F3F9` |
| 102 | `#B1E7F2` |
| 103 | `#63CFE5` |
| 104 | `#3CC3DF` |
| 105 | `#309CB2` |
| 106 | `#247586` |
| 107 | `#184E59` |
| 108 | `#0C272D` |

### Accent / Yellow
Frame `2027:375`. **Identical ramp to `Warning` — the Warning status family reuses the Yellow values.**

| Step | Hex |
|---|---|
| 100 | `#FFFBEA` |
| 200 | `#FEF5D3` |
| 300 | `#FDEBA7` |
| 400 | `#FCD64F` |
| 500 | `#FBCC23` |
| 600 | `#C9A31C` |
| 700 | `#64520E` |
| 800 | `#322907` |
| 900 | `#191404` |

### Accent / Green
Frame `2051:734`.

| Step | Hex |
|---|---|
| 100 | `#E2F9E8` |
| 200 | `#CAF2D5` |
| 300 | `#9CE6AF` |
| 400 | `#3FCD64` |
| 500 | `#10C03E` |
| 600 | `#0D9A32` |
| 700 | `#0A7325` |
| 800 | `#064D19` |
| 900 | `#053A13` |

### Accent / Beige
Frame `2051:763`.

| Step | Hex |
|---|---|
| 100 | `#FEFAF5` |
| 200 | `#FDF5EA` |
| 300 | `#FCECD5` |
| 400 | `#F9D9AB` |
| 500 | `#F7CF96` |
| 600 | `#D8B179` |
| 700 | `#BA935D` |
| 800 | `#9B7640` |
| 900 | `#7D5824` |

### Accent / Navy Blue
Recovered from the Variables panel. No swatch frame on the Colors page. IDs `2817:2062`–`2817:2070`.

| Step | Hex |
|---|---|
| 100 | `#EBF2FF` |
| 200 | `#D7E6FF` |
| 300 | `#B0CDFF` |
| 400 | `#619AFF` |
| 500 | `#3981FF` |
| 600 | `#2E68CF` |
| 700 | `#173770` |
| 800 | `#112B58` |
| 900 | `#061228` |

### Accent / Orange
Recovered from the Variables panel. IDs `2815:2052`–`2817:2060`. **Note the one-off: `Text/Accent-Orange-Dark` maps to Orange-600, not Orange-700 like other dark accents.**

| Step | Hex |
|---|---|
| 100 | `#FFF2E8` |
| 200 | `#FEE4D2` |
| 300 | `#FECAA5` |
| 400 | `#FD954A` |
| 500 | `#FC7A1D` |
| 600 | `#CA6217` |
| 700 | `#65310C` |
| 800 | `#4C2509` |
| 900 | `#321806` |

### Accent / Pink
Recovered from the Variables panel. IDs `2817:2072`–`2817:2080`. **Note the one-off: `Text/Accent-Pink` maps to Pink-600, not Pink-500 like other accents.**

| Step | Hex |
|---|---|
| 100 | `#FFE9F7` |
| 200 | `#FED3EF` |
| 300 | `#FDA7DF` |
| 400 | `#FC4FBF` |
| 500 | `#FB23AF` |
| 600 | `#C91C8C` |
| 700 | `#640E46` |
| 800 | `#320723` |
| 900 | `#190412` |

### Accent / Purple — two theme variants
Recovered from the Variables panel. IDs `2288:685`–`2288:693`. **Purple is the only accent ramp that has a distinct POS Dark variant** (every other accent is identical across themes). If you're building for POS Dark specifically, use the Dark column values.

| Step | Light / Billing / Payroll | POS Dark |
|---|---|---|
| 100 | `#F0E2FB` | `#F5EBFB` |
| 200 | `#E4C9F6` | `#EAD6F8` |
| 300 | `#CA97ED` | `#D5ADF1` |
| 400 | `#B164E4` | `#AC5BE2` |
| 500 | `#7E00D2` | `#9732DB` |
| 600 | `#6500A8` | `#7928AF` |
| 700 | `#4C007E` | `#5B1E83` |
| 800 | `#320054` | `#3C1458` |
| 900 | `#19002A` | `#1E0A2C` |

### Status — Error (partial ramp; only 100/500/600 defined)
Frame `97:202`.

| Step | Hex |
|---|---|
| 100 | `#FBEAE9` |
| 500 | `#D92D20` (= `Text/Error`) |
| 600 | `#AE241A` |

### Status — Warning
Frame `97:238`. **Identical to Accent/Yellow.**

| Step | Hex |
|---|---|
| 100 | `#FFFAE9` |
| 200 | `#FEF5D3` |
| 300 | `#FDEBA7` |
| 400 | `#FCD64F` |
| 500 | `#FBCC23` |
| 600 | `#C9A31C` |
| 700 | `#64520E` |
| 800 | `#322907` |
| 900 | `#191404` |

### Status — Success
Frame `97:249`. Note: the swatch frame shows many duplicated `C5FEE4` placeholders in the middle steps (WIP), but the Variables collection resolves to the values below.

| Step | Hex |
|---|---|
| 100 | `#EEFFF5` |
| 200 | `#DCFFEB` |
| 300 | `#BAFFD8` |
| 400 | `#75FFB1` |
| 500 | `#52FF9D` |
| 600 | `#42D481` |
| 700 | `#217F4A` |
| 800 | `#10542E` (= `Icon/Success`) |
| 900 | `#002912` |

## Accent palette rule for charts & categorization

Pantheon's full accent palette is **eight families**: Aqua, Beige, Green, Navy Blue, Orange, Pink, Purple, Yellow. Every family has a full 100-900 ramp and matching `Surface/Text/Icon/Border/Card/Chips/Notch` semantic aliases.

**Categorical / chart default order** (warm-to-cool, visually distinguishable when adjacent): `Aqua → Green → Yellow → Orange → Pink → Purple → Navy Blue → Beige`. For any series that needs semantic grouping, prefer the ramps whose hue matches the meaning (Green for positive/go, Orange/Pink for attention, Navy Blue for informational, Purple for enterprise/premium).

**Saturation step convention:**
- Primary fills / Notch badges: `-500`
- Tonal backgrounds (Chips, Card accents): `-200` (Purple uses `-100`)
- Text/Icon on colored backgrounds: `-500` (except Pink → `-600`)
- Dark variant text/icon: `-700` (except Orange → `-600`)
- Borders: `-700` (except Pink → `-600`, Purple → `-500`, Green/Beige → `-800`)

If you need more than 8 series, **repeat the palette with the `-700` step instead of `-500`** — this doubles the palette size while keeping everything on-brand. Never introduce a hue outside these 8 families.

**Error / Warning / Success are not accents** — they carry semantic meaning (red/yellow/green = status) and must only be used for their respective status meanings. Never use Error-500 as a decorative red.

## Typography — Prometheus

Letter-spacing 0 on every style. Inter throughout (Pantheon names it `Static/Font/Font` = Inter).

### Composite font tokens (ready to use)
`Prometheus/<Family>/<Size>-<Weight>` where Family ∈ Display / Title / Body / Label; Size ∈ Large / Medium / Small; Weight ∈ Regular / Medium / SemiBold / Bold. Labels only use Medium and SemiBold.

| Token | Font / Size / Line height / Weight |
|---|---|
| `Prometheus/Display/Large-Regular` | Inter 32 / 40 / 400 |
| `Prometheus/Display/Large-Medium` | Inter 32 / 40 / 500 |
| `Prometheus/Display/Large-SemiBold` | Inter 32 / 40 / 600 |
| `Prometheus/Display/Large-Bold` | Inter 32 / 40 / 700 |
| `Prometheus/Display/Medium-Regular` | Inter 24 / 32 / 400 |
| `Prometheus/Display/Medium-Medium` | Inter 24 / 32 / 500 |
| `Prometheus/Display/Medium-SemiBold` | Inter 24 / 32 / 600 |
| `Prometheus/Display/Medium-Bold` | Inter 24 / 32 / 700 |
| `Prometheus/Display/Small-Regular` | Inter 20 / 28 / 400 |
| `Prometheus/Display/Small-Medium` | Inter 20 / 28 / 500 |
| `Prometheus/Display/Small-SemiBold` | Inter 20 / 28 / 600 |
| `Prometheus/Display/Small-Bold` | Inter 20 / 28 / 700 |
| `Prometheus/Title/Large-Regular` | Inter 18 / 26 / 400 |
| `Prometheus/Title/Large-Medium` | Inter 18 / 26 / 500 |
| `Prometheus/Title/Large-SemiBold` | Inter 18 / 26 / 600 |
| `Prometheus/Title/Large-Bold` | Inter 18 / 26 / 700 |
| `Prometheus/Title/Medium-Regular` | Inter 16 / 24 / 400 |
| `Prometheus/Title/Medium-Medium` | Inter 16 / 24 / 500 |
| `Prometheus/Title/Medium-SemiBold` | Inter 16 / 24 / 600 |
| `Prometheus/Title/Medium-Bold` | Inter 16 / 24 / 700 |
| `Prometheus/Title/Small-Regular` | Inter 14 / 22 / 400 |
| `Prometheus/Title/Small-Medium` | Inter 14 / 22 / 500 |
| `Prometheus/Title/Small-SemiBold` | Inter 14 / 22 / 600 |
| `Prometheus/Title/Small-Bold` | Inter 14 / 22 / 700 |
| `Prometheus/Body/Large-Regular` | Inter 16 / 24 / 400 |
| `Prometheus/Body/Large-Medium` | Inter 16 / 24 / 500 |
| `Prometheus/Body/Large-SemiBold` | Inter 16 / 24 / 600 |
| `Prometheus/Body/Large-Bold` | Inter 16 / 24 / 700 |
| `Prometheus/Body/Medium-Regular` | Inter 14 / 22 / 400 |
| `Prometheus/Body/Medium-Medium` | Inter 14 / 22 / 500 |
| `Prometheus/Body/Medium-SemiBold` | Inter 14 / 22 / 600 |
| `Prometheus/Body/Medium-Bold` | Inter 14 / 22 / 700 |
| `Prometheus/Body/Small-Regular` | Inter 12 / 20 / 400 |
| `Prometheus/Body/Small-Medium` | Inter 12 / 20 / 500 |
| `Prometheus/Body/Small-SemiBold` | Inter 12 / 20 / 600 |
| `Prometheus/Body/Small-Bold` | Inter 12 / 20 / 700 |
| `Prometheus/Label/Large-Medium` | Inter 14 / 22 / 500 |
| `Prometheus/Label/Large-SemiBold` | Inter 14 / 22 / 600 |
| `Prometheus/Label/Medium-Medium` | Inter 12 / 20 / 500 |
| `Prometheus/Label/Medium-SemiBold` | Inter 12 / 20 / 600 |
| `Prometheus/Label/Small-Medium` | Inter 10 / 18 / 500 |
| `Prometheus/Label/Small-SemiBold` | Inter 10 / 18 / 600 |

### Typography primitives
Backing variables the composites compose from — usually you don't touch these directly.

| Primitive | Value |
|---|---|
| `Static/Font/Font` | Inter |
| `Static/Weight/Regular` | Regular (400) |
| `Static/Weight/Medium` | Medium (500) |
| `Static/Weight/Semi Bold` | Semi Bold (600) |
| `Static/Weight/Bold` | Bold (700) |
| `Display Large/Size` | 32 · `/Line Height` 40 |
| `Display Medium/Size` | 24 · `/Line Height` 32 |
| `Display Small/Size` | 20 · `/Line Height` 28 |
| `Title Large/Size` | 18 · `/Line Height` 26 |
| `Title Medium/Size` | 16 · `/Line Height` 24 |
| `Title Small/Size` | 14 · `/Line Height` 22 |
| `Body Large/Size` | 16 · `/Line Height` 24 |
| `Body Medium/Size` | 14 · `/Line Height` 22 |
| `Body Small/Size` | 12 · `/Line Height` 20 |
| `Label Large/Size` | 14 · `/Line Height` 22 |
| `Label Medium/Size` | 12 · `/Line Height` 20 |
| `Label Small/Size` | 10 · `/Line Height` 18 |

## Sizing / Radius / Elevation

### Width (icon / affordance scale)
| Token | Value |
|---|---|
| `X Small/Width` | 16 |
| `X Small/Height` | 16 |
| `Small/Width` | 18 |
| `Medium/Width` | 20 |
| `Large/Width` | 24 |

### Corner radius
| Token | Value | Use for |
|---|---|---|
| `Square/Small` | 8 | Chips, small buttons, text inputs |
| `Square/Medium` | 10 | Cards, most buttons |
| `Square/Large` | 12 | Modals, bottom sheets, major surfaces |
| `Round/Rounded` | 200 | Pill buttons, fully rounded avatars/chips |

### Button heights
From the Buttons component set's `Size` axis (not exposed as named variables):
- Extra Small: 32
- Small: 36
- Medium: 40
- Large: 48

### Spacing
Pantheon does **not** ship a named spacing token collection. Padding and gaps inside components are hardcoded on the 8-pt grid: 4, 8, 12, 16, 20, 24, 32, 48, 64. When composing layouts, stick to this grid — don't invent 13px or 17px gaps.

### Elevation
| Token | Value |
|---|---|
| `Elevation/3` | `0 1px 3px 0 rgba(0,0,0,0.30)` + `0 4px 8px 3px rgba(0,0,0,0.15)` |

Pantheon uses elevation sparingly — `Elevation/3` is the only named shadow (used on Pop Up). For cards and surfaces, prefer a 1px `Border/Primary` over a drop shadow. Never invent a custom shadow.

## Cross-collection gotchas

1. **POS Dark swaps the Gray ramp**. POS Dark is not just "inverted" via semantic tokens — the underlying Gray primitive ramp has **different hex values per step** in POS Dark vs. the other three themes. Gray-0 flips from white to near-black, Gray-1000 flips from black to white, and every step between is remapped. **Always use semantic tokens for grays** (`Text/Primary`, `Surface/Primary`, `Border/*`) — they resolve correctly per theme. If you hardcode `#999999` you'll break POS Dark silently.
2. **Purple has a distinct POS Dark variant** — the only accent ramp that does. If you're designing specifically for POS Dark, consult the Purple table's Dark column. For everything else (Aqua, Beige, Green, Navy Blue, Orange, Pink, Yellow), the ramp is identical across all four themes.
3. **One-off semantic mappings that break the "-500 primary / -700 dark" pattern:**
   - `Text/Accent-Pink` and `Icon/Accent-Pink` → Pink-**600** (not -500)
   - `Text/Accent-Orange-Dark` and `Icon/Accent-Orange-Dark` → Orange-**600** (not -700)
   - `Notch/Accent-Green` → Green-**600** (not -500)
   - `Border/Accent-Purple` → Purple-**500** (not -700)
   - `Border/Accent-Green`, `Border/Accent-Beige` → **-800** (not -700)
   When in doubt, look up the semantic token rather than deriving from the ramp step convention.
4. **Some POS Dark semantic tokens diverge:** `Text/Tertiary` resolves to Gray-600 in Light but Gray-800 in POS Dark. `Border/Secondary` and `Border/Disabled` also shift one step darker in POS Dark. Use the semantic name — don't read it off Light and assume Dark matches.
5. **`Text/Disabled` = `Text/Tertiary`** both resolve to `Gray-600` in Light (`#999999`). Keep the semantic distinction in code; visually they render identically today but may diverge later.
6. **Aqua uses 100-108 labels in the swatch frame**, but the Variables panel confirms the canonical names are `Aqua-100` through `Aqua-900`. Treat them as 100–900; the 100–108 labels are a Figma display artifact.
7. **Warning ramp ≈ Yellow ramp** — step 200 onward is byte-identical. Warning-100 differs from Yellow-100 by one hex unit (`#FFFAE9` vs `#FFFBEA`). They are effectively aliases.
8. **Success had placeholder swatches in earlier extractions** — the correct values are the full 9-step ramp listed above (`EEFFF5 → 002912`), not the `C5FEE4`-repeated placeholders the Colors page showed in the old Figma render.
9. **Error ramp is intentionally short** (only 100/500/600). If you need an intermediate Error shade, either generate it from the existing steps or flag the gap — don't invent one.
10. **Legacy `var(--sds-*)` tokens** appear on the Colors page (copied from the Figma community "Simple Design System" kit). Ignore them; not part of Pantheon.
11. **`Colors/Surface/Black (Text & icons)`** on the Pop Up page is a legacy namespace — migrate mental references to `Text/Primary`.
12. **The Internal Only Canvas is a hidden library** containing 404 token definitions that don't surface via `get_variable_defs` because no visible node references them. For any future token that isn't in this file, open the Figma Variables panel directly (Pink/Purple/Orange/Navy Blue ramps live only there — they have no swatch frames).

## Per-page token reference count

How many unique tokens each page actually references. Useful for knowing which pages to query live if a token goes missing from this file.

| Page | Node id | Unique tokens |
|---|---|---|
| Typography | `66:686` | 66 |
| Buttons | `36:1881` | 46 |
| Colors | `66:689` | 42 |
| Text Input | `66:685` | 32 |
| Chips | `57:165` | 31 |
| Side Drawer | `2400:18` | 30 |
| Table | `2436:798` | 26 |
| Tabs | `47:626` | 25 |
| Bottom Sheets | `66:687` | 24 |
| Cards | `2:113` | 22 |
| Dropdown | `2768:141` | 19 |
| List | `3461:3` | 17 |
| Tooltip | `2380:1293` | 17 |
| Pop Up | `66:688` | 15 |
| Icons | `2884:15439` | 11 |
| Switch | `2382:278` | 9 |
| Badges | `50:222` | 7 |
| Checkbox | `2331:76` | 4 |
| Radio Buttons | `2381:1299` | 4 |
| Cover | `126:26` | 3 |
| Internal Only Canvas | `0:2` | 0 (hidden) |
| Date Picker | `3980:641` | 0 (empty) |
| — (separator) | `126:27` | 0 (empty) |
