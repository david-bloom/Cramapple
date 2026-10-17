# APPROVAL-0188 — MCQ coaching boundary and runtime answer-leak check, Production `more-help` v4 (2026-10-16)

**STATUS: EXECUTED 2026-10-16 23:14 UTC.** Production `more-help` is v4 (deployed from PR #478's branch; first attempts were blocked by the tool permission classifier until the owner replied that he grants retry permission). Post-deploy: Production lists v4 ACTIVE; an unauthenticated POST returns 401. Not yet exercised by a real student request: the owner smoke test must confirm that a pre-submit MCQ is delivered (if the Production gateway key cannot call the checker model, MCQ help fails closed with `help_unavailable`).
**Approver:** David Bloom (chat, 2026-10-16: "For 1, 2 and 3 yes"). Production `more-help` v3 → v4.

## What changes (vs v3, commit 111e1ffd)
1. **MCQ coaching boundary** (`contract.ts`): before submission, the model is told not to state the deciding fact, rule, relationship or conclusion, to use an action headline, and to point to the fact to read.
2. **Runtime answer-leak check** (`verify.ts`, wired in `handler.ts` and `index.ts`): for pre-submit MCQ help only, after generation and before commit, `google/gemini-3.8-flash` (a different family from the author, Anthropic Haiku 5.5) sees the question, the choices, the correct choice (read server-side with the service role; students still cannot read `is_correct`) and the draft help, and answers whether the help reveals the answer. A leak is refused as `answer_disclosure` (diagnostic `runtime_check`) and the lease is released. If the check cannot run, the request fails closed as `help_unavailable` (503). FRQs and post-grade help are not checked (FRQs keep the deterministic stated-conclusion rules).
Both layers apply to the live subjects as well (Calculus AB/BC, Chemistry, Statistics MCQs).

## Evidence
- 39 backend tests pass.
- Checker validation on 13 real Dev outputs (no student quota used): it flagged the 3 clear old leaks (Biology 3.1, 2.2, 3.5) and passed all 7 outputs written under the new boundary. A first run had 4 errors because Gemini's reasoning exhausted a 400-token limit; fixed with `max_tokens 2000` and low reasoning, and the rerun had 0 errors.
- Dev v21 end to end: 2 of 2 delivered (one took 26 s, probably a cold start).
- Production prerequisite, read-only: `service_role` can read `app.mcq_choices.is_correct`; `authenticated` cannot.

## Risks to watch
- One extra gateway call and added latency per pre-submit MCQ help; cost not measured.
- Fail-closed: if the Production gateway key cannot call the checker model, every pre-submit MCQ help fails with `help_unavailable`. Verify in the owner smoke test.
- The checker can wrongly flag legitimate help (the student sees "couldn't connect"). Sample is small: 13 judged, no false positive among the 7 new-boundary outputs.

## Rollback
Redeploy the v3 source: `git checkout 111e1ffd -- supabase/functions/more-help`, then `supabase functions deploy more-help --project-ref pcntajvbdfqhbeewmdry --workdir <repo> --use-api`.

## Follow-up 2026-10-16 (owner smoke test): rewrite loop, Dev v22, NOT in Production
Owner smoke test on Production v4: Physics 1 MCQ `apphy1-mcq-004` (name the third-law partner) was refused (`answer_disclosure`, "couldn't keep this explanation within setup guidance"). Replay of the exact question with Production's facts: the older pattern checks passed 6 of 6 drafts; the runtime check flagged 6 of 6 (the help said to swap the two objects, i.e. it gave the answer). Owner asked why the check does not fix what it flags.
Change: the check's reason is now sent back to the author model (`revisionNote`, key never shared, previous draft not repeated) for a rewrite, at most 2 rewrites, each re-checked; help is refused only if the rewrites still leak; a checker outage still fails closed immediately. Replay: 6 of 6 flagged drafts were repaired by one rewrite (e.g. "Write down which object exerts the force and which receives it, then state the paired force in your own words"). 40 backend tests pass; Dev `more-help` v22. Cost: one or two extra author calls plus checks on flagged requests only. Production still v4 until the owner approves v5.
