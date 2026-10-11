# Lane A pilot — accuracy, speed and cost

**Date:** 2026-10-10
**Scope:** AP Chemistry `kind='diagram'` reference entries classified Lane A.
**Approach approved by the Product Owner** 2026-10-10 (narrow scope: Lane A + pedagogically
synthetic illustrative data, reference-content diagrams only; Lanes B and D untouched, the
question-stimulus programme untouched). `TASK-0006` remains otherwise Pending.
**Code:** `scripts/lane-a-pilot/` — `render.py`, `specs.json`, `verify.py`, `out/`.

Nothing is loaded to any database and nothing is published. This measures the method.

---

## 1. Headline

| | |
| --- | --- |
| Published entries covered | **9 of 9** Lane A (verified against Production) |
| Figures produced | 11 — one entry needs two; one has no published entry |
| Renderer families written | **6** |
| Authored labelled parts rendered | **38 of 38** |
| Automated checks | **391, 0 failing** |
| Mean render time | **0.57 ms** per figure |
| Whole pipeline (render + 184 checks + write) | **69 ms** |
| Models at render time | **0** |
| Review step | 2 readers, 5/5 planted controls rejected, 11/11 figures accepted |
| Gateway spend (review step) | **$0.18** for all 11 figures |

## 1a. Correction: what is actually published

The first write-up said "all 10 published AP Chemistry Lane A entries", taken from the seed
artifacts in `scripts/content-seed/`. Those are **pre-load candidates, carrying no row id, topic
code or status**. Checked against Production (`pcntajvbdfqhbeewmdry`) on 2026-10-10:

- Production holds **15** published `ap_chemistry` diagram entries: **9 Lane A, 6 Lane B**.
- **`Maxwell-Boltzmann distribution (catalysis)` is not among them.** It exists only as a seed
  candidate. The nearest published rows are the Unit 5 convention *How a catalyst increases rate*
  and the Unit 3 vocabulary *Maxwell-Boltzmann distribution*. Its figure is kept, marked
  `unpublished`, excluded from coverage, and is not production-eligible until an entry exists.
- For the other nine, Production's `items[]` match the seed artifacts **exactly**, so the coverage
  claim stands on published content: **38 of 38 labelled parts**.
- Every `visual_asset_ref` in Production is still null, as expected.

Specs are now keyed on `reference_entry_id`, not on the title string. `prod_entries.json` records
the mapping and the date it was read.

## 2. Accuracy

### What was checked

184 assertions in three groups.

**Domain properties** — chemistry and maths facts that a wrong chart violates:

- Maxwell–Boltzmann peaks at θ/2 and integrates to 1 (the *speed* distribution peaks elsewhere,
  so substituting it fails loudly — this is the single most likely silent error in this family)
- hotter → larger fraction beyond Ea; lower Ea → larger fraction, with the curve unchanged
- every transition state is a true local maximum, every intermediate a true local minimum,
  every Ea positive, and the rate-determining step is the largest barrier
- isotope abundances sum to 100% and the weighted average mass reproduces magnesium's 24.305
- PES peak heights sum to the atomic number, and the core subshell has the highest binding energy
- the Morse minimum sits at `re`, energy → 0 at large separation, and higher bond order gives a
  shorter bond with a deeper well
- pH = pKa exactly at the half-equivalence point; the weak-acid equivalence point is basic;
  pH is monotonic and stays inside 0–14
- concentrations conserve material; forward and reverse rates converge to the *same* value

**Geometry** — every annotation and curve lies inside the plotted axes.

**Structure** — determinism (byte-identical re-render), axis labels present, `<title>`/`<desc>`
present, and synthetic data disclosed.

### Coverage

Each spec declares which of its entry's authored `items[]` labelled parts it renders, and the
check is made **per entry, not per figure** — so an entry whose parts span two charts is only
covered when both exist. All 40 labelled parts across the 10 entries are rendered.

### What actually went wrong, and what caught it

Seven defects. **The automated checks and the visual inspection caught disjoint sets**, which is
the most important result here.

| # | Defect | Caught by |
| --- | --- | --- |
| 1 | Multistep alt text didn't state the direction of change | property check |
| 2 | Potential-energy spec never disclosed its data was illustrative | property check |
| 3 | The equilibrium entry needs two figures; one chart cannot be both concentration-vs-time and rate-vs-time | coverage check |
| 4 | My own disclosure check compared lowercase against an all-caps label, so it had silently passed on alt text alone for all ten | investigating #2 |
| 5 | "overall change" label collided with the "products" label | **eye** |
| 6 | Axis ticks at fifths of the range gave pH 0/3/6/8/11/14 and energies −793/−547/−300 | **eye** |
| 7 | The bond-energy arrow was positioned beyond `r_max` and rendered off-canvas — while `covers` still claimed the entry's "Depth of the energy well" was shown | **eye** |

Defect 7 is the one to take seriously. Every number in that spec was correct, the chart rendered,
and the coverage check passed — because it tested a *declaration* rather than the render. Declared
coverage is not rendered coverage. The fix was to add the geometry group above, so that class is
now caught automatically; it accounts for most of the growth from 116 to 184 checks.

Defect 4 is the matching caution in the other direction: a green test suite is only as good as the
assertions in it, and one of mine was inert.

**Conclusion on accuracy.** The property tests carry the science and catch what no amount of
looking would (nobody eyeballs a normalisation integral). They do not catch legibility, and
legibility defects are not cosmetic here — an axis labelled 0/3/6/8/11/14 is a chart a student
will misread. Both are required. Neither is optional, and the visual pass cannot be delegated to
the person who cannot check the chemistry.

## 2a. The review step (added after the first write-up)

§7.3 owed one subject-competent pass over the illustrative values. Run as **one step, two
independent readers, no veto and no patch loop** — `openai/gpt-6.1-sol` and
`google/gemini-3.5-flash`, both non-Anthropic, because an Anthropic model would be marking its
own author's homework. Script: `scripts/lane-a-pilot/ced_check.py`.

Readers see the authored entry (claim, labelled parts, caution) and the exact drawing parameters.
They judge one question: *would a student who reads this figure learn something false?*

### Planted controls

Five deliberately wrong figures, each changing exactly one thing. **Three were chosen because
they pass `verify.py` cleanly**, so the controls measure whether a model reader adds anything
over the test suite:

| Control | Defect | Caught by verify.py? |
| --- | --- | --- |
| C1 | pH = pKa asserted at the equivalence point (the entry's caution forbids it) | yes |
| C2 | Temperature labels swapped against their thetas | **no** |
| C3 | Isotope abundances swapped, still labelled magnesium | yes |
| C4 | Second barrier made larger while the alt text still calls the first rate-determining | **no** |
| C5 | Nitrogen PES with 2s=3 and 2p=2 electrons (still sums to 7) | **no** |

### Result

**Controls 5/5 rejected by both readers. All 11 figures accepted by both.** The three controls
that defeat the test suite were caught, which is the evidence that this step earns its place.

### Two findings about the readers themselves

**A newer model was worse, and confidently so.** The first pass used `google/gemini-3.8-flash`,
newer than the protocol's ratified `gemini-3.5-flash`. It **accepted C2 with high confidence** —
a confident miss, which voids the batch under the controls gate. Swapped to the ratified
`gemini-3.5-flash`: 5/5. This is a direct argument for the protocol's rule that the Product Owner
ratifies the slate per batch rather than tracking the newest id.

**Two models failed on my harness, not their judgement.** `gemini-2.5-pro` errored on every item
and `gemini-3.5-flash` on two, because `max_tokens=1200` truncated reasoning models before they
emitted JSON. Raised to 4000 and both behaved. A harness limit reads exactly like a model being
bad at the task; worth remembering before rejecting a model.

### The one real flag

`gpt-6.1-sol` rejected the photoelectron spectrum: the nitrogen binding energies were presented
as measured (`synthetic: false`) rather than illustrative. That was a fair challenge to a claim I
had made without a source. On checking, the peak heights (2:2:3), the ordering, and the 1s value
(~39.6 MJ/mol, cross-checking against ~400 eV) hold up, but I could not trace the 2s and 2p
figures (2.45 and 1.45) to a primary table. The figure is now disclosed as illustrative and
carries a `values_note` saying exactly what is and is not sourced. Both readers then accepted it.

By contrast the mass spectrum keeps `synthetic: false`: its magnesium data comes from the
published AP Chemistry 1.2 explainer, which cites CED 1.2.A.1-2, and `verify.py` independently
recomputes the weighted average to 24.305 from those same numbers.

## 3. Speed

| Stage | Time |
| --- | --- |
| Pure render, mean per figure | 0.57 ms |
| Pure render, range | 0.04 ms (stick spectrum) – 1.32 ms (Maxwell–Boltzmann) |
| Full pipeline: 11 renders + 184 checks + file writes | 69 ms |

Rendering all 23 Lane A entries product-wide would take well under a tenth of a second. Render
time is not a constraint and never will be: there is no network call, no model, no I/O.

Authoring time is the real cost, and it is dominated by the renderer, not the spec. 372 lines of
renderer and 245 of verifier were written once; each entry then costs about 1 KB of JSON.

## 4. Cost

**Marginal cost per rendered image: zero.** No model participates at render time, so there is no
per-view, per-student or per-regeneration cost, and no bill that grows with traffic.

**Gateway spend: $0.18** for the accepted review pass — 34 calls, 24,104 input and 15,056 output
tokens across two readers, priced at the live gateway rates. That is **$0.016 per figure**.
Rendering itself still costs nothing: no model is involved there.

A further **$0.39** went on discarded exploration — the voided `gemini-3.8-flash` pass and the
candidate-reader tests, of which `gemini-2.5-pro` alone burned $0.19 producing 17,771 output
tokens and no usable JSON. **Total gateway spend for the review step: $0.57.** The repeatable
figure going forward is the $0.18.

No extractor and no veto were used: four models are not re-run over a claim the entry's own
authoring already validated.

**Session cost.** Context grew 260,864 → 324,757 tokens across the build, i.e. ~63,900 tokens for
six renderers, eleven specs, 184 checks, three fix rounds and the visual QA. The account's
five-hour window moved from 8% to 10% of a Max plan, and the monthly extra-usage balance did not
move from $32.27 — the whole pilot ran inside plan.

*Caveat on that number:* context growth is not billed tokens. Billed input is higher, because
every turn re-sends the conversation. Treat ~64k as the volume of new material produced, and the
2-percentage-point move in the five-hour window as the honest real-world cost signal.

**Per entry, amortised.** Six families served eleven figures. Spreading the one-time renderer work
across the ten entries gives roughly 6.4k tokens per entry; the marginal eleventh figure — the
rate-vs-time chart, a new spec on an existing family — cost a few hundred tokens and under a
millisecond. That gap is the whole argument.

## 5. What this says about the picture approach

The Lovable mock of 2026-10-09 produced one of these ten entries (the Maxwell–Boltzmann
distribution) as a matplotlib PNG. It cost about one model call, as this does. The difference is
what survived: the generator lived in a disposable sandbox and is gone, so the second
Maxwell–Boltzmann entry (the catalysis variant) would have cost the same again, and the third —
Physics 2's qualitative one — the same again.

Here the catalysis variant is 14 lines of JSON against a renderer that already existed.

Measured on this pilot: **6 renderers, 11 figures.** Under the picture approach that is 11
commissions, 11 files to store, version, restyle and re-check.

## 5a. Where these would display, and why they are not ready

### The surfaces, and how wide they are

| Surface | Component | Content width |
| --- | --- | --- |
| `/question` reference pane, "Graphs" | `GraphEntries` in `QuestionExperience.jsx` | **272-332px** (`.qx-pane-right` is `minmax(300px, 360px)`, less `.qx-graph` padding) |
| Lesson Notes sheet, single column | `ca-notes-sheet` | ~900-1100px |
| Lesson Notes sheet, two-column flow | `.ca-notes-full-flow` at container >=1000px | ~470px |
| Standalone `/learn/<subject>/<unit>/<topic>` | same sheet | as above |
| Phone | any of the above | ~358px |
| Copy notes | `exportDeepDive` clipboard HTML | Google Docs page width |

### The blocker

**The figures are drawn at 980x620 for slots as narrow as 272px.** SVG text scales with the
image, so in the question pane's Graphs section an 11.5px label renders at
`11.5 x 332/980 = 3.9px`, the axis titles at 4.2px and the figure title at 6.8px. Against the
16px body-text minimum this project already enforces on `/question`, that is a factor of four
out. Verified by rendering the titration curve at 332, 272 and 358px.

So the honest answer to "ready for production?" is **no, and the blocker is layout, not
chemistry**. The science is checked, the labels are complete, the disclosure is right. The
figures simply do not fit the surface they are meant for.

> **Resolved.** Three layout presets now exist; see the display design doc. Compact type renders
> at 10.7px in today's 332px pane and 14.9px in the proposed 460px one.

### The fix, and why the spec approach makes it cheap

Give the renderer **two layout modes driven by the same spec**: `compact` (roughly 340x300,
fewer annotations, larger relative type, legend dropped in favour of direct labels) for the
question pane and phone widths, and `full` for the notes sheet. The container picks the mode, and
a compact figure taps through to the full one.

This is only possible because the figure is a spec. A stored PNG cannot reflow, drop annotations
or grow its type for a narrow column; it can only shrink until it is unreadable, which is exactly
what the picture approach would have delivered into a 300px pane.

### How they reach the student

**Render client-side from `visual_spec jsonb` on the entry. No bucket, no signed URL, no
`visual_asset_ref`.** The stimulus-image path (private bucket, server-side signing inside
`student-session-items`) exists for binaries and Lane B will need it; Lane A does not, because
the spec is small structured data the serving RPC already returns alongside `items[]`.

Concretely: add `visual_spec jsonb` to `app.unit_reference_entries`, have
`get_topic_point_guides` pass it through in `reference[]`, and give the app a renderer component
that `GraphEntries` and the notes sheet both use. `visual_asset_ref` stays reserved for Lane B.

### Two open decisions

1. **Copy notes.** `exportDeepDive` builds clipboard HTML aimed at Google Docs, where inline SVG
   is unreliable. Either rasterise for export only, or omit figures from Copy notes and say so in
   the copy. Needs a decision before the notes sheet ships figures.
2. **The notes sheet drops reference content today.** `selectedTopicNotes` passes two arguments to
   `mapOpenHandGuides` instead of four, and even when fixed the mapper folds diagrams into a
   "Lists and sequences" prose section. A figure needs its own section there, not the prose
   roll-up. This is the same defect flagged in the Lesson Notes handoff.

## 6. Known limitations

- **Not yet TypeScript.** The pilot renderer is dependency-free Python. Production needs the same
  maths in the app's client-side renderer. The functions port directly and the property tests
  should port with them; this is real work but small, and it was out of scope for a measurement.
- **No compact layout, so nothing is production-ready yet.** See §5a: at the question pane's
  272-332px the labels render at about 4px.
- **No brand styling.** Figures use the mock's journal monochrome, not the orange/Bungee system.
  Styling scientific figures is a separate design decision.
- **One placement is conventional but loose.** The bond-energy bracket sits to the right of the
  curve minimum rather than at it; correct as a measurement bracket, slightly indirect to read.
- **Synthetic values are now reviewed, by models rather than a person.** Ten of eleven figures use
  illustrative numbers, and the §2a step accepted all of them with the controls gate passing. That
  is meaningful evidence, not a human expert's sign-off. If you want a person in this loop before
  anything reaches students, that is still outstanding — but the readers caught three defect
  classes the test suite cannot see, so the marginal value of a human pass is now much lower than
  it was.
- **The readers never see pixels.** They judge parameters and text, so they verify the chemistry,
  not the drawing. Layout and legibility remain a human visual pass.
- **Entry granularity.** One entry needed two figures. Others may; this cannot be known without
  attempting them.

## 7. Recommendation

1. **Accept the method.** 40/40 labelled parts, 184 passing checks, zero marginal cost, and the
   defects it did produce were found and fixed inside one session.
2. **Keep both gates.** Property tests for the science, a visual pass for legibility. Do not drop
   either; they caught disjoint defects here.
3. **Adopt the §2a review step as standing practice** — two non-Anthropic readers, planted
   controls, one round, no veto, no patch loop. It costs $0.016 per figure, caught a real
   disclosure defect, and its controls proved it sees three defect classes the tests cannot.
   Ratify the reader slate per batch rather than taking the newest model id, and keep
   `max_tokens` at 4000 or above.
4. **Then extend to the remaining 13 Lane A entries** (Statistics 7, Physics 4, Precalculus 1,
   plus one unattributed boxplot). Expect roughly five or six further families — the
   histogram/dotplot/boxplot/stem-and-leaf/pie/bar group is simple and highly shared — for about
   11–12 families covering all 23 entries.
0. **Superseded in part.** The Product Owner's 2026-10-10 direction (figure beside the question,
   an enlarge control, figures never omitted from the export, and every figure titled and
   labelled for recall) is designed and built in
   `LANE_A_FIGURE_DISPLAY_DESIGN_2026_10_10.md`. The compact layout below is done; item 6's
   `visual_spec jsonb` is replaced there by a figures table, because a column on the entry
   re-creates the single-owner problem that blocks recall.

5. **Build the compact layout mode before anything else** (§5a). Until a figure is legible at
   332px it cannot ship to the surface it was built for, and this is the one blocker that is not
   a matter of taste.
6. **Then port to TypeScript with the tests**, and only then add `visual_spec jsonb` to
   `app.unit_reference_entries` and pass it through `get_topic_point_guides`. Nothing here needs
   a database change yet.
7. **Decide the Copy notes and notes-sheet questions** in §5a before the sheet ships figures.
