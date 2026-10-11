# Handoff: the rest of Lane A, and all of Lane B

**STATUS:** CURRENT. Written 2026-10-11 to be executed by a session that was not here.

**Read first:** `docs/product/FIGURE_PRODUCTION_PROTOCOL.md` (v1.4) — it governs. Then
`LANE_A_COMPLETE_2026_10_11.md` and `LANE_A_STATISTICS_BATCH_2026_10_11.md` for what the last two
batches did and what they cost. This document adds only what those do not say: **the gap Lane A's own
scope left behind, the labelling problems underneath it, and an execution plan for Lane B.**

**Toolchain:** `scripts/lane-a-pilot/` — `render.py` (13 families), `verify.py` (1,241 checks),
`ced_check.py` (two-reader gate), `build_load_sql.py` (loader generator), `specs.json` (26 figures).
The app's renderer is `src/lib/figures/render.ts` in `david-bloom/ap-prep-blueprint`, kept at
**byte-for-byte parity** with the Python.

---

## 1. Where things actually stand

**Live in Production** (`APPROVAL-0153`, `0157`, `0158`): 25 figures, 13 renderer families, 25 uses,
identical in Development. Every published `kind='diagram'` entry that is Lane A has a figure.

| Subject | `diagram` entries | With a figure | Without (all Lane B) |
|---|---:|---:|---:|
| AP Statistics | 7 | 7 | 0 |
| AP Chemistry | 15 | 9 | 6 |
| AP Physics 2 | 6 | 3 | 3 |
| AP Physics C: Mechanics | 3 | 1 | 2 |
| AP Physics 1 | 2 | 0 | 2 |
| AP Physics C: E&M | 1 | 0 | 1 |
| AP Biology | 4 | 0 | 4 |
| **Total** | **38** | **20** | **18** |

Calculus AB, Calculus BC and Precalculus have **no** `diagram` entries at all. Precalculus nonetheless
has a Lane A figure, on a `vocabulary` entry — which is the whole subject of §2.

**Not visible to any student yet.** The client keeps a whitelist of figure families and silently drops
the rest; the seven new families are merged in `ap-prep-blueprint` (#6, #10) but **publishing in Lovable
is a separate step that has not happened**. Until it does, only AP Chemistry's ten figures can appear.
Confirm before assuming otherwise: Lovable `latest_commit_sha` should match the app repo's `main`, and
then a signed-in look at an AP Statistics topic.

## 2. The gap: Lane A was scoped to the wrong column

Lane A was defined as *the `kind='diagram'` entries*. That filter is not the concept. Chart-shaped
content is spread across `vocabulary`, `convention`, `formula` and `list_sequence` entries, and the
only reason one of them has a figure is that AP Precalculus' **"Residual plot"** happened to be listed
by title in the 2026-10-10 assessment. Nothing systematic found it.

A keyword scan of non-diagram published entries (title or body matching plot/graph/chart/curve/
histogram/distribution/spectrum/scatter, or "plotted against", "on the horizontal axis", "graph of")
returns **~24 candidates**. This is a lead list, not a classification: **run protocol §2 over it** before
building anything.

### 2a. Needs no new renderer family — the cheapest work in the lane

| Subject · topic | Entry (kind) | Family | Note |
|---|---|---|---|
| Physics 1 · 1.3 | Slope and area relationships on motion graphs (`list_sequence`, 4 items) | `kinematic_panels` | **The figure already exists**: `physcmech-xva-graphs`. Its 4 authored labels are the same relationships. |
| Physics C Mech · 1.3 | Displacement from area under v–t graph (`formula`) | `kinematic_panels` | Same existing figure; add a use. |
| Physics C Mech · 1.3 | Change in velocity from area under a–t graph (`formula`) | `kinematic_panels` | Same existing figure; add a use. |
| Physics 1 · 3.2 | Work from a force-displacement graph (`convention`) | `xy_series` | Shaded area under F∥(x); one new figure, shareable with the next row. |
| Physics C Mech · 3.2 | Work as area under an F∥ vs. displacement graph (`convention`) | `xy_series` | Same figure as above — see §3.3 on cross-subject sharing. |
| Physics 2 · 9.2 | Zero-pressure temperature from a P–T graph (`convention`) | `xy_series` | Straight line extrapolated to P = 0. |
| Physics 2 · 11.3 | Ohmic materials and the I–ΔV graph (`convention`) | `xy_series` | Ohmic straight line vs a non-ohmic curve. |

**Three of these cost nothing but a `figure_uses` row** — the many-to-many join exists precisely for
this, and `usedBy` is already a list in the payload.

### 2b. Small extensions of an existing family

| Subject · topic | Entry | Family |
|---|---|---|
| Chemistry · 8.5 | Polyprotic acid titration curves (`list_sequence`, 3 items) | `titration_curve` + a second equivalence point |
| Chemistry · 5.3 | Linear plot that identifies reaction order (`list_sequence`, 3 items) | `xy_series`, three linearised panels ([A], ln[A], 1/[A] vs t) |
| Precalculus · 2.15 | Semi-log plot (`vocabulary`) and "Using a semi-log plot to justify an exponential model" (`convention`) | `xy_series` with a log y axis |

### 2c. One new family, high value

AP Statistics 2.11 **"Probability as area under the normal curve"** (`convention`), plus **"Normal
distribution"** and **"Standard normal distribution"** (`vocabulary`), and 3.14 **"Shape of chi-square
distributions"** (`convention`). A `density_curve` family — bell curve with a shaded interval, and a
skewed family by degrees of freedom — covers four entries and is the most-used idea in the subject.

### 2d. Classify before believing

Sampling/randomization distributions (Statistics 2.12), cumulative probability distribution (2.8),
polar graphs, concavity of sinusoids, reciprocal-trig graph features, "Graphs can miss important
behavior" (Calculus AB 1.3) — all *sound* like charts. Several are probably Lane A function plots
needing a `function_plot` family; some are prose about graphs rather than a graph. **Do not skip §2.**

### 2e. A possible home for the orphan

`chem-mb-catalysis` has drawn correctly since the pilot but has no published entry, so it is not
production-eligible. **AP Chemistry 3.5 "Maxwell-Boltzmann distribution" (`vocabulary`, 0 items)** is a
plausible home. Check it against the entry's body before attaching; the protocol's §9 note stands until
someone does.

## 3. Labelling issues, with the evidence

These are the reasons the work above is not simply "more figures". Each needs a decision, not just
typing.

### 3.1 `kind` does not mean what Lane A assumed

`kind='diagram'` labels *what the entry is about*, not *whether it is drawable*. "Residual plot" is
`vocabulary`; "Work from a force-displacement graph" is `convention`; "Displacement from area under v–t
graph" is `formula`. **Recommendation:** stop using `kind` as the lane filter. Classify on the content —
"is this a chart drawn from data or a function?" — and record the verdict somewhere durable, because
the next session will otherwise re-derive it. A `lane` column on the entry, or a lane column in the
classification doc, both work; the doc is cheaper and needs no migration.

### 3.2 Most Lane A candidates have no `items[]`

Of the ~24 candidates, **19 have zero authored labelled parts.** The coverage gate (§4a) checks a
figure's `covers` against the entry's `items[]`, so for those entries it asserts nothing — `verify.py`
prints a note saying so rather than passing silently, which is the honest behaviour but not a
substitute for a contract.

Two routes, and the protocol does not yet choose between them:

- **(a) Author `items[]` first**, through the reference-pack pipeline with its checkers. Defensible,
  slower, and keeps new teaching content inside the gates that own it.
- **(b) Let the figure's own `labels` carry the parts.** The data model supports it ("labels live on
  the figure, not the entry") and the residual plot was built this way.

**The risk with (b), stated plainly: the figures table is a side door into the corpus that the
reference-pack checkers do not watch.** The residual plot mitigated it by going through the two-reader
figure gate with the entry's body in the prompt. That is weaker than the content pipeline. **Someone
should rule on this once**, because it governs ~19 entries and not just one.

### 3.3 Cross-subject near-duplicate entries

Three concepts are authored twice, in sibling subjects, with drifting titles and labels:

| Concept | Entry A | Entry B | Labels |
|---|---|---|---|
| Vector arrows | Physics 1 · 1.1 | Physics C Mech · 1.1 | **identical** (Arrow direction, Arrow length) |
| Free-body diagram | Physics 1 · 2.2 "Free-body diagram (FBD)", 5 labels | Physics C Mech · 2.2 "Free-body diagram", 4 labels | B's four are a **subset** of A's five |
| Electric field map | Physics 2 · 10.3, 3 labels (Field vector, Field line, Source charges) | Physics C E&M · 8.3, 2 labels (Field map vectors, Field lines) | **same idea, different wording** |

**One figure can serve both entries.** Verified in the live RPC: the `figures` key filters only on
`f.status = 'published'` and the existence of a use pointing at an entry in this payload — **it does not
filter on `f.subject_key`**. So a figure authored under one subject renders for the other, and the
figure's own `subject_key` is effectively provenance.

Consequence: **Lane B is 15 figures for 18 entries, not 18.** The third row needs care — coverage
matches label strings exactly, so a shared figure must list *both* wordings in its `covers`.

**The deeper issue** is that the same concept is authored twice and already drifting. `TASK-0070` solved
exactly this for Calculus AB/BC with `app.subject_reference_aliases`, but these are different subject
pairs and the entries are not identical. Worth a decision: alias, normalise, or accept the duplication
and share the figure.

### 3.4 `visual_asset_ref` is still unused and still reserved

All 18 Lane B entries have `visual_asset_ref IS NULL`. The column was reserved for Lane B on the
assumption Lane B means a stored asset. §4 argues most of Lane B is not that.

## 4. Lane B: an execution plan

**18 entries, 15 distinct figures, three sub-kinds.** The protocol's §9 already says the cheapest real
start is the constrained grammars, not the commissioned art — and that TASK-0006 §10's proposal of
phylogenetic trees serves nothing, because the corpus contains none.

### 4.1 Constrained grammar — arrows (4 entries, 2 figures)

| Entry | Labels |
|---|---|
| Physics 1 · 1.1 and Physics C Mech · 1.1 — Vector arrow representation | Arrow direction; Arrow length |
| Physics 1 · 2.2 and Physics C Mech · 2.2 — Free-body diagram | Dot; Force arrows; Same-direction forces; Whole forces only; Coordinate axis |

A tiny grammar: arrows from an origin with magnitude, direction and a label, plus a dot and optional
axes. **Family `arrow_diagram`.** Properties to assert: arrow length is proportional to magnitude and
the proportion is the same for every arrow; the angle drawn equals the angle specified; for an FBD,
every force is a **whole** force (no components drawn alongside their resultant — the entry's own
"Whole forces only" label), all arrows originate at the dot, and if the body is in equilibrium the
vector sum is zero. That last one is the kind of thing a wrong figure violates silently.

### 4.2 Constrained grammar — particulate boxes (5 entries, 5 figures)

Chemistry 3.3 solid/liquid/gas; 3.8 solution; 4.3 balanced equation; 7.8 reversible reaction; 2.4
sea-of-electrons. Coloured circles in a box, with counts, spacing and arrangement. **Family
`particulate_box`.** Properties: atom conservation across a balanced-equation panel (count each species
either side — this is the entry's own labelled part and is exactly machine-checkable); solid/liquid
comparable molar volume with gas far sparser; the reversible-reaction panels' particle counts
reproducing the stated K; solute:solvent ratio matching the stated concentration.

### 4.3 Constrained grammar — circuits and fields (4 entries, 3 figures)

Physics 2 11.2 circuit schematic symbols (8 labels — a symbol library, effectively a legend sheet);
Physics 2 10.3 + Physics C E&M 8.3 field map (shared); Physics 2 10.5 equipotential map. **Families
`circuit_symbols` and `field_map`.** Field-map properties: field lines never cross; lines begin on
positive and end on negative charge; density scales with magnitude; **equipotentials cross field lines
at right angles** and no work is done along one (the entry's "Field along an isoline" label).

### 4.4 Genuinely commissioned or licensed (4 entries, 4 figures)

The AP Biology four: DNA double helix, fluid mosaic membrane, chloroplast, mitochondrion. These are
anatomical drawings; a spec-driven renderer is the wrong tool. **This is the only part of Lane B that
needs a decision about cost, licensing and where the asset lives** — and the only part
`visual_asset_ref` was reserved for. Options: commission, license, or build a crude labelled schematic
and accept it is not art. **Do not start here.**

### 4.5 Suggested order

1. `arrow_diagram` — 4 entries, 2 figures, the smallest grammar, and it unblocks the Physics 1 entries
   that currently have nothing at all.
2. `particulate_box` — 5 entries, best property tests in the lane (atom conservation).
3. `field_map` + `circuit_symbols` — 4 entries, 3 figures.
4. Biology — only after a decision on §4.4.

Running §2's cheap reuse cases (§2a) *before* any of this is defensible: three of them cost one row.

## 5. How to run it

```bash
# 1. Build. Author specs in scripts/lane-a-pilot/specs.json; add families to render.py.
python3 -I scripts/lane-a-pilot/verify.py            # gate 4a: must be 0 failed

# 2. Look at it, at the real widths. Gate 4b is not optional and finds what 4a cannot.
#    Every batch so far has found defects here that a green suite missed.

# 3. Two non-Anthropic readers, five planted controls, >=3 passing the suite cleanly.
python3 -I scripts/lane-a-pilot/ced_check.py --prefix "<id-prefix>," --controls <set>
#    Needs scripts/vercel-gateway-check/.env.local — in a worktree, SYMLINK it from the
#    main checkout, never paste the key. About $0.02 a figure.

# 4. Generate the loader and apply to Development.
python3 -I scripts/lane-a-pilot/build_load_sql.py --prefix "<prefix>," \
    --batch <name> --out out/load_<name>.sql
supabase db query --linked --workdir /Users/davidbloom/Documents/Cramapple.nosync \
    -f "$PWD/scripts/lane-a-pilot/out/load_<name>.sql"

# 5. Production is a HARD GATE. Approval naming the batch first. Then:
supabase db query --linked --workdir /Users/davidbloom --debug -f "<absolute path>"
#    --workdir /Users/davidbloom is PRODUCTION. Confirm the ref in the --debug line
#    BEFORE the write, and pass an ABSOLUTE path: -f resolves against --workdir.

# 6. The app must learn any new family or it renders nothing (see §6).
```

## 6. The trap that has already cost this lane once

**A figure whose family the client does not know is silently dropped.** `FIGURE_FAMILIES` in
`src/lib/topic-content.ts` is a whitelist and `mapFigure` returns `null` for anything else. Nine AP
Statistics figures sat in Production invisible for exactly this reason. **Any new family needs the app
changed in the same breath as the database**, and the app change is not done until Lovable is published.

Port new families to `src/lib/figures/render.ts` and prove the port by **parity, not inspection**: render
every new figure at all three layouts in both renderers and diff. The Python and TypeScript agreed
45/45 on the last batch only after four formatting differences were found that way.

## 7. Open decisions for the Product Owner

1. **§3.2** — may a figure's own `labels` stand in for a missing `items[]`, or must the entry be
   authored first? Governs ~19 entries.
2. **§3.3** — alias, normalise, or accept the three cross-subject duplicate entries?
3. **§4.4** — commission, license, or schematic for the four AP Biology structures?
4. **§2e** — is Chemistry 3.5 the home for `chem-mb-catalysis`?
5. Standing, from the pilot: **no human subject expert has reviewed any batch's illustrative values.**

## 8. Do not touch

- `chem-mb-catalysis` stays out of Production until an entry exists for it (§2e).
- The AP Chemistry loaders in `scripts/content-seed/ap-chemistry-reference-u2-u3-2026-10-10/` are
  **behind** Production, because `APPROVAL-0149` re-extracted symbol definitions afterwards. Do not
  "repair" Production from them.
- `load_ap_calculus_bc_u1_u3_rekey.sql` is the superseded copy-rows approach; `TASK-0070` replaced it
  with aliasing. Never apply it.
- Do not change `render.py`'s number formatting without re-running the parity check: the two renderers
  agree only because the tie-rounding and float-formatting rules were matched deliberately.
