# TASK-0071 — Preload the Current MCQ Answer for Instant Feedback

**Status:** Code complete; app PR [#14](https://github.com/david-bloom/ap-prep-blueprint/pull/14) merged with CI green, backend PR [#421](https://github.com/david-bloom/Cramapple/pull/421) open and mergeable with all checks green. Production untouched.
**Tier:** Standard implementation; **Hard Gate** for any Production function deploy or app publish.
**Owner:** Codex session. **Product Owner:** David Bloom.
**Date opened:** 2026-10-11
**Decision:** `DECISION-0117`
**Approval:** `APPROVAL-0161` (implementation only; not Production)
**Session close:** `docs/handoffs/SESSION_CLOSE_2026_10_11_CURRENT_MCQ_ANSWER_PRELOAD.md`
**Related:** `TASK-0053` (distractor-specific feedback), `TASK-0056` (direct-read closure)

## Outcome

An MCQ can reveal its result immediately after the student chooses an answer. The browser preloads the
answer metadata for exactly the question currently displayed and retains it only in React memory. The
existing authoritative grading, attempt persistence and mastery updates still run on the server.

## Contract

`student-session-items` accepts one additive request shape:

```json
{
  "learning_session_id": "…",
  "current_mcq_answer": { "content_item_version_id": "…" }
}
```

The function returns ordered choice keys and text, `is_correct`, and the authored rationale only when:

- the caller owns an active learning session;
- the version belongs to that session's exam pack;
- both the item and version are published;
- the item is an MCQ; and
- the choices contain exactly one correct answer.

The ordinary queue remains answer-free. It can still preload up to ten questions, but this answer request
is one version at a time and is issued only for the current question.

## Client behavior

1. When the current MCQ changes, clear the prior answer from memory and request the new one.
2. On submission, build the existing MCQ feedback shape locally and switch to review immediately.
3. Keep the normal server grade/persist/read-back chain running in the background.
4. Disable navigation while that write is pending. If it fails, retain the feedback and offer a retry with
   the in-memory submission payload.
5. Replace the local feedback with the authoritative server response once the read-back succeeds.
6. If preload fails, fall back to the prior server-only behavior.

## What this does not change

- No table or view grant is widened. Direct reads of answer-bearing columns remain revoked.
- No multi-question answer page is returned.
- The client result does not update attempts, mastery or any other durable state.
- FRQ answer handling and Open Hand exclusions are unchanged.
- No Production function deploy, app publish or database change is authorized by this task's approval.

## Verification

- `deno check supabase/functions/student-session-items/index.ts`
- `deno test --allow-env supabase/functions/student-session-items/index_test.ts` — 35/35
- Frontend focused tests — 56/56
- Frontend full Vitest suite — 1,011/1,011
- Frontend production build — passed

The repository-wide frontend lint target is not a usable gate on this baseline: it reports 6,008 existing
errors across the project, overwhelmingly formatting violations. No bulk formatting was performed.

## Rollback

Remove the client's `current_mcq_answer` request and local optimistic feedback state, then remove the
matching function branch. With either side absent, the existing server-only grading path remains the
fallback.

## Next action

Review and merge backend PR #421. The coordinated Production Edge Function deploy and app publish require
a new, explicit Hard-Gate approval.
