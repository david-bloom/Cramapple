# TASK-0050 - Open Hand Answer-Key Serving Contract

Status: Dev migration and RPC verified; evaluate-attempt Dev deploy pending approval
Tier: Hard-Gate
Owner: Codex
Product Owner: David Bloom
Date: 2026-09-27

Renumbered from TASK-0049 on 2026-09-28. TASK-0049 belongs to the Biology/
Statistics six-criterion label remediation, which two Production migrations
(`task0049_promote_*`) and an active Codex prompt already cite by number. This
work carried the same number by mistake and had no durable citations of its own,
so it was renumbered rather than annotated in place — the same correction main
made for the `attempt_criterion_results` writer (commit `734cf286`).

## Outcome

Build the narrow backend exception that lets an authenticated student view a
full answer key in Open Hand mode while permanently preventing that same
student from receiving a score for that exact content item version.

## Contract

`public.get_open_hand_item(p_learning_session_id, p_content_item_version_id)`:

- requires `auth.uid()`;
- requires an active learning session owned by that user;
- requires a published item/version in the session's exact exam pack;
- atomically and idempotently inserts `(user_id, content_item_version_id)` into
  `app.open_hand_scoring_exclusions`;
- returns every MCQ choice with `is_correct`, `rationale`, and an MCQ
  `minimum_fix` derived from `rationale`;
- returns FRQ canonical answers plus every criterion with points, evidence
  requirements, accepted variants, and authored `minimum_fix`.

Ordinary student answer-key grants and views are unchanged. The exclusion table
has RLS forced, no `anon` or `authenticated` table grants, and only the service
role may read it directly.

## Scoring Behavior

`evaluate-attempt` checks the exclusion immediately after validating the owned
attempt, confirming its response version is submitted (`response_not_submitted`
otherwise), and resolving its content version. A matching row returns
HTTP `409` with:

```json
{ "error": "open_hand_item_not_scorable" }
```

The rejection happens before the content version, MCQ choices, FRQ criteria, or
other answer-bearing records are loaded. A failed eligibility lookup returns
HTTP `500` with `open_hand_eligibility_check_failed`; scoring never proceeds on
an unknown eligibility state.

Submission state is deliberately read from the response version
(`response_version.is_submitted`), not from `attempts.status`. A QA pass
(2026-09-28) asked whether an explicit `attempts.status = 'submitted'` gate
should be added; it must not be. `index.ts`'s own audit note records that
`attempts.status`/`graded_at`/`score_points` are 0% populated in Production —
the write that would set them has apparently never succeeded on real traffic
(suspected `attempts_prevent_client_grading_truth_update` trigger). Gating
scoring on that column would gate on a field that is never written.

## Access Decision

`student-session-items` selects ordinary queues at request time and does not
persist each delivered item. Therefore the RPC cannot prove prior membership in
a stored delivery list. Its narrow equivalent check mirrors the real serving
boundary: an owned active session plus a published item/version in that
session's exact exam pack. The RPC intentionally has no admin ownership bypass.

## O9 Decision

MCQ has no authored `minimum_fix` column. TASK-0050 derives that response field
from the existing rationale, avoiding a schema addition and content-authoring
pass. This can be overridden later without changing the security contract.

## Files

- `supabase/migrations/20260928023843_open_hand_answer_key_contract.sql`
- `supabase/functions/evaluate-attempt/index.ts`
- `supabase/functions/evaluate-attempt/index_test.ts`
- `docs/product/ARCHITECTURE_AND_DESIGN_DECISIONS_CURRENT.md`

## Verification

Local checks:

- [x] `deno check supabase/functions/evaluate-attempt/index.ts`
- [x] `deno test --allow-env supabase/functions/evaluate-attempt/index_test.ts`
- [x] migration applied to Development with migration history

The migration file was originally authored as `20260928022517` but Development
recorded it as `20260928023843`, because `apply_migration` stamps its own
version at call time rather than using the filename. The file was renamed to
match Development (2026-09-28); Development's table and function were confirmed
identical to the file first (same four columns, types, nullability, `now()`
default; `SECURITY DEFINER`), so this is timestamp drift, not divergence. The
rename matters because the migration is not idempotent — a bare `create table` —
so a `db push` that still saw the old filename as un-applied would fail on
"relation already exists". The same drift exists on TASK-0039's BYOQ migrations,
so treat it as a property of MCP-applied migrations generally, not a one-off.

Dev hard-gate checks:

- [x] apply migration to Development only;
- [x] confirm `anon` and `authenticated` still cannot directly select
  `mcq_choices.is_correct` or `mcq_choices.rationale`;
- [x] confirm anonymous, foreign-session, inactive-session, cross-pack, and
  unpublished-item RPC calls fail;
- [x] call the RPC twice and assert the same key plus one exclusion row;
- [ ] deploy `evaluate-attempt`, submit a matching attempt, and assert
  `409 open_hand_item_not_scorable`;
- [x] run database advisors; the new no-policy/private-table INFO and
  authenticated/ownership-checked definer WARN are intentional.

The Development Edge Function deploy was blocked by the platform safety reviewer
because the existing bundle exceeded its 200,000-byte review limit. It requires
explicit Product Owner approval before retrying; no workaround was attempted.

Production remains blocked until Dev evidence is recorded and the Product Owner
explicitly approves the production migration/deployment hard gate.
