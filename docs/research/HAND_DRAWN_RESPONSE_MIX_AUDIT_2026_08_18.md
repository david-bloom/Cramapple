# Hand-drawn vs. non-hand-drawn question mix audit — 2026-08-18

**Trigger:** Owner request to open a new session checking whether Cramapple's
published question set has "the appropriate mix" of items requiring a
hand-drawn (student-photographed) response versus items that don't, judged
against each subject CED and other primary sources.

**Status:** Analysis only. No content changed, no `content_visual_requirements`
or `practice_format` rows written.

**Evidence class:** Mixed. The exam-side numbers (what the CED/real exam
requires) are freshly re-derived from `docs/product/*_CED_FACT_PACK.md`, which
are themselves primary-source-verified. The Cramapple-side numbers (what's
currently published) are **not re-queried live** — Supabase MCP is
unauthenticated in this session (no interactive OAuth available headless), so
this reuses the most recent full-corpus counts from
[`IMAGE_REQUIREMENT_SWEEP_2026_08_05.md`](IMAGE_REQUIREMENT_SWEEP_2026_08_05.md)
and [`TASK0020_CROSS_COURSE_IMAGE_READINESS_SCAN_2026_08_03.md`](TASK0020_CROSS_COURSE_IMAGE_READINESS_SCAN_2026_08_03.md).
Thirteen days of content work have happened since the 08-05 sweep (see
`ACTIVITY_LOG.md`), so treat the "current" column below as **last-verified
2026-08-05, not reconfirmed today** — flagged per row where that matters.

## Method

1. Pulled each subject's real-exam FRQ archetypes, point structure, and
   response modality (digital Bluebook vs. handwritten paper booklet) from its
   CED fact pack — this is what determines whether the *real* exam actually
   makes students hand-draw something.
2. Pulled Cramapple's current published hand-drawn-tagged (`no_constructs` /
   `supplemental_hand_drawn` / explicit HDG package) item counts from the
   08-05 sweep, which read every published item individually rather than
   using a keyword heuristic.
3. Compared the two per subject and flagged where they diverge, and whether
   the divergence looks like a deliberate, defensible authoring choice
   (already reasoned through in the 08-05 sweep) or an unexamined gap.
4. Folded in one hard constraint that overrides the mix question for now:
   **hand-drawn grading itself currently fails all four DR-1 accuracy
   thresholds** on real photos (
   [`HAND_DRAWN_REAL_PHOTO_GRADING_ACCURACY_2026_08_18.md`](HAND_DRAWN_REAL_PHOTO_GRADING_ACCURACY_2026_08_18.md),
   same day as this audit) — 23% exact-match, 30.6% false-accept rate. Any
   "we should add more hand-drawn items" conclusion below is gated on that
   being fixed first; it is not a reason to reduce the *authored* mix, since
   authoring and grading-readiness are separate problems.

## Subject-by-subject comparison

| Subject | Real exam: does the exam itself make students hand-draw? | Real exam: CED-documented graph/diagram-construction exposure | Cramapple published mix (as of 2026-08-05) | Read |
|---|---|---|---|---|
| AP Statistics | **No.** Fully digital Bluebook, built-in Desmos grapher; CED fact pack explicitly states hand-drawn practice is `supplemental_hand_drawn`, never exam-simulating (`AP_STATISTICS_2027_CED_FACT_PACK.md` §7). | Construct (Practice 3.A) is a named FRQ task verb, but performed digitally on the real exam. | 40 of 70 FRQ (57%) tagged `no_constructs`/hand-drawn; 32 of 48 targeted-drill FRQs carry explicit `hand_drawn`/`capture_instruction` markers. | **Mismatch by design, not by gap.** The fact pack already labels this supplemental and non-exam-simulating. 57% hand-drawn is a large fraction of a subject whose real exam has *zero* hand-drawn graphing — worth an explicit Owner call on whether that supplemental volume is still the right size given the grading-accuracy failure above, not a CED-alignment question. |
| AP Biology | Operationally assumed hybrid (MCQ digital, FRQ handwritten paper booklet) — **flagged `Not CED-verified`** in the fact pack itself (`AP_BIOLOGY_CED_FACT_PACK.md` §8); needs confirmation against current College Board exam-administration guidance, not just this repo's assumption. | FRQ Q2 Part B is explicitly "construct the appropriate graph from the data provided," worth 4 of 9 points — 1 of the exam's 6 FRQs has a graded construction component (~17% of FRQ point-weight-bearing questions). | 7 of 41 FRQ (17%: 5 HDG-GRAPH hand-drawn items + 2 self-graph FRQs) tagged hand-drawn/`no_constructs`. | **Good alignment**, 17% vs. 17%, *if* the hybrid-modality assumption holds. That assumption is explicitly unverified — worth closing before trusting this row further. Separately: all 36 published Biology FRQs (not just the 7 with images) have `practice_format IS NULL` as of 08-05, so none of these — hand-drawn or not — are actually reachable by a real student session yet; the mix is correct on paper but not yet servable. |
| AP Chemistry | Modality not documented in the fact pack (no hybrid/digital note found either way — an open question, unlike Biology where at least the assumption is written down and flagged). | Practice 3 ("create graphs, diagrams, and cross-scale representations") is FRQ-only in exam weighting, 8-16% of FRQ practice weight. One documented real item type: sketching a titration pH curve. | 1 of 42 FRQ (2.4%: `apchem-sfrq-032`, titration curve) tagged `no_constructs`. Zero others found in a full 110/110 item read. | **Possible undercount.** 8-16% FRQ-practice weight for a "create graphs/diagrams" skill vs. 2.4% of published FRQs having any construction component is a wide gap. The 08-05 sweep's own read found every other item's needed numeric value already given as text/table even where the stem mentions "titration curve" or "photoelectron spectrum" — a deliberate authoring choice to make those text-answerable rather than a gap, per that sweep's rationale. Whether that choice under-serves Practice 3 specifically (as opposed to just avoiding unnecessary images) hasn't been directly evaluated by anyone yet — flagging as an open question, not asserting a defect. |
| AP Physics 1 / 2 / C: Mechanics / C: E&M | **Yes, confirmed** for Physics 1 and 2 ("hybrid digital exam (Bluebook + handwritten FRQ booklets)," stated directly, not flagged as an assumption). Physics C packs don't repeat the modality line explicitly but are the same College Board hybrid-exam family. | All four courses share the same 4 FRQ archetypes; "Translation Between Representations" (1 of 4, ~25% of FRQ questions) routinely requires sketching a graph or force/momentum diagram. Every FRQ across the family is handwritten, so diagrams (free-body, vector) are drawn by hand on the real exam even outside that one archetype. | 6 of 53 published items (~11%) tagged `no_constructs` across all four Physics subcourses combined. | **Likely undercount, with a caveat.** ~25% of FRQ questions have a construction-heavy archetype, and *every* FRQ in this family is handwritten on paper in the real exam (unlike Bio, this is confirmed, not assumed) — yet only ~11% of Cramapple's published items are tagged hand-drawn. The 08-05 sweep's rationale was that every item "explicitly specifies its geometry/circuit topology/graph shape in prose, or explicitly asks the student to construct the diagram/graph themselves" — i.e., a deliberate choice to test the same construct via prose rather than a missing capability. That's a defensible design choice for *reading* a diagram, but it doesn't address that on the real exam, free-body/vector diagrams are drawn by hand as a scored step even on FRQs that aren't the "Translation" archetype — worth checking whether Cramapple's FRQ criteria expect or credit an actual drawn diagram anywhere, separate from image-display need. |
| AP Precalculus | Not documented either way in the fact pack. | 4 FRQ task models (Function Concepts, Modeling Non-Periodic, Modeling Periodic, Symbolic Manipulations) — none named "construct/sketch a graph" the way Bio/Stats/Physics are, but "Function Concepts" and both "Modeling" types commonly involve graphical representation per Practice language elsewhere in the CED. | 0 of 64 published items (0%) tagged hand-drawn. | **Plausibly correct as-is.** Precalculus's FRQ task models don't name graph construction the way the other four subjects do; the 08-05 sweep read all 64 items and found every one gives an explicit formula/equation/table rather than requiring a read off an unshown graph. Lowest-risk "no gap" verdict of the five non-Statistics subjects, but it's the same sweep's own self-flagged "borderline design smell" (`apcalcab-frq-u13-002`, see Calculus row) that applies here too in spirit — worth a second look specifically for whether any of the four FRQ task models, on the real exam, ever requires the student to sketch rather than just read a graph. |
| AP Calculus AB/BC | Not documented either way in the fact pack. | Practice 2 ("Connecting Representations": translate within/across graphical, numerical, analytical, verbal representations) is 10-20% of FRQ practice weight — includes sketching curves/derivative behavior from given information. | 0 of 36 published items (0%) tagged hand-drawn. | **Same shape as Precalculus, one concrete flagged instance.** The 08-05 sweep explicitly flagged `apcalcab-frq-u13-002` ("the graph of g") as giving every segment's exact endpoints/open-closed status in text — "functionally equivalent to a table, so no image is missing, but a stricter reviewer might want it rendered as an actual image for exam-format fidelity." That's a prompt-*image* concern (student reading a graph), not itself a hand-drawn-*response* gap — but Practice 2's 10-20% weight on graphical representation, combined with zero hand-drawn Calculus items anywhere in the corpus, is worth the same open question as Chemistry and Physics: is text-equivalence actually construct-equivalent for a skill whose real-exam form is reading and sketching a curve, not reading a table? |

## What this audit did *not* establish

- No live re-query of `app.content_visual_requirements` / `practice_format` —
  the table above is 13 days stale on the Cramapple side. Given the volume of
  publishing activity since 08-05 (dozens of ACTIVITY_LOG entries), the exact
  percentages could have moved; the *shape* of the findings (Stats far above
  its real-exam exposure by design, Chemistry/Physics/Calc/Precalc at or near
  zero despite non-trivial CED weight on graphical/diagram skills) is much
  less likely to have flipped, since none of the intervening sessions
  targeted hand-drawn mix specifically.
- AP Biology's hybrid-exam-modality assumption (`Not CED-verified`) was not
  resolved here — it was already flagged as open in the fact pack itself and
  remains open.
- This audit did not check whether "text-equivalent" items (the 08-05 sweep's
  `no_not_needed` calls on items that mention a visual but supply every value
  in prose) are actually construct-equivalent to a student who has to draw or
  read the visual on the real exam. That's a Learning Quality judgment call,
  not a mechanical count — flagged per subject above where it applies
  (Chemistry, Physics, Calculus, Precalculus), not resolved.
- English Literature has a `subject packs/English Lit` folder but no
  `content/item-packages` entry and wasn't in the 08-03/08-05 sweeps — out of
  scope here since it doesn't appear to have published content yet; flag if
  that's changed since.

## Recommendation

1. **Don't scale hand-drawn item volume in any subject before the grading
   accuracy fix lands** — the 08-18 real-photo benchmark failing all four
   DR-1 thresholds is the binding constraint right now, independent of
   whether the authored mix is correct.
2. **Re-run the count query live** once Supabase access is available in an
   interactive session, to get current numbers rather than 08-05's.
3. **Two genuine open questions worth an Owner or Learning Quality decision**,
   not further mechanical counting:
   - Chemistry/Physics/Calculus/Precalculus: is deliberately avoiding
     hand-drawn/visual items by supplying every value in prose actually
     construct-equivalent for skills (Practice 3 in Chemistry, Practice 2 in
     Calculus, the Translation archetype in Physics) whose real-exam form is
     reading or sketching a graph — or is it quietly testing an easier
     surrogate skill at scale across four subjects?
   - Statistics: given the real exam has zero hand-drawn graphing (fully
     digital, built-in Desmos) and grading accuracy on hand-drawn responses
     is currently failing, is 57%/40-of-70 the right supplemental volume, or
     should it shrink until grading is trustworthy?
4. **Close the Biology hybrid-modality assumption** — it's a load-bearing fact
   for whether Biology's 17%-vs-17% alignment in this audit means anything;
   right now it's Cramapple's own unverified assumption, not a CED fact.

**Next Owner:** David Bloom
**Next Required Action:** Decide whether to (a) authorize live re-verification
of the Cramapple-side counts, (b) route the Chemistry/Physics/Calculus/
Precalculus construct-equivalence question to Learning Quality, and (c) set a
policy on Statistics' supplemental hand-drawn volume given the current
grading-accuracy failure.
