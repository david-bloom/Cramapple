# AP Biology Synthetic Prompt-Visual Survey, Model Evaluation, and Smoke Test

**Date:** 2026-08-04
**Status:** Research only. No Production content, Storage, or schema was modified.
**Scope:** The 41-item AP Biology FRQ slice locked by `APPROVAL-0042` (same slice
audited in TASK-0020). Does not cover the broader 97 published / 254 latest
AP Biology item pool, or AP Statistics.
**Builds on:** `docs/research/TASK0020_LAUNCH_SLICE_CLASSIFICATION_2026_08_03.md`,
`docs/research/TASK0020_LAUNCH_READINESS_FINDINGS_2026_08_03.md`,
`docs/research/ap_biology_stimulus_images_2026_07_12/README.md`.

This is scoped narrower than TASK-0020: it addresses **Program A prompt-visual
content creation** only (which items need a synthetic image, and how good is a
generative-AI approach at making one). It does not touch Program A's delivery
blockers (signed URL path, renderer, accessibility metadata), Program B
(hand-drawn capture), or Program C (grading) — those remain exactly as found in
TASK-0020.

## 1. Survey — independent re-derivation of the Biology construct-sensitivity list

TASK-0020 flagged that its 7-item construct-sensitive list (`APBIO-FRQ-L-009,
011, 019, 020, 021, 027, 028`) was preparer-derived only, and required "a
second reviewer [to] independently re-derive the construct-equivalence-risk
list from all 41 Biology candidates" before Learning Quality review. This
section performs that re-derivation. It is a technical classification pass,
not the Learning Quality equivalence judgment itself — that approval still has
not happened for any item on this list.

**Method:** read `stem` (not just `stimulus`) for all 30 text/JSON-encoded
Biology FRQ candidates and the 10 no-visual-candidate items, live from
Production (`pcntajvbdfqhbeewmdry`, SELECT-only). The prior classification
worked mostly from `stimulus`; `stem` is where an explicit "using the
pedigree" / "the graph shows" / "using Figure 1" instruction lives, and is a
sharper signal for "the prompt requires the student to read a visual that does
not exist as a visual" than keyword-matching the stimulus text alone.

**Finding: `APBIO-FRQ-L-003` was missed and should be added to the
construct-sensitive list.**

Its stimulus is a three-generation genetics pedigree serialized as a
generation-by-generation text list (same pattern as the already-flagged
`L-019`). Its stem opens with **"Using the pedigree, determine the most
likely mode of inheritance..."** — an explicit instruction to read a diagram
that does not exist as a diagram, then asks the student to determine
genotypes of four named individuals from pedigree structure. This is not a
borderline case: pedigree-inheritance-pattern reasoning depends on the visual
topology (who mated with whom, sibship groupings, generation structure), and
`L-003`'s prior classification as "no prompt-visual candidate" appears to be
an oversight, not a considered judgment.

**Everything else re-checked and confirmed correct.** Every other item in the
25-item text/JSON-encoded bucket was checked for stem language referencing a
figure/graph/diagram the student is asked to read, cross-referenced against
its stimulus:

- The 7 previously-flagged items (`L-009, 011, 019, 020, 021, 027, 028`) all
  have explicit "Figure 1 shows..." / "the graph shows..." / "using the food
  web diagram..." stem language — confirmed correctly flagged.
- No other item's stem instructs the student to read a visual that isn't
  present as text/table data. Several items narrate pathways or mechanisms as
  numbered/bulleted steps (`L-002` epinephrine cascade, `L-013` endomembrane
  trafficking, `L-014` mitochondrial ETC structure, `L-017` insulin
  signaling, `L-022` miRNA biogenesis) — these read like they *could* be
  diagrams, but their stems ask the student to "describe," "trace," or
  "explain" the pathway in their own words rather than "using the diagram
  below," so the text-only stimulus is not a construct gap for these. This
  distinction (stem instruction, not topic subject matter) is the operative
  test, and it is what separates `L-014` (ETC background info, describe-only
  stem, not flagged) from `L-011` (explicit "the graph shows," flagged).
- Items presenting data as tables with stems saying "using the data in the
  table" / "Table 1 shows" are correctly text-only — a table is not degraded
  by being stored as text, unlike a pedigree or a curve shape.
- `L-025` and `L-038` ask the student to *construct* a cladogram from a given
  character/nucleotide-difference matrix; the source data is inherently
  tabular and the diagram is the student's own answer, not something they
  need to be shown. Correctly unflagged.

**Revised construct-sensitive count: 8, not 7** — `L-003, 009, 011, 019, 020,
021, 027, 028`. `docs/research/TASK0020_LAUNCH_SLICE_CLASSIFICATION_2026_08_03.md`
should be read together with this addendum rather than edited in place, per
this repo's practice of not rewriting dated assessment records after the fact.

This re-derivation is a technical pass by one additional reviewer, not the
Learning Quality construct-equivalence approval TASK-0020 requires before any
of these 8 items can be treated as settled. It narrows the list; it does not
approve it.

## 2. Model research

TASK-0020 explicitly put "vendor, or model-selection decisions" out of scope.
This section makes that decision researchable for the first time.

### 2.1 What already exists: the proven deterministic approach

`docs/research/ap_biology_stimulus_images_2026_07_12/generate.py` already
solved this problem once, for a different 10-item set (`APBIO-FRQ-S-002`
etc.), using **matplotlib** — not a generative AI image model. That approach:

- Produces exact, reproducible, version-pinned output (the README documents a
  Matplotlib-version pin and refuses to generate under a different version).
- Still needed a human scientific-accuracy review pass, which caught 3 real
  errors (a backwards arrow, a wrong pathway connection, a misleading
  connector line) — even fully deterministic, code-generated diagrams need
  review, but the error class is "the author's script had a bug," which is
  fixable and auditable in source control.
- Is naturally suited to exactly the content types Biology's 8 construct-
  sensitive items are: pedigrees, food-web/pathway diagrams, and line/curve
  graphs with named quantitative features (peak position, axis range) are all
  things matplotlib (or equivalent programmatic charting) draws exactly, on
  request, every time.

### 2.2 Generative image models: availability

Checked via Vercel AI Gateway (`AI_GATEWAY_API_KEY`, already wired in this
repo for text models per `docs/research/GOLD_SET_GENERATION_PROTOCOL.md`).
Reachability probe (`scripts/vercel-gateway-check/image_models_probe.mjs`):

| Model slug | Result |
|---|---|
| `openai/gpt-image-1` | **Reachable.** Generated a valid PNG. |
| `google/gemini-2.5-flash-image` | Not reachable — `invalid_request_error` on this account/slug. |
| `black-forest-labs/flux-1.1-pro` | Not reachable — `model_not_found`. |

Only `openai/gpt-image-1` is currently usable through this account's gateway
access. This is not a considered model bake-off — it's a one-account
reachability check. A real model-selection decision, if generative AI image
models remain on the table after §3, should re-probe Gemini/Imagen and other
candidates under correct slugs/entitlements before ruling them out.

### 2.3 Recommendation

**Do not use a generative AI image model as the primary path for Biology's 8
construct-sensitive items.** Use the proven matplotlib/programmatic approach
for pedigrees, food-web/pathway diagrams, and quantitative line graphs — the
three content types that make up all 8 items. Reserve a generative image
model, if one is used at all, for content a chart library cannot produce:
`L-028`'s Mount St. Helens photographs are the only item in this set that
asks for something photographic rather than diagrammatic, and even there,
real stock/archival photography (with clear rights) is worth checking before
reaching for synthetic photo generation.

§3 is why this recommendation is not a formality.

## 3. Smoke test

Three items were chosen from the 8-item construct-sensitive list to span the
three content types found in it: a pedigree (`L-003`, the newly-added item —
also the highest-complexity case, 12 labeled individuals across 3
generations), a linear pathway diagram (`L-009`'s food web, the simplest
case), and a multi-curve quantitative graph (`L-011`'s enzyme-pH curves).
Generated with `openai/gpt-image-1` (the only reachable candidate, §2.2) via
`scripts/vercel-gateway-check/apbio_image_smoke_test.mjs`. Prompts were
written to spell out every exact value/label from the item's stimulus text,
to give the model the best possible chance. Images saved to
`docs/research/apbio_synthetic_image_smoke_test_2026_08_04/` for the record —
**none were reviewed as acceptable; none are release candidates.**

### 3.1 QA findings

**`APBIO-FRQ-L-009` (food web) — content correct, framing defect.**
All four labels correct and in the right order (`Phytoplankton → Zooplankton
→ Small fish (anchovies) → Tuna`), arrows point the right direction. The
leftmost and rightmost boxes are clipped at the canvas edge (`Phytoplankton`
reads "ytoplankton," `Tuna`'s box is cut off) — a framing bug, not a content
error, and plausibly fixable with a margin instruction. This is the one image
of the three that a re-prompt might rescue.

**`APBIO-FRQ-L-011` (enzyme activity vs. pH) — scientifically wrong, fails
the item's actual assessment target.** The requested peaks were Pepsin at
pH 2.0, Amylase at pH 7.0, Trypsin at pH 8.0 — three curves separated across
the pH range, which is the entire point of the question (matching each
enzyme's optimum to its digestive location). The generated graph instead
clusters all three peaks together around pH 4–6, with Amylase and Trypsin
nearly overlapping. The x-axis tick labels are also non-linear and internally
inconsistent (`0, 2, 4, 6, 8, 14` — jumps from 8 straight to 14, skipping 10
and 12, with visibly uneven spacing). A student asked to read optimal pH
values off this graph would get answers contradicted by the item's own
canonical answer key. **This is not a cosmetic defect — it would teach and
test the wrong thing.**

**`APBIO-FRQ-L-003` (pedigree) — multiple structural errors, unusable.**
The most complex of the three prompts, and the model lost track of the
structure:
- Generation labels are wrong: four visual rows are drawn but labeled `I, II,
  III, III` (two rows share the label "III"; there is no row labeled "IV").
- An individual is dropped: Generation II should have six children
  (`II-1` through `II-6`); the image shows only five, skipping `II-5`
  entirely.
- ID numbers are reused incorrectly across generations: the row that should
  be Generation III (children of `II-3` × `II-4`) is labeled with recycled
  Generation II IDs (`II-2, II-3, II-4`) instead of `III-1` through `III-4`,
  and shows only 3 individuals where the source specifies 4 (`III-4` is
  missing).
- A second, separate error in the same region: the *next* row after that
  (which should not exist — the source pedigree only has 3 generations) is
  drawn as an extra fourth generation, again mislabeled "III," with `III-1,
  III-2, III-3` shown and `III-4` still missing.

Every one of these errors would change the answer to Part A ("determine the
genotypes of I-1, I-2, II-3, and II-4" — individuals whose identity in the
image no longer reliably matches their labeled ID) and Part B (a chi-square
calculation over II-3 × II-4's four children, one of whom is now missing from
the image). **This is the highest-stakes failure of the three**, because
pedigree structure errors are exactly the kind of thing a rushed human
reviewer could also miss on a quick glance — the image "looks like" a
correct pedigree at a distance.

### 3.2 What this confirms

1 of 3 smoke-test images might be salvageable with reprompting (food web,
framing only). 2 of 3 have the exact failure mode §2.3 predicted: generative
image models are unreliable at exact multi-entity structure (pedigree) and
exact quantitative feature placement (graph peaks, axis scale) — which is
precisely the profile of Biology's remaining 7 construct-sensitive items.
This is a 3-image sample, not a statistically powered evaluation, but it is
consistent with — not contradicting — the recommendation in §2.3.

### 3.3 Second model: Gemini (`google/gemini-2.5-flash-image`)

Re-probed after the initial write-up specifically to check whether §2.3's
conclusion was an artifact of one model rather than the underlying approach.
`google/gemini-2.5-flash-image` turned out to be registered in the gateway as
a **language model** that emits image output parts (`generateText` +
`result.files`), not as an image-model endpoint (`generateImage` returns
`ModelTypeMismatchError` for it) — a routing detail worth keeping if this
model is probed again. `google/imagen-4.0-generate-001` is a true
image-model endpoint and is also reachable, but was not run in this smoke
test. Same 3 items, same exact-value prompts, saved under
`docs/research/apbio_synthetic_image_smoke_test_2026_08_04/gemini_comparison/`.

**Food web:** correct framing (the gpt-image-1 clipping defect did not
recur), but two of the four labels are misspelled — "Phytoplatrron" and
"Zooplankan" instead of "Phytoplankton" and "Zooplankton." Different failure
mode (text hallucination vs. framing), same outcome: not usable as-is.

**Enzyme pH graph:** peak separation is visibly better than gpt-image-1's
attempt — three distinguishable peaks rather than three bunched together —
but still not accurate: Pepsin peaks around pH 3 (should be 2.0), Trypsin
peaks around pH 10 (should be 8.0, a 2-unit error), and both axis labels have
typos ("Relativ enzzme ativity"). The x-axis ticks are again unevenly spaced
(0, 2, 5, 6, 8, 14).

**Pedigree:** worse than gpt-image-1's attempt, not better. Generation I has
three individuals instead of two, with "I-2" used as a duplicate label.
Generation II has seven symbols instead of six, one of them left completely
unlabeled, and the sex/affected-status symbols don't match the intended
individuals (`II-4` drawn as a circle when the source specifies a male).
Generation III relabels individuals using recycled Generation-II IDs mixed
with one fabricated ID ("III-5") that doesn't exist in the source at all,
while `III-1` and `III-3` are simply missing. The legend also has a spelling
error ("Unnufated").

**Conclusion: a second, architecturally different model does not rescue the
approach.** Gemini traded gpt-image-1's error class (framing, structural
undercounting) for a different one (text/spelling hallucination) while
independently reproducing the same structural miscounting on the pedigree —
the hardest and highest-stakes item — and still missing exact peak placement
on the graph. Two vendors, two different underlying architectures, same
category of failure on the same two content types. This raises confidence
that §2.3's recommendation is about generative image models as a category
for this use case, not a `gpt-image-1`-specific weakness.

## 4. Deterministic generator: built and QA'd for all 7 non-photo items

Built `docs/research/apbio_synthetic_image_smoke_test_2026_08_04/generate_construct_sensitive.py`,
following the exact style conventions of the proven
`ap_biology_stimulus_images_2026_07_12/generate.py` (matplotlib, Agg
backend, textbook-schematic, deterministic). Covers 7 of the 8
construct-sensitive items — everything except `L-028`, which needs actual
photographs (see §4.1 recommendation, now §5.2).

| Item | Content type | Result |
|---|---|---|
| `APBIO-FRQ-L-003` | 3-generation pedigree, 12 individuals | All IDs, sexes, affected-status, and the `II-3`×`II-4` mating exactly match the source. |
| `APBIO-FRQ-L-019` | 3-generation X-linked pedigree | All IDs/symbols exact; no affected females, matching the source's stated constraint. |
| `APBIO-FRQ-L-009` | Food web, 4-node linear chain | Exact labels, correct arrow direction; canvas-clipping bug caught and fixed during QA (see below). |
| `APBIO-FRQ-L-011` | Enzyme activity vs. pH, 3 curves | Peaks placed at exactly pH 2.0 / 7.0 / 8.0 as specified; even axis spacing. |
| `APBIO-FRQ-L-020` | Norm-of-reaction line graph (Figure 2 only) | All 9 data points (3 genotypes × 3 nitrogen levels) plotted at their exact given values. |
| `APBIO-FRQ-L-021` | Euchromatin vs. heterochromatin schematic | Qualitative/structural, not data-precise — conveys the correct contrast (loosely packed & accessible vs. densely packed & inaccessible) without contradicting the source. |
| `APBIO-FRQ-L-027` | Dual-axis Keeling Curve + temperature anomaly, 1850–2024 | Endpoints match exactly (280 ppm / 421 ppm; 0°C / +1.4°C baseline), accelerating trend shape matches the described rate increase. |

**One real bug, caught by the same QA process used on the generative-model
images:** `L-009`'s first draft clipped the rightmost box ("Tuna") at the
canvas edge — the identical framing defect §3.1 flagged in the gpt-image-1
output, just introduced through a bounding-box miscalculation instead of a
generative model's own accord. Fixed by widening the figure and shifting box
positions; confirms the review step remains necessary even for code-drawn
output, exactly as the original 10-image batch's 3 caught errors already
established.

**No other defects found.** Every ID, symbol, mating relationship, curve
peak, and data point traces directly back to the exact value pulled from
Production `stimulus` text in §1 — because the values are read from the same
source data, not re-typed from memory or inferred by a model. This is the
structural reason the deterministic approach doesn't share the generative
models' failure mode: correctness is a property of the script matching the
data, checkable by direct comparison, rather than a property of how well a
model happened to interpret a natural-language description.

These are still **candidates, not release candidates** — see §5.3.

**2026-08-05 update: uploaded to Production for reviewer visibility only.**
All 7 images are now in the `content-assets` bucket at
`Biology/FRQ/<content_key>.png` (same convention as `APBIO-FRQ-S-009`), and
`app.content_item_versions.stimulus_image_path` is set on each item's latest
version (`scripts/content-seed/upload_apbio_construct_sensitive_images.mjs`
for the upload; a direct SQL `UPDATE` for the path, touching only
`stimulus_image_path`/`updated_at` — `status`/`review_status`/`approved_at`
were left untouched). This makes the images visible to `tutor`/`reader`/
`validator`/`admin`/`content_author` roles through the reviewer portal's
existing render path (confirmed live: `storage-sign-url`'s `canAccessBucket`
still has no `student` grant for `content-assets`, and the deployed student
`/session` route still renders placeholder content, not `stimulus_image_path`
— neither has changed since §2). **This is not a release or a Learning
Quality approval** — it puts the 7 images in front of reviewers, which is
what needs to happen before any construct-equivalence or scientific-accuracy
review can occur, not a substitute for it.

**2026-08-05: scoped as `docs/tasks/TASK-0021-BIOLOGY-PROMPT-VISUAL-STUDENT-DELIVERY.md`.**
Covers the student-facing delivery gap described above (signed delivery path,
session-render fix, accessibility metadata, fail-closed behavior, the
`practice_format` blocker). Hard-Gate tier, approval pending — scoping only,
not authorization to build or ship.

## 5. Recommended next steps

1. ~~Build the 8 Biology construct-sensitive images with a programmatic
   generator.~~ **Done for 7 of 8** — §4. `L-028` remains.
2. Route `L-028` (the one photographic item) separately — check licensable
   archival/stock photography of the actual Mount St. Helens blast zone
   before considering synthetic photo generation for it. Not started.
3. Treat this survey's 8-item list, the 6-image generative-model rejection
   (§3, two models), and the 7 code-drawn candidates (§4) as inputs to — not
   a substitute for — the Learning Quality construct-equivalence review
   TASK-0020 already requires. **Nothing in this document authorizes
   reviewing, approving, or shipping a release candidate.** It narrows what
   needs to be built, rules out generative image models as the generation
   method, and produces 7 candidate images for that review to start from.
4. Any committed release candidate still goes through the same gates TASK-0020
   already established for `APBIO-FRQ-S-009`: exact-version binding,
   scientific/grading/accessibility/rights review, and independent QA before
   anything reaches Production. The 7 candidates in this document have had
   exactly one reviewer (the preparer) checking data fidelity — the same
   "second reviewer" gap TASK-0020 flagged for the construct-sensitivity list
   in §1 applies equally to these images before they can move further.

## 6. Evidence

- Production queries: SELECT-only against `app.content_item_versions` /
  `app.content_items`, `pcntajvbdfqhbeewmdry`. No learner data, no mutations.
- `scripts/vercel-gateway-check/image_models_probe.mjs` — image-model
  reachability probe (`generateImage` endpoint).
- `scripts/vercel-gateway-check/gemini_slug_probe.mjs` — follow-up slug probe
  that found `google/imagen-4.0-generate-001` (image-model endpoint) and
  diagnosed `google/gemini-2.5-flash-image` as a language-model endpoint.
- `scripts/vercel-gateway-check/apbio_image_smoke_test.mjs` — the 3-image
  gpt-image-1 smoke test.
- `scripts/vercel-gateway-check/apbio_image_smoke_test_gemini.mjs` — the same
  3 items against `google/gemini-2.5-flash-image` via `generateText`.
- `docs/research/apbio_synthetic_image_smoke_test_2026_08_04/generate_construct_sensitive.py`
  — the deterministic generator for 7 of the 8 construct-sensitive items.
- Generated images, all QA-rejected reference artifacts or unreviewed
  candidates, none are release candidates:
  - `docs/research/apbio_synthetic_image_smoke_test_2026_08_04/APBIO-FRQ-L-003.png`,
    `L-009.png`, `L-011.png`, `L-019.png`, `L-020.png`, `L-021.png`, `L-027.png`
    — code-drawn candidates, §4.
  - `docs/research/apbio_synthetic_image_smoke_test_2026_08_04/gemini_comparison/`
    — the Gemini generative-model comparison images, §3.3, rejected.
  - `docs/research/apbio_synthetic_image_smoke_test_2026_08_04/gpt_image_1_comparison/`
    — the gpt-image-1 generative-model images, §3.1, rejected. (Note: these
    were originally saved at the top level of this directory under the same
    filenames as the code-drawn candidates in §4, and were transiently
    overwritten when the generator first ran. Recovered from the script's
    `/tmp` output and moved here before anything was lost or committed in a
    broken state — flagged here in case the git history for this directory
    looks like it skipped a step.)
