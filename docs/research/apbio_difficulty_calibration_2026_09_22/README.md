# AP Biology Difficulty — Method, Calibration and First-Pass Assignments

Status: **Proposal — not ratified, not written to Production** | Date: 2026-09-22
Owner: David Bloom (Product Owner) | Subject scope: AP Biology (all ten subjects for the calibration data)

Records the difficulty method David approved as a first pass on 2026-09-22, the evidence behind
it, and a difficulty label for every published AP Biology item. Nothing here has been written to
any database. Under DECISION-0055 the gate before anything serves is AI build → independent AI
cross-model QA → Product Owner approval; only the build step is complete.

---

## 1. The governance point, first

**College Board does not define a difficulty scale.** Verified against the primary sources in
`subject packs/`:

- **2025 AP Statistics Chief Reader Report** — zero occurrences of *difficult, easy, hard, rigor,
  complexity, challenging* in the full extracted text.
- **AP Statistics CED** (20,117 lines) — 8 hits, 7 of them ordinary English. The only structural
  one states that exam development ensures an appropriate spread of difficulty across questions.
  It is asserted as a test-design property and never operationalised.
- **AP Biology CED** — same single boilerplate line. No levels, no rubric, no per-question label.
- Neither CED ties task verbs **or** Science Practices to difficulty.

So the three-level Easy / Medium / Hard scheme is a **Cramapple decision anchored to College Board
data**, not a College Board citation. Cite it that way. What College Board *does* publish is
empirical attainment, which is what §2 uses.

Cramapple previously carried a four-level scale (Easy / Medium / Hard / Very Hard) on 996 of 1,346
published items with no definition anywhere in `schemas/`, the content prompts or any governance
doc. Two reviewer QA sweeps measured it as unreliable — 19 of 70 reviewer ratings matched the
authored label (`docs/research/REVIEWER_QA_GULGELDI_2026_08_02.md`), and 21 of 40 differed "almost
always downward" (`docs/Q&A/REVIEWER_QA_SWEEP_2026_07_28.md`). Both sweeps recommended an explicit
difficulty rubric. This document is that rubric.

## 2. What College Board publishes instead: per-criterion attainment

Chief Reader Reports give each scored rubric point a **max** and a **mean**. The ratio
`mean / max` is an empirical difficulty measure — externally published, reproducible, and at
exactly the granularity Cramapple's rubric model uses (`frq_criteria.points_possible`).

`crr_calibration_all_subjects.csv` holds **316 scored rubric points across 8 subjects**, extracted
from the 2025 reports (Physics 1 is 2024). Regenerate with `extract_crr_points.py`.

**Subject baselines differ by 21 points, so cut points must be per subject:**

| Subject | Points | Mean | Hard ≤ | Moderate | Easy ≥ |
|---|---:|---:|---:|---|---:|
| AP Physics 2 | 40 | 0.653 | 0.58 | 0.58–0.78 | 0.78 |
| AP Physics C: E&M | 40 | 0.603 | 0.55 | 0.55–0.69 | 0.69 |
| AP Biology | 18 | 0.549 | 0.49 | 0.49–0.75 | 0.75 |
| AP Physics C: Mech | 40 | 0.548 | 0.47 | 0.47–0.72 | 0.72 |
| AP Calculus BC | 54 | 0.546 | 0.48 | 0.48–0.66 | 0.66 |
| AP Precalculus | 24 | 0.448 | 0.41 | 0.41–0.56 | 0.56 |
| AP Chemistry | 46 | 0.440 | 0.35 | 0.35–0.52 | 0.52 |
| AP Calculus AB | 54 | 0.439 | 0.36 | 0.36–0.54 | 0.54 |

A point earning 0.55 is below average in Physics 2 and well above average in Calculus AB. A single
global threshold would classify most of Physics 2 as Easy and most of Calculus AB as Hard — an
artifact of the subject, not the questions.

**Gaps:** AP Statistics and AP Physics 1 publish question-level means only, no per-point data, so
they contribute zero rows. The Physics 1 report is 2024.

## 3. The method: task verb (Method A)

An item's difficulty is the **modal tier of its rubric criteria's task verbs**, ties broken upward.
For MCQ, the stem's task verb.

| Tier | Verbs |
|---|---|
| **Easy** | identify, state, name, list, label, annotate, indicate, select, classify, recall |
| **Medium** | describe, **explain** (see §4), determine, compare, contrast, distinguish, construct, represent, write, analyze, apply, trace, graph, plot |
| **Hard** | justify, predict, evaluate, design, propose, support (a claim), synthesize, integrate, critique, **calculate** |

`calculate` sits in Hard on the evidence: 0.49 measured, exactly Biology's hard tertile boundary.
It is the most borderline assignment in the table.

### Why this method and not the alternative

A second framing was tested — cognitive complexity by mechanics (single-step recall → two-step
application → multi-unit synthesis). It was rejected:

- **It is not reproducible as specified.** Operationalising "integrates concepts across multiple
  units" four reasonable ways moved the Hard bucket from **1 item to 76 items** (0.8% to 64%).
- **It agrees with the verb method no better than chance.** On the 90 items both methods
  classified: 30.0% exact agreement, **Cohen's kappa 0.023** against 28.4% chance agreement. Best
  kappa across all four variants was 0.203, still only "slight".
- **It cannot be computed for much of the library.** Using metadata alone, 49 of 118 Biology items
  have no unit signal at all.

Its multi-unit signal is still useful as a **tiebreaker inside the Medium band** — where the verb
method is weakest — but not as a primary classifier.

### Validation against real AP attainment

Method A was scored against the 16 hand-verified 2025 AP Biology rubric points, using Biology's own
tertiles (Hard ≤ 0.49, Easy ≥ 0.75):

**12 / 16 = 75% exact match**, with errors structured, not random:

- **Easy: 3/3 correct.** Every `identify` point landed Easy (mean 0.813).
- **Hard: 4/4 correct.** Every `justify` and `evaluate` point landed Hard (`justify` mean 0.107).
- **All 4 errors fell in the Medium band** — `construct` 0.88 and `describe` 0.83 were actually
  Easy; `calculate` 0.49 and `explain` 0.21 were actually Hard.

**The method is reliable at the extremes and soft in the middle.** Treat Easy and Hard labels as
usable now; treat Medium as "not yet discriminated".

By Science Practice the signal is cleaner still: SP4 Representing/Describing Data 0.77 → SP1
Concept Explanation 0.57 → SP3 Questions & Methods 0.57 → SP5 Statistical Tests 0.49 → **SP6
Argumentation 0.18**.

## 4. The `explain` split — the single biggest lever

`explain` is **Medium when it means SP1 Concept Explanation, Hard when it means SP6 Argumentation.**

The AP Biology CED lists **1.B "Explain biological concepts and processes"** as the core skill of
Science Practice 1, whose measured mean is 0.57 — Medium. The one CRR data point where `explain`
scored 0.21 was Skill **6.E**, applied argumentation, not 1.B.

A blanket `explain → Hard` rule was tried first and rejected: **35 of 63 Hard items were Hard
solely because of that one verb**, and the corpus distribution swung from 53.4% Hard to 23.7% Hard
on that choice alone. The implemented rule treats `explain` as Medium unless the criterion text
carries argumentation markers (*claim, argument, supports the, refute, justify, evidence that,
evaluate*).

This is the most load-bearing single rule in the method and the first thing to re-test when student
data arrives.

## 5. First-pass assignments

`apbio_difficulty_assignments.csv` — **all 118 published AP Biology items, 0 unclassified.**
Regenerate with `assign_difficulty.py`.

| | n | Easy | Medium | Hard |
|---|---:|---:|---:|---:|
| **All** | 118 | 23 (19.5%) | 75 (63.6%) | 20 (16.9%) |
| FRQ | 75 | 21 (28.0%) | 47 (62.7%) | 7 (9.3%) |
| MCQ | 43 | 2 (4.7%) | 28 (65.1%) | 13 (30.2%) |

**Basis: 81 items by task verb, 37 by judgement.** Every row carries its `basis` and `rationale`.
The 37 judgement calls are items with no explicit task verb — short-FRQ rubrics whose criteria are
declarative content statements, and MCQ whose stems use "Which best explains / is best supported"
phrasing. They were assigned on the mechanics framework: Easy = single-step recall, Medium =
mechanism chain or standard calculation, Hard = argumentation, multi-evidence synthesis or
multi-unit integration.

**Note the MCQ/FRQ asymmetry:** 30.2% of MCQ classify Hard against 9.3% of FRQ, because our MCQ
stems are overwhelmingly argumentation-phrased. If accurate, the MCQ bank is written at markedly
higher cognitive demand than the FRQ bank — worth knowing independently of these labels.

The corpus is heavier in the middle than a real AP form, which is expected for an authored practice
bank but is also where the method is weakest. Do not read the Medium bucket as a measurement.

## 6. Limitations

1. **37 of 118 assignments are judgement, not measurement.** They are reproducible only in the
   sense that the rationale is recorded per row.
2. **The `explain` split drives the distribution** (§4). Re-test it first.
3. **`calculate → Hard` is borderline** — one observation, sitting exactly on the tertile boundary.
4. **Medium is not discriminated.** All four validation errors were Medium-classified.
5. **Validation n = 16**, one subject, one year.
6. `verb_auto` and `attr_method` in `crr_calibration_all_subjects.csv` are **unverified automated
   extraction** and must not be used as-is. The automated pass mislabelled Biology Q1 D1/D2
   (0.14, 0.02) as `describe` when the CRR text identifies them as Skill 6.B justify-a-claim —
   one verb per part-letter cannot handle a part with multiple sub-points. The `ratio`, `task` and
   `topic` columns are reliable. Only the 16 Biology points used for validation were hand-verified.

## 7. Why student data will not arrive soon, and what to do about it

David's framing was "a reasonable first pass until we have enough student data to make
adjustments." Measured against Production on 2026-09-22:

- `app.grading_results` — 78 gradings, **all 78** carrying a non-empty `criterion_results` JSON
  array. Criterion-level outcomes are being captured.
- `app.attempt_criterion_results` — the normalized table built for exactly this — **0 rows**.
  Nothing has ever written to it. The signal exists only inside JSON blobs.
- **AP Biology has 56 criterion datapoints, across 3 items, from 1 user, all on 2026-07-28** —
  against 278 published criteria. Statistics has 76 more from 2 users.

That is a smoke test, not calibration data, and Production still has essentially no real students.

**So do not wait on student data to fix the Medium band.** The CRR per-criterion means are already
external, published and extracted; they are what produced the `explain` and `calculate` corrections
here. Student data should refine an already-anchored scale rather than build one from scratch.

Two prerequisites for that later calibration:
1. Fix the `attempt_criterion_results` write path before volume arrives, or accept a backfill from
   JSON under pressure later.
2. Extend the hand-verified verb mapping beyond Biology — roughly 40 questions across 8 reports.
   The CRR narrative names the skill for most points, so this is bounded work.

## 8. Files

| File | What it is |
|---|---|
| `crr_calibration_all_subjects.csv` | 316 scored rubric points, 8 subjects, from the Chief Reader Reports |
| `apbio_difficulty_assignments.csv` | Easy/Medium/Hard for all 118 published AP Biology items, with basis and rationale |
| `extract_crr_points.py` | Regenerates the calibration CSV from the PDFs in `subject packs/` |
| `assign_difficulty.py` | Regenerates the assignments from Production |

Sources: `subject packs/*/ap25-cr-report-*.pdf` (Physics 1: `ap24-`), `subject packs/*/ap-*-course-and-exam-description*.pdf`.
These are third-party College Board copyrighted material, held on disk and never committed.

## 9. Next owner and action

**Next owner:** David Bloom.
**Next action:** ratify or reject the method and the 118 assignments. Nothing here is written to
Production. If ratified, the open question is where the label lives — `prompt_json.difficulty` is
the existing field but is read by no runtime code and is absent from 59 of 75 Biology FRQ.
