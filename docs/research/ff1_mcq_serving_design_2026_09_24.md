# FF-1 design proposal — make AP Biology MCQ reachable on the practice path

**Date:** 2026-09-24  
**Scope:** STEP 1 only — Production verification and design. No implementation and no Production writes.  
**Recommendation:** Option C, a Biology-scoped combined practice selector used only for Biology
`targeted_drill` sessions.

## 1. Recommendation in one paragraph

Add a service-role-only, `SECURITY INVOKER` function named
`app.select_biology_practice_items` that selects the existing eligible Biology targeted-drill FRQ
and all published Biology MCQ, returns an explicit answer-free projection including `item_type`, and
builds a session-stable proportional queue. At today's eligible pool (71 text-answer FRQ and 43
MCQ), the normal 20-item request returns **12 FRQ and 8 MCQ**, interleaved rather than grouped.
`student-session-items` should call this function only when the owned active session is AP Biology
and `practice_format='targeted_drill'`; every other subject and every other format stays on the
existing path. MCQ retain `practice_format = NULL`. The Edge Function reuses the existing
`deliverRows`/`buildRenderItem` path, which already fetches only `choice_key` and `choice_text` and
already renders rows tagged `item_type='mcq'` as choices. `attempt-response` and
`evaluate-attempt` require no production-code change for this design.

This is a real semantic change: `targeted_drill` remains an FRQ classification on content rows, but
a Biology `targeted_drill` **session** becomes a mixed practice queue. The new selector, not the
`practice_format` column, is the explicit policy boundary that admits MCQ to that queue.

## 2. Production facts re-verified

All queries below were SELECT-only against Cramapple Production
`pcntajvbdfqhbeewmdry` on 2026-09-24. The published-set predicate was:

```sql
with latest as (
  select distinct on (content_item_id) *
  from app.content_item_versions
  order by content_item_id, version_num desc
)
select ...
from app.content_items ci
join latest civ on civ.content_item_id = ci.id
...
where ci.status = 'published' and civ.status = 'published';
```

Verified results:

| Fact | Production result |
| --- | ---: |
| Biology published corpus | **118** = 75 FRQ + 43 MCQ |
| Biology by format | 72 FRQ/`targeted_drill`; 3 FRQ/NULL; 43 MCQ/NULL |
| Published MCQ product-wide | **783** |
| Published MCQ with non-NULL `practice_format` | **0** |
| Biology unit-gated servable | **0** |
| Product-wide unit-gated servable | **8** (4 Calculus AB + 4 Calculus BC) |
| Biology practice targeted-drill servable | **71** (one of the 72 is excluded from text serving) |

The 783 MCQ split is: Biology 43; Calculus AB 60; Calculus BC 63; Chemistry 68;
Physics 1 63; Physics 2 40; Physics C E&M 48; Physics C Mechanics 41; Precalculus 53;
Statistics 304. The nine non-Biology subjects therefore contain the cited **740** MCQ.

Additional facts that affect the design:

- All 43 current published Biology MCQ versions have exactly four choices and exactly one keyed
  correct choice. None has a stimulus image path or an `image_needed='yes'` requirement.
- Production has three Biology and 46 Statistics `grading_results` rows with
  `model_id='rule-based-mcq'` and `status='graded'`. The MCQ grading branch is live and has executed;
  it is not merely dormant repository code.
- No Production learning session has ever used `practice_format='mcq'`. Biology has six
  `targeted_drill` sessions and six NULL-format sessions. Therefore a new pure-MCQ-session branch
  would also require a client/session-start change before it moved launch-day content.
- The live `app.content_items` check constraint permits a non-NULL `practice_format` only for FRQ,
  and the column comment calls it a serving contract for FRQ. This matches the repository baseline
  at `supabase/migrations/20260731160000_schema_baseline.sql:1952` and `:1969`.
- Live `pg_proc.prosecdef` is false for `public.select_practice_frqs` and
  `app.select_confirm_transfer_item`, and true for `public.select_unit_gated_practice_items`.
  The proposal does not assume all existing selectors are definers; it explicitly keeps the new
  selector invoker-rights and service-role-only.

These results independently confirm the problem statement and the FF-13 verification in
`docs/research/ff2_ff13_verification_2026_09_24/README.md`.

## 3. Current path, with evidence

### Selection and delivery

`public.select_practice_frqs` selects only `item_type='frq'`, requires the requested FRQ
`practice_format`, excludes hand-drawn items, and caps at 50
(`supabase/migrations/20260923150000_exclude_hand_drawn_from_text_serving.sql:19-66`). The ordinary
branch of `student-session-items` passes the session format directly to that RPC
(`supabase/functions/student-session-items/index.ts:479-502`). Its request limit is capped at 20
(`supabase/functions/_shared/student-item-delivery.ts:15`).

The delivery layer is already MCQ-capable:

- it queries `app.mcq_choices` with the explicit projection
  `content_item_version_id, choice_key, choice_text`, never `*`, `is_correct`, or `rationale`
  (`supabase/functions/student-session-items/index.ts:138-159`);
- `buildRenderItem` emits `item_type`, safe choices, and no raw `prompt_json`
  (`supabase/functions/_shared/student-item-delivery.ts:287-327`); and
- the confirm-transfer branch proves the precedent by tagging selected rows as `item_type='mcq'`
  before calling that same delivery code (`supabase/functions/student-session-items/index.ts:386-393`).

The proposed ordinary mixed queue should reuse this path. It does **not** need a new render contract
or the source-item-dependent confirm-transfer selector. The latter is deliberately a one-item,
same-cell flow (`supabase/migrations/20260826120000_course_mode_confirm_transfer_item_selector.sql:40-127`),
not a general queue.

### Attempt creation

`attempt-response` requires `attempt_mode` to equal the content item's `item_type`
(`supabase/functions/attempt-response/index.ts:486-490`). It returns
`practice_format_mismatch` only when the content item itself has a non-NULL format and it differs
from the session (`:499-516`). Thus:

- a mixed-queue FRQ (`practice_format='targeted_drill'`, `attempt_mode='frq'`) continues to pass;
- a mixed-queue MCQ (`practice_format=NULL`, `attempt_mode='mcq'`) already passes; and
- confirm-transfer's NULL-format MCQ precedent remains unchanged.

No `attempt-response` change is recommended. Giving MCQ a synthetic `targeted_drill` value merely
to satisfy this check would be unnecessary and would require weakening the FRQ-only constraint.

### Grading

`evaluate-attempt` refuses an unsubmitted response before it loads the answer key
(`supabase/functions/evaluate-attempt/index.ts:685-719`). It then loads MCQ choices server-side,
including `is_correct`, through the service client (`:789-816`), and the grading router maps MCQ to
the deterministic `mcq_rule` target (`supabase/functions/_shared/grading-router.ts:71-80` and
`:119-122`). The branch accepts a selected choice key or text from `response_parts`, exact-matches
it against the one correct choice, awards 0/1, uses no model, and writes
`model_id='rule-based-mcq'` (`supabase/functions/evaluate-attempt/index.ts:1082-1155`).

That path already works in Production, as the live grading-result counts above establish. STEP 2
needs coverage for a served Biology MCQ flowing through it, not a new grading algorithm.

## 4. Options compared

### A. Put `practice_format` on MCQ and widen `select_practice_frqs`

**Reject.** `targeted_drill` currently has a database-enforced, documented meaning for FRQ only.
This option is not just a cheap filter edit: it requires changing
`content_items_practice_format_check`, changing the column contract/comment, migrating data,
returning or synthesizing `item_type` so the client does not default the row to FRQ, and deciding
whether the semantic change applies to 43 Biology MCQ or all 783 MCQ.

If applied product-wide, the other 740 MCQ become eligible at once. If applied only to Biology, the
other subjects do not change immediately, but the shared column and widened selector create an
implicit future on-ramp for them, and the schema would no longer encode the current product model.
Either form stretches `targeted_drill` from an FRQ content classification into a generic queue tag.

### B. Add `select_practice_mcqs` and merge its result in the Edge Function

**Viable, but second choice.** It avoids the `practice_format` semantic stretch and can be gated to
Biology. However, two independent selector calls leave queue composition, proportional allocation,
stable ordering, under-filled-pool fallback, and de-duplication in the Edge Function. That makes
the application layer the source of truth for a serving policy that is easier to test atomically in
SQL. A generic sibling would also need an explicit subject rollout gate or it could expose all 740
other-subject MCQ.

### C. Biology-scoped combined selector for the existing targeted-drill session

**Recommend.** One selector owns the complete Biology queue and its mix, while all non-Biology
calls retain the existing `select_practice_frqs` behavior. It requires no content mutation, no
meaning change to `practice_format`, no label dependency, no new client session type, and no grading
change. It also gives QA one RPC whose result can be checked for exact composition and answer-free
shape.

## 5. Concrete proposed contract

### Database function

Create:

```text
app.select_biology_practice_items(
  _exam_pack_version_id uuid,
  _practice_format text,
  _selection_seed uuid,
  _limit integer default 20
)
```

Properties:

1. `LANGUAGE sql STABLE SECURITY INVOKER`, fixed `search_path = pg_catalog`.
2. Revoke EXECUTE from `PUBLIC`, `anon`, and `authenticated`; grant only to `service_role`.
3. Fail closed to zero rows unless the pack resolves to `exam_code='ap_biology'` and the requested
   format is exactly `targeted_drill`.
4. FRQ eligibility exactly mirrors `select_practice_frqs`: published item and version,
   `item_type='frq'`, `practice_format='targeted_drill'`, and not hand-drawn.
5. MCQ eligibility is published item and version, `item_type='mcq'`, and not hand-drawn. It does
   not read taxonomy labels or `practice_format`.
6. Return only the existing render metadata plus explicit `item_type`. Do not join
   `app.mcq_choices`; do not return an answer key; never use `SELECT *`.
7. Derive the FRQ/MCQ quota proportionally from the two eligible pool sizes, using largest
   remainder rounding and filling unused quota from the other pool. With today's 71/43 pool and a
   20-item request, that is **12 FRQ + 8 MCQ**.
8. Within each type, order by a deterministic hash of `_selection_seed` (the owned learning-session
   ID) and content-item-version ID, then interleave the quota. Re-fetching one session is stable,
   while different sessions do not permanently starve the 23 MCQ beyond a single 20-item window.
9. Cap `_limit` at the existing 20-item delivery limit. Keep `full_exam_frq` on the old selector;
   FF-1 must not silently absorb FF-2.

### `student-session-items`

Extend the session lookup with the pack's `exam_code`. For an owned, active AP Biology
`targeted_drill` session, call the new app-schema RPC with the session ID as the selection seed.
For every other case, call the current selector exactly as today. Pass the selected rows through
`withHandDrawnFlag` and the existing `deliverRows` unchanged.

The new function returns `item_type`, so no new confirm-transfer-style hardcoded tag is required.
The existing safe choice query and `buildRenderItem` are the reusable MCQ delivery precedent.

Add a fail-closed validation in `deliverRows`: an `item_type='mcq'` row must have a non-empty choice
list or be omitted with a non-sensitive enum reason such as `choices_missing`. Production currently
has four choices for all 43, so this is defensive and should not change the measured queue.

### Student-visible result

- Normal Biology `targeted_drill`, limit 20: 12 FRQ and 8 MCQ, interleaved, subject to the existing
  media/visibility omission gate.
- Biology `full_exam_frq`: unchanged (currently empty).
- Biology NULL-format session: unchanged (`session_practice_format_unset`).
- Other subjects: unchanged item-for-item because they continue calling `select_practice_frqs`.
- Each MCQ contains stem/stimulus, `item_type='mcq'`, and choices containing only
  `choice_key`/`choice_text`; it never contains `is_correct` or `rationale`.

## 6. Blast radius on the other nine subjects

The recommended branch is gated by `exam_code='ap_biology'` in both routing and selector SQL.
Therefore the following published MCQ remain exactly as they are today and do not become eligible
on the practice path:

| Subject | MCQ | Effect under C |
| --- | ---: | --- |
| AP Calculus AB | 60 | None |
| AP Calculus BC | 63 | None |
| AP Chemistry | 68 | None |
| AP Physics 1 | 63 | None |
| AP Physics 2 | 40 | None |
| AP Physics C: E&M | 48 | None |
| AP Physics C: Mechanics | 41 | None |
| AP Precalculus | 53 | None |
| AP Statistics | 304 | None |
| **Total outside Biology** | **740** | **None** |

The existing FRQ queues for these subjects also remain item-for-item unchanged because their RPC,
arguments, ordering, limits, and delivery path do not change. Generalizing the combined selector to
another subject must be a later explicit rollout with that subject's own measured pool and QA.

## 7. Security invariant and functional proof

### Boundary design

The live grants are correct and must not change. Production currently gives `authenticated` SELECT
on exactly `id`, `content_item_version_id`, `choice_key`, `choice_text`, and `created_at` in
`app.mcq_choices`. The public view has no `is_correct` or `rationale` column.

The authenticated functional probes run during this design pass produced:

- `SET LOCAL ROLE authenticated; SELECT choice_text FROM app.mcq_choices LIMIT 1;` — succeeded;
- the same projection of `is_correct` — SQLSTATE **42501 permission denied**; and
- the same projection of `rationale` — SQLSTATE **42501 permission denied**.

Because `student-session-items` uses a service-role client, column grants do not protect its query.
Its explicit choice projection is the operative boundary. The new selector should be invoker-rights
and should not touch choices at all; if implementation instead makes any serving function
`SECURITY DEFINER`, its explicit return list becomes the only database boundary and `SELECT *` is
forbidden.

### Required post-build authenticated probe

QA must use a real non-admin student access token, not the service key and not a SQL inspection:

1. Start or reuse an owned active Biology `targeted_drill` session.
2. Invoke `/functions/v1/student-session-items` with that student's bearer token and
   `{ "learning_session_id": "...", "limit": 20 }`.
3. Assert HTTP 200; exactly 20 items before any legitimate media omissions; 12 FRQ and 8 MCQ; every
   MCQ has four choices; each choice's key set is exactly `choice_key,choice_text`.
4. Recursively scan the complete raw JSON body and fail if any object key equals `is_correct` or
   `rationale` anywhere, not merely under `choices`.
5. With the **same student token**, issue Data API projections against `app.mcq_choices`: verify
   `choice_text` succeeds and both `is_correct` and `rationale` return 403/permission denied.
6. Create an attempt for one served MCQ with `attempt_mode='mcq'`; save a selected choice in
   `response_parts.selected_choice_key`; submit it; then invoke `evaluate-attempt`. Assert the
   pre-submit grading call is rejected, the post-submit call returns the rule-based 0/1 result, and
   neither response reveals the correct key or rationale.

This probe proves the end-to-end authenticated response boundary. Static checks of grants, function
source, or TypeScript projections are useful supporting evidence but do not satisfy it.

## 8. STEP 2 acceptance tests proposed

If this design is approved, STEP 2 should include:

- SQL integration: Biology targeted-drill returns the expected proportional mix, explicit
  `item_type`, stable same-seed order, different-seed rotation, no hand-drawn items, and zero rows
  for a non-Biology pack.
- SQL privileges: only `service_role` can execute the new function; its declared columns contain no
  answer-bearing field.
- Edge unit tests: Biology routes to the combined selector; every other subject/format uses the old
  selector; MCQ choices are safe; missing choices fail closed; session ownership remains enforced.
- Attempt integration: a selected NULL-format MCQ creates an `attempt_mode='mcq'` attempt without
  `practice_format_mismatch`; an FRQ mismatch still returns the existing error.
- Grading integration: known-correct and known-wrong submitted MCQ yield 1/1 and 0/1 through
  `rule-based-mcq`, with zero model tokens and no pre-submit key exposure.
- Authenticated functional probe: all six checks in section 7 pass against the deployed QA target,
  then are repeated after Claude applies to Production.

## 9. Explicit non-goals

- No content-row updates and no `practice_format` migration.
- No grant widening and no change to either secret MCQ column.
- No taxonomy-label promotion and no use of the unit-gated selector.
- No change to confirm-transfer semantics.
- No fix for `full_exam_frq` or the general empty-queue reason (FF-2/FF-15).
- No rollout of MCQ practice serving to the other nine subjects.

**STOP:** this document is the STEP 1 deliverable. Implementation requires explicit approval.
