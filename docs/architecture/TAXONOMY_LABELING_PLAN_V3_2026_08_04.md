# Taxonomy Labeling Plan — v3 (amended)

**Amends:** the CED unit-labeling plan drafted for the AP Biology tagging pilot.
**Date:** 2026-08-04
**Status:** Revised per Codex review. Ready for execution subject to §11.

## Revision 3 changelog (Codex review response)

Codex approved the direction and asked for T2/T4 revision before execution. All
six points are accepted; three are strengthened by a new measurement.

| Codex point | Disposition | Where |
|---|---|---|
| Keep taxonomy outside `prompt_json` | **Accepted**, unchanged from v2 | T2 |
| Store labels against content item **plus source version/hash** | **Accepted with a correction** — `content_hash` is unfit for this purpose; define a taxonomy-relevant hash | T2 `[REVISED v3]` |
| Split serving labels from coverage labels | **Accepted, and now empirically load-bearing** | T9 `[NEW v3]` |
| Criterion-level required-unit labeling as the primitive | **Accepted**, with a rubric-quality precondition | T4 `[REVISED v3]` |
| GPT-5.5 + Gemini agreement as first automation lane | **Accepted for units only — not for topics** | T6.b `[REVISED v3]` |
| DeepSeek optional pending timeout/prompt work | **Accepted**, no change needed | T5.d |

**[MEASURED] The finding that drives the v3 changes.** Re-scoring the pilot for
GPT-5.5 + Gemini only (18 of 20 items where both calls succeeded):

| Agreement level | Rate |
|---|---|
| `required_units` identical | **16/18 = 89%** |
| `required_topics` identical | **8/18 = 44%** |

The two-model lane is strong at **unit** granularity and roughly a coin flip at
**topic** granularity. Units are 8 coarse buckets; topics are 61 fine ones, and
the models split on granularity calls (e.g. whether `3.3 Cellular Energy`
accompanies `3.5 Cellular Respiration`).

This maps exactly onto Codex's serving/coverage split and decides which side can
be automated:

- **Serving labels need units** (`max_required_unit`) → automatable, 89% lane.
- **Coverage labels need topics** (§10.1 targets are per-topic) → **not
  automatable at current agreement**; human validation required.

The two unit-level splits were `APBIO-FRQ-L-012` and `APBIO-FRQ-L-016` — the same
two items flagged in T4 as definitional disputes. Disagreement continues to track
difficulty, which is the property the triage lane depends on.

## How to read this document

Every step is tagged so the delta from v1 is unambiguous:

| Marker | Meaning |
|---|---|
| `[UNCHANGED]` | v1 text stands as written. Execute as planned. |
| `[AMENDED]` | v1 step modified. The change and its reason are stated inline. |
| `[NEW]` | Step that did not exist in v1. |
| `[BLOCKING]` | Must complete before later steps; blocks what it names. |

Amendment IDs are `T1`–`T8`. Step IDs are `S0`–`S7`. Reference these in review.

---

## 0. Why v1 needs amending

v1 is a sound protocol for labeling a question **for the first time**. Since it
was drafted, production measurement showed the problem is not greenfield.

**[MEASURED] 2026-08-04, read-only against `pcntajvbdfqhbeewmdry`:**

- AP Biology: **289 of 307** topic-tag instances (94.1%) match no topic in the
  verified Fall 2025 CED. **174 of 181** versions carry at least one invalid tag.
  147 distinct tag strings exist for a course with 61 topics.
- AP Statistics: same shape — 146 distinct tag strings across 177 versions.
- Tags are stored in `app.content_item_versions.prompt_json->'subtopics'` and
  `->'modules'`.
- Examples: `5.1 Mendelian Genetics` (CED 5.1 is Meiosis), `3.4 Cellular
  Respiration` (CED 3.4 is Photosynthesis), `8.5 Biogeochemical Cycles` (does not
  exist), `1.1 Enzyme Structure and Catalysis` (enzymes are Unit 3),
  `enzyme activity` (not topic-formatted).

**[MEASURED] Blast radius is currently zero for learners but non-zero for the
system.** `app.home_release_manifest` has 2 rows with `allowed_unit_numbers` set
and `public.set_course_position` exists, so unit-gated serving is built — but
`app.student_course_positions` has **0 rows**, so no learner is being served
through it today. **Codex should re-verify this independently (S0.3); the whole
sequencing below assumes it.**

Detail: `docs/research/TAXONOMY_PILOT_LEARNINGS_2026_08_04.md`.

---

## 1. `[AMENDED]` T1 — Make the CED Fact Pack the only taxonomy source

v1 text stands. Two additions:

**T1.a — Registry carries a confidence tier.** Each subject's registry row
records `taxonomy_confidence: verified | provisional`, where `verified` means
checked against the College Board CED PDF this cycle with a citation (document
title, effective year, page).

- AP Biology is **`verified`** as of 2026-08-04 (CED Effective Fall 2025,
  pp. 17, 20–22, 197–203).
- The other eight subjects are **`provisional`** — their fact packs have not been
  re-checked against source this cycle.

**T1.b — A `provisional` registry may flag but never reject.** Labeling against
an unverified list will manufacture false corrections. Where the registry is
provisional, a mismatch raises a human-confirmation flag; it does not overwrite
or invalidate a label.

**Why:** the Biology fact pack itself listed four non-existent topics until
corrected on 2026-08-04. An unverified reference treated as authoritative is more
dangerous than a missing one, because abstention is at least visible.

**Canonical table** (v1 fields, plus):

```
subject, school_year, unit_number, unit_title, topic_code, topic_title,
taxonomy_source_version, taxonomy_confidence, source_citation
```

---

## 2. `[NEW]` `[BLOCKING]` T2 — Move taxonomy out of the immutable content version

**Blocks:** S4, S5, S6.

Taxonomy currently lives in `content_item_versions.prompt_json`. Under
`CONTENT_GOVERNANCE_AND_VALIDATION.md` §10.2 step 8, "each revision creates a new
immutable version and repeats affected reviews." **Correcting a tag would
therefore create a new content version and re-open content review — roughly 351
re-review cycles for metadata that never touched a question.**

v1's rule "never overwrite old taxonomy silently; create a new version" is
correct in intent but unaffordable where the field currently sits.

**Amendment `[REVISED v3]`:** store taxonomy in its own append-only label table
keyed to the **content item**, versioned independently of content, **and record
the content state the label was validated against** (Codex point 2).

```
content_item_id              -- NOT content_item_version_id: label survives repairs
label_version                -- append-only; supersedes, never overwrites
validated_against_version_id -- the content version a human actually validated
validated_against_taxo_hash  -- see T2.a; NOT content_hash
label_scope                  -- 'serving' | 'coverage'   (T9)
required_units[]             -- serving scope
max_required_unit            -- derived = max(required_units)
assessed_topics[]            -- coverage scope; exact registry topic_code values
primary_unit                 -- nullable; teaching home only, never an eligibility input
required_units_by_criterion  -- jsonb; the T4 primitive: [{criterion_id, units[], evidence}]
taxonomy_source_version      -- FK to registry version
taxonomy_confidence          -- copied from registry at write time
label_status                 -- legacy_unvalidated | provisional_model | validated | stale | held
validated_by, validated_at, validation_decision_id
superseded_by                -- nullable FK to the label_version that replaced it
```

### T2.a `[NEW v3]` — do not use `content_hash` for staleness

Codex is right that a label must record the content state it was validated
against. **But the existing `content_hash` column cannot serve that purpose.**

**[MEASURED]** Of 49 matched (defective → repaired) version pairs, **11 had an
identical `content_hash` across the repair** while `frq_criteria` changed — and
at least one (`APBIO-FRQ-L-038`) also changed `stimulus` and
`canonical_answer_1` with the hash unmoved. `content_hash` does not cover
`frq_criteria`, `stimulus`, or `canonical_answer`.

Using it for staleness would silently fail to detect **rubric changes** — which
is precisely what T4's criterion-level labeling depends on. Define instead:

```
taxonomy_relevant_hash = hash(
  stem, stimulus,
  prompt_json minus taxonomy keys,
  canonical_answer_1, canonical_answer_2,
  mcq_choices (key + text + is_correct),
  frq_criteria (full row set)
)
```

**Staleness rule:** when a new content version's `taxonomy_relevant_hash`
differs from `validated_against_taxo_hash`, set `label_status = 'stale'`. Stale
is **not** invalid — it is *not servable under unit gating* and *queued for
re-validation*. Most repairs will not change required units; the point is that
the system knows it has not checked.

See also the standing production issue on `content_hash` coverage, which is
independent of this plan.

**Consequences (unchanged from v2):**
- Label corrections do **not** create content versions or re-open content review.
- Append-only provenance is preserved as v1 required.
- `prompt_json.subtopics` / `->'modules'` become **read-only legacy**. Do not
  write to them again. Do not delete them yet (S0.2).

---

## 3. `[NEW]` `[BLOCKING]` T3 — Containment before remediation

**Blocks:** any use of taxonomy for coverage reporting or serving.

v1 has no step for the labels already in production.

- **S0.1** Backfill every existing tagged version into the T2 label table with
  `label_status = 'legacy_unvalidated'`. Do not attempt correction in this step.
- **S0.2** Mark `prompt_json.subtopics` / `modules` as non-authoritative in
  documentation and in any consuming code path. Leave the data in place as an
  audit trail.
- **S0.3** **Verify the blast-radius claim independently**: confirm
  `student_course_positions` is empty, and confirm what
  `home_release_manifest.allowed_unit_numbers` is compared against. If any live
  path resolves unit eligibility from `prompt_json`, that is an incident and
  escalates ahead of everything else in this plan.
- **S0.4** Adopt v1's fail-closed rule explicitly and record it as a decision:
  **`legacy_unvalidated` labels are not servable for unit-gated practice.** In
  practice this makes essentially all Biology and Statistics content non-servable
  under unit gating until remediated. That is the intended conservative posture,
  not a regression.

---

## 4. `[AMENDED]` T4 — Define "required to answer" as a decidable test

v1 says "`required_units`: all units needed to answer correctly" without defining
"needed." **[OBSERVED]** that is exactly where the pilot models split, and it was
definitional rather than a knowledge gap:

- `APBIO-FRQ-L-013` — is *Mechanisms of Transport* required to trace organelle
  sequence in secretion? GPT-5.5 included it with a caveat; Gemini excluded it.
- `APBIO-FRQ-L-016` — is Unit 8 required for a hypothalamus/feedback item?
  Gemini included it; GPT-5.5 did not.

Human reviewers will split the same way and produce inconsistent labels from a
correct-looking process.

**Amendment — adopt this operative definition:**

> A unit is **required** if a student who has not covered that unit could not
> earn full credit — evaluated **criterion by criterion against the rubric**
> (or, for MCQ, against the keyed answer and each distractor refutation).

Rules that follow:
- Decide from the rubric, not from what the question is "about."
- A concept that appears only as scenario dressing, and is not needed for any
  credit, is **not** required.
- `primary_unit` is the teaching home and is **never** an eligibility input
  (v1 rule retained, `[UNCHANGED]`).
- `max_required_unit` is derived, not asserted (v1 rule retained).

Both the model prompt and the reviewer rubric must state this definition
verbatim, so the two are scored against the same standard.

### T4.a `[REVISED v3]` — the criterion is the labeling primitive

Codex point 4 accepted, and it makes the definition above **self-enforcing**
rather than merely stated. Label each rubric criterion with the units it
requires; derive the item label:

```
required_units      = union(criterion.units)
max_required_unit   = max(required_units)
```

Store the derivation in `required_units_by_criterion`. Do not discard it — the
definition already demands criterion-level reasoning, so persisting it costs
nothing and buys three things:

1. **It resolves the disputes rather than defining them away.** "Is Unit 8
   required for `APBIO-FRQ-L-016`?" becomes "*which criterion* requires Unit 8?"
   If no criterion awards credit for it, the answer is no, and the disagreement
   is settled by inspection instead of argument.
2. **Disagreement localises.** Two reviewers (or two models) who differ now
   differ at a named criterion, which is reviewable. Item-level disagreement is
   not.
3. **It makes the label auditable** against the artifact it was derived from.

**MCQ mapping.** MCQs have no `frq_criteria`. The equivalent criterion set is:
the keyed-answer justification, plus one refutation per distractor — exactly the
structured fields proposed in amendment A2 of
`CONTENT_GOVERNANCE_AMENDMENT_PROPOSAL_2026_08_04.md`. Where those fields do not
yet exist, label MCQs at item level and mark
`required_units_by_criterion = null`, rather than inventing criteria.

### T4.b `[NEW v3]` `[BLOCKING]` — rubric quality is a precondition

Criterion-level labeling inherits rubric defects. **[MEASURED]** rubric/prompt
misalignment is the single largest FRQ first-pass failure class — items where
"the rubric separately requires" something the prompt never asks for, or where
mandatory subparts referenced by the rubric are absent from the stem.

**Labeling a broken rubric produces a broken label.** Run preflight rubric checks
(A1 checks 4–7: every criterion maps to a prompt part; every prompt part has a
criterion; no criterion scores an unasked operation) **before** criterion-level
labeling. An item failing those checks is routed to repair, not to labeling.

This is a sequencing dependency Codex's point 4 did not name, and it blocks S5
for FRQs.

---

## 5. `[AMENDED]` T5 — Generate provisional labels (v1 step 1)

v1 stands, with four corrections to the pilot harness.

**T5.a `[BLOCKING]` — Use real question packets, not excerpts.** The pilot fed
hand-written summaries (`'Michaelis-Menten data; determine Km and Vmax; …'`).
The models flagged this themselves: *"Full FRQ prompts are not provided."* A
summary already encodes a human's topic judgment, so the pilot did not measure
labeling from question content. Use full stem, stimulus, choices, rubric,
canonical answers — the reviewer-experiment extractor already produces this shape.

**T5.b — Withhold existing tags from the prompt.** The pilot included
`existing_modules` / `existing_subtopics` in the packet. Since those are 94%
wrong, agreement with them cannot validate anything, and the model is anchored on
the value under test. Withhold for measurement. (A separate *remap* mode may show
them, but its output must never be scored as agreement.)

**T5.c — Separate call health from item risk.** 12 of 60 pilot calls failed
(DeepSeek 10/20, Gemini 2/20), and each surfaced as `risk_flags: model_failure`
**on the item** — so 12 of 20 items appeared risk-flagged when the content was
fine and the harness broke. Report call health in a separate column. Require
**≥2 successful calls** before assigning any reconciliation status, and report the
denominator: `2-of-2` must not be labelled the same as `2-of-3`.

**T5.d — Do not use model confidence for anything.** **[MEASURED]** pilot
confidence clustered 0.90–1.00 including on disagreements (L-012: Gemini
`confidence = 1` for units `1,3`; GPT-5.5 `0.98` for unit `3`). This is the third
independent corpus showing self-reported confidence carries no signal — the
reviewer experiment recorded 27 of 27 false publishes at `confidence: high`.
Keep collecting the field; exclude it from every routing and gating rule.

DeepSeek at a 50% failure rate is not usable in this harness as configured —
fix or replace before the full run.

---

## 6. `[AMENDED]` T6 — Validation pass (v1 step 2)

v1 requires a reviewer on every item, with a second reviewer for high-risk,
multi-unit, or low-confidence items. Two amendments.

**T6.a `[NEW]` — Measure the reviewers before trusting them.** v1 treats reviewer
output as ground truth. **[MEASURED]** in the reviewer experiment, a genuinely
broken item (ethanol/water azeotrope) was approved by **8 of 12 human reviewers**.
There is no basis for assuming taxonomy judgment is more reliable — particularly
since humans produced the current invalid tags.

Before bulk validation: **~40 items, two reviewers, blind to each other and to
existing tags**, scored under the T4 definition. Measure inter-rater agreement on
(a) unit set and (b) multi-unit vs single-unit. If agreement on multi-unit labels
is poor, adjudication becomes the default rather than the exception, and v1's
staffing assumption needs revising. This gold set is also the ground truth for
scoring T5 and calibrating T6.b.

**T6.b `[AMENDED]` — Triage by model agreement instead of reviewing all 351.**

Note the reasoning, because it deliberately differs from the position taken in
the AI reviewer experiment. There, model agreement was judged weak evidence for
*clearing* content: defect detection is unbounded search, so "all models found
nothing" is mostly evidence that nothing was looked for hard enough. Taxonomy is
**closed-set classification** against a 61-item list where each model makes a
*positive* assertion — independent agreement on a positive assertion is real
evidence. **[OBSERVED]** the pilot supports this: models agreed on clear
single-unit items and split precisely on the genuinely ambiguous multi-unit ones,
so disagreement tracked difficulty.

**`[REVISED v3]` — the automation lane covers UNITS ONLY, not topics.**

Codex proposed GPT-5.5 + Gemini agreement as the first automation lane. Accepted,
with a scope limit the measurement requires:

**[MEASURED]** on the 18 pilot items where both models succeeded — unit-set
agreement **16/18 (89%)**, exact topic-list agreement **8/18 (44%)**.

At 44%, topic-level agreement is close to a coin flip and cannot support an
automation lane. Unit-level agreement at 89% can. Therefore:

| Label | Granularity | Lane |
|---|---|---|
| `required_units` / `max_required_unit` (**serving**, T9) | 8 units | **Automatable** — two-model agreement |
| `assessed_topics` (**coverage**, T9) | 61 topics | **Human validation required** |

Proposed routing for the serving lane, to be **calibrated against the T6.a gold
set before use**:

| Condition | Route |
|---|---|
| Both models succeed, identical `required_units`, single unit | Spot-check sample (target ~20%) |
| Both models succeed, identical `required_units`, multi-unit | Full human validation |
| Models disagree on unit set | Full human validation |
| <2 successful calls | Re-run; do not assign a status |
| Subject registry is `provisional` | Full human validation |
| **Any** `assessed_topics` (coverage) label | **Full human validation** |

Note the two-model design has **no tiebreaker**: agreement is unanimity of two,
so a correlated error has no third vote to catch it. This is why the spot-check
sample on the auto lane is not optional, and why multi-unit agreement still
routes to a human — **[MEASURED]** both pilot unit-level splits (`L-012`,
`L-016`) were multi-unit boundary calls.

Do not adopt the triage until the gold set shows the spot-check lane's error rate
is acceptable. If it is not, fall back to v1's review-everything.

---

## 7. `[UNCHANGED]` Write canonical labels (v1 step 3)

v1's write rules stand, with fields as specified in T2. Restated for completeness:

- Write only after validation.
- `required_units`, `max_required_unit`, `primary_unit`, `required_topics`,
  `taxonomy_source_version`, `validated_by`, `validated_at`,
  `validation_decision_id`.
- Use exact registry `topic_code` values, never free text.

**All v1 safety rules are retained unchanged:**

- Never infer eligibility from `primary_unit`.
- Never overwrite old taxonomy silently — append a new label version.
- Treat missing/uncertain units as not servable for unit-gated practice.
- Use exact CED unit/topic IDs, not free-text labels.
- Model suggestions are auditable but may never publish a label without human
  validation.

---

## 7a. `[NEW v3]` T9 — Split serving labels from coverage labels

Codex point 3, accepted. The measurement in the changelog shows this is not only
a modelling nicety — it determines what can be automated.

The two labels answer different questions and must not share a field:

| | **Serving label** | **Coverage label** |
|---|---|---|
| Question | What must a student have covered to answer this? | What does this item count toward? |
| Derived from | Every criterion's prerequisite units | The units/topics the rubric awards credit for |
| Field | `required_units[]`, `max_required_unit` | `assessed_topics[]` |
| Granularity | Unit (8) | Topic (61) |
| Automation | Two-model agreement lane (89%) | Human validation (44% model agreement) |
| Counting | n/a | **Counts once**, toward the assessed topic(s) |

**The distinction that matters:** *required* ≠ *assessed*. `APBIO-FRQ-L-017`
(insulin / GLUT4) **requires** units 1, 2, 3, 4 to answer — so it gates at unit 4.
But it **assesses** signal transduction; Unit 1 protein structure is prerequisite
background, not what earns the credit.

**Why conflating them corrupts §10.1 coverage.** If a multi-unit item counted
toward every required unit's target, one hard item would fill four slots across
four units and coverage would inflate. Coverage counts an item once, against what
it assesses.

**Rule:** coverage targets are computed from `assessed_topics` only. Serving
eligibility is computed from `max_required_unit` only. Neither field may
substitute for the other, and `primary_unit` is an input to neither.

---

## 8. `[NEW]` T7 — Close the authoring path

Remediation without prevention re-accumulates the defect.

- Add a **closed-list topic-tag check** to authoring preflight: a tag not present
  in the `verified` registry for that subject fails before a human reviews the
  item. This is amendment A1 checks 15–16 in
  `CONTENT_GOVERNANCE_AMENDMENT_PROPOSAL_2026_08_04.md`, and it is the cheapest
  check in that proposal — a closed-list lookup against a 94%-defective field.
- Require the author to declare `required_units` **with per-unit justification at
  authoring time**, under the T4 definition. The pilot's `evidence_by_unit`
  structure is a good template. This makes tagging an authored specification the
  author owns, not metadata applied afterwards.

---

## 9. `[NEW]` T8 — Recompute coverage and report the delta

This is the business output and v1 does not name it as a deliverable.

`CONTENT_GOVERNANCE_AND_VALIDATION.md` §10.1 targets "all 60 official public
topics… at least ten approved MCQs and five approved short-FRQ prompts" per
topic. **[INFERRED]** that target is currently tracked against a taxonomy that
does not map to the CED, so reported coverage is unreliable in both directions —
real gaps may be hidden and phantom coverage may be claimed.

On completion, recompute coverage against validated labels and report the delta
against previously-reported coverage. Expect surprises; they are the point.

---

## 10. Execution order

| Step | Content | Gate |
|---|---|---|
| **S0** | T3 containment (S0.1–S0.4), incl. independent blast-radius check | `[BLOCKING]` |
| **S1** | T2 label table incl. `label_scope` + `taxonomy_relevant_hash` (T2.a); stop writing `prompt_json` taxonomy | `[BLOCKING]` for S4+ |
| **S2** | T1 registry with confidence tier; T7 preflight check | |
| **S3** | T4 definition + T4.a criterion primitive written into model prompt and reviewer rubric | `[BLOCKING]` for S4, S5 |
| **S3b** `[NEW v3]` | T4.b rubric preflight (A1 checks 4–7) over all FRQs; route failures to repair, not labeling | `[BLOCKING]` for S5 (FRQ only) |
| **S4** | T6.a gold set: 40 items, 2 blind reviewers, inter-rater agreement — **scored separately for units and topics** | `[BLOCKING]` for S6 |
| **S5** | T5 model run over full set — real packets, tags withheld, GPT-5.5 + Gemini | |
| **S6** | T6.b triage calibrated on S4: serving/unit auto lane + spot-check; **all coverage/topic labels human-validated** | |
| **S7** | T8 coverage recomputation from `assessed_topics` and delta report | |

S1, S2, and S3 may run in parallel after S0. S3b may run in parallel with S1–S3.

**`[NEW v3]` Expected human load.** **[MEASURED]** 89% unit agreement implies
roughly 10–15% of items route to human on the serving lane, plus a ~20%
spot-check — but **100% of coverage/topic labels need human validation** at
current model agreement. Codex should size S6 on the topic side, not the unit
side; that is where the cost sits. If topic-level coverage is not needed for the
first release, deferring it removes most of the human effort in this plan —
see question 7.

---

## 11. Questions for the Product Owner

1. **T2** — is moving taxonomy out of `prompt_json` into a separate label layer
   acceptable? It is the difference between ~351 content re-reviews and none, and
   it blocks S4 onward.
2. **T4** — is the rubric-based definition of "required" the right one for
   serving? It is deliberately narrow: scenario dressing that earns no credit
   does not count.
3. **T6.b** — is agreement-based triage acceptable in principle for taxonomy,
   given the reasoning in §6 for why it differs from the publish-gate case? If
   not, S6 reverts to reviewing all 351.
4. **S0.4** — confirm that making all Biology and Statistics content non-servable
   under unit gating during remediation is acceptable.
5. **Ownership** — who owns CED registry currency per subject, and who
   re-verifies each August when College Board publishes revisions? Eight of nine
   subject packs are currently `provisional` with no named owner.
6. **Root cause** — how did 147 invented Biology topic strings enter production,
   and does that path still exist? T7 closes the authoring route; it does not
   close an ingest or migration route if one was used.
7. **`[NEW v3]` Is topic-level coverage needed for the first release?**
   **[MEASURED]** model agreement is 89% on units but 44% on topics, so every
   topic label needs a human. Serving (`max_required_unit`) needs units only.
   If §10.1 per-topic coverage reporting can wait, deferring `assessed_topics`
   removes the large majority of human effort in this plan and unblocks
   unit-gated serving much sooner. If it cannot wait, S6 should be staffed for
   ~351 human topic validations.
