# Reviewer queue rebalance, gold-set expansion, and tutor_decision label fix — 2026-08-09

## 1. Gold-set roster expansion

Owner directed: add Abdul Hanan (Calculus-qualified) and Ahmed Ali (Physics-qualified) to
gold-set review, pairing them with Chisom Anuba's existing unpaired answers rather than
seeding a fresh batch; give Abdul the leftover Precalculus answer too.

- Granted both the `gold-set-review` feature flag.
- Paired Abdul with Chisom on Calculus AB + Calculus BC (2 answers), and later on
  Precalculus (1 answer) — 3 total.
- Paired Ahmed with Chisom on Physics 1/2/C-Mechanics/C-E&M (4 answers).

Script: `scripts/content-seed/reviewer-management/20260809_gold_set_flags_and_pairing.sql`.

## 2. Half of Ahmed's physics queue moved to Saood

Owner directed: move half of Ahmed Ali's pending physics tutor_question queue to Muhammad
Saood so Ahmed reaches gold-set work sooner.

**Ahmed had 213 pending physics assignments.** Moving a proportional half (106) hit
`duplicate key value violates unique constraint` on 76 of them — Saood already holds a row
(submitted or withdrawn) for the same `content_item_version_id` + `review_stage`. Investigated
why: Saood has **522 physics decisions already submitted** (155 Physics 1, 121 Physics 2, 137
C:E&M, 109 C:Mechanics) and **zero pending** physics assignments — he's already the blind
partner on nearly all of Ahmed's queue.

**Only 30 of Ahmed's items had no existing Saood row at all** (10 each in Physics 2, C:E&M,
C:Mechanics; none in Physics 1) — those are the ones that actually moved.

Breaking down what remained on Ahmed's plate (183 items) after the move:

- **153** already have Saood's submitted decision — Ahmed is the second/last reviewer, and
  the pair is only waiting on him. Confirmed: all 153 of Saood's decisions here are `approve`
  (82 with explicit label + 3 with the label missing) or `approve_with_edits` (58 explicit +
  10 missing) — zero `disapprove`.
- **30** have only a withdrawn other-reviewer row — Ahmed is effectively the sole/first
  reviewer on these.

Script: `scripts/content-seed/reviewer-management/20260809_ahmed_physics_half_to_saood.sql`.

## 3. Publish backlog re-check

Owner asked whether single-reviewed approved/approved-with-edits questions were fully QA'd
and published (referring to the Pool 1/Pool 2 and 167-item backlog work earlier the same
day). Re-verified: **zero** items remain at a terminal-approved `review_status`
(`question_review_approved`, `difficulty_confirmed`, `answer_approved`,
`mcq_answer_review_complete`) without being published. What's left at `reviewed_approved` is
only the four previously-flagged out-of-scope buckets (55 legacy null-`review_status`, 3
`difficulty_discussion`, 2 `tutor_review_pending`, 1 `ap_reader_pending`) — none of which are
decided/approved states.

Ahmed's 183/213-item queue is unrelated to that backlog: those are `content_review_assignments`
with `status='pending'` — no decision submitted yet, so nothing for a publish step to act on.

## 4. Ahmed Ali's answered-so-far stats

50 tutor_question decisions submitted: 4 `approve` (8%), 46 `approve_with_edits` (92%), 0
`disapprove`. Edit-or-disapprove rate: **92%** — flagged as unusually high and worth a
follow-up look at whether it clusters around one root cause (as the E&M convention-gap did
in an earlier sweep) or reflects genuinely defect-heavy content.

## 5. tutor_decision null-label bug — found and fixed

While computing Saood's decision breakdown in §2, found `tutor_decision` (the text label
alongside the numeric `tutor_score`) null on 568 platform-wide `tutor_question` decisions (249
score=1, 291 score=2, 28 score=3), plus one anomalous fixture row (`reviewer_id
aaaaaaaa-0001-...`) with `tutor_score IS NULL` but `tutor_decision='approve'`.

**Root cause:** `supabase/functions/review-decision/index.ts` accepts `tutor_decision` as an
input alias to derive `tutor_score` (via `resolveTutorScore`), but never writes the label back
into the row it inserts — the `.insert(...)` call never included a `tutor_decision` key at all.
Every decision submitted through the live edge function has always landed with a null label;
the 1,777+817+89 rows that do have a label were populated by one-off historical
backfill/remediation scripts, not by the app.

**Blocker found before any data fix:** `app.content_review_decisions` has an immutability
trigger (`prevent_review_decision_mutation`) that blocks `UPDATE` outright — decisions are
write-once evidence, same principle as "never edit a reviewed/published row in place." A direct
`UPDATE ... SET tutor_decision = ...` backfill is not permitted and was not attempted.

**Fix applied — source only, no historical backfill:**

- Added `resolveTutorDecisionLabel(tutorScore, decisionValue)` to
  `supabase/functions/review-decision/review-payload.ts` — prefers a client-sent label
  (validated against the known set) so an explicit override is never discarded, otherwise
  derives the label from `tutor_score` so it's never null when a score is present.
- Wired it into `index.ts`: computed alongside `tutorScore`, added to `decisionPayload`, and
  added to the `content_review_decisions` insert. Deployed (`review-decision` v18 → v19).
- **Historical 568-row gap is deliberately left as-is** — `tutor_score` is complete and
  authoritative for every one of them, so nothing is ambiguous; any report or query needing
  the label should derive it from `tutor_score` (1→approve, 2→approve_with_edits,
  3→disapprove) rather than reading `tutor_decision` directly for older rows. A non-mutating
  read-side view/function was offered as an alternative but not built — no decision made yet
  on whether it's wanted.
