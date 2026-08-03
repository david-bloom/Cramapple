<!-- source: claude/cramapple-grading-experiments-9lkjqc@ddf2d4472d9e -->
## Production Content Reconciled to Tutor Decisions; Reviewer Image Support Shipped - 2026-07-20

**Task:** Grading-experiments session, continued live from a student-home-page
UX review. Escalated into direct Production database and edge-function
changes — Higher-tier: real production data mutations, code deploys, no
schema/migration change.
**Status:** Done and deployed. Some findings handed off, not fixed.

**Summary:** Session started as a UX review of a `/proto/home` student
homepage POC, then pivoted when the user asked whether AP Bio/Stats had
enough tutor-reviewed content to finalize grading. Verified directly against
Production (`pcntajvbdfqhbeewmdry`) rather than trusting the premise: found
the *reviewed* content and the *published* content were largely disjoint sets
— most published items had never been reviewed, and 2 AP Statistics items
were live despite explicit tutor disapproval (out-of-CED for the 2027 exam).

With explicit direction, reconciled Production to match actual tutor
decisions:
- Retired the 2 disapproved-and-published Stats items (`status='retired'`,
  non-destructive).
- Published 35 tutor-approved, no-edit-needed items stuck in draft (30 Bio +
  5 Stats).
- Remedied and published 8 `approve_with_edits` items with precise,
  tutor-specified text fixes (answer-choice wording, a real math error, a
  stray uncorrected draft calculation left in a rationale, a missing
  intra-S-phase-checkpoint mention) — verified current text against each
  tutor note before editing. Caught and fixed one of my own mistakes mid-way
  (wrong `mcq_choices.id` grabbed for a choice-D edit; the text-match `WHERE`
  clause prevented silent corruption).
- Declined to freehand two "simplify the numbers/terminology" MCQs and two
  substantive FRQ content issues (unrealistic data, rubric specificity,
  stimulus/question mismatch) — fixed what had exact tutor-specified text
  (`APBIO-FRQ-S-001` stimulus rewrite, `APSTATS-HDG-2026-GRAPH-005` quiz→test
  relabel across stem/stimulus/table/JSON keys) and flagged the rest for
  Orly rather than inventing exam content.
- Reopened all 13 items I materially edited or made a keep-as-is judgment on
  back to `pending` in `content_review_assignments` for the original tutor to
  re-confirm, rather than trusting my own edits as final.

Separately, confirmed tutors could not review image-bearing questions at all:
`review-queue`'s payload never selected `stimulus_image_path`, and even if it
had, the `content-assets` storage bucket only authorizes `admin`/
`content_author` roles — tutors (`role='tutor'`) could never self-sign a
download URL. Fixed by signing images server-side inside `review-queue`
(service-role client, no bucket-ACL change needed); deployed to Production
(v18). Audited both subjects for questions that need an image but lack one:
found exactly one real gap (`APSTAT-MOD7-M004`, draft, completely empty
stimulus for a "this tree diagram shows..." probability question) against
~200 reviewed-or-pending items and the full Bio/Stats corpus. Everything else
that looked like a candidate was already resolved via the corpus's
established "Figure 1 (described): ..." text-substitute convention.

Built and shipped a reusable soft-flag heuristic
(`content_flags.possible_missing_stimulus_image`) into `review-queue` (v19)
per explicit product decisions (soft flag, not a hard block; wired at the
review checkpoint only, not into TASK-0017). Validated against the full
reviewed-or-pending set before shipping and caught two bugs in my own first
draft in the process (missed the "description" noun form vs. "described"
participle; missed "diagram shows" vs. the narrower "diagram shown").

Recovered the AP Biology/Statistics/Chemistry calibration-tier gold-set
candidates (built 2026-07-08/09 per DECISION-0034/APPROVAL-0032) from two
unmerged Codex branches onto `main` via PR #44 — they had never been merged
and were at risk of being lost if those branches were cleaned up. Confirmed
these remain AI-provisional "calibration" (silver), not `adjudicated_gold`;
merging changes no launch gate.

One process gap surfaced and left unresolved: there is no reliable
system-level way to detect "tutor-reviewed content was edited after the
review" — `content_item_versions.updated_at` is polluted by status-only bulk
updates and doesn't propagate from child-table edits (`mcq_choices`,
`frq_criteria`), so it gives both false positives and false negatives. All 13
re-review flags this session exist only because they were tracked manually in
conversation, not because the system would surface them on its own.

**Verification performed:** `deno check` on `review-queue/index.ts` before
each deploy (twice); manually confirmed all 10 real Bio FRQ stimulus images
exist in `content-assets` storage before trusting the signing fix; re-derived
and hand-verified the missing-image regex against ~200 real items before
shipping, not just spot-checked; confirmed all 13 reopened items show
`status='pending'` by content key after the fact.

**Files/systems changed:** `supabase/functions/review-queue/index.ts`
(deployed Production v18, v19); Production DB (`pcntajvbdfqhbeewmdry`) —
`app.content_items`/`content_item_versions`/`mcq_choices` status and text
updates, `content_review_assignments` reopened; PR #44
(`claude/pull-gold-set-candidates` → `main`, open, not yet merged).

**Open blockers/risks carried forward:**
1. `APSTAT-MOD7-M004` — empty stimulus, unanswerable as authored, needs an
   author (not fixed; declined to invent probability data).
2. Four Bio FRQs need real content authoring, not mechanical fixes:
   `APBIO-MCQ-069`, `APBIO-MCQ-074` (simplify, no exact spec given),
   `APSTATS-HDG-2026-GRAPH-005` (unrealistic dataset — the quiz→test fix
   addressed only part of the tutor's note), `APBIO-FRQ-S-001`/`-L-009`
   flagged earlier, GRAPH-005/FRQ-S-001 both live with a known partial gap.
3. No system-level "content edited after review" detector exists — proposed
   using the unused `content_review_decisions.canonical_answer_snapshot`
   column for this; not built.
4. TASK-0010 human dual-blind adjudication has still not happened for either
   subject — the calibration gold-set candidates recovered in PR #44 remain
   silver-tier. This is unaffected by tonight's publish/retire actions but
   means DECISION-0041's calibration-before-publish gate is still unmet by
   everything published tonight.
5. PR #44 is open, unreviewed, unmerged.

**Next Owner:** David Bloom.
**Next Required Action:** Review/merge PR #44; decide who authors the
missing-image and simplify-content items; decide whether to build the
content-drift-after-review detector; get the 13 reopened items in front of
the Bio/Stats tutors.

---

<!-- source: claude/cramapple-grading-experiments-9lkjqc@ddf2d4472d9e -->
## Kimi Grading Experiment Wired and Pre-Registered - 2026-07-17

**Task:** Grading-experiments session. Standard-tier research (reversible
harness change; no learner-facing effect, no schema/production change).
**Status:** Wired and pre-registered on
`claude/cramapple-grading-experiments-9lkjqc`. NOT YET RUN — the paid run needs
`AI_GATEWAY_API_KEY`, which is not present in the web session environment.

**Summary:** David asked to rerun the grading experiments with **Kimi**
(Moonshot) to see whether its complex reasoning helps students, measuring
**speed, quality, and cost**. Wired two arms into the existing SP-1 harness
(`scripts/vercel-gateway-check/sp1_pilot.mjs`) rather than building anything
new, so results pair directly against the prior AP Bio arms on the identical
100-row `learning_quality_approved` FRQ02 corpus:

- `SP-Kimi-Thinking` (`moonshotai/kimi-k2-thinking`) — the headline arm. Kimi
  reasons natively, not via the OpenAI `reasoningEffort` knob, so that knob is
  left unset. Two settings deliberately differ from every fast arm and both are
  required for the arm to measure anything real: `maxOutputTokens: 2000` (a
  thinking model bills reasoning as output; a 150-cap truncates it before the
  JSON verdict) and `criterionTimeoutMs: 45000` (a 4–8 s cap tuned for fast
  models would time out every thinking call).
- `SP-FAST-Kimi` (`moonshotai/kimi-k2`, no thinking) — the same-family baseline
  that isolates what the reasoning actually buys.

Also added both slugs to the `models.mjs` reachability probe and PROVISIONAL
Kimi pricing to the `PRICING` table (flagged for reconciliation against the
real gateway invoice before any cost number is cited). Both arms grade with the
model alone (no gpt-5.5 escalation, no misattribution audit) for a clean read.

Validated the wiring with `--dry-run` (arms parse, corpus loads 40/40 with all
5 ambiguous-cluster IDs present, 320 planned calls) and `node --check` on both
files. The actual paid run was NOT executed here — no gateway key in this
environment.

Pre-registered the run plan, hypotheses, priority order (Speed > Quality >
Cost), integrity gate, and success/kill criteria in
`docs/research/apbio_kimi_grading_experiment_2026-07-17.md` before running, per
the reporting standard, so results can't be cherry-picked after the fact.

**Scope guard:** FRQ02-only, single-question — input to `TASK-0010`, not a
release claim, and not a change to the learner-facing automated-score gate
(`NOW-013` unchanged).

**Next Owner:** David Bloom — run `npm run models` then the pilot in an
environment with `AI_GATEWAY_API_KEY`, or hand the run commands to whoever
holds the key. Reconcile Kimi pricing at run time.

---

<!-- source: codex/five-subject-harness-and-content@c5f539294c4d -->
## AP Statistics Fact Pack G0A Approved by Tutor Jill (No Changes) — Both Bulk-Authoring Fire Gates Green — 2026-07-14

**Task:** AP Statistics 2026-27 content rebuild — Gate G0A
**Status:** G0A cleared. Both named fire gates for G2 bulk authoring are now green; G2 remains David-gated on the broader orchestration items.

**Summary:** The qualified AP Statistics subject tutor (Jill) approved
`docs/product/AP_STATISTICS_2027_CED_FACT_PACK.md` — the sole sanctioned authoring
input for the 2027 rebuild cascade — **without changes** (relayed by David; the
subject tutor holds the G0A sign-off per David's 2026-07-13 review-chain
reassignment; Orly remains Curriculum Owner). This clears **G0A**. The other named
fire gate, **G3V**, already cleared 2026-07-13 (10/10 logical units, commit
`716843e`). Because the sign-off carried no changes, the G3V-passed vertical slice
(authored against the draft pack) needs no rework.

**What this unblocks:** the two fire gates in
`AP_STATISTICS_BULK_AUTHORING_RUN_PLAN_2026_07_13.md` are both green. **What it does
NOT do:** authorize bulk authoring by itself — the orchestration spec still lists
open scope questions (Q1–Q7) and the G1.5 FRQ-archetype schema gap
(`content_ingest_rows.frq_form` is short/long only, can't represent the 2027 Q1–Q4
structure); David authorizes G2. And downstream, bulk-authored content still passes
Codex G3 → tutor G4A → grading/repair → **G4B calibration** before any publish
(the DECISION-0041 gate). G0A is an *authoring-input* gate, upstream of both.

**Distinction:** this fact-pack G0A sign-off is separate from Jill's in-progress
STATS-RV-B1 *content-item* review, and from the grading-calibration gold set.

**Next Owner:** David Bloom.
**Next Required Action:** Decide whether to resolve the open scope questions +
G1.5 schema and authorize G2 bulk authoring, or hold. Optionally formalize the G0A
sign-off as an APPROVAL record.

<!-- source: codex/five-subject-harness-and-content@c5f539294c4d -->
## Tutor Content-Review Set Built; Stats Tutor (Jill) STATS-RV-B1 Queue Assigned in Production — 2026-07-14

**Task:** Tutor content review (onboarding + content QA toward calibration)
**Status:** Stats tutor onboarding batch live in Production; Bio + larger batches staged.

**Summary:** Built a deterministic, stratified tutor content-review set of 140
Production items (`docs/research/tutor_review_set_2026_07_14/`): STATS-RV-B1/B2 and
BIO-RV-B1/B2 (10 MCQ + 10 FRQ, then 25 each), read-only from Production
(`pcntajvbdfqhbeewmdry`). Confirmed both tutors hold active grading qualifications
(Stats, Bio). Reviewed the Product Owner's tutor instructions doc (Google Doc) —
largely aligned with the `review-decision` flow (one-submission MCQ approval,
note-required, subject-scoped queue); two items to confirm against the reviewer UI
(decision labels Yes/Maybe/No ↔ numeric `tutor_score`; issue codes vs free-form
`concern_codes`). Product Owner decided to launch beta single-reviewer if needed.

**Production write (Product Owner authorized):** assigned STATS-RV-B1 to the Stats
tutor Jill (`available_memory@yahoo.com`, reviewer_id `0a5909f7…`) — 20
`content_review_assignments` (10 mcq + 10 frq, `tutor_question`, `pending`,
`created_by` admin) + set those 20 `content_item_versions.review_status =
tutor_review_pending`, replicating `assign-for-review` for a single reviewer (that
Edge function requires two distinct reviewers, so the rows were created directly).
Verified: 20 pending for Jill, versions marked. Nothing published; this is content
review only (a tutor decision never publishes an item or changes a grade).

**Flag:** the Stats items are 2026-format (9-module); AP Statistics is being rebuilt
to 2027 (5-unit) per DECISION-0036 — some may be retiring. Bio has no format change.

**Update 2026-07-14:** BIO-RV-B1 assigned to the Bio tutor **Morgan**
(`amjadsolangi654@gmail.com`, reviewer_id `83098fb9…`, role tutor, Bio-qualified) —
20 `content_review_assignments` (10 mcq + 10 frq, `tutor_question`, `pending`) +
versions marked `tutor_review_pending`, same single-reviewer mechanism as Jill.
Both tutors now have a live B1 queue. Separately, the **AP Biology CED fact pack**
(`docs/product/AP_BIOLOGY_CED_FACT_PACK.md`) §3 topic map was anchored from the
public course framework and is now a **G0A DRAFT ready for Morgan's sign-off**
(mirrors Jill's Stats G0A).

**Next Owner:** David Bloom.
**Next Required Action:** Confirm the reviewer-UI decision labels/issue codes match
the instructions; hand Morgan the AP Biology fact pack for G0A sign-off; assign
STATS-RV-B2 / BIO-RV-B2 after the B1 batches clear. Tutor content review remains
distinct from the grading-calibration gold set (response adjudication), the
DECISION-0041 publish gate.

<!-- source: codex/five-subject-harness-and-content@c5f539294c4d -->
## TASK-0016 Phase A Executed on Dev (Migrations + Functions, Shadow Mode) — 2026-07-14

**Task:** TASK-0016 — Multi-Rubric Grading & Feedback Engine Rollout, Phase A
**Status:** Deployed and boundary-verified on Development; Production untouched.

**Summary:** Under APPROVAL-0037 (full Phase A incl. review pipeline), reconciled
the uncommitted grading worktree into 11 workstream commits (95/95 function tests
green; auth-token telemetry bug fixed), then executed Phase A on Dev
(`wmgjsdkphcyhngaffbqf`). Read-only preflight found Dev's migration history
**diverged / partly managed outside this repo** (rubric-routing columns applied
under foreign Jul-11 version ids), so migrations were applied individually via MCP
rather than `db push`. Applied 7 additive/idempotent migrations (5 `grading_results`
columns, `profiles.review_queue_scope` with a hardened CHECK, review-schema
stabilization, and RLS-policy restore taking two label tables from 0→4 policies).
Deployed 6 edge functions via CLI with shared deps auto-bundled: `evaluate-attempt`
(v7→v8) plus new `attempt-response`, `assign-for-review`, `review-queue`,
`review-decision`, `reviewer-invite` — all ACTIVE. Post-DDL security advisors
showed only pre-existing WARNs (no new findings; the RLS-zero-policy issues were
resolved). Boundary smoke: unauth `evaluate-attempt`→401, `review-queue` GET→401,
CORS preflight→200.

**Deferred:** HDG spatial remediation (content guard would abort — 0 published HDG
on Dev); queue-scope backfill + dbloom01→admin promotion (privilege change);
non-Phase-A migrations (curated interface, atomic publication, TASK-0017 H1–H5).

**Also built this session:** push-button AP Statistics calibration harness
(`scripts/grading-model-assessment/calibrate-ap-statistics.ts` + converter +
launch-bar verdict; 10/10 tests) — provisional/plumbing until adjudicated gold and
real grader captures land.

**Evidence:** `docs/qa/TASK0016_PHASE_A_DEV_EXECUTION_EVIDENCE_2026_07_14.md`;
`docs/qa/TASK0016_PHASE_A_DEV_EXECUTION_PACKET_2026_07_14.md`.

**Next Owner:** David Bloom.
**Next Required Action:** Authorize the seeded end-to-end Dev evidence run (needs
AP Statistics content + a test student on Dev) to prove router dispatch,
deterministic-before-LLM, sanitizer grounding, and the shadow round-trip. Separately,
schedule a migration-history reconciliation for Dev. No Production change is
authorized; `QA-pass ≠ launch approval`.

<!-- source: codex/five-subject-harness-and-content@c5f539294c4d -->
## TASK-0017 H1–H5 Repository Harness Implemented and Locally Verified — 2026-07-13

**Task:** TASK-0017 — Reusable Subject-Onboarding Harness
**Status:** Repository/local build complete; independent re-QA passed; ready for Dev Hard-Gate; Dev/Production untouched.

**Summary:** After Product Owner clarification under DECISION-0040, implemented additive H1/H2 persistence, the deterministic plan/apply compiler, and H3–H5 capability, validation, eligibility, manifest-relation, calibration, and content-clearance layers. Two independent-QA passes correctly failed intermediate snapshots. The resulting remediation now covers canonical package/legacy payload and parent-manifest immutability; typed target/invalidation checks and immutable suite meaning; policy/pack-scoped reviewer evidence, revocations, persisted team eligibility, and review-queue enforcement; item-derived renderer/modality and deterministic parameter checks at compiler and DB boundaries; exact hash-attested waiver evidence; P0-equivalent gate reporting; package-bound adjudicated calibration evidence; exact approval binding/revocation/consumption; policy-conflict detection; and concurrency control. Canonical questions remain `content_items` / `content_item_versions`; no parallel `artifact_versions` question record was introduced.

**Local evidence:** PostgreSQL 17.10 clean-stack execution on disposable port 55443 passed P0 rollback/exact-version tests after H1–H5. AP Statistics preserved a seeded prior nine-unit taxonomy and persisted the five-unit/four-practice scheme plus Q1–Q4. Bio/current-Stats golden snapshots were stable. Chemistry scaffold reconciliation published no content. The true-create fixture rolled back completely. Canonical-plan/item tampering, unsupported item modalities/renderers, wrong parameter types, changed same-semver policies, arbitrary/mismatched/revoked approval IDs, invalidated/retired validation evidence, duplicate evidence IDs, and revoked reviewer/clearance evidence failed closed. Positive reporter/P0 parity, waiver hash attestation, queue enforcement, calibration evidence, exact approval consumption, and a real two-session one-winner conflict passed. Idempotent Stats reapply remained one application/four item applications. Privilege/RLS/plugin audits were green; hosted PostgREST exposed-schema verification remains a required Dev preflight.

**Evidence:** `docs/architecture/TASK0017_H1_H5_PHYSICAL_DESIGN_2026_07_13.md`; `docs/qa/TASK0017_H1_H5_LOCAL_EVIDENCE_2026_07_13.md`.

**Independent verdict:** PASS at frozen commit `4b1bc07`; no remaining repository blocker.

**Next Required Action:** Product Owner Hard-Gate decision for Dev, followed by an exact authoritative execution approval record/ID, hosted proof that `app` is not Data API-exposed, and a Dev evidence run. Production remains distinct.

<!-- source: codex/five-subject-harness-and-content@c5f539294c4d -->
## AP Statistics Vertical-Slice G3V Re-QA: Q1/Q3/Q4 Pass — 2026-07-13

**Task:** AP Statistics 2026-27 content rebuild, Gate G3V
**Status:** G3V passed — 10/10 logical review units pass after focused Q4 confirmation at `716843e`.

**Summary:** Reviewed branch tip `31e1967`; the vertical-slice remediation itself landed at `a478f7e`. Q1 now defines and reaches all registered members, making the census key unambiguous. Q3 supplies independent random selection from more than 10,000 bottles, so the 10% condition is verifiable; its t statistic and two-sided p-value recompute correctly. Q4 supplies population size, alpha, and a correct two-sided p-value/decision. Commit `996b46d` made Point 6 score both `z≈.80` and `p≈.42`; commit `716843e` made Point 8 require `p≈.42 > .05` and reject z-only justification. The Q4 prompt/model/rubric now align. No removed topic appears; inventory is correctly 10 units / 12 atomic questions. G3V passes 10/10.

**Evidence:** `docs/research/CODEX_G3V_AP_STATISTICS_VERTICAL_SLICE_REQA_2026_07_13.md`.

**Next Owner:** AP Statistics orchestration owner for the next separately governed gate.
**Next Required Action:** Treat G3V as cleared. Confirm remaining fact-pack/tutor and grading/calibration prerequisites before any bulk run, staging, or publication; G3V clearance alone authorizes none of those later actions.

<!-- source: codex/five-subject-harness-and-content@c5f539294c4d -->
## TASK-0017 Post-Approval P0 Re-Verification + TASK-0009 Fast-Track Slices; AP Statistics G3V Failed 3 FRQs — 2026-07-13

**Tasks:** TASK-0017, TASK-0009; AP Statistics 2026-27 rebuild G3V
**Status:** P0 repository/local evidence green; TASK-0009 fast-track conceptual slices proposed for review; G3V failed pending targeted content remediation. Dev/Production untouched.

**Summary:** Executed the DECISION-0039 repository/local-only conditions on remote-verified branch `codex/task0016-phase-c-content-publish-approval-packet` at `997c476` while preserving the dirty worktree. Both P0 SQL regressions passed against fresh PostgreSQL 17.10. The fixture deliberately installed pgcrypto in `public`; the migration normalized it to `extensions` and proved `extensions.digest(text,text)` resolves. RPC privileges remained anon/authenticated false, service-role true. Replaced request-payload hashing with a deterministic canonical manifest hash over the ordered exact content-version relation plus sorted evidence/policy references; the positive regression independently reconstructs and matches it.

Extracted the Edge→RPC request contract. The Edge caller now requires non-empty source and rights IDs, separately categorized grading/calibration and security/privacy validation-run IDs, approved-by identity, and validator/teaching/grading policy version IDs. Three local tests passed, including fail-before-RPC omissions; the RPC independently validates actual suite category, pass state, and exact target version. Prepared a Dev execution/rollback/evidence packet; no approval ID exists and nothing was applied.

Delivered TASK-0009's two DECISION-0038 fast-track conceptual slices: immutable ItemPackage/archetype identity mapped to `content_items`/`content_item_versions` only, and multi-scheme taxonomy per exact `exam_pack_version` with version-level assignments and historical coexistence. `artifact_versions` is not restored as a parallel question record. No DDL was produced.

Fresh independent G3V review recomputed the full AP Statistics vertical slice. All arithmetic passed and no removed topic was tested, but Q1 incorrectly calls a one-week visitor frame a census of all members, Q3 asks to verify independence without a population count, and Q4 makes an inferential decision without alpha or an explicit decision rule. Verdict: 7 pass / 3 fail across 10 logical units. The source's “9 items” count is also wrong (10 logical units / 12 atomic questions). Bulk generation remains gated.

**Evidence:** `docs/qa/evidence/TASK0017_P0_POST_APPROVAL_SQL_2026_07_13.log`; `docs/qa/evidence/TASK0017_EDGE_RPC_CONTRACT_2026_07_13.log`; `docs/qa/TASK0017_DEV_EXECUTION_EVIDENCE_PACKET_2026_07_13.md`; `docs/architecture/TASK0009_M0_FAST_TRACK_CONCEPTUAL_MODEL_2026_07_13.md`; `docs/research/CODEX_G3V_AP_STATISTICS_VERTICAL_SLICE_QA_2026_07_13.md`.

**Next Owner:** David Bloom for TASK-0009 slice ratification and any separate Dev approval; Claude/content author for Q1/Q3/Q4 remediation; fresh Codex QA for G3V re-review.
**Next Required Action:** Revise the three failed FRQs and inventory count, then re-run G3V. Separately review the two TASK-0009 conceptual slices. Do not apply Dev/Production changes or start AP Statistics bulk generation.

<!-- source: codex/five-subject-harness-and-content@c5f539294c4d -->
## TASK-0017 Subject-Onboarding Harness Opened; Publication-Trust P0 Found in admin-content — 2026-07-13

**Task:** TASK-0017 (new, Hard-Gate); relates to TASK-0016, TASK-0014/0015, TASK-0009.
**Status:** Task in progress. P0 is implemented and locally verified against disposable PostgreSQL 17; H0/H1 executable contracts and governance design are ready for review. Dev and Production remain untouched.

**Summary:** David asked what Codex could most do to accelerate launching new subjects. Recommendation: turn per-subject launch machinery into a reusable, parameterized onboarding harness (since content authoring is now parallelized by Anthropic models, the repeat bottleneck is the validation/infrastructure layer). Drafted a Codex prompt; Codex returned a detailed review that (a) verified a P0 publication-trust bug and (b) required structural revisions. All incorporated into a Hard-Gate task.

**Publication-trust P0:** The prior non-atomic publication sequence was replaced in the repository with a service-role-only transactional RPC that locks and publishes the exact reviewed `content_item_versions.id`, derives gate eligibility from stored evidence, and rolls back serving and release state together. A real PostgreSQL run caught ambiguous PL/pgSQL aliases missed by typecheck; those were corrected. Clean-schema rollback and exact-version regressions now pass. The exact-version test proves version 2 publishes while prior version 1 retires and newer unapproved version 3 remains untouched. Privileges resolve `anon=false`, `authenticated=false`, `service_role=true` for RPC execution. The independent review also added duplicate, extraneous, stale, and expired rights/evidence rejection.

**David's decisions (`DECISION-0037`):** P0 first → H1 vertical slice → rest; content-clearance waivable by PO only (grading/rights/security never); canonical question-version record (v1) = `content_item_versions.id`; canonical school-year id = `2026-27`; AP Chem/Physics adopt the harness once ready (no new one-offs); harness supports new-subject and annual-revision.

**Deliverables:** `docs/tasks/TASK-0017-SUBJECT-ONBOARDING-HARNESS.md`; atomic RPC migration and PostgreSQL fixtures/regressions; executable Draft 2020-12 SubjectPackage and ItemPackage schemas; AP Statistics 2026-27 and Q1–Q4 fixtures; pinned contract validator/tests; and `docs/architecture/TASK0017_H0_H1_DESIGN_2026_07_13.md` covering the manifest replacement, typed validation registry, immutable content-clearance exception, security boundary, migration, and rollback.

**Next Owner:** David Bloom / TASK-0009 conceptual-model owner.
**Next Required Action:** Review H0/H1 contracts and ratify/revise the relational slices through TASK-0009. Then authorize a separate Dev physical-design/migration execution packet if accepted. Materialize authoritative gate evidence before any August Biology/Statistics publication. Do not publish AP Chemistry.

<!-- source: codex/five-subject-harness-and-content@c5f539294c4d -->
## AP Statistics 2026-27 CED Change Assessed; Multi-Model Content Rebuild Orchestration Designed — 2026-07-13

**Task:** Cross-cutting — TASK-0013 (AP Statistics); relates to TASK-0016, tutor review workstream.
**Status:** Assessment done; orchestration designed and documented; **not yet executed** (blocked on curriculum lock + Codex plan review). `DECISION-0036` recorded.

**Summary:** David surfaced the College Board 2026-27 AP Statistics CED change. Reviewed the CED PDF directly and confirmed a major restructuring, then designed a multi-model content-rebuild orchestration per David's executive decision to have Anthropic models lead content development.

**CED changes confirmed (read from the PDF, not inferred):**
- Course collapses **9 modules → 5 units** (new MC weights U1 20–30%, U2 15–25%, U3 15–25%, U4 10–20%, U5 10–20%).
- FRQ section restructures **6×~4pt → 4×10pt** multi-part questions (Q1 Practices 1&2; Q2 Practices 3&4; Q3 inference; Q4 multi-area) — each point scored independently. Exam is 42 MCQ + 4 FRQ, 90 min/section, 50/50 weight.
- **Inference for the regression slope** and **chi-square goodness-of-fit** do not appear in the new unit list — flagged UNCONFIRMED-removed pending Orly's call and a prior-edition diff.
- Fully digital via Bluebook with a built-in Desmos calculator; College Board gives no detail on digital graph-entry. Per David, **hand-drawn graph capture stays in scope** (no Desmos-equivalent exists; students still need graph-construction practice).

**Deliverables this session:**
- `docs/product/AP_STATISTICS_2027_CONTENT_REBUILD_ORCHESTRATION.md` — two orchestrations (A: item re-creation to the 5-unit/4×10pt shape; B: rubric-block + student-repair refresh incl. deterministic verifier-profile sync), the corrected model cascade (Opus authors + adversarially verifies correctness; Sonnet conformance + bulk transforms; Haiku catalog/report), and gates G0–G5 with Codex as independent plan-reviewer (G1) and QA (G3).
- Added an AP-Statistics-specific rubric standard block to `docs/product/TUTOR_REVIEWER_QUICKSTART.md` (unit tagging, 4 practices, 4×10pt independent-point FRQ scoring, task-verb↔criterion matching, slope/chi-square flag-don't-reject guidance) — sourced from the CED scoring guidelines.
- `DECISION-0036` records the AI-led authoring shift, the model tiering, Codex's reviewer role, and the standing guardrails (candidate-not-cleared, no auto-publish, no CB material, boundary-contract requirement).
- Memory `project_ap_stats_2027_format_change` created/updated.

**Corrected an earlier framing:** the initial instinct to QA Opus output with Sonnet was flagged as backwards for correctness-critical statistical content; the cascade keeps correctness verification at Opus tier and independent, with Sonnet limited to conformance.

**Codex G1 review (2026-07-13):** verdict "return for targeted revision, then approve." Spec revised to **v2** incorporating all required corrections: five removed topics recorded as confirmed CB facts (verified against the CB page — departures-from-linearity, combining random variables, geometric distribution, chi-square GOF, slope inference; residual plots retained); authoring input is a human-reviewed CED fact pack, not the full PDF; curriculum authoring split from verifier code (cascade emits a requirements manifest, Codex/TASK-0016 implements); added G−1 containment and a separate G4B grading-clearance gate; deterministic scripts own counts/recomputation (Haiku narrative-only); vertical slice required before bulk. Codex also flagged the v1 docs as uncommitted (GitHub source-of-truth durability pending).

**Next Owner:** David (scope decisions Q1–Q7 in the spec; live removed-topic-item disposition is time-sensitive), Orly (G0A fact pack), Codex/TASK-0016 (G1.5 FRQ-archetype schema — `content_ingest_rows.frq_form` is short/long only and cannot represent Q1–Q4).
**Next Required Action:** (1) David answers the execution-gating open questions. (2) Claude drafts the G0A CED fact pack for Orly's confirmation (if approved). (3) G−1 corpus freeze + classification. (4) Vertical slice, Codex G3V, then bulk. Content lands staged only; publication remains David-gated.

<!-- source: claude/cramapple-grading-mlr0o1@7f02b9c305c7 -->
## Statistics Deterministic Verifier Fixes: Independent Opus Re-QA - Confirmed Safe, Found Broader Scope Than Disclosed - 2026-07-12

**Task:** Verifies the two entries below (SE/SE_diff removal, criterion-
count guard). Relates to `TASK-0016`, `TASK-0010`.
**Status:** Both fixes confirmed correct and safe by independent re-QA
(David's request: run the re-QA with a different model, `opus`, for
genuine model-diversity independence, not just fresh context). One
correction applied to the guard's own commit-time claim; one comment
inaccuracy fixed. Still not deployed to Production.

**Summary:** Opus re-derived all the math independently (SE, CI bounds,
t-statistics from `ecf_parts` canonical formulas), independently ported
and ran the exact `extractNumbers`/`matchesTarget` logic against the real
response texts, and traced the live call site line-by-line rather than
trusting the commit messages. Verdict on both fixes: **correct, safe, no
over-grading hole introduced.** Specifically confirmed the "final value
mathematically implies correct intermediate value" argument is airtight
for both `MOD3-H001-INV` and `MOD6-H001` — the checker matches against
fixed canonical values (not the student's own derivation), and each final
value is strictly monotonic in its intermediate, so no arithmetic-error-
cancellation path exists that could let a wrong SE produce a passing final
value. Confirmed `MOD6-H001` now genuinely passes (t=2.1 clears the 2%
tolerance on 2.06104) and `MOD3-H001-INV` still genuinely fails, specifically
on the missing hypothesis-test t-statistic (2.28217) — the response never
computes it. Confirmed the "signal isn't lost" claim precisely: `statisticsCheck`
threads through as `action_hint`/`repair_hint`/metadata on the LLM path,
but does **not** reach the LLM's own prompt — it shapes feedback, not the
score, worth being precise about going forward.

**What the QA caught that the original fix missed:** the criterion-count
guard checks `input.criteria.length`, which is *total* rubric criteria
(numeric + conceptual combined) — there's no "kind" field available at
that call site to filter to just numeric ones. Every content_key currently
in `STATISTICS_TARGETS` has 2+ total criteria (`MOD3-H001-INV`: 5,
`MOD6-H001`: 3, `MOD7-H001`: 2, all 18 `APSTATS-SFRQ-*` items: 4 each).
That means the guard currently returns null for the **entire configured
catalog**, not just the one multi-numeric-criterion item that motivated
the fix — the hard-block/cost-saving prefilter path is presently
unreachable for everything. Safe (every response gets real LLM grading
now, no wrong zeros), but a real, previously-undisclosed side effect: the
prefilter's cost-saving purpose is dormant, not narrowly fixed.

**Also caught and corrected:** the guard's original commit claimed the 18
`APSTATS-SFRQ-*` items' criterion structure "couldn't be confirmed without
live DB access." That was wrong — it's determinable from
`docs/research/ap_statistics_phase4_mcq_smoke_batch_2026_07_01/ap_statistics_frq_batch_2026_07_01.json`'s
a/b/c/d criterion structure, which was already checked out on this branch.
Missed it the first time; QA found it. Corrected the code comment to state
this plainly instead of the "unknown" claim.

**Also caught:** a minor but real inaccuracy in the SE_diff fix's own
comment — it claimed the response's "2.0 to 2.1" range "already passes
the 2% tolerance," when actually only the 2.1 endpoint does (2.0 misses by
0.02); the conclusion (response passes) was still correct since the
numeric-match logic only needs one hit, but the comment overstated why.
Fixed.

**Verified, not just re-asserted:** independently confirmed no test
breakage — the only tests referencing the removed SE/SE_diff values
(`math-verifier_test.ts`) exercise the separate symbolic ECF verifier, not
this file. Confirmed no TypeScript-level issues from reading (still no
Deno available in this environment for a real compile check).

**Next Owner:** David Bloom / Main Conductor
**Next Required Action:** Decide whether the dormant cost-saving prefilter
is worth restoring properly (would need a numeric-vs-conceptual criterion
"kind" signal threaded to the call site — a real follow-up feature, not a
quick fix) or is an acceptable tradeoff to leave as-is (safety over cost
savings). Decide whether/when to deploy both statistics-verifier.ts fixes
to Production — still undeployed.

---

<!-- source: claude/cramapple-grading-mlr0o1@7f02b9c305c7 -->
## Statistics Deterministic Verifier: Fixed the Criterion-Bundling Severity Bug - 2026-07-12

**Task:** Directly follows the entry below. Relates to `TASK-0016`,
`TASK-0010`.
**Status:** Fixed on `claude/cramapple-grading-mlr0o1`
(`supabase/functions/_shared/statistics-verifier.ts`), not yet deployed to
Production, not yet independently re-QA'd.

**Summary:** David asked whether the criterion-bundling issue flagged in
the prior entry had an identifiable root cause, and then asked to fix it.
Root cause confirmed precisely: `STATISTICS_TARGETS` is item-level (one
flat required-values list per `content_key`), with no mapping of which
value belongs to which rubric criterion. The gate this feeds
(`buildStatisticsDeterministicFallback`, wired at `evaluate-attempt/
index.ts` as `"deterministic-statistics-prefilter"`) is intentionally a
cost-saving pre-filter, not an accidental fallback — but its item-level
granularity doesn't match rubrics that have more than one independently-
gradable criterion, so on those items ANY single missing value hard-blocks
credit and the LLM call for the ENTIRE response, not just the one affected
criterion.

**Confirmed scope before fixing, not guessed:** checked all 5 items with
visible per-criterion data (`statistics_item_keys.json`) for criterion
count. Only `APSTAT-MOD3-H001-INV` has more than one numeric criterion
(`ci_calculation` + `hypothesis_test`) — confirmed exposed. `MOD6-H001`,
`MOD7-H001`, `MOD8-H001` are single-criterion — safe even before this fix.
The 14 `APSTATS-SFRQ-*` items (already-published production content, not
the calibration corpus) aren't in that file, so their criterion count
couldn't be confirmed without live Supabase access (not available this
session — MCP tool calls started requiring interactive approval).

**The fix, chosen specifically to not require knowing what wasn't
confirmed:** rather than attempting to guess which target value belongs to
which criterion for the 14 unverified items (real risk of silently
assigning a value to the wrong criterion and introducing a new,
differently-shaped bug), added a guard in
`buildStatisticsDeterministicFallback`: the hard block now only fires when
the item has exactly one rubric criterion
(`input.criteria.length !== 1 -> return null`). `promptBase.criteria` is
already the live rubric loaded from the `frq_criteria` table at the
`evaluate-attempt` call site, so this check works correctly at runtime for
every item, including the 14 unverified ones, without needing their
structure known in advance — if any of them turn out to be multi-criterion,
this guard already protects them; if single-criterion, behavior is
unchanged.

**What this does NOT do:** it doesn't add real per-criterion deterministic
partial credit — multi-criterion items just stop being hard-blocked and
fall through to full LLM grading instead, still informed by the same
signal as a repair-hint (confirmed the codebase already threads
`checkStatisticsDeterministicEvidence`'s raw result through as a soft
signal via a separate `statisticsCheck` variable, used for
`action_hint`/`repair_hint` even when the LLM grades normally — not lost
by this change, only the hard block is narrowed).

**Verified before committing:** ran a plain-JS simulation of the exact
guard logic against three cases — `MOD3-H001-INV` (2 criteria, still flags
internally) now correctly falls through (`null`, LLM runs); `MOD6-H001` (1
criterion, already passes after the prior fix) unaffected; a hypothetical
single-criterion item with genuinely no evidence still hard-blocks as
before. Brace-balance checked (no Deno available in this environment for a
real typecheck, same standing limitation as every code change this
session).

**Next Owner:** David Bloom / Main Conductor
**Next Required Action:** Get this independently re-QA'd before deploying.
Decide whether to check the 14 `APSTATS-SFRQ-*` items' live criterion
structure (needs Supabase MCP re-approval) to know for certain whether any
of them were actually exposed to the original bug, versus leaving it
unconfirmed since the fix protects them either way. Decide whether/when to
deploy this and the prior SE/SE_diff fix to Production — neither has been
deployed yet.

---

<!-- source: claude/cramapple-grading-mlr0o1@7f02b9c305c7 -->
## Statistics Deterministic Verifier: Fixed Redundant-Value Over-Strictness, Found a Severity Bug - 2026-07-12

**Task:** Follows from the AP Statistics calibration dry-run's 10 disagreement
cases (85.7% agreement, `ap_statistics_phase_c_calibration_dryrun_2026_07_11/report.md`).
Relates to `TASK-0016` (grading engine), `TASK-0010` (grading confidence).
**Status:** 2 of 10 cases fixed in `supabase/functions/_shared/statistics-verifier.ts`
(live production code, already deployed and now updated in git on
`claude/cramapple-grading-mlr0o1`). 1 fully verified fixed, 1 partially
fixed with the remaining blocker identified and deliberately not touched.
A severity-level architectural issue was found and is flagged, not fixed,
pending an explicit decision. Not yet independently re-QA'd.

**Summary:** At David's request, went through all 10 calibration dry-run
disagreements individually, pulling the exact response text and rubric for
each (not just the dry-run's summary notes) before deciding what to fix.
They split into four distinct categories, not one "tolerance" problem:

**Category A — over-strict, live, fixed (2 of 3 cases):**
`APSTAT-MOD3-H001-INV` and `APSTAT-MOD6-H001` both required an
intermediate value (SE / SE_diff) to appear as a bare typed number in the
response, even though (a) the rubric's own `learner_facing_text` only asks
for the final CI bounds / t-statistic, never a separately-stated SE, and
(b) a correct final value mathematically implies a correct intermediate
value (CI_low/CI_high are computed directly from SE; t_stat from SE_diff),
making the explicit intermediate check both over-strict and redundant.
Removed SE (21.9089) from `APSTAT-MOD3-H001-INV`'s target list and SE_diff
(1.94079) from `APSTAT-MOD6-H001`'s. **Verified by hand** (plain-JS
reimplementation of the exact comparison logic, run against the real
response texts from `provisional_labels.json`, not assumed): `MOD6-H001`
now fully passes. `MOD3-H001-INV` only partially improves — see the
severity finding below for why it still doesn't fully flip.

**Category B — not a live bug (1 case, `APSTAT-MOD4-H001-INV`):** this
content_key isn't in `statistics-verifier.ts`'s target list at all: this
disagreement only exists in the calibration dry-run's own standalone
research-script reimplementation (`calibration_runner.ts`), not in
production. No live code to fix. Not adding new deterministic coverage for
it — that's expanding what the system checks, a different decision than
fixing what's already checked.

**Category C — false-positive over-credit risk, not currently live (2
cases, `APSTAT-MOD7-M005` and `STATS-MOD1-E004`):** both are genuine bugs
in the *dry-run script's* local number-matching (a coincidentally-matching
number gets credited even when it's not the actual computed answer — e.g.
`STATS-MOD1-E004`'s response computes the WRONG mean, 22.5, but happens to
include "18" as one of the four raw data values it's averaging, and the
naive matcher credits it as if 18 were the given answer). **Neither
content_key is in the live `statistics-verifier.ts` target list**, so this
specific exposure isn't live today — but the underlying pattern (matching
any occurrence of a number in free text, with no check that it's presented
as the actual final answer) is structurally present in every one of the
~20 items that *are* covered. Correctly distinguishing "the decisive final
answer" from "a number that happens to appear" is a real NLP problem, not
a parameter tweak — deliberately not attempting an ad-hoc heuristic fix for
this now, same reasoning as the QA checker's visual-keyword heuristic
earlier this session. Flagging as a known structural risk across the whole
target list, not fixing.

**Category D — label/scope questions, not code bugs (4 cases,
`APSTAT-MOD6-M001` x2, `APSTAT-MOD7-H001`, `APSTAT-MOD8-M002`,
`APSTAT-MOD8-M004`):** the deterministic checker (where it applies) is
either already correct and the *provisional* AI-draft label looks wrong
(`MOD6-M001`'s two disagreements look like a genuine labeling
inconsistency — one arithmetically-correct response labeled
`partially_earned`, another labeled `not_earned` for what reads as the
same class of correct-arithmetic response; `MOD7-H001` looks like the
provisional label under-crediting terse-but-correct work), or the
criterion is fundamentally about *interpretation* language, not just
numeric presence (`MOD8-M002`/`MOD8-M004`: the number is present but the
interpretation is backwards/miscontextualized, which a number-presence
check structurally cannot evaluate). None of these are addressed here —
they're `TASK-0010` Phase 2 adjudication-queue material, not code to
patch unilaterally.

**Severity finding, not fixed, needs an explicit decision:** traced
exactly how `checkStatisticsDeterministicEvidence`'s result is used in
`evaluate-attempt/index.ts` (lines ~747, ~1128). When it flags, the result
(`buildStatisticsDeterministicFallback`) **replaces the entire grading
payload for the whole response, zeroes points_earned, sets confidence to
low, and skips the LLM grader call entirely** — for every criterion in the
item, not just the one with the missing value. This is exactly why the
`MOD3-H001-INV` fix above only partially worked: the item's flat target
list bundles values from two logically separate rubric criteria
(`ci_calculation`'s CI bounds and `hypothesis_test`'s t-statistic) into one
undifferentiated list, so a response that fully earns `ci_calculation` but
doesn't compute an explicit numeric t-statistic for `hypothesis_test`
still gets the *entire response* hard-zeroed and never reaches the LLM —
confirmed against the real provisional-labeled-"earned" response used in
the dry-run. Fixing this properly means making the deterministic gate
criterion-aware (the calibration script's own local `keyedCriterionVerdict`
already does this correctly via `statistics_item_keys.json`'s
per-criterion `parts`, live production code does not) — a real
architecture change to a hard-gate in live grading code, not a parameter
tweak. Deliberately not attempted in this pass: no way to test the change
end-to-end in this environment (no Deno, no ability to invoke
`evaluate-attempt` live), and the blast radius (every AP Statistics FRQ
routed through this pre-filter, currently ~20 keyed items) is large enough
to warrant explicit sign-off before restructuring, not a same-session
silent fix.

**Verified before committing:** brace-balance checked (no Deno available
in this environment for a real typecheck — same limitation as every prior
code change this session); the two target-list edits verified against the
exact real response texts, not assumed correct from the summary notes.

**Next Owner:** David Bloom / Main Conductor
**Next Required Action:** Decide whether `buildStatisticsDeterministicFallback`
should keep its current all-or-nothing hard-block-and-zero-credit behavior,
or whether a criterion-aware version (or a softer "flag for review, still
let the LLM grade" behavior) should replace it — this affects every live
AP Statistics FRQ response routed through it today, not a hypothetical.
Route `MOD6-M001`'s apparent label inconsistency and `MOD7-H001`'s
possible under-crediting to `TASK-0010` Phase 2 adjudication once staffed.
Get this round independently re-QA'd before treating it as verified — same
standing caveat as every remediation round this session.

---

<!-- source: claude/cramapple-grading-mlr0o1@7f02b9c305c7 -->
## Phase C R4 Independent Re-QA - Confirmed - 2026-07-12

**Task:** TASK-0016 Phase C. Verifies the R4 remediation entry below.
**Status:** Independently re-QA'd, fresh/isolated agent, no memory of
building R4 or the checker script. **Verdict: holds up — no defects
found.** First remediation round on this packet to pass independent
re-verification on the first try; R1-R3 needed a second pass to find gaps.

**Summary:** Re-checked every specific R4 claim rather than trusting the
self-report: independently recomputed the `APSTAT-MOD7-H002-INV`
chi-square statistic from scratch (χ² = 48.61, df = 2, p < 0.0001 —
matches exactly) and confirmed all 4 response variants are internally
consistent with the new stimulus, not just the `fully_correct` one;
verified the `APSTAT-MOD7-M001`/`-M004` stimulus fixes against the
deterministic answer keys and `validate_keys.py`; wrote an independent
script checking difficulty-suffix consistency across **all 100 FRQ items
in every module**, not just Module 8 — zero mismatches, confirming the fix
was complete and didn't regress anything elsewhere; rebuilt the packet
from a clean detached worktree and confirmed byte-identical reproducibility.

**Directly tested, not just read, both self-disclosed checker
limitations** flagged in `scripts/task0016_phase_c_qa_checks.mjs`'s own
comments: scanned every `ecf_parts[].givens` value in the full 30-item key
file for the whitelisted convention values (0.5, 1.96, 1.645, 2.576, 2.326,
1.282) — found 9 occurrences, checked each by hand, all are genuine
textbook conventions (stated confidence levels, true/false guess
probability, or in one case a value the checker's own percent-regex
already catches directly). Separately grepped all 100 FRQ stems for
visual-vocabulary words the checker's keyword list doesn't cover ("bar
chart," "dotplot," "stem-and-leaf," "normal curve," etc.) — zero hits;
every "plot"/"table"/"graph" mention already matches the existing regex and
already shows up in the 7 human-read candidates. **Neither limitation is
currently exploitable on this corpus** — real gaps in principle, but not
live defects today.

Also read a further 10-item unchecklisted random sample (no keyword
heuristic, no prior review) for the same answerability defect class this
entire investigation has been about — no new issues found.

**Next Owner:** David Bloom / Main Conductor
**Next Required Action:** None blocking — R4 is verified. Remaining open
items unchanged from R4's own list: `APSTAT-MOD8-M001`'s strength-
assessment gap (left open, out of scope), and the rights/source +
manifest-schema-drift publish blockers flagged in `approval_packet.md`.

---

<!-- source: claude/cramapple-grading-mlr0o1@7f02b9c305c7 -->
## Phase C Remediation R4: Fixed 3 Unanswerable FRQs + Module 8 Difficulty Labels - 2026-07-12

**Task:** TASK-0016 Phase C. Directly follows the independent re-QA entry
below.
**Status:** Fixed on `claude/cramapple-grading-mlr0o1` (commit `b552f06`,
pushed to PR #38). **Independently re-QA'd 2026-07-12, same day — held up.**
See the "Phase C R4 Independent Re-QA — Confirmed" entry above for the
verification record. No staging or publish action executed.

**Summary:** At David's request to fix the 3 new answerability blockers,
the Module 8 difficulty labels, commit the missing checker script, and
re-scan the full corpus, brought the entire Phase C publish packet (all 9
generator inputs + the generator script + the deterministic-key validator,
previously only on `codex/task0016-phase-c-content-publish-approval-main`)
onto this branch.

**Fixed `APSTAT-MOD7-M001`/`-M004`/`-H002-INV`** — same defect class as the
original 8: rubric/answer-key data never shown to the student. Added the
missing stimulus text for the first two. For `-H002-INV` (a 4-part
contingency-table + chi-square item that was missing its medium-anxiety
group entirely), constructed a full self-consistent data set, independently
computed the chi-square statistic by hand (χ² ≈ 48.61, df=2, p<0.0001)
*before* writing it into the model response, and rewrote all 4 response
texts (fully-correct through subtly-wrong) to match. Also fixed an
unrelated bug found while editing: the item's `module` field said 6, its
content_key says MOD7.

**Fixed the Module 8 difficulty labels** — 9 of 10 items were tagged
`very_hard` regardless of key suffix; corrected `M001`-`M005` to `medium`
and `H001`-`H004` to `hard`, matching the corpus-wide suffix convention
confirmed elsewhere (E→easy 15/15, VH→very_hard 6/6, no exceptions outside
Module 8).

**Committed `scripts/task0016_phase_c_qa_checks.mjs`** — the checker both
`qa_review.md` and the original `remediation_log.md` cite was confirmed (by
the independent re-QA) to never have been committed anywhere; this is a
fresh implementation, not a recovery. Its first version produced its own
false positives — flagged the standard z=1.96 95%-CI critical value as a
"hidden given," and missed percentage-form data (`"35%"` in a stem vs.
`0.35` in the answer key) due to a number-matching bug. Fixed both before
committing. The full-corpus visual/tabular-keyword scan is deliberately a
**warning tier, not fail-closed** — verified by hand that it produces real
false positives on this corpus (self-contained or purely conceptual items
that happen to mention "table"/"plot"), so a regex flags human-read
candidates rather than asserting a verdict it can't actually make.

**Full-corpus scan result:** 7 candidates, resolved by hand — 6 confirmed
false positives (documented individually in `remediation_log.md`'s R4
section), 1 real and left open (`APSTAT-MOD8-M001`: direction is
answerable but the rubric's "strength" requirement has no supporting
scatter-tightness data in the stem — same defect class, but outside the
specific 3-item scope requested this round, so flagged rather than
silently fixed).

**Verified, not just asserted:** regenerated the packet
(`build_task0016_phase_c_publish_packet.mjs`, same 200/100/100/18/0/0
structural counts as before); re-ran `validate_keys.py`
(`ALL CHECKS PASS`, 44/44 keys, 7/7 ECF templates — confirms the
stem/stimulus-only edits didn't disturb the deterministic answer keys
underneath them); ran the new checker (`PASS`, 28 deterministically-keyed
FRQs matching R1-R3's figure).

**Also found and deliberately did not fix:** the checker's disposition
count (`deterministicKeyed`/`conceptualOnly`/`excludedOrMethodOnly`)
initially tried to reproduce R1-R3's "28 keyed / 68 conceptual / 4
excluded" split, but `statistics_item_keys.json` only covers 30 of the 100
FRQ items — there's no way to derive that specific 68/4 split from data
this checker has visibility into. Renamed the output to
`deterministicKeyed` (28, verified) / `notDeterministicallyKeyed` (72,
honest about being unclassified) rather than fabricate a number that looks
precise but isn't verifiable.

**Not done, at the time this entry was written:** independent re-QA of this
round — completed later the same day, see the entry above. Rights/source
and manifest-schema-drift issues flagged separately in `approval_packet.md`
remain untouched, out of scope for this fix.

**Next Owner:** David Bloom / Main Conductor
**Next Required Action:** Decide whether to fix `APSTAT-MOD8-M001` now or
leave it for a later round. Rights/source and manifest-schema-drift gate
still needs to clear before this packet is actually stage-ready — R4 fixed
content-answerability, not the separately-flagged publish blockers.

---

<!-- source: claude/cramapple-grading-mlr0o1@7f02b9c305c7 -->
## Phase C Publish Packet Independent Re-QA - Fail, New Blockers Found - 2026-07-12

**Task:** TASK-0016 Phase C (AP Statistics content publish packet). Relates
to `TASK-0010` (rubric/content quality) and the earlier Fail verdict on
`codex/task0016-phase-c-content-publish-approval-main`.
**Status:** Independently re-QA'd, fresh/isolated agent, no prior context on
this content. **Verdict: Fail — new blockers, not just re-confirmation of
old ones.** No content changed; this is a review-only pass. Not merged, not
published.

**Summary:** At David's request to "make sure" the Phase C remediation
actually holds up (the original Fail verdict's fixes had only been
self-verified by the same author who made them — see the earlier session
entries), ran an independent QA pass in an isolated git worktree
(`git worktree add --detach`, no shared state with the remediator's or the
original reviewer's checkout).

**R1 (reproducibility) and R2 (`APSTAT-MOD5-M001` sample-SD value:
7.91) — confirmed genuinely fixed.** Rebuilt the packet from a second,
independent detached worktree; output byte-identical to the committed
`bulk_import_payload.json`. Independently recomputed the SD by hand (sample
variance 62.5, sqrt = 7.905694... ≈ 7.91) — checks out. Re-ran
`validate_keys.py` independently (had to install `sympy`, undocumented
dependency): `ALL CHECKS PASS`.

**R3 (8 answerability fixes) — the named 8 are real, but the sweep was
incomplete.** All 8 claimed fixes independently verified as genuinely
answerable from their (now text-embedded) stimuli, math/logic checked by
hand for each. But the agent scanned the **full 100-item FRQ corpus**, not
just the 8-item checklist, and found the identical defect class
(rubric/answer requires data never shown to the student) still present in
at least 3 more items never mentioned by either the original QA or the
remediation log:

- `APSTAT-MOD7-M001` — contingency-table marginal-probability item; the
  needed counts (`prefer: 80, total: 200`) exist only in the hidden answer
  key, never in the student-facing stem.
- `APSTAT-MOD7-M004` — same pattern, tree-diagram probabilities
  (`p1: 0.3, p2: 0.7`) never surfaced to the student.
- `APSTAT-MOD7-H002-INV` — part (a) asks the student to construct a
  contingency table from data that isn't fully given (missing the
  low/medium/high anxiety group sizes) — same class as the already-fixed
  `MOD6-H002-INV`, but this sibling item was missed.
- Plus a softer one, `APSTAT-MOD8-M001` (rubric requires "moderate to
  strong strength" from a stem that only says "appears linear," no
  scatter-tightness info given).

**New issue, unrelated to R1-R3:** all 10 Module-8 FRQ items are tagged
`difficulty: "very_hard"` in `prompt_json` regardless of their key-suffix
letter (which encodes difficulty everywhere else in the corpus) — Module
8's medium/hard difficulty buckets are effectively empty for exam-draw
purposes. Not caught by the original QA's 15-item sample (Module 8 wasn't
in it).

**Could not verify:** the fail-closed checker script (`task0016_qa_checks.mjs`)
both prior documents cite as returning a clean pass is **not committed
anywhere in the repo** — it only ever existed at a `/private/tmp/...` path
on the original author's/remediator's own machines. The agent independently
re-derived the structural counts it would have checked (duplicates,
disposition counts, `-CAL` key count) by hand instead — matched, but this
is a partial substitute, not a re-run of the actual cited tool. Live-DB
collision/publish behavior also not checked (no live access), consistent
with both prior documents' own scope limits.

**Next Owner:** David Bloom / Main Conductor
**Next Required Action:** Do not run `bulk_import` on this packet. Fix
`APSTAT-MOD7-M001`, `APSTAT-MOD7-M004`, `APSTAT-MOD7-H002-INV` (same
stimulus-completion pattern as the original 8), correct the Module 8
difficulty field, and commit the QA-cited checker script into the repo so
future passes can actually re-run the same tool instead of re-deriving
substitute checks by hand. Then run a full-corpus (not 15-item sample)
answerability scan before the next QA pass, given a sample-based scan
already missed 3+4 items across two rounds.

---

<!-- source: claude/cramapple-grading-mlr0o1@7f02b9c305c7 -->
## TASK-0010 Approved and UX-006 Brief Replaced With Real Integration - 2026-07-12

**Task:** TASK-0010, UX-006. Follows directly from the two entries below.
**Status:** `TASK-0010` approved to execute (`APPROVAL-0026`/`DECISION-0036`).
`prompts/LOVABLE_UX006_STUDENT_PRACTICE_GRADING.md` replaced with a
real-integration version. Neither is a production deploy by itself — the
UX-006 brief is a build spec for whoever executes it next (Lovable), not
yet executed.

**Summary:** After the Phase A ship-and-fix work in the two entries below,
David approved `TASK-0010` (Grader Confidence and Calibration) to move from
`Proposed` to active execution, and asked for the `UX-006` Lovable brief to
be replaced from frontend-only/simulated to real backend integration.
Recorded as `APPROVAL-0026` and `DECISION-0036`: this authorizes the
confidence/calibration program to run, not a Done decision — none of
`TASK-0010`'s eleven acceptance criteria are met, and `NOW-013`'s gate on
learner-facing automated scores is explicitly still open (needs Phase 4
shadow cohort + Phase 5 limited release to actually pass). Updated
`docs/tasks/TASK-0010-...md` status/approval-state and
`docs/MASTER_TODO.md`'s `NOW-013`/Active Task Register rows accordingly.

Rewrote `prompts/LOVABLE_UX006_STUDENT_PRACTICE_GRADING.md` to wire the
existing UX design (MCQ/FRQ practice, criterion feedback, grading states)
to the real Production backend instead of Lovable-fixture state: real
Supabase auth (no anonymous), reads only through the curated `public.*`
views (`PHASE1_CURATED_INTERFACE_NOTES.md`), and a concrete
`evaluate-attempt` request/response contract pulled directly from the
deployed function's source (`operation`/`idempotency_key`/`attempt_id`/
`response_version_id`/`content_item_version_id`/`rubric_version_id`/
`assistance_condition`; response fields including the `feedback_preview`/
`action_hint`/`repair_hint` columns fixed in the prior entry). Explicitly
kept dispute and regrade simulated — no backend exists for either, in git
or on Production, so building against them for real would mean fabricating
a contract that doesn't exist anywhere.

**Two things flagged in the brief as needing live verification before
build, not asserted as fact:** (1) whether AP Biology content is actually
published yet — a prior finding (`DECISION-0033`) flagged all
`content_items` stuck in `draft`, which would block this brief from being
exercised end-to-end at all; (2) which entrypoint actually submits a
response — git has a `submit-response` edge function and an
`app.submit_response` RPC, but Production's live edge-function list
(checked this session) shows a differently-named `attempt-response`
function instead, consistent with the same out-of-band deployment pattern
already found for grading. Supabase MCP tool calls started requiring
interactive approval partway through this session (tool server
reconnected under new IDs) and couldn't be retried non-interactively, so
neither was confirmed live — the brief tells whoever builds it to check
both before wiring anything, rather than guessing.

**Addendum, same day:** David named himself Learning Quality Owner / Grading
Lead for `TASK-0010`. Updated the task file's `Owner` line and
`MASTER_TODO.md`'s `NOW-013` owner column accordingly; corrected
`DECISION-0036`'s Risks/Follow-ups (still unmerged at the time, so amended
in place rather than logged as a separate correction) to reflect it instead
of shipping a stale "not yet named" note. Phase 2 still needs a *second*
qualified Grading Validator besides David before that phase can run — the
task requires two independent blind scorers.

**Second addendum, same day:** David clarified the Grading Validators
(plural, Phase 2's "two qualified Grading Validators") will be sourced from
the tutors currently being hired, not separately recruited — no individuals
named yet since hiring is in progress. Recorded in the task file's Phase 2
section with an explicit dependency this creates: those tutors must clear
`TASK-0005`/`NOW-005`'s validator-qualification bar (still `In Progress`,
not yet approved) before they can score gold-set cases, so Phase 2 is now
blocked on two things, not one — hiring completing, and `NOW-005` clearing.
Whether David also serves as Lead Grading Validator (who adjudicates
disagreements between the two scorers) or that's a separate hired-tutor
role is not yet decided.

**Third addendum, same day:** David asked to be named one of the two
Grading Validators himself (not just Lead / Learning Quality Owner).
Recorded in the task file. This sharpens rather than resolves the open
question from the addendum above: the Lead's entire function is
adjudicating disagreements *between* the two blind scorers, so if David is
one of the two scorers, he structurally cannot also be the Lead
adjudicating his own disagreements with the other scorer — that would
collapse the independence the phase exists to protect. Flagged in the task
file as an unresolved process-design tradeoff (third person as Lead, or
David steps back from being a scorer) rather than picking one unilaterally.
Also noted explicitly: the `NOW-005`/`TASK-0005` qualification bar applies
to David the same as any hired-tutor validator — being Product Owner
doesn't exempt him from it.

**Next Owner:** David Bloom / Main Conductor
**Next Required Action:** Resolve the Lead-vs-scorer conflict above before
Phase 2 can actually run once validators are qualified and hiring lands.
Before handing the UX-006 brief to Lovable, confirm the two open items from
the first addendum via Supabase MCP or dashboard (content publish status;
`attempt-response` vs `submit-response`/`app.submit_response` as the real
submission entrypoint). Track `NOW-005` (validator qualifications) as a
prerequisite for anyone — David included — to score Phase 2 gold-set
cases.

---

<!-- source: codex/five-subject-harness-and-content@c5f539294c4d -->
## Tutor Content-Review Pipeline Repaired, Subject Qualifications Added, Grading-Telemetry Auth Bug Found; AP Bio/Stats Draft QA Pass and Fixes — 2026-07-12

**Task:** Cross-cutting — relates to TASK-0016, tutor onboarding, content QA.
**Status:** Tutor invite/review pipeline now functional end-to-end and verified with a real test invite. Content QA pass complete for all 200 draft MCQs and 254 draft FRQs, with fixes applied. Grading-telemetry dashboard fix scoped but blocked on Lovable credits.

**Summary:** Session started from "make sure the assessment process is ready" (tutors hired to review content) and expanded through several rounds of live debugging and QA once testing surfaced real bugs.

**Tutor review pipeline — bugs found and fixed (all deployed to Production, `pcntajvbdfqhbeewmdry`):**
- `reviewer-invite` edge function existed in the repo but was never deployed to Production (deployed now, v3).
- `app.prevent_profile_role_change` trigger blocked legitimate service-role profile updates because it checked the legacy JWT `role` claim, which doesn't exist under Production's newer opaque API-key format; fixed to also check `current_user = 'service_role'` (migration `fix_prevent_profile_role_change_service_role_check`).
- `checkDashboardAdmin`/`assertAdmin` (Lovable frontend, `Remix of Cramapple App` project) called a `has_role` RPC that doesn't exist in Production — silently made every admin check return false, hiding admin nav and blocking `/reviewer/users`. Fixed to read `profiles.role` directly.
- A stray Lovable-authored edit briefly replaced the working `reviewer-invite` call with a hand-rolled query against a nonexistent `user_roles` table; reverted to the correct edge-function call.
- Added a real invite form to `/reviewer/users` (was a hardcoded stub) with role + subject-qualification selection.

**New feature — subject qualifications (per Product Owner decision):** tutors are now scoped to the AP subject(s) they're invited for, stored in `app.validator_qualifications` (`qualification_type='grading'`, `exam_ids[]`). `assign-for-review` now rejects assigning content outside a tutor's qualified subjects; `review-queue` filters a tutor's own queue by qualification (fails open if a reviewer has no qualification rows, so existing seed data isn't broken). Two required-but-previously-missing columns on `validator_qualifications` (`qualification_policy_version_id`, `expires_at`) were populated with placeholder/far-future values since no formal qualification-policy framework exists yet.

**Review-flow behavior changes (per Product Owner decision):** `review-decision`'s `tutor_question` stage now requires per-answer-choice approval (`answer_approvals`) for MCQs in the same submission as the question decision — collapsing the old two-phase design where answer-choice review happened in a separate `tutor_answer` round after reader approval. A `note` is now hard-required (400 `note_required`) when the question or any answer choice isn't fully approved. Added a `diagnostic_flag` UI control with reviewer guidance copy (first draft, not yet reviewed by Learning Quality). Deferred: module/topic tagging and student-facing surfacing timing — logged as open follow-up, not built this session.

**Grading-telemetry dashboard bug found, fix scoped but not yet shipped (blocked on Lovable credits):** `loadDashboardOverview` queries `dashboard_subjects_v1`/`dashboard_pipeline_v1`/etc. using the service-role client, but those views gate on `auth.uid()` — service-role calls have no `auth.uid()`, so every dashboard view silently returns zero rows regardless of admin status. Fix (swap to the caller's own RLS-scoped client) is fully specified but blocked on the Lovable workspace's monthly credit limit as of session end.

**Content QA pass — all 200 draft MCQs + 254 draft FRQs reviewed (AP Biology + AP Statistics), via parallel review agents; confirmed findings fixed directly in Production:**
- 2 MCQ content defects fixed: `APBIO-MCQ-005` (glucose/galactose mislabeled as structural isomers — they're stereoisomers/epimers), `APBIO-MCQ-082` (stated allele frequency 20.8% didn't match the founder-effect math; corrected to 16.7%).
- 3 FRQ procedural/labeling defects fixed: `APSTAT-MOD3-H001-INV` and `APSTAT-MOD6-M003` used z*-based confidence intervals when only sample SD was known (should be t*-based; corrected with right df and bounds); `STATS-MOD1-E002` mislabeled a student ID number as quantitative (corrected to categorical).
- 12 FRQ rubric/canonical-answer mismatches fixed (mostly AP Biology): canonical answers that didn't actually contain what their own rubric criterion required (missing probability calculations, missing named concepts like "directional selection" or "bottleneck effect," missing numeric results).
- **Confirmed canonical answers (`content_item_versions.canonical_answer_1/2`) are not consumed anywhere in the live grading/repair path** (`evaluate-attempt` doesn't reference them; `statistics-verifier.ts`'s deterministic table was a one-time manual copy, not a live read) — they're an editorial/reference field only. This resolved an open question about backfill priority.
- Backfilled full-credit canonical answers for all 42 `APBIO-FRQ-L-*` (long-form) items, which had none. In the process found and fixed: `APBIO-FRQ-L-028` (stem only presented part (a); rubric graded parts (b)(c)(d) on content never shown to the student — extended the stem to properly set up all four parts) and `APBIO-FRQ-L-004` (stem referenced "the 6th base" of a template strand for a point mutation, but that position didn't match the described base per the given sequence; corrected to the actual matching position and updated the codon-change reasoning).
- Found and fixed a real data-integrity bug in **published** content: all 40 `APSTATS-HDG-2026-GRAPH-*` items (hand-drawn graph FRQs, live in Production) were missing their `app.frq_criteria` projection, even though the correct rubric already existed in `content_item_versions.prompt_json`. Fixed via a direct SQL projection from the existing JSON (no content invented) — 160 criteria rows inserted across 40 items. An initial "12 items with no data at all" finding from one QA batch was a false alarm caused by a wrong content_key filter pattern; the real content_key prefixes are `APBIO-HDG-` / `APSTATS-HDG-`, not `HDG-` alone.
- A systemic content-items/versions/choices/criteria linkage sweep across the *entire* corpus (not just drafts) found no other orphaned items beyond the one above.

**Files changed in this repo (uncommitted as of session end):** `supabase/functions/reviewer-invite/index.ts`, `assign-for-review/index.ts`, `review-decision/index.ts`, `review-queue/index.ts` — all mirror what's deployed live in Production; not yet committed to git.

**Next Owner:** David Bloom
**Next Required Action:** (1) Add Lovable workspace credits, then have Claude send the already-specified `loadDashboardOverview`/Content-page fix. (2) Decide whether to run the same systemic `prompt_json`-vs-`frq_criteria` desync check against other published content beyond the HDG items. (3) Review/commit the four locally-modified edge function files. (4) Resume TASK-0016 critical path — gold-set adjudication is still the launch-gate blocker, now realistically unblocked since the tutor pipeline works.

<!-- source: codex/five-subject-harness-and-content@c5f539294c4d -->
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

<!-- source: codex/five-subject-harness-and-content@c5f539294c4d -->
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

<!-- source: codex/five-subject-harness-and-content@c5f539294c4d -->
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

<!-- source: codex/five-subject-harness-and-content@c5f539294c4d -->
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

<!-- source: codex/five-subject-harness-and-content@c5f539294c4d -->
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

<!-- source: recovery/ap-statistics-benchmark-content-20260721@48194689e25e -->
## AP Statistics Phase 6 Calibration Blocked - 2026-07-01

**Task:** TASK-0013 (AP Statistics, Subject 2), Phase 6.
**Status:** Blocked. No grading logic changed.

**Summary:** Ran the Phase 6 calibration protocol as far as the evidence
allowed. The protocol requires real independent blind tutor scores for AP
Statistics responses in the existing reviewer workflow before calculating
criterion-level agreement, LLM-alone vs. LLM+verifier lift, or disagreement
clusters. The only documented live AP Statistics content is the 36-item smoke
batch published earlier on 2026-07-01; that same execution record states it
was promoted past `content_review_assignments` / `content_review_decisions`
and was not reviewed by a tutor/reader.

Attempted a read-only Supabase connector query against Production
(`pcntajvbdfqhbeewmdry`) to reconfirm table counts, but the connector failed
before SQL execution with `MCP startup failed: timed out awaiting tools/list`.
No database numbers were fabricated. Wrote the blocker report at
`docs/research/ap_statistics_phase6_calibration_report_2026-07-01.md`.

**Next Owner:** David Bloom / Orly Bloom.
**Next Required Action:** Create or collect a real blind-scored AP Statistics
FRQ calibration sample, then rerun Phase 6. Until then, do not wire the
deterministic calculation verifier into live grading and do not claim AP
Statistics grader-agreement/confidence numbers.

---
