# Activity Log

This log records meaningful operating activity, approvals, closeouts, blockers, and handoffs. Newest entries are at the top.

## Index

Most recent entries (full reverse-chronological list follows below):

- Cramapple-Wide QA Pass: AP Biology Publish Gap Found; Governance Paperwork and Test-Account Cleanup — 2026-07-03
- AP Statistics Hand-Drawn Graph-Response Seed QA'd and Staged — 2026-07-02
- AP Statistics Smoke Batch QA-Fixed and Published Live — 2026-07-01
- AP Statistics Phase 2 Migration Applied; MCQ + Short FRQ Smoke Batches Staged — 2026-07-01
- Legacy Blueprint Files Relocated to `legacy/` — 2026-07-01
- AP Statistics Launch Task Drafted (TASK-0013) — 2026-06-30
- Hand-Drawn Graph Corpus Realism Fix and Four-Finding Spot-Check — 2026-06-30
- New-User Experience Live QA — 2026-06-29
- Production Readiness QA Handoff — 2026-06-21
- Cramapple Visual Identity Brief Revised From Family Discussion — 2026-06-21
- Session and Storage Backend Surfaces Wired — 2026-06-21
- Cramapple Visual Identity Brief Drafted — 2026-06-21
- Production Plumbing Session Handoff — 2026-06-20
- Supabase Production Migrations and Storage Policies Drafted — 2026-06-20

**Rotation rule:** once this log exceeds ~400 lines, archive the older (bottom-of-file) entries to `docs/activity_log/archive/ACTIVITY_LOG-<range>.md` and update this index. Keep the index itself to the last ~10 entries.

---

## Cramapple-Wide QA Pass: AP Biology Publish Gap Found; Governance Paperwork and Test-Account Cleanup - 2026-07-03

**Task:** Cross-cutting, relates to TASK-0012, TASK-0013.
**Status:** One urgent new finding surfaced, not yet fixed. Two cleanup items closed.

**Summary:** At David's request for "what remains for AP Bio and AP Stats
beyond tutor approval and payment," did a live QA pass across both
subjects rather than relying on prior session notes.

**Finding (urgent, unresolved): AP Biology has zero published content in
Production.** All 242 `app.content_items`/`content_item_versions` rows for
AP Biology (100 MCQ + 142 FRQ) sit at `status = 'draft'`.
`evaluate-attempt` (`supabase/functions/evaluate-attempt/index.ts:875-879`)
unconditionally requires `content_items.status`, `content_item_versions
.status`, and `exam_pack_versions.status` to all equal `'published'` — Bio's
exam pack version is published, but no individual item is, so real student
attempts should currently fail with `content_not_published` (409) across
the board. Across the entire database, AP Statistics (36 items, published
2026-07-01) is the *only* subject with any published content right now.
This directly contradicts a successful live grading walkthrough recorded
in "New-User Experience Live QA" (2026-06-29) — timeline/cause not yet
investigated. Not fixed in this session; flagged for the next session to
root-cause before assuming Biology grading works.

**Governance paperwork closed:** confirmed most AP Statistics docs
(`TASK-0013.md`, the MCQ/FRQ smoke batch, three prompt files) were already
committed and pushed by a parallel process (commit `0027e7a`). Committed
and pushed the remaining four files this session had produced (
`docs/research/ap_statistics_graph_response_seed_2026_07_02/`,
`scripts/generate_ap_statistics_graph_response_seed.py`,
`prompts/LOVABLE_SIGNUP_DYNAMIC_SUBJECTS.md`,
`prompts/LOVABLE_HOMEPAGE_DEMO_FRQ.md`). Recorded `DECISION-0033` in
`DECISIONS_LOG.md`, formalizing three previously chat-only instructions:
publishing AP Statistics content without tutor review (2026-07-01), the
rights/originality-is-not-a-blocker clarification (2026-07-03, restates
`DECISION-0031`'s existing no-official-material policy rather than
reopening it), and showing AP Statistics as live/selectable on `/signup`
for feedback and tutor-recruiting purposes given payment isn't live
(2026-07-03).

**Test-account cleanup closed, via disable rather than delete.** Checked
FK constraints before acting: `created_by` on this session's content
(`content_items`, `content_item_versions`, `content_ingest_batches`,
`content_ingest_rows` — 123 rows total) is `ON DELETE NO ACTION`, so a hard
delete would have simply failed rather than cascading. But
`content_review_assignments` (5 rows) and `content_review_decisions` (3
rows) reference these accounts as `reviewer_id` with `ON DELETE CASCADE`
— real historical Biology reviewer-workflow QA data, not test noise a hard
delete would have destroyed. Set `auth.users.banned_until = '2099-01-01'`
for all four test accounts (`tutor-a`, `tutor-b`, `reader-a`,
`admin@cramapple-test.internal`) instead — login disabled, referential
integrity and review history intact.

**Next Owner:** David Bloom.
**Next Required Action:** Investigate and fix the AP Biology publish gap
before assuming Biology grading works for real students. If Biology
content actually needs the same manual promotion AP Statistics got, that's
a materially bigger action (242 items vs. 36) and should get the same
explicit go-ahead DECISION-0032/0033 got.

---

## AP Statistics Hand-Drawn Graph-Response Seed QA'd and Staged - 2026-07-02

**Task:** TASK-0013 (AP Statistics, Subject 2) Phase 4; relates to TASK-0011 (hand-drawn graph grading).
**Status:** Staged for tutor review only. Not reviewed, not published. Content and generator script authored by Codex in a separate worktree (`/Users/davidbloom/.codex/worktrees/da74/Cramapple`), QA'd and migrated by Claude.

**Summary:** At David's request, QA'd Codex's
`scripts/generate_ap_statistics_graph_response_seed.py` (840-line
deterministic generator, no randomness, PIL-based reference-image rendering)
and the 12 AP Statistics graph-response FRQs it produced (6 archetypes x 2:
boxplot, segmented bar, mosaic plot, dotplot, scatterplot, curve
annotation). Independently recomputed every numeric/statistical claim in
all 12 items rather than reading them at face value. Found one real error:
`APSTATS-HDG-2026-GRAPH-010`'s canonical answer claimed 82 cm should not be
called a definite outlier; recomputing the standard 1.5xIQR rule on that
item's own dataset (Q1=71.5, Q3=75.5, upper fence=81.5) shows 82 exceeds the
fence, so it IS an outlier by the rule the course teaches. Fixed before
staging. All other 11 items and the image-rendering logic checked out
exactly.

Migrated all 12 items into `app.content_ingest_batches`/`content_ingest_rows`
(Production, `pcntajvbdfqhbeewmdry`) -- staged only, matching explicit
instruction that tutors will review and approve this content, unlike the
2026-07-01 smoke batch which was published directly at David's override
instruction. No `content_review_assignments` created (no real tutor account
exists yet to assign to). Reference images were NOT uploaded to Supabase
Storage -- they exist only in the repo's
`docs/research/ap_statistics_graph_response_seed_2026_07_02/reference_images/`.
Full detail, including two flagged assumptions (1 point per criterion; no
unit-number mapping for the `modules` field) in
`docs/research/ap_statistics_graph_response_seed_2026_07_02/README.md`.

One transcription/corruption incident during manual SQL construction (row 8
briefly contained row 7's content when hand-retyping a 49KB query) was
caught before anything was sent to Production -- switched to a safer
generate-then-Read-then-submit workflow in two 6-item chunks for the actual
inserts, then verified all 12 row_keys post-insert to confirm no corruption
landed.

**Next Owner:** David Bloom / Orly Bloom.
**Next Required Action:** Assign these 12 rows for tutor review once a real
AP-Statistics-credentialed reviewer account exists. Resolve the two flagged
assumptions (points-per-criterion, unit-number mapping) before or during
that review.

---

## AP Statistics Smoke Batch QA-Fixed and Published Live - 2026-07-01

**Task:** TASK-0013 (AP Statistics, Subject 2), Phase 4.
**Status:** Live and gradeable in Production. **Not reviewed by a tutor. Rights/originality gate not evaluated.** David Bloom (Product Owner) explicitly directed this, accepting that risk after being told what it skips.

**Summary:** At David's request, ran computational QA on the 18 staged short
FRQs (recomputed every numeric claim against its stated criterion rather than
reading them) and found two real errors: `APSTATS-SFRQ-001` criterion `c1`
claimed mean ~21.4 with mean < median; correct values are mean = 23.67 (sum
213/9) and mean > median, consistent with the stated right skew.
`APSTATS-SFRQ-008` criterion `a1`/`c1` claimed E[X] = $3.20; correct value is
$1.80 (0.20(10) + 0.50(2) + 0.30(-4) = 1.8). Both fixed directly on the staged
`content_ingest_rows` before promotion. All other 16 FRQs and all 18 MCQs
checked out exactly (z-scores, regression predictions/residuals, binomial
mean/SD/P(X=5), sampling-distribution SEs, both confidence intervals, both
test statistics/p-values, both chi-square statistics, both slope-inference
results).

David then instructed: fix the errors and publish. Before publishing,
investigated (via a research subagent) what "publish" actually requires in
this schema and found the real serving/grading path is
`app.content_items`/`app.content_item_versions`/`app.mcq_choices`/`app.frq_criteria`
-- the tables marked "deprecated compatibility projection" in a 2026-06-27
migration comment, not the nominally "authoritative" `app.artifact_versions`
model (0 rows in Production, never actually used for any content, Biology
included). `evaluate-attempt` hard-gates on `content_items.status`,
`content_item_versions.status`, and `exam_pack_versions.status` all being
`'published'` independently.

The real `admin-content` publish operation (`enforceGatePolicy` in
`supabase/functions/admin-content/index.ts:156`) requires the caller to
assert `source_gate` and `rights_gate` as literally `'passed'` -- the code's
own comment admits this is currently just a client-asserted claim with no
server-side verification. Rather than write a false "rights review passed"
record into `app.release_candidates` (which did not happen), chose the
honest path: wrote directly to the compatibility tables that `evaluate-attempt`
actually reads (`content_items`, `content_item_versions`, `mcq_choices`,
`frq_criteria`, all `status = 'published'`), left `content_item_versions.review_status`
`NULL` (accurately: no tutor/reader ever reviewed this), and did not create
any `app.artifact_versions`/`release_candidates`/`publication_events` rows --
consistent with how the rest of Production content already works (that
governance-model table has 0 rows platform-wide). Flipped
`app.exam_pack_versions.status` to `'published'` for the AP Statistics exam
pack (`548f06be-ccf4-426d-b82b-b424137a4438`) and marked the 36 staged
`content_ingest_rows` as `materialized`.

Caught and fixed one transcription error of my own during manual SQL
construction: `APSTATS-SFRQ-018` criterion `d1` was accidentally duplicated
from `c1`'s text; corrected before finishing verification.

**Verified:** 36/36 `content_items` published, 36/36 `content_item_versions`
published, every MCQ has exactly 4 choices with exactly 1 `is_correct`, every
FRQ has exactly 4 criteria summing to 4 points, `exam_pack_versions.status =
'published'`.

**Next Owner:** David Bloom.
**Next Required Action:** None required, but be aware: this content is live
and gradeable to any AP Statistics student flow that exists, without ever
having been reviewed by a tutor/reader or cleared for rights/originality.
If a real AP Statistics student-facing surface goes live before that review
happens, students would see unreviewed content.

---

## AP Statistics Phase 2 Migration Applied; MCQ + Short FRQ Smoke Batches Staged - 2026-07-01

**Task:** TASK-0013 (AP Statistics, Subject 2), Phases 2 and 4.
**Status:** Migration applied to Production. Content staged for tutor review only — not reviewed, not published, not visible to students.

**Summary:** At David Bloom's request, discovered via direct Supabase access
(the first session on this task with a live DB connection) that Phase 2's
migration -- authorized by `DECISION-0032` and merged into git via PR #26 --
had never actually been applied to Production. `app.subjects` had only a
`biology` row; no AP Statistics subject, exam pack, or content labels existed.
Applied `supabase/migrations/202606300001_ap_statistics_schema_instantiation.sql`
exactly as merged (additive-only, `exam_pack_version.status = 'draft'`, per
`DECISION-0032`'s scope) to `Cramapple - Production` (`pcntajvbdfqhbeewmdry`)
after explicit confirmation. Verified: `app.subjects` row `ap-statistics`, one
`app.exam_packs`/`app.exam_pack_versions` pair (draft), 9 `app.content_labels`
unit rows.

Also generated 18 AP Statistics MCQs (2 per module across all 9 modules) using
`prompts/content/AP Statistics MCQ Prompt.txt`, confirmed as a smoke-test batch
separate from the approved 71-MCQ `DECISION-0031` pilot total. Staged them into
`app.content_ingest_batches`/`app.content_ingest_rows` -- the same tables the
`content-intake` Edge Function writes to -- rather than any live/published
content table, per the Phase 4 authoring brief's "same governance gates as
Biology, no shortcut for being a pilot" rule. No reviewer assignments were
created. Full batch and rationale recorded in
`docs/research/ap_statistics_phase4_mcq_smoke_batch_2026_07_01/`.

Also staged a companion batch of 18 short FRQs (2 per module) supplied by
David as a local file (`output/ap_statistics_frq_batch_2026_07_01.json`) --
unlike the MCQs, this content was not generated by Claude. Schema-validated
(matching part/criteria point totals, no duplicate `content_key`s, no
`hand_drawn` items) then staged the same way into
`app.content_ingest_batches`/`app.content_ingest_rows`
(`batch_id 8144a2b2-6456-4a1a-84f8-65ba5a1ecb07`), with `canonical_answer`
synthesized per row from the `criteria[].learner_facing_text` fields. No
reviewer assignments created for this batch either. Copy of the source file
and updated rationale in the same
`docs/research/ap_statistics_phase4_mcq_smoke_batch_2026_07_01/` folder.

Also noted: a second Supabase project, `Cramapple - Development`
(`wmgjsdkphcyhngaffbqf`), exists and is far behind Production (stuck at
`202606230001_prototype_student_schema`) -- flagged, not acted on.

**Next Owner:** David Bloom / Orly Bloom.
**Next Required Action:** Assign the 36 staged rows across both batches
(MCQ `batch_id 13f3f72a-e512-4982-b38c-c240d90c97d3`, short FRQ `batch_id
8144a2b2-6456-4a1a-84f8-65ba5a1ecb07`) for tutor review via the normal
`assign-for-review` pipeline, or discard/regenerate if the smoke test doesn't
need to become real content. Decide whether `Cramapple - Development` should
be brought back in sync with Production or retired.

## Legacy Blueprint Files Relocated to `legacy/` - 2026-07-01

**Task:** Housekeeping (no task ID; doc-only, standing-approval cleanup).
**Status:** Done.

**Summary:** The `Blueprint_*` planning docs and `PROJECT_SETUP.md` (dated
2026-06-08/09) were sitting in an untracked, never-committed `legacy
content/` directory (note the space) at repo root — meaning `docs/README.md`'s
Authority Order item 6 referenced "root-level `Blueprint_*` files" that did
not actually exist in git. Moved the eight files into a new tracked `legacy/`
directory and updated `docs/README.md` item 6 to point at it. Historical
references to "root-level `Blueprint_*` files" in `CRAMAPPLE_VISION.md`,
`DECISIONS_LOG.md` (`DECISION-0001` consequences), and
`TASK-0003-HIGH-LEVEL-SYSTEM-ARCHITECTURE.md` were left unchanged as
accurate-at-the-time historical record; only the current normative pointer in
`docs/README.md` was updated.

**Next Owner:** David Bloom.
**Next Required Action:** None — informational. Confirm before merge if this
should also be reflected in `CRAMAPPLE_VISION.md`/`DECISIONS_LOG.md`.

## AP Statistics Launch Task Drafted (TASK-0013) - 2026-06-30

**Task:** TASK-0013 (new — AP Statistics, Subject 2)
**Status:** Spec drafted, Hard-Gate tier, `Ready for Review` / Awaiting Owner
Approval. No implementation has started; this is plan-only.

**Summary:** At David's request, assessed which AP subject is the closest
technical match to AP Biology among the subjects Orly (AP Statistics, AP
Calculus AB, AP English Literature) and Micah (AP World History) are taking
this year, on grading-architecture reuse grounds — FRQ scoring shape
(criterion/rubric vs holistic essay) and what verification technique each
needs (deterministic calculation checks, symbolic math, document-use
reasoning, or none of the above). AP Statistics ranked closest: criterion/
rubric-scored FRQs with quantitative thresholds, same scoring shape as
Biology's FRQ criterion contracts, plus a shared curriculum owner (Orly).

Drafted `docs/tasks/TASK-0013-AP-STATISTICS-LAUNCH.md` with a phased
delegation plan: Phase 1 (de-hardcode `grade-frq`/`evaluate-attempt` away
from literal "AP Biology" strings and wire the existing prompt-build-manifest
design from `CONTENT_AUTHORING_AND_PROMPT_ARCHITECTURE.md` §5 to
`subject_id`) is the one piece that blocks any second subject regardless of
which one is chosen, so it's sequenced first and delegated to Codex. Also
drafted a ready-to-fire Codex execution prompt for that phase
(`prompts/CODEX_AP_STATISTICS_PHASE1_GRADING_GENERALIZATION.md`), explicitly
marked do-not-execute pending task approval. Lovable's frontend phase is
scoped but not prompted yet, since the AP Statistics response-input UI
(typed calculation entry vs Biology's freehand graph canvas) depends on
Phase 1's output.

Confirmed via schema read that the multi-subject logical model was already
partially built: `app.subjects` exists as a first-class table
(`202606230002_subjects_normalization.sql`), and `content_key`/taxonomy
`label_type` columns are generic, not Biology-specific. The actual gap is in
the grading edge functions, not the schema.

**Next Owner:** David Bloom
**Next Required Action:** Review `docs/tasks/TASK-0013-AP-STATISTICS-LAUNCH.md`
and answer the five pending owner decisions listed in its Approval State
section (subject confirmation, content-sourcing model, pilot batch size/date,
reviewer credentialing, rights posture) before Codex Phase 1 begins.

---

## Hand-Drawn Graph Corpus Realism Fix and Four-Finding Spot-Check - 2026-06-30

**Task:** TASK-0011 (handwritten graph capture); relates to TASK-0010 gold/calibration governance.
**Status:** Research progress — generator fixed and verified. No production or content-release approval. Committed, rebased onto `main`, and opened as PR #18 (`claude/task-0012-deferred-findings`) alongside the broader working-tree cleanup; mergeable.

**Summary:** Spot-checked the in-repo hand-drawn graph generation artifacts
against four defect modes carried over from prior corpus/reference-image work:
(a) pen-type tradeoff (legibility vs point-position precision), (b) recurring
"carrying capacity" in student-facing text, (c) synthetic data that lands on
uniform/consecutive-integer sequences that are not real noise, and (d) paired
good/bad reference images that must isolate exactly one criterion violation.

Findings against the 2026-06-29 v0.1 corpus (`HDG-2026-P1-*`): (b) clean — zero
student-facing or reviewer occurrences; (a) only partially handled — the Orly
protocol logs `writing_instrument` after the fact but the 150-item capture
instruction is identical and silent on instrument; (c) failing and systemic —
no replicate-level data (SEM was an arithmetic formula), 60/90 uniform x-grids,
only 5 categorical mean-shapes recycled across 50 items, symmetric analytic
series; (d) absent in-repo — neither generator produces single-violation pairs,
so there are no true-negative criterion cases.

Acted on (c): rewrote `scripts/generate_hand_drawn_graph_corpus.py` to a
seeded, reproducible v0.2 generator. Every displayed mean and SEM is now derived
from synthetic replicate observations (stored per point for audit); two noise
scales give off-model scatter plus a legitimate irregular SEM; x-grids are
non-uniform but clean; displayed values are integer means / one-decimal SEM; and
shapes are RNG-varied per item. Output written to a NEW package
`docs/research/hand_drawn_graph_corpus_2026_06_30/` (prefix `HDG-2026-P2-*`); the
v0.1 package is left untouched and stays bound to the 100+ pages already drawn.

**Verified:** Generator runs and is bit-for-bit reproducible across runs
(identical JSONL hash). Re-running the v0.1 audit checks on v0.2: uniform x-grids
4/100 (was 60/90), uniform/fake SEM 0/100 (was 13/100), distinct categorical
shapes 50/50 (was 5), non-integer means 0 and non-1dp SEM 0, replicate-derived
SEM varies within every item, real off-model scatter in 49/50 series items. A
late-binding closure bug in the peak branch (corrupted 13 items) was found and
fixed; peak items now render proper optima with mild scatter. v0.1 dir confirmed
unmodified.

**Open / not done:** (a) pen-type is still uncontrolled (no felt-tip caution,
no matched-instrument capture sets); (d) single-violation negative cases still
do not exist — required before criterion precision can be measured; v0.2 has no
trace-set renders yet (`generate_hand_drawn_trace_sets.py` still targets v0.1);
no adjudicated dual-human gold exists for any image; external multimodal grading
remains blocked on Product Owner data-transfer approval. These gate any
learner-facing automated graph score per the drawn-response architecture review
and TASK-0010.

**Next Owner:** David Bloom (Product Owner).
**Next Required Action:** Decide the next collection/test focus — recommended
order: (1) reviewer blind-scoring pass to establish adjudicated gold (no provider
needed), (2) author single-violation responses for true negatives (finding d),
(3) point the trace renderer at the v0.2 package if drawable pages are wanted.
Review/merge PR #18 (note: TASK-0012 decisions were renumbered to DECISION-0029
CORS / DECISION-0030 budget to resolve a numbering collision with `main`).

## New-User Experience Live QA - 2026-06-29

**Task:** UX-001 (year-aware onboarding); Lovable-built student app at cramapple.com
**Status:** QA findings proposed — NOT passed. Pass/Done decision is the Product Owner's.

**Summary:** Live walkthrough of the new-user flow on cramapple.com via the
connected Chrome browser, signed in as `dbloom01@gmail.com` (so QA ran on the
owner's real account, leaving test data: one completed setup, one practice
session, one submitted MCQ). The `/signup` purchase wizard and account creation
could not be exercised (payment/account creation are prohibited agent actions),
so the commercial funnel is verified only to step 1 ("Which AP subject are you
buying?", 4-step, AP Biology available).

Working: landing page; `/account-created` welcome screen (prior dead-end
regression is fixed); setup-complete guard (`/account-created` → `/home` for a
returning user); `/setup` one-screen composed surface matching the design
(exam panel, course-position copy, time selector defaulting to 15 min,
recommended-session card, secondary "Other ways to start"); time selector;
`Start session` → `/session/mcq`; MCQ cold attempt → submit → "1 of 1 point"
feedback in an accessibility live region → Continue/Retry; returning Home
recommendation card. No console errors observed during the flow.

Defects found:
1. (HIGH) `/setup` course-position controls are unwired — "Change" opens no unit
   picker and "Yes, that's right" has no visible effect (silent no-op, no console
   error). Learner cannot confirm/adjust course position, breaking a locked
   onboarding decision.
2. (HIGH — needs confirmation) `/account-created` primary CTA "Set up my first
   session" did not navigate to `/setup` on first pass; could not reproduce
   because the page now forwards to `/home` (setup complete) and the owner's
   account state was not reset to retest.
3. (MEDIUM-HIGH) Exam date wrong/stale: `/setup` shows "Tuesday, May 12, 2026"
   with "0 days from today" — a past date with a clamped countdown. An Aug 2026
   beta needs the 2027 administration date.
4. (MEDIUM) In-app pages (`/setup`, `/session/mcq`) render in a cramped ~210px
   left column at desktop width; marketing pages render full-width — an app-shell
   container issue.
5. (LOW) Page titles leak the internal "UX-001" dev label (e.g. "MCQ attempt —
   Cramapple UX-001").

Fix prompt drafted: `prompts/LOVABLE_UX001_FIX_SETUP_DEFECTS.md` (covers #1–#4
plus the #5 minor).

**Next Owner:** David Bloom (Product Owner) for pass/Done decision; Lovable for
fixes once approved.
**Next Required Action:** Run `LOVABLE_UX001_FIX_SETUP_DEFECTS.md`; confirm the
welcome-CTA navigation with a true first-time user; resolve the exam-pack date
source (data, not just frontend). Do not treat the new-user experience as
launch-ready until #1 and #3 are fixed and re-verified.

## Production Readiness QA Handoff - 2026-06-21

**Task:** TASK-0012 / production-readiness review
**Status:** Handoff Logged; Live Function Boundary Still Unverified End-to-End
**Summary:** Captured the current state so the next session can resume cleanly. The local repo is on `claude/task-0012-qa-fixes` at `c5a4f93`, and PR #12 fixes are present locally: audit-event idempotency now scopes to `(request_id, reason_code)` via `supabase/migrations/202606210001_audit_events_idempotency_per_operation.sql`, and shared Supabase env validation now fails fast at module load in `supabase/functions/_shared/supabase.ts`. Live Vercel route checks for `/beta/start`, `/beta/resume`, and `/beta/admin/health` returned `200`, but direct POSTs to `https://cugmpcpdeqkaqmyyqujx.supabase.co/functions/v1/session-event`, `/evaluate-attempt`, and `/admin-content` returned `404 NOT_FOUND`, so the configured Supabase project still does not expose the expected function endpoints. The code review also established that the repo contains no `useServerFn`, `createServerFn`, or `_serverFn` call sites, so any remaining Lovable backend coupling would have to be confirmed in the live runtime/network tab, not from source alone.

**Next Owner:** Main Conductor / Claude QA
**Next Required Action:** Verify the live beta network path against the intended Supabase function origin, confirm beta/prod Supabase isolation in the dashboards, and enumerate any remaining `admin-content` defects as explicit checklist items before cutover.

## Cramapple Visual Identity Brief Revised From Family Discussion - 2026-06-21

**Task:** No tracked task number yet (brand/visual identity work; not yet filed under docs/tasks)
**Status:** Brief Revised; Color/Mark Direction Still Unresolved
**Summary:** Transcribed a full-family recorded brand discussion (David, Orly, Micah, Nama, plus the kids as target-user panel) and revised `docs/product/CRAMAPPLE_VISUAL_IDENTITY_BRIEF.md` against it. Changes: added buyer-timing segmentation (2-month/1-month/cram cohorts) plus an ongoing-class-support segment; flagged an open, unresolved question on whether parents should lead messaging over students, especially early in the cycle; added explicit voice guidance to not lead with "AI" as the sell and to use the family/primary-source story as evidence of rigor rather than founder-story novelty; clarified that "feels like a really good tutor" is an interaction-tone target distinct from the Apple/Chrome visual-brand-temperature target; added semantic/functional color use for criterion-level grading feedback (correct/partial/incorrect) as a deliberate palette exception; added a seasonal grade-now/exam-later copy framing note; and flagged programmatic per-question SEO landing pages as a real design-system requirement needing a template. Color palette (mono+green leaning) and logo mark (Option A vs. B) from the prior session remain unresolved and untouched by this revision.

**Next Owner:** David Bloom
**Next Required Action:** Resolve the buyer-order open question (student-first vs. parent-first messaging) and confirm or amend the new Voice/Color additions; separately, still owes a decision on the mono+green palette and mark Option A/B from the prior session.

## Cramapple Visual Identity Brief Revised From Family Discussion - 2026-06-21

**Task:** No tracked task number yet (brand/visual identity work; not yet filed under docs/tasks)
**Status:** Brief Revised; Color/Mark Direction Still Unresolved
**Summary:** Transcribed a full-family recorded brand discussion (David, Orly, Micah, Nama, plus the kids as target-user panel) and revised `docs/product/CRAMAPPLE_VISUAL_IDENTITY_BRIEF.md` against it. Changes: added buyer-timing segmentation (2-month/1-month/cram cohorts) plus an ongoing-class-support segment; flagged an open, unresolved question on whether parents should lead messaging over students, especially early in the cycle; added explicit voice guidance to not lead with "AI" as the sell and to use the family/primary-source story as evidence of rigor rather than founder-story novelty; clarified that "feels like a really good tutor" is an interaction-tone target distinct from the Apple/Chrome visual-brand-temperature target; added semantic/functional color use for criterion-level grading feedback (correct/partial/incorrect) as a deliberate palette exception; added a seasonal grade-now/exam-later copy framing note; and flagged programmatic per-question SEO landing pages as a real design-system requirement needing a template. Color palette (mono+green leaning) and logo mark (Option A vs. B) from the prior session remain unresolved and untouched by this revision.

**Next Owner:** David Bloom
**Next Required Action:** Resolve the buyer-order open question (student-first vs. parent-first messaging) and confirm or amend the new Voice/Color additions; separately, still owes a decision on the mono+green palette and mark Option A/B from the prior session.

## Session and Storage Backend Surfaces Wired - 2026-06-21

**Task:** TASK-0012
**Status:** In Progress
**Summary:** Replaced the remaining `session-event` and `storage-sign-url` Edge Function scaffolds with authenticated production implementations. `session-event` now creates, resumes, saves, and ends `app.learning_sessions` rows with idempotent audit logging, while explicitly returning a clear unsupported response for anonymous-session attachment until the schema supports it. `storage-sign-url` now validates bucket/path scope, enforces learner-owned `learner-uploads` paths, issues signed upload/download URLs, and performs admin-only cleanup deletes. The function set still passes `deno check`. Browser smoke on the local prototype pages succeeded. The Supabase project roots responded, the updated Edge Functions were deployed to `pcntajvbdfqhbeewmdry`, and the live function routes now return `401` instead of `404`, confirming they are exposed at the expected boundary.

**Next Owner:** Main Conductor
**Next Required Action:** Verify the Vercel-facing app routes in production still point at the deployed Supabase functions, then confirm whether any remaining live beta traffic still depends on Lovable-hosted backend execution.

## Cramapple Visual Identity Brief Drafted - 2026-06-21

**Task:** No tracked task number yet (brand/visual identity work; not yet filed under docs/tasks)
**Status:** Brief Draft Complete; Color/Mark Direction In Progress (unresolved)
**Summary:** Worked through David's preliminary creative brief (Google Doc) and tightened it into `docs/product/CRAMAPPLE_VISUAL_IDENTITY_BRIEF.md`. Resolved several open forks: Khan Academy/Quizlet/Duolingo are stature-only references (importance to students), not visual style references; Apple/Mozilla/Chrome/Instagram are the actual style touchstones — Cramapple should read as a tech-category product, not another edtech app; identity is designed for the student, parent-facing material inherits it rather than getting a separate "credibility" register; deliverable order is voice -> typography -> color -> fonts -> logo/wordmark; product is web-first (not mobile), used at a desk late at night, so contrast and a dark-mode-first palette are hard requirements, not aesthetic preference; the brand helps the student manage urgency rather than manufacturing more of it (no countdown/FOMO devices). Explored four color directions (signal blue/Chrome-coded, graphite+amber/Apple-coded, mono+green/terminal-coded, deep violet/Instagram-coded) in both dark and light mode as inline chat mockups. David is leaning toward mono+green. Iterated the apple mark through three rounds toward more geometric, less literal forms, ending with two unresolved options: (A) a faceted straight-edged polygon silhouette that keeps a faint apple echo, (B) a fully abstract open-ring mark with no literal apple reference at all.

**Next Owner:** David Bloom (creative direction decision)
**Next Required Action:** Decide between mark Option A and Option B (or request another iteration) and confirm the mono+green palette. Note: the color/mark mockups shown this session were inline chat visualizations only — nothing was saved as a file in the repo. Once a direction is locked, the brief's Color and Logo/Wordmark sections need to be updated with the final hex values and a saved SVG of the chosen mark.

## Production Plumbing Session Handoff - 2026-06-20

**Task:** TASK-0012
**Status:** In Progress
**Summary:** Completed the first production-plumbing pass for the new Vercel/Supabase boundary. Confirmed Vercel project mapping for `cramapple` and `cramapple-dev`, set the Supabase environment split, and documented the `SUPABASE_URL` / `SUPABASE_ANON_KEY` / `SUPABASE_SERVICE_ROLE_KEY` checklist for both environments. Provisioned `Cramapple-Development` in Supabase by applying the `app` schema migrations in order, creating the private storage buckets, and verifying the seeded exam pack and account/profile rows. Verified auth and session persistence in the beta flow, then identified that the live graded attempt path was still executing through Lovable-managed `useServerFn` / `_serverFn` behavior instead of the new backend boundary.

**Next Owner:** Main Conductor, then David Bloom for continued migration sequencing
**Next Required Action:** Finish removing the remaining Lovable backend surface (`beta.admin.health.tsx`), then wire the live attempt/session/admin paths to the repo-owned Vercel/Supabase endpoints when ready.

## Supabase Production Migrations and Storage Policies Drafted - 2026-06-20

**Task:** TASK-0012
**Status:** Draft Complete
**Summary:** Converted the production Supabase schema plan into SQL migrations under `supabase/migrations/`. The migration set creates the `app` schema, profiles, exam packs, versioned content, sessions, attempts, criterion results, progress snapshots, audit events, the initial AP Biology seed, and private storage bucket policies. No live deployment or database change was applied.

**Next Owner:** Main Conductor, then David Bloom for review and live application approval
**Next Required Action:** Review the migrations and policies for any scope tweaks, then decide whether to apply them to the production Supabase project.

## Supabase Production Schema and RLS Plan Drafted - 2026-06-20

**Task:** TASK-0012
**Status:** Draft Complete
**Summary:** Drafted the production Supabase schema, RLS, and storage plan for the fresh production project `pcntajvbdfqhbeewmdry`. The plan defines the `app` schema, profiles, exam packs, versioned content, attempts, progress snapshots, audit events, private storage buckets, and the browser/server trust boundary. No live database, RLS, or storage changes were made.

**Next Owner:** Main Conductor, then David Bloom for approval and migration sequencing
**Next Required Action:** Review the schema and policy draft, decide whether any tables or bucket rules need scope reduction, and then convert the approved plan into migrations and server-side functions.

## Supabase Edge Function Draft Added - 2026-06-20

**Task:** TASK-0012
**Status:** Draft Complete
**Summary:** Added a production Edge Function draft covering assessment grading, session orchestration, storage URL signing, and admin content lifecycle operations. The draft includes a dedicated architecture note and scaffolded function entrypoints under `supabase/functions/`, but no live deployment or provider calls were made.

**Next Owner:** Main Conductor, then David Bloom for review and implementation sequencing
**Next Required Action:** Review the function catalog and decide whether the draft should be expanded into real authorization, database, and model-orchestration logic before any deployment.

## Evaluate-Attempt Production Path Implemented - 2026-06-20

**Task:** TASK-0012
**Status:** In Progress
**Summary:** Replaced the `evaluate-attempt` scaffold with a real production-grade Edge Function that authenticates the caller, loads the attempt, response version, content item, and rubric criteria from Supabase, reserves daily model budget atomically, calls the OpenAI Responses API with structured output, persists grading results, and updates the attempt record. Added the supporting `response_versions`, `grading_results`, `model_usage_ledger`, and `prompt_versions` migration.

**Next Owner:** Main Conductor, then David Bloom for review, secret setup, and live migration approval
**Next Required Action:** Review the new migration and function contract, then decide whether to wire the remaining session and admin functions to the same production ledger pattern before deployment.

## Supabase Schema Review Feedback Addressed - 2026-06-20

**Task:** TASK-0012
**Status:** In Progress
**Summary:** Incorporated Claude's review feedback by narrowing the schema-plan language to the operational learning boundary, explicitly separating the full content-governance model as a separate hard-gated task, and adding database guardrails for client-side grading-truth writes, published-content uniqueness, MCQ correctness uniqueness, duplicate-response protection, attempt rubric uniqueness, and session-query indexing.

**Next Owner:** Main Conductor, then David Bloom for approval and migration sequencing
**Next Required Action:** Review the new guardrail migration and decide whether to further decompose the content-side model into the governance task before production application.

## Full Content Governance Model Added - 2026-06-20

**Task:** TASK-0012
**Status:** In Progress
**Summary:** Added the logical content-governance schema for source provenance, rights, artifact versions, state events, commissions, author and validator qualifications, review assignments, validation suites, release candidates, manifests, publication events, incidents, and revalidation tracking. The production plan was updated to note that the governance model now exists in the migration set.

**Next Owner:** Main Conductor, then David Bloom for review of the governance migration and any wiring changes needed in the application
**Next Required Action:** Verify the new tables and decide whether the app should be rewired to them immediately or left on compatibility tables until the next release slice.

## Content Workflows Wired to Governance Tables - 2026-06-20

**Task:** TASK-0012
**Status:** In Progress
**Summary:** Replaced the admin content scaffold with a real governance-aware Edge Function that writes source, rights, artifact version, state event, release candidate, manifest, and publication records. The legacy content tables now act as a compatibility projection, and a new migration marks them as deprecated so the transition is explicit.

**Next Owner:** Main Conductor, then David Bloom for review of the content workflow wiring and compatibility projection behavior
**Next Required Action:** Decide when to rewire the remaining read path off the legacy content tables and whether to keep the compatibility projection only for a bounded transition window.

## Production Plumbing and Cutover Readiness Task Created - 2026-06-20

**Task:** TASK-0012
**Status:** Not Started
**Summary:** Added a production-plumbing task to define the environment split, production accounts and keys, backend trust boundaries, deployment and rollback expectations, observability, and cutover criteria for moving from beta validation into a governed production launch. The task intentionally stays documentation-only and does not change live secrets, migrations, or deployments.

**Next Owner:** Main Conductor, then David Bloom for approval and implementation sequencing
**Next Required Action:** Review the task scope against UX001 and UX006, then turn the approved boundaries into the concrete production setup plan.

## Beta Revised-Answer Scoring Bug Logged - 2026-06-16

**Surface:** `https://cramapple-beta.lovable.app/beta`
**Status:** Patch Prompt Drafted
**Summary:** Confirmed by manual walkthrough on the Photosynthesis light
reactions FRQ that a coached revision targeting a single missed criterion
returns `Predicted: +0   Actual: +0` and leaves the revised total unchanged
even when the revision plainly satisfies the targeted criterion. Root cause
hypothesis: the revision is graded in isolation against the full rubric, so
it silently loses credit on criteria the original earned. Recommended fix
is targeted-criterion grading: grade the revised text only against the
clicked criterion and carry every other per-criterion decision forward
from the immutable original, then recompute the total. The comparison panel
must also expose original total, revised total, per-criterion delta,
predicted gain, and observed gain. Drafted
`prompts/LOVABLE_BETA_FIX_REVISION_SCORING.md` with the bug, the (b)
grading semantics, the updated comparison fields, and an acceptance check
requiring `REVISED (3/4)` with `+1` on the reproduction.

**Next Owner:** Lovable patch operator, then David Bloom for verification
**Next Required Action:** Apply the patch prompt to the beta, rerun the
documented walkthrough, and confirm both the gain case and the
no-improvement case behave as specified before any further beta use.

## Content Authoring and Revision Workbench Design Started - 2026-06-15

**Task:** UX-003
**Status:** In Progress
**Summary:** Defined the author-facing destination for new commissions and
items recycled by UX-002. The workbench covers task acknowledgement, complete
MCQ and FRQ package editing, simulated document import, anchored reviewer
comments, immutable version comparison, provenance and rights capture,
preflight, resubmission to two-tutor reassessment, and qualified access to the
review carousel with self-review exclusion. Renumbered student-provided
question intake to UX-004.

**Next Owner:** Paid Tutor Authors, AP Readers, Learning Quality Owner,
accessibility, security, privacy, and rights reviewers, then David Bloom
**Next Required Action:** Test the queue, editor, comments, comparison,
provenance, resubmission, and review-mode transition before any production
implementation.

## Student-Provided Question Intake Design Started - 2026-06-13

**Task:** UX-004
**Status:** In Progress
**Summary:** Defined a five-stage outside-question intake covering typed,
pasted, photographed, and document inputs; extraction confirmation; possible
personal information; one-round missing-context clarification; confidence-aware
subject matching; Teach, Hint, Check My Work, and Solution modes; and a
conservative active-assessment state. Created the canonical UX specification,
task record, clickable prototype, and Lovable render brief.

**Next Owner:** Learning Quality, accessibility, security, privacy, rights, and
academic-integrity reviewers, then David Bloom
**Next Required Action:** Test whether students can provide complete context,
understand confidence limits, choose the intended help mode, and distinguish
private use from anonymous improvement and separately reviewed publication.

## Question and Answer Review Portal Design Started - 2026-06-13

**Task:** UX-002
**Status:** In Progress
**Summary:** Defined the staged two-tutor and AP Reader workflow for question
candidates and MCQ answer options, including aggregate-score routing, immutable
edit-and-recycle behavior, whole-package exclusion, exact-agreement difficulty
labels, reviewer independence, and the boundary between candidate approval and
production release. Created the canonical interaction design, task record,
clickable prototype, and Lovable render brief.

**Next Owner:** Tutors, AP Readers, Learning Quality Owner, accessibility and
security reviewers, and David Bloom
**Next Required Action:** Review and test the carousel, score meanings,
rationale requirements, answer-package behavior, and difficulty discussion
before any production implementation.

## Drawn-Response Pilot V0 Preflight Blocked - 2026-06-13

**Tasks:** TASK-0010 / TASK-0011
**Status:** QA Blocked - Revision Required
**Summary:** Reviewed Claude's three-prompt AI-drafted pilot. The package has
the right scope, student/reviewer separation, candidate labeling, and capture
controls. Preflight found that Prompt 2's enzyme table is not reproducible from
its incomplete stated formula, Prompt 3's values do not match its logistic
equation, and the rights section cites a nonexistent Product Owner originality
approval. Standardized the P0 recommendation to SEM, symmetric error bars, an
operational plateau estimate, and a bounded linear scale. Corrected unsupported
rubric assumptions.

**Next Owner:** Claude for v0.2 remediation
**Next Required Action:** Produce a new immutable package satisfying
`prompts/CLAUDE_REMEDIATE_DRAWN_RESPONSE_PILOT_V0.md`, then return it for
deterministic recalculation, Learning Quality preflight, rights-status review,
and Product Owner decision before Orly begins.

## Orly Drawn-Response Pilot Protocol Prepared - 2026-06-13

**Tasks:** TASK-0010 / TASK-0011
**Status:** Draft internal research protocol
**Summary:** Reviewed Claude's 12-item hand-drawn AP Biology reference library.
Retained its graph-feature taxonomy and recommendation to begin with bounded
quantitative graphs, but rejected the historical official-question derivatives
as pilot prompts or gold-set seeds. Corrected overgeneralized graphing and
scoring claims. Prepared a protocol for Orly to complete three or fewer
independently authored graph prompts and submit two raw phone captures per
response.

**Next Owner:** Claude for rights-clean pilot drafting; Orly Bloom for Learning
Quality review and participation after the prompts pass review
**Next Required Action:** Claude produces three original student prompt sheets,
separate reviewer packages, provenance records, and the Orly administration
checklist defined in
`prompts/CLAUDE_REVISE_DRAWN_RESPONSE_PILOT_SET.md`.

## Official Exam Date and Registration Direction Applied - 2026-06-13

**Task:** UX-001
**Status:** In Progress
**Summary:** Removed learner-entered AP exam dates from the canonical student
portal UX, clickable prototype, architecture workflow, and Lovable render
brief. The active versioned exam specification now supplies the official date,
while the learner confirms registered, not registered yet, or unsure status.
The latter two paths remain non-blocking and explain that registration happens
through the learner's school or AP coordinator.

**Next Owner:** Learning, accessibility, representative learners, and David
Bloom for review
**Next Required Action:** Review whether the three registration choices and
school/AP coordinator explanation are clear without distracting from the first
useful learning action.

## Lovable UX-001 Render Brief Prepared - 2026-06-13

**Task:** UX-001
**Status:** In Progress
**Summary:** Created a self-contained Lovable build brief for rendering the
post-account student experience and related learning-session states. The brief
defines frontend routes, mock state, exact copy, branching behavior,
accessibility requirements, QA paths, and explicit prohibitions on backend
connections, production deployment, protected content, and invented product
policy.

**Next Owner:** David Bloom / Lovable operator
**Next Required Action:** Give
`prompts/LOVABLE_UX001_STUDENT_EXPERIENCE.md` to Lovable, generate a preview,
and return the preview for Learning, Marketing, accessibility, learner, and
Product Owner review.

## Post-Account Student Experience Expanded - 2026-06-13

**Task:** UX-001
**Status:** In Progress
**Summary:** Expanded the first-run prototype from a single setup screen into a
five-step, recoverable post-account journey: account-ready explanation, AP
Biology exam context, immediate learner goal, available time, optional
calibration, and a transparent first-session plan. The plan changes with the
learner's choices and preserves direct-start and finish-later paths.

**Next Owner:** Learning, Marketing, accessibility, representative learners,
and David Bloom for review
**Next Required Action:** Test whether learners understand why each setup
question is asked, how it changes their plan, and whether calibration feels
optional rather than required.

## Initial Student Portal UX Work Started - 2026-06-13

**Task:** UX-001
**Status:** In Progress
**Summary:** David authorized the initial product UX work. Created the formal
task record and proposed student-portal interaction design covering onboarding,
session modes, the stable learning-session frame, criterion feedback, repair
and retry, learner override, Move On and return behavior, coaching copy,
uncertainty, disputed grades, progress, accessibility, prototype scope, and
research questions. Production implementation and final UX decisions remain
hard-gated.

**Next Owner:** Main Conductor for low-fidelity prototype preparation; Orly
Bloom, Micah Bloom, accessibility reviewer, and David Bloom for review
**Next Required Action:** Conduct Learning, Marketing, accessibility, and
representative learner review of `prototypes/ux-001/index.html`, then bring the
nine proposed UX decisions to David.

## Content Follow-On Tasks Defined — 2026-06-13

**Tasks:** TASK-0008 through TASK-0011
**Status:** Proposed / Research
**Summary:** Added a clean proprietary exemplar replacement, conceptual
schema-governance reconciliation, phased grader-confidence program, and
paper-first QR-linked handwritten graph-capture research. Confirmed that MCQ
and FRQ authoring proceed simultaneously and that all reviewed FRQs remain
unapproved candidates subject to edit or rejection.

**Next Owner:** Learning Quality Owner, Grading Lead, Technical Owner, and
counsel as assigned
**Next Required Action:** Review task scopes and approve execution resources and
participants where required.

## Authoring Architecture Rewritten and Experiment Defined — 2026-06-13

**Task:** TASK-0007 / CONTENT-001
**Status:** In Progress
**Summary:** Rejected the prohibited official-derived candidate, converted useful
quality lessons into abstract failure cards, preserved paid-tutor authorship as
the production baseline, and defined a blinded validation-only experiment for
alternative AI-led authoring models. Replaced stale physical-schema proposals
with an immutable prompt-build-manifest architecture and complete MCQ/FRQ
package contracts.

**Next Owner:** Orly Bloom / Learning Quality Owner and counsel
**Next Required Action:** Review the architecture, experimental arms, source
isolation, contracts, metrics, and decision thresholds before execution.

## Visual Stimulus Architecture Review Prepared — 2026-06-12

**Task:** TASK-0006 / CONTENT-001
**Status:** Ready for Owner Review
**Summary:** Assessed the proposed structured-chart, prose-fallback, and
image-generation model. Recommended deterministic quantitative visuals,
governed authored or constrained diagrams, validated accessible equivalents,
and deferral of free-form generated scientific images. Added fail-closed,
answer-leakage, source, rights, revalidation, and learner-created graphing
requirements.

**Next Owner:** David Bloom
**Next Required Action:** Decide the five architecture questions in
`TASK-0006`, followed by Learning Quality, accessibility, and counsel review.

## Corrected AP Biology Coverage Direction Adopted — 2026-06-12

**Task:** TASK-0005 / CONTENT-001A
**Status:** Approved direction; Learning Quality review remains
**Summary:** Reviewed Claude's coverage and schema package. Retained the
separate MCQ/FRQ targeting model but corrected the taxonomy from 48 to 60
official topics and the full target from 784 to 964 inventory items. Defined one
inventory item as one MCQ or one independently delivered FRQ prompt. Approved
expert-curated diagnostic use before empirical confirmation, required human
review for statistical signals, and deferred physical Supabase design.

**Next Owner:** Orly Bloom / Learning Quality Owner
**Next Required Action:** Review topic-level feasibility, content variety, and
beta prioritization against the corrected matrix.

## Markdown-First Document Rule Adopted — 2026-06-12

**Task:** Operating documentation
**Status:** Approved
**Summary:** Established Markdown in GitHub as the default and canonical project
document medium. Google Docs is the preferred collaboration or backup copy.
Word is now an exception for a specific external, submission, printing, or
layout-fidelity need and is not regenerated by default.

**Next Owner:** Main Conductor
**Next Required Action:** Apply the format hierarchy to new and updated
documents and return accepted Google Docs edits to canonical Markdown.

## GitHub Synchronization Rule Adopted — 2026-06-12

**Task:** Operating documentation
**Status:** Approved
**Summary:** Required every retained local project document to be committed and
pushed to `david-bloom/Cramapple`. Added machine-local metadata exclusions and
remote-verification requirements.

**Next Owner:** Main Conductor
**Next Required Action:** Commit and push the current documentation set, then
verify the remote branch.

## Question Distribution Analysis Started — 2026-06-12

**Task:** CONTENT-001A
**Status:** Completed with corrections
**Summary:** Claude analyzed the distribution of MCQs and FRQs. Review retained
the separate question-form target model but rejected the 48-topic assumption
and 784-item total. `DECISION-0014` records the corrected 60-topic, 964-item
direction.

**Next Owner:** Orly Bloom / Learning Quality Owner
**Next Required Action:** Review the corrected coverage matrix, topic-level
feasibility, content variety, and beta prioritization.

## Proprietary Question Bank Rules Defined — 2026-06-12

**Task:** TASK-0005 / CONTENT-001
**Status:** Approved direction with open gates
**Summary:** Defined a proprietary MCQ and FRQ bank. Quantity was later refined
by `DECISION-0014` to ten MCQs and five short-FRQ prompts per official topic
plus eight long-FRQ prompts per unit. Base packages come from paid authors or
purchases; AI may create candidate variants only from packages with explicit
derivative and model-input rights. Every variant requires a complete rubric,
teaching package, provenance, and independent validation.

**Next Owner:** Orly Bloom / Learning Quality Owner with counsel
**Next Required Action:** Review topic-level feasibility, draft the simple
release, define permitted source and asset rules, establish the AI holdout, and
set production sample thresholds for question changes and retirement.

## Paid Tutor Question-Authoring Model Adopted — 2026-06-12

**Task:** TASK-0005 / CONTENT-001
**Status:** Approved direction; operating details in progress
**Summary:** Replaced the proposed historical-question-seeded generation model
with paid qualified tutors independently authoring original question packages
from Cramapple coverage briefs. Official College Board questions and scoring
materials are excluded from seeds, adaptation targets, few-shot examples, and
generative-model inputs.

**Next Owner:** Orly Bloom / Learning Quality Owner
**Next Required Action:** Define tutor author qualifications, commissioning
briefs, compensation and revision terms, originality and IP agreements,
preflight checks, coverage targets, and independent validation assignments.

## Owner Review Queue Updated — 2026-06-12

**Tasks:** TASK-0001, TASK-0003, TASK-0004
**Status:** NOW-001, NOW-002, and NOW-003 Done
**Summary:** David recorded `TASK-0001` and `TASK-0003` as Done and completed
owner review of the current `TASK-0004` documentation. `TASK-0004` remains open
for the independent AP Biology tutor review required by `NOW-004`.

**Next Owner:** Orly Bloom / qualified AP Biology tutors
**Next Required Action:** Complete `NOW-004`, record findings, and determine
whether `TASK-0004` requires remediation or can be closed.

## Master Backlog Created — 2026-06-12

**Task:** Operating documentation
**Status:** Active
**Summary:** Created `docs/MASTER_TODO.md` as the canonical index of current
task closures, required designs, legal and quality gates, teaching research,
MVP implementation, commercial readiness, and deferred expansion work. Backlog
entries preserve their existing approval state and do not authorize execution.

**Next Owner:** David Bloom / Main Conductor
**Next Required Action:** Continue with `NOW-004` through `NOW-007`.

## Content Governance and Validation Procedure Prepared — 2026-06-12

**Task:** TASK-0005
**Status:** In Progress
**Summary:** Drafted the complete proposed operating procedure for immutable
content and rubric versions, source and rights provenance, independent teaching
and grading validation, reviewer qualifications, numeric release gates, atomic
exam-pack publication, monitoring, revalidation, retirement, rollback, and
audit.

**Next Owner:** David Bloom
**Next Required Action:** Coordinate Learning Quality Owner and counsel review,
then approve, request changes, or reject the proposed policy and thresholds.

## Learning Boundary Questions Resolved — 2026-06-11

**Task:** TASK-0004
**Status:** Documentation revision in progress
**Summary:** Defined assessable skill targets for repeated-miss evidence; established diagnostic and instructional Frame behavior; made intervention selection recommendation-with-override; marked per-target time and stable-success thresholds for pedagogy research; and assigned public student-question publishing primarily to marketing/content with teaching and grading gates.

**Next Owner:** David Bloom
**Next Required Action:** Review the revised documents and PR language.

## Unified Learning and Stuck-State Revision — 2026-06-10

**Task:** TASK-0004
**Status:** Documentation revision in progress
**Summary:** Replaced deterministic miss counting and universal Sideways-first routing with evidence-weighted escalation, discriminating probes, independent and delayed confirmation, learner Move On, schedule-aware Park, and skill-and-task-specific intervention effectiveness. Added explicit anonymous use of student responses to improve Cramapple, separate from public publication.

**Next Owner:** David Bloom
**Next Required Action:** Review the revised learning-system documents and the updated pull request.

## Component Architecture and Teaching Design Prepared — 2026-06-10

**Task:** TASK-0004
**Status:** Ready for Owner Review
**Summary:** Created separate canonical designs for system context and logical components, and for ten-day teaching and pedagogy. Added a versioned exam-fact boundary, AP Biology point-distribution guidance, diagnostic and improvability models, next-action logic, FRQ pedagogy, and validator requirements.

**Next Owner:** David Bloom
**Next Required Action:** Review the documents and proposed decisions, then approve, request changes, or record the Done decision.

## High-Level System Architecture Prepared — 2026-06-09

**Task:** TASK-0003
**Status:** Ready for Owner Review
**Summary:** Promoted the architecture planning discussion into a canonical high-level design covering critical workflows, logical components, learner memory, account progress, user-provided questions, validator operations, parent entitlements, AI/provider boundaries, marketing interoperability, security, deployment, and AP-exam extensibility.

**Next Owner:** David Bloom
**Next Required Action:** Review the pull request and approve, request changes, or record the Done decision.

## Estimated AP Score Guidance Revision Prepared — 2026-06-09

**Task:** TASK-0002
**Status:** Ready for Owner Review
**Summary:** Updated Cramapple Vision v0.3 to permit qualified estimated AP score ranges, require confidence and non-official labeling, and connect estimates to concrete improvement guidance. Recorded the owner-approved planning scope and calibration requirements.

**Next Owner:** David Bloom
**Next Required Action:** Review the pull request and approve, request changes, or record the Done decision.

## Project Operating System Initialized — 2026-06-09

**Task:** TASK-0001
**Status:** Ready for Owner Review
**Summary:** Installed and customized the AI Project Operating Kit. Added David Bloom as Product Owner, added the Strategy Advisor role, established GitHub as the source of truth, and stored Cramapple Vision v0.2 in `docs/product/`.

**Next Owner:** David Bloom
**Next Required Action:** Review the draft pull request and approve or request changes.
