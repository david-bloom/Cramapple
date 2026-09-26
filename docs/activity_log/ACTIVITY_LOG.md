# Activity Log

This log records meaningful operating activity, approvals, closeouts, blockers, and handoffs. Newest entries are at the top.

## Index

Most recent entries (full reverse-chronological list follows below):

- October 2 Launch Operating Cleanup (2026-09-26): David confirmed Friday, October 2, 2026 as the free-launch date. Added `PROJECT_SETUP.md` and `docs/product/LAUNCH_RUNBOOK_2026_10_02.md`; resolved D-1 for this launch because the live app/home page already exists; moved labels/difficulty and payment work off the October 2 flat-path critical path; made a brand-new-student entitlement-to-grading smoke test an explicit stop condition; and rotated the oversized activity, decision, and approval logs into lossless archives. Documentation only — no code, deployment, migration, secret, or Production mutation. **Branch:** `codex/launch-plan-operating-kit-cleanup`. **Approval state:** documentation under Standing Approval; launch remains a Hard Gate requiring David's final go/no-go.
- Session Close: PR #201 (Six Launch-Readiness Plans + DECISION-0069 Through 0073), #202 (Student Home Design Direction), and #203 (P0 Remediation Verification Closeout) All Merged to `main` (2026-09-26): Closing out the launch-planning session below. When PR #201 was marked ready for review, GitHub surfaced a real merge conflict: `main` had independently landed its own `DECISION-0068` (TASK-0039 Phase 1, BYOQ parallel tables) while this branch had claimed `DECISION-0068` through `0072` for five unrelated launch-planning decisions. Merged `main` in and renumbered this branch's five decisions to `DECISION-0069` through `0073` per this log's own stated collision convention (later-merging branch renumbers) — content unchanged, only the IDs moved, across `DECISIONS_LOG.md`, `ACTIVITY_LOG.md`, `MASTER_TODO.md`, and all six launch-plan docs; added a footnote recording the collision. PR #201 then merged clean (`14aee72`). David separately asked to merge #202 (still draft; marked ready for review, then merged clean, `baa1dbe`) and #203 (already ready, CI green, docs-only; merged clean, `f189543`). No code/schema/production changes in any of the three — all documentation. **Still open, not resolved by any of this**: the entitlement-gating bug in `attempt-response`/`use-grade-practice.ts` (flagged 2026-09-20, re-confirmed this session) remains unfixed; `SUBJECT_SERVABILITY_CRITERIA.md`'s own AP Statistics row still doesn't reflect the 2026-09-25 pilot-pack retirement; BIZ-001's remaining items (access duration, refunds, parent-purchaser handling) are undecided but deferred past Friday's free launch. **Next Owner:** David Bloom. **Next Required Action:** none blocking Friday's launch specifically; the entitlement bug should get a real fix before payment flow resumes post-launch. — 2026-09-26
- Six Launch-Readiness Plans Drafted + DECISION-0069 Through DECISION-0073 Recorded, Friday Free-Launch Confirmed Ready Pending One Unfixed Bug (2026-09-26, PR #201, branch `claude/launch-planning-cram-4oyh2g`, not yet merged; note: these decisions were originally numbered 0068-0072 and renumbered at merge time to avoid colliding with `main`'s own independently-landed DECISION-0068 below — see the DECISIONS_LOG.md footnote): David asked for a set of component launch plans an AI agent could run to completion and know when that part of the app is ready for students. Wrote `docs/product/APP_LAUNCH_READINESS_INDEX_2026_09_26.md` plus five component plans (marketing home page, payment flow, content pipeline, student hub, subject onboarding gate), each citing existing canonical docs rather than re-deriving requirements. **Two independent AI reviews (a second Claude session, then Fable) found the first draft was built without reading `docs/product/APP_REBUILD_MIGRATION_PLAN.md` (2026-09-22, David-approved) — a newer plan it directly conflicted with**: the design system cited was retired, the payment plan's "nothing exercised yet" was six weeks stale (a real customer had already paid via live Stripe), and the index's "run in parallel" framing contradicted David's recorded build sequence. Corrected all three in place with visible CORRECTION blocks, verified each claim against source files (including resolving a git-history contradiction on AP Statistics' exam-pack hazard by comparing exact commit timestamps) before writing anything. **David then made five real launch decisions, each recorded and threaded through every affected doc: DECISION-0069** (Day-1 subjects are AP Biology + AP Statistics, pricing $39.99/$79.99/$99.99 single/2-bundle/3-bundle — flagged the 2-bundle carries effectively no discount, still unconfirmed); **DECISION-0070** (BYOQ ships ungated/anonymous on the new home page, unlimited tier deferred until all 10 subjects live, target window "next week," wordmark-only branding); **DECISION-0071** (superseding 0070 — launch Friday, free, no Stripe/payment gating at all; payment flow plan moved entirely off the critical path, becomes a post-launch follow-up); **DECISION-0072** (extends `DECISION-0063`, the existing Biology-only "launch on the flat/practice path, unit-gating deferred" policy, to AP Statistics too — resolving it as a Day-1 subject despite Statistics having the strongest unit-gated coverage of any subject); **DECISION-0073** (identifies the actual launch frontend as `ap-prep-canvas.lovable.app` — a third option, not either candidate this session had framed; first guess was wrong, corrected with real evidence once David supplied the live HTML: the page's own `og:image` meta embeds another project's screenshot URL, confirming the true project as "Remix of Cramapple App," `d334fed9-5a97-4e76-906e-7c0ad7082212`). **Verified directly against Lovable-hosted source** (read-only, no code changed) that the live page already fully matches the new orange/Bungee design system (an earlier "stale branding" finding was real but pointed at a stale cached screenshot, not the live page) and, critically, that the practice/grading flow is genuinely production-wired — `src/lib/use-grade-practice.ts` calls the real `session-event`/`attempt-response`/`evaluate-attempt` edge functions documented elsewhere in this repo (TASK-0016's rollout), not mocked; only the home-page hero's `FrqDemo.tsx` (under `src/components/marketing/`) is a scripted demo, which is expected. This also independently confirmed the entitlement-gating bug flagged 2026-09-20 (unentitled `attempt-response` calls hit a generic "Couldn't score that" error) lives in exactly this real code path — **the bug itself was not fixed this session**, only documented and cross-referenced. Live page currently still shows a $39.99/Stripe purchase CTA, stale against the free-launch decision; David is fixing this himself directly in Lovable (a "Free this week!" banner) rather than delegating it. Also updated `docs/MASTER_TODO.md`'s BIZ-001/GTM-001 items to reflect DECISION-0069. **Net assessment given directly to David: five of six original launch-readiness areas are in good shape or correctly descoped for Friday (marketing page, payment-on-hold, content-pipeline-not-needed, student-hub-and-grading-confirmed-real, subject-gate-not-blocking); the one real open risk is the unfixed entitlement-gating bug.** All work is docs-only in this repo (no schema/code/deploy changes); PR #201 still open/draft, not merged — see Approval State below. — 2026-09-26
- TASK-0039 Phase 1 Approved: BYOQ Data Model Uses Parallel Tables, Not the Live Graded Pipeline (DECISION-0068, APPROVAL-0050, 2026-09-26): David approved Decision needed #1 and Phase 1 scope. Two adversarial review passes this session (of the initial plan, then of a proposed unified schema that would have generalized `app.attempts`/`app.response_versions`/`app.response_attachments` in place) found the "generalize the live tables" option's safety premise false — `app.record_manual_grade` has no content check and `app.prevent_client_grading_truth_update` exempts `service_role`, both confirmed directly against Production — so a BYOQ item could reach the real human-grading queue under that design. Decision: BYOQ gets its own parallel tables (`app.byoq_items`/`app.byoq_responses`, later `app.byoq_capture_pairing_tokens`/`app.byoq_attachments`), no shared code path with the graded pipeline to leak through. Also approved: `TASK-0039` Phase 1's schema, a separate BYOQ Practice screen (never branching inside the live graded screens), and the Home entry point. Explicitly **not** approved: Phase 2 (still needs its Pre-flight verification step), Phase 3 (still needs `docs/product/BYOQ_WORKSHEET_PARSING_DESIGN.md`'s Open Decisions resolved), and `TASK-0039`'s "New gaps" list (entitlement, quotas, retention, consent copy, promotion boundary, subject scoping, stuck-BYOQ routing, hints floor) — none of that is resolved by this approval. No code changed this entry.
- TASK-0039 Drafted: BYOQ Production-Operational Plan, Phased, Awaiting Product Owner Approval (2026-09-25): wrote `docs/tasks/TASK-0039-BYOQ-PRODUCTION-OPERATIONAL.md`, a Hard-Gate task covering Home entry point + Practice MCQ/FRQ serving of a student's own item (Phase 1), QR photo capture of a single BYOQ question (Phase 2), and worksheet upload split into multiple questions (Phase 3, explicitly undesigned — blocked on its own design doc). Grounded directly against Production rather than docs alone: confirmed `app.capture_pairing_tokens`/`app.response_attachments`/the `capture-pairing` edge function are real, deployed, and working, but `upload_purpose` is hard-check-constrained to the single literal `'DRAWN_RESPONSE'` and `content_item_version_id`/`response_version_id`/`attempt_id` are all `NOT NULL` — a BYOQ photo has no library content to bind to, so Phase 2 needs its own decision (parallel tables, recommended, vs. relaxing the live table's constraints). Also confirmed Practice MCQ/FRQ are now live in the production Lovable app as of 2026-09-24 (see that entry below) — BYOQ's job is to extend those screens, not build new ones. Confirmed no worksheet-splitting precedent exists anywhere (OCR research on record is entirely about grading hand-drawn responses, not parsing a document into questions) and that `docs/product/BYOQ_UPLOAD_POLICY_AND_DATA_LIFECYCLE_DISCUSSION_2026_09_23.md`, referenced by the 2026-09-23 entry below, is no longer present in the repo. No code changed. **Next Owner:** David Bloom. **Next Required Action:** approve/revise TASK-0039's scope and Phase 2's Decision needed #1 (parallel tables vs. extending the live capture-pairing tables).
- AP Biology Shipped to Production and Set to Launch on the Practice Path (2026-09-24): nine migrations applied and verified, DECISION-0062 and DECISION-0063 logged, four silent serving failures found and a standing check built. See `docs/product/SESSION_STATUS_2026_09_24.md`.
- Practice MCQ and Practice FRQ Wired to Live Production Supabase (Lovable, New Cramapple App); Two Real Bugs Found During Verification, Both Still Open (2026-09-24): Practice MCQ and Practice FRQ (the CramApple Design System screens imported earlier this session) were wired to real Supabase data and real server-side grading, replacing local/localStorage grading entirely — confirmed working end-to-end against Production with a throwaway test student account (real MCQ correct/incorrect verdicts, real FRQ per-criterion grading with ↻ never ✕ on missed points). Verification surfaced two real, still-open issues, both independent of this session's own changes: **(1) content gap, urgent** — the AP Statistics exam pack version new students are auto-assigned (2027-05-18, 203 MCQs) has zero published FRQs; only an older pack (2027-05-11) has FRQ content, so FRQ practice is currently broken for any real student landing on the default pack. **(2) backend bug** — `student-session-items` does not reliably honor its `item_type` filter (returned zero MCQs for one pack, FRQs when MCQs were requested for another); a client-side fallback was added in the Lovable project to query published items directly as a workaround, mirroring an existing workaround already present in `src/hooks/use-session.ts` for this same known AP Statistics pilot gap, but the root cause is unfixed server-side. Also not yet done: true in-browser verification of `/practice-mcq` and `/practice-frq` (blocked by production CORS not allowlisting the Lovable build sandbox's origin — the data/grading contract was verified directly against the real edge functions instead, which is a legitimate but partial substitute for loading the actual rendered pages). Production data created during verification: one test student account (`cramapple-qa-test+practice-verification-1790183201@cramapple.com`), a free-trial entitlement, two learning sessions, and three graded attempts (2 MCQ, 1 FRQ) — clearly labeled test data, left in place. — 2026-09-24
- Hand-Drawn Capture Reviewed Against a Separate Codex BYOQ Upload-Policy Discussion Draft; Consent Notice Added (2026-09-23): David asked for review of a Codex-authored discussion draft (`docs/product/BYOQ_UPLOAD_POLICY_AND_DATA_LIFECYCLE_DISCUSSION_2026_09_23.md`, not approved, general BYOQ upload policy) against TASK-0038's hand-drawn capture work. Found the draft's first-upload disclosure requirement applies to hand-drawn capture too (its own text names the hand-drawn scoring feature), and its student-initiated-deletion section directly conflicts with `app.response_attachments`' immutability trigger (`BEFORE DELETE OR UPDATE`, blocks all deletion including `service_role`, added on purpose by TASK-0025 for grading-dispute/audit integrity — confirmed live against Production). **David's direction:** add simple consent copy (not a blocking step, no recorded-acceptance event) and disregard the deletion section entirely — it was discussion only, not a decision. Added a Terms/Privacy consent notice with a PII reminder to `CaptureItem.tsx` (the real `/session` hand-drawn capture component), shown before and during every capture; `tsc`/Vitest clean (401/402, same one pre-existing unrelated failure). No backend change made. `exam-buddy-wireframe` commit `677728c`. — 2026-09-23
- TASK-0038 Phase 4 Operational Commitment Approved (DECISION-0059, APPROVAL-0049, 2026-09-23): David approved the pilot-scale grading commitment proposed this session — scope limited to `APBIO-HDG-2026-GRAPH-002` only; grader is David Bloom personally (no qualified-reviewer roster exists yet); 24-hour grading SLA with at least daily queue checks; disputes handled as a manual, logged SQL correction rather than product tooling (no regrade RPC exists); the repair-authoring gap (`record_manual_grade` always passes `highestValueGap: null`, so a manually-graded student sees a score but no repair prompt) accepted as-is for the pilot rather than blocking on it; a two-stage rollout where `/session-hand-drawn-pilot` stays admin-gated until David personally runs one real end-to-end loop under real (non-simulated) conditions — the one Phase 3 acceptance criterion never yet exercised — before any named small group gets access, with no further widening without revisiting this decision. Explicitly does **not** close TASK-0020 Program C's Hard Gate, which still needs the full multi-owner design (Learning Quality, Operations, Privacy/Security) for any broader launch — this covers only the narrow pilot scope one Product Owner can approve alone. TASK-0038 is now Phase 1-4 complete; the one remaining open item is Stage 1's real end-to-end run, not yet performed. — 2026-09-23
- TASK-0038 Phase 4 Done (Infrastructure; Operational SLA/Grader Commitment Still Open): Real Hand-Drawn Grading Queue Built, an RLS Gap and a Dead Storage-Permission Check That Both Blocked Real Cross-User Admin Grading Found and Fixed, One Transcription Bug Caught Before It Reached Production (2026-09-23). Investigating what Phase 4 actually needed surfaced a real finding: `app.attempts`/`app.response_attachments`/`app.grading_results` RLS is owner-only with **no admin bypass** — the original single-attempt admin grading page read these tables directly via the authenticated client, which only ever worked because every attempt graded through this pilot so far has been an admin's own test submission (0 real rows, ever, per the Phase 1/2 audit). A real admin grading a real student's attempt would have hit RLS and failed on the read side; separately, `storage-sign-url`'s `ownsLearnerPath` check had **no admin exception at all** for `sign_download`, so `canAccessBucket`'s own admin clearance for `learner-uploads` was dead code — the photo itself was unreachable too. Fixed both: two new admin-only, service-role `attempt-response` operations (`list_manual_grading_queue`, `get_manual_grading_context`) replace the RLS-blocked direct reads; `storage-sign-url` gained a narrow admin exception scoped to `sign_download` only (upload/delete stay strictly owner/admin-delete). **Caught a real bug mid-session**: an intermediate manual retype of `storage-access.ts` while assembling the large multi-file deploy payload swapped `validator` for `content_author` on the `validation-artifacts` bucket rule — caught by diffing the deployed Dev content against local disk before promoting to Production, fixed, and redeployed with the correct rule confirmed via Dev/Prod content-hash match before Production ever ran the bad version. Also verified the much-larger `attempt-response` deploy (13 files, hand-retyped shared modules) byte-for-byte against local source with a comment/whitespace-stripped diff — 2 files showed only stripped-comment differences, zero logic drift, before pushing to Production. Both functions deployed Dev then Prod (hash-matched); 2 new unit tests (both new operations refuse a non-admin caller before ever touching the service client). Frontend: new `/admin/grade-response` queue-list route (`list_manual_grading_queue`); the existing per-attempt page rewritten to call `get_manual_grading_context` instead of direct RLS-bound reads. Verified: `tsc --noEmit` clean, `vite build` succeeds with both routes registered, Vitest 401/402 (same one pre-existing unrelated failure carried all session). **Left for David, not an engineering task**: TASK-0020 Program C names operationalizing manual grading (reviewer queue, qualifications, SLA, dispute path, capacity) as its own Hard Gate — the queue now works, but nobody has committed to who grades and how fast; that decision, not more code, is what has to happen before `/session-hand-drawn-pilot`'s admin gate comes off for real students. — 2026-09-23
- TASK-0038 Phase 3 Done (Still Admin-Gated): Real `/session` Can Now Serve and Capture a Hand-Drawn Pilot Item (2026-09-23). Investigation found the gap was narrower than scoped: `CaptureItem`/`prepareCaptureSlot`/`submitCapturedResponse` were already wired into the real `SessionFrame`/`use-session.ts` (built for TASK-0016 Phase D2's QR capture) — the standalone `/hand-drawn-pilot` page never touches that machinery, it's a separate bespoke one-off. The actual missing piece was a way for real `/session` to *reach* a promoted item at all. Backend: new migration `20260923170000_select_hand_drawn_pilot_items.sql` — a dedicated selector RPC (deliberately separate from `select_practice_frqs`/`select_unit_gated_practice_items`, which Phase 1 made actively exclude hand-drawn items), double-filtered on `hand_drawn=true AND label_status='human_graded_pilot_approved'`; applied Dev then Prod, live-verified returning exactly `APBIO-HDG-2026-GRAPH-002` and nothing else. `_shared/student-item-delivery.ts` gained a safe `response_mode: "typed"|"hand_drawn"` field on the student-facing payload, derived from a raw `prompt_json` read that happens in exactly one place (`student-session-items`'s new `withHandDrawnFlag`) so the rest of `prompt_json` (answer-bearing fields like `expected_graph_spec`) never has to flow downstream. New `mode: "hand_drawn_pilot"` branch in `student-session-items/index.ts`; deployed Dev then Prod, byte-identical content hash confirmed, Dev smoke-tested clean (401, no crash). Fixed a pre-existing stale unit test along the way (key-allowlist test missing `choices`/`item_type`, unrelated to this change) and flagged a separate pre-existing, unrelated breakage — `student-session-items/index_test.ts`'s fixtures use non-UUID session ids and every test fails on a strict UUID check (confirmed via `git stash` isolation, spawned as follow-up `task_dff018c9`, not fixed this session. Frontend (`exam-buddy-wireframe`): `servedItemToQuestion` now derives `kind: "hand_drawn"` from the server's `response_mode`; new `UseSessionOptions.handDrawnPilot` flag; new route `/session-hand-drawn-pilot` mounts the real `SessionFrame`/`useSession` against the real selector — admin-gated and unlinked from nav, same posture as the existing pilot page, since **Phase 4 (a real human-grading queue) does not exist yet** — a real student submitting today would land in `human_review_pending` with nothing committed to resolve it, so opening this route to real students is explicitly Phase 4's go-ahead, not this one's. Verified: `tsc --noEmit` clean, `vite build` succeeds with the new route registered, full Vitest suite 401/402 (same one pre-existing unrelated failure this repo has carried all session). Committed and pushed to `main` in both repos (backend `864c22aa`; frontend `e16c72d`, merged clean with unrelated upstream Lovable work at `053c37d..7e5cbf5` -- a `.lovable/plan` doc plus a `vite-tanstack-config` version bump, `tsc --noEmit` re-verified clean post-merge). **Lovable publish NOT triggered this session** — pushing to `main` does not deploy; publishing is its own explicit step, left for David per this repo's standing practice. — 2026-09-23
- Older entries: [`ACTIVITY_LOG-2026-06-09_to_2026-09-22.md`](archive/ACTIVITY_LOG-2026-06-09_to_2026-09-22.md)

**Rotation rule:** once this log exceeds ~400 lines, archive the older (bottom-of-file) entries to `docs/activity_log/archive/ACTIVITY_LOG-<range>.md` and update this index. Keep the index itself to the last ~10 entries.

---

## October 2 Launch Operating Cleanup — 2026-09-26

**Task:** Launch operating-kit and execution-plan cleanup
**Tier:** Standard documentation; October 2 launch remains Hard-Gate
**Status:** Ready for Review
**Branch:** `codex/launch-plan-operating-kit-cleanup`

David confirmed the free-launch date as Friday, October 2, 2026. Added the missing root
`PROJECT_SETUP.md` so the README's operating-kit link is valid and both Claude and Codex enter through
`CRAMAPPLE_SESSION_START.md`. Added `docs/product/LAUNCH_RUNBOOK_2026_10_02.md` as the short launch
execution surface. It makes public CTA verification, a brand-new-student free/trial entitlement and
grading round trip, Biology and Statistics flat-path smoke tests, BYOQ safety/copy verification,
fresh-context QA, and David's go/no-go the October 2 critical path.

Updated DECISION-0071 and the launch index with the exact date, resolved D-1 for this launch because
DECISION-0073 already confirms the live app and home page exist, and moved payment plus the
labels/difficulty pipeline to post-launch for the two approved flat-path Day-1 subjects. Rotated the
three oversized activity logs into linked archive files with entry-count verification; no historical
entry was discarded.

No code, deployment, migration, secret, payment, or Production change was made.

**Next Owner:** Main Conductor / David Bloom
**Next Required Action:** Review this documentation branch, then package the runbook into assigned
Claude/Codex workstreams. Any live change or launch decision follows the recorded Hard Gates.

## AP Biology Shipped to Production and Set to Launch on the Practice Path — 2026-09-24


**Task:** AP Biology completion + launch readiness
**Status:** Nine migrations applied and verified; launch path decided; two agents in flight
**Summary:** Biology moved from zero applied migrations to nine. M0 (span store), M3 (difficulty
store), M4 (remove `prompt_json.total_points` from 16 items), M2 (112 provisional coverage labels +
6 held), M1 (67 canonical answers and 548 credited-response spans) all applied to Production, plus
three repairs (M2.1, M2.2, M2.3) and a new standing check. **DECISION-0062** landed coverage labels
as `provisional_model` rather than settling the T9 vs DECISION-0055 human-validation question.
**DECISION-0063** set Biology to launch on the practice path, which serves 71 `targeted_drill` FRQ
and reads no taxonomy label or difficulty value.

The session's most consequential finding was **four silent serving failures**, three found by hand
and one only after building `app.servable_items_census()` and calling the real serving functions
instead of modelling them: 20 MCQ republished in August had silently stopped matching their content
hash and had been unservable for six weeks; M1 dropped 28 more items out of serving the same
morning; the unit-gated path has never served a Biology item at all and serves 8 items across all
ten subjects; and an empty item queue returns `status: ok` with no reason. None is wrong code. Each
is a design choice to report absence as normality. `scripts/qa/servable_items_check.py` now measures
this per subject, self-verifies against the real RPCs (93 ok, 0 mismatch) and fails on any drop —
but it has no trigger yet.

Four of my own claims were corrected by measurement during the session and are recorded in
`docs/product/SESSION_STATUS_2026_09_24.md`: two wrong servable-item counts computed from a
predicate no live function uses, a migration-ordering error that staled 65 labels I had just
written, and an FF-13 "blocker" that turned out to have been fixed weeks earlier.

**Next Owner:** David Bloom / Codex
**Next Required Action:** Codex is working FF-1
(`prompts/CODEX_WORK_ORDER_FF1_MCQ_SERVING_2026_09_24.md`) — make the 43 Biology MCQ reachable
through the serving contract rather than the frontend's client-side fallback, and diagnose the
`student-session-items` `item_type` filter bug reported in the entry below. Queued but not
dispatched: `prompts/CODEX_WORK_ORDER_QUEUE_2026_09_24.md` (J.0 → N → N.1). Open Product Owner
decisions: the `APBIO-FRQ-S-101` rubric split, whether drafting over published canonicals is
acceptable for S-021/S-023/S-058, the two osmosis topic corrections, and whether any serving label
is ever promoted to `validated` (without which the unit-gated path stays dark product-wide).

## Practice MCQ and Practice FRQ Wired to Live Production Supabase — 2026-09-24

**Task:** N/A (Lovable frontend wiring, New Cramapple App project, this session)
**Status:** Live and grading correctly; two known issues open (one urgent, one backend)
**Summary:** Wired the CramApple Design System's Practice MCQ and Practice FRQ screens
(imported earlier this session) to real Supabase data and real server-side grading via
`session-event` → `student-session-items` → `attempt-response` (create/save/submit) →
`evaluate-attempt`, removing local/localStorage grading (`gradeMcq`/`gradeFrq`) entirely
for these two screens. Open Hand FRQ, Open Hand MCQ, and Supabase schema/migrations were
left untouched. Connecting to Production required: adding the Lovable preview origins for
both New Cramapple App and New Cramapple Marketing to `ALLOWED_ORIGINS` (per DECISION-0029,
no wildcard fallback) and to Supabase Auth's Redirect URLs — both write-only settings with
no retrievable current value, reconstructed from known live domains (Vercel, `cramapple.com`,
existing Lovable preview URLs) rather than a saved copy, since none existed; and creating a
throwaway, email-confirmed test student account (manual `email_confirmed_at` SQL update was
needed since the sandboxed test runner has no mailbox access).

Verification against Production, using that test account, confirmed the grading chain
actually works: a correct MCQ answer graded 1/1, an incorrect one graded 0/1 with feedback;
a real 4-part FRQ item graded 3/4 with per-criterion results, the missed criterion marked
↻ (revisit) and never ✕ — the Open-Hand-only mark — matching the product rule from
DECISION-0057. This also exercised the real `entitlement_required` / trial-start path a
real student would hit, not a bypass.

Two real, still-open issues surfaced, both pre-existing and independent of this session's
code:
1. **Content gap (urgent):** the AP Statistics exam pack version new students are
   auto-assigned (`2027-05-18`, 203 MCQs) has zero published FRQs. Only an older pack
   (`2027-05-11`, 101 MCQs / 69 FRQs) has FRQ content — FRQ practice is currently broken
   for any real student who lands on the default pack.
2. **Backend selector bug:** `student-session-items` does not reliably honor its
   `item_type` request parameter (returned zero MCQs for one pack, FRQ items when MCQs
   were requested for another). A client-side fallback was added in the Lovable project
   (querying published items directly) to work around it, mirroring an existing workaround
   already present in `src/hooks/use-session.ts` for this same known AP Statistics pilot
   gap — the root cause is unfixed server-side.

Not yet done: true in-browser verification of `/practice-mcq` and `/practice-frq` as
rendered pages — Production CORS does not allowlist the Lovable build sandbox's own
origin, only its preview origin, so the sandbox verified the full data/grading contract by
calling the real edge functions directly with a real auth token instead of loading the
pages in a browser. This is a legitimate but partial substitute; someone should open the
preview URL directly to close the gap.

Production data created and left in place (clearly labeled test data): one test student
account (`cramapple-qa-test+practice-verification-1790183201@cramapple.com`,
auth id `a9b458e1-b364-492c-8267-7d0cfb5f4ae9`), one free-trial entitlement, two learning
sessions, and three graded attempts (2 MCQ, 1 FRQ). The test account's active exam pack is
currently left set to the older (`2027-05-11`) pack, not the default, since that was the
only way to reach FRQ content.

**Next Owner:** David Bloom
**Next Required Action:** Decide how to close the FRQ content gap on the default AP
Statistics pack (publish FRQs to it, or repoint new-student assignment to the pack that
has them); assign the `student-session-items` `item_type`-filter bug for a proper
server-side fix rather than relying on the client-side fallback long-term; do the
manual in-browser check of `/practice-mcq` and `/practice-frq`; decide whether to record
the reconstructed `ALLOWED_ORIGINS`/Redirect-URL values somewhere retrievable (e.g. a
`docs/architecture/` reference) so this is never unrecoverable again; decide whether to
clean up the test production data above.

## BYOQ Answer-Visibility Rule Discussed and Decided (DECISION-0057) — 2026-09-23

**Task:** N/A (product/teaching policy discussion, this session)
**Status:** Rule approved; data model and hint-throttling open
**Summary:** Investigated whether BYOQ (bring-your-own-question / photo-capture of a
student's own homework) has any path into the tables the Open Hand answer-key
lockdown protects (`app.mcq_choices`, `app.frq_criteria`) — it does not; BYOQ is
frontend-prototype-only with no backend tables today. That confirmed Open Hand
questions are always CramApple library content, never student-submitted, resolving
part of Decision 21's ambiguity. David then set the underlying rule explicitly: a
BYOQ item must never expose a canonical answer, in any mode, though it may still
receive rubric-derived hints, deep-dive material, reference content, and
win/lose-points strategy guidance. If a student is stuck on a BYOQ item, the product
should route them to a related Open Hand question and back. Recorded as
DECISION-0057. Also discussed: whether BYOQ should live in the same tables as
library content or a separate one (recommended separate, unifying only at the point
a BYOQ item is promoted to public SEO/AEO content — not yet approved); a
hint-throttling idea for students submitting multiple BYOQ items (explicitly
deferred, not ready to decide); and a captured requirement that any future BYOQ
schema needs at minimum a difficulty label and a unit/topic pair.
**Full discussion:** `docs/product/BYOQ_ANSWER_VISIBILITY_AND_DATA_MODEL_DISCUSSION.md`

**Next Owner:** David Bloom
**Next Required Action:** Decide the BYOQ data-model approach (or hold it until the
BYOQ intake design is fleshed out further); pick the hint-throttling question back up
when ready; write the Open Hand answer-key RPC (now unblocked) and the BYOQ intake
migration when scoped.

---

## Session Close — Difficulty Calibration and the Overnight Codex Program — 2026-09-23

**Task.** No Task ID. Session opened on the App Rebuild / content-gaps thread and became two
things: establishing a defensible difficulty signal, and standing up an overnight Codex program
against the Biology/Statistics content gaps.

### What changed

**1. 160 local-only files committed** (PR #163). Found at session start while checking the working
tree against the Synchronization Rule. Not drafts: 29 topic-guide seed migrations (2026-08-25→27)
whose content **is live in Production** — 603 topic point briefs and 603 explainers across ten
subjects — while **none of their versions appear in Production's migration ledger**. They were
applied as direct SQL and their source sat on one machine for a month.

**2. A difficulty method, anchored to measured attainment** (PRs #164–#167).
**College Board defines no difficulty scale.** Verified: zero occurrences of *difficult/easy/hard/
rigor/complexity* in the 2025 AP Statistics Chief Reader Report; the AP Biology and AP Statistics
CEDs mention difficulty once, as a line about exam construction, and neither ties task verbs or
Science Practices to it. So the three-level scheme is a **Cramapple decision anchored to College
Board data, not a College Board citation** — cite it that way.

What College Board does publish is per-criterion attainment. Extracted **316 scored rubric points
across 8 subjects**. Subject baselines differ by 21 points (Physics 2 0.653, Calculus AB 0.439), so
cut points are per subject.

Validation: the task-verb method scores **12/16 (75%)** against hand-verified 2025 AP Biology
points and is **100% correct at both extremes** — all four errors fell in the Medium band. Two
corrections from measured data: `calculate` → Hard (0.49, on the hard tertile) and `explain` split
(Medium for CED skill 1.B Concept Explanation at 0.57; Hard only in SP6 Argumentation context). A
blanket explain→Hard rule was tried and rejected — it alone moved the corpus from 23.7% to 53.4%
Hard. The competing cognitive-complexity method was tested and rejected: **Cohen's kappa 0.023**
against the verb method.

David's Chemistry framework validated best of the three — **9/10** against per-point attainment,
with monotonic verb ordering (identify 0.635 → calculate 0.513 → explain 0.380 → predict+justify
0.170). Statistics validated weakest (n=6, question-level; its Investigative-Task claim is
contradicted by the only data available).

**Final assignments, 0 unassigned:** Biology 118 (19.5/63.6/16.9), Chemistry 119 (44.5/43.7/11.8),
Statistics 384 (52.1/25.8/22.1).

**3. Overnight Codex program** (PRs #168–#171, #176–#177). Work orders A–D plus a run protocol,
then Project 2 (E–I). All executed overnight; all four A–D produced complete artifact sets.

**4. QA infrastructure** (PRs #173–#175). An offline QA harness recomputing every stated invariant,
with a self-test that plants known defects and asserts detection, plus a **count baseline verifying
28/28 assertions exact**.

### What was verified

- **Bio/Stats topic labels (PR #172): Biology ACCEPTED, Statistics REJECTED.** Structure was
  flawless — 502/502 items, all 73 (subject, code) pairs valid, 0 unit mismatches. Content was not:
  56 Statistics items wrong across four template-shaped classes (compare-two-groups labelled `1.7`
  not `1.9`; sampling-*method* items labelled as sampling-*distributions*; 24 graph items labelled
  off a boilerplate stem; regression placed in Unit 1). Two codes absorbed 45% of the corpus.
- **Work orders A–D: all four PASS every structural invariant.** The harness reported 46 findings
  on first run; **every one was the harness's bug, not Codex's** — recovery sources resolved only
  against the current item version, assembly-literal spans verbatim-checked against a source they
  correctly lack, and a truth snapshot that omitted retired parent `APBIO-FRQ-L-025` entirely.
- **A's recovery yield: 13 of 101.** The hypothesis that the 2026-08-12 rubric split left
  recoverable text was **right about the mechanism and wrong about the yield** — the split created
  genuinely new criteria, not finer slices. **88 criteria remain drafted (down from 118).**
  GAP-9's drafted-content problem is real, not a migration artifact.
- **49% of the FRQ library has no canonical answer** — 274 of 563, across every subject.

### A correction to my own work, recorded

I initially filed as critical that AP Statistics had zero items in Units 6–9. **That was my error.**
The current AP Statistics CED has **five** units, not nine. The registry and Codex were both right.
Consequence worth keeping: the content's author-time `subtopics` use the **legacy 9-unit**
numbering while the registry uses the current 5-unit one, so `agreement_with_author_prose='no'` on
85 items is partly an artifact of comparing two CED editions and is **not an accuracy signal**.

### What remains open

1. **The semantic QA of A–D is not done.** Structural QA passed; content correctness — does each
   drafted span earn its criterion, does each authored number re-derive — has not been checked.
   **This is Claude's, not Codex's** (DECISION-0055 independent-model gate).
2. **F and H are gated shut**: no `qa_report.md` exists in any A–D directory.
3. **Statistics topic labels**: work order E is the rework; **Codex has started it.**
4. **Biology topic labels**: accepted, awaiting Product Owner sign-off (6 flagged items).
5. **Difficulty assignments**: proposal only, unratified, and `prompt_json.difficulty` is read by
   no runtime code.
6. `app.attempt_criterion_results` has **0 rows** — nothing writes to it, though all 78
   `grading_results` carry criterion JSON. Task chip open.

### Governance findings

- **A–D reached `main`** when the protocol said branch-only. Proposals belong on a branch until
  ratified. E–I are correctly scoped to `codex/project2-2026-09-23`.
- **A stop-for-QA gate was crossed.** The canonical-answer decision requires "Biology drafts are
  QA-verified before Statistics generation begins". A and B ran the same night with no QA between.
  B's output passed structural QA, so nothing is invalid, but the gate is real — and the work
  orders that skipped it were mine. G now carries an explicit per-subject STOP-for-QA.

### Do not touch next session

- `docs/research/apstats_topic_labels_rework_2026_09_23/` — Codex's in-flight work order E.
- `docs/research/apbio_frq_segmentation_2026_09_22/` and `bio_stats_topic_tagging_2026_09_22/` —
  prior records, named as source material.
- The four A–D directories — read for QA, never edit. `qa_findings.csv` / `qa_report.md` are
  QA-owned and do not yet exist.

**Next Owner:** David Bloom (ratification) / Claude (semantic QA).
**Next Required Action:** Run the semantic QA of work orders A–D in handoff order (A first),
writing `qa_report.md` and `qa_findings.csv` into each directory with an explicit
accepted/rejected disposition line — that line is what unlocks F and H for Codex.

## Local-Only Durable Artifacts Synced to `main` — 2026-09-22

**Task.** Session start under `docs/team_charter/CRAMAPPLE_SESSION_START.md`. Step 5 (verify
current GitHub state) surfaced 160 untracked files in the working tree. The previous handoff
recorded the tree as clean and the last session-close entry described the remainder as
"pre-existing untracked topic-brief drafts." Checked rather than accepted.

**What they actually were.** Not drafts. 29 topic-guide seed migrations dated 2026-08-25 to
2026-08-27, their 27 companion `docs/product/AP_*_TOPIC_POINT_BRIEFS.md` records, the two AP
Calculus BC generator scripts, `docs/teaching/COURSE_MODE_SCORE_IMPACT_CONTENT_PROTOCOL_2026_08_27.md`,
`prompts/LOVABLE_COURSE_MODE_SCORE_IMPACT_UX_UNIT1_2026_08_27.md`, and the untracked half of
`.claude/skills/cramapple-design/` (component library, five `ui_kits` screens, `docs/new_design/`
token CSS, bundle, manifest, `github.md`).

**Evidence (read-only, Cramapple - Production `pcntajvbdfqhbeewmdry`, 2026-09-22).**

- The content those migrations produce **is live**: 603 topic point briefs and 603 explainers
  across all ten subjects (`app.topic_point_briefs` / `app.topic_explainers`, grouped by
  `subject_key`; ap_biology 60, ap_calculus_ab 81, ap_calculus_bc 111, ap_chemistry 91,
  ap_physics_1 43, ap_physics_2 46, ap_physics_c_em 17, ap_physics_c_mechanics 41,
  ap_precalculus 58, ap_statistics 55).
- **None of the 29 versions appear in the Production migration ledger.** Filter:
  `select version, name from supabase_migrations.schema_migrations where version between
  '20260825000000' and '20260828000000'` returns exactly one row,
  `20260827010001_mcq_choices_public_view_drop_answer_key`.
- Conclusion: the seeds were applied as direct SQL, not through the ledger, and their source was
  never committed. The provenance and regeneration path for published Production content existed
  on a single machine — contrary to the Synchronization Rule in `docs/README.md`.

**What landed.** Three commits on `claude/local-only-artifacts-sync`, no database state changed.
Files were scanned for credentials before staging; none found.

**Correction to the prior session-close record.** That entry's claim "All work merged to `main`"
was accurate. An initial `gh` read in this session reported PR #162 as OPEN; it had in fact
merged at 22:59:18Z (merge commit `58b940ce`), and `b6ef2a65` is an ancestor of `origin/main`.

**Still open, not addressed here.** The Production migration ledger does not reflect how this
content was applied, so `supabase/migrations/` and the ledger disagree for this batch. Committing
the files makes the source durable; it does not reconcile the ledger. Related prior finding: the
Dev migration ledger was already recorded as untrustworthy under TASK-0027.

**Next Owner:** David Bloom
**Next Required Action:** Review and merge the PR. Then decide whether the migration-ledger
divergence for this batch is reconciled (repair-mark the 29 versions as applied) or accepted and
documented as a known seed path.
