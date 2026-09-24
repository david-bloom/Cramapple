# AP Biology Completion Plan

**Status:** Active — D0, D1, D3, D4, D5 accepted (2026-09-24). **D2 blocked**: the September labels are *coverage* labels, not replacements for the live *serving* labels, and the governing architecture plan requires human validation for every coverage label — which DECISION-0055 may or may not have paused. See M2.
**Owner:** David Bloom (ratification) / Claude (migration + verification)
**Date:** 2026-09-24
**Purpose:** Finish AP Biology end to end, and in doing so **establish the ratify → apply → verify
path that no subject has yet used.**

---

## The governing fact

**This program has produced eight QA-accepted proposal sets and applied none of them.**

Biology is the clearest case. Its building is roughly 90% complete; its shipping is at zero:

| Workstream | Proposal | Production today |
| --- | --- | --- |
| Canonical answers | A + F, QA-accepted, 88 criteria authored | **7 FRQ still blank** |
| Topic labels | QA-accepted 2026-09-22 | **Not applied.** Serving labels are `legacy_unvalidated` / `provisional_model` / `held` / `stale`, last written **2026-08-08** |
| Difficulty | 118-row calibrated assignment | **0 of 118 items carry a difficulty value** |
| Point totals | Work order I, QA-accepted | 9 items still mismatched |
| Hand-drawn (4 items) | capture live, `expected_graph_spec` present | holds at `shadow_review`, **scores nothing** |

So the reason to finish Biology first is not that it is nearly done. It is that **Biology is the only
subject where the loop can actually be closed** — it is the only subject the DECISION-0052 grader
gate accepts, so it is the only place an *applied* canonical can be confirmed to grade at 100%.

Every other subject will hit this same wall. Better to hit it once, at 118 items, than three times at
scale.

---

## Blocker found while writing this plan: the segmentation has nowhere to go

**`creditedResponse` / `spans[]` has no storage location in Production.** Verified 2026-09-24:

- `app.content_item_versions` has `canonical_answer_1` and `canonical_answer_2` (both `text`) and no
  span, credited-response or segmentation column.
- No table anywhere matching `%credit%`, `%span%`, `%canonical%` or `%open_hand%`.
- **Zero** published Biology items carry `creditedResponse`, `credited_response` or `spans` in
  `prompt_json`.

Work orders A, B, C, F and G have between them produced **thousands of criterion-tagged spans**. F
alone produced 576 across 71 Biology items. The entire point of that work is that Open Hand can
strike exactly the text earning a deselected rubric point — and there is currently nowhere to put it.

**Consequence:** applying "Biology's canonical answers" today would write `canonical_answer_1` text
and **discard every span**. That is not finishing Biology; it is shipping half the artifact and
losing the half that took the most QA effort.

**This is decision D0 below, and it blocks the canonical-answer migration.** It is also the single
highest-value thing surfaced by this plan, because it applies to all ten subjects.

---

## Definition of done for AP Biology

Biology is complete when all six hold:

1. Every published Biology FRQ has a canonical answer that is a student-voice full-credit response,
   and its segmentation is stored and retrievable.
2. Every published Biology item carries a ratified topic label from the current taxonomy source
   version, at `label_status` better than `provisional_model`.
3. Every published Biology item carries a ratified difficulty value.
4. No open high-severity QA finding against Biology content.
5. The DECISION-0052 grader gate has been run against the **applied** canonicals for every reachable
   item, with results recorded.
6. The 4 hand-drawn items have an explicit disposition. **Met 2026-09-24:** `GRAPH-002` is in the
   TASK-0038 human-graded pilot; `-003`, `-008` and `-010` are accepted as non-scoring until Engine
   4's spatial verifier exists.

---

## Ratification decisions required (these are yours, and they gate everything)

| ID | Decision | Recommendation | Blocks |
| --- | --- | --- | --- |
| ~~**D0**~~ | **DECIDED 2026-09-24 — DECISION-0060.** Segmentation is stored in a dedicated child table keyed by `content_item_version_id`, one row per span. Deciding argument: a span is answer-key material, and RLS on a dedicated table is far easier to get right than hiding a key inside a blob the grader reads on every attempt. | — | **Unblocked** |
| ~~**D1**~~ | **ACCEPTED 2026-09-24.** A + F's canonical answers and segmentation are ratified for Biology. M1 may proceed once F.1 lands (`APBIO-FRQ-S-101`'s four-part re-label) — see the M5 baseline. | — | **Unblocked** |
| **D2** *(part)* | **ACCEPTED 2026-09-24** — the September topic labels supersede the August provisional set. **Still open: sign-off on the 6 flagged items**, which the accepting QA raised for Product Owner review. M2 can be written against the accepted set but should not apply until the 6 are resolved. | — | M2 |
| ~~**D3**~~ | **DECIDED 2026-09-24 — DECISION-0061.** Three levels are operative; four-level sources translate down (`Very Hard` → `Hard`) non-destructively, with the attainment ratio stored alongside. **Biology carries zero difficulty values, so it has nothing to translate** — its 118-row assignment applies directly and does **not** wait on work order J. | — | **Unblocked** |
| ~~**D4**~~ | **APPROVED 2026-09-24 — remove `prompt_json.total_points`** from the 9 Biology items. No runtime reads it; `evaluate-attempt` sums `frq_criteria.points_possible`. | — | **Unblocked** |
| ~~**D5**~~ | **DECIDED 2026-09-24 — accept as non-scoring for now.** Correction to how this was framed: the four are **not** uniform. `APBIO-HDG-2026-GRAPH-002` is `human_graded_pilot_approved` and sits in the TASK-0038 human-graded pilot lane (DECISION-0058/0059) — it *is* graded, by a human, under an operational commitment. The other three (`-003`, `-008`, `-010`) are `ai_provisional_unapproved` and genuinely score nothing. So D5 applies to those three; `-002` is already dispositioned elsewhere and must not be swept up. | — | **Unblocked** |

**D0 and D3 were not Biology-specific, and both are now decided** (DECISION-0060, DECISION-0061),
which settles the storage shape and the difficulty scheme for all ten subjects. D5 is decided too.
**Remaining: D1, D2 and D4 — all three are ratifications of work QA has already accepted**, not new
judgement calls.

**One condition worth carrying forward on D5.** Accepting three items as non-scoring is safe while
Production has no real students. It stops being safe the moment it does: a student who submits a
drawing and receives nothing back is a worse experience than an item that was never offered. Revisit
when the first real cohort lands, or when Engine 4's verifier ships — whichever comes first.

---

## Migration sequence

Each step is a reviewable migration with a verification query that must pass **before** the next step
begins. Nothing is applied by direct SQL — the 29 topic-guide migrations of 2026-08-25/27 were
applied that way and are the reason the Dev migration ledger cannot be trusted.

**Correction to this plan's verification strategy, 2026-09-24.** It originally said each migration
would be rehearsed on Dev before Production. **That works for schema and not for data.** Dev holds
**1** Biology item against Production's 118 — M0 rehearsed cleanly because it is pure DDL, but M1–M4
touch Biology content Dev does not have, so applying them there proves nothing.

The substitute is stronger than a Dev rehearsal, not weaker: **a data migration whose effect can be
fully enumerated read-only against Production before it runs does not need a rehearsal environment.**
Each of M1–M4 therefore ships with (a) the exact before-state, queried read-only, (b) an idempotent
statement, (c) the rollback data recorded in the migration itself, and (d) verification queries to
run after. Production remains a hard gate; nothing applies without explicit Product Owner go.

### M0 — establish the segmentation store *(D0 decided — DECISION-0060)*

Create the store, with no data. Verify shape, constraints and RLS before anything is written. RLS
matters: **a credited-response span is answer-key material** and must not be readable by
`authenticated` — the same exposure class as the `mcq_choices.is_correct` finding.

### M1 — canonical answers and segmentation *(gated on D1, M0)*

Write `canonical_answer_1` for the 7 blank Biology FRQ, and the full segmentation for all 71
in-scope items from F's `canonical_proposal.jsonl`.

**Do not overwrite any existing `canonical_answer_1`.** F's own removals are proposals against the
assembled answer, not against Production, and DECISION-0056 authorised removal in the proposal only.

*Verification:* every one of the 75 Biology FRQ has a non-empty canonical; every span concatenates to
its `full_text`; every criterion has a span tagged to it alone; span count matches the proposal
exactly.

### M2 — topic labels *(WRITTEN and REHEARSED 2026-09-24; not yet applied to Production)*

**RESOLVED as DECISION-0062:** the 118 Biology coverage labels land as `provisional_model`, the six
QA-flagged items land as `held`, no serving label is touched, and the T9 question moves from gating
storage to gating *promotion* (and with it T8's coverage recompute).
`supabase/migrations/20260924160000_biology_coverage_topic_labels.sql`. Rehearsed against a local
replica built from the real DDL: INSERT 118 / UPDATE 60, label_version resolved per item (58 v1, 30
v2, 30 v3), exactly one current coverage label per item, all 118 serving rows unchanged, 0 rows
written as validated. Both guards negative-tested and both roll the transaction back.

**The original M2 instruction was wrong, and writing it surfaced why.**

`docs/architecture/TAXONOMY_LABELING_PLAN_V3_2026_08_04.md` §7a (T9) splits the label layer in two,
and is explicit that the halves are not interchangeable:

| | **Serving label** | **Coverage label** |
| --- | --- | --- |
| Question | What must a student have covered to *answer* this? | What does this item *count toward*? |
| Field | `required_units[]`, `max_required_unit` | `assessed_topics[]` |
| Granularity | Unit (8) | Topic (61) |
| Automation | two-model lane (89% agreement) | **human validation** (44% agreement) |

> *"Neither field may substitute for the other, and `primary_unit` is an input to neither."*

Three consequences, all verified against Production 2026-09-24:

1. **The September labels are coverage labels, not replacements for the August ones.** The live August
   rows are *serving* labels carrying `required_units` — they answer a different question and are
   still needed. **Nothing gets superseded.** "September supersedes August" was my framing and it was
   wrong.
2. **`assessed_topics` has never been populated.** Across all 484 Biology label rows — 181 coverage
   and 303 serving — **zero** carry a topic. The September proposal would be the first topic-level
   data ever written to this layer.
3. **The plan requires full human validation for coverage labels.** Its triage table reads: *"**Any**
   `assessed_topics` (coverage) label → **Full human validation**"* — because model agreement on
   topics measured 44% against 89% on units. Codex's own proposal marks **69 of 118** Biology rows
   `needs_human=true`, which is consistent with that.

**The unresolved question, which is a Product Owner call, not a QA one.** DECISION-0055 paused the
human independent-review requirement for content and made AI cross-model QA plus Product Owner
approval the operative gate. It names `CONTENT_GOVERNANCE_AND_VALIDATION.md` §11.1 and DECISION-0044
explicitly. **It does not name this plan's T9/T6.b human-validation rule for coverage labels.** So it
is genuinely ambiguous whether that rule is paused.

**Resolved 2026-09-24 as DECISION-0062, by routing around the ambiguity rather than settling it.**
The labels land in a status that claims nothing: `provisional_model`. Three facts make that safe —
nothing in the codebase reads `assessed_topics` (grep-verified: DDL only, no selector, no RPC, no
edge function); the schema's own check constraint makes `validated` unreachable without a named
validator, timestamp and decision id, all of which this migration leaves null; and the coverage index
only indexes `validated` rows, so provisional labels are invisible to any coverage computation. The
T9 question therefore still blocks T8's coverage recompute — which is where it belongs — and no
longer blocks storing the data.

*Verification, once unblocked:* every published Biology item has exactly one current coverage label
with a non-empty `assessed_topics`; every topic code is in the closed list at the stated
`taxonomy_source_version`; **no serving label is modified**; the 2 osmosis corrections land as `2.7`;
the 4 hand-drawn items are held rather than labelled from a boilerplate stem.

### M3 — difficulty *(store written, NOT applied; data load blocked)*

`supabase/migrations/20260924150000_content_item_difficulty.sql`. Creates
`app.content_item_difficulty` — the operative three-level band plus `attainment_ratio`,
`ratio_source`, `subject_cut_points` and `source_value` (the raw pre-translation string), per
DECISION-0061. A table rather than `prompt_json` keys, following D0's precedent: five facts per item
would bloat a blob `evaluate-attempt` reads on every attempt. **That storage choice was made by
precedent, not separately asked — it can be overridden.**

Biology's `source_value` is null throughout: it carries no existing difficulty value, so there is
nothing to translate. That is exactly why it is the clean subject to prove the shape on.

**The data load is blocked, and the reason is worth knowing.**
`apbio_difficulty_assignments.csv` holds all 118 bands but its columns are only
`content_key, item_type, difficulty, basis, rationale` — **there is no ratio.** The continuous score
was computed during calibration and discarded, which is precisely the gap work order J.1b was written
to stop, and Biology predates it. Further, **37 of 118 carry basis `judgement`**, which has no
attainment anchor at all, so no ratio exists for them even in principle under this method; the other
81 record their task verbs and could be reconstructed.

**QA should not reconstruct those ratios** — that would make the QA model the author of numbers it
then verifies. The fix is a small regeneration for Codex: re-run `assign_difficulty.py` for Biology
emitting `attainment_ratio`, `ratio_source` and `subject_cut_points`, leaving the ratio null with
basis `calibrated_judgement` where no anchor exists. 118 items, method already written.

Loading 118 null ratios now would ship Biology as the one subject not carrying the thing
DECISION-0061 exists for.

*Verification:* store empty, RLS on, no grants to `anon`/`authenticated`/`public`. After the data
load: 118 of 118 items carry exactly one row; every band is in the ratified vocabulary; every
`calibrated_task_verb` row carries a non-null ratio; `source_value` null for all 118.

### M4 — point totals *(D4 approved; migration written, NOT applied)*

`supabase/migrations/20260924140000_biology_remove_total_points.sql`. Removes
`prompt_json.total_points` from the 9 Biology versions where it disagrees with the rubric. All 9
currently declare **8** against a rubric summing to **9**, and all 9 share the identical shape
`a=1;b=3;c=3;d=2` — one bad authoring template. The removed values are recorded in the migration so
the change is reversible.

**A question the before-state raised that D4 did not settle.** **16** Biology items carry
`total_points`, not 9. The other **7** — `L-003`, `L-008`, `L-014`, `L-026`, `L-030`, `L-031`,
`L-036` — carry a value that *agrees* with its rubric. Removing the field from 9 and leaving it on 7
produces a state in which absence is ambiguous: a reader cannot tell whether a missing
`total_points` means "removed because wrong" or "never had one". Since work order I's actual finding
was that **no runtime reads the field at all**, removing all 16 is the more coherent end state.
**Product Owner call: 9 as approved, or all 16.**

*Verification:* the 9 no longer carry the field; no Biology item has a `total_points` disagreeing
with its rubric sum; `prompt_json` key counts drop by exactly one on those 9 and are unchanged
elsewhere in Biology.

### M5 — grader gate against applied canonicals *(gated on M1)*

Re-run `app.qa_grade_frq` for every reachable Biology item **after** M1, against the applied text
rather than the proposal.

This is the step that makes DECISION-0052 real for the first time. It is also where the current
evidence says trouble lives: F's QA ran the gate on 3 items and **2 failed**, both with the grader's
own explanation affirming the criterion while its status denied it, and its own integrity checker
flagging the contradiction.

*Verification:* record every score. **A score below 100% is a finding, not a failure to suppress** —
and on current evidence it is more likely to be a grader defect than a content defect.

---

## What this plan deliberately does not do

- **It does not widen the grader gate.** The QA path is restricted to `ap_biology` and to items with
  no existing canonical, which is why only 3 items are reachable. Widening it is a Production change
  to a token-gated path and is out of scope here. *But note the interaction:* M1 writes canonical
  answers, and the gate refuses items that **have** a canonical — so **M5 must run against a snapshot
  captured before M1, or the guard must be widened first.** Sequencing this wrongly makes the gate
  permanently unreachable for Biology.
- **It does not touch Engine 4.** The 4 hand-drawn items are dispositioned by D5, not fixed here.
- **It does not commit the other nine subjects.** It establishes the path they will use.

---

## Risks

| Risk | Mitigation |
| --- | --- |
| **M1 makes the grader gate unreachable** (writing a canonical trips the 409 guard) | Run M5's baseline capture **before** M1, or widen the guard first. This is the sharpest ordering trap in the plan. |
| Segmentation store leaks answer keys to students | RLS on the new store proven in M0 before any data is written; same class as the `mcq_choices.is_correct` exposure |
| Direct-SQL application repeats the untrusted-ledger problem | Every step is a migration with a verification query; no direct SQL |
| Difficulty scheme changes after M3 | J.1a/J.1b make the collapse non-destructive and the band re-derivable, so a later change is a re-read, not a re-assignment |
| Biology "done" is declared while proposals for other subjects rot | H's five finished subjects should be QA'd and parked, not left open |

---

## Sequence and owners

| Step | Owner | Depends on |
| --- | --- | --- |
| D0–D5 decisions | **David** | — |
| Work order J (difficulty vocabulary brief) | Codex | — |
| M0 segmentation store | Claude | **APPLIED to Dev and Production 2026-09-24** (empty), RLS proven |
| M5 baseline capture | Claude | — *(must precede M1)* |
| M1 canonical + segmentation | Claude | D1, M0, M5-baseline |
| M2 topic labels | Claude | **WRITTEN + REHEARSED 2026-09-24** (DECISION-0062) — awaiting Production apply |
| M3 difficulty | Claude | **store APPLIED to Production 2026-09-24 (empty)**; data load blocked on work order J.0 |
| M4 point totals | Claude | **APPLIED to Production 2026-09-24** — all 16, verified |
| M5 grader gate re-run | Claude | M1 |
| Biology closeout record | Claude | all |

Codex's share is small: work order J, and any content rework a decision triggers. **The critical path
is D0 through D5** — the building is done and the decisions are what the work is waiting on.
