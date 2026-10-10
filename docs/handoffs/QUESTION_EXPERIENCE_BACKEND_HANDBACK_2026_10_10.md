# Question Experience Backend — Hand-back for Approval

**STATUS:** Applied and probed in **Development only** (`wmgjsdkphcyhngaffbqf`). Production untouched.
Awaiting Product Owner approval before any Production apply (Hard Gate).

**DATE:** 2026-10-10 · **BRANCH:** `claude/chem-reference-pack-u1`

**Files:**
- Migration: `supabase/migrations/20261010040000_question_experience_read_model.sql` (Dev ledger version
  `20261010040000`, matching the filename)
- Dev seed / teardown: `scripts/qa/question_experience_dev_seed.sql`,
  `scripts/qa/question_experience_dev_teardown.sql`
- Probe output: `docs/qa/evidence/question_experience_2026_10_10/`

All findings below were read from Dev. Production was not read, per the brief. Dev is known to drift from
Production, so the counts are Dev counts. Re-check the two flagged counts against Production before approval.

## 1. Finding: what exists against the list

| # | Your belief | Finding | Built? |
|---|---|---|---|
| 1 | No ordered list or pointer on `learning_sessions` | **Correct, with one correction.** An ordered list already exists: `app.session_target_items` (`target_id`, `ordinal`, `content_item_version_id`) via `session_targets.learning_session_id`. But it belongs to issued Home targets (TTL, consume and eligibility triggers), and it has **0 rows** in Dev (`session_targets` also 0), while 57 of 59 Dev attempts sit in sessions. Practice items come from `student-session-items`, which selects them dynamically, drops answered items from later pages, and keeps "the ordinary queue cursor … entirely client-side" (file header comment). So the set **cannot be derived** after the fact. | **Yes: stored explicit list.** `app.learning_session_items`. Position is derived from it plus attempts, so no pointer column. |
| 2 | No store for comparison answers | **Correct.** Nothing stores Full credit / Common mistake / Vague. The closest thing is `item_package_payload.worked_solution` (52 Dev versions), which is a single worked solution, not variants. | **Yes:** `app.content_item_comparison_answers`, one row per (version, variant) with its own `is_published`. |
| 3 | No single read model | **Correct.** The page currently stitches together `student-session-items`, `get_graded_mcq_feedback`, `get_topic_point_guides` and direct reads. | **Yes:** `public.get_question_experience`. |
| 4 | How-the-points-went must be derived mechanically | **Agreed.** It needs no storage. | Derived inside the RPC from `grading_results.criterion_results`. **No model call, no table.** |
| 5 | Resume might already be answerable | **Partly.** `learning_sessions.status` (`active`/`completed`/`archived`) plus attempts can tell you a session is open and which item was last touched. They **cannot** tell you the next item, because the set is client-side (item 1). With item 1's table, resume is fully derivable. | **Nothing new for resume.** It is a derived `resume` block in the RPC. |

**Where the brief is slightly off:**
- `app.session_target_items` already gives an ordered item list. It just isn't used by practice sessions.
- `presentation.ts` does **not** fill the Open Hand pane's Vocabulary from `reference[]` today:
  `LiveOpenHandTeaching.jsx` called `mapOpenHandGuides(brief, explainer)` without the reference arrays.
  The Preview shell change at Lovable commit `84f287f0` wires it, and is under separate review.
- Dev content constraint: Dev has **no Chemistry questions**, and every published Dev FRQ is a single-criterion
  test fixture. You said more FRQs are being added. The multi-criterion how-the-points-went probe should be
  re-run on one of those (see §5).

Reused, not recreated: `learning_sessions`, `attempts` (grading truth is read only, never written by the RPC),
`grading_results.criterion_results`, `frq_criteria`, `mcq_choices` (through the existing
`get_graded_mcq_feedback`), `get_topic_point_guides` (called inside, so the reference path is unchanged),
`response_versions`. `app.attempt_criterion_results` (IDG-8) is neither read nor written.

## 2. The migration

`20261010040000_question_experience_read_model.sql`, one transaction:

1. **`app.learning_session_items`**
   - Columns: `learning_session_item_id`, `learning_session_id` → `learning_sessions.id` (on delete cascade),
     `ordinal ≥ 1`, `content_item_version_id` → `content_item_versions.id` (restrict), `added_at`.
   - Unique `(session, ordinal)` and unique `(session, version)`.
   - RLS forced. A student reads only items of their own sessions (policy through `learning_sessions.user_id = auth.uid()`).
     Only `service_role` writes.
   - Writer: **`app.append_learning_session_items(p_learning_session_id uuid, p_content_item_version_ids uuid[]) → integer`**.
     It appends in the order given, skips duplicates (a re-sent page doesn't renumber), locks the session row,
     and returns the total.
   - Execute is granted to `service_role` only. Probe: students can't call it.
2. **`app.content_item_comparison_answers`**
   - Columns: `variant ∈ {full_credit, common_mistake, vague}`, `response_text`, `explanation`, `is_published`,
     `published_at`, `source_note`. Unique `(content_item_version_id, variant)`.
   - **Publish guard trigger:** publishing is refused unless the question version is published. `published_at`
     is stamped on publish and cleared on unpublish (probed).
   - RLS forced, **no authenticated/anon grant, no policy.** These are answer truth, so they're readable only
     through the RPC, and only after submission.
3. **`public.get_question_experience`**: see §3.

The migration doesn't touch the `attempts_prevent_client_grading_truth_update` trigger or any grading
column. The seed wrote grading truth at insert as `service_role`, honouring the trigger's rule.

## 3. The RPC (contract for the Lovable wiring section)

```
supabase.rpc('get_question_experience', {
  p_learning_session_id: <uuid>,   // required; must be the caller's session
  p_ordinal: <int | null>          // optional; null = the resume position
})
```

`security definer`, `stable`. Granted to `authenticated` and `service_role`. Not callable by `anon`.

**Errors**
- `not_authenticated`: no signed-in user.
- `question_experience:session_not_found`: the session doesn't exist or belongs to someone else.
- `question_experience:invalid_ordinal`: `p_ordinal` is outside `1..total`.
- Errors from `get_topic_point_guides` pass through.

**Response (jsonb, camelCase except `mcqFeedback`)**

| Key | Shape / fields | Notes |
|---|---|---|
| `session` | `learningSessionId, status, entryPath, sessionMode, startedAt, endedAt` | |
| `counter` | `{ index, total }` or `null` | Renders `index/total`, e.g. `2/5`. `null` when the session has no stored items. |
| `resume` | `{ action, ordinal, contentItemVersionId, attemptId }` | `action` ∈ `start_item` · `next_item` · `continue_draft` · `review_feedback` · `no_items` · `session_ended`. Always computed for the resume position, whatever `p_ordinal` is. |
| `item` | `contentItemVersionId, contentItemId, itemType, title, stem, stimulus, hasStimulusImage` or `null` | Images still need a signed URL from `student-session-items`, which SQL can't sign. |
| `mcqChoices` | `[{ choiceKey, choiceText }]` | **No answer truth.** |
| `criteria` | `[{ criterionKey, learnerFacingText, pointsPossible, judgementKind, minimumFix }]` | `minimumFix` is `null` until this attempt is submitted. |
| `attempt` | `attemptId, status, startedAt, submittedAt, gradedAt, scorePoints, scorePossible, resultState, resultSummary` or `null` | This session's latest attempt on this item. Scores fall back to `grading_results` when `attempts` columns are null (pre-IDG-5 rows). |
| `grading` | `gradingResultId, status, pointsEarned, pointsAvailable, confidence, feedbackPreview, actionHint, repairHint, criterionResults[{ criterionKey, status, pointsAwarded, evidenceQuote, decisionExplanation, minimumFix }]` or `null` | Only after submission. `status` values: `earned` · `not_yet_earned` · `unable_to_determine`. |
| `mcqFeedback` | verbatim `get_graded_mcq_feedback` output: `attempt_id, content_item_version_id, picked_choice_key, earned, possible, choices[{ choice_key, choice_text, is_correct, rationale }]` or `null` | MCQ only, and only after grading. **snake_case** because it reuses the existing function unchanged. |
| `priorAttempts` | `[{ attemptId, contentItemVersionId, learningSessionId, submittedAt, scorePoints, scorePossible, resultState, isCurrent }]` | Every submitted attempt on this question (any version, any session), oldest first. |
| `pointsChange` | `{ previousAttemptId, currentAttemptId, previousPoints, currentPoints, pointsAvailable, criteria[{ criterionKey, previousStatus, currentStatus, change }] }` or `null` | Only when this attempt and an earlier one on the same question are both graded. `change` ∈ `gained` · `lost` · `unchanged` · `undetermined` · `not_previously_assessed` · `not_currently_assessed`. Purely mechanical. |
| `comparisonAnswers` | always 3, in order `full_credit, common_mistake, vague`: `[{ variant, available, locked, responseText, explanation }]` | `available=false` → render the tab **disabled**. `locked=true` (not yet submitted) → no content even when available. Empty array only when there's no item. |
| `topic` | `{ subjectKey, unitNumber, topicCode }` or `null` | From the version's primary cell and the taxonomy (UUID joins). |
| `reference` | object keyed by kind (`vocabulary`, `formula`, `list_sequence`, `convention`, `diagram`); each an array of `{ id, subjectKey, unitNumber, ownerTopicCode, topicCodes, kind, title, body, items[{label,meaning}], visualAssetRef, caution, sourceNote, memoryHooks }` | The same objects `get_topic_point_guides` returns for this topic, in RPC order. Kinds with no entries are absent. Diagrams are text `items` only (TASK-0006). |
| `memoryHooks` | `[{ id, referenceEntryId, referenceTitle, referenceKind, ownerTopicCode, unitNumber, kind, hookText, expandsTo[{cue,means}], whenToUse, caution, sourceNote }]` | Passed through from `get_topic_point_guides`. |

**Wiring the client still needs (not done; flagged for the next step):** the item-delivery path must call
`app.append_learning_session_items` when it serves a page. That's a small edit to
`supabase/functions/student-session-items/index.ts` after `deliverRows`, with `{ error }` captured. Until
it ships, real sessions have `counter: null` and `resume.action: 'no_items'`. Only the Dev seed rows have
items. I left the edge function alone so this hand-back stays DB-only, as asked.

## 4. Probes (Development, 2026-10-10)

Seeded for Dev student `cda34c9d-…`, with three sessions (`a0a0a0a0-…-0001/0002/0003`). Full JSON is in the evidence folder.

| Probe | Expected | Result |
|---|---|---|
| p1: S1, resume (no ordinal) | resume on the draft; comparison locked | `counter 2/3`, `resume.action continue_draft` ordinal 2, attempt `draft`, `minimumFix` null, all 3 comparison tabs `available:false, locked:true` ✅ |
| p2: S1 #1 retry (0/1 then 1/1) | how-the-points-went + comparison unlocked | `counter 1/3`; `priorAttempts` [0/1, 1/1 current]; `pointsChange.criteria` [`criterion_1`: `not_yet_earned` → `earned`, **gained**]; `full_credit` available + content; `common_mistake` (unpublished row) and `vague` (no row) `available:false` ✅ |
| p3: S2 #1 MCQ, before submission | choices without truth, reference grouped | `counter 1/2`, `resume start_item`; `mcqChoices` have only `choiceKey/choiceText`; `grading`/`mcqFeedback` null; `topic` ap-statistics 1.5; `reference` {diagram: 3, vocabulary: 1} ✅ |
| p4: S2 #2 MCQ, graded | MCQ truth only after grading | `mcqFeedback` present (`picked_choice_key A`, 1/1, choices with `is_correct`/`rationale`) ✅ |
| p5: S3, no items | empty state | `counter null`, `resume.action no_items`, `item null` ✅ |
| p0 / n3: RLS on session items | own rows only | own: 5 rows; another student: 0 ✅ |
| n1: another student's session | refused | `question_experience:session_not_found` ✅ |
| n2: ordinal 9 of 3 | refused | `question_experience:invalid_ordinal` ✅ |
| n4: direct read of comparison answers | refused | `permission denied for table content_item_comparison_answers` ✅ |
| n5: anon call | refused | `permission denied for function get_question_experience` ✅ |
| Publish guard | refuse on unpublished version; stamp/clear `published_at` | refused `comparison_answer:version_not_published`; unpublish → null; republish → stamped ✅ |
| Grants | append is service-role only | `authenticated` can't execute `append_learning_session_items`; anon can't execute the RPC ✅ |

**Bug found and fixed during probing:** the RPC first picked the "current" attempt by `created_at`. Two
attempts created in one transaction share a `created_at`, so it chose the older one and `pointsChange`
went null. It now orders by `started_at desc, created_at desc, id desc`. Only the function was re-applied
on Dev, and the ledger's statements were updated to match the file.

## 5. Open items for approval

1. **Approve or amend** the migration for Production (Hard Gate). A Production apply should load the same file
   and re-run these probes against a real FRQ.
2. **Multi-criterion probe:** re-run p2 on one of the incoming Dev FRQs with two or more criteria, to show
   `gained`/`unchanged`/`lost`/`undetermined` together. Single-criterion Dev fixtures only show `gained`.
3. **Edge-function wiring** (§3) as a separate, small change, so `counter`/`resume` work for real sessions.
4. Who authors comparison answers, and the checking rule for them, isn't decided. The table only gives them a home.
5. Remove the Dev seed when you're done reviewing: `scripts/qa/question_experience_dev_teardown.sql`.
