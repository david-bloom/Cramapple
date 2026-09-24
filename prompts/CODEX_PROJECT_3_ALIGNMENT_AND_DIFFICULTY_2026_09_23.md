# Codex Project 3 — Content/Rubric Alignment and Difficulty (work orders J–M)

DATE: 2026-09-23 | RUNS: long-run, unattended, multi-session, continuous
MODE: **Proposal only. Read-only against Production. No writes to published content, ever.**

Successor to Project 2 (`CODEX_PROJECT_2_CONTENT_COMPLETION_2026_09_23.md`). **Its shared rules and
its shared QA-preparation contract apply here unchanged** — read them first, including the
span-exclusivity invariant and the confidence rule added on 2026-09-23. `CODEX_OVERNIGHT_RUN_PROTOCOL_2026_09_22.md`
still governs count mismatches, pre-existing artifacts, committing and partial completion.

**Branch:** `codex/project3-2026-09-23`. No PR, no merge to `main`.

---

## Sequencing: this project does not jump the queue

Project 2 is still in flight. **Finish it first**, in its own order: G.1 (re-cut `ap-physics-1`),
then G's remaining subjects, then H, then E.1, then I.

Project 3 exists for two situations:

1. **When a Project 2 order is blocked** — a QA gate not yet open, a required input missing. Rather
   than idling or skipping ahead, take a Project 3 order. Report the switch.
2. **When Project 2 is complete.** Then this becomes the main queue.

Every order here is **measurement and proposal, not authoring**. That is deliberate: these are jobs
that can run unattended for hours without the risk profile of generating student-facing content, and
they are the ones whose findings currently block ratification of work already done.

---

## Why these four, stated honestly

Each order below exists because a specific QA finding or a verified Production count says it does.
Where a number is given, it was verified read-only on 2026-09-23 and **you should re-verify it
before working** — the protocol's tiered-drift rule applies.

---

# Work order J — difficulty: reconcile the vocabulary, then complete the coverage

**Directory:** `docs/research/difficulty_reconciliation_2026_09_23/`
**Priority: highest in this project.** It is the one with a decision hiding inside it.

## The problem, measured

The 2026-09-22/23 calibration work established a **three-level** scheme — Easy / Medium / Hard —
anchored to published College Board per-criterion attainment, with per-subject cut points, and
produced assignments for three subjects. Those assignments are **unratified and unapplied.**

Meanwhile Production already carries difficulty on 838 of 1,346 published items, and its live
vocabulary is **not** the calibrated scheme:

| Value in Production | Items | Notes |
| --- | ---: | --- |
| `(none)` | 508 | across all ten subjects, **including all 118 Biology** |
| `Medium` | 411 | |
| `Easy` | 173 | |
| `Hard` | 159 | |
| **`Very Hard`** | **49** | **a fourth level, outside the calibrated scheme** |
| `Easy-Medium` | 20 | AP Statistics only — a hybrid |
| `hard` / `medium` / `easy` / `very_hard` | 26 | AP Statistics only — casing variants |

So there are three separate problems wearing one label: a **vocabulary** that has four levels and
inconsistent casing, a **coverage** gap of 508 items, and a **calibrated proposal for three subjects
that was never applied**.

## J.1 — Reconcile the vocabulary. Propose; do not choose.

The central question is not yours to answer: **is the scheme three levels or four?** Build the
evidence and put the decision to the Product Owner.

1. Inventory every distinct value, its count, and its subject and item-type distribution.
2. For the 49 `Very Hard` items, extract what distinguishes them from `Hard` — task verbs, point
   totals, item type, topic. **Is `Very Hard` a real fourth band or an inconsistently applied
   `Hard`?** Answer with evidence from the items, not from the label.
3. Do the same for the 20 `Easy-Medium` items.
4. Establish the provenance of the existing 838 where you can: which migration, seed or run set them.
   A label whose origin is unknown carries less weight than one whose method is recorded.
5. Produce `vocabulary_decision_brief.md` setting out both options — collapse to three levels, or
   ratify four — with the item counts each implies, what would have to be relabelled, and which
   option the evidence favours. **Recommend, then stop.**

The 26 casing variants are a separate and unambiguous matter: `hard` and `Hard` are the same label
written twice. Propose the normalisation as a straightforward correction, listed per item.

## J.2 — Extend the calibrated method to the subjects that already have attainment data

`docs/research/apbio_difficulty_calibration_2026_09_22/crr_calibration_all_subjects.csv` holds **316
scored rubric points across eight subjects**, extracted from published Chief Reader Reports:

`AP Biology` 18 · `AP Calculus AB` 54 · `AP Calculus BC` 54 · `AP Chemistry` 46 ·
`AP Physics 2` 40 · `AP Physics C: E&M` 40 · `AP Physics C: Mech` 40 · `AP Precalculus` 24

Assignments were produced for Biology, Chemistry and Statistics only. **Five subjects have the
attainment data and no calibrated assignment:** Calculus AB, Calculus BC, Physics 2, Physics C E&M,
Physics C Mechanics, plus Precalculus — and **AP Physics 1 and AP Statistics have no rows in that
file at all**, so treat their baselines as absent and say so rather than borrowing another subject's.

Read `README.md` and `STATISTICS_AND_CHEMISTRY.md` in that directory before starting — they record
the method, what was validated and what was rejected. Two findings there bind you:

- **Cut points are per subject.** Subject baselines differ by 21 points (Physics 2 at 0.653,
  Calculus AB at 0.439). Do not apply one subject's thresholds to another.
- **A blanket `explain` → Hard rule was tried and rejected** — it alone moved the corpus from 23.7%
  to 53.4% Hard. The validated treatment splits `explain`: Medium for concept explanation, Hard only
  in an argumentation context. Reproduce the method; do not re-derive a new one.

Work subject by subject, committing after each. Report each subject's cut points, its resulting
distribution, and the validation you were able to run.

## J.3 — Biology

Biology carries **zero** difficulty labels in Production and has a complete 118-row calibrated
assignment sitting unapplied. Reconcile the two and propose. This is the cleanest case in the order —
no existing labels to argue with.

## Required evidence columns

Per item: `content_key`, `subject_key`, `item_type`, `existing_difficulty` (raw), `proposed_difficulty`,
`basis` (`calibrated` | `normalised_casing` | `carried_forward` | `undetermined`), `confidence`,
`rationale`, `attainment_anchor` (the CRR figure or subject baseline it rests on), `needs_human`.

**`undetermined` is available and is a real answer** — for items in a subject with no attainment
baseline, or where the vocabulary decision in J.1 changes what the label should be. An honest
`undetermined` beats a confident guess, and the shared confidence rule applies: where two bands both
plausibly fit, that item is `medium` confidence at best.

---

# Work order K — canonical answers that restate their own rubric

**Directory:** `docs/research/canonical_rubric_alignment_2026_09_23/`
**This is a measurement job across the whole library. It is the best continuous-overnight order here.**

## Why

QA of work order C found that the published canonical answers for all 14 `APSTATS-SFRQ-*` items **are
the rubric text** — third-person rubric voice with criterion-key prefixes, e.g. `a1) States the median
is 22 minutes.` rather than "The median commute time is 22 minutes." Measured similarity to their own
`learner_facing_text` averaged 0.652, with 28 of 56 span-criterion pairs at or above 0.85 and several
character-identical.

These are live, and they are what Open Hand shows a student as the full-credit exemplar. DECISION-0052
was written against exactly this: *"today's FRQ canonical is a restatement of the rubric, not a
verified full-credit response."*

**The AP Statistics finding came from a QA sample of one subject. Nobody has measured the other
nine.** 289 of 563 published FRQ carry a canonical answer. That is the scope.

## What to do

1. For every published FRQ with a non-empty `canonical_answer_1`, in all ten subjects, compute the
   word-level similarity between the answer text and the concatenated `learner_facing_text` of its
   criteria — and, where the answer is segmentable by part, per criterion. Use case- and
   punctuation-normalised tokens with `difflib.SequenceMatcher`, the same method QA uses, so the
   numbers are directly comparable.
2. Also flag **rubric-voice markers** independent of similarity: leading criterion-key prefixes
   (`a1)`, `b2)`), third-person rubric verbs at sentence start (`States…`, `Identifies…`,
   `Describes…`, `Concludes…`, `Explains…`), and the second-person forms (`to earn this point`,
   `make sure your response`). Similarity and voice are different signals and a bad answer may trip
   only one.
3. Rank by severity: character-identical, then ≥0.85, then ≥0.70, then voice-marker-only.
4. **Do not rewrite anything.** This order produces a measurement, a ranked list and a per-subject
   summary. Re-authoring is a separate decision and a separate order.

## Required output

`alignment_report.csv` — one row per item: `content_key`, `subject_key`, `similarity_overall`,
`similarity_max_criterion`, `voice_markers` (which fired), `severity_band`, and a short
`sample_quote` showing the worst offending sentence. Plus `SUMMARY.md` with per-subject counts and
the distribution, and an explicit statement of how many items in each subject would fail a
"the canonical must not be the rubric" test.

**Expect AP Statistics to score worst — that is the known case. The finding of interest is any
subject that scores comparably and has not yet been looked at.**

---

# Work order L — `rubric_type` coverage is not a tail

**Directory:** `docs/research/rubric_type_coverage_2026_09_23/`

Project 2's work order I.2 scopes `rubric_type` coverage from GAP-3, which describes "a tail of
items". Verified on 2026-09-23, it is not a tail:

| Subject | Published FRQ | `rubric_type` null |
| --- | ---: | ---: |
| ap-calculus-ab | 62 | **62** |
| ap-calculus-bc | 64 | **64** |
| ap-precalculus | 64 | **64** |
| ap-physics-1 | 54 | **54** |
| ap-chemistry | 51 | **51** |
| ap-physics-c-em | 49 | **49** |
| ap-physics-c-mechanics | 36 | **36** |
| ap-physics-2 | 28 | **28** |
| ap-statistics | 80 | 35 |
| biology | 75 | 71 |

Essentially **every non-spatial FRQ** has a null `rubric_type`; the populated ones are the hand-drawn
spatial items. Re-verify these counts first and report what you actually find.

**What matters is whether this is a defect at all.** The grading router reads `rubric_type` first and
falls back to `prompt_json.evaluator_strategy`, so a null may be harmless in practice. Establish that
before proposing 500 changes:

1. Read `supabase/functions/_shared/grading-router.ts` and determine exactly what a null
   `rubric_type` causes for each item type and engine.
2. For each null item, record what it *would* resolve to today, and whether that resolution is
   correct for the item.
3. Propose a value per item **only where the fallback resolves wrongly or ambiguously.** If the
   fallback is correct everywhere, **the right output is a finding that GAP-3 overstates the problem**,
   not 500 proposed edits. Say so plainly if that is what you find.

One known concrete case from QA of work order E: `APSTATS-HDG-2026-GRAPH-005` has a null
`rubric_type` where its 19 siblings carry `spatial`. That one is a genuine gap.

---

# Work order M — items assessing content outside their course

**Directory:** `docs/research/course_scope_audit_2026_09_23/`

## Why

QA of work order D found three items published in the **AP Calculus AB** bank that assess **BC-only**
topics: `apcalcab-mcq-045` (Euler's method), `-046` (logistic models), `-050` (arc length). Their
author tags cite CED topics `7.5`, `7.9` and `8.13`, which exist in the BC registry and correctly do
not exist in the AB one. A student practising AB is studying material that is not on the AB exam.

**Three were found because D happened to look at AB. Nobody has swept the other subjects.**

## What to do

1. For every published item carrying an author-time topic reference — `prompt_json.topic`, a
   `topic-N.N` tag in `modules`, or `taxonomy_refs` — parse the code and test it against **that
   subject's** closed list at its verified `taxonomy_source_version`.
2. A code that is valid in a **related** subject's list but not the item's own is the signal. The
   AB/BC pair is the obvious case; also check Physics 1 against Physics C, and Precalculus against
   Calculus AB.
3. For each hit, read the item and judge whether the content genuinely sits outside the course scope
   or whether the author tag is simply wrong. **These are different findings with different fixes** —
   a misfiled item moves or retires; a bad tag is corrected.
4. Out of scope: do **not** move, retire or relabel anything. The three AB items D found are already
   with the Product Owner and must not be touched.

Output `scope_audit.csv` — `content_key`, `subject_key`, `author_code`, `in_own_closed_list`,
`valid_in_related_subject` (which), `content_verdict` (`out_of_course_scope` | `tag_error` |
`inconclusive`), `evidence`, `needs_human`.

---

## Continuous filler, when an order finishes early

Prefer finishing an order over starting filler. But these are small, bounded and safe to run
unattended:

- **Rubric-defect sweep.** DECISION-0052's follow-ups say criteria that no correct answer can satisfy
  go to the Curricular Owner rather than being papered over. No one has swept for them. Verified
  2026-09-23: all 5,831 criteria have non-empty `evidence_requirements` and `minimum_fix` and
  positive points, so the mechanical defects are already absent — what remains is semantic, so sample
  rather than sweep exhaustively, and report the sampling frame you used.
- **Point-total mismatches.** 10 items (9 Biology sharing one bad template, 1 Chemistry). Already
  scoped as Project 2's work order I.1; do it there, not here.
- **Difficulty/topic cross-tabulation.** Once J produces labels, report difficulty distribution by
  topic and unit per subject. A unit where every item is Easy is a content-coverage finding worth
  surfacing, and it costs one query.

---

## What happens after

Everything here is a proposal. The gate before anything serves a student is unchanged: **AI build
(you) → independent AI cross-model QA (a different model) → Product Owner approval**, per
DECISION-0055. Nothing in this project writes to Production.

Two lessons from Project 2's QA that apply to every order here:

- **A blanket zero is not a result.** Work order E reported zero `undetermined`, zero `needs_human`
  and zero open questions across 384 items, and QA rejected six of them. Work order D reported
  `content_disagrees=false` on all 241 rows and QA could not prove the check had run. **Emit per-item
  verdicts, not just exceptions**, so a zero is evidenced rather than asserted.
- **Satisfying every stated invariant is not the same as doing the job.** Work order B passed every
  invariant its work order listed and was rejected, because the invariant table omitted the one that
  mattered. If you notice that this charter's checks would pass while the underlying purpose fails,
  **say so in `SUMMARY.md`** — that finding is worth more than a clean run.
