# Session close: every `kind='diagram'` entry now has a figure, and one batch is still waiting

**STATUS:** CURRENT, 2026-10-12. **Governed by:** `FIGURE_PRODUCTION_PROTOCOL.md` v1.9.
**Continues:** `SESSION_CLOSE_2026_10_11_LANE_A_GAPS_AND_LANE_B.md`, which stops before
`density_curve` and covers neither `function_plot` nor the five Lane B gaps.

**The headline:** the count of published `kind='diagram'` reference entries with no figure went
**5 → 0 in Production**. That number was 41 when this programme started.

**The thing not to lose:** `function_plot` — 19 figures over 15 entries — is built, gated, ported,
merged and **sitting in Development only**. It is the entire current difference between the two
environments, and it is why **AP Precalculus and AP Calculus AB still have no figure in
Production**. See §8.

| | Development | Production |
|---|---:|---:|
| published figures | 73 | **54** |
| renderer families | 23 | **22** |
| uses | 81 | **62** |
| entries covered | 71 | **56** |
| `kind='diagram'` entries with no figure | 0 | **0** |

The difference is exactly `function_plot`. Every figure that *is* in Production is drawn by a
renderer costing nothing at serve time, and was verified reaching a real authenticated student.

## 1. What shipped in this stretch

| Batch | Figures | New families | Approval | State |
|---|---:|---|---|---|
| AP Statistics `density_curve` | 10 | `density_curve` | `APPROVAL-0160` | **Live in Production** |
| Precalculus / Calculus AB `function_plot` | 19 | `function_plot` | — | **Development only** |
| **Lane B gaps** | **5** | `organelle`, `dna_ladder`, `membrane_bilayer`, `electrochemical_cell` | **`APPROVAL-0162`** | **Live in Production** |

`function_plot` would give AP Precalculus and AP Calculus AB their first figures of any kind — once
it is loaded. It never was. This was asserted as live in the first draft of this document and
corrected by querying `app.figures` per family in both environments rather than trusting the claim.

### The five Lane B gaps, and the §4.4 decision behind them

| Subject · topic | Entry | Figure | Family |
|---|---|---|---|
| AP Biology 1.6 | Antiparallel DNA double helix | `bio-dna-antiparallel` | `dna_ladder` |
| AP Biology 2.3 | Fluid mosaic model of the plasma membrane | `bio-fluid-mosaic` | `membrane_bilayer` |
| AP Biology 3.4 | Chloroplast structure | `bio-chloroplast` | `organelle` |
| AP Biology 3.5 | Mitochondrion: regions and functions | `bio-mitochondrion` | `organelle` |
| AP Chemistry 9.8 | Electrochemical cell diagram | `chem-electrochemical-cell` | `electrochemical_cell` |

These five had been held back as the ones that might need commissioned artwork. The Product
Owner's ruling was **"build it properly"**, and the design that answers it is the most reusable
thing in this session:

> **Make the family derive what it asserts, so the wrong picture is unrepresentable.**

- The DNA spec names **one** strand. The partner base comes from the pairing rule and the
  hydrogen-bond count from the pair (two for A–T, three for C–G), so a mispaired base cannot be
  drawn. A single orientation flag sets **both** arrowheads, so the strands cannot be made parallel.
- Each membrane inclusion's geometry follows from its **kind**. A protein always crosses both
  leaflets; a steroid always sits among the tails and reaches neither surface; every carbohydrate
  chain lands on the extracellular face. The spec chooses the kind and the x position, never the y.
- Every arrow in the cell follows from **which side the anode is on** — electrons out of the anode,
  cations to the cathode, anions to the anode — so no two arrows can disagree.

## 2. The consequence of that design, which is now protocol §4c

A family that cannot draw a wrong picture leaves the property tests with almost nothing to catch.
**All the remaining risk moves into the words**, and a geometry control is one the renderer simply
refuses to draw, so it tests nothing. The controls for such a batch must be **text controls**:

| Control | Defeats the suite? | What it does |
|---|---|---|
| G1 strands called parallel | no — caught | denies the entry's second item |
| G2 proton gradient reversed | **yes** | runs ATP synthase backwards |
| G3 sugars on the cytoplasmic face | **yes** | contradicts the drawing |
| G4 anode label left on the cathode | **yes** | every arrow consistent, every label wrong |
| G5 granum drawn as one disc | no — caught | denies that a granum is a stack |

Result: **5/5 controls rejected, 5/5 figures accepted by both non-Anthropic readers.**

## 3. What each gate actually caught, which is the argument for keeping all three

**§4a property tests — 3,848 checks, 0 failed.** Caught the things nobody eyeballs: that the
hydrogen bonds sit in the gap *between* the two bases, that no two rungs overlap, that the salt
bridge's ends are below both solution surfaces and touch neither electrode, that the electron arrow
runs anode → cathode.

**§4b the eye — four real defects, none of them visible to any test:**

1. A label laid straight **across the hydrogen bonds it named**, hiding the only visible difference
   between A–T and C–G. Now a test: no label may sit in the bond band.
2. Cristae drawn as sharp spikes **floating free of the membrane they are folds of**. Now a test:
   every fold's base lies on the inner membrane.
3. A glycolipid drawn as a **bare head with no fatty acid tails** — a bead stuck to the surface
   rather than a membrane lipid. Now a test.
4. Three labels overprinting in the cell, fixed by giving the compact size an `ann` flag so the
   phrases that do not fit are dropped rather than stacked.

A fifth was designed out rather than patched: the cristae now leave a band clear right across the
matrix so the matrix label is never drawn over, and `p_organelle` asserts that band is really clear.

**§4c the readers — one fair flag.** The cell's alt text said the anode "loses mass as its metal is
oxidised" when the figure names no electrode material or half-reaction. The entry says a mass change
*can* occur; the alt asserted it. Corrected, re-run, accepted.

**The parity run — a defect in code already live.** The port proved **219/219 figure/layout pairs
byte-identical across 23 families**, and in doing so caught that the app painted **open circles
before the curves**, so `precalc-hole`'s hole was filled in by the curve's own stroke at every size.
That had shipped. The Python reference had already been fixed; the app had not, and only a
byte-comparison would have told anyone.

## 4. Order of operations, which is not optional

`FIGURE_FAMILIES` is a whitelist in the app's renderer: a figure whose family the app does not know
renders **nothing**, silently. So the sequence is always

> merge the app port → **publish it** → verify the live bundle → *then* load Production.

For this load the live bundle `/assets/Figure-puuBQBLU.js` was checked before any write: all four
family keys present, the electrode height present (minified to `.545`), and the open-circle emit at
offset 50934 now following the curve emit at 50886. Only then did the load run.

## 5. Verification on Production

- Counts 49 → **54** published figures, 18 → **22** families, 57 → **62** uses, 51 → **56** entries.
  No unpublished figure rows exist.
- The five rows are **byte-identical to Development by digest** (`8eb686059acfe6097db3e25a3e62a61a`,
  n=5); each `figure_uses` row resolved **by natural key** to the intended subject and topic.
- **As a real authenticated student**, not `service_role`: 1.6 → `dna_ladder`, 2.3 →
  `membrane_bilayer`, 3.4 and 3.5 → `organelle`, 9.8 → `electrochemical_cell`. AP Biology 1.1, which
  has no figure, returns 0 cleanly. AP Statistics 2.11 still serves its 5 — no regression.
- A **planted draft** figure on Biology 3.4 was invisible to that student, who saw only
  `bio-chloroplast`; the probe rolled back leaving 0 rows.

## 6. Two process defects found and fixed

- **`build_load_sql.py` accepted `--batch` and then tagged the rows from `--prefix`.** Earlier
  batches were named by a single prefix so the two agreed by accident; this one spans two, and the
  rows went out tagged `batch=bio-,chem-electro-figures-…` until the argument that exists for this
  was actually read.
- **A regression I shipped.** A Lovable publish earlier in this session carried an unrelated merged
  commit that gave the Lesson Notes template the app's subject picker and took away its back link.
  Publishing ships **every** merged-but-unpublished commit, not only yours. Fixed, and the test that
  had pinned the broken behaviour was corrected rather than deleted. Check
  `git log <last-published>..main` before pressing publish.

## 7. Mistakes worth recording

- **"Lane B is complete except the AP Biology four" was wrong and I said it about five times.**
  There were **five** gaps: AP Chemistry 9.8 fell between one handoff's §1 inventory (18 entries)
  and its §4 plan (17), and I repeated the plan's number without checking it against the database.
  §9 of the protocol now carries the query that settles any such claim, and it is the only
  acceptable evidence for "complete".
- **I ran `git checkout specs.json` to undo a formatting mistake and deleted two uncommitted
  figure specs with it.** Rebuilt from the transcript and verified the JSON round-trip was
  byte-identical before re-adding, but the right move was a WIP commit first.
- **My first RLS probe returned 0 figures for every topic, including the control.** That was my
  wrong JSON path — figures sit at the **top level** of the RPC payload, not under `entries` — not
  the data. Checking the shape rather than reporting the zeros is the whole lesson of
  `feedback_silent_absence_failures`: serving reports absence as normality.

## 8. What is left

1. **Load `function_plot` to Production.** The highest-value item on this list: 19 figures, 15
   entries, and the only figures AP Precalculus and AP Calculus AB would have. Built, three gates
   passed, ported at byte parity and merged — and never loaded. The load SQL is
   `scripts/lane-a-pilot/out/load_function_plot.sql`; it resolves entries by natural key, so it is
   portable. The app already knows the family (verified in the live bundle), so the usual
   publish-before-load ordering is already satisfied. Needs its own approval.
2. **Nobody has looked at `field_map`, `circuit_symbols` or the three `xy_series` gap figures.**
   They pass every gate and are live and serving. Gate 4b is the one gate a human must perform, and
   for these it has never been performed.
3. **~81 chart-shaped entries live outside `kind='diagram'`** — in `vocabulary`, `convention`,
   `formula` and `list_sequence`. `kind` was never the right lane filter. They are classified in
   `LANE_A_GAP_CLASSIFICATION_2026_10_11.md` and are **not built**. This is the next lane of work
   and is larger than everything above.
4. **A signed-in look at the five new figures.** The Product Owner has confirmed four earlier
   figures drawing live; these five have been verified by query and by contact sheet, not by eye in
   the real app.

**Next Owner:** David Bloom.
**Next Required Action:** approve the `function_plot` Production load — it is finished work sitting
idle, and two whole subjects have no figures without it. Then a signed-in look at AP Biology 1.6 /
2.3 / 3.4 / 3.5 and AP Chemistry 9.8, and a decision on whether the ~81 non-`diagram` entries become
the next lane.
