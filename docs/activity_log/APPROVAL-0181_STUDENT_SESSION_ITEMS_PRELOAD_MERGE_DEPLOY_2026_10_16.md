# APPROVAL-0181 — Deploy the merged `student-session-items` (teaching_image + current_mcq_answer) to Production

**Decision:** Approved and deployed; verified.
**Date:** 2026-10-16
**Approver:** Product Owner David Bloom ("Yes, deploy it to Production")
**Tier:** Hard-Gate (live Edge Function)

**Why:** David reported "The answer key for this question isn't available here" on served learn-mode questions (e.g. AP Biology topic 1.4). Investigation found a backend/app version skew: Production's function (v40, 2026-10-10 14:43 UTC, carries the worked-example `teaching_image` branch of APPROVAL-0151, which is not on `main`) predates the `current_mcq_answer` preload (commit e153c867, 2026-10-11) that `main` and the published app call. Production ignored the request and returned the ordinary page.

**Change:** three-way merge of Production's deployed source and `main` against their merge-base `23f84d17` (no conflicts; both features present; 40 tests pass; `deno check` clean; PR david-bloom/Cramapple#476). Deployed with `supabase functions deploy student-session-items --project-ref pcntajvbdfqhbeewmdry --use-api` as **v41**, JWT-verified. Development verified first: `current_mcq_answer` returns the current question's choices (exactly one correct); the ordinary page stays answer-free.

**Production check:** the page's `current_mcq_answer` call now returns 4 choices with exactly one correct on every "Show another". The worked-example item still renders with its key.

**Rollback:** Production v40's exact source is saved (`tmp/ssi_prod_v40_rollback/`, gitignored); redeploy it with the same command from a workdir containing it.

**Not changed / open:** the learn-mode key panel for served (non-worked-example) MCQs still reads "isn't available here". The server returns `mcqFeedback` only after a graded attempt, and the app uses the preloaded answer only when a choice is submitted (message present since the 2026-10-10 canvas rebuild, af13de4). Showing the preloaded key up front in learn mode is an app change, not made here.
