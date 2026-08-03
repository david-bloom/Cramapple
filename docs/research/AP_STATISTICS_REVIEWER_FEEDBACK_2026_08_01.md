# AP Statistics Reviewer Feedback — Triage and Response

**Date:** 2026-08-01
**Reviewer:** Jill (AP Statistics, sole Statistics reviewer)
**Triaged by:** Claude session (content review)
**Status:** Prompt fixes applied; four items need Product Owner decisions

All five findings were checked against the Production database
(`pcntajvbdfqhbeewmdry`) and the authoring prompts. **All five are confirmed.**
Two of them (3 and 4) are symptoms of the same underlying cause: AP Statistics
content was authored against the retired 9-unit CED and against a question format
that does not exist on the exam.

---

## Content inventory (Production, at time of triage)

AP Statistics items across all three content-key prefixes (`APSTAT`, `APSTATS`,
`STATS`) — 276 items total:

| Format | Total | Published |
| --- | --- | --- |
| MCQ | 118 | **16** |
| Short FRQ (4pt, Cramapple-invented format) | 148 | **66** |
| Long FRQ (exam-shaped) | 10 | **1** |

The published mix is close to the inverse of the real exam: 66 published items in
a format the exam does not contain, against 16 MCQs and a single long FRQ. This
single table explains Jill's findings 2 and 3 at once.

For reference, the real exam is **42 MCQ (50%) + 4 FRQ × 10 points (50%)**.

---

## Critical context: most of this is already decided and blocked on Jill

Findings 2, 3, and 4 are, in substance, re-discoveries of a problem that was
diagnosed and planned on 2026-07-13. That plan is not visible from the current
branch, which is why it is easy to miss:

- **`DECISION-0036`** commissioned a full AP Statistics content rebuild against the
  Fall 2026 CED, using a multi-model authoring cascade.
- **`docs/product/AP_STATISTICS_2027_CED_FACT_PACK.md`** is the sanctioned authoring
  input — verified unit map, weights, topic map, statistical practices, task verbs,
  the four 10-point FRQ archetypes, and the five confirmed removals. **It exists
  only on branch `codex/five-subject-harness-and-content` (commit `e0bf685`)**, not
  on `main` and not on this branch.
- **`APPROVAL-0036`** approved a target bank of **100 MCQ / 70 FRQ**, split per unit
  and per FRQ archetype.
- The whole cascade is **gated on G0A** — subject-tutor sign-off on the fact pack —
  and G0A was reassigned from Orly to the AP Statistics subject tutor.

**Jill is the AP Statistics subject tutor, and she is the only one.** So G0A is
waiting on her, while she spends her review cycles on 2025-26 content that the
approved plan intends to replace. Her findings 2, 3, and 4 are exactly the three
questions G0A asks — she has effectively answered them from the reviewer's side
without being asked the question directly.

That reframes the priority: the highest-value next action is not to patch the old
bank item by item, but to **put the fact pack in front of Jill for G0A sign-off**,
which unblocks the rebuild that resolves findings 2, 3, and 4 structurally. Fact
pack §9 lists the open G0A items, and §9.3 — "which legacy items truly test a
removed concept vs. can be remapped" — is precisely what her review has been
producing evidence for.

---

## Finding 1 — Reviewer unit picker shows the retired 9-unit CED

**Confirmed. Root cause identified in two places.**

The reviewer's unit dropdown is fed by `getUnitsForSubject()` in the production
frontend repo (`david-bloom/exam-buddy-wireframe`):

- `src/data/taxonomy.ts` — `AP_STATISTICS_UNITS` still lists the nine 2020-CED
  units, including "Inference for Quantitative Data: Slopes". Confirmed present on
  `origin/main`, not just on a feature branch.
- `src/routes/_authenticated/reviewer.review.$assignmentId.tsx:166` consumes it;
  line 224 blocks submission when no unit is chosen. That is exactly why Jill
  "couldn't submit the question until I chose" and had to pick a retired unit.

The same app already publishes the **correct** 5-unit structure on its public AP
Statistics pages (`src/routes/ap-statistics.index.tsx`), and one of those pages
explicitly states the old Unit 9 was removed. So the app contradicts itself: the
marketing site is on the new CED, the reviewer tool is on the old one.

**Data impact is small and cheap to repair.** Only 19 Statistics review decisions
carry a `topic_selections.unitId`, and 2 of those point at Unit 9 — a unit that no
longer exists. Nothing else in the schema depends on the Statistics unit numbering.

**Fix:** replace `AP_STATISTICS_UNITS` with the 5-unit list and remap the 19
existing tags. Not applied here — it lands in a different repo, and the remap
should ship together with the taxonomy swap so no tag is orphaned. See Decision D1.

---

## Finding 2 — Not enough multiple-choice questions

**Confirmed.** 16 published MCQs. MCQ is half the exam score and it is the format
students drill most, so 16 is far short of usable for a beta cohort.

There is no blocker here and no prompt defect — the AP Statistics MCQ prompt is
sound and 118 MCQs already exist. The gap is that 60 sit in `draft` and 34 in
`reviewed_approved` without being published. Roughly 94 MCQs are one review pass
and one publish batch away from being live.

Note this interacts with the publication-trust P0 (admin-content publishes before
validating gates) — a bulk publish should not be run until that is settled.

**Fix:** a review-and-publish push on the existing 94, then author to a target
count. Needs a target from the owner. See Decision D2.

---

## Finding 3 — Too many short-answer items that are not exam-format

**Confirmed, and this is the most consequential finding.**

The AP Statistics Short FRQ prompt *already documented this defect at the time it
was written*. Its own header says the 4-point / parts-a–d structure is "Cramapple's
own content-authoring convention... it is not a College Board exam-format claim,
since the real AP Statistics exam does not have a 'Short FRQ' category the way AP
Biology does." The format was copied from AP Biology and applied to a subject whose
Section II is a small number of extended, multi-part, 10-point questions.

The compounding cause: **there is no AP Statistics Long FRQ prompt.** `prompts/content/`
contains a Long FRQ prompt for Biology but only MCQ and Short FRQ prompts for
Statistics. Every Statistics free-response authoring run therefore had only one
path available, and it produced the wrong shape 148 times.

Jill is right that these items "test great concepts" — the defect is the container,
not the statistics. Some are likely salvageable by consolidating several 4-point
items into one exam-shaped extended question.

The approved rebuild already fixes this going forward: fact pack §5 defines the four
10-point archetypes (Q1 Practices 1&2, Q2 Practices 3&4, Q3 Inference, Q4
multi-focus), and `APPROVAL-0036` sets a 70-FRQ target in that shape. What is not
decided is what happens to the **148 existing short FRQs**, 66 of them published.

**Applied:** a hold notice at the top of the Short FRQ prompt blocking new AP
Statistics batches, pointing authors at the fact pack archetypes instead. Biology
is unaffected.
**Still needed:** a disposition for the 148 existing items. See Decision D3.

---

## Finding 4 — Out-of-scope questions

**Confirmed, and broader than reported.** Jill named three topics. The CED fact
pack (see below) lists **five** confirmed removals, so the sweep was run against all
five plus multiple regression. Result: **19** of the 276 Statistics items test
removed or never-in-scope content.

| Content key | Type | Status | Removed topic |
| --- | --- | --- | --- |
| APSTATS-MCQ-008 | MCQ | **published** | combining random variables |
| APSTATS-MCQ-017 | MCQ | **published** | slope inference |
| APSTAT-MOD6-H002-INV | Long FRQ | reviewed_approved | slope inference |
| APSTATS-MCQ-008-CAL | MCQ | reviewed_approved | combining random variables |
| APSTATS-MCQ-018-CAL | MCQ | reviewed_approved | slope inference |
| APSTAT-MOD8-H001 | Long FRQ | assigned | slope inference |
| APSTAT-MOD8-H004 | Short FRQ | draft | slope inference |
| APSTATS-MCQ-048 | MCQ | draft | geometric distribution |
| APSTATS-MCQ-098 | MCQ | draft | slope inference |
| APSTAT-MOD8-VH001 | Long FRQ | reviewed_disapproved | multiple regression |
| APSTATS-MCQ-018 | MCQ | reviewed_disapproved | slope inference |
| APSTATS-SFRQ-015 | Short FRQ | reviewed_disapproved | chi-square goodness-of-fit |
| APSTATS-SFRQ-017 | Short FRQ | reviewed_disapproved | slope inference |
| APSTATS-MCQ-015 / -015-CAL / -016 | MCQ | retired | chi-square goodness-of-fit |
| APSTATS-MCQ-017-CAL | MCQ | retired | slope inference |
| APSTATS-MCQ-086 | MCQ | retired | multiple regression |
| APSTATS-SFRQ-018 | Short FRQ | retired | slope inference |

The review process is working — 10 of the 19 are already disapproved or retired.
**Five need action: 2 published and 3 `reviewed_approved`.** These are not reviewer
misses. They passed review against the old CED, where inference for slope and
combining random variables were legitimate topics — the reviewer tool was showing
the old unit list, so approving them was correct at the time.

**Two of the five are topics Jill did not name:** `APSTATS-MCQ-008` (published) and
`APSTATS-MCQ-008-CAL` test combining random variables, removed in the Fall 2026
revision. Worth telling her, since it means the scope problem is wider than the
three examples she happened to hit.

**A correction to note.** An earlier pass in this session flagged four additional
items for "curved scatterplots." That was wrong, and the fact pack warns against
exactly this conflation: **residual plots and curvature are RETAINED** (new Topic
5.4). Only the old "departures from linearity" framing and the re-expression
machinery (log/power/exponential transformation to achieve linearity) were removed.
An item may still show a residual plot, ask the student to see a pattern, and
conclude a linear model is inappropriate. Jill's phrase "curved scatterplots" is
worth clarifying with her against this distinction before anything is deleted on
that basis.

**Applied:** a hard-exclusion block in both AP Statistics prompts covering all five
confirmed removals plus multiple regression, with the retained/removed boundary on
residuals stated explicitly, and a positive statement of the regression ceiling.
**Still needed:** disposition of the 5 live/approved items. See Decision D4.

---

## Finding 5 — Mosaic plots with equal group totals

**Confirmed, and the underlying defect is worse than reported.**

Seven mosaic-plot items exist, all hand-drawn-graph items (`APSTATS-HDG-2026-GRAPH-*`).
Row sums:

| Item | Status | Group totals | Verdict |
| --- | --- | --- | --- |
| GRAPH-025 | published | 100 / 100 / 100 | **Degenerate** — identical |
| GRAPH-026 | published | 100 / 100 / 100 | **Degenerate** — identical |
| GRAPH-027 | published | 100 / 100 / 100 | **Degenerate** — identical |
| GRAPH-003 | published | 100 / 100 / 80 | **Defective** — two identical |
| GRAPH-023 | published | 100 / 100 / 80 | **Defective** — two identical |
| GRAPH-024 | published | 90 / 115 / 70 | OK |
| GRAPH-009 | retired | 90 / 110 / 100 | OK |

So 5 of 7 are defective and all 5 are published. Jill's "every question" is a
slight overstatement across the full set, but her diagnosis is exactly right: when
group totals are equal the column widths are equal and the mosaic plot *is* a
segmented bar chart.

**A second defect she did not name affects all seven.** Every one ends with a task
of the form "state which group has the largest *number* of X". A mosaic plot
displays conditional proportions; a raw count cannot be read off it, and the
question is answerable straight from the table without drawing anything. So even
GRAPH-024 and GRAPH-009, whose widths are fine, ask the student to read the plot
the wrong way.

**Applied:** graphical-display rules in both AP Statistics prompts requiring
unequal group totals (no two identical, largest ≈1.5x smallest, row sums verified
before emitting), forbidding count-reading questions on mosaic plots, and directing
the author to a segmented bar chart — named correctly — when group totals are equal.
**Still needed:** regeneration of the 5 defective items and a task rewrite on all 7.
See Decision D5.

---

## Addendum — 2026 released FRQs vs. the 2027 format (checked 2026-08-01)

Source: the College Board 2026 AP Statistics free-response set
(`apcentral.collegeboard.org/media/pdf/ap26-frq-statistics.pdf`). **Structure only
is recorded below — no College Board question text, data, or scoring content may be
copied into this repo or into any authoring prompt** (`DECISION-0031`/`0033`).

**Last year's structure:** Section II, 90 minutes, **6 questions**. Suggested pacing
splits ~65 minutes across Q1–Q5 and ~25 minutes on Q6 — Q6 is the extended
Investigative Task. Part depth ranges from a single undivided prompt (Q4) to four
lettered parts with numbered sub-parts (Q5, Q6).

**How the six map onto the 2027 archetypes, and whether the content survives:**

| 2026 Q | Shape | Content area | Maps to 2027 | Scope under the new CED |
| --- | --- | --- | --- | --- |
| 1 | A, B, C(i–ii) | One-variable data, comparing distributions, choice of display | Q2 (Practices 3&4) | **Fully in scope** |
| 2 | A(i–iii), B, C | Experimental design; meaning of statistical significance | Q1 (Practices 1&2) | **Fully in scope** |
| 3 | A, B, C(i–ii), D | Normal, binomial, **geometric** | — | **Partly removed** — the geometric parts are gone |
| 4 | single prompt | Two-sample inference for means, full procedure | Q3 (Inference) | **Fully in scope** |
| 5 | A(i–ii), B(i–ii), C(i–ii), D | Two-way tables, **mosaic plot**, mutually exclusive vs. independent, chi-square appropriateness | Q2 or Q4 | **Fully in scope** (independence chi-square retained) |
| 6 | A(i–ii), B(i–ii), C(i–iii), D(i–ii) | Investigative Task: regression, CI for a mean response, prediction intervals, standard-error structure | Q4 (multi-focus) | **Mostly removed** — Parts C and D are regression inference |

**Verdict: useful as a style model, unsafe as a content model.**

- **Good guide for:** context richness, how parts scaffold from computation to
  interpretation, task-verb discipline, and how much reading a real stimulus carries.
  Four of the six (Q1, Q2, Q4, Q5) are fully in scope and are better exemplars of
  exam-shaped questions than anything currently in Cramapple's bank.
- **Bad guide for shape:** six questions, not four. There is no 10-point question
  anywhere in the 2026 set.
- **Dangerous guide for scope:** 2 of the 6 carry removed content, and the largest
  question in the set (Q6) is mostly built on regression inference, which is exactly
  what the revision deleted. Anyone modelling new items on Q6 would reproduce the
  single biggest scope error.

**This corrects Finding 3 above in one respect.** Old Q1–Q5 were each worth 4 points.
So Cramapple's 4-point Short FRQ was a *reasonable model of the old exam*, not an
arbitrary Biology import — the mismatch is with the **new** exam, where every
question is 10 points and no 4-point question exists. (The old scoring was holistic
0–4 per question rather than 1 point per part, so it was never an exact match.) That
materially improves the salvage case in D3: the 148 items are well-matched to a
format that was just retired, not junk.

**Mosaic plots — the 2026 set contains the exemplar.** Q5 Part B is a mosaic plot
question built the opposite way from Cramapple's on both axes: its three groups have
**strongly unequal** totals, and it asks what the labeled width, height, and area
*represent as probabilities* — marginal, conditional, and joint respectively. That is
the actual teaching point of the display, and it is the standard Cramapple's seven
mosaic items fail. The graphical-display rules in both prompts were rewritten around
this width = marginal / height = conditional / area = joint framing.

**Minor flag:** the 2026 paper carries a note that it was originally administered
digitally. Digital delivery is therefore not new in 2027, which is worth correcting
wherever internal docs describe the 2027 change as the move to digital — the
substantive changes are the unit consolidation, the removals, and the 6x4 → 4x10
FRQ restructure.

---

## Addendum — the archetype designation (answers the "long FRQ" proposal)

**The schema already supports this, and it is better than a long/short binary.**
`app.content_items` carries two fields that AP Statistics has never used:

- `practice_format` — constrained to `targeted_drill` | `full_exam_frq`
- `frq_archetype` — free text, and a table constraint
  (`content_items_full_exam_archetype_check`) enforces that
  `practice_format = 'full_exam_frq'` implies `frq_form = 'long'` **and** a non-empty
  `frq_archetype`.

So "use the long-FRQ designation for questions that combine practices" is already
expressible, and the database will enforce it: an exam-shaped item is
`practice_format='full_exam_frq'` + `frq_form='long'` + an archetype.

**But every one of the 158 AP Statistics FRQs has both fields NULL.** AP Physics,
AP Precalculus, and AP Calculus all populate them; Statistics never has. The
Physics vocabulary in use (Mathematical Routines, Translation Between
Representations, and so on) is subject-specific and does not apply here, while
Precalculus and Calculus use per-subject slugs — the pattern Statistics should follow.

**Recommendation:** define four Statistics archetype slugs matching the College
Board's four question types exactly, rather than overloading `frq_form`:

- `ap-statistics-frq-q1-practices-1-2`
- `ap-statistics-frq-q2-practices-3-4`
- `ap-statistics-frq-q3-inference`
- `ap-statistics-frq-q4-multi-focus`

This turns "make sure we have a mix of inference and multipart" from a judgment call
into a queryable blueprint constraint. Note that **the blueprint already exists**:
`APPROVAL-0036` set the 70-FRQ target as 14 / 16 / 22 / 18 across the four
archetypes (inference-weighted). The approved split and the schema field have simply
never been connected. Doing so also lets `targeted_drill` carry any short-form items
retained under D3, keeping drill content clearly separated from exam simulation.

---

## Addendum — practice-coverage is a hard constraint on Q3 and Q4 (2026-08-01)

**The rule.** College Board's own wording separates the archetypes into two tiers:

- Q1 "**primarily** assesses Practices 1 and 2"; Q2 "**primarily** assesses
  Practices 3 and 4" — the hedge gives latitude.
- Q3 "assessing the inference skills associated with Practices **2, 3, and 4**";
  Q4 "assessing Practices **2, 3, and 4**" — no hedge.

So for Q3 and Q4 the three-practice coverage is **structural, not descriptive**. An
item that is labeled Q3 or Q4 but exercises only two of the three practices is
mis-archetyped, however good the statistics are. It should be re-labeled Q2 or
rewritten — not shipped under a Q3/Q4 tag.

**The trap that makes this easy to get wrong: verifying conditions is Practice 4,
not Practice 2.** Skill **4.E** is "justify a chosen inference method by verifying
conditions." The Practice 2 inference skills are a different set:

| Skill | Practice | Demand |
| --- | --- | --- |
| 2.C | **P2** | identify the appropriate inference method |
| 2.D | **P2** | identify error types and relationships among inference components |
| 2.E | **P2** | identify the null and alternative hypotheses |
| 3.E | **P3** | calculate the inference-method result |
| 4.E | **P4** | justify the method by verifying conditions |
| 4.F / 4.G | **P4** | interpret the result / justify a claim from it |

An author who builds "check the conditions, compute the statistic, interpret it"
will believe they covered P2/P3/P4 and will actually have covered **P3 and P4 only**.
Practice 2 requires the student to *choose the procedure*, *state the hypotheses*,
or *reason about error types* — not to check conditions.

**Applying the rule to the drafted vertical slice** (`e0bf685`,
`docs/research/ap_statistics_2027_vertical_slice_2026_07_13.md`):

| Draft | P2 | P3 | P4 | Verdict |
| --- | --- | --- | --- | --- |
| **Q3** (one-sample t-test) | A hypotheses (2.E); B(i) procedure (2.C); E Type I error (2.D) | C statistic, df, p-value (3.E) | B(ii–iii) conditions (4.E); D decision + conclusion (4.F/4.G) | **PASSES** |
| **Q4** (discrete RV → proportion) | **none** | A(i–ii), C(i–iii) calculations (3.C/3.D/3.E) | B interpret E(X) (4.D); D justify claim (4.B/4.G); E conditions (4.E) | **FAILS** |

**Draft Q4 is mis-archetyped.** It is titled "Multi-Focus on Practices 2, 3 & 4" but
contains no Practice 2 demand: it never asks the student to identify the appropriate
procedure, state hypotheses, or reason about error types. Its Part E ("state one
condition… verify the large-counts condition") is 4.E — Practice 4 — which is
exactly the trap above. As authored it is a Practice 3&4 question, i.e. a Q2 wearing
a Q4 label.

There is a related statistical smell that the same fix resolves: Q4 computes a
standardized statistic comparing a sample proportion to a model **without ever
stating hypotheses**, which leaves the inference half-formed. Adding a P2 part
(state H0/Ha, or identify the procedure and why it applies) both restores the
archetype and tightens the statistics.

Note the slice's Q3 header explicitly tracks "inference across P2/P3/P4" — the
author was holding the constraint for Q3 and dropped it for Q4. That is precisely
the kind of silent drift a mechanical check catches and a human reviewer may not.

**Required authoring rule** (to be added to fact pack §5 and to the AP Statistics
Long FRQ prompt when it is written):

> Every Q3 and Q4 item must carry **at least one part whose primary demand is a
> Practice 2 skill (2.C, 2.D, or 2.E)**, at least one Practice 3 part (3.x), and at
> least one Practice 4 part (4.x). Tag each part with its skill code. Condition
> verification counts as 4.E and does **not** satisfy the Practice 2 requirement.
> An item failing this is re-archetyped, not published under a Q3/Q4 tag.

**Why this should be a machine check, not a review instruction.** Per-part skill
codes make the constraint mechanically verifiable at authoring time. If parts are
tagged, a validator can reject a Q3/Q4 whose skill codes don't span all three
practices — before it reaches Jill. This belongs with the `frq_archetype` work in D6
and with the TASK-0017 harness compiler, which already enforces
`deterministic_check_contracts`. Adding a practice-span check is the same class of
rule.

---

## Addendum — full FRQ classification and counts (2026-08-01)

Every AP Statistics FRQ (158 items, all three content-key prefixes) was classified by
its actual point total and criterion count, taken from `frq_criteria` on each item's
latest version.

### The headline

**Not one of the 158 aligns with the four question types.** The four archetypes are
10-point multi-part questions. **The highest-scoring item in the entire bank is worth
5 points.** Alignment fails on shape before content is even considered, so a strict
"remove everything that doesn't align" would retire 100% of the FRQ pool — including
all 67 published items.

### Counts by category

| Category | Items | Published | In pipeline | Already retired/disapproved |
| --- | ---: | ---: | ---: | ---: |
| **A.** One-point, single-criterion short answer | 90 | 19 | 68 | 3 |
| **B.** Four-point multi-part | 23 | 15 | 4 | 4 |
| **C.** Undersized "long" FRQ (2–5 pt) | 5 | 1 | 3 | 1 |
| **D.** Hand-drawn graph drill (4 pt, `APSTATS-HDG-*`) | 40 | 32 | 1 | 7 |
| **Total** | **158** | **67** | **76** | **15** |

MCQ pool for reference: **118** items (16 published, 34 reviewed_approved, 60 draft,
1 changes_requested, 6 retired, 1 disapproved). Archetypes do not apply to MCQ — the
CED assigns MC a *practice* weighting (P1 5–10%, P2 20–30%, P3 25–35%, P4 25–35%),
so MCQs should be labeled by practice/skill, not by question type.

### Category A is Jill's finding 3, precisely

The 90 one-point items are single-criterion, single-part questions — not FRQs and not
multi-part drills. This is exactly what she described as "not FRQ-type questions but
just ask a question that requires a short answer." A sampling also shows a further
defect: **at least 3 reference a display that does not exist** — stems opening "This
tree diagram shows…", "This residual plot shows…", "This probability distribution
shows…" with an empty `stimulus` and no `stimulus_image_path`. Those are unanswerable
as published.

### Unit labels are also on the retired taxonomy

Separately from the 19 reviewer `topic_selections` noted in Finding 1, the
`content_labels` table defines **AP Statistics Unit 1 through Unit 9** and **200 Stats
items carry those unit labels**, including **22 items tagged to Unit 9** — a unit that
no longer exists. The D1 remap is therefore larger than first scoped: it covers the
label definitions, 200 item taggings, and the 19 review decisions.

### Why "retire everything" is the wrong execution of the right instruction

Categories B and D are legitimate practice content in the wrong container, and the
schema already has the correct home for them: `practice_format = 'targeted_drill'`,
which AP Physics already uses for 112 items. The fact pack §7 further specifies that
hand-drawn work is tagged `supplemental_hand_drawn` and never presented as simulating
the real exam — which is exactly category D's correct disposition, and David's
2026-07-13 ruling was that hand-drawn graph practice **stays in scope**.

Retiring all 67 published FRQs would leave the AP Statistics bank at 16 published
MCQs and nothing else, seven weeks from the beta, with no rebuilt content to replace
them (the rebuild is still gated at G0A and has produced 12 draft items in a markdown
file). Recommended split:

- **Retire category A (90 items).** Not FRQs, not drills, and the source of the
  reviewer complaint. This is the real removal target.
- **Reclassify B, C, D (68 items) as `targeted_drill`**, keeping them available and
  clearly separated from exam simulation, pending replacement by rebuilt content.
- **Assign no Q1–Q4 archetype to any existing item.** The schema constraint requires
  `full_exam_frq` ⟹ `frq_form='long'` + non-empty archetype, and nothing in the bank
  is exam-shaped. Archetype labels become assignable only when rebuilt content exists.

---

## Addendum — next-best-action by question type (design note)

The instinct to route remediation on question type is right, but the tagging should go
one level finer, and that changes what needs to be labeled now.

- **Archetype (Q1–Q4) is the right unit for *readiness reporting*.** "You are ready on
  Q1-style questions, weak on Q3" maps to how the exam is built and how a student
  thinks about it.
- **Practice/skill is the right unit for *next-best-action*.** "Struggling with
  Practice 2 — choosing the procedure and stating hypotheses" is a teachable
  instruction; "struggling with Q3" is not, because Q3 spans three practices and the
  student may be fine at two of them.

The plumbing largely exists: `attempt_criterion_results` already records per-criterion
outcomes. If each criterion carries its CED skill code (2.C, 3.E, 4.E …), then
practice-level diagnosis falls out of data already being captured, with no new
instrumentation. That is the same per-part skill tagging that D7 requires for the
practice-span check — so **D6 and D7 are prerequisites for this feature, not
independent of it.** Tagging criteria with skill codes once buys the archetype
validator and the adaptive engine together.

Worth noting the diagnostic asymmetry: a student failing every Practice 2 criterion
across Q1, Q3, and Q4 has one problem, not three. Only skill-level tagging surfaces
that.

---

## Addendum — pre-cutover unit-tag snapshot (taken 2026-08-01, before the 5-unit picker went live)

> **CUTOVER TIMESTAMP — the boundary this snapshot exists to preserve.**
> The 5-unit picker was published from the Lovable workspace at
> **2026-08-01 23:56 America/New_York = 2026-08-02 03:56 UTC**.
>
> Any AP Statistics unit tag with `submitted_at` / `created_at` **before** that
> instant was recorded against the **retired 9-unit CED**. Anything after it is the
> **5-unit Fall 2026 CED**. This timestamp is the only thing separating the two for
> unit ids 1–5 until the labels are renamed (see the recommendation at the end of
> this section).

The reviewer unit picker switches from the retired 9-unit CED to the 5-unit Fall 2026
CED at the next Lovable publish. **At that moment unit ids 1–5 change meaning** — an
id of `3` denotes "Collecting Data" before the cutover and "Inference for Categorical
Data: Proportions" after — and nothing in the schema records which CED a tag was
written under. This snapshot preserves the boundary while it is still unambiguous.

**State immediately before cutover:**

| Unit id | Item unit-labels | Review-decision tags | After cutover |
| ---: | ---: | ---: | --- |
| 1 | 22 | 4 | **Ambiguous** |
| 2 | 12 | 0 | **Ambiguous** |
| 3 | 26 | 1 | **Ambiguous** |
| 4 | 27 | 1 | **Ambiguous** |
| 5 | 17 | 1 | **Ambiguous** |
| 6 | 27 | 4 | Self-evidently old CED |
| 7 | 26 | 5 | Self-evidently old CED |
| 8 | 21 | 1 | Self-evidently old CED |
| 9 | 22 | 2 | Self-evidently old CED |
| **Total** | **200** | **19** | |

Units 6–9 need no marker — those ids do not exist in the new CED, so any tag carrying
them is unambiguously old. **The at-risk population is units 1–5: 104 item labels and
7 review-decision tags, 111 rows.** After cutover these are separable only by
timestamp (`submitted_at` / `created_at` earlier than the publish).

**Recommended durable fix, cheaper than it looks.** Rename the nine `content_labels`
definitions from `AP Statistics Unit N` to `AP Statistics Unit N (2020 CED)`. That is
**9 rows changed**, and it makes all 200 existing taggings self-describing permanently,
with no per-tagging migration. New-CED labels are then created under distinct names and
can never collide. The 19 decision tags can be marked in the same pass by adding a
`"ced": "2020"` key to their `topic_selections` JSON.

Not done here — it is user-visible in the reviewer and admin surfaces, and it overlaps
fact pack §9.3 (remap rules for removed topics), which is currently with Jill for G0A
sign-off. Recording the snapshot above is sufficient to make the cutover recoverable
either way, so publishing need not wait on it.

---

## Changes applied in this session

Both files in `prompts/content/`:

- `AP Statistics MCQ Prompt.txt`
- `AP Statistics Short FRQ Prompt.txt`

1. **Unit taxonomy replaced** with the 5-unit structure, with an explicit
   instruction never to emit a unit above 5 or use the four retired unit names, and
   a note on where chi-square and sampling distributions now live.
2. **Hard-exclusions block added** — the five confirmed Fall 2026 removals (slope
   inference, chi-square goodness-of-fit, departures-from-linearity and
   re-expression, combining random variables, geometric distribution) plus multiple
   regression, with the retained/removed boundaries stated explicitly (residual
   plots and curvature retained; chi-square homogeneity/independence retained;
   binomial retained) and a positive statement of the regression ceiling.
3. **Graphical-display rules added** — mosaic plot width/total requirement, the
   proportions-not-counts rule, and segmented bar chart as the correct alternative.
4. **Hold notice added** to the Short FRQ prompt (AP Statistics only) blocking new
   batches pending Decision D3.

No content records were modified. No changes were made to the frontend repo.

---

## Decisions needed from the Product Owner

| # | Decision | Notes |
| --- | --- | --- |
| **D0** | **Send Jill the CED fact pack for G0A sign-off.** | Highest leverage by a wide margin. Unblocks the approved rebuild that resolves D2, D3, and most of D4 structurally. The fact pack must first be brought onto a reachable branch — it lives only on `codex/five-subject-harness-and-content`. |
| **D1** | Approve the 5-unit taxonomy swap in the frontend repo, plus a remap of the 19 existing unit tags. | Cheapest fix here, and it blocks correct tagging on every future review. The 2 items tagged to the retired Unit 9 need a judgment call. Should ship before Jill's next review batch. |
| **D2** | Set an MCQ target and authorize a review-and-publish push on the ~94 existing MCQs. | `APPROVAL-0036` already sets 100 MCQ for the rebuilt bank; the open question is whether to publish existing 2025-26 MCQs as an interim measure or wait for the rebuild. Interacts with the publication-trust P0 — confirm a bulk publish is safe first. |
| **D3** | Decide the disposition of the 148 existing short FRQs (66 published). | Options: retire wholesale in favor of rebuilt 10-point FRQs; keep as a clearly labeled drill format distinct from exam practice; or consolidate groups of them into 10-point archetype questions to salvage the statistics. Jill's view is worth having — she called the concepts good and the format wrong. |
| **D4** | Approve retiring the 5 out-of-scope items that are published or approved. | Published: `APSTATS-MCQ-008`, `APSTATS-MCQ-017`. Approved: `APSTAT-MOD6-H002-INV`, `APSTATS-MCQ-008-CAL`, `APSTATS-MCQ-018-CAL`. Also worth clarifying "curved scatterplots" with Jill first — residual curvature is retained. |
| **D7** | Adopt the Q3/Q4 practice-span rule and enforce it mechanically via per-part skill codes. | Draft Q4 in the existing vertical slice already fails it. Cheapest to fix now, before bulk authoring generates 70 FRQs with the same drift. Pairs with D6. |
| **D6** | Adopt the four `frq_archetype` slugs for Statistics and connect them to the `APPROVAL-0036` 14/16/22/18 split. | Schema already supports and enforces it; all 158 Stats FRQs are currently NULL on both `frq_archetype` and `practice_format`. Makes "a mix of inference and multipart" enforceable rather than aspirational. Cheap, and should land before bulk authoring starts. |
| **D5** | Approve regenerating the 5 defective mosaic items and rewriting the task on all 7. | The task rewrite matters more than the width fix — the count-off-a-proportions-plot defect affects all seven, including the two whose widths are fine. |

Risk context: there are no active students, so none of this has live learner
exposure, which lowers the tier on every item above.

---

## Suggested reply to Jill

Worth telling her directly that all five were confirmed, since a reviewer who sees
findings acted on keeps reporting them:

- The unit list is a real bug in the reviewer tool, not her misreading it — fix queued.
  Thank her specifically; without the report it would have kept silently corrupting tags.
- More MCQs: agreed, ~94 are already authored and awaiting a review-and-publish push.
- The short-answer format: she identified a genuine authoring-architecture mistake.
  New batches are on hold, and the rebuilt bank will use the real 4 × 10-point shape.
- Out-of-scope items: 19 found across five removed topics — two more than she named
  (combining random variables, geometric distribution). Most were already caught by
  her own reviews; the prompts now hard-exclude all of them.
- One thing to check with her: "curved scatterplots." Residual plots and curvature
  are **retained** in the new CED (Topic 5.4) — what was removed is the
  departures-from-linearity framing and transformation to achieve linearity. Worth
  confirming which of the two she was seeing before anything is deleted on that basis.
- Mosaic plots: confirmed, and her instinct extends further — every mosaic item also
  asks students to read a raw count off a proportions display, which is being
  rewritten too.

**The ask worth making of her:** she is the G0A sign-off for the CED fact pack, and
the entire Statistics rebuild is waiting on it. Her five findings show she is
already reviewing against the new CED in her head. Getting the fact pack in front of
her is a better use of her next hour than another batch of 2025-26 items.
