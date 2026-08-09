# Physics single-reviewed backlog: root cause, §9 QA, and publish — 2026-08-09

**Trigger:** Owner reported 58 questions showing as "in review" on
`https://cramapple.com/reviewer/content` for Physics 2 / C:E&M / C:Mechanics with a
single review label already, plus asked where 82 approve-labeled decisions (assigned to
Ahmed Ali, reviewed by Muhammad Saood) were. Owner recalled a decision made 2026-08-08:
abandon the two-reviewer requirement, since the new §9 independent-re-derivation QA
protocol was effective enough that single review + §9 QA is sufficient for publication.

## Root cause

`docs/activity_log/ACTIVITY_LOG.md` (2026-08-08) records **"183 Single-Reviewed Physics
Items Assigned to Ahmed Ali for Second Review (213 Total Pending)"** — a batch created
explicitly for a *second* human review, under the two-reviewer model that was still active
at that point. If the single-review-is-sufficient decision was made at or after that
assignment, this batch fell through a seam: nobody redirected it onto the new
single-review + §9-QA + publish path, so it just sat as "waiting for a second reviewer"
that, per the new decision, was never actually required.

**Confirmed this is Physics-specific, not a platform-wide pattern.** Querying every
subject for "single tutor_question decision submitted, item still unpublished":

| Subject | Single-reviewed, second reviewer still pending | Single-reviewed, no second reviewer assigned |
|---|---:|---:|
| AP Physics 1 | 21 | 4 |
| AP Physics 2 | 12 | 0 |
| AP Physics C: Mechanics | 9 | 4 |
| AP Physics C: E&M | 9 | 4 |
| AP Chemistry | 0 | 1 |
| AP Statistics | 0 | 1 (Engine 4 hand-drawn-graph item, out of scope — see below) |
| AP Calculus AB / Biology | 0 | 0 |

No other subject had an equivalent leftover "assign for second review" batch sitting
around when the policy changed, which is why this backlog is essentially all Physics.

**Excluded from this pass:** `APSTATS-HDG-2026-GRAPH-005` — a single-reviewed AP
Statistics item, but it's an Engine 4 `spatial`/`human_shadow` hand-drawn-graph item, a
different grading engine and QA methodology (Set C, deferred until Engine 4 leaves
shadow per `GOLD_SET_GENERATION_PROTOCOL.md` §2). Not part of the standard MCQ/FRQ §9
protocol used here.

## §9 independent re-derivation QA

**Method:** 4 parallel background agents, one per physics course, each independently
re-solving every FRQ criterion and MCQ answer key from scratch (real physics
computation, not eyeballing) before comparing to the stored value — same discipline as
every other §9 pass this session.

| Course | n | Clean | Defects |
|---|---:|---:|---:|
| AP Physics 1 | 23 | 23 | 0 |
| AP Physics 2 | 12 | 12 | 0 |
| AP Physics C: E&M | 11 | 11 | 0 |
| AP Physics C: Mechanics | 11 | 11 | 0 |
| **Total** | **57** | **57** | **0** |

All 57 items — momentum/collisions, rotational dynamics, kinematics, circuits,
thermodynamics, Gauss's-law E&M problems, oscillations, and the corresponding MCQs —
independently re-derived correctly with no physics errors, no rubric/stem contradictions,
no point-total mismatches, and no stem/`mcq_choices` desync. The E&M and Mechanics agents
were specifically directed to check for the two known recurring defect patterns found
earlier this session in these same subjects (an unstated sign/direction convention gap in
E&M; a "procedure asked but only variable-identification graded" gap in Mechanics) —
neither pattern recurred in this batch.

## Publish

Published all 57 items directly on the single review + this §9 pass (no second human
reviewer), consistent with the 2026-08-08 policy decision:

- Set `content_item_versions.review_status = 'question_review_approved'` and
  `status = 'published'` on each (this batch never got a `review_status` at all under the
  old code path, since `advanceWorkflow` only computes an aggregate once both blind-pair
  tutor_question decisions are submitted — with only one side in, nothing had ever set
  it).
- Set `content_items.status = 'published'`.
- **Withdrew the now-unnecessary pending second-review `tutor_question` assignments** on
  these 57 items (51 of them had one; Ahmed Ali held all 51). His pending physics queue
  dropped from 183 to 132 as a result — the remaining 132 are items where *nobody* has
  submitted a decision yet, a different, unrelated bucket untouched by this pass.

Verified: `content_items.status='published'` count for all 57 target `content_key`s = 57
(in-script assertion, transaction would have rolled back otherwise).

## Follow-ups not actioned here

- The 12 no-second-assigned single-reviewed items outside these 57 course subjects (1
  Chemistry, 1 Statistics) are the same shape but weren't included in this batch's scope
  (defined as the three Physics courses named in the trigger); worth a quick follow-up
  pass.
- Whether any *other* Physics-adjacent leftover "assign for second review" batches exist
  from before 2026-08-08 wasn't exhaustively searched — this pass targeted exactly the
  single named batch and its current live state.
