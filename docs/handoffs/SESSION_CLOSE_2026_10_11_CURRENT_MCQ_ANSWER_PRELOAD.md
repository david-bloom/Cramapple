# Session Close — Current MCQ Answer Preload and Instant Feedback

**Date:** 2026-10-11  
**Task:** `TASK-0071`  
**Decision:** `DECISION-0117`  
**Approval:** `APPROVAL-0161` — implementation and PRs only  
**Production:** untouched; deploy and app publish remain a Hard Gate

## Outcome

The current MCQ's answer can be present in browser memory before submission, so the app shows the
existing answer-key feedback immediately after a choice click. Server grading remains authoritative and
continues in the background for attempt persistence, score and mastery.

Only one answer is requested at a time. The ordinary question-serving page remains answer-free, and the
client clears the cached answer whenever the displayed item changes.

## Review artifacts

| Repository | Commit | Pull request | Scope |
|---|---|---|---|
| `david-bloom/Cramapple` | `e153c867` | [#421](https://github.com/david-bloom/Cramapple/pull/421) | Edge Function contract, validation, tests and canonical records |
| `david-bloom/ap-prep-blueprint` | `885b14e` | [#14](https://github.com/david-bloom/ap-prep-blueprint/pull/14) | In-memory preload, immediate feedback, background-save states and tests |

At final status read, app PR #14 was **merged** with CI successful. Backend PR #421 remained **open and
mergeable**, with Minimal CI, Vercel preview, Vercel Agent Review and Preview Comments all successful.
Merging the app repository does not itself publish the Lovable app; Production remained unchanged.

## Backend contract and gates

`student-session-items` accepts:

```json
{
  "learning_session_id": "…",
  "current_mcq_answer": { "content_item_version_id": "…" }
}
```

It returns choices, correctness and rationales for one version only when the caller owns an active
session, the item belongs to that session's exam pack, the item and version are published, the item is an
MCQ, and exactly one choice is correct. No table/view grant changes and no migration are involved.

## Client behavior

- Preload after the current MCQ is read; retain the result in React state only.
- Clear it on item change or once authoritative feedback arrives.
- On submit, render the normal feedback shape locally without waiting for the network.
- Keep the existing grade, persist and read-back chain running.
- Disable question navigation while persistence is pending.
- If persistence fails, keep the feedback visible and offer retry using the in-memory payload.
- If preload fails, use the previous server-only flow.

## Verification completed

- Backend `deno check`: passed.
- Backend tests: 35/35 passed.
- Frontend focused tests: 56/56 passed.
- Frontend full suite: 1,011/1,011 passed.
- Frontend production build: passed.
- `git diff --check`: passed in both repositories.
- Repository-wide frontend lint is not a usable baseline gate: 6,008 existing errors, predominantly
  formatting. No unrelated bulk-format change was made.

## Deployment boundary and order

Nothing in this session authorizes or performs a Production change. After both PRs are reviewed and
merged, the explicit Production approval should name both actions:

1. deploy the updated `student-session-items` Edge Function;
2. publish the app build carrying the frontend PR;
3. run a signed-in MCQ smoke that confirms immediate feedback, the saving state, persisted attempt, and
   correct next-question behavior.

Publishing the frontend first is fail-soft because an unrecognized preload response is ignored, but the
backend-first order makes the intended contract available before the UI requests it.

## Exact next action

David reviews and merges Cramapple PR #421; app PR #14 is already merged. If the backend is satisfactory,
grant a separate Hard-Gate approval for the coordinated Production function deploy and app publish. No
additional product decision is waiting.
