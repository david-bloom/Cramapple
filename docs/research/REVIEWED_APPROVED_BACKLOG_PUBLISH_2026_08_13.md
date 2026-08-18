# Reviewed-approved backlog publish — 2026-08-13

**Trigger:** Owner request to "run a publication protocol" — the standing process this
repo uses is documented in `CONTENT_AUTHORING_AND_QA_PROTOCOL.md` §7.2 (P0-B publish
gate) and §9 (independent re-derivation, a publish precondition), and the closest
precedent is `REVIEWED_APPROVED_BACKLOG_PUBLISH_2026_08_09.md`. This run follows the
same method at a much smaller scale (24 items vs. 167).

**Scope:** Production (`pcntajvbdfqhbeewmdry`).

## 1. Backlog size

42 `content_items` at `status='reviewed_approved'`:

| Bucket | n |
|---|---:|
| `review_status='question_review_approved'` (genuinely ready) | 24 |
| Intermediate (`difficulty_discussion` 9, `ap_reader_pending` 7, `tutor_review_pending` 2) | 18 |

Only the 24 are publishable per the P0-B allowlist gate. The 18 intermediate items are
correctly still mid-review — out of scope, not a bug.

**Structural pre-check on the 24** (competing published versions, MCQ choice/correct
counts, FRQ point values): all clean, matching the 08-09 precedent's finding that
structural checks rarely catch anything §9 doesn't also need to check.

## 2. §9 independent re-derivation

Ran across 3 parallel agents, grouped by subject (AP Statistics 11 items; AP Physics C
E&M+Mechanics 6 items; AP Physics 1 + AP Chemistry 7 items), each independently
re-solving every item from scratch before comparing to the stored answer key/rubric —
same method as the 08-09 pass and CED_PROTOCOL §9.2.

**Result: 23/24 clean, 1 defect.**

- `apphycem-frq-050` (AP Physics C: E&M FRQ) — the `b-justification` criterion's
  `learner_facing_text` and `minimum_fix` both claimed the field's denominator
  "(z²+a²)^(3/2) grows faster than the numerator as a increases." This is physically
  false: the numerator (kQz) has no dependence on `a` at all — only the denominator
  changes. The item's numeric answers and predictions (E ≈ 1.15×10³ N/C → ≈4.32×10²
  N/C, decreasing) were already correct; only this one justification's wording embedded
  the false claim.

No other defects — no wrong answer keys, no unit/dimensional errors, no self-contradictory
rubric text, no criteria mismatched to their stem — across AP Statistics (11), the other
5 AP Physics C items, all 6 AP Physics 1 items (specifically checked for the
dimensional-analysis distractor pattern flagged in a prior sweep — did not reproduce
here), or the AP Chemistry item.

## 3. Repair

Standard insertion discipline (new version, never edit in place):
`apphycem-frq-050`'s `b-justification` criterion corrected to state the numerator has no
`a`-dependence and only the denominator grows; `evidence_requirements` was already
correctly worded and left unchanged. Re-approved via `owner_remediation_approval`,
landed back at `reviewed_approved`/`question_review_approved`.

Also backfilled `apchem-frq-l-012`'s `practice_format` (was `NULL` with `frq_archetype`
also `NULL` — identical case to 15 items fixed the same way in the 08-09 backlog publish;
set to `'targeted_drill'`).

## 4. Publish

First attempt failed the `content_pipeline_guard_publish` trigger:
`cannot publish from status retired (must be reviewed_approved)`. Root cause:
`apchem-frq-l-012`'s only live version (v2) had `review_status='question_review_approved'`
and the parent `content_items.status` was already `'reviewed_approved'`, but the
**version row itself** was stuck at `status='retired'` — a stale-status inconsistency
(the mirror image of the item-level stale-retired bug found in the 08-09 pass, this time
on the version row instead of the item row). No content was wrong — `apchem-frq-l-012`
had already cleared §9 clean — only this one field. Corrected `civ.status` to
`reviewed_approved` to match its own `review_status` and the parent item's status
(verified v1 was genuinely superseded/`modification_reserved`, not a competing
candidate), then retried.

**Second attempt: all 24 published successfully.**

## 5. Re-verification

- Duplicate published versions per item: **0**
- Published MCQs with a choice-count desync (≠4 choices): **0**
- Remaining `reviewed_approved`+`question_review_approved` backlog: **0**
- All 24 targeted items confirmed `status='published'`: **24/24**

**P0-B net check (`status='published'` AND `review_status IN ('excluded',
'modification_reserved')`) returned 3, not 0.** Investigated immediately — **none of the
3 are from this publish batch**: `APBIO-HDG-2026-GRAPH-010`, `APBIO-MCQ-095`,
`apphy2-mcq-015`. These are pre-existing, unrelated to today's work — most recently
touched 2026-08-12/13, after the 2026-08-12 sweep's own P0-B check reported 0 rows
(`REVIEWER_QA_SWEEP_2026_08_12.md`), meaning new reviewer findings against already-
published content landed in the ~24-48 hours since that check, via the same mechanism
documented there (the 08-09 gate fix lets re-review findings on published items get
written down instead of erroring out). **Not investigated or repaired this pass** — each
needs its own look at the actual reviewer finding behind it, which is separate work from
today's backlog-publish task. Flagged as a follow-up below.

## 6. Follow-ups

- **New P0-B finding, 3 items, needs its own pass:** `APBIO-HDG-2026-GRAPH-010`,
  `APBIO-MCQ-095`, `apphy2-mcq-015` — published content with an open exclusion/
  modification-reserved finding against it. Check each item's actual
  `content_review_decisions` note to see what was flagged before deciding on a fix,
  same method as the 2026-08-12 sweep's 17-item remediation.
- Everything else already logged as open in `REVIEWER_QA_SWEEP_2026_08_12.md`'s
  follow-ups remains open and untouched by this pass (08-10 P0-B items, 08-10
  disapprovals, AP Physics C: Mechanics gold-set review backlog, topic-selection-
  compliance gap, the 18-item intermediate-review-status backlog from §1 above).

## 7. Follow-up remediation (2026-08-13, same day) — the 3-item P0-B finding closed

Pulled each of the 3 items' actual `content_review_decisions` note and independently
assessed whether the finding was real before fixing anything.

- **`APBIO-HDG-2026-GRAPH-010`** (Sarah Sohail, `disapprove`) — **confirmed real.** The
  item (a hand-drawn-graph FRQ: plot 9 points, label axes, sketch a trend line, describe
  the correlation) tested only generic scatterplot mechanics, with no AP-Biology-specific
  reasoning required anywhere in the rubric. Added a 5th criterion
  (`BIOLOGICAL_INTERPRETATION`, 1pt) requiring the student to explain forage biomass as a
  limiting resource for the rabbit population's carrying capacity; reworded the
  stem/stimulus to ask for it; total points 4 → 5.
- **`APBIO-MCQ-095`** (Sarah Sohail, `approve_with_edits`) — **confirmed real, two
  issues.** Choice A's rationale claimed "conservation of energy applies to physics, not
  ecological energy transfer efficiency" — false; energy is always conserved, ecological
  efficiency describes how much is *retained as biomass* (~10%) vs. lost as heat/waste at
  each trophic transfer. Corrected the rationale to state this accurately without changing
  the choice text (the misconception it represents is still the intended distractor).
  Separately, choice D's stated value (0.1 kcal/m²/year) was arithmetically inconsistent
  with its own (flawed) reasoning — "one extra 10% step from the sun" actually yields 1
  kcal/m²/year, not 0.1; corrected the choice text and rationale to be internally
  consistent.
- **`apphy2-mcq-015`** (Ahmed Ali, `approve_with_edits`, "revise stem and option C
  rationale") — **no factual defect found** on independent re-derivation; the physics was
  already correct. Treated the vague note as a clarity request rather than force a
  correctness fix with no confirmed error behind it: reworded the stem as a complete
  question instead of a fill-in-the-blank continuation, and tightened choice C's rationale
  for precision.

**Migration:** `scripts/content-seed/reviewer-qa-remediation/20260813_p0b_second_wave_repair.sql`
— same insertion discipline as every remediation this session (new version, never edit in
place), owner-remediation-approved, republished directly (these were live P0-B items, not
sitting in review limbo). Structural QA gate passed clean before republish.

**Result:** all 3 republished. Re-verified: P0-B net check back to **0**, 0 duplicate
published versions, 0 MCQ choice-count desyncs.
