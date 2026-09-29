# TASK-0051 — Open Hand: One Gated Answer-Key Path

**Status:** Approved to execute in Development. Production Hard-Gated.
**Tier:** Hard-Gate
**Owner:** TBD (single agent, single branch)
**Product Owner:** David Bloom
**Date opened:** 2026-09-29
**Decision:** `DECISION-0086` (supersedes the competing designs)
**Approval:** `APPROVAL-0061`
**Plan:** `docs/product/OPEN_HAND_BRANCH_RESOLUTION_PLAN_2026_09_29.md`
**Supersedes:** the TASK-0050 label previously carried by `codex/task-0049-open-hand-answer-key`
(TASK-0050 now belongs to the skill-dimension rollout). That branch has now renumbered twice; this
is its final number.
**Area:** Open Hand / answer-key exposure / scoring integrity

## Outcome

One gated path by which a student may see a full answer key, which atomically records that they saw
it and permanently prevents them being scored on that exact content item version — replacing two
competing half-implementations with a single one.

## Decisions this implements (`DECISION-0086`)

- **D1 (c) — Access is entitlement-scoped, with a mandatory exclusion write.** Any authenticated
  user holding an active entitlement for the item's subject may view, on a servable pack. Staff/QA
  roles may view **and are exempt from the exclusion write** — excluding a reviewer from scoring is
  meaningless.
- **D2 (a) — Unify on the RPC.** `open-hand-item` calls `public.get_open_hand_item` rather than
  reading answer tables directly, so the exclusion insert and the key read happen in one statement
  and no window exists in which a student has seen the key without an exclusion row.
- **D3 — This work is TASK-0051.**

## What has to change, and why it is not just plumbing

The existing RPC implements **D1 (a)**, not D1 (c). Adopting D1 (c) requires amending it:

1. **Access predicate.** Replace "owns an active learning session containing the item" with "holds
   an active entitlement for the item's subject, on a servable pack" (`status='published' AND
   retired_at IS NULL`, subject itself active — `SUBJECT_SERVABILITY_CRITERIA.md` criterion 6).
2. **Staff/QA bypass.** The RPC today has *no* admin bypass, by deliberate design. D1 (c) adds one,
   scoped to view-only, and those callers must skip the exclusion insert.
3. **Schema change — `learning_session_id` is `NOT NULL`.** Verified in Dev 2026-09-29:
   `app.open_hand_scoring_exclusions` is `(user_id, content_item_version_id, learning_session_id,
   disclosed_at)`, all `NOT NULL`. Under entitlement-scoped access a caller may have no learning
   session at all, so the insert cannot satisfy that column. **Recommend making it nullable** —
   record the session when one exists, null otherwise — since decoupling from session ownership is
   the entire point of D1 (c). The alternative, continuing to require a session, collapses D1 (c)
   back into D1 (a) in practice.
4. **Payload parity.** `get_open_hand_item` must return what `open-hand-item` returns today, or the
   non-answer parts (`topic_explainers`, `topic_point_briefs`) stay as direct reads in the edge
   function. They are not answer-bearing and do not need to be inside the RPC.

## Blocker on the critical path

`evaluate-attempt` cannot be deployed. Measured 2026-09-29: `index.ts` is 89,616 bytes and, with its
20 direct `_shared` imports, **289,938 bytes** — a floor, transitive imports uncounted — against the
platform safety reviewer's 200,000-byte limit. This blocks the enforcement half in **both** Dev and
Production. Resolve by obtaining the explicit Product Owner approval the reviewer asks for, or by
shedding ~90KB+ from the import closure. **Do not attempt a workaround**; the original session
correctly declined to.

## Severity context — do not let this get re-escalated or forgotten

Step 0 established that **no student-facing exposure exists today**: `open-hand-item` is deployed in
Dev with **no caller**, the Open Hand screens are demo-only components fed local sample content with
no network call, Dev's exclusions table holds 0 rows, and Production has no `open-hand-item` at all.

The gap becomes real **the moment the plate loop is wired to live data**, which is what
`PLATE_LOOP_BUILD_PLAN_2026_09_27.md` sets out to do. **The exclusion mechanism must land in the
same change as that wiring, not as a follow-up.** That is the one scheduling constraint here.

## Verification

- [ ] Amended RPC applied to Development; entitlement-scoped access confirmed; staff/QA path
      confirmed to view without writing an exclusion row.
- [ ] Anonymous, unentitled, retired-pack and unpublished-item calls all confirmed to fail.
- [ ] Called twice for the same student/item: same key returned, exactly one exclusion row.
- [ ] `anon` and `authenticated` still cannot directly select `mcq_choices.is_correct` or
      `.rationale`.
- [ ] End-to-end, as one sequence: view an item's key through Open Hand, submit an attempt on that
      same item, assert `409 open_hand_item_not_scorable`.
- [ ] Negative case: an item never viewed in Open Hand still scores normally.
- [ ] Database advisors run; any new INFO/WARN explained.
- [ ] Fresh independent QA in a new context, not a continuation of the implementing session.
- [ ] Production: migration + both function deploys, as one coherent change, on David's explicit
      approval.

## Branch handling

Consolidate onto a single branch. Close the losing PR with a pointer rather than deleting it, so the
reasoning stays on record. Carry across #256's non-duplicated assets — its `minimal-ci.yml` wiring,
its tests, and `PLATE_LOOP_BUILD_PLAN_2026_09_27.md` — and the codex branch's migration and task
record.
