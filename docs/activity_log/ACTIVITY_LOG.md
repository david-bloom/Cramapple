# Activity Log

This log records meaningful operating activity, approvals, closeouts, blockers, and handoffs. Newest entries are at the top.

## Index

Most recent entries (full reverse-chronological list follows below):

- Blocked Five-Subject Branch Archived After Three-Way Verification; §3 Skill Anchoring Source-Verified 55/55; Jill Confirmation Deferred — 2026-08-02
- Reviewer Unit Picker Moved to the 5-Unit CED; Retired Content Withdrawn From All Review Queues — 2026-08-01
- AP Statistics FRQ Remediation Executed — 90 Retired, 68 Reclassified, Discovered All Statistics FRQs Were Unservable — 2026-08-01
- AP Statistics Reviewer Feedback Triaged; Authoring Prompts Corrected to the 5-Unit CED — 2026-08-01
- Publication-Trust Second Defect Found; 7 Disapproved Items Unpublished; Reviewer Roster Reshuffled; Rationale Repairs Begun — 2026-07-31
- Complete Four-Course Physics Review Packet Assigned to Saood — 2026-07-27
- Cross-Subject 21-Question Repairs Applied; 12 Chemistry Historical Labels Reconciled — 2026-07-27
- Cross-Subject 21-Question Content-Remediation Pilot Packet Frozen — 2026-07-27
- All 234 Changes-Requested Questions Audited; 70 Low-Risk Repairs Approved — 2026-07-27
- Biology Unapproved/Unassigned Paired Review Assigned to Sohail and Adil — 2026-07-27
- `approve_with_edits` State Logic and Correction-Backed Labels Repaired — 2026-07-27
- Complete AP Calculus BC Review Packet Assigned to Muhammad Saood — 2026-07-27
- Grading-Experiment Readiness Re-Verified; Engine 1 Grading+Repair Pilot Spec Authored — 2026-07-27
- One-Reviewer + AI-QA Publication Reconciliation — 2026-07-27
- Two-Approval / Executed-Edit Publication Reconciliation — 2026-07-27
- Published-Without-Approval Assignment Backfill — 2026-07-27
- Saood Precalculus/Physics QA Reconciled; 12 Corrections Forked; 16 False Exclusions Reversed — 2026-07-27
- AP Statistics Hand-Drawn-Graph Set-04 Calibration Pack Recovered and Integrated — 2026-07-27
- Rolling 72-Hour Reviewer QA and Remediation — 2026-07-27
- Two Frontend Bugs Found and Fixed (Stimulus-Table Rendering, Bio Reviewer Unit Availability); AP Statistics Never Assessed for FRQ Structure — 2026-07-26
- Branch Hygiene Operational Enforcement — 2026-07-26
- FRQ Structure QA and Repair Across Six Subjects (Bio, Physics, Chemistry, Calc AB/BC, Precalc) — 2026-07-25/26
- 100 New AP Chemistry Items Authored and Assigned; Calc/Precalc CED+QA Pass; Reviewer Roster Reshuffled — 2026-07-24
- Fixed Alternating-Residual Artifact in Scatterplot Datasets; CED Verification for Calc/Chem/Bio; Reviewer Tagging-Gap Pipeline Fix; Adil Abbasi Onboarded — 2026-07-24
- CED Verification and Physics Content Review — Session Handoff — 2026-07-24
- Shipped review-decision Atomic-Lock Fix; Fixed Unrealistic Scatterplot Correlations Flagged by Jill — 2026-07-22
- Production Content Reconciled to Tutor Decisions; Reviewer Image Support Shipped — 2026-07-20
- Kimi Grading Experiment Wired and Pre-Registered — 2026-07-17
- Phase A Broken-Import Fix and Deterministic-Layer-Only Ship Decision — 2026-07-12
- TASK-0016 Phase A Grading-Router Reconciled Onto Grading Branch — 2026-07-12
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

## Blocked Five-Subject Branch Archived After Three-Way Verification; §3 Skill Anchoring Source-Verified 55/55; Jill Confirmation Deferred — 2026-08-02

**Task:** Blocked-branch reconciliation (plan: `prompts/FABLE_AP_STATISTICS_BLOCKED_BRANCH_RECONCILIATION_2026_08_02.md`, Revision 3 executed after Fable review)
**Status:** Archive executed and verified. Fact pack upgraded. One step remains open (Step 0 — landing the working branch on `main`), plus the deferred Jill confirmation and a follow-up branch/PR sweep.

**Summary:** `codex/five-subject-harness-and-content` (forked 2026-07-01, 93 commits, 1176 files, pre-dating the schema-baseline squash `b6559a2`) was archived — not merged — after three independent verifications came back safe. The one asset worth salvaging (§3 per-topic skill/LO anchoring for AP Statistics) had already been ported to the fact pack and is now source-verified.

**1. Provenance check (all subjects, not just Statistics).** All 288 content keys seeded on the branch (Chemistry 36, Physics 1/2/C-Mech/C-E&M 36 each, Calc AB/BC/Precalc 36 each) exist in Production via a separate SQL-loader ingestion documented on the branch itself (`docs/qa/CALCULUS_THREE_SUBJECT_SEED_PRODUCTION_EVIDENCE_2026_07_17.md`; Prod `created_at` 2026-07-18/20 confirms). Spot-checked stems are character-identical, and Production has since evolved *past* the branch (v2 rewrites, M1 minimum_fix work). Archiving loses no content.

**2. Migration end-state diff (declared-DDL analysis; Docker unavailable for a scratch apply).** The baseline is **not** a strict superset of the branch's 27 migrations: (a) most objects are in the baseline ✅; (b) nothing is in live Production beyond the baseline; (c) eight migrations' worth of TASK-0017 harness schema (item-package columns, taxonomy tables, verifier/capability tables, review-pool harness) exist in **Dev only** 🟡; (d) two files declare functions/triggers existing **nowhere** 🔴: `20260718014159_add_atomic_draft_package_adoption.sql` and `202607200001_subject_package_preflight.sql`. These were deliberately **not** ported to the working branch (they depend on Dev-only columns absent from the Production baseline and would break migration application); they are preserved verbatim in the archive tag and should be revisited when TASK-0017 harness work resumes.

**3. §3 skill-anchoring verification.** The local CED PDF turned out to be the **new Fall-2026 edition** (contrary to earlier session belief that no usable source existed). All 55 topic rows in the fact pack's §3 were verified against the five Unit-at-a-Glance tables (pp. 27–28, 59–60, 83–84, 118–119, 146): **zero mismatches** of any kind; Unit 5's LO→skill footnote additionally confirmed against topic pages 151–154. The branch's "60 topics" claim was wrong (55 current + 5 removed = 60 pre-removal). Fact pack confidence flags and §3 header updated from "unverified candidate" to "source-verified, SME confirmation deferred."

**4. Archive executed.** Annotated tag `archive/codex-five-subject-20260727` → `30bc07d`, pushed and verified on origin; remote branch deleted; stale `/private/tmp/cramapple-content-qa2` worktree registration pruned; local branch deleted. The tag message carries the full rationale and names the unique-to-ref files.

**5. Jill confirmation deferred (David's decision, 2026-08-02).** Verifying 55 rows is significant work and she's needed elsewhere. The review Sheet ("AP Statistics — Topic Skill-Tag Review (Jill) v2") exists, unsent. With the source verification done, her eventual pass is exceptions-oriented, not a proofread. Hard deadline remains: before bulk Statistics authoring keys items off these tags. The stale v1 Sheet (alphanumeric codes) still needs David to confirm it's trashed before anything is sent.

**6. G3V vertical-slice question closed on content grounds.** The full delta between the 07-14 draft and the approved fact pack is: §3 (additive), the §8 curvature wording, and the §9 count fix. All Production items touching residuals/curvature were cross-checked against the §8 change on 2026-08-02 (zero edits needed); the §9 fix is doc-only. G3V content needs no rework **regardless of whether the 07-14 relayed sign-off was genuine.** What survives is governance only, feeding the new discipline rule: gate sign-offs must come from the gatekeeper's own hand (edit trail, submitted decision) — never relayed.

**Next Required Action:** (1) **Step 0 — land `claude/cramapple-grading-experiments-9lkjqc` on `main`**; everything from 2026-08-02 (baseline squash, approved fact pack, deployed `review-queue` source, CED-alignment content fixes) exists only on that branch, and the deployed edge-function code currently has no merged source of truth. Awaiting David's answer on what, if anything, blocks the PR. (2) Follow-up sweep of same-era refs, none triaged here: branches `codex/task0018-recognized-home` + `codex/task0019-session-targets` (with `.worktrees/`), `recovery/production-plumbing-storage-20260721` + `recovery/ap-statistics-benchmark-content-20260721` (live `~/.codex/worktrees/`), `origin/recovery/ap-statistics-set04-integration`, `claude/grading-conflict-resolution-ledger` (separate checkout), two detached-HEAD worktrees — plus stale draft PRs #43, #39, #38 from the same era.

## Reviewer Unit Picker Moved to the 5-Unit CED; Retired Content Withdrawn From All Review Queues — 2026-08-01

**Task:** TASK-0013
**Status:** Database change applied and verified. Two code changes made but **not
yet shipped** — see Next Required Action.

**Summary:** Closed Jill's finding 1 (decision D1) and the orphaned-assignment
defect found during post-execution validation of the FRQ remediation.

**1. Reviewer unit picker (`src/data/taxonomy.ts`, `exam-buddy-wireframe`).**
`AP_STATISTICS_UNITS` replaced with the 5-unit Fall 2026 CED structure. While
making the change, found a **second, latent bug**: on `origin/main` the reviewer
route derives subject keys as `"biology"` / `"ap-statistics"` (hyphens) but
`SUBJECT_UNITS` is keyed `ap_biology` / `ap_statistics` (underscores), so
`getUnitsForSubject` returns `[]` and main would render an **empty** picker. Since
Jill saw a populated nine-item list, `origin/main` is not what is deployed —
worth knowing before anyone assumes a main-based fix reaches her. The fix
therefore normalizes the key (both separators, either Biology spelling) rather
than matching one convention, so it is correct on whichever branch deploys. A
comment records that unit ids 1–5 now denote different content than ids 1–5 did
under the retired CED, so historical tags are not comparable and still need the
D1 remap.

**2. Retired content in review queues.** Migration
`20260802020000_withdraw_review_assignments_on_retired_content` added a
`withdrawn` assignment status and withdrew every open assignment pointing at
retired content: **7 total — 4 AP Statistics (Jill) created by yesterday's
retirement, plus 3 pre-existing AP Biology (Adil Abbasi)**. Verified afterwards:
zero retired items remain in any queue, for any reviewer. `withdrawn` was added
rather than reusing `skipped` because `skipped` is a reviewer-initiated action —
reusing it would have recorded against two named reviewers that they skipped work
they were never shown. Assignments are preserved, not deleted, so the audit trail
survives.

**3. Recurrence fix (`supabase/functions/review-queue/index.ts`).** The queue
filtered only on assignment status and never on `content_items.status`, which is
why retiring content left it in queues indefinitely. Added `status` to the
content-items fetch and a filter that drops retired items at the queue boundary.
`deno check` passes. Confirmed the deployed function (v26) already contains the
other uncommitted local change in that file (the MCQ `buildReviewerStem` fix), so
this filter is the only delta.

**Update — published 2026-08-01 23:56 ET (2026-08-02 03:56 UTC).** The taxonomy fix
was applied in the Lovable workspace (the production build source) rather than via a
GitHub PR, because the workspace had already fetched the broken `537b09c` and builds
from its own state. Lovable confirmed all seven lookup assertions pass and the
typecheck is clean. **This timestamp is the CED cutover boundary** — AP Statistics
unit tags written before it use the retired 9-unit numbering, after it the 5-unit
Fall 2026 numbering, and for unit ids 1–5 the timestamp is currently the only thing
distinguishing them. Pre-cutover snapshot (200 item labels, 19 decision tags, broken
down by unit) is recorded in
`docs/research/AP_STATISTICS_REVIEWER_FEEDBACK_2026_08_01.md`.

**Update 2 — a THIRD defect, found by post-publish verification (2026-08-02).**
Verifying the publish on a real item exposed a further bug that the first two fixes
did not touch. `subjectKeyFromContentKey` in the reviewer route matched the
content_key prefix by exact equality against `"APSTAT"`, but AP Statistics content
uses **three** prefixes: `APSTAT` (60 items), `APSTATS` (176), `STATS` (40). The
latter two returned `null`, so **216 of 276 Statistics items — 78% — never rendered a
unit picker at all.** Production data confirmed it exactly: 100% of Statistics unit
tags sit on `APSTAT-*`; `APSTATS-*` had 138 decisions and 0 tags, `STATS-*` 21
decisions and 0 tags. This also explains Jill's original wording — "for *a few*
questions I have been asked to identify which unit" — she only ever saw the picker on
the 22% that resolved. Fixed via `prompts/LOVABLE_REVIEWER_SUBJECT_PREFIX_FIX_2026_08_02.md`
and published; **verified live on `APSTATS-MCQ-002-CAL`, which now shows the 5-unit
dropdown.** ("No topics available" alongside it is correct — Statistics has no
subtopic map, and the submit guard only requires a subtopic when options exist.)

**Pattern worth naming.** Three independent defects in the same tagging path in two
days, all sharing one signature: **a lookup miss returns `[]`, which is
indistinguishable from "this subject legitimately has no units," and `[]` then
silently disables the requirement to tag.** No error, no log, no visible difference.
That is why all three survived. Any further work here should make the tagging
requirement fail loudly, or at minimum have the UI distinguish "no units configured"
from "units failed to load."

**Durable fix still outstanding.** Deriving subject from the content_key is the root
cause; the prefix list is a patch on a patch. `content_item_versions.subject_key` is
already populated correctly for all 530 items (`ap-statistics` for all three
prefixes, `biology` for APBIO). Adding `subject_key` to the `review-queue` select and
payload, then using `artifact.subject_key` and deleting `subjectKeyFromContentKey`,
retires the whole bug class. Needs an edge-function deploy.

**Next Owner:** David Bloom
**Next Required Action:** (0) Confirm a tagged decision lands after the cutover on an
`APSTATS-*` or `STATS-*` item — that is the proof the 78% are now tagging, and it has
never happened before in this system's history. (1) Ship the `review-queue` change
through the normal deploy path — deliberately not hand-deployed via MCP, which would require
re-supplying every shared module by hand and risks breaking the reviewer queue on
a transcription error. Until it ships, the data is clean but the defect can
recur on the next retirement. (2) Land the `taxonomy.ts` change in whichever
branch deploys `cramapple.com` — it is committed nowhere yet and is uncommitted
in the `consolidate-apstats-ui` worktree. (3) Still outstanding from the prior
entry: commit the four remediation migrations to `supabase/migrations/`.

## AP Statistics FRQ Remediation Executed — 90 Retired, 68 Reclassified, Discovered All Statistics FRQs Were Unservable — 2026-08-01

**Task:** TASK-0013
**Status:** Executed against Production. Full record:
`docs/research/AP_STATISTICS_FRQ_REMEDIATION_PLAN_2026_08_01.md`.
**Summary:** Followed on from the same-day reviewer-feedback triage. Jill's finding
that AP Statistics had too many one-off short-answer items (not FRQs, not exam
format) was scoped into a plan, put through two rounds of independent model review
(Opus authored, Sonnet reviewed twice), then executed by Sonnet with the Product
Owner's explicit sign-off on the one remaining judgment call.

The review chain surfaced two things worth recording independent of the remediation
itself. First: **no AP Statistics FRQ — published or not, all 158 of them — was
reachable through the app's practice-session serving path before this change.** The
live RPC `select_practice_frqs` requires an exact `practice_format` match with no
NULL fallback, and every Statistics FRQ had `practice_format IS NULL`. This had
nothing to do with content quality; it was a pure metadata gap that made 67 published
items inert. Second: a database trigger (`prevent_live_frq_reclassification`) blocked
the straightforward fix for published items, requiring either a 48-item
unpublish/re-review/re-publish cycle through Jill's queue or a narrow, precisely
scoped exception to the trigger. The Product Owner chose the latter (option "2c")
after the trade-off was put to him directly rather than decided by either model.

**Executed as four migrations:** (1) retired 90 single-criterion "not really FRQ"
items (Jill's actual complaint); (2) backfilled `practice_format='targeted_drill'`
on 18 items with no guard conflict; (3) amended the reclassification trigger with a
carve-out scoped to exactly the `practice_format`-from-NULL case, leaving
`frq_archetype`/`frq_form` protection fully intact; (4) backfilled the remaining 50
items (48 published + 2 with stale published-version history the review chain
uncovered mid-execution). Two pre-execution checks the plan had flagged as required
but undone were closed first: no retiring content_key is hardcoded in app source, and
the one surface that reads content directly outside the RPC (`free-score-check`) is
hardcoded to AP Biology and cannot reach Statistics rows.

**Verified end state:** 158 FRQs total (unchanged), **94** retired, 68 tagged
`targeted_drill`, 48 published and now all 48 servable (up from 0), 0 tagged
`full_exam_frq`. No archetype was assigned to anything — nothing in the bank is
exam-shaped, and the constraint enforcing that was left untouched.

**Independent post-execution validation (Opus, same day).** Re-queried Production
directly. The data changes are correct and complete: all 90 category-A items retired
and left untagged, all 68 B/C/D items tagged `targeted_drill` with statuses
preserved, 48 published and 48 servable via `select_practice_frqs`, no deletions, and
the trigger carve-out confirmed narrow (it bypasses only when `old.practice_format IS
NULL` **and** `frq_archetype`/`frq_form` are unchanged; every genuine reclassification
still raises). The 18/50 population correction was verified and is a real catch — the
guard keys on `content_item_versions.status`, not `content_items.status`, so
`GRAPH-005` and `SFRQ-018` were blocked despite not being published items.

Two record-keeping corrections from that validation:

1. **The retired count is 94, not 91** (corrected above). 90 category A + 1 category B
   + 3 category D that were already retired pre-execution. The execution record
   counted only one pre-existing retired item and missed three hand-drawn ones. The
   earlier plan projection of 105 was also wrong, and that error originated in the
   plan document, not the execution — it used 15 (retired *plus* disapproved) as the
   baseline where the true pre-existing retired count was 7. **The database was right
   throughout; only the documents were wrong.**
2. **The four migrations are recorded in Production's ledger but are not in the
   repository.** `supabase/migrations/` has no corresponding files. This diverges from
   the plan's §10 (deliver as tracked migrations) and from the governance rule that
   GitHub is the source of truth. It matters most for the trigger amendment: the repo
   baseline `20260731160000_schema_baseline.sql` contains no `practice_format is null`
   carve-out, so a repo-to-Production reconciliation could silently revert it and
   re-block the backfill path. **Committing the four migration files is the one
   outstanding action from this execution.**

**Also found and explicitly out of scope for this execution:** `app.content_items_full_exam_archetype_check`'s
partner validator, `app.validate_full_exam_frq_version`, only checks shape for AP
Physics exam codes — Statistics items published as `full_exam_frq` currently get zero
validation, and if Statistics is added to that function's allow-list without also
adding its archetype branches, every future Statistics `full_exam_frq` publish will
hard-fail. This must be handled together with the four archetype slugs whenever that
work starts.

**Next Owner:** David Bloom
**Next Required Action:** **(0) Commit the four migration files to
`supabase/migrations/` so the repo matches Production** — the only item where delay
carries real risk, since the trigger carve-out currently exists in Production alone.
Then, when ready: (1) extend `validate_full_exam_frq_version` for AP Statistics
alongside adopting the four archetype slugs; (2) decide the fate of the two
published/approved out-of-scope-topic items and the 5 defective mosaic items
(separate triage doc); (3) resume the G0A fact-pack sign-off with Jill, still the
highest-leverage open item across both documents.

## AP Statistics Reviewer Feedback Triaged; Authoring Prompts Corrected to the 5-Unit CED — 2026-08-01

**Task:** TASK-0013
**Status:** Prompt fixes applied; six decisions open for the Product Owner
**Summary:** Jill submitted five AP Statistics content findings. All five were
verified against the Production database and the authoring prompts, and all five
are confirmed. Root causes: (a) the reviewer unit picker in the frontend repo is
still on the retired 9-unit CED — present on `origin/main`, and it hard-blocks
submission, so Jill was forced to tag items with retired units (19 Statistics
decisions carry old-CED unit tags, 2 of them pointing at a unit that no longer
exists); (b) there is no AP Statistics Long FRQ prompt, so every free-response
authoring run used the Biology-shaped 4-point "Short FRQ" format — which the AP
Statistics exam does not contain — producing 148 short FRQs against 10 long FRQs;
(c) the prompts carried no scope-exclusion list, admitting 19 items testing removed
or never-in-scope content, of which 2 are published and 3 `reviewed_approved`;
(d) the prompts carried no mosaic-plot rule, and 5 of 7 mosaic items have equal or
partly equal group totals, collapsing the display into a segmented bar chart.
Two defects Jill did not name were found: all 7 mosaic items ask students to read a
raw count off a proportions display, and two published/approved items test
combining random variables (also removed). Published mix is close to the inverse of
the exam (42 MCQ + 4×10pt FRQ): 16 MCQs, 66 short FRQs, 1 long FRQ.

**Key finding beyond the feedback itself:** findings 2, 3, and 4 are re-discoveries
of a problem already diagnosed and planned on 2026-07-13 (`DECISION-0036`,
`APPROVAL-0036`, target 100 MCQ / 70 FRQ). The sanctioned authoring input,
`docs/product/AP_STATISTICS_2027_CED_FACT_PACK.md`, exists **only on branch
`codex/five-subject-harness-and-content`** (commit `e0bf685`) and is invisible from
`main`. The rebuild is gated on G0A — subject-tutor sign-off on that fact pack — and
Jill is the AP Statistics subject tutor. She is the gate, and she has been spending
review cycles on 2025-26 content instead. Her findings answer three of the open G0A
questions from the reviewer's side.

Corrected both AP Statistics prompts against the fact pack: 5-unit taxonomy with a
where-the-old-material-went map, a hard-exclusion block covering all five confirmed
removals plus multiple regression, and mosaic/segmented-bar display rules. An
earlier over-correction in this session that would have excluded retained residual
curvature was caught against fact pack §8 and reversed. Placed a hold on new AP
Statistics Short FRQ batches pointing authors at the 10-point archetypes.
No content records and no frontend files were modified. Full triage with evidence:
`docs/research/AP_STATISTICS_REVIEWER_FEEDBACK_2026_08_01.md`.

**Next Owner:** David Bloom
**Next Required Action:** Rule on the six open decisions — D0 (highest leverage: get
the fact pack onto a reachable branch and in front of Jill for G0A sign-off);
D1 taxonomy swap + 19-tag remap; D2 MCQ target and publish push; D3 disposition of
the 148 short FRQs; D4 retiring 5 out-of-scope live/approved items; D5 regenerating
5 mosaic items and rewriting the task on all 7.

## Publication-Trust Second Defect Found; 7 Disapproved Items Unpublished; Reviewer Roster Reshuffled; Rationale Repairs Begun — 2026-07-31

**Task:** Content-review session. Reviewer QA sweep over the 126 decisions since
the prior sweep, reviewer performance assessment, content repair, and publication.

**Outcome:**

*Publication-trust P0, second manifestation.* Published state is decoupled from
review decisions in both directions. Found 10 items in `reviewed_approved`/
`published` carrying a reviewer disapproval, including **7 AP Statistics items
whose only decision on record was a disapproval**. Three (`APSTATS-MCQ-018`,
`-SFRQ-015`, `-SFRQ-017`) test slope inference and chi-square GOF, both removed
from the 2027 CED, and had been servable since 2026-07-01. All 7 unpublished to
`reviewed_disapproved`; reviewer decisions left untouched. A related defect: an
`approve_with_edits` leaves an item approved with the edit unmade — **78 items**
are in that state. Triage: 53 substantive, 12 cosmetic, 9 design improvements,
4 no-ops (notes requesting no change). Three approve/disapprove conflicts remain
unadjudicated (`APBIO-FRQ-L-034`, `apchem-frq-l-001`, `apchem-mcq-038`).

*Reviewer QA.* Integrity and structural checks over the window: all clean.
Content QA found 5 defects, all AP Chemistry, all Zeeshan approvals — including
`apchem-mcq-038` (simple distillation keyed correct for ethanol/water, which
forms an azeotrope) and two duplicate-answer-value items (`068`, `070`) that the
string-level distinctness check passes. Roster decisions: Qamar Ul Zaman removed
(0-for-9 against two peers, 0 notes on 16 approvals); Abdul Hanan retained and
re-queued (strongest distractor auditor on the roster, 6-0 vs Qamar, was idle);
Zeeshan retained by owner decision; Gulgeldi Darrynow's first packet QA'd —
strong on FRQs, 16 note-free MCQ approvals at 2.9 min each.

*Repairs.* 14 of 20 distractor-rationale defects repaired as v2 successors
(8 Precalculus, 6 Chemistry), 2 Chemistry FRQ rubrics rewritten from bundled
part-level criteria to 10 single-fact criteria each with points preserved.

*Publication.* 21 items published (11 Precalculus, 8 Chemistry, 2 Physics 2),
each with 2+ distinct approving reviewers, no disapprovals, no outstanding edits,
and independently QA'd. `apcalcab-mcq-004` rejected on provenance — its two
approvals came from a suspended reviewer and a test-fixture account.

**Files/systems changed:** Production Supabase (`pcntajvbdfqhbeewmdry`);
`scripts/content-seed/reviewer-qa-remediation/20260731_unpublish_disapproved_statistics.sql`,
`20260731_distractor_rationale_repair_precalculus.sql`,
`20260731_distractor_rationale_repair_chemistry.sql`;
`scripts/content-seed/reviewer-management/20260731_abdul_shazia_precalc_split_and_calcab_paired.sql`,
`20260731_dispose_qamar_pending_assignments.sql`.

**Open:** 18 FRQ rubric rewrites (17 Physics, 1 Calc BC); 6 remaining rationale
repairs; 4 AP Statistics items needing removal or data regeneration rather than
repair; `APBIO-MCQ-010` under-specified by its reviewer note. `DECISION-0041`
(TASK-0010 calibration as a publish gate) is referenced in agent memory but does
**not** exist in `DECISIONS_LOG.md`, which ends at DECISION-0035 — unresolved.

---

## Complete Four-Course Physics Review Packet Assigned to Saood — 2026-07-27

**Task:** Assign every latest active question across AP Physics 1, AP Physics
2, AP Physics C: Mechanics, and AP Physics C: Electricity and Magnetism to
Muhammad Saood.

**Outcome:** Verified Saood's active qualification for all four exams and
resolved 328 latest active questions: 176 MCQ and 152 FRQ. Preserved 248
existing submitted assignments and added the 80 missing assignments as
pending. Saood now has complete coverage: 88 Physics 1 questions and 80 each
for Physics 2, Physics C: Mechanics, and Physics C: E&M. All 328 assignments
carry the published workflow label `Saood complete Physics review`
(`saood-complete-physics-review-2026-07-27`) in their owning exam pack.
Independent reconciliation found zero missing, skipped, or item-type-mismatched
assignments.

**Files/systems changed:** Production Supabase
`pcntajvbdfqhbeewmdry`; repo script
`scripts/content-seed/reviewer-management/20260727_saood_complete_physics_packet.sql`.

## Cross-Subject 21-Question Repairs Applied; 12 Chemistry Historical Labels Reconciled — 2026-07-27

**Task:** Repair the 21-question cross-subject pilot in Production, return
`APSTAT-MOD8-M004` and `apchem-mcq-050` to draft for second review, and repair
the stale tutor-pending labels on 12 Chemistry FRQ versions.

**Outcome:** Created immutable draft successors for all 21 pilot questions.
Nineteen contain the governed rubric, assumption, or substantive repair. The
Statistics and Chemistry controls are content-identical drafts awaiting
independent review. Retired all 21 source versions without approving or
publishing a successor. Reconciled 12 superseded Chemistry FRQ versions: four
approve outcomes now show `question_review_approved`, eight approve-with-edits
outcomes show `modification_reserved`, and all 12 historical versions are
retired.

**Verification:** 21/21 latest pilot successors and parent items are draft;
21/21 have no decision; 21/21 sources are retired. All 17 substantively
repaired FRQs reconcile points, all three MCQs retain four unique choices and
one answer, both controls are content-identical, and all 12 Chemistry outcomes
match their decision. Production has no second actively qualified Chemistry or
Statistics reviewer, so the controls remain unassigned.

**Evidence:**
`docs/research/content_remediation_cross_subject_pilot_2026_07_27/PRODUCTION_REPAIR_REPORT.md`;
`supabase/migrations/20260728013916_repair_cross_subject_pilot_and_chemistry_labels.sql`.

## Cross-Subject 21-Question Content-Remediation Pilot Packet Frozen — 2026-07-27

**Task:** Begin the author/tutor remediation of the 164 questions intentionally
left in `changes_requested` with a bounded cross-subject packet covering rubric
restructuring, assumptions, and substantive rewrites.

**Outcome:** Froze a 21-question packet across AP Biology, AP Chemistry, AP
Statistics, AP Physics 1, AP Physics 2, AP Physics C: E&M, and AP Physics C:
Mechanics. The packet contains eight rubric-point restructures, six
assumption/convention repairs, six substantive rewrite or adjudication cases,
and one verified-no-change control. Added a repair manifest, author handoff
prompt, read-only Production source resolver, validation requirements, and
independent-review exit criteria.

**Verification:** Production resolution found 21/21 current source versions
matching the frozen version numbers, 21/21 still `changes_requested`, and
21/21 with active tutor findings. The packet itself makes no Production
changes and authorizes no approval or publication.

**Evidence:**
`docs/research/content_remediation_cross_subject_pilot_2026_07_27/README.md`.

## All 234 Changes-Requested Questions Audited; 70 Low-Risk Repairs Approved — 2026-07-27

**Task:** Review every latest question labeled `changes_requested`, apply all
strictly low-risk corrections, and approve each question only after its defect
is verified as corrected.

**Outcome:** Audited all 234 questions and distinct tutor notes. Created 64
immutable corrected versions for exact, tutor-specified stem, choice, and
rationale edits. Verified that five AP Statistics questions already contained
their requested corrections and that one AP Precalculus tutor note identified
no defect, so those six correct current versions were preserved. Added
immutable approvals for all 70 verified questions. Left 164 questions in
`changes_requested`: 124 FRQs requiring scoring/task-design judgment and 40
MCQs requiring non-mechanical subject-matter or rewrite decisions.

**Verification:** 70/70 remediated latest versions and parent items are
`reviewed_approved`; 164 latest versions remain `changes_requested`. Every
changed MCQ has exactly one keyed answer and no duplicate choice text. Nothing
was published.

**Evidence:** `docs/research/CHANGES_REQUESTED_LOW_RISK_REMEDIATION_2026_07_27.md`;
`supabase/migrations/20260728011701_remediate_low_risk_changes_requested.sql`.

## Biology Unapproved/Unassigned Paired Review Assigned to Sohail and Adil — 2026-07-27

**Task:** Assign every unapproved or unassigned latest active AP Biology
question to Sarah Sohail and Adil Abbasi, with both reviewers covering the
same questions.

**Outcome:** Verified active AP Biology qualifications for both reviewers and
resolved 112 eligible latest active questions from authoritative lifecycle
state: 75 MCQ and 37 FRQ. Reused their existing assignments and blind groups,
added the 143 missing reviewer-question assignments, and reopened Adil's two
skipped assignments as pending. Both reviewers now cover all 112 questions;
all 112 pairs share matching non-null `blind_group_id` values. Existing
submitted decisions remain intact. All 224 reviewer-question assignments are
grouped under the published workflow label
`Biology unapproved or unassigned paired review`
(`sohail-adil-biology-unapproved-unassigned-2026-07-27`).

**Files/systems changed:** Production Supabase
`pcntajvbdfqhbeewmdry`; repo script
`scripts/content-seed/reviewer-management/20260727_sohail_adil_biology_unapproved_unassigned_pair.sql`.

## `approve_with_edits` State Logic and Correction-Backed Labels Repaired — 2026-07-27

**Task:** Enforce the Product Owner rule that `approve_with_edits` remains
changes-requested until the defect is corrected, after which the corrected
question becomes approved.

**Outcome:** Fixed the Production state-machine regression that mapped tutor
scores 1 and 2 to the same `reviewed_approved` state. Added
`changes_requested`, corrected blind-pair aggregation, and prevented decisions
on old versions from changing the current item. Added immutable, auditable
`approve` decisions for 28 correction-backed latest versions while preserving
the historical edit requests through `supersedes_id`. Demoted 234 unresolved,
non-published latest versions from false approval to `changes_requested`.
Published ambiguous cases were flagged `modification_reserved`, not silently
removed.

**Verification:** 28/28 repaired latest versions now have `approve` as their
only active label; all 28 audit assignments are submitted and tagged
`owner_remediation_approval`. The migration applied to Production
`pcntajvbdfqhbeewmdry`.

**Evidence:** `docs/research/APPROVE_WITH_EDITS_STATE_REPAIR_2026_07_27.md`;
`supabase/migrations/20260728005749_correct_approve_with_edits_state.sql`.

## Complete AP Calculus BC Review Packet Assigned to Muhammad Saood — 2026-07-27

**Task:** Create one reviewer packet containing every current AP Calculus BC
question and assign it to Muhammad Saood.

**Outcome:** Verified that Saood holds an active qualification for AP Calculus
BC, then created 36 pending `tutor_question` assignments covering every latest
active BC item: 20 MCQ and 16 FRQ. Grouped all 36 assignments under the
published workflow label `AP Calculus BC complete review`
(`saood-ap-calculus-bc-complete-2026-07-27`). Independent reconciliation found
36 assignments, 36 labels, zero item-type mismatches, and zero missing latest
items. The two pre-existing pending Carlos Eduardo Hutchings assignments (one
MCQ and one FRQ, with no decisions) were left intact.

**Files/systems changed:** Production Supabase
`pcntajvbdfqhbeewmdry`; repo script
`scripts/content-seed/reviewer-management/20260727_saood_ap_calculus_bc_complete_packet.sql`.

## Grading-Experiment Readiness Re-Verified; Engine 1 Grading+Repair Pilot Spec Authored — 2026-07-27

**Task:** Answer "are we ready to start running grading experiments?" — verify
three specific readiness claims (reviewed content at scale, hand-drawn
responses for Phase B, ≥20 verified Stats questions) rather than accept them,
then move to actually preparing a first real experiment.

**Findings:**
- Corrected an earlier conclusion: the tracked repo hand-drawn-graph corpus is
  synthetic and its one documented real pilot was QA-blocked, but a
  previously-unknown local directory (`docs/hand drawn samples/`, untracked,
  not in git) contains ~295 real photographed hand-drawn responses across
  Biology, AP Statistics, Calculus AB, and Chemistry. Broader sampling (7
  additional images across every subfolder) confirmed no synthetic files are
  mixed in.
- Pulled live production counts: 468 `reviewed_approved` items total (274 MCQ
  + 194 FRQ), concentrated in Physics (all 4 courses) and Statistics; AP
  Statistics alone has 58 `reviewed_approved` (37 MCQ + 21 FRQ), confirming
  and exceeding the "≥20" claim.
- Checked whether `published` implies `reviewed_approved` and found it does
  not: only 83 of 159 published items (52%) have an actual
  `content_review_decisions` row with `tutor_decision in ('approve',
  'approve_with_edits')` behind them. Chemistry and both Calculus tracks have
  zero approved published items. This is the [publication-trust
  bug](../architecture/) already on record, now confirmed concretely in data.
- Test-merged `claude/cramapple-grading-experiments-9lkjqc` against
  `codex/five-subject-harness-and-content` in a scratch clone: the two
  branches are complementary (content/harness vs. grading runtime) but not
  cleanly mergeable — 7 real conflicts in `admin-content`, `attempt-response`,
  `review-decision`, `review-queue`, plus `ACTIVITY_LOG.md`/`DECISIONS_LOG.md`
  and two architecture docs. Deferred as a separate manual-merge task, not a
  blocker for running experiments now.
- Researched whether a zero-cost dry-run harness exists for the real grading
  path: it does not. `grading-router.ts`'s routing logic is free and
  deterministic but doesn't score anything; `evaluate-attempt/index.ts` calls
  OpenAI directly and unconditionally with no mock/stub seam. Also confirmed
  `evaluate-attempt` calls OpenAI directly rather than the Vercel AI Gateway
  the project otherwise standardizes on — worth a separate look.
- Researched the real invocation contract: `evaluate-attempt` requires a real
  `attempts` + submitted `response_versions` row and only grades `published`
  content (rejects `reviewed_approved` alone); no designated safe test
  account exists in the codebase; no real candidate-answer corpus exists
  paired with real content_keys.

**Outcome:** Selected 6 real production items (all `published` and backed by
a genuine approval decision — 3 Biology FRQ, 3 Statistics FRQ; MCQs
deliberately excluded since MCQ grading is `rule_based_mcq` with no repair
path to test) and generated 30 candidate student answers (5 per item, ranging
quality tier 1–5, one guaranteed tier-5 each) via an independently-prompted
Gemini pass, blind to the canonical answers/rubric to avoid bias. Authored and
committed the full execution spec, the candidate-answer set, and a
self-contained Codex kickoff prompt:
`docs/research/grading_repair_pilot_2026_07_27/README.md`,
`candidate_answers.json`, `gemini_answer_generation_prompt.md`, and
`prompts/CODEX_GRADING_REPAIR_PILOT_KICKOFF_2026_07_27.md` (commit `0c5fc16`,
pushed to `claude/cramapple-grading-experiments-9lkjqc`). The spec requires
Codex to create one isolated synthetic test-student identity, run all 30
answers through the real `evaluate-attempt`/`grading-router`/`grading-repair`
path in Production, report accuracy/speed/cost findings against the standing
Speed > Quality > Cost priority, and fully clean up all test data afterward.

**Next Owner:** Codex (execution), then David Bloom (review of
`RESULTS_2026_07_27.md`).
**Next Required Action:** Hand
`prompts/CODEX_GRADING_REPAIR_PILOT_KICKOFF_2026_07_27.md` to Codex and run the
pilot end-to-end, including cleanup verification.

## One-Reviewer + AI-QA Publication Reconciliation — 2026-07-27

**Task:** Publish every latest question version with one clean approval from an
active qualified tutor reviewer and authoritative Codex or Claude QA evidence.

**Outcome:** Identified 18 eligible versions: four immutable QA-remediation
forks and 14 AP Statistics versions carrying the Codex verification profile.
Published all 18; final verification found 18 eligible, 18 published, and zero
remaining unpublished. No explicit Claude QA marker was present in production,
so no question qualified on Claude evidence alone.

**Guardrail:** A plain content-generation `codex` tag was not treated as QA.
Five score-2 approved-with-edits questions were excluded because the requested
follow-up edits are not recorded as executed: `apphy1-frq-013`,
`apphy2-mcq-016`, `apphycem-frq-014`, `apphycem-mcq-003`, and
`APSTAT-MOD8-M004`.

**Production Fix:** Publishing exposed a null-handling defect in
`app.validate_full_exam_frq_version`: Physics MCQs with
`practice_format IS NULL` were incorrectly evaluated as full-exam FRQs. Applied
migration `fix_full_exam_frq_validator_null_practice_format`, using
`IS DISTINCT FROM` so only explicit `full_exam_frq` items enter that validator.

## Two-Approval / Executed-Edit Publication Reconciliation — 2026-07-27

**Task:** Publish every latest content version that either has approvals from
two distinct qualified reviewers or is an immutable remediation fork implementing
a reviewer's approved-with-edits decision.

**Outcome:** Reconciled 38 eligible latest versions. Eight multi-review-approved
AP Biology MCQs were already published. Published 30 structurally complete
remediation forks across Biology, Chemistry, Physics, Precalculus, and
Statistics, and skipped their now-redundant pending re-review assignments.
Four forks initially encountered the one-published-version constraint; their
superseded published versions were retired before publishing the corrected
latest versions. Final verification: 38 eligible, 38 published, zero remaining
unpublished.

**Exclusions:** Five structurally invalid, retired Biology short FRQs were not
republished despite having two old approvals. Test-account approvals do not
count toward the qualified two-reviewer rule.

## Published-Without-Approval Assignment Backfill — 2026-07-27

**Task:** Ensure every published latest question version without an approving
tutor-question decision is assigned to a qualified subject reviewer.

**Outcome:** Found 76 published versions without approval. Nineteen already had
open assignments. Created the 56 missing assignments: 38 AP Statistics to Jill
Schmidlkofer, 13 AP Biology to Sarah Sohail, and 5 AP Biology to Adil Abbasi.
Calculus and Chemistry gaps were already assigned to Carlos Eduardo Hutchings
and Muhammad Zeeshan, so no duplicates were added.

`APSTATS-HDG-2026-GRAPH-039` already had Jill's explicit disapproval while
remaining published, so it was retired instead of being incorrectly treated as
unreviewed. Final production reconciliation: 75 published latest versions
remain without approval, all 75 have an open tutor-question assignment, and
zero are unassigned.

**Next Required Action:** Complete the queued reviews and do not promote
replacement versions without an approving tutor decision.

## Saood Precalculus/Physics QA Reconciled; 12 Corrections Forked; 16 False Exclusions Reversed - 2026-07-27

**Task:** Independently assess Muhammad Saood's completed AP Precalculus and all-Physics review at question level and apply confirmed fixes without overwriting submitted review evidence.

**Outcome:** Reconciled 388 submitted decisions across AP Precalculus and the four Physics subjects. Saood found several genuine mathematical, physical, ambiguity, and rubric-alignment defects, but his 16 disapprovals of the new full-scale Physics FRQs were invalid: the mandatory subparts existed in `prompt_json.parts`, while the reviewer delivery/rendering path showed only the generic `stem`. The 16 decisions and assignments remain preserved, but their automatic `reviewed_disapproved` / `excluded` state was reversed to draft so they cannot be published or treated as validly rejected. The production `review-queue` Edge Function was updated to include `artifact.prompt_json` (v24). The corresponding Lovable reviewer-client rendering change remains blocked pending explicit authorization to send the implementation request to the external Lovable agent; therefore the 16 questions were not reopened.

Confirmed fixes were implemented as immutable new versions for nine Precalculus FRQs (`001`, `005`, `007`, `008`, `009`, `010`, `013`, `014`, `016`), Precalculus MCQ `010`, and Physics C: E&M FRQs `013` and `022`. These changes make every scored rubric requirement explicit in the prompt, remove the strict-threshold ambiguity in Precalculus FRQ `007`, add the inverse-function domain to MCQ `010`, correct the fixed-interior-radius field scaling in E&M FRQ `013`, and repair the impossible equilibrium-release setup/missing mass in E&M FRQ `022`. All 12 latest versions have matching hashes and fresh pending Saood rechecks; all prior versions and decisions remain intact.

**Files/systems changed:** Production Supabase `pcntajvbdfqhbeewmdry` — 12 new content versions + cloned choices/criteria + 12 pending recheck assignments; 16 full-scale Physics versions/items returned to draft; `review-queue` Edge Function v24. Repo — `supabase/functions/review-queue/index.ts`; `scripts/content-seed/reviewer-qa-remediation/20260727_saood_precalc_physics_qa.sql`.

**Next Required Action:** authorize and ship the reviewer-client change that preserves and renders `prompt_json.parts`, then assign the 16 full-scale Physics FRQs for a valid second review (preferably Ghazanfar for independence).

**Follow-up, same date:** David directed that the second review go back to Saood. Shipped a server-side reviewer-display safeguard in `review-queue` that appends any structured `prompt_json.parts` missing from the visible stem, avoiding both the client-rendering gap and duplicate prompts. Created immutable v2 forks of all 16 full-scale Physics FRQs, cloned all 160 rubric rows, grouped the assignments under the published workflow label `Full-scale Physics FRQ recheck` (one label per owning exam pack), and assigned all 16 to Saood as pending `tutor_question` work. Final reconciliation: 16/16 latest versions carry the pack marker, 16/16 items and versions are assigned, 16/16 hashes match, 16/16 pending Saood assignments have pack labels, and 16/16 original v1 decisions remain preserved.

## AP Statistics Hand-Drawn-Graph Set-04 Calibration Pack Recovered and Integrated — 2026-07-27

**Task:** TASK-0011 (handwritten graph capture); direct follow-on to
"Hand-Drawn Graph Corpus Realism Fix and Four-Finding Spot-Check — 2026-06-30".
**Status:** Research artifact integrated onto `main`. No production or
content-release approval — this is calibration/benchmark material, not
learner-facing content.

**Summary:** A branch of AP Statistics research work (`recovery/ap-statistics-benchmark-content-20260721`)
was produced entirely inside a detached/dirty worktree between 2026-06-30 and
2026-07-02 and was never recorded in this log at the time — it surfaced only
during a branch/PR-count reduction pass on 2026-07-27, three-plus weeks after
the fact. Independent re-QA confirmed the work is real, technically sound, and
still relevant to the active TASK-0011 grader-productionalization effort, so it
is being landed now rather than discarded, with this entry closing the
record-keeping gap.

**What `set_04` is:** a hard-case hand-drawn-graph calibration pack
(`docs/research/hand_drawn_graph_corpus_2026_06_30/trace_sets/set_04/`),
generated by `scripts/generate_hand_drawn_trace_set_04.py` against the
corrected v0.2 corpus (`HDG-2026-P2-*`, the realism-fixed generator from the
2026-06-30 entry) — not the earlier defective v0.1 corpus. It is intentionally
biased toward the estimate/annotation criteria that an earlier benchmark pass
found showed rubric drift, while still retaining categorical and series
controls, and is the concrete follow-through on that 2026-06-30 entry's own
"Next Required Action" #3 ("point the trace renderer at the v0.2 package").

**Other artifacts integrated from the same recovered branch** (all research/
prompt material, no schema or production code):
- `docs/research/hand_drawn_graph_benchmark_2026_06_30/` — an actual completed
  benchmark run against the v0.2 corpus, including a 150-item fast-escalation
  result set (`runs/hand_drawn_graph_benchmark_results_fast_esc_150.jsonl`) and
  two report variants.
- `docs/research/ap_statistics_graph_response_seed_2026_07_02/` — a 12-item
  seed set with reference images and a contact sheet.
- `docs/research/ap_statistics_phase4_mcq_smoke_batch_2026_07_01/` and
  `docs/research/ap_statistics_phase6_calibration_report_2026-07-01.md` — a
  content batch and a blocker report from an earlier Phase 4/6 attempt.
- `prompts/CLAUDE_AP_STATISTICS_PHASE6_CALIBRATION_RUN.md`,
  `prompts/CODEX_AP_STATISTICS_PHASE4_PILOT_CONTENT_BATCH.md`,
  `prompts/LOVABLE_AP_STATISTICS_SUBJECT_AWARE_ONBOARDING.md` — drafted,
  not-yet-executed handoff prompts for those same phases.
- `prompts/LOVABLE_HOMEPAGE_DEMO_FRQ.md` — extended the homepage demo spec from
  AP-Biology-only to alternate AP Biology and AP Statistics examples.
- `docs/architecture/CONTENT_AUTHORING_AND_PROMPT_ARCHITECTURE.md` §5.1 and
  `docs/product/AP_STATISTICS_PHASE4_CONTENT_AUTHORING_BRIEF.md` — a durable
  "platform vs. subject-specific responsibilities" clarification, still
  accurate today and unrelated to any date-specific status claim.

**Deliberately excluded from this integration:**
- `docs/tasks/TASK-0013-AP-STATISTICS-LAUNCH.md` — the recovered branch's edit
  is a 2026-07-01 status snapshot (e.g. "Phase 4 smoke batch live... 71-MCQ/
  33-FRQ pilot pending") that is now stale relative to `main`'s actual current
  TASK-0013 state; merging it would have regressed the doc's accuracy rather
  than improved it.
- `legacy/Blueprint_*` and `legacy/PROJECT_SETUP.md` — `main` does not carry
  these files at all (they were apparently removed outright, not merely
  relocated, at some point after this branch diverged); reintroducing them was
  out of scope for this integration.
- The recovered branch's own `ACTIVITY_LOG.md` and `docs/README.md` edits —
  superseded by `main`'s independently-evolved versions of both; this entry
  replaces them for the `set_04`-relevant history.

**Open items carried forward from the 2026-06-30 entry, still unresolved:**
pen-type is still uncontrolled; no single-violation true-negative cases exist;
no adjudicated dual-human gold exists for any image; external multimodal
grading remains blocked on Product Owner data-transfer approval. These still
gate any learner-facing automated graph score.

**Next Owner:** David Bloom (Product Owner), or whoever currently owns
TASK-0011.
**Next Required Action:** Decide whether to run `set_04` through a reviewer
blind-scoring pass now that it's landed, given the benchmark results already
in hand suggest genuine value in resolving the estimate/annotation rubric-drift
finding it targets.

---

## Rolling 72-Hour Reviewer QA and Remediation — 2026-07-27

**Task:** Independently QA every tutor-question decision submitted from
2026-07-24 13:19:11 UTC through 2026-07-27 13:19:11 UTC; adjudicate suggested
edits and disapprovals; apply confirmed fixes without destroying review history.

**Result:** Audited 420 decisions: 197 approved as-is, 200 approved with edits
(188 distinct questions), and 23 disapproved. Thirty-three distinct
approve-with-edits questions now have accepted versioned remediation; the other
155 recommendations were declined because they were optional style preferences,
restated content already present, or were not supported by the question. The
final cross-subject tranche created 16 immutable corrected versions and assigned
each back to the relevant reviewer. Corrections include Biology rubric/content
alignment, graph stimulus synchronization, Statistics wording and fundraiser
expected-value realism, and the AP Chemistry real-gas direction error.

**Disapproval adjudication:** Only `APBIO-FRQ-L-018` was a currently live,
fatally unusable question; it combined a meiosis stimulus, photosynthesis
questions, and a meiosis rubric, so the item and version were retired. Four
Physics disapprovals correctly identified defects in old versions that had
already been superseded. Sixteen full-scale Physics disapprovals were false
positives caused by the reviewer UI omitting structured FRQ parts; replacement
versions remain assigned for re-review after the rendering fix.
`APBIO-FRQ-L-034` and `APBIO-HDG-2026-GRAPH-008` did not substantiate
retirement; the latter received a narrower rubric/data synchronization fix.

**Evidence:** Production marker
`prompt_json.qa_remediation = '2026-07-27 rolling 72h reviewer QA'` appears on
16 corrected versions, each with exactly one pending reviewer assignment.
The executed idempotent remediation is
`scripts/content-seed/reviewer-qa-remediation/20260727_last_72h_cross_subject_qa.sql`.

**Next Owner:** Assigned subject reviewers
**Next Required Action:** Re-review the corrected versions; complete Saood's
16-item full-scale Physics recheck pack before making retirement decisions on
those questions.

## Two Frontend Bugs Found and Fixed (Stimulus-Table Rendering, Bio Reviewer Unit Availability); AP Statistics Never Assessed for FRQ Structure - 2026-07-26

**Task:** Continuation of the FRQ structure QA/repair effort (see entry below). David spotted that the reviewer portal showed no images for `APBIO-FRQ-L-009` despite the item clearly needing tabular data — investigating led to two real, unrelated frontend bugs in the production Lovable app (`d334fed9-5a97-4e76-906e-7c0ad7082212`, `exam-buddy-wireframe`, live at `cramapple.com`), both found and fixed the same way: read the actual rendering code first (not the reviewer portal alone, which needs a real login I don't have), diagnose precisely, send a fully-specified fix request to Lovable's build agent, then independently re-read the committed files to confirm the fix rather than trusting the agent's own "tests pass" report.

**Bug 1: student-facing stimulus text with embedded data tables rendered as unreadable collapsed text.** `src/routes/_ux.session.frq.tsx` and `_ux.session.mcq.tsx` both dumped `item.stimulus` raw into a plain `<p className="cm-lede">` with no whitespace or table handling — since the CSS class has no `white-space: pre-wrap`/`pre-line`, the browser's default behavior collapses all newlines, so any stimulus with a pipe-delimited data table (common across Bio/Chem/Physics content) rendered as one unreadable run-on line, tables merged together indistinguishably. Confirmed this affected the student view specifically — the reviewer portal (`reviewer.review.$assignmentId.tsx`) uses `white-space: pre-wrap` and was already fine, matching what the reviewer had described as merely suboptimal, not broken. Checked every other plausible rendering surface before calling this complete: the marketing FRQ demo (hardcoded content, not DB-driven), the per-subject marketing "practice questions" SEO pages (static content, already using a proper table component, verified on both Biology and Chemistry), and the hand-drawn capture flow (doesn't render stimulus at all) — none had the bug. Fixed by adding a shared `src/components/session/StimulusText.tsx` component plus a `src/lib/stimulus-blocks.ts` parser that splits stimulus text into prose blocks (line breaks preserved) and pipe-delimited table blocks (rendered via the existing shadcn `Table` components, with caption detection for a preceding "Table N: ..." line), then wiring both session routes to use it. Verified by hand-tracing the parser against `APBIO-FRQ-L-009`'s actual stimulus text and independently reading back the committed files and the new unit test (`stimulus-blocks.test.ts`) rather than trusting Lovable's self-reported "115/115 tests pass." Commit `cba2d608142d2dc26b748874758d7867380502c5`.

**Bug 2: two real AP Biology units were unselectable in the reviewer's mandatory topic-tagging dropdown, blocking submission.** Both Adil Abbasi and (independently) Sarah Sohail hit the same blocker: the reviewer review-workspace form requires picking a unit before it will accept a submission, but Unit 5 (Heredity) and Unit 8 (Ecology) were marked `available: false` in `src/data/taxonomy.ts`'s `AP_BIOLOGY_UNITS` array, rendering them as disabled "(coming soon)" options. This was stale, not deliberate — both units already have full subtopic lists in the same file, and Unit 8 (Ecology) content is demonstrably live in the review pipeline right now (`APBIO-FRQ-L-009`, fixed and reassigned in the prior entry, is an ecology item). Also discovered while diagnosing this: the mandatory-unit requirement is currently wired up **only** for Biology and Statistics (`subjectKeyFromContentKey` only maps `APBIO`→biology and `APSTAT`→ap-statistics; every other subject resolves to `null`, so `getUnitsForSubject` returns an empty list and the "must pick a unit" validation never triggers) — which is exactly why no Chemistry/Physics/Calculus reviewer had ever reported anything like this; they aren't subject to the requirement at all yet. Fixed by flipping both booleans to `available: true`, nothing else touched. Verified by independently reading back the committed file. Commit `9b8f7afa24b00f56aa6dc684c40987e37e76fc26`. David confirmed both units now show correctly for reviewers.

**Also surfaced: AP Statistics was never assessed for the FRQ structure issue.** David asked directly whether all subjects had been assessed and repaired. Answer: no — the structural-conformance sweep documented in the entry below covered Bio, Physics (all 4), Chemistry, Calc AB, Calc BC, and Precalculus, but never included Statistics. There's a separate, larger AP Stats 2027 format-change rebuild already decided (6×4pt→4×10pt FRQs, per earlier memory/decision records) that may or may not already account for this — that assumption has not been verified and should not be treated as a substitute for actually checking Stats' current live FRQ structure against its current CED.

**Files/systems changed:** Lovable project `d334fed9-5a97-4e76-906e-7c0ad7082212` (production frontend, `cramapple.com`) — `src/lib/stimulus-blocks.ts` (new), `src/components/session/StimulusText.tsx` (new), `src/lib/__tests__/stimulus-blocks.test.ts` (new), `src/routes/_ux.session.frq.tsx` and `_ux.session.mcq.tsx` (updated to use the new component), `src/data/taxonomy.ts` (two boolean flags flipped). No changes to this docs repo or to the content database in this entry.

**Next Owner:** whoever picks up the paused Chemistry FRQ-structure repair (see the prior entry's continuation prompt, unchanged by this work); David, for deciding whether/when to run the AP Statistics structural assessment.
**Next Required Action:** confirm with Adil and Sarah that their submissions now go through cleanly now that Units 5 and 8 are selectable (both were told the fix is live; neither has been independently confirmed via an authenticated click-through, which needs their own login). Decide whether to run the AP Statistics FRQ structure assessment next, using the same method as the other six subjects.

---

## Branch Hygiene Operational Enforcement — 2026-07-26

**Task:** Branch-sprawl resolution and prevention (`APPROVAL-0027` /
`DECISION-0039`)
**Status:** Charter adopted; repository controls active; first cleanup tranche
complete. One required-review constraint remains.

**Summary:** PR #55 encoded R1–R7 and was squash-merged as `0c83742` after a
Codex re-review, source-of-truth status correction, and collision-free
approval/decision number recheck. `main` is now PR-only; force-push and branch
deletion are blocked; administrators retain the human-only break-glass bypass.
PR #56 added `.github/workflows/minimal-ci.yml` and was squash-merged as
`c11d9b3`. Its `test` job passed on both the PR (Actions run `30227404660`) and
`main` (run `30227434281`), then became a strict required check. Review
conversations must be resolved. GitHub-native auto-merge and automatic remote
head deletion are enabled. Merge queue remains off because no stale-base race
has been observed.

**Required-review constraint:** David is currently the repository's only
collaborator. GitHub does not allow an account to approve its own PR, so setting
`required_approving_review_count: 1` would deadlock native auto-merge and force
the admin bypass on every PR. The count therefore remains `0` until a second
eligible reviewer is added; governance readiness remains a recorded
human/conductor step.

**Cleanup evidence:** Removed five local and four remote refs whose tips were
fully merged and which had no worktree, unique commits, or unpushed refs.
Removed the clean stale Physics Option B worktree/local branch after verifying
all PR #53 paths were byte-equivalent on `main`. Removed the clean detached
branch-audit worktree at a commit already ancestral to `main`. Removed merged
PR #55/#56 local and remote heads after byte-equivalence checks, and pruned one
dead `wt-bh-v3` worktree metadata entry. Six real worktrees remain.

**Protected / not touched:** The grading checkout remains at 62 changed or
untracked paths. The production-plumbing recovery worktree has 15 untracked
duplicate-named files and failed R7, so it was not cleaned. Recovery worktrees
and unmerged branches remain pending their PR disposition. Grading-document
recovery and executable Phase C artifact recovery remain separate future
slices. `math-verifier_test.ts` is not in the required CI battery because its
`cases.json` fixture is part of that still-unrecovered grading work.

**Next Owner:** David Bloom / Main Conductor
**Next Required Action:** Add a second eligible GitHub reviewer before requiring
one approval. Resolve PRs #50–#52, then continue R7 cleanup per branch. Recover
grading documentation and executable Phase C artifacts through separate scoped
PRs.

---

## FRQ Structure QA and Repair Across Six Subjects (Bio, Physics, Chemistry, Calc AB/BC, Precalc) - 2026-07-25/26

**Task:** Adil Abbasi (new Bio reviewer) flagged an FRQ as "needing AP rubric numbering (i, ii, iii, iv)." Investigating that single comment surfaced a systemic defect: live FRQ content across most subjects does not match the real College Board CED's required point/part structure per FRQ type — a genuine points-left-on-the-table bug, not cosmetic. This grew into a full cross-subject audit-and-repair effort spanning two days. **Chemistry finished 2026-07-26 — see the dedicated update below. All six subjects now either fixed or handed to their appropriate owner (Physics/Codex in progress separately).**

**Method established and reused across all six subjects:** pull the actual CED PDF (local repo copy or Google Drive), extract the real per-FRQ-type point/part structure with verbatim quotes (never from memory or "standard AP exam" assumptions), audit live DB content against it, then repair via either a mechanical fix (relabel/reweight/merge existing content) or genuine new authoring, always forking a new `content_item_versions` row (never editing in place) for any item with an existing submitted `content_review_decision`, and always independently re-querying the DB after every write rather than trusting a self-reported "verified" claim — a discipline that caught real errors, including two from a Haiku-run process that reported false verification results not backed by an actual query.

**AP Biology — long FRQs FIXED, short FRQs RETIRED pending rebuild.** Real CED: 4 parts labeled "Part A/B/C/D", uneven weights (long=9pts as 1/3/3/2 or 1/4/2/2; short=4pts as 1/1/1/1). Found: all 42 long FRQs had only ~8pts flat-weighted (a few with 5 criteria instead of 4); all 100 short FRQs had only 2 of the 4 required parts. Long FRQs corrected 2026-07-25 in independently-verified batches of 5 (Haiku-executed, versioned/forked where a decision existed, review assignments created for every fork) — confirmed 42/42 correct via a fresh query, including catching and fixing two batches where the reported "verified correct" values didn't match the actual database. Short FRQs were bulk-retired by David directly (`status='retired'`) pending the still-unbuilt 2-new-parts-per-item authoring pass — not yet scoped or assigned.

**Sarah Sohail added as a 3rd Biology reviewer** (existing profile, no onboarding needed) — given the same 20-item packet shape as Adil's original eval, minus the 5 now-retired short-FRQ slots (15 items: 10 MCQ + 5 long FRQ), sharing the same `blind_group_id`s as Amjad's/Adil's original decisions for direct comparison.

**AP Physics — all 4 subjects (Physics 1/2, C-Mech, C-E&M), Codex Phase 2 approved and in progress, not done by Claude directly.** Real CED: 4 FRQ archetypes (Mathematical Routines=10pts, Translation Between Representations=12pts, Experimental Design and Analysis=10pts, Qualitative/Quantitative Translation=8pts) — verified independently for Physics 1 directly from source; Physics 2/C-Mech/C-E&M confirmed via Codex's verbatim-quoted follow-up after an initial pass left them unconfirmed. Found: all 136 live FRQs are 2-6pts, none meeting any archetype's real total; 64/136 already carry recoverable legacy archetype tags, only 2 truly unclassified. Corrected an initial Haiku/Codex mischaracterization: the CED's "4 FRQs" describes one exam sitting, not a target bank size — a practice bank should have many items per archetype. Codex traced the actual live serving code (Lovable frontend) and confirmed the defect is **dormant**, not live — zero Physics FRQs are currently published at both item and version level. David approved Codex's Phase 2 plan: reclassify all 136 as `targeted_drill`, author a 16-item full-scale vertical slice (one per archetype per subject) as `full_exam_frq`, mandatory CED subpart patterns for that slice, ordinary human review (no owner override), and a hard requirement that the serving-layer enforcement (canonical use-classification field + server-owned selection RPC + `create_attempt` format-matching) ships before any of the new content publishes. **In progress with Codex, not tracked further in this repo session.**

**AP Chemistry — real CED: 3 Long FRQs (10pts each) + 4 Short FRQs (4pts each), 7 total, 46pts.** No fixed part template like Bio/Physics — the CED's own sample scoring guidelines show variable part counts (3 to 8 lettered parts) as long as the total is right. Found: only 1/28 long FRQs and 20/38 short FRQs already hit their targets; **this one is live, not dormant** — `apchem-frq-l-001` (4/10pts) and `apchem-sfrq-001` (2/4pts) are both currently published and reachable. **Fixed this session: the 6 worst long FRQs** (`apchem-frq-l-001` through `-006`, all were flat at 4pts against 10 required) — each part's already-compound task (e.g. "calculate X and justify Y") was split into 2-3 genuinely distinct, verified sub-criteria rather than point-inflated; 1 edited in place, 5 forked (2 auto-assigned by an existing DB trigger, 3 assigned manually) to Muhammad Zeeshan Hanif, the sole qualified Chemistry reviewer. Verified 6/6 at exactly 10 points.

**AP Calculus AB and BC — FIXED, 32/32 items verified.** Real CED (both subjects share the identical structure): 6 FRQs, every one worth exactly 9 points across 3-4 parts (2-5pts each) — confirmed via literal "Total for Question N — 9 points" lines in the primary source. Found: all 32 items (16 AB + 16 BC) were flat at exactly 3 points (1 per part), 0/32 conforming — the largest proportional gap found across all subjects. Fixed by splitting each existing 1-point task into a genuine 3-component breakdown (setup/method, execution, final answer or justification), verified against the actual math for every one of the 32 items individually — not mechanical relabeling. AB: 4 items edited in place, 12 forked (a `validator_qualifications` trigger correctly blocked assigning the forks to SK MD Ferdous, whose qualification is `suspended` per David's standing decision — routed to Carlos Eduardo Hutchings instead, the other active-qualified AB reviewer). BC: all 16 edited in place (zero prior review decisions existed); **no reviewer assigned** — BC currently has no qualified/assigned reviewer at all, a pre-existing gap, not something this session should have guessed at.

**AP Precalculus — FIXED, 16/16 items verified, including a self-caught near-mistake.** Real CED: 4 FRQ types (Function Concepts, Modeling a Non-Periodic Context, Modeling a Periodic Context, Symbolic Manipulations), each worth exactly 6 points across 3 lettered parts (2pts each). Initial assessment wrongly concluded the DB's existing 6-criteria-per-item structure (6×1pt) needed merging into 3×2pt — checked the real CED's own scoring guideline layout before executing and found the existing 6-criteria structure already matches the real exam's `i.`/`ii.` sub-scoring pattern for each part exactly; no merge was needed, and merging would have made the content *less* faithful, not more. The actual, narrower defect: lowercase `(a)/(b)/(c)` labeling instead of the real "Part A/B/C" convention, plus zero archetype classification on all 16 items. Fixed via fork (all 16 had a submitted decision — no in-place path existed for any of them), archetype-classified against the CED's precise task descriptions (2 of the 16 classifications were judgment calls, flagged as such rather than treated as settled), review assignments created. Discovered mid-fix that all 16 original decisions came from Muhammad Saood — initially treated as a possible mis-assignment (he's rostered as Physics-only) until David confirmed he's also a Calculus tutor being deliberately tested on Precalculus; re-review assignments routed back to him.

**Files/systems changed:** Production DB (`pcntajvbdfqhbeewmdry`) — Bio: 42 long-FRQ versions (7 forked) + criteria; Chemistry: 6 long-FRQ versions (5 forked) + criteria + 5 review assignments; Calc AB: 16 versions (12 forked) + criteria + 12 review assignments; Calc BC: 16 versions (in-place) + criteria; Precalc: 16 forked versions + criteria + 16 review assignments. Repo — `docs/architecture/CONTENT_AUTHORING_AND_PROMPT_ARCHITECTURE.md` (new required FRQ structural-conformance check, §9); `docs/research/AP_PHYSICS_FRQ_STRUCTURE_VALIDATION_2026_07_25.md`, `docs/research/AP_CHEMISTRY_FRQ_STRUCTURE_VALIDATION_2026_07_25.md`, `docs/research/AP_CALCULUS_PRECALC_FRQ_STRUCTURE_VALIDATION_2026_07_26.md` (new); `prompts/CODEX_AP_BIOLOGY_FRQ_STRUCTURE_CORRECTION_2026_07_25.md`, `prompts/CODEX_AP_PHYSICS_FRQ_STRUCTURE_VALIDATION_AND_CORRECTION_2026_07_25.md` (new); `prompts/CLAUDE_FRQ_STRUCTURE_REPAIR_CONTINUATION_2026_07_26.md` (new handoff for the unfinished Chemistry work). Memory — reviewer roster and a new cross-subject FRQ-structure-audit tracking file updated throughout.

**Next Owner:** whoever picks up the Chemistry repair (handoff prompt above has the exact remaining item lists and point deltas); David for the two staffing gaps surfaced (no qualified BC reviewer; Chemistry has only one reviewer, no pairing partner).
**Next Required Action:** Chemistry — 21 long FRQs (`apchem-frq-l-007` through `-027`, currently 7-9pts, need 10) and 19 short FRQs (10 at 2pts including the live `apchem-sfrq-001`, 4 at 3pts, 4 at 5-6pts needing trimming) remain. See the handoff prompt for exact lists, current point totals, and decision status per item.

### Update 2026-07-26: AP Chemistry FRQ repair completed

Picked up `prompts/CLAUDE_FRQ_STRUCTURE_REPAIR_CONTINUATION_2026_07_26.md`. Fixed `apchem-sfrq-001` first (was `published`/`published` and under-pointed at 2/4 — the one live-exposure item) before anything else. Then fixed the remaining 18 short FRQs (9 forked to Zeeshan since they had submitted decisions, 9 edited in place) and all 21 remaining long FRQs (all edited in place — none had picked up a submitted decision since the prior audit) in verified batches of 4-6, re-querying `frq_criteria` and `content_item_versions.prompt_json` after every write. Every addition/trim was genuinely new or removed content (new sub-parts on real chemistry — thermodynamics extensions, common-ion effects, two-point Arrhenius calculations, etc. — never point inflation on an unchanged task), with the underlying chemistry verified by hand before writing.

While doing a final full-bank sweep, found that the 6 long FRQs marked "fixed" in the entry above (`apchem-frq-l-001` through `-006`) had a real rubric (`frq_criteria` summed to 10, confirmed correct) but a stale `prompt_json.total_points` metadata field still reading 4 — never synced when they were fixed. Corrected all 6. This means any code path reading `total_points` from that field rather than summing `frq_criteria` would have shown an incorrect value for those 6 items until now; worth checking whether the serving/grading layer trusts that field anywhere.

**Final state, full Chemistry FRQ bank (66 items):** all 28 long FRQs at exactly 10/10 points; all 38 short FRQs at exactly 4/4 points. No known FRQ structural defects remain in Chemistry.

**Files/systems changed:** Production DB (`pcntajvbdfqhbeewmdry`) — `apchem-sfrq-001` (edited in place) plus 8 more short FRQs edited in place and 9 forked (`apchem-sfrq-002` through `-010`, all forked, 9 new `content_review_assignments` to Zeeshan); all 21 remaining long FRQs (`apchem-frq-l-007` through `-027`) edited in place plus new `frq_criteria` rows; `prompt_json.total_points` metadata corrected on `apchem-frq-l-001` through `-006`.

**Next Owner:** David — the two staffing gaps from the original entry remain open (no qualified Calc BC reviewer; Chemistry has only Zeeshan, no pairing partner). Whoever next touches the Chemistry serving/grading path should confirm nothing reads the stale-metadata `total_points` field directly instead of summing criteria.
**Next Required Action:** none blocking for Chemistry. AP Biology short-FRQ rebuild (100 items, bulk-retired, not yet scoped) remains the one open cross-subject FRQ-structure item.

---

## 100 New AP Chemistry Items Authored and Assigned; Calc/Precalc CED+QA Pass; Reviewer Roster Reshuffled - 2026-07-24

**Task:** Continuation of the same-day session above. Six pieces of work: (1) authored and shipped 100 new AP Chemistry items; (2) wrote a Codex handoff prompt for the equivalent Calculus/Precalculus batch; (3) quality-audited Muhammad Zeeshan Hanif's (Chemistry, probationary) and SK MD Ferdous's (Calc AB) review work; (4) validated existing Codex-authored Calc AB/BC/Precalc content against CED and ran a quality pass, fixing real defects; (5) confirmed Adil Abbasi's Bio re-review pack; (6) reshuffled reviewer assignments per David's direction.

**Status:** All done except the backfill/pipeline-code items noted as out of scope below.

**1. Authored and shipped 50 MCQ + 50 FRQ for AP Chemistry**, distributed proportionally across all 9 CED units via parallel subagents (several hit transient API 502/connection-closed errors and were retried — no data loss, just slower). Ran a scripted validation pass before touching Production and caught two real defects pre-insert: one MCQ with no `is_correct:true` anywhere despite a correct rationale, and one FRQ criterion with leftover mid-sentence scratch-work text ("...60−20... actually 45−20=25..."). Both fixed before insert. Inserted via `content/item-packages`-equivalent direct SQL (`apchem-mcq-021..070`, `apchem-frq-l-007..028`, `apchem-sfrq-011..038`) using the Supabase CLI (`supabase db query --linked -f <file>`) rather than pasting SQL through the chat tool, after confirming the CLI's default linkage resolves to Production. Split into 4 packs of 25 and assigned to Muhammad Zeeshan Hanif (single reviewer — no second Chemistry reviewer exists yet for blind pairing).

**2. Wrote `prompts/CODEX_CALCULUS_PRECALC_CONTENT_EXPANSION_2026_07_24.md`** — a handoff for Codex to author the same 50+50-per-subject batch for Calc AB, Calc BC, and Precalculus. While researching current numbering, discovered Codex's existing calc content (from `codex/five-subject-harness-and-content`, not this branch) uses a materially richer JSON-package schema than the one used for Chemistry here (`archetype_ref`, `taxonomy_refs`, `deterministic_checks`, `required_evidence`, provenance/originality metadata) — pointed the prompt at Codex's own existing files as the template rather than re-specifying a schema, and flagged the platform-wide MCQ-correct-answer-length-outlier pattern (found in `content-preflight.ts` git history) for Codex to avoid.

**3. Reviewer quality audits.** Zeeshan (34 Chemistry decisions, 0 disapprovals, ~41% `approve_with_edits`): spot-checked his edit notes against actual stored content and both checked items were real, precise catches (a truncated MCQ rationale; a rationale conflating "enthalpy" with "enthalpy change") — verdict good, recommended for full-queue promotion (pending David's go-ahead, not yet actioned). Ferdous (32 Calc AB decisions, all `approve`, 0 edits/disapprovals): independently re-derived the math on 7 sampled items — all correct — but every FRQ note was empty (`null`) and MCQ notes were heavily templated (3 items share an identical sentence verbatim), plus one internally inconsistent entry (`concern_codes: ["Accuracy"]` on a plain `approve` with no described concern). Content came back clean but the review process itself doesn't clear the bar set by Zeeshan/Jill/Amjad — flagged as inconclusive on reviewer diligence, not yet promoted.

**4. Validated existing Codex-authored Calc AB/BC/Precalc content (108 items) against the primary-source CED verified earlier this session** — clean: AB correctly uses only Units 1-8, BC correctly includes 9-10, Precalc correctly excludes the not-assessed Unit 4 (zero items tagged to it). Ran the MCQ-length-outlier check across all 60 existing MCQs: platform-here average is 1.11x (well under the 1.6-1.7x seen in Stats/Bio), but 11/60 (18%) still exceeded the 1.4x threshold. Fixed the 5 safely fixable ones (`apcalcab-mcq-013`, `apcalcbc-mcq-018`, `apprecalc-mcq-006`, `apprecalc-mcq-007`, `apprecalc-mcq-014`) without fabricating new distractor values; left 6 alone where the length gap is inherent to the math (e.g. irrational vs. integer answer choices) rather than authoring bias. One fix (`apprecalc-mcq-006` choice D) corrected a genuine bug independent of length: the distractor's value (`x²+5`) didn't match its own stated rationale ("adds f(x) and g(x)" — the actual sum is `x²+2x+2`). Also caught and **retracted** a false-positive math error I initially flagged on `apcalcbc-frq-005` — traced to comparing it against the wrong function from memory instead of pulling its actual stimulus first; the original content was correct.

**5. Confirmed Adil Abbasi's 20-item Bio re-review packet** (set up earlier this session) is intact: all 20 assignments still blind-paired with Amjad Ali's original decisions via matching `blind_group_id`, some already `submitted`.

**6. Reviewer roster changes, all per direct instruction, none unilateral:**
- SK MD Ferdous: no new work pending his vs. Hutchings comparison.
- Carlos Eduardo Hutchings: discovered he'd been assigned 100 pending items across all three Calc/Precalc subjects (not the single small evaluation packet on record) — deleted all 68 BC/Precalc assignments (all `pending`, zero decisions, safe to remove), leaving only his 32 AB items, so his packet now matches Ferdous's scope for a fair comparison.
- Ghazanfar Ali (2nd Physics reviewer): discovered he'd been assigned 136 pending items across all four Physics subjects (also not the single small packet on record) — deleted the 102 Physics 2/C-Mechanics/C-E&M assignments, leaving only his 34-item Physics 1 packet.
- Muhammad Saood (Physics, proven): no changes — already has 144 assignments across all 4 Physics subjects, 124 already submitted. Investigated "how much Physics content is CED-validated and QA'd" per David's question: CED validation was done in an *earlier* session (not re-verified today); no systematic QA pass (like the one just run on Calc) has ever been done on Physics content. Also surfaced 3 unresolved `reviewed_disapproved` items in Physics C E&M (`apphycem-frq-013`, `-frq-014`, `-mcq-003`) that need attention independent of any new assignment.

**Not done / explicitly out of scope this session:** backfilling topic tags on existing untagged content (flagged 2026-07-24 earlier, David hasn't asked for this); a Physics QA pass (flagged, not requested); resolving the 3 disapproved Physics C E&M items; deciding whether to promote Zeeshan or reassign Amjad's full Bio backlog to Adil (both contingent on further evaluation per standing roster policy).

**Files/systems changed:** Production DB (`pcntajvbdfqhbeewmdry`) — 100 new `apchem-*` content items + choices/criteria; 5 `apcalc*`/`apprecalc*` MCQ choice text/rationale edits; 4 new `content_review_assignments` packs (100 rows) for Zeeshan; 170 `content_review_assignments` rows deleted (68 Hutchings, 102 Ghazanfar). Repo — `prompts/CODEX_CALCULUS_PRECALC_CONTENT_EXPANSION_2026_07_24.md` (new); this activity log entry. Memory — reviewer roster memory updated to reflect all assignment changes above.

**Next Owner:** David Bloom (decide Zeeshan/Ferdous/Hutchings promotion calls once comparisons are in; decide on the 3 disapproved Physics C E&M items); whoever picks up Codex's calculus batch next (prompt is written, not yet sent).
**Next Required Action:** none blocking — all requested actions this session are complete. Recommend running a Physics QA pass (mirroring the Calc/Chem one) before trusting that corpus at the same confidence level as Calc/Chem, whenever that becomes a priority.

---

## Fixed Alternating-Residual Artifact in Scatterplot Datasets; CED Verification for Calc/Chem/Bio; Reviewer Tagging-Gap Pipeline Fix; Adil Abbasi Onboarded - 2026-07-24

**Task:** Four pieces of work in one session: (1) continued the CED-verification handoff from `docs/reviewer_packets/CED_VERIFICATION_STATUS_2026_07_24.md` (PR #49) for Calculus/Chemistry/Biology; (2) investigated and fixed a review-decision `topic_selections` field that was silently always empty; (3) investigated and fixed a new data-realism bug Jill Schmidlkofer flagged in trend-line questions; (4) built an onboarding review queue for a new Biology tutor.

**Status:** All four done.

**1. CED verification — Calculus confirmed stable, Chemistry cosmetic renames only, Biology has real topic renumbering.** Verified all three subjects' primary-source PDFs (David-supplied; the AP Biology PDF was read directly from `docs/teaching/ap-biology-course-and-exam-description.pdf` via `pdftotext`, which proved far more reliable than the Google Drive `read_file_content` connector for a 240-page document — that connector truncated/reordered text past Unit 6). Calculus AB/BC: no changes from the existing fact pack. Chemistry: same 9 units, weighting, and topic numbering; only unit-title renames (Unit 2, 3, 6, 9) and one topic rename. Biology: real drift in Units 1, 2, 3, 4, 5, and 7 — topic counts changed (e.g. Unit 1 macromolecules split into 4 per-molecule topics, Unit 2 renamed "Cells" with 2 topics merged, Unit 3's "Fitness" topic dropped, Unit 7's "Extinction" topic dropped) while Units 6 and 8 are unchanged. Wrote a new "AP Biology 2026-27 — CED Fact Pack (v2, primary source Fall 2025, use this one)" to the shared Drive folder, content verified read back. Found incidentally: AP Biology's publish-gap memory (dated 2026-07-03/07-13, "0 published") is now stale — status breakdown is `draft: 109, published: 112, reviewed_approved: 22, assigned: 11` (254 total); not root-caused which session published them.

**2. Reviewer tagging-gap root cause found and fixed.** `content_review_decisions.topic_selections` was `{}` on every single row — the field is fully wired end-to-end (schema, server function, edge function) but the actual tutor-review form (`src/routes/_authenticated/reviewer.review.$assignmentId.tsx` in the Lovable-managed frontend, project `d334fed9-5a97-4e76-906e-7c0ad7082212`) hardcoded `topic_selections: {}` at the submit call site with no state variable or UI control ever built for it. Had Lovable's agent add a `topicSelection` state + unit/topic picker sourced from `src/data/taxonomy.ts`, persisted via `reviewer-draft.ts`, required-before-submit (commit `a7fb7aa8`). Also found and fixed that `taxonomy.ts`'s `AP_BIOLOGY_UNITS`/`PLACEHOLDER_SUBTOPICS` were stale relative to the new CED fact pack from item 1 above; updated to match (commit `9db07ba9`). This only prevents the gap from growing — the 254 existing `apbio-*` items (and other subjects) remain untagged; no backfill was requested or done.

**3. Fixed a second, distinct data-realism bug in the 9 `scatterplot_regression_context` items** (7 `APSTATS-HDG-2026-GRAPH-*`, 2 `APBIO-HDG-2026-GRAPH-*`) that were rebuilt in the 2026-07-22 entry above for an unrealistic-|r| complaint. Jill flagged that the "new" data in the most recent trend-line questions she reviewed (e.g. `GRAPH-011`) showed residuals alternating above/below the trend line in lockstep — a real regression-diagnostic red flag, not a cosmetic complaint. Verified quantitatively: recomputed residuals for all 9 items (sorted by the independent variable) and found 7-8 of 8 possible sign flips in every single one (random data averages ~4/8) — the 2026-07-22 fix corrected `|r|` but introduced a deterministic alternating-offset artifact instead of real noise while doing so. Confirmed the bug is fully scoped to this archetype (7 of 40 Stats HDG items, 2 of 12 Bio HDG items — every other archetype lacks paired regression data so structurally can't have this bug); 5 of the 7 Stats items were already `published` and live to students. Regenerated all 9 datasets with genuine `numpy` random noise (bisection-tuned to preserve each item's original `|r|`, direction, and value range so no rubric criterion needed to change — all 9 items' criteria are qualitative, e.g. "describes strong negative roughly linear association," with no numeric answer keys tied to specific data values), rejecting any candidate whose residual-sign flip ratio fell outside 25-72% (a plausible-random band). Wrote the corrected data to all 3 storage locations (`content_item_versions.stimulus`, `prompt_json.stimulus`/`stimulus_table`, and `prompt_json.parts[0].prompt_text` for the Stats items) and reopened the 2 Biology assignments that had a locked `submitted` decision back to `pending` (the Stats items were already `pending` from the prior fix's reopening — that's how Jill was reviewing them when she found this). Also noted, not fixed: 3 of the published Stats items (`GRAPH-032`, `-034`, `-035`) have **no review assignment at all** despite being live — a separate, pre-existing gap consistent with the known publication-trust bug already in memory.

Added a permanent guardrail to `docs/architecture/CONTENT_AUTHORING_AND_PROMPT_ARCHITECTURE.md` §9 (FRQ Package Contract): synthetic scatterplot/regression datasets now require Jill's exact wording ("residuals should be randomly scattered around zero with no visible pattern...") in authoring instructions **plus** an automated post-generation check (reject if residual-sign alternation exceeds ~70% of transitions) — the instruction alone was judged insufficient since natural-language "don't have a pattern" guidance is a weak guardrail against an LLM (or human) still producing a subtly patterned sequence.

**4. Onboarded new Biology tutor Adil Abbasi** (`adilmanzoor2434@gmail.com` — already existed as a `tutor`-role user, no invite needed) with a 20-item review queue (10 MCQ, 10 FRQ) at David's request, all fully overlapping items Amjad Ali (the existing primary Bio tutor) had already reviewed, sharing Amjad's existing `blind_group_id` per item so the two reviewers' decisions can be directly compared once Adil submits.

**Files/systems changed:** Production DB (`pcntajvbdfqhbeewmdry`) — 9 `content_item_versions` rows' `stimulus`/`prompt_json` (scatterplot fix); 2 `content_review_assignments` rows reopened to `pending` (Bio scatterplot items); 20 new `content_review_assignments` rows for Adil Abbasi. Lovable project `d334fed9-5a97-4e76-906e-7c0ad7082212` — `reviewer.review.$assignmentId.tsx`, `reviewer-draft.ts`, `content-schema.ts` (topic picker, commit `a7fb7aa8`), `taxonomy.ts` (commit `9db07ba9`). Google Drive — new AP Biology CED fact pack v2. `docs/architecture/CONTENT_AUTHORING_AND_PROMPT_ARCHITECTURE.md` — new synthetic-dataset-realism guardrail.

**Next Owner:** Jill Schmidlkofer (re-review the corrected scatterplot items), Adil Abbasi (first review queue), David Bloom.
**Next Required Action:** decide whether to backfill topic tags on existing content (not done, out of scope for item 2 above); decide whether/how to fix `GRAPH-032`/`-034`/`-035`'s missing review assignments; complete Chemistry/Calculus corpus scope-check against the new fact packs if desired (not attempted this session, out of scope for what was asked).

---

## CED Verification and Physics Content Review — Session Handoff - 2026-07-24

**Task:** No formal TASK-XXXX yet — an outgrowth of the AP Statistics content-quality review, extended per David's instruction to build a primary-source "CED Fact Pack" per subject and check existing content against it. Priority given: physics, then calculus, then chemistry (biology added later).
**Status:** Physics (all 4 courses) and Precalculus fully verified against primary-source CED PDFs and current. Calculus AB/BC, Chemistry, and Biology still need the same treatment — blocked this session by a Google Drive MCP connector that returned `MCP error -32003: MCP tool call requires approval` on every call, even after multiple reconnects. David is ending this session over the connector issue and starting a new one.

**Full detail, reusable verification method, exact Drive doc titles/IDs, unmatched PDF links, and open engineering bugs are in `docs/reviewer_packets/CED_VERIFICATION_STATUS_2026_07_24.md` — read that file in full before picking this back up.**

**Summary of what's done:** AP Physics 1, Physics 2, Physics C: Mechanics, and Physics C: E&M CEDs were all found to have been substantially restructured for 2024-25 (verified against David-supplied Fall 2024/© 2026 primary-source PDFs, not web search). Notably: Fluids moved from Physics 2 to Physics 1 (added as new Physics 1 Unit 8); Physics 1's unit structure was rewritten to closely mirror Physics C: Mechanics; neither Physics 1 nor Physics C: Mechanics has a standalone "Gravitation" unit anymore (orbital content lives under Unit 6, Topic 6.6); Physics C: E&M and Physics 2 were both renumbered. AP Precalculus got its first-ever fact pack (new subject, Fall 2026 edition, notably Unit 4 is taught but not assessed on the AP Exam). A scope check on the `apphy1-*` corpus found no items needed correction for the restructuring itself, but found two thin/uncovered areas relative to the new CED (orbital mechanics, and fluids density/buoyancy); 8 new content items were authored to close those gaps and assigned to reviewer Muhammad Saood. Four reviewer briefing packets for Saood were written and merged via PR #48.

**Two engineering bugs surfaced but not fixed** (need an engineering session): `prevent_review_decision_mutation` trigger references the wrong PK column (`old.id` vs actual `content_review_decision_id`); `lock_content_review_submission` trigger blocks inserting a superseding decision against any assignment that already has one, even a broken one. Recommend one ticket covering both, bundled with the earlier `GRAPH-009`/`MCQ-078` assignment-locking issue.

**Also outstanding:** several superseded/placeholder Google Drive fact-pack docs need manual deletion by David — no Drive delete tool is available to Claude. Full list in the linked status doc.

**Next Owner:** whichever session picks this up next — start by reading `docs/reviewer_packets/CED_VERIFICATION_STATUS_2026_07_24.md` in full.

---

## Shipped review-decision Atomic-Lock Fix; Fixed Unrealistic Scatterplot Correlations Flagged by Jill - 2026-07-22

**Task:** Two related pieces of live-Production work in one session.

**Status:** Both done and deployed/applied.

**1. `review-decision` edge function — deployed the atomic submission
lock + rebuilt MCQ answer-approval flow.** Discovered the previously
committed `a24d523` fix (atomic lock trigger + MCQ per-choice
`answer_approvals`) was written on a stale fork of this file that predates
the categorical-scoring rewrite (`bf70d0b`/`a6bee10`) actually live in
Production — deploying it as-is would have silently reverted Production's
live `tutor_decision`/`difficulty_action` model and its reader-approval →
`tutor_answer` fan-out flow. Also found the deployed fan-out itself was
broken: it tried to insert 4 assignment rows per tutor (one per MCQ choice)
against an `upsert` `onConflict` target that has no matching unique
constraint on `content_review_assignments` — meaning MCQ answer-choice
review has likely never worked end-to-end in Production.

Fix actually shipped: applied the `content_review_submission_lock` DB
trigger (atomic, base-independent) unchanged, then rebuilt the MCQ
answer-approval logic against the real deployed baseline — one
`tutor_answer` assignment per tutor (not per choice), with the eventual
decision required to cover every answer choice in a single bundled
submission (`answer_approvals: [{choice_key, approved}, ...]`, validated
exactly against `mcq_choices`, note required unless every choice is
approved). This is also the only workable design under the new lock
trigger, since it locks an assignment after its first decision — a
choice-at-a-time submission model can't work once locking is atomic.

Made two deployment mistakes correcting this (a placeholder file, then a
mismatched cors/auth pair) before landing the correct version — both
self-caught and fixed within the same session; confirmed via live
smoke test and `get_logs` that 0 real decisions were lost (the crashes
happened before the DB write, so failed = no-op, not corruption).

**2. Fixed the exact unrealistic-scatterplot-data flaw Jill has been
flagging since 2026-07-16.** Jill raised this again today, more
comprehensively, after independently spot-checking 3 items (r = .997,
.997, -.9955). Verified this quantitatively rather than taking it on
faith: computed Pearson r directly against Production for the full
`APSTATS-HDG-2026-GRAPH-*` `scatterplot_regression_context` archetype (7
of the 40 hand-drawn-graph items) — all 7 had |r| between 0.987 and 0.9986,
confirming this is systemic to the archetype, not just the 3 items Jill
happened to check. Cross-referenced her actual `content_review_decisions`
notes: she flagged `GRAPH-005` on 2026-07-16 and again 2026-07-21, and
`GRAPH-033`/`GRAPH-036` today, with precise numeric suggestions
(hours-studied 0–5 with repeats, quiz scores in the 60s–90s, r around
-.75/-.80 for the irrigation item) — this flaw sat live on published,
student-facing content for 6 days. The 2026-07-20 entry above already
identified `GRAPH-005` as unrealistic and did a partial wording fix
(quiz→test relabel) but explicitly left the underlying data-realism issue
as a carried-forward gap — that gap is now closed, for all 7 items, not
just 005.

Rebuilt each of the 7 items' datasets (`GRAPH-005`, `-011`, `-032`, `-033`,
`-034`, `-035`, `-036`) with realistic scatter (|r| ≈ 0.77–0.83, matching
Jill's own suggested range), preserving each item's context, units, and
association direction so no rubric criterion (trend-line direction,
association-strength wording) needed to change. For `GRAPH-005`
specifically, followed Jill's exact spec: hours studied 0–5 with repeated
values, quiz scores in the 60s–90s range. Also fixed a markdown-table
rendering bug found while doing this: items `-032` through `-036` had all
their data rows collapsed onto a single line (missing row breaks) instead
of one row per pair like `-005`/`-011` — same underlying template bug,
fixed as part of the same edit. Updated all 4 places each item stores this
text/data consistently (`content_item_versions.stimulus`,
`prompt_json.stimulus`, `prompt_json.parts[0].prompt_text`,
`prompt_json.stimulus_table`).

Reopened the 3 assignments that already had a locked decision (`GRAPH-005`,
`-033`, `-036`, all Jill) back to `pending` so she reviews the corrected
version fresh, rather than trusting the fix as final. The other 4 items had
no decision recorded yet, so nothing to reopen there.

**Not done / flagged, not fixed:** `docs/research/benchmark_corpus_2026_07_06/statistics_hand_drawn_05/corpus.jsonl`
references `GRAPH-005` as its `source_item_id` and still describes the old
data (quiz-score wording, old point positions) — a downstream
grading-harness benchmark sample, not live student content. Left as-is;
worth a separate pass if that benchmark corpus needs to stay in sync with
live content.

**3. Same flaw confirmed in AP Biology — 2 items fixed, 10 more items with
a separate related bug flagged, not fixed.** David asked whether the
correlation pattern extends to other subjects. Checked every subject for
the same structured `stimulus_table` hand-drawn-graph format: only Biology
also uses it (12 items, same 6 archetypes as Statistics — same generation
pipeline). Of those, 2 use `scatterplot_regression_context`:
`APBIO-HDG-2026-GRAPH-009` (enzyme reaction rate vs. substrate
concentration, r=0.999) and `-010` (rabbit population vs. forage biomass,
r=0.993) — same bug, confirmed quantitatively the same way as the
Statistics items. Neither was published (`010` was `assigned`, never
shipped; `009` was `reviewed_disapproved`).

Fixed both with the same realistic-scatter approach (r=0.849, r=0.817),
keeping `009`'s substrate-concentration range in the sub-saturation region
where real Michaelis-Menten enzyme kinetics is genuinely near-linear,
rather than just adding noise to an implausible full-range enzyme curve.

While fixing these, found `009`'s actual `content_review_assignments`
history: Amjad disapproved it on 2026-07-17 for "missing the data values
needed to make the graph" — and confirmed why: **all 12** Biology HDG
items have `content_item_versions.stimulus` (the column the reviewer UI
actually reads) `NULL`, even though the data exists in `prompt_json`. This
is a separate, broader population bug from the correlation issue — it
means none of the 12 Biology hand-drawn-graph items have ever been
properly reviewable. Fixed it for `009`/`010` as part of the same update
(populated `stimulus` with the corrected text+table). The other 10 items
still have this bug — not fixed here, out of scope for what was asked, but
worth a dedicated pass since it's blocking review entirely, not just a data
quality issue.

Reopened `009`'s assignment (Amjad) and reset its `content_item_versions`/
`content_items` status from `reviewed_disapproved` back to `assigned` so it
re-enters his queue with the fix in place, rather than staying rejected for
a problem that's now resolved.

**Files/systems changed (addendum):** Production DB — 2 more
`content_item_versions` rows (`APBIO-HDG-2026-GRAPH-009`, `-010`) —
`stimulus`, `prompt_json.stimulus`, `prompt_json.stimulus_table`; 1
`content_review_assignments` row reopened to `pending`; `009`'s item/version
status reset from `reviewed_disapproved` to `assigned`.

**Next Required Action (addendum):** decide whether to fix the missing-
`stimulus` bug on the other 10 Biology HDG items now or as a separate task —
they're all currently unreviewable by design (empty stimulus in the
reviewer UI), independent of any data-realism concerns.

**Verification performed:** independently computed Pearson r for all 7
original datasets and all 7 replacement datasets before touching
Production; confirmed the replacement update landed correctly by
re-querying `content_item_versions.stimulus` after the migration; confirmed
`review-decision` v15 boots cleanly (`OPTIONS` → 200, unauthenticated
`POST` → 401, zero errors in `get_logs`) and that zero decisions were
written to the DB during the ~2-minute mistake window.

**Files/systems changed:** Production DB (`pcntajvbdfqhbeewmdry`) —
`content_review_submission_lock` trigger (new); `review-decision` edge
function (v15); 7 `content_item_versions` rows' `stimulus`/`prompt_json`
for the `APSTATS-HDG-2026-GRAPH-*` scatterplot items; 3
`content_review_assignments` rows reopened to `pending`.

**Next Owner:** Jill Schmidlkofer (re-review the 3 reopened items),
David Bloom
**Next Required Action:** confirm the corrected `GRAPH-005`/`-033`/`-036`
data reads as realistic; separately, this same generation flaw may extend
to other archetypes/subjects seeded by the same pipeline — worth a broader
sweep, not done here (scope was exactly what Jill flagged).

---

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

## Phase A Broken-Import Fix and Deterministic-Layer-Only Ship Decision - 2026-07-12

**Task:** TASK-0016, Phase A. Corrects the previous entry below.
**Status:** Fixed on `claude/cramapple-grading-mlr0o1` (commit `62758c9`),
pushed to PR #37. Still not merged to `main`, still no production deploy at
the time of this entry.

**Summary:** David asked to land Phase A wiring live for tutors to see it in
action without waiting for the tutor-approval gate, shipping today's
single-call LLM grader plus the deterministic layer only (explicitly not the
SP-1 misattribution audit or `C2Direct-Low` routing). Before deploying,
found that the `evaluate-attempt/index.ts` landed in the prior entry
(sourced from upstream commit `8f79ebe`) imports four modules —
`evaluate-attempt-response.ts`, `grading-feedback.ts`,
`statistics-verifier.ts`, `verification-profiles.ts` — that do not exist on
any branch in the repository's history, **including `8f79ebe`'s own source
branch at any commit**. That code would fail to load in Deno at all; it was
never actually runnable upstream, not just unmerged. The prior entry's claim
that the file was verified "byte-identical to `8f79ebe`'s target" was true
but insufficient — byte-identical to a target that itself doesn't resolve is
not a working verification.

Did not attempt to fabricate the four missing modules. Instead rewrote the
integration from the pre-Phase-A `evaluate-attempt/index.ts` by hand:
`resolveGradingRoute` (self-contained, verified) picks a route from
`rubric_type`/`evaluator_strategy` (now selected from `content_item_versions`)
or falls back to legacy `item_type`; when the route is `symbolic_ecf` and the
item's `content_key` matches a seeded entry in `math-verifier.ts`'s
`STATISTICS_ITEM_KEYS` lookup with populated `ecf_parts`, `buildEcfResult`
grades it deterministically (`model_id: "deterministic-symbolic-ecf"`,
`deterministic_verifier_version` recorded) and the LLM call and budget
reservation are both skipped. Every other case — including every currently
published AP Biology item, since none are in that lookup — falls through to
the existing single-call LLM grader completely unchanged. Deliberately did
not wire `formula-notation.ts`'s ambiguous-text/action-hint/repair-hint
helpers or populate the `feedback_preview`/`action_hint`/`repair_hint`
columns added by the prior entry's migrations — those need the still-missing
feedback-formatting layer; left null rather than fabricated.

Verified: only `grading-router.ts`, `math-verifier.ts`, and
`formula-notation.ts` are imported, and grepped the full `supabase/functions/`
tree to confirm zero remaining references to any of the four missing
modules. Brace-balance checked (no Deno available in this environment, so
this is not a substitute for `deno check`/`deno test`, which is still
outstanding).

**Decision, recorded per David's instruction:** ship Phase A (deterministic
layer + existing single-call grader) to Production ahead of the formal AP
Biology tutor-review gate (`NOW-004`) and `TASK-0010` approval, specifically
so tutors can observe it live and drive iteration from real behavior rather
than reviewing it statically first. This is a scoped exception for tutor
visibility, not a decision to open automated FRQ scores to students broadly
— `TASK-0010`/`NOW-013`'s gate on learner-facing automated scores is
unchanged and still open.

**Next Owner:** David Bloom / Main Conductor
**Next Required Action:** Merge PR #37, apply the pending migrations to
`Cramapple-Production` (`pcntajvbdfqhbeewmdry`), and redeploy
`evaluate-attempt`. Run `deno check`/`deno test` in an environment with Deno
before or immediately after deploy, since that verification is still
outstanding.

---

## TASK-0016 Phase A Grading-Router Reconciled Onto Grading Branch - 2026-07-12

**Task:** TASK-0016 (Grading Engine Rollout), Phase A
**Status:** Landed on `claude/cramapple-grading-mlr0o1` (pushed, draft PR
opened). Not on `main`. No production deploy, no approval requested yet —
mechanical reconciliation only.

**Summary:** At David's request to move grading toward production wired to
the Lovable frontend, first step was reconciling TASK-0016's Phase A
deterministic/symbolic grading-router work — previously stranded on
`origin/codex/task0016-phase-c-base` and never merged — onto this branch's
current, post-backend-consolidation `main` lineage. A straight cherry-pick of
commits `8f79ebe`/`98dc544` produced false conflicts because their branch
lineage also carries unrelated, unwanted Lovable runtime-context commits
(`44687a4`, `3b61a41`) earlier in its history. Resolved by diffing each
commit directly against the actual merge-base (`4a179e0`, confirmed identical
to this branch's pre-change `evaluate-attempt/index.ts` and `_shared/`) and
applying that diff instead, then cherry-picking `98dc544` (R1/R2 remediation)
on top, which applied cleanly since its parent is `8f79ebe` exactly.

Added `supabase/functions/_shared/{grading-router,math-verifier,
formula-notation}.ts` (+ tests) and wired them into `evaluate-attempt`, plus
6 migrations (deterministic verifier pins, rubric-routing columns +
backfill, feedback/action/repair hint columns on `grading_results`).
Verified the reconstructed `evaluate-attempt/index.ts` is byte-identical to
`8f79ebe`'s target before layering the remediation commit.

**Found and fixed during reconciliation, not carried over from any branch:**
the curated `public.grading_results` view (`202607090001_curated_public_
interface.sql`, applied 2026-07-09, one day after Phase A's migrations but
before Phase A was ever reconciled onto this history) lists `grading_results`
columns explicitly and was missing all 5 of Phase A's new columns
(`feedback_preview`, `action_hint`, `repair_hint`,
`deterministic_verifier_version`, `boundary_contract_version`). Since Lovable
reads through `public.grading_results`, not `app.grading_results` directly,
this would have silently hidden Phase A's feedback/repair output from the
frontend even after Phase A landed. Added
`202607120001_grading_results_view_phase_a_columns.sql` to recreate the view
with those columns included.

**Deliberately left out of this reconciliation** (present on
`codex/task0016-phase-c-base` but out of scope for landing the grading
router): AP Chemistry/Physics launch scaffolding, AP Statistics content-sync
commits, review-queue admin-scope changes, the Lovable runtime-context/
student-memory wiring, and the small `25da9ea` `review-queue` `frq_form`
fix. None of these are prerequisites for Phase A; pulling them in would have
reintroduced the large unrelated diff surface this step was meant to avoid.

**Not done in this step:** Phase C (AP Statistics deterministic-layer +
content publish) — its QA verdict is `FAIL`
(`ap_statistics_phase_c_publish_staging_2026_07_11/qa_review.md` on
`codex/task0016-phase-c-content-publish-approval-main`) with remediation
claimed but never re-verified; not pulled in here. No SP-1 quality-research
findings (misattribution audit, `C2Direct-Low` routing) are wired in — those
were never wired into `evaluate-attempt` on any branch, including this one.
Migrations have not been applied to any live Supabase project; `deno check`/
tests have not been run (no `deno` available in this environment) — TypeScript
correctness has only been verified by exact diff match against the source
commit's target, not by compiling.

**Next Owner:** David Bloom / Main Conductor
**Next Required Action:** Decide the quality bar for what ships first (per
prior session discussion: deterministic layer alone vs. also wiring the
misattribution audit before merge to `main`), get the outstanding Phase A
reviewer sign-off confirmed, and run `deno check`/tests against these files
in an environment with Deno before treating Phase A as merge-ready.

---

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
