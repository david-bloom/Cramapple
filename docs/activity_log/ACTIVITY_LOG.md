# Activity Log

This log records meaningful operating activity, approvals, closeouts, blockers, and handoffs. Newest entries are at the top.

## Index

Most recent entries (full reverse-chronological list follows below):

- AP Physics C (Mechanics and E&M) Units 1-3 Pipeline (APPROVAL-0108 to 0113) (2026-10-04): 41 seeds repaired or cleaned and topic-tagged, 104 variants published (43 + 61), two skill grids built, 141 skill cells written. Mechanics MCQs 41 to 84, E&M 48 to 109. All AP subjects now have the Units 1-3 pipeline applied.
- AP Physics 2 Units 9-11 Pipeline (APPROVAL-0105 to 0107) (2026-10-03): 18 seeds repaired or cleaned and topic-tagged, 50 variants published, skill grid built, 68 skill cells written; Physics 2 MCQs 40 to 90.
- Calculus BC Units 1-3 Finished (APPROVAL-0104) (2026-10-03): BC skill grid built; 263 skill cells copied from the AB twins, 16 native topics and 23 skill cells voted; 286 of 294 BC Units 1-3 MCQs now have topic and skill.
- Units 1-3 Skill and Topic Cleanup, Biology 025-v3, MCQ-005 Retired (APPROVAL-0098 to 0103) (2026-10-03): two stale labels re-issued; Biology `025-v3` restored; Physics 1 and Precalculus skill grids built; 679 + 66 skill cells and 36 topic cells written; `apcalcab-mcq-005` and its 5 variants retired. See the entry below.
- AP Biology: Last 4 Orphan Items Retired (APPROVAL-0096) (2026-10-03): `APBIO-FRQ-L-028`, `APBIO-MCQ-012` (test attempts only, per the Product Owner), `APBIO-FRQ-L-038` and `APBIO-FRQ-L-041` (latest version retired) set to `retired`; every published Biology item now has a published version (132 of 132); Biology published items 136 to 132.
- AP Biology: 38 Items With All Versions Retired Now Marked Retired (APPROVAL-0095) (2026-10-03): 38 of the 42 Biology items that were marked published with no published version (17 FRQ, 21 MCQ) set to `retired` at item level; no student-visible change (the selector already required a published version). Biology published items 174 to 136. Four left for a decision: `APBIO-FRQ-L-028` and `APBIO-MCQ-012` (attempts), `APBIO-FRQ-L-038` and `APBIO-FRQ-L-041` (unretired `reviewed_approved` v1).
- AP Biology: 3 More Items Retired (APPROVAL-0092) and DECISION-0095 Recorded (2026-10-03): `APBIO-MCQ-014` (70S/80S ribosomes), `063` (signal sequence) and `025` (kidney ADH outside the pack) retired, zero attempts; Biology published items 177 to 174. `DECISION-0095` records the rule that items stay within the CED vocabulary and that breaking items are retired. 42 older Biology items are marked published with no published version (not caused by this change).
- AP Biology: 7 Published Variants With Out-of-CED Terms Retired (APPROVAL-0091) (2026-10-03): a full-text scan of the 24 variants published under `APPROVAL-0080` found 7 using terms the CED does not name (70S/80S ribosomes, receptor-mediated endocytosis, binary fission, high-salt wash); all 7 retired (zero attempts), 17 remain published; Biology published items 184 to 177; validated serving labels unchanged.
- Google Sign-In Removed From Checkout; Post-Pilot Task Opened (TASK-0058) (2026-10-02): at David's direction Lovable removed the "Continue with Google" option from `/checkout` (commit `18666296`, only `checkout.index.tsx`, deletions only, not yet published). Reviewed Chrome's identity guidance against the redirect flow; improvements, layout wishes and Stripe hardening are collected in `docs/tasks/TASK-0058-POST-PILOT-CHECKOUT-AND-SIGN-IN.md`. Google branding/verification is David-owned and prepared there.
- Stripe Live Payment Proven in Production; Refund Round Trip Verified (2026-10-02): David paid \$39.99 with Link on the live checkout, the live webhook processed it, access was granted; a \$10 partial refund kept access (PR #310 fix) and the remaining \$29.99 revoked it. Coupon and new-student paths still untested.
- AP Biology Skill Re-vote (APPROVAL-0081) (2026-10-02): 73 topic-corrected items re-voted by four models; 69 skill cells rewritten (52 validated, 10 provisional, 7 held), 6 skills changed, 54 unchanged; 4 validated cells deliberately kept.
- AP Biology Variants Loaded and Published (APPROVAL-0080) (2026-10-02): 24 variant MCQs loaded in 3 chunks (md5 24 of 24) and published with validated labels (Unit 1: 3, Unit 2: 21).
- AP Biology Topic Correction (APPROVAL-0079) (2026-10-02): 73 primary topic cells replaced by three-family consensus (42 cross-unit), 21 skill cells moved to the new topic, MCQ-005 relabeled to Unit 2; 43 earlier-validated items topic-probed for the first time.
- AP Statistics Variants Published (APPROVAL-0078) (2026-10-02): 131 variants published with validated labels (Unit 1: 63, Unit 2: 33, Unit 3: 35); Statistics published 293, unit-gated servable 261, stale hashes 0; one variant held as a draft.
- AP Statistics Variants Loaded as Drafts; 8 Items Retired (APPROVAL-0077) (2026-10-02): 132 variant MCQs loaded in 12 chunks (md5 132 of 132), not yet published; 8 items on CED-removed topics retired.
- AP Statistics Units 1-3 Pipeline v2: Repairs, Labels, Skill Cells (APPROVAL-0076) (2026-10-02): 4 MCQ rationales repaired as version 2, 8 serving labels validated, 129 skill cells written (116 validated, 1 provisional, 12 held); blind plus audit for 129 items took 7 minutes and $2.56.
- AP Chemistry Variants Loaded and Published; Canonical Answers Filled (APPROVAL-0075) (2026-10-02): 72 variant MCQs loaded in 12 chunks (md5 72 of 72) and published with validated labels; 49 Chemistry MCQ canonical answers filled; Chemistry published 119 to 191, servable 82 to 154; MCQ grading found not to read canonical answers.
- AP Chemistry Units 1-3 Full Pipeline Run (APPROVAL-0074) (2026-10-02): steps 1-7 from scratch in about 86 minutes, 2,040 gateway calls, $7.55 gateway list price, about 0.9M Claude tokens; 8 seeds repaired, 36 topic cells, 28-skill grid, 37 labels, 34 skill cells, 75 variant drafts (not loaded); audit recall gap and missing seed CED check found.
- AP Biology Grid Created and 70 Live Items Relabeled for Serving (APPROVAL-0073) (2026-10-02): 22 skills x 60 topics = 1320-cell grid from the CED; Bio unit-gated servable 43 to 110 of 118; registered topic cells found wrong on about 58 items (36 across units), left unchanged for a decision; skill labels in progress.
- Cells Validation Check Relaxed in Production for Model-Consensus Labels (APPROVAL-0072, DECISION-0085 Route 1) (2026-10-02): `validated` now needs a human or a `model_run_id` plus a decision id and timestamp; rehearsed and applied as migration `20261002164510`; no rows changed.
- AP Precalculus Variants Published (APPROVAL-0097) (2026-10-03): 143 variants loaded (md5 143 of 143) and published with validated labels (Unit 1: 56, Unit 2: 42, Unit 3: 45); Precalculus published 116 to 259, servable 78 to 221.
- AP Precalculus Units 1-3 Seeds Repaired and Labeled (APPROVAL-0093, 0094) (2026-10-03): 25 rationales corrected on 15 items, duplicated A-D list removed from 22 stems, 34 labels validated, 47 topic cells, 3 defective MCQs fixed, 010 retired; Precalculus servable 53 to 78; 147 variants authored, not loaded.
- AP Calculus BC: 283 AB Units 1-3 Questions Mirrored (APPROVAL-0090) (2026-10-03): copied in-database from the AB pack with validated labels (Unit 1: 118, Unit 2: 83, Unit 3: 82); Calc BC published 130 to 413, servable 45 to 328.
- AP Physics 1: 89 Variants Published, Units 4-8 Stems Cleaned (APPROVAL-0088, 0089) (2026-10-03): 89 variants loaded (md5 89 of 89) and published with validated labels (Unit 1: 12, Unit 2: 36, Unit 3: 41); 21 Units 4-8 stems cleaned; Physics 1 published 113 to 202, servable 83 to 172.
- AP Physics 1: 4 Framework Questions Retired, 32 Stems Cleaned (APPROVAL-0087) (2026-10-03): np1-001/002/003/006 retired; duplicated A-D list removed from 32 published stems (24 relabeled, 8 held); 21 Units 4-8 items have the same defect, not touched.
- AP Physics 1 Units 1-3: 4 Rationales Repaired, Topic Cells Created (APPROVAL-0086) (2026-10-03): 32 topic cells from a three-family consensus, 4 published rationales repaired, 041 released to Unit 3; np1-002 released then returned to held (exam-scoring item); 89 variants authored and checked, not loaded; 4 course-framework questions recommended for retirement.
- Calc AB: 109 New Units 2-3 Questions Authored, Loaded and Published (APPROVAL-0085) (2026-10-03): 28 original seeds (14 Unit 2, 14 Unit 3) and 81 variants, md5 109 of 109, validated labels; Calc AB published 308 to 417, servable 237 to 346; 2 seeds and 6 variants dropped for needing Unit 4-5 content.
- Calc AB Pilot Variants Published (APPROVAL-0084) (2026-10-03): 30 variants loaded (md5 30 of 30), 29 published with validated labels (Unit 2: 14, Unit 3: 15), 1 held; Calc AB published 279 to 308, servable 208 to 237.
- Calc AB Seed Fixes Applied (APPROVAL-0083, originally numbered 0071): `apcalcab-mcq-026` Choice C Replaced, `apcalcab-mcq-028` Units Corrected to [1, 2] (2026-10-02): rehearsed then applied on Production; servable 207 to 208.
- Calc AB Launch-Readiness Pass, Serving-Label Repair (APPROVAL-0082, originally numbered 0069), Units 2-3 Pilot Started (2026-10-02): read-only readiness census, then relabelled 11 of 12 held/stale items on Production (servable 196 to 207); `frq-u13-003` left held; S0a audit of the 12 Unit 2-3 seeds found 0 key defects and 1 weak rationale (`026` C).
- Stripe Functions Tranche 2 Deployed to Production (APPROVAL-0071) (2026-10-02): `stripe-webhook` (partial-refund fix), `create-checkout-session`, `create-post-purchase-addon` and `create-parent-payment-link` deployed and verified (source identical to `main`, 400 probes, no data change, no charge). Production Stripe secrets re-set by David (key/webhook distinct, catalog exact match). Lovable not yet published; Gate D ($1 test) pending.
- Stripe Functions Tranche 1 Deployed to Production (APPROVAL-0070) (2026-10-02): `stripe-webhook` v21, `get-checkout-status` v1 and `send-parent-payment-email` v1 deployed and verified (source identical to `main`, 400/405 probes, no data change, no charge). Tranche 2 and the Lovable publish remain unapproved.
- Stripe Payment Migrations Applied to Production (APPROVAL-0069) (2026-10-02): the three TASK-0041 payment-schema migrations were applied to Production and verified (`stripe_customers`, `parent_payment_email_requests`, webhook replay columns + `claim_stripe_webhook_event`). No function, secret, or Stripe change. Next: deploy the six functions from David's Mac, then live Stripe setup.
- Seeded-Variant Runs: Status by Subject Documented; AP Biology Pilot Closed (2026-10-01): added protocol section 10, a table of which subjects have had a variant run (AP Calculus AB partly, AP Biology Units 1-2) and which still need one (Calculus BC, Chemistry, Physics 1, Physics 2, Physics C E&M, Physics C Mechanics, Precalculus, Statistics), plus a pre-run checklist. The label probe on the final AP Biology text is prepared (`probe_items_final.json`) but needs a run from the Product Owner's laptop.
- AP Biology Seeded-Variant Pilot: Seed Audit, 14 Variants, `APBIO-MCQ-023` Repair Approved (APPROVAL-0067) (2026-10-01): S0a found 7 of 8 Biology seeds clean and 1 defective rationale (`APBIO-MCQ-023` choice A, both models); 14 class-A variants written and content-checked by both models (3 DeepSeek-only wording defects fixed, patched items re-checked clean). The Product Owner approved the one-item Production repair, which was applied and verified.
- Stripe Production Cutover Checklist Drafted; Launch Shape Revised to a $1 Pilot Then 50% Off (2026-10-01): read-only audit found Production is on the August Stripe code (4 of 6 functions missing, `stripe_customers`/`parent_payment_email_requests`/webhook-replay schema missing). Checklist written; `DECISION-0094` supersedes `DECISION-0091`. No Production, Stripe, or secret change.
- Calc AB Repair Approved (APPROVAL-0066): `apcalcab-mcq-037` Key Letter, 10 Distractor-Rationale Repairs, Label Carry-Forward (2026-10-01): the Product Owner approved applying the 037 key-letter fix and the 10 audited distractor-rationale repairs (11 items) to Production, plus carrying their serving labels forward; scripts were tested in a rolled-back Production run first. Applied 2026-10-01; verified.
- Seeded Generation Protocol, 136 + 24 AP Calc AB Items Published, Session Close (2026-09-30): wrote the seeded-item generation protocol, published the Unit 1 batch (136) and 24 seeded variants to Production under the Product Owner's approval (`DECISION-0093`, `APPROVAL-0065`). Keys were never wrong; 10 of 20 audited published seeds have rationale defects and `apcalcab-mcq-037` has a key desync, both handed off as open repairs.
- PR Triage, TASK-0057 Opened, Stale Branches Retired (2026-09-30): triaged the open PRs against live state. The TASK-0056 migrations were already in Production and the revoke was verified (no answer or rubric column readable by `authenticated`/`anon`); #277, #278, #284, #285, #286 were merged. PR #268 (taxonomy `subject_id` link) was closed unmerged because it added the link without moving any join onto it, and its migration was never applied anywhere. The full three-step fix (link, move every join, CI guard) is now `TASK-0057` (post-launch, PR #288), with an initial inventory of eight live Production functions; `get_home_start_queue` reads the taxonomy without the normalizer. Retired four stale branches after checking each against `main`; the only unique work, Codex Work Orders N/N.1 (Biology serving labels, incomplete), was preserved first (PR #290). No code, migration or deploy. **Next Owner:** David Bloom. **Next Action:** none from this thread; TASK-0057 is post-launch.
- TASK-0056 Closed In Production; Launch Shape Set To Coupon Checkout (2026-09-30): answer keys are no longer directly readable by any signed-in or anonymous caller on Dev or Production (`APPROVAL-0063`/`0064`); guard `scripts/qa/answer_key_exposure_guard.sql` returns no rows on both and now runs daily. The first revoke was a silent no-op (table-level grant), and the guard caught it on Dev; fixed with a safe-column grant. `evaluate-attempt` F2 fix live (Prod v70, verified). `DECISION-0091`: Oct 2 is free via `/checkout` with a 100%-off coupon. PRs #284/#285/#286/#277 merged. Handoff: `docs/handoffs/SESSION_CLOSE_2026_09_30_LAUNCH_READINESS_TASK0056.md`. **Next Owner:** David Bloom. **Next Action:** deploy #284 to Dev and complete a $0 test-mode checkout; practice session with Orly; fresh independent QA.
- TASK-0051 Independent QA → BLOCKED; TASK-0056 Opened, Step 1 Audit Done (2026-09-29): independent QA of the Open Hand RPC found the RPC and `evaluate-attempt` sound but **answer keys directly readable by any signed-in user** outside the RPC (`content_item_versions.canonical_answer_1/2`, `explanation`, `item_package_payload`, plus the `public` views) in Dev and Production. TASK-0051 set Blocked (PR #277). David chose launch-gating, explanation after submission only, and the FRQ rubric as a recorded hint (`DECISION-0089`), opening TASK-0056 (PR #278). Step 1 reader audit: only the reviewer fallback screen breaks on the revoke; no student or anonymous path reads a revoked column; Production logs show only service-role reads. No code, migration or deploy. **Next Owner:** David Bloom. **Next Action:** approve step 2 (the reviewer SECURITY DEFINER function on Dev, plus the Lovable `review.functions.ts` edit), then the step 3 migration.
- TASK-0041 Checkout/Login Direction Revised (2026-09-29): anonymous re-QA reproduced `/signup` → `/login` redirect (subject picker targets the app's `/home`, not `/checkout`). Product Owner revised the checkout doc; five answers recorded as `DECISION-0090` (passwordless only, verified-session entry, student-direct-only add-on, first-name-only parent screens, `/signup` → `/checkout`). Found that parent-share checkouts saved the parent's card for off-session reuse and the webhook would attach it to the student; fixed in four edge functions on `claude/task-0041-payment-login-direction` (Dev `stripe_customers` confirmed empty, so no card was ever attached). Dev deploy blocked by the permission classifier — left for David. Lovable prompt drafted, not sent.
- Session Close: Skill Work Captured Off A Stranded Branch; Migration Ledger Gap Found (2026-09-29): end-of-session capture after the MCQ feedback deploy. The skill-dimension work (~13,500 lines) was sitting on an unmerged branch **while its effects were already live in Production** — now PR #272. Recovering it exposed that TASK-0050 applied five migrations to Production of which **four had no file in the repository at all**, and the fifth was a stub whose timestamp (`20260929113000`) did not match the recorded version (`20260929110501`), so the next `supabase db push` would have re-applied it. All five recovered verbatim from `supabase_migrations.schema_migrations`, byte counts matching the recorded lengths. A wider count then showed the problem is systemic: **185 migrations applied to Production since 2026-09-01 against 113 files in the repo — at least 72 exist only in Production**, so the schema cannot be rebuilt from source. Opened `TASK-0055` rather than fixing 72 migrations at session end. Root cause: `apply_migration` records a server-assigned version and writes no local file, and nothing in CI catches the divergence. Handoff: `docs/handoffs/SESSION_CLOSE_2026_09_29_MCQ_FEEDBACK_AND_SKILL_WORK.md`, with the ordered execution plan (commands, preconditions, rollback, traps, open decisions) in `docs/handoffs/RESOLUTION_RUNBOOK_2026_09_29.md`. **Next Owner:** David Bloom. **Next Action:** merge PR #272; run `scripts/student_grade_smoke.mjs` before test students; then Open Hand (TASK-0051/0052).
- MCQ Feedback Rebuilt From The Chosen Distractor; Deployed To Production (2026-09-29): every wrong MCQ answer had returned one fixed string on every item in every subject — "Select the answer choice that matches the published correct answer" — while the item's own authored distractor rationales sat unread two variables away in `mcqChoices`. **34 of the 63** recorded `highest_value_gap` rows were that placeholder, across **19 items carrying 76 unused rationales**. Rebuilt as three moves (orient by skill/unit, point at the chosen distractor's authored rationale, close on a question), with the shape rotating across four variants by an FNV-1a hash of item × chosen key so a twenty-question session does not read as one template — David, 2026-09-29: feedback should mix "tell" and "ask" and be "loose enough that it doesn't feel overly formulaic". The correct choice's rationale is never read. **The scope finding is that this was never blocked on content:** all **2,349** published distractors across all ten subjects already carry an authored rationale, zero gaps, so coverage is 100% at deploy with no authoring and no model spend (`TASK-0053`, PR #264/#265). Three self-corrections en route, all published: a skill-coverage figure of 406 that was really **304** (PR #266 — `content_item_cells.skill_code` is nullable, so `exists(...)` counted topic-only tags as skill tags); the reason given for that nullability, which I called schema drift when migration `20260927004500` had made topic-only tagging deliberate **and had already guarded the MATCH SIMPLE hazard I reported as a discovery** (PR #267); and two of the three "traps" I proposed fixing turning out not to be defects at all — the third, the hyphen/underscore subject-key split, is real (`replace('_','-')` silently drops Biology) and is parked as draft PR #268 with no current consumer. **Deployed to Development then Production (v67) on explicit per-action authorization.** `TASK-0054` opened for the reference-content model: `topic_explainers` and `topic_point_briefs` were authored as markdown, key the taxonomy as plain text with no FK, and carry **no skill reference at all**. **Next Owner:** David Bloom. **Next Action:** run `scripts/student_grade_smoke.mjs` (PR #270, unmerged) against Production immediately before handing the app to test students — the brand-new-student submit-to-grade path has still never been exercised end to end.
- Skill-Dimension Rollout Planned and Measured; Open Hand's Two Competing Implementations Resolved (2026-09-29): Two strands, no Production writes and no AI-Gateway spend in either. **Skill dimension (TASK-0050, `DECISION-0085`, `APPROVAL-0060`, PRs #258/#259, both merged):** corrected the rollout plan against the live `content_item_cells` schema — a 2026-09-27 migration the first draft predated had already added the whole `assignment_status`/`validated_by` governance apparatus, made `skill_code` nullable (so the composite FK no longer catches an *unassigned* skill, only a hallucinated one), and added a one-primary-per-version index that would break a naive Phase B insert. Then ran a feasibility measurement across all ten subjects: **MCQ inventory, not the skill dimension, is the binding constraint on `DECISION-0074` mastery — the ceiling is `floor(published_MCQ / 2)` and is independent of grid size**, so the rollout delivers schema parity but is not the mastery unlock. AP Statistics' 203 existing skill-coded rows turned out to be stranded on retired pilot pack `7c5a2975` (203 MCQ, **0 FRQ**, 0 servable items), so GAP-10's measured zero is a pack/content gap before it is a labeling gap. David then set the labeling roster (proposers `openai/gpt-5.5` + `gemini-2.5-pro`, blind adjudicator `claude-opus-5`) and ruled that `validated` is earned by ≥2-of-3 model consensus with no human review pass — recorded as extending `DECISION-0066` rather than reversing `DECISION-0079`. One open Hard Gate: `content_item_cells_validation_check` requires a human `validated_by`, so a model-consensus `validated` is rejected by the database today. **Open Hand (TASK-0051, `DECISION-0086`, `APPROVAL-0061`):** the feature had been built twice by agents that could not see each other's work — one branch was local-only until this session pushed it. PR #256 served answer keys and recorded nothing; `codex/task-0049-open-hand-answer-key` recorded a scoring exclusion and refused to score the item afterwards. Verification established there is **no student-facing exposure today** (the deployed `open-hand-item` has no caller; the Open Hand screens are demo-only and make no network call; Production has no such function), so this is a latent gap in unwired work that becomes real the moment the plate loop is wired to live data — hence TASK-0052 for that wiring. David chose entitlement-scoped access with a mandatory exclusion write (staff/QA exempt), unified on the RPC. An independent Fable review then falsified a claim this session had propagated into three documents: **there is no `evaluate-attempt` bundle blocker** — the 200,000-byte limit belongs to the Supabase MCP deploy tool, not the platform, and the function was deployed to Production via the CLI on 2026-09-27. The same review found that the RPC, not the edge function, is the real security boundary (it is granted to `authenticated`), and that looping the single-item RPC across `open-hand-item`'s list response would have excluded ~20 items per screen load — enough to burn AP Biology's entire 43-item MCQ pool in two loads. **Next Owner:** David Bloom. **Next Action:** TASK-0051 execution to the Development boundary, then the Production Hard Gate; separately, decide the `validated_by` route for `DECISION-0085`.
- TASK-0039 BYOQ Live in Production, Phases 1–2 (2026-09-28): Claude built and shipped bring-your-own-question end to end under `APPROVAL-0058`/`DECISION-0084`. The work covers parallel `byoq_*` tables with no answer-bearing column (enforced by a CHECK), the `byoq` edge function (anonymous owner keys plus recognized students, the answer-leak gate, unscored responses, phone/QR capture with metadata-stripped photos), 30-day anonymous retention on pg_cron, and the App screens at `app.cramapple.com/byoq` with a homepage link on `cramapple.com`. Independent QA returned Fail on the first round (unswept raw uploads, unscheduled purge, spoofable IP rate limit, title/source-note answer leak); all four were fixed and re-verified on Dev (24/24 live smoke checks) before Production. A Production round trip passed and was cleaned up. Phase 3 (worksheet upload) remains blocked on `BYOQ_WORKSHEET_PARSING_DESIGN.md`. **Next Owner:** David. **Next Action:** confirm or revise the eight launch defaults in `DECISION-0084`, and do a real-phone QR test on `app.cramapple.com/byoq`.
- Oct 2 Launch Audit, TASK-0049 File Collision Resolved + Cold-Start Test Added, TASK-0039 BYOQ
  Status Checked (2026-09-28): ran a read-only Oct 2 launch-readiness audit (headline finding: the
  runbook's own brand-new-student submit-to-grade smoke test has never been run against the live
  app — still the top open risk). Then fixed the two issues it flagged, PR #251
  (`claude/task-0049-dedup-and-cold-start-test`, draft, CI green): annotated (not renamed)
  `TASK-0049-CLAUDE-INDEPENDENT-AUDIT-2026-09-28.md` in place, per `DECISION-0075`'s
  annotate-in-place convention, since a same-day Production migration and an active Codex prompt
  already cite that exact filename as their evidence trail; added a reciprocal pointer and refreshed
  status/baseline fields in the real `TASK-0049-BIOLOGY-STATISTICS-SIX-CRITERION-REMEDIATION.md`,
  which were themselves stale (Phase 1 already promoted 100 items to Production the same day).
  Added `supabase/functions/start-trial/index_test.ts` — previously zero coverage of the entrypoint
  a brand-new student calls for the free-trial entitlement `authorize_grading_access` checks at
  submit time — via a `handleStartTrial(req, deps)` seam matching `attempt-response`'s pattern;
  wired into `minimal-ci.yml`, diagnosed and fixed a resulting `--allow-env` CI failure, green as of
  `9f50cab`. Explicitly not a substitute for the live smoke test above. Separately checked TASK-0039
  (BYOQ) status on request: confirmed zero backend exists (no migrations, no edge function — grep
  and full git-history search both confirm every BYOQ commit is docs or the non-production `web/`
  prototype), and flagged that the launch-readiness index's "~2-4 hrs remaining" estimate
  materially understates TASK-0039's own multi-day Hard-Gate scope (camera/QR capture is
  launch-required per `DECISION-0076`). No Production reads or writes this session. Session handoff:
  `docs/handoffs/SESSION_CLOSE_2026_09_28_LAUNCH_AUDIT_TASK0049_DEDUP_BYOQ_CHECK.md`. **Next Owner:**
  David Bloom. **Next Action:** review/merge PR #251; decide BYOQ's Oct 2 scope (descope vs.
  compressed build).
- TASK-0046 Verification Session Closed; TASK-0049 Created (2026-09-28): confirmed TASK-0042 Done, ran read-only Production six-criterion verification across all 10 subjects, and produced subject-slice evidence/PRs pending fresh independent QA. AP Biology currently has 23/118 current-fresh validated serving labels and four hand-drawn FRQs without canonicals (all structurally excluded from ordinary/unit-gated serving); AP Statistics has 67/170 current-fresh validated serving labels with canonical/rubric/choice/difficulty coverage otherwise clean. David requested a dedicated follow-up to close these six-criterion gaps; no such remediation task already existed, so created **TASK-0049 — Biology + Statistics: Close Remaining Six-Criterion Servability Gaps** as a Hard-Gate task. No Production writes were performed. Session handoff: `docs/handoffs/TASK-0046_SESSION_CLOSE_2026_09_28.md`. Concurrent TASK-0046 PR #248 exists and must be reconciled with this session's PRs before merging overlapping documentation. **Next Owner:** fresh independent QA/Main Conductor. **Next Action:** reconcile TASK-0046 evidence/PRs, complete fresh QA, then seek explicit Product Owner approval for the first TASK-0049 Production remediation slice.
- Content-Pipeline Session, Final Close: Pair-QA Status Confirmed Complete for All Ten Subjects
  (2026-09-27): David asked what remained to be pair-QA'd after the content pipeline/unlock work
  above. Read-only check, no new writes: the original 2026-09-25 pairing
  (`TIER3_LABELS_DIFFICULTY_PAIRED_PLAN_2026_09_25.md`) split the nine non-Biology subjects into Pair
  1 (Statistics/Chemistry), Pair 2 (Calculus AB/Precalculus), Pair 3 (Physics 1/Physics 2), and Pair 4
  (Physics C: Mechanics/Physics C: E&M), plus a solo Calculus BC lane, with Biology on its own separate
  FF lane. `LAUNCH_PLAN_CONTENT_PIPELINE_2026_09_26.md`'s status table lists "Independent cross-QA:
  Complete" for all ten, and this session already has independent corroboration beyond that table's
  own claim: the 216-row single-unit freshness re-audit and the 27-of-141 blind multi-unit third
  review (via a separate model, candidate label withheld from the prompt) ran across all ten subjects
  together, superseding the original per-pair split, and `app.servable_items_census_selftest()` shows
  0 mismatches. **Zero subjects remain to be pair-QA'd.** Caveat recorded: this confirms the cross-QA
  *procedures* ran and landed correctly in Production, not a fresh independent re-read of each pair's
  original substantive judgment calls (e.g., whether a specific unit-assignment rationale was sound) —
  that would be a deeper content-quality pass, distinct from what was checked here. Also re-confirmed
  for David: the AP Biology difficulty gap (see below) is fully closed, not outstanding — a prior
  message had referenced it only as session background, which read as if it were still open.
- Content-Pipeline QA Session Close: PR #235 Verified, Biology Difficulty Gap Closed, Unlock Status
  Checked (2026-09-27): Independently audited the Codex `codex/task-0042-content-pipeline-remediation`
  worktree and, after it merged, PR #235 itself, against live Production rather than the docs' own
  claims. Confirmed as accurate: the 216-row DECISION-0066 freshness re-audit (0 reverted, hashes
  traced to original pre-promotion migrations, not circular), the five-row difficulty correction, the
  runner-hardening diff, and the 27-of-141 blind multi-unit third review (exact `validation_decisions`
  note match). Found one claim overstated — "complete difficulty coverage for all ten subjects" was
  false for Biology (43/65 MCQ, 75/95 FRQ) — traced the cause (a one-shot 2026-09-24 load capped at the
  118 items live then; 42 items published since without a backfill trigger) and closed it same session
  via `20260927170500_apbio_difficulty_gap_closure.sql`, applying the approved task-verb method;
  Biology is now 95/95 FRQ, 65/65 MCQ. Committed and pushed to `main` (`b9ed6ea5`). **Unlock status,
  corrected after re-diagnosis:** all 10 subjects are fully unlocked. A first pass flagged AP
  Statistics as having 2 of 7 probed units return 0 rows and left it as an open item; re-diagnosis
  found this was a false alarm caused by a pre-existing, already-documented limitation of
  `app.servable_items_census_selftest()` (it scans every `exam_pack_version` including retired ones).
  Calling `select_unit_gated_practice_items` directly against both of AP Statistics' pack versions
  confirmed the live, non-retired pack serves both units correctly (19 and 48 items); only the
  retired 2026-08-24 pilot pack (retired 2026-09-25) returned 0, which is correct behavior, not a
  defect. Corrected same session — see below.
- AP Biology Difficulty Gap Closed (2026-09-27): PR #235's "complete difficulty coverage for all ten
  subjects" claim was checked against live Production and found overstated for Biology (43/65 MCQ,
  75/95 FRQ). Traced the gap to the one-shot 2026-09-24 difficulty load
  (`20260924240000_apbio_content_item_difficulty_load.sql`, work order J.0), which covered exactly the
  118 items live at that time and asserted that count; 42 items (20 FRQ + 22 MCQ, all authored
  June/July 2026) later moved to `published` through ordinary editorial review with no corresponding
  backfill — corpus growth outrunning a one-time load, not a repack (Biology has had a single
  `exam_pack_version` since 2026-06-27) or a defect in that migration. Closed via
  `20260927170500_apbio_difficulty_gap_closure.sql`, applying DECISION-0061/0065's approved task-verb
  method identically to `scripts/taxonomy/build_remaining_difficulty_artifacts.py`'s regex
  classification (FRQ: modal criterion tier with upward tie-break over `app.frq_criteria`; MCQ: stem
  classification; undecided items default to Medium/`calibrated_judgement`, never a fabricated ratio).
  Verified post-apply: Biology is now 95/95 FRQ and 65/65 MCQ with a difficulty row;
  `app.servable_items_census_selftest()` shows 0 mismatches. Source:
  `docs/research/apbio_difficulty_gap_closure_2026_09_27/APBIO_DIFFICULTY_GAP_CLOSURE_2026_09_27.csv`.
- `O17` Home Redesign Reviewed for Viability, `TASK-0048` Planned (2026-09-27): David shared a
  Design-canvas artifact (`https://claude.ai/artifact/HoaRcFFv8GoiV9VeyDcgYh`) as the intended `/home`
  redesign answering `O17`. Reviewed every element against the real schema/functions rather than
  judging it on looks: design-system fidelity confirmed real (`project/ds/cramapple/tokens.json` is a
  byte-for-byte copy of `docs/new_design/`'s tokens, not a reinvention). Stage A (new student) and
  Stage B (building evidence) are mostly buildable now or after small backend work; the
  Main/Personalized state depends on things that don't exist yet (`GAP-10`'s content pass, an unbuilt
  partial-FRQ-resume capability, a nonexistent streak/trend computation layer) and was deliberately cut
  from scope. **Independently found while reviewing:** `get_home_start_queue` (the RPC behind the
  "Start here" queue on the *current* live Home) was written in a migration
  (`20260828120000_home_start_queue_rpc.sql`) and never deployed to Dev or Production — confirmed via
  `pg_proc` on both — the same "written, never shipped" bug class as today's earlier `public.sessions`
  fixes, silently showing every student a hardcoded placeholder queue today, unrelated to this
  redesign. Created `TASK-0048` (`docs/tasks/TASK-0048-HOME-REDESIGN-STAGE-A-B.md`) scoping Stage A +
  Stage B with that RPC deploy and a topic-level course-position schema change as prerequisites; the
  diagnostic quiz, cross-subject rollup, and full Main-state build are explicitly flagged as separate
  follow-ups, not silently dropped. **Next Owner:** David Bloom (confirm scope), then whoever picks up
  `TASK-0048`. **Next Action:** deploy `get_home_start_queue` — free-standing, fixes live Home
  regardless of this task's timeline. Full detail in `LAUNCH_PLAN_STUDENT_HUB_2026_09_26.md`'s
  "REVIEWED, 2026-09-27" section and `ARCHITECTURE_AND_DESIGN_DECISIONS_CURRENT.md`'s `O17`.
- TASK-0042 Content Pipeline Done (2026-09-27): completed the 216-row freshness audit, five difficulty corrections, runner hardening, all-subject label execution, and blind Claude third review of the actual 141 current multi-unit candidates. Promoted 27 exact confirmations; retained 66 disagreements and 48 holds. All-subject live census: 0 mismatches. David set no fixed quantity targets outside Biology; maximize safely usable published inventory (`DECISION-0082`). Approval: `APPROVAL-0056`.
- David Chose "Fix First" on the Two `public.sessions` Bugs — Lovable Agent Blocked, Needs Editor
  Attention (2026-09-27): asked David directly whether to fix the two session-route bugs found this
  session, retire the cluster, or leave both alone — he chose fix-first. Sent a complete, precise fix
  spec to the "New Cramapple App" Lovable project via `send_message` (exact before/after code, correct
  `learning_sessions` columns, explicit instruction not to fabricate a `summary`/recommendation
  replacement for `session.setup.tsx`). **The agent isn't executing it** — three consecutive messages
  each returned in seconds with empty content and no new commit (`list_edits` still shows `a67a28d5`,
  unchanged). Matches the Lovable tool's documented `awaiting_input` behavior: an unrelated, earlier
  request today ("Automatic Full Preview") left a `switch_to_build_mode` approval pending, which "only
  the user can answer... in the Lovable editor" and a new message doesn't clear. **Next Owner:** David
  Bloom. **Next Action:** open `https://lovable.dev/projects/56cae479-f7c9-4988-b536-56538c38ee4e`,
  clear whatever's pending, then re-send or let the queued fix run — the fix itself needs no further
  design work, it's fully specified in the project's chat history and in
  `LAUNCH_PLAN_STUDENT_HUB_2026_09_26.md`'s "BLOCKED, 2026-09-27" section.
- Session-Route Retirement Re-Audited — Two Real `public.sessions` Query Bugs Found, Cluster's Live
  Reachability Weaker Than Last Session's Correction Implied (2026-09-27): per last session's explicit
  instruction to trace every Start *and* Resume entry point before raising retirement again, re-traced
  the whole `/setup`/`/topic`/`/session/mcq`/`/session/frq`/`/session/uncertain`/`/setup/subject` cluster
  directly against live Lovable source and Production's real schema. **Found two previously-unknown,
  real bugs, not a routing-policy question:** `home.functions.ts`'s `loadStudentHome` (behind
  `TopicHome`'s "Resume" banner) and `session.setup.tsx` (behind its "Returning student" banner) both
  query `public.sessions` with `.eq("user_id", ...)` and select a `goal` column — that table's real
  columns are `student_id` (no `user_id`) and no `goal` at all, confirmed via
  `information_schema.columns`. PostgREST errors on both bad references; both call sites swallow the
  error via `?? []`, so both features silently no-op for every student, always — the identical bug
  *class* (wrong table/column, error swallowed) as the `attempts` bug this doc already fixed once,
  recurring unnoticed in an adjacent query. Also found `session.index.tsx` (bare `/session`) does not
  actually invoke the `requireSubject: true` guard its own JSDoc claims it does, so the second path the
  prior correction cited into `/setup/subject` is not confirmed either (not exhaustively ruled out
  elsewhere). **Net: the cluster currently has no confirmed live entry point from the real default flow
  — not because it was provably dead by design, but because of two fixable bugs.** Fixing them would
  restore reachability (the opposite direction from retirement) — flagged to David rather than resolved
  either way. **Next Owner:** David Bloom (scope call: fix the `public.sessions` bugs, retire the
  cluster, or both in sequence). **Next Action:** none taken past diagnosis; full detail in
  `LAUNCH_PLAN_STUDENT_HUB_2026_09_26.md`'s "AUDITED, 2026-09-27" section.
- IDG-5 and `DECISION-0074` Mastery Capture Both Confirmed Live in One Real Grading Round Trip
  (2026-09-27): immediately after the `cell_scoped` fix below, David submitted a real answer at
  `app.cramapple.com` (topic `1.13`) and it graded. Queried Production directly to confirm, rather than
  trusting the UI: `app.attempts` shows the real attempt (`d7663902-...`) went `submitted` → `graded` in
  ~1.5s via the service-role write path, `status`/`result_state` both `"graded"`, score 0/1 — the first
  non-synthetic confirmation that `attempts_prevent_client_grading_truth_update` (fixed last session,
  previously only scratch-row-tested) works on real traffic. **`app.student_cell_state`** also shows a
  new row for that topic/skill with `last_event: "incorrect"`, `mastery_mcq_correct_count: 0` (correct —
  a miss shouldn't increment it), and `last_attempt_id` correctly linked to the graded attempt — the
  first live confirmation of the entire `DECISION-0074` mastery-capture backend (schema →
  `assistance_state` derivation → mastery counters), previously verified only by unit tests and a
  synthetic Dev event. **Both of last session's two biggest unverified builds are now confirmed live.**
  **Next Owner:** open. **Next Action:** none required; a correct answer, a second topic, and the FRQ
  path remain untried against real traffic if more confidence is wanted. Full detail in
  `LAUNCH_PLAN_STUDENT_HUB_2026_09_26.md`'s second "RESOLVED, 2026-09-27" section.
- `cell_scoped` No-Matching-Content Bug Resolved — Stale Edge Function Deploy, Not a Query/Data Bug
  (2026-09-27): picked up the paused diagnosis from `LAUNCH_PLAN_STUDENT_HUB_2026_09_26.md`'s
  "SESSION CLOSE" section (every AP Statistics topic serving `no_matching_content` for a real signed-in
  account, despite 203 published MCQs confirmed present). **Root cause: Production's and Dev's deployed
  `student-session-items` Edge Function predated the `cell_scoped` mode commit (`912699b2`,
  2026-09-26) entirely** — pulled the live deployed source directly and confirmed it had no
  `cell_scoped` branch and the old `MAX_ITEMS = 20`. Neither environment had been redeployed since that
  commit landed (`git push` does not deploy Supabase Edge Functions on its own). The stale function
  silently fell back to its default queue path, which for David's session shape called
  `select_ordinary_combined_practice_items` — confirmed directly against Production that this RPC
  returns zero rows for that pack/format, producing exactly the `no_matching_content` seen live.
  **Side finding fixed first:** 5 tests in `student-session-items/index_test.ts` were silently broken
  (test-mock/routing mismatch from two branches merging independently, confirmed via a `git worktree`
  bisection to `912699b2` where all 23 then-existing tests passed) — fixed the mocks only, no runtime
  change, commit `707a1c52`, 26/26 pass now. **Fix:** redeployed current `main`'s `student-session-items`
  to Dev then Production (David confirmed both, via `AskUserQuestion`, before the Production deploy);
  both report an identical `ezbr_sha256`; `get_advisors` shows no new findings. **Live-verified:** David
  re-tried on `app.cramapple.com` immediately after the Production deploy and confirmed content now
  loads — bug fully closed, no open follow-up. **Next Owner:** whoever resumes
  `LAUNCH_PLAN_STUDENT_HUB_2026_09_26.md`'s IDG-5 live-grading verification, now unblocked. **Next
  Action:** attempt the real live grading round trip (sign-in → submit → grade → `attempts` row update)
  IDG-5 has been waiting on. Full detail in `LAUNCH_PLAN_STUDENT_HUB_2026_09_26.md`'s "RESOLVED,
  2026-09-27" section.
- Lean Source-of-Truth Startup Mode Adopted (DECISION-0081 / APPROVAL-0055, 2026-09-27): diagnosed why
  Codex session-start was consuming most of a session's usage budget before task work began —
  `CODEX_NEW_SESSION_PROMPT.md` hardcoded an unconditional ~3,200-line, 11-doc read for every task,
  contradicting `CRAMAPPLE_SESSION_START.md`'s own "read only what a bounded task needs" guidance, and
  the three activity/approval/decision logs' "(Index section)" instruction had no enforceable stopping
  point. Rewrote `CODEX_NEW_SESSION_PROMPT.md` and `CLAUDE_NEW_SESSION_PROMPT.md` to classify Tier
  first (pointing at `AGENT_OPERATING_MODEL.md`'s existing Task Tiers definition rather than
  redefining it, to avoid drift) and size the reading set to that tier; added an end-of-index HTML
  comment marker to `ACTIVITY_LOG.md`, `APPROVALS_LOG.md`, and `DECISIONS_LOG.md` (see the bottom
  of each file's Index section for its exact form — deliberately not spelled out here, so this
  entry's own prose can't be mistaken for the marker by a literal-string reader) so index-only
  reads have a real stopping point, with a required fallback (read past the marker, don't report
  absence) if a targeted ID/keyword search finds nothing; added root `AGENTS.md` for repo-wide
  search discipline (no broad scans of `docs/research`, `docs/teaching`, `prompts`, `tmp`, `output`,
  worktree/dependency dirs, generated output, raw logs, image/PDF corpora). David reviewed the
  diagnosis and the protocol draft directly, requested six tightening edits, and approved shipping
  once applied — recorded as `DECISION-0081`/`APPROVAL-0055`. **Repo-size hygiene** (large tracked
  PDFs, raw `.jsonl` logs, generated SQL under `scripts/*/out`) was flagged as a real, separate finding
  and deliberately **not** bundled into this change. **Next Owner:** open. **Next Action:** none
  required to use the new protocol going forward; repo-size cleanup remains a separate, unscheduled
  follow-up.
- BYOQ Anonymous-Access Conflict RESOLVED (DECISION-0077 / APPROVAL-0053, 2026-09-27): the conflict flagged in the entry below — `DECISION-0070` (BYOQ ungated/anonymous) vs. `DECISION-0068`'s authenticated `user_id`-keyed schema — was resolved by David directly: **BYOQ is identity-agnostic.** `app.byoq_items.user_id` is nullable (recognition, not a gate); BYOQ runs anonymously on the marketing page (`61dd6602`) and recognized in the app (`56cae479`) with identical behavior; anonymous scoping (session/device token) is build work under TASK-0039. `DECISION-0070` stands; `DECISION-0068`'s auth assumption gives. Reconciled in place: `TASK-0039` (schema + resolution note), `DECISIONS_LOG` (`DECISION-0077`), `APPROVALS_LOG` (`APPROVAL-0053`), and the canonical one-pager (O16 → D18). **Correction to the entry below:** it cites the launch frontend as `d334fed9` ("Remix of Cramapple App") — that is the **stale** ID `DECISION-0073` self-corrected; the verified live projects are **App `56cae479`** (`app.cramapple.com`) and **Marketing `61dd6602`** (`cramapple.com`) (re-confirmed via live DNS 2026-09-27). **Next Owner:** Claude (BYOQ build, TASK-0039). **Next Action:** design the anonymous-scoping mechanism and the nullable-`user_id` migration under the existing Hard-Gate.
- TASK-0039 Reconciled Against DECISION-0075's Documentation Cleanup: Phase Priority and Ownership Corrected (DECISION-0076, APPROVAL-0052); Anonymous-Access Conflict Found and Reported, Not Resolved (2026-09-27): a cross-session notification pointed this session at `DECISION-0075` (the new canonical `ARCHITECTURE_AND_DESIGN_DECISIONS_CURRENT.md`), which surfaced a real conflict with `TASK-0039`'s approved Phase 1 (typed intake first, camera capture deferred, Claude-owned) against a same-day decision this session hadn't seen: "BYOQ is phone capture to start. Document upload post launch," with BYOQ's build originally assigned to Codex. Rather than self-resolve, stopped and asked David directly. **David's direction:** "phase 1 is phone, not text BYOQ" and "Claude is taking over BYOQ while Codex works on content pipeline" — recorded as `DECISION-0076`/`APPROVAL-0052`. `TASK-0039` annotated in place (not physically renumbered, to avoid leaving 49 cross-references inconsistent): camera/QR capture is now launch-required, typed intake is a fallback, and the Pre-flight verification step's frontend-identity question was independently resolved by `DECISION-0073` (the launch frontend is Lovable project `d334fed9`, "Remix of Cramapple App" — neither of this task's two earlier guesses). **A second, more severe conflict was found during the same re-verification pass and reported rather than self-resolved:** `DECISION-0070` (2026-09-26) states BYOQ ships "ungated, as an anonymous session" on launch — structurally incompatible with the approved Option A schema's owner-scoped RLS (`app.byoq_items.user_id` as a `NOT NULL` FK, keyed to an authenticated `auth.uid()`), and possibly implying BYOQ ships on the marketing frontend rather than the authenticated app. **Not resolved this session** — flagged directly to David, no schema or implementation work proceeded past this point. **Next Owner:** David Bloom. **Next Required Action:** decide whether BYOQ needs an anonymous-capable data path (no `user_id`) or whether the anonymous/ungated framing in `DECISION-0070` should be revisited, and confirm which frontend BYOQ actually ships in.
- Documentation Cleanup — Architecture/Design Single Source of Truth (2026-09-27): docs-only pass that
  created the canonical one-pager `docs/product/ARCHITECTURE_AND_DESIGN_DECISIONS_CURRENT.md` and
  `docs/INDEX.md`, annotated the stale canonical design/rebuild docs in place (fixed-plate rule → responsive;
  §11 decisions marked resolved with TASK-0047/`DECISION-0074` citations; Course Mode / "Project-Crux"
  vocabulary + palette banners), and added entry-point pointers. Verified the responsive frame, project
  IDs, commit locations, and DNS against live systems, not docs. **Ratified `DECISION-0075`** (one-pager
  canonical, owner David Bloom; governed-doc pointers kept; legacy = annotate-in-place, no move).
  Committed via docs-only PR.
- Session Close: Six-Section Launch Plan Audit, Mastery Rule Tightened (`DECISION-0074`), Student
  Interaction Data Schema Plan Drafted, Full Branch Survey/Cleanup/Merge, MCQ-Fix Attribution
  Corrected (2026-09-27): David asked for a full audit of all six launch-plan sections
  (marketing home, payment, content pipeline, student hub shell, grading engine, subject gate) with
  completion/effort estimates. Ran 6 parallel live-verification agents (not doc-trusting) — see memory
  `project_launch_plan_six_section_audit_2026_09_26.md` for full per-section detail. **Two findings
  changed prior understanding: (1) the live marketing/app frontend is Lovable project `61dd6602`
  ("New Cramapple Marketing"), not `d334fed9` as `DECISION-0073` and every dependent doc had assumed —
  confirmed via live DNS, not a doc citation; (2) no real student has ever had a graded attempt complete
  in Production** — corrects an earlier memory note that a stuck real student's attempts would
  "resolve on next retry." Both corrected in `APP_LAUNCH_READINESS_INDEX_2026_09_26.md`.
  **`DECISION-0074`:** mastery rule tightened, on David's direction, from "2 full-point answers, with
  hint" to **2 correct MCQ + 1 full-point FRQ, with no hint use prior to submission** (post-submission
  hints still never count). Adds `GAP-9` to `CONTENT_GAPS_RUNNING_LIST.md` (a taxonomy cell needs both a
  servable MCQ and FRQ or it can never reach mastery under the new rule — accepted as a temporary content
  gap, not a rule flaw). A full audit/extend/prune plan for the student-interaction-data schema was
  drafted by Fable, reviewed, amended twice after two rounds of pushback (an indexing plan for the new
  tables; elevating the hint-definition-boundary question to a hard gate on schema-building, not an
  end-of-plan decision) — written to `docs/product/STUDENT_INTERACTION_DATA_SCHEMA_PLAN_2026_09_27.md`,
  plan only, nothing executed. **Full local/remote branch survey and cleanup**: of ~50 local branches
  and ~30 live worktrees, deleted 16 confirmed-merged/superseded branches directly; merged 17 branches
  of real unshipped work to `main` via PRs #211-#228 (14 AP Statistics Course Mode content branches
  covering all of Unit 2/most of Unit 3, plus TASK-0044's execution, plus the AP Statistics MCQ-serving
  fix); correctly declined to merge one branch (`codex/tier1-precalc-calcbc-canonical-2026-09-25`) on
  discovering its canonical answers were already superseded by better, evidence-sourced migrations on
  `main`. **Corrected a mis-attribution found along the way** (PR #229): the AP Statistics MCQ-serving
  fix actually deployed to Production is `codex/task-0044-statistics-mcq`, not
  `claude/task-0047-ap-statistics-mcq-serving` as `ACTIVITY_LOG.md`, `APPROVALS_LOG.md`
  (`APPROVAL-0051`), and `LAUNCH_RUNBOOK_2026_10_02.md` had all credited — the latter branch's Dev-only
  version never reached Production. **What remains open, in priority order:**
  1. **No real student has ever completed a graded attempt in Production** — needs investigation before
     Oct 2; directly contradicts the runbook's own stop condition. Highest-priority open item.
  2. A reviewable cleanup script (`branch_cleanup_2026_09_27.sh`, sent to David) covers 18 more
     confirmed-safe branch/worktree deletions, blocked on David's own machine by this session's
     destructive-action permission classifier — not yet run.
  3. `content/course-mode-stats-3.5-2e` and `3.7-3e`: real uncommitted generator-code and content
     changes found in their worktrees during the cleanup pass (not captured in any commit) — needs a
     recovery pass, explicitly NOT a deletion candidate despite looking like a stale merged branch.
  4. `codex/tier1-precalc-calcbc-canonical-2026-09-25` left unmerged (see above) — David's call whether
     anything in it is worth salvaging before deleting.
  5. The hint-definition-boundary question (which in-attempt events count as "hint use before
     submission" under `DECISION-0074`) blocks the interaction-data plan's Phase 1 items 1-2 — needs
     David's answer, recorded as a `DECISION-0074` addendum, before that work starts.
  6. Marketing home page (`61dd6602`): BYOQ unshipped, `/signup` not gated to Bio/Stats, one unsupported
     marketing claim still live — see the corrected index row for detail.
  7. Payment flow's four open decisions (D-6/D-9/D-10/D-11) — unchanged, still David-only, still
     post-launch.
  **Verified:** all PR merges confirmed via `gh pr view --json state,mergedAt`; Production schema state
  for the MCQ-fix correction confirmed via direct `execute_sql` against Supabase, not inferred from
  docs; the two flagged uncommitted worktrees confirmed via `git status --short --ignored`, not assumed
  clean. **Files changed:** `APP_LAUNCH_READINESS_INDEX_2026_09_26.md`, `LAUNCH_PLAN_STUDENT_HUB_2026_09_26.md`,
  `LAUNCH_RUNBOOK_2026_10_02.md`, `TASK-0044-LAUNCH-SUBJECT-ONBOARDING-GATE.md`, `CONTENT_GAPS_RUNNING_LIST.md`,
  `DECISIONS_LOG.md` (`DECISION-0074`), `ACTIVITY_LOG.md`, `APPROVALS_LOG.md` (`APPROVAL-0051`), new
  `STUDENT_INTERACTION_DATA_SCHEMA_PLAN_2026_09_27.md`. **PRs merged this session:** #210 (prior turn),
  #211-#226 (branch cleanup merges), #227 (MCQ-fix branch), #228 (distractor-repair branch), #229
  (attribution correction). **Approval state:** all merges were docs/content/already-verified-live-code;
  no new Production schema/config change was made by this session directly (the MCQ-fix code itself was
  already live before PR #227 merely caught `main`'s git history up to it). Launch go/no-go remains
  David's Hard Gate. **Next Owner:** David Bloom (decisions above) or whoever picks up the real-grading
  investigation next. **Next Required Action:** investigate why the one confirmed real student's
  attempts are still ungraded — this blocks confident Oct 2 sign-off regardless of how everything else
  above resolves. **Do not touch:** `codex/image-workflows-design-sketch` (quarantined, needs a fresh
  design review before merge) and `archive/free-score-check-2026-08-15` (intentional permanent archive)
  — both confirmed correctly untouched this session. — 2026-09-27

- TASK-0044 Executed (October 2 Flat-Path Content Gate); AP Statistics MCQ Serving Gap Diagnosed
  2026-09-26, Fixed and Deployed to Production 2026-09-27 — Both Awaiting Fresh Independent QA:
  Claude executed TASK-0044 (branch `claude/task-0044-flat-path-gate-bio-stats`, commit `24966a79`,
  merged `main` via PR #226), verifying criteria 1/2/4/6 live against Production for the two Day-1
  subjects. **AP Biology: Pass** — 71/71 servable `targeted_drill` FRQ and 43/43 MCQ have canonical
  answers/rubrics; live RPC calls confirmed both types reachable (`select_practice_frqs` → 50 rows;
  `select_biology_practice_items` → real 12 FRQ/8 MCQ mix). **AP Statistics: FRQ Pass, MCQ Blocked** —
  49/49 servable FRQ pass, but a real gap was found and diagnosed: 101/101 published MCQ were
  content-ready with zero path to serve them, because `select_practice_frqs` is FRQ-only by design and
  `select_biology_practice_items` (the only existing combined selector) is Biology-only by design,
  confirmed by reading both the RPC SQL and `student-session-items/index.ts`.
  **CORRECTION, 2026-09-27:** the fix that actually reached Production is `codex/task-0044-statistics-mcq`
  (merged `main` via PR #227), not a separate same-day attempt (`claude/task-0047-ap-statistics-mcq-serving`,
  since deleted) this entry originally credited. That earlier branch built the same idea — a new,
  subject-agnostic `app.select_ordinary_combined_practice_items` RPC (additive — Biology's own selector
  is untouched) — but only wired `student-session-items` to route AP Statistics's `targeted_drill`
  format to it; its migration and edge-function version were applied to Cramapple Development only and
  were **never applied to Production**, contrary to what this entry originally stated. The branch that
  actually shipped, `codex/task-0044-statistics-mcq`, routes both `mcq` (the real Home session format)
  **and** `targeted_drill` to the same RPC — independently verified byte-for-byte identical (function
  body, comment, and deployed edge-function source) to what Production was already running before PR
  #227 formally merged it into `main`'s git history. Live post-merge verification: 7 FRQ + 13 MCQ for
  AP Statistics (matching the original dry-run projection exactly) and 12 FRQ + 8 MCQ for AP Biology,
  unchanged. **A real, resolved shared-workdir incident** (unaffected by this correction): mid-execution
  of the original TASK-0044 pass, this local checkout was switched to a branch Codex had concurrently
  checked out elsewhere for TASK-0040, so one commit briefly landed on the wrong branch, bundled with
  Codex's uncommitted work. Caught before anything was pushed; verified Codex's actual dedicated
  worktree was never touched; cleanly separated the two agents' work and re-committed TASK-0044 on its
  own branch via an isolated `git worktree` rather than the shared primary checkout. **Neither TASK-0044
  nor the MCQ-serving fix has closed** — both still need a fresh, independent QA pass and Main Conductor
  integration before `Done`. **Next Owner:** whoever runs the next QA pass (fresh context, not a
  continuation of any of these sessions). **Next Required Action:** QA the live AP Statistics MCQ
  experience end-to-end per `LAUNCH_RUNBOOK_2026_10_02.md` item 4, then fold the verdict into
  `TASK-0044-LAUNCH-SUBJECT-ONBOARDING-GATE.md`. — 2026-09-27 (correcting a 2026-09-26 entry)

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

<!-- INDEX_END -->

## Units 1-3 Skill and Topic Cleanup, Biology 025-v3, MCQ-005 Retired (APPROVAL-0098 to 0103) — 2026-10-03

**Approvals:** `APPROVAL-0098` to `APPROVAL-0103` (David Bloom, chat). **Scripts and votes:** `scripts/content-seed/skills-u13-2026-10-03/`, `scripts/content-seed/pipeline-v2-bio-u13-2026-10-02/load/restore_025v3.sql`.

**What was done (Production `pcntajvbdfqhbeewmdry`):** (1) the two real stale labels (`APBIO-MCQ-088`, `apphy1-mcq-049`) re-issued validated on the published version; the other ~50 census "mismatches" are never-validated labels. (2) Biology `APBIO-MCQ-SV-025-v3` restored (the only 025 variant that passed both checkers). (3) Skill grids built for Physics 1 (10 skills, 430 cells) and Precalculus (8 skills, 464 cells). (4) Four-voter skill votes on 140 Units 1-3 seeds, then variants inherited: 679 skill cells. (5) 32 topic cells for topic-less variants, 7 for untagged seeds (3 by CED-text tiebreak), 34 more skill cells, 6 seed skill cells with 2 inheriting variants. (6) `apcalcab-mcq-005` and its 5 variants retired.

**Verified:** every batch rehearsed with a rollback first; after each commit an md5 over the written rows equalled the locally computed plan.

**Known leftovers:** 4 variants with a 2-2 skill split; 6 variants and 26 more waiting on seeds without a skill; FRQs, Units 4 and above, and Calculus BC not covered; two documented drafts (`APSTATS-MCQ-SV-057-v2`, `apcalcab-mcq-sv-025-v1`) stay held.

## AP Biology: 38 Items With All Versions Retired Now Marked Retired (APPROVAL-0095) — 2026-10-03

**Approval:** `APPROVAL-0095` ("Clean up the 42"). **Script:** `scripts/content-seed/reviewer-qa-remediation/20261003_apbio_align_orphan_item_status.sql`. **Follows:** the 42-item finding recorded with `APPROVAL-0092`.

**What was found:** the 42 Biology items marked `published` with no published version were old pipeline retirements (item rows last touched 2026-07-16 to 2026-08-13) where only the versions had been retired. The practice selector requires both the item and its version to be `published`, so none was being served, and the census already counts the state as its own bucket. No student-visible effect.

**What was done:** 38 of the 42 (17 FRQ, 21 MCQ) set to `retired` at item level by a rule inside the script (all versions retired, no attempts). Verified: Biology published items 174 to 136; published versions and validated serving labels unchanged (132 and 163). **Held, not touched (4):** `APBIO-FRQ-L-028` (5 attempts) and `APBIO-MCQ-012` (1 attempt), where an item-status change might affect anything listing a student's history by item status (not checked); `APBIO-FRQ-L-038` and `APBIO-FRQ-L-041`, each with an unretired `reviewed_approved` version 1 beside retired versions 2 and 3.

**Per the Product Owner:** no rescan of other subjects' banks under `DECISION-0095`. **Update, same day:** the four held items were retired under `APPROVAL-0096` after the Product Owner confirmed the attempts were tests, not real students. Biology now has 132 published items, each with a published version. **Next Owner:** David Bloom. **Next Action:** none from this thread.

## AP Biology: 3 More Items Retired (APPROVAL-0092) and DECISION-0095 Recorded — 2026-10-03

**Approval:** `APPROVAL-0092` ("Retire all 3 and create a decision for stay within the CED"). **Decision:** `DECISION-0095`. **Script:** `scripts/content-seed/reviewer-qa-remediation/20261003_apbio_retire_014_063_025.sql`.

**What was done:** a read-only scan of the 41 published AP Biology seed-style MCQs found two with terms the CED does not name (`APBIO-MCQ-014`: 70S/80S ribosomes; `063`: signal sequence); with `025` (kidney ADH and aquaporin-2 physiology outside the pack, per `APPROVAL-0080`) all three were retired. This corrects the pilot's count: six of the eight pilot seeds, not five, used out-of-CED terms (`014` was missed). Verified afterwards: Biology published items 177 to 174, seed-style published MCQs 65 to 62, 17 variants and 163 validated serving labels unchanged.

**Finding, not caused by this change:** 42 Biology items (20 FRQ, 22 MCQ) are marked `published` at item level while every version is `retired`. Whether any is served was not checked. **Next Owner:** David Bloom. **Next Action:** decide whether to clean up those 42 and whether to scan other subjects' published banks under `DECISION-0095`.

## AP Biology: 7 Published Variants With Out-of-CED Terms Retired (APPROVAL-0091) — 2026-10-03

**Approval:** `APPROVAL-0091` (Product Owner: "some of the published ones use terms outside the CED. We should retire them. We have enough questions."). **Script:** `scripts/content-seed/reviewer-qa-remediation/20261003_apbio_retire_out_of_ced_variants.sql`. **Follows:** `APPROVAL-0080`, and the 2026-10-01 ruling that items stay within CED vocabulary.

**What was done:** a full-text scan (stimulus, stem, every choice and rationale) of all 24 published `APBIO-MCQ-SV-` variants against terms confirmed absent from the CED V.1 text found 7 matches; those 7 were retired in one transaction: `014-v1`, `014-v2`, `022-v3` (70S/80S ribosomes), `022-v1` (70S ribosomes, binary fission), `018-v1`, `018-v3` (receptor-mediated endocytosis), `023-v2` (high-salt wash). Zero attempts on all seven. `SV-005-v3` ("tripeptides") was kept on purpose. Verified: variants published 24 to 17, Biology published items 184 to 177, no published item without a published version, validated serving labels unchanged at 163.

**Not done:** no replacements written; this session's 16 drafts stay unloaded; the unit-gated servable count was not re-queried. **Next Owner:** David Bloom. **Next Action:** none required; the open items are in `docs/handoffs/SEEDED_QUESTIONS_SESSION_RECORD_2026_10_01.md`.

## Google Sign-In Removed From Checkout; Post-Pilot Task Opened (TASK-0058) — 2026-10-02

At David's direction (after the Google consent screen showed the Supabase project URL and the redirect flow left the page), Claude sent a tightly scoped instruction to the Lovable marketing project; Lovable commit `18666296` removed the Google button, the "or type your email" divider and the code that existed only for it. The diff was checked line by line: one file (`src/routes/checkout.index.tsx`), deletions only, signed-in handling untouched, nothing published. `TASK-0058` collects the post-pilot work (Google One Tap/FedCM with `signInWithIdToken`, step reorder and wallet layout, wallets-first email capture, a Dev-pointed frontend, Stripe hardening, email/SMTP, passkeys) and the Google Auth Platform branding checklist.

**Approval state:** documentation; the Lovable edit is unpublished. **Next Owner:** David Bloom. **Next Action:** publish the Lovable project when ready; start Google branding verification; the pre-pilot items listed in `TASK-0058`.

## Stripe Live Payment Proven in Production; Refund Round Trip Verified — 2026-10-02

Evidence is in `docs/product/STRIPE_PRODUCTION_CUTOVER_CHECKLIST_2026_09_30.md` ("Gate D evidence, part 1"). A full-price live Link payment ($39.99, Biology, existing admin student) was processed by the live webhook on the first attempt; a $10 partial refund left the entitlement active and the remaining $29.99 refund revoked it. David refunded the whole charge. Found and fixed (Lovable `230e0670`) the email conflict that stopped the card form loading; Bank, Cash App Pay, Klarna and Amazon Pay switched off in Stripe.

**Not approved / still open:** the Orly email; the new-student path (invite email, 6-digit code), which depends on Supabase email delivery (SMTP setting unverified); the $1 coupon on a live checkout; the `support@cramapple.com` alias; the go/no-go. **Next Owner:** David Bloom. **Next Action:** test a brand-new student in a private window with the `?promo=` link and a fresh email; check Supabase Auth SMTP settings.

## Stripe Functions Tranche 2 Deployed to Production (APPROVAL-0071) — 2026-10-02

**Approval:** `APPROVAL-0071`. All four functions deployed from `main` `fc2f3a6c` and verified (see the approval entry). Earlier the same day David re-set `STRIPE_SECRET_KEY`, `STRIPE_WEBHOOK_SECRET` (Production had stored identical values for both, which was wrong) and `STRIPE_PRICE_CATALOG_JSON` (exact match to the validated JSON); a fifth event, `charge.refunded`, was added to the live webhook endpoint; the refund policy is live in the Terms; the "free until November" copy is gone.

**Approval state:** Hard Gate. Not approved: the Lovable publish, the Orly email, the go/no-go. **Next Owner:** David Bloom. **Next Action:** fix the `support@cramapple.com` alias; decide when to publish the Lovable project; then Gate D (your own \$1 purchase with the live code, refund it, confirm access and revocation).

## Stripe Functions Tranche 1 Deployed to Production (APPROVAL-0070) — 2026-10-02

**Approval:** `APPROVAL-0070` (tranche 1). `stripe-webhook` v20→v21, `get-checkout-status` v1, `send-parent-payment-email` v1, all `verify_jwt=false`, deployed source byte-identical to `main`; invalid-request probes returned 400/405; Production data unchanged. Live publishable key already sits in the Lovable `.env` but the project is unpublished (checkout still shows "Online payment isn't switched on yet"). Refund-policy draft is in PR #309; it exposed that the Contact Us form sends nothing.

**Approval state:** tranche 2 not approved. **Next Owner:** David Bloom. **Next Action:** confirm Stripe mode of Production's `STRIPE_SECRET_KEY`, the live webhook endpoint and signing secret, live price IDs, the support email and refund text; then approve tranche 2.

## Stripe Payment Migrations Applied to Production (APPROVAL-0069) — 2026-10-02

**Approval:** `APPROVAL-0069` (`DECISION-0094`). Three additive migrations applied to Production and checked one by one; ledger versions `20261002001232`, `…001253`, `…001308`; 5 existing webhook events backfilled to `processed`; entitlements unchanged (253); service-role-only access on the new objects; no new advisor findings. Dev evidence from the same day: `$1` coupon purchase and refund round trip pass on `stripe-webhook` v25 (PR #306). No function deployed, no secret, no Stripe or Lovable change.

**Approval state:** Hard Gate. Remaining Production steps are unapproved: six function deploys, live secrets, live Stripe setup, Lovable publishable key. **Next Owner:** David Bloom. **Next Action:** deploy the six functions with `--no-verify-jwt`; confirm refund/terms position and live Stripe setup.

## Seeded-Variant Runs: Status by Subject Documented; AP Biology Pilot Closed — 2026-10-01

**Doc:** `docs/research/SEEDED_ITEM_GENERATION_PROTOCOL_2026_09_30.md`, new section 10. **PRs:** #303 (merged), #305 (round-5 checks for the `005` variants, plus this documentation). No Production change in this entry; the Production changes of the day are `APPROVAL-0067` and `APPROVAL-0068`.

**Status (corrected 2026-10-03):** AP Calculus AB (Unit 1 complete, others sampled, Units 2-3 pilot started), AP Biology (this session's 16 drafts unloaded; a different 24-variant set published under `APPROVAL-0080`, overlapping), AP Chemistry (Units 1-3, 72 published) and AP Statistics (Units 1-3, 131 published) have had variant runs. AP Calculus BC, Physics 1, Physics 2, Physics C E&M, Physics C Mechanics and Precalculus have not. FRQs have had none. See protocol section 10.

**Session records (2026-10-02):** `docs/handoffs/SEEDED_QUESTIONS_SESSION_RECORD_2026_10_01.md` (generation, with the handoff packet) and, kept separate, `docs/handoffs/GRADING_NOTES_FROM_SEEDED_QUESTION_SESSION_2026_10_01.md`. **Open:** reconcile the two Biology variant sets, including published variants that use terms outside the CED (seeded-question record, addendum); label probe on this session's final text (input `probe_items_final.json`; only needed if the drafts are used); re-check of the 24 Calc variants against the repaired Calc seeds. (Seed topic relabelling was done by `APPROVAL-0079`.)

## AP Biology Seeded-Variant Pilot: Seed Audit, 14 Variants, `APBIO-MCQ-023` Repair Approved (APPROVAL-0067) — 2026-10-01

**Pilot:** `scripts/content-seed/apbio-seeded-pilot-2026-09-30/` (class A seeds only, Units 1-2, checkers `google/gemini-3.5-flash` + `deepseek/deepseek-v4-pro`, author Claude Sonnet 5.5). Reports: `S0A_AUDIT_REPORT.md`, `VARIANTS_MATH_CHECK_REPORT.md`. Total checker spend so far about $0.60.

**Findings:** 0 key errors anywhere (0 of 16 seed solves, 0 of 28 variant solves disagreed). Seeds: 1 of 8 had a defective rationale (`APBIO-MCQ-023` choice A). Variants: 2 of 14 had a real wording defect, all raised by DeepSeek only and hand-verified; patched and re-checked clean. Calc comparison and caveats are in the reports. Production's provisional topic tags on several seeds look wrong (for example `APBIO-MCQ-008` tagged 1.1 Structure of Water but about a protein mutation); the label probe will test this before any variant inherits a tag.

**Approval:** `APPROVAL-0067` covers the one-item Production repair of `APBIO-MCQ-023` choice A, tested first in a rolled-back run. **Applied 2026-10-01 and verified:** v2 published (v1 retired), only choice A's rationale changed, key still D, both labels restored and hash-fresh, Biology counts unchanged (118 published, 43 unit-gated, 69 validated). The 14 variants are not in any database. **Pilot closed 2026-10-01:** 16 variants (2 per seed incl. repaired 023), checker spend $2.45; all 16 ready for review preparation, with `021-v1`/`021-v2` conditional: the Product Owner directed on 2026-10-01 that signal sequences directing proteins to the ER are in the 2026-2027 AP Biology curriculum (not verified against the CED text; College Board site unreachable from the session), which released the hold. The repo's AP Biology fact pack appears to predate the 2026-27 curriculum and should be refreshed from the CED; final report `scripts/content-seed/apbio-seeded-pilot-2026-09-30/PILOT_REPORT.md`. **Follow-on, 2026-10-01:** after checking the CED (V.1, pp. 49-51) the Product Owner ruled that items stay within CED vocabulary. `021-v2` was rewritten at CED level; six more variants (`018-v1`, `018-v2`, `021-v1`, `022-v1`, `023-v1`, `023-v2`) were rewritten and checked (content clean; scope clean except two DeepSeek-only flags, `021-v1` and `022-v1`, adjudicated in the report); the `005` pair is held. Under `APPROVAL-0068` the five published seeds `APBIO-MCQ-005`, `018`, `021`, `022`, `023` were replaced with CED-vocabulary versions in Production (keyed letters unchanged, labels carried forward, counts unchanged). The variants still need a re-check against the new seeds.

## Stripe Production Cutover Checklist Drafted; Launch Shape Revised to a $1 Pilot Then 50% Off — 2026-10-01

**Decision:** `DECISION-0094`. **Doc:** `docs/product/STRIPE_PRODUCTION_CUTOVER_CHECKLIST_2026_09_30.md`. **Branch:** `claude/stripe-production-cutover`. Documentation only; no Production, Stripe, secret, or migration change.

Read-only Supabase audit (2026-09-30): Production runs `create-checkout-session` v21 and `stripe-webhook` v20 from August; `get-checkout-status`, `create-parent-payment-link`, `send-parent-payment-email`, and `create-post-purchase-addon` are not deployed; `app.stripe_customers`, `app.parent_payment_email_requests`, the `stripe_webhook_events` replay columns, and `app.claim_stripe_webhook_event` are missing (Dev has all). Deploying the new webhook before the three migrations would fail every student checkout. Dev's payment functions run `verify_jwt=false`; Production's `create-checkout-session` is `true`, so every deploy needs `--no-verify-jwt`. Not verified: live-mode Stripe state, Loops, the Lovable frontend.

**Approval state:** Hard Gate. Nothing for Production approved. **Next Owner:** David Bloom. **Next Action:** deploy `stripe-webhook` and `get-checkout-status` to Dev and run a $1 single-subject test-card purchase; confirm the coupon's Stripe mode; write the refund/terms position.

## Calc AB Repair Approved (APPROVAL-0066): `apcalcab-mcq-037` Key Letter, 10 Distractor-Rationale Repairs, Label Carry-Forward — 2026-10-01

**Approval:** `APPROVAL-0066` (`DECISION-0093`). **Scope:** 11 published AP Calc AB MCQs on Production; two scripts in `scripts/content-seed/reviewer-qa-remediation/` (`20260930_apcalcab_037_key_and_distractor_rationale_repair.sql`, `20260930_apcalcab_label_carry_forward.sql`), run back to back in one transaction.

**Why:** the seed audit found 10 of 20 audited published seeds with distractor rationales that do not produce their shown value (keys were all correct), and `apcalcab-mcq-037` with `canonical_answer_1 = 'A'` while choice B is the flagged-correct local maximum (grading reads `is_correct`, so students were graded correctly; the stored letter only reached reviewer snapshots). `TASK-0053` now shows the chosen distractor's rationale to students, so the false rationales were student-visible.

**Applied 2026-10-01** as one transaction: 11 items republished as new versions, 11 labels restored. Verified: one published version each, key letter equals correct choice (`037` now `B`), `is_correct` unchanged, no desync, no stale validated hashes; Calc AB counts unchanged (279 published, 196 unit-gated, 198 validated).

**Follow-up:** the 24 seeded Calc AB variants were written from some of these seeds; re-check them against the repaired seeds. About 150 other published MCQs remain unaudited (policy: audit a seed when it is varied).

**Tested first:** a rolled-back run on Production on 2026-09-30 passed every in-script assertion (11 repaired, key letter equals correct choice on all 11, `is_correct` unchanged, stem/choice sync, no duplicate published versions, labels restored and hash-fresh) and left Production unchanged.

## Seeded Generation Protocol, 136 + 24 AP Calc AB Items Published, Session Close — 2026-09-30

**Tasks:** none opened; two repair items handed off (see handoff). **Decision / Approval:** `DECISION-0093`, `APPROVAL-0065`.
**Environments:** Production writes (content only) on `pcntajvbdfqhbeewmdry`; Vercel AI Gateway calls. No code deploy, no migration.
**PRs:** #292 (Unit 1 batch + protocol v0.5 + TASK-0056 QA brief, merged); #293 (seeded generation protocol, merged); this close-out PR; a separate scripts/content-seed PR left for David.

### What happened

- Authored, checked and published 34 original + 102 variant Unit 1 items (136), then relabelled 8 to Unit 2; wrote the **seeded item generation protocol** (seed classes, clean-room rule, family spec, model-combination and roster-currency lessons).
- Ran a 16-variant cross-unit pilot, an 8-variant Unit 3 run and a blind Fable calibration; published 24 seeded variants.
- Findings: keys were never wrong; defects sit in distractor rationales; a second checker catches what the first misses; 10 of 20 audited published seeds had rationale defects (all keys right); `apcalcab-mcq-037` has `canonical_answer_1 = A` while choice B is flagged correct.

### Open at close

See `docs/handoffs/SESSION_CLOSE_2026_09_30_SEEDED_GENERATION.md`.

## PR Triage, TASK-0057 Opened, Stale Branches Retired — 2026-09-30

**Tasks:** `TASK-0057-SUBJECT-TAXONOMY-KEY-LINK.md` (opened, post-launch); triage across TASK-0041, TASK-0051, TASK-0056
**Authorization:** David, in session: "open the task for the three step fix and close 268"; "delete the three and open the preservation PR"; "merge 288"
**PRs:** #288 (TASK-0057, merged); #290 (Work Order N preservation, merged); #268 (closed unmerged). Others merged by David: #277, #278, #284, #285, #286.
**Environments:** read-only SQL and logs on Development and Production. **No code, migration or deploy.**

### What was checked

- **All open PRs merged cleanly together** in any order. The blockers were drafts, missing records and
  one unapplied migration, not conflicts.
- **TASK-0056 was already live in Production.** The ledger recorded `20260930120000/100/200`, and SQL
  confirmed that no answer or rubric column is selectable by `authenticated`/`anon` and that the public
  views no longer project them. The Lovable `review.functions.ts` at HEAD no longer reads `explanation`.
  Production `evaluate-attempt` is v70 (F2 fix).
- **PR #268's migration `20260929190000` was never applied** in either environment. Merging it would
  have left an unapplied migration on `main` (runbook Trap 7).

### Decisions taken in session

- **#268 closed, replaced by TASK-0057.** A `subject_id` link with no join moved onto it leaves the
  Biology key-mismatch trap live. TASK-0057 ships the link, the join migration and a CI guard together.
  Initial Production inventory: eight live functions on the path, and `get_home_start_queue` reads the
  taxonomy without `normalize_student_subject_key()`, so check it. Branch
  `claude/taxonomy-subject-id-link` is kept as step 1's starting point.
- **Four branches retired** after checking every file against `main`:
  - `codex/task-0049-open-hand-answer-key` (fully merged);
  - `claude/task-0051-skill-dimension-rollout` (superseded by `TASK-0050-SKILL-DIMENSION-ROLLOUT.md`);
  - `claude/student-hub-launch-plan-s3t7ua` (landed via #256; its only unique file was the batch
    `open-hand-item` that `DECISION-0086` removed, so it was not merged);
  - `codex/work-order-n-biology-serving-labels`, after its files were preserved on `main` as
    `docs/research/apbio_serving_labels_2026_09_24/` with a `STATUS.md` marking them historical and
    incomplete. They hold the only 48-item Production packet and two newly suspected Unit 3/Unit 4 label
    mix-ups, `APBIO-MCQ-031` and `-035`.

  The deletion was done by David; this session's GitHub access returns 403 on deleting branches it did
  not create.

**Remote after cleanup:** `main` and `claude/taxonomy-subject-id-link` only.

**Next Owner:** David Bloom. **Next Action:** none from this thread. TASK-0057 is post-launch.
`APBIO-MCQ-031`/`-035` should be checked by whoever next owns Biology serving labels.

## TASK-0056 Closed In Production; Launch Shape Set To Coupon Checkout — 2026-09-30

- **Answer-key exposure (TASK-0056, DECISION-0089):** three migrations applied to Dev (`APPROVAL-0063`) and
  Production (`APPROVAL-0064`), each recorded under its file version with a body MD5-identical to the file.
  The guard returns no rows on both. A real Production student is refused every protected column; safe
  reads and `select_practice_frqs` still work.
- **Caught by the guard:** the column-level revokes were no-ops, because `authenticated` held table-level
  SELECT. Fixed with `20260930120200` (the `20260824060000` pattern).
- **Reviewer portal:** a one-line Lovable edit (`783f6e04`, published) instead of the planned RPC switch,
  because the selected `explanation` was never used.
- **F2:** `evaluate-attempt` `.limit(1)` deployed by David; Production v70 verified byte-identical to `main`.
- **DECISION-0091:** Oct 2 stays free, via `/checkout` with a 100%-off coupon; runbook amended.
- **Open:** #284's $0 checkout path undeployed and never exercised; live click-through; 24-hour log watch;
  fresh independent QA (TASK-0051 stays Blocked until then).
- **Handoff:** `docs/handoffs/SESSION_CLOSE_2026_09_30_LAUNCH_READINESS_TASK0056.md`.

## TASK-0051 Independent QA → BLOCKED; TASK-0056 Opened, Step 1 Audit Done — 2026-09-29

**Tasks:** `TASK-0051-OPEN-HAND-UNIFIED-ANSWER-KEY.md` (QA; status set **Blocked**); `TASK-0056-ANSWER-KEY-DIRECT-READ-EXPOSURE.md` (opened, In Progress)
**Decision:** `DECISION-0089` (David, in session: "Yes to all three recommendations")
**PRs:** #277 (QA report + TASK-0051 status, ready for review); #278 (TASK-0056 + DECISION-0089 + INDEX row + step 1 inventory, draft)
**Environments:** Development: reads, rolled-back SQL test transactions, one scripted test user and one probe user (both deleted, SQL-verified clean). Production: read-only SQL and logs only. **No migrations, deploys or code changes anywhere.**

### What was found

- **TASK-0051's RPC holds.** A 12-case access matrix passed (anonymous, unentitled, expired entitlement, other subject, spoofed admin claims, draft item, retired pack, foreign session, staff with no exclusion row, idempotent exclusion). `evaluate-attempt`'s exclusion check is item-keyed, runs before any answer read, and fails closed. Dev and Production table parity holds; Production has no `get_open_hand_item`.
- **Blocker (F1):** any signed-in user can read answer keys directly: `app.content_item_versions.canonical_answer_1/2`, `explanation`, `item_package_payload` (`mcq_form.options[].correct`), and the `public.content_item_versions` / `public.frq_criteria` views. Production: 380 MCQ letter keys, 548 FRQ model answers, 391 explanations, 203 package `correct` flags, 2,896 rubric rows.
- **Also:** `evaluate-attempt` `.maybeSingle()` returns a permanent 500 once a student has exclusions on two versions of one item (F2). Dev still runs the stale `open-hand-item` v9 (F3).
- **Step 1 audit (TASK-0056):** the only reader that breaks on the revoke is the reviewer fallback in `review.functions.ts` (Lovable `56cae479` and `exam-buddy-wireframe`), which reads `explanation` with the reviewer's own login. Students, anonymous users, the marketing site `61dd6602` and all edge functions are unaffected. Production edge logs: every answer-column read used the service-role key.
- **In passing (pre-existing):** the app calls `get_chosen_distractor_rationale` and `get_graded_choice_feedback`, and **neither exists in Dev or Production** (errors swallowed). `graded-feedback.ts` already fails reading `is_correct`. `explanation` never reaches students.

### Limits of this session's verification

This container's proxy replaces the caller's `Authorization` header on the Dev host, so no real-JWT HTTP call was possible. Access checks ran as SQL with `role` and `request.jwt.claims` set, inside rolled-back transactions. `scripts/open_hand_e2e_dev.mjs` could not be independently reproduced past the first user-authenticated call.

**Next Owner:** David Bloom. **Next Action:** approve TASK-0056 step 2: (a) Dev apply of `public.get_review_item_version` (SECURITY DEFINER, assignment- or admin-gated), and (b) the Lovable edit switching `review.functions.ts` to it. Then approve the step 3 revoke migration for Dev, and separately for Production.

## MCQ Feedback Rebuilt From The Chosen Distractor; Deployed To Production — 2026-09-29

**Task:** `TASK-0053-DISTRACTOR-SPECIFIC-MCQ-FEEDBACK.md` (launch gating); `TASK-0054-REFERENCE-CONTENT-MODEL.md` opened
**Authorization:** David, 2026-09-29, in-session: "Do all three in that order", then "Deploy to prod"
**PRs:** #264 (code, merged), #265 / #266 / #267 / #269 (docs, merged), #268 (migration, parked draft), #270 (smoke test, open)
**Environments:** Development and **Production** — `evaluate-attempt` v67, CLI with `--workdir`

### What was wrong

Every wrong MCQ answer produced one fixed string, on every item, in every subject:
"Select the answer choice that matches the published correct answer." It restates the definition of
"wrong", and it is the only thing a student gets back from an MCQ. Measured on Production: 34 of 63
recorded `highest_value_gap` rows were that placeholder, across 19 items which carry 76 authored
distractor rationales the code never read.

### What shipped

Feedback is composed from what the item already knows — orient (skill via `content_item_cells` →
`taxonomy_skills`, unit via `taxonomy_topics`), point (the **chosen** distractor's authored
rationale), redirect (a question, never a correction). The shape rotates across four variants keyed
by an FNV-1a hash of item version × chosen key: stable on re-read, different across items. The
correct choice's rationale is never read, since the item may be served to the same student again.

Deliberately not approximated: naming what the student got right first (a 1-point MCQ has no partial
credit to praise) and immediate re-practice (a serving decision, not a string).

### The finding that decided scope

**This was never blocked on content.** All 783 published MCQ items across all ten subjects carry
authored rationales on all 2,349 distractors — zero gaps. Coverage is 100% at deploy, with no
authoring and no model spend. It was also not blocked on `TASK-0050`: the orienting cue degrades
independently.

### Corrections made in-session, all published

1. **406 → 304** skill-labelled MCQs (PR #266). `content_item_cells.skill_code` is nullable, so an
   `exists(...)` test counted topic-only tags as skill tags. Only Statistics has any skill labelling.
2. **"Schema drift" was wrong** (PR #267). Migration `20260927004500` made topic-only tagging
   deliberate, and had already found and guarded the MATCH SIMPLE hazard I reported as a discovery,
   via `content_item_cells_topic_fkey`. I had read the migration that *created* the table rather than
   the newest one touching it.
3. **Two of three "traps" were not defects.** The nullable `skill_code` is by design; the missing
   `authenticated` grant on `content_item_cells` is INV-1 ("store fine, present coarse") and granting
   it would undo a security decision. Only the subject-key namespace split is real — parked as draft
   PR #268 because nothing in the shipping path consumes it.

David's read on the session: "I feel like we are learning but also getting off track." Accurate — of
five PRs opened, only #264 was on the critical path.

### Open

- `scripts/student_grade_smoke.mjs` (PR #270) is written but **has never been run**. Dev has no
  secret key available locally (the one in `.secrets.env` is Production-only: Dev 401 / Prod 200) and
  Dev requires email confirmation. David will run it against Production immediately before handing
  the app to test students.
- `TASK-0054`: reference content carries no skill reference and no FK to the taxonomy; AP Physics C:
  E&M is short 14 topics in both `topic_explainers` and `topic_point_briefs`.

**Next Owner:** David Bloom.
**Next Action:** run the smoke test before test students; then TASK-0051/0052 (Open Hand).


## TASK-0039 BYOQ Live in Production, Phases 1–2 — 2026-09-28

**Task:** `TASK-0039-BYOQ-PRODUCTION-OPERATIONAL.md`
**Approval:** `APPROVAL-0058` (David, 2026-09-28: "get task 0039 into production"); defaults in `DECISION-0084`
**Branch:** `claude/cramapple-task-0039-wfgs2q`
**Status:** Phases 1–2 live in Production. Phase 3 blocked.

**Shipped to Production (`pcntajvbdfqhbeewmdry`):**

- Migrations `task0039_byoq_core` and `task0039_byoq_hardening`: `app.byoq_owners`, `byoq_items`,
  `byoq_responses`, `byoq_capture_pairing_tokens`, `byoq_attachments`, plus the claim, bind, and expire
  RPCs, the Vault-backed purge invoker, two pg_cron jobs, and the 20 MB cap on `learner-uploads`.
- Edge function `byoq` (verify_jwt off, own auth). Deployed source diffed against the built bundle;
  the only differences are rendered `\u` escapes.
- Vault secrets `byoq_purge_token` (generated inside the database, never seen by the session) and
  `byoq_function_url`.
- Lovable App (`app.cramapple.com/byoq`, `/byoq/new`, `/byoq/capture`, `/byoq/$itemId`) and the
  Marketing homepage section linking to the app. Both were published, and the live pages were
  confirmed by fetching them from Production's pg_net.

**Verification:**

- 33 Deno tests for BYOQ (65 including capture-pairing), with clean lint.
- SQL integration assertions pass on Dev.
- 24/24 live smoke checks on Dev after hardening.
- Production: CORS for both domains, `list_subjects`/`list_topics`, `start` creates no owner, a bad
  purge token gets 403, and the Vault cron purge returns 200. A full write round trip (create →
  answer text masked → remove → confirm → unscored save → delete) passed, and the test owner and pg_net
  responses were deleted afterwards. The App's 445 Vitest tests pass.
- Security advisors show only expected INFO for no-policy tables. There is one new WARN (`pg_net` in
  `public`), which is not relocatable and is accepted.

**Not done / open:**

- A real-phone QR capture test on Production, since the session's sandbox cannot reach the public web.
- `BYOQ_IP_HMAC_KEY` is unset, so IP hashing falls back to the service-role key. This works, but a
  dedicated secret is preferred.
- The Dev temporary functions `byoq-smoke-runner` and `byoq-ip-echo` were redeployed as inert 410
  stubs, because the tooling cannot delete them.
- Phase 3 is blocked on its design doc's open decisions.


## Content-Pipeline QA Session Close: PR #235 Verified, Biology Gap Closed, Unlock Status Checked — 2026-09-27

**Task:** Independent QA of `codex/task-0042-content-pipeline-remediation` / PR #235
**Status:** Session closed. One real gap found and fixed; one real gap found and left open.

**What this session did.** Read the Codex handoff doc cold, then re-verified its own claims against
live Production (`pcntajvbdfqhbeewmdry`) rather than trusting the doc or the later PR body. Checks
run and their results:

- **216-row DECISION-0066 freshness re-audit** (`20260927112814_reaudit_decision0066_single_unit_promotions.sql`):
  confirmed applied; spot-checked two of the 216 recovered hashes against the original pre-promotion
  migration (`20260925220100_apcalcab_serving_labels_batch_01.sql`) to rule out circularity; live query
  showed all 216 still `validated`, matching the audit CSV's 0-reverted result exactly.
- **Five-row difficulty correction** (`predict`/`integrate` Medium→Hard): confirmed all five rows are
  `Hard` in Production.
- **Runner hardening** (`extend_serving_labels_mcp.mjs`): confirmed the diff adds genuine resume-match
  guards (subject/version/content-key/hash) and a self-test fixture, not just cosmetic changes.
- **PR #235's 27-of-141 blind multi-unit third review**: confirmed via an exact `validation_decisions.notes`
  match ("blind independent multi-unit third review by anthropic/claude-haiku-4-5... Candidate label
  withheld from the review prompt.") and `app.servable_items_census_selftest()` returning 0 mismatches.
- **One claim found overstated**: PR #235 said difficulty coverage was "complete for all ten subjects."
  Biology was actually 43/65 MCQ and 75/95 FRQ.

**Biology gap: traced and closed same session.** Origin: the one-shot 2026-09-24 difficulty load
(`20260924240000_apbio_content_item_difficulty_load.sql`, work order J.0) covered exactly the 118
items live at that time and hard-asserted that count. 42 items (20 FRQ + 22 MCQ, all authored
June/July 2026) later moved to `published` through ordinary editorial review with no backfill
trigger — corpus growth outrunning a one-time load, not a repack (Biology has had one
`exam_pack_version` since 2026-06-27) and not a defect in TASK-0042, which never touched Biology
(DECISION-0063/0072 route it to the flat/practice path). Closed via
`20260927170500_apbio_difficulty_gap_closure.sql`: applied DECISION-0061/0065's approved task-verb
method, replicated from `scripts/taxonomy/build_remaining_difficulty_artifacts.py`'s regex
classification, directly in SQL (Postgres regex needs `\y` for a word boundary, not `\b` — `\b` is a
literal backspace in Postgres's ARE dialect and silently matched nothing until caught). Verified
post-apply: Biology 95/95 FRQ, 65/65 MCQ. Committed and pushed to `main` (`b9ed6ea5`).

**Unlock status, checked directly against the real selector before closing.** Ran
`app.servable_items_census_selftest()` grouped by subject and probed unit:

| Subject | Units probed | Units returning 0 |
| --- | ---: | ---: |
| AP Biology | 8 | 0 |
| AP Calculus AB | 8 | 0 |
| AP Calculus BC | 10 | 0 |
| AP Chemistry | 9 | 0 |
| AP Physics 1 | 8 | 0 |
| AP Physics 2 | 7 | 0 |
| AP Physics C: E&M | 6 | 0 |
| AP Physics C: Mechanics | 7 | 0 |
| AP Precalculus | 4 | 0 |
| AP Statistics | 7 | **2** |

At first read this looked like AP Statistics was not fully unlocked (2 of 7 probed units returning
0 rows), and was recorded as an open item. **Correction, same session:** re-diagnosis found this was
a false alarm. `app.servable_items_census_selftest()` reported `unit=1` and `unit=5` twice each for
AP Statistics — once against the real live exam-pack version, once against a **retired** pilot pack
(`7c5a2975-8f0e-45b9-8fcc-7ec9b8d81ada`, created 2026-08-24, retired 2026-09-25). This is the
pre-existing, already-documented limitation in `docs/content/CONTENT_PIPELINE_LIVE_CENSUS_2026_09_26.md`
("`app.servable_items_census()` currently scans every exam pack version without filtering
`exam_pack_versions.status` or `retired_at`... a reporting-helper defect, not a recurrence of the
dual-published pack hazard") — not something this session introduced. Confirmed by calling
`public.select_unit_gated_practice_items` directly against both AP Statistics pack version IDs:
the live pack (`548f06be-ccf4-426d-b82b-b424137a4438`, never retired) returns 19 items for unit 1
and 48 for unit 5, matching the correct probe rows exactly; only the retired pilot pack returns 0,
which is correct — real students never see it.

**Corrected conclusion: all 10 subjects are fully unlocked.** No further action needed for AP
Statistics.

**Next Owner:** David Bloom
**Next Required Action:** none. Optionally, harden `app.servable_items_census_selftest()` itself to
filter out retired/non-live exam-pack versions so a future run doesn't require re-diagnosing the
same known artifact — tracked as a nice-to-have, not a blocker.

## AP Biology Difficulty Gap Closed — 2026-09-27

**Task:** Follow-up QA on PR #235 (TASK-0042)
**Status:** Applied to Production, verified
**Migration:** `20260927170500_apbio_difficulty_gap_closure.sql`

PR #235 claimed difficulty coverage was "complete for all ten subjects." A live query against
Production found this overstated for Biology: 43/65 MCQ and 75/95 FRQ had a difficulty row, not
118/118.

**Origin.** The one-shot 2026-09-24 difficulty load
(`20260924240000_apbio_content_item_difficulty_load.sql`, work order J.0) covered exactly 118
items — every Biology item that was current-latest-published at that time — and hard-asserted
that count. Since then, 42 items (20 FRQ + 22 MCQ, all authored June/July 2026) moved to
`published` status through ordinary editorial review, with no corresponding difficulty backfill.
Biology has had exactly one `exam_pack_version` since 2026-06-27 (never retired or re-cut), so
this is corpus growth outrunning a one-time load, not a repack and not a defect in that migration.
TASK-0042 never touched Biology (DECISION-0063/0072 route it to the flat/practice path, not gated
by difficulty), so this gap was never in that task's scope.

**Fix.** Applied DECISION-0061/0065's approved task-verb method to the 42 gap items, using the
identical regex classification already implemented in
`scripts/taxonomy/build_remaining_difficulty_artifacts.py`: FRQ items take the modal criterion
tier (over `app.frq_criteria.learner_facing_text`/`evidence_requirements`/`minimum_fix`) with an
upward tie-break; MCQ items classify on the item stem; items with no decisive verb cue default to
Medium/`calibrated_judgement` (the same undiscriminated-middle-band fallback the approved method
uses elsewhere), never a fabricated ratio. No authored difficulty value existed for any of the 42
items (no `content/item-packages/ap-biology/` directory, no `prompt_json.difficulty` on any of
them), so every row is freshly classified. The migration guards scope (published item, published
non-retired pack, current version match) and refuses to overwrite any row that already has a
difficulty value.

**Verified post-apply:** Biology is now 95/95 FRQ and 65/65 MCQ with a difficulty row (26 Hard, 10
Medium, 6 Easy). `app.servable_items_census_selftest()` shows 0 mismatches system-wide.
Source/audit trail: `docs/research/apbio_difficulty_gap_closure_2026_09_27/APBIO_DIFFICULTY_GAP_CLOSURE_2026_09_27.csv`.

**Next Owner:** David Bloom
**Next Required Action:** none — this closes the gap flagged in the PR #235 review. No further
action needed unless Biology's corpus grows again without a difficulty backfill trigger, which
remains a standing "silent absence" risk (nothing currently connects a publish-status transition
to the difficulty/label pipelines for any subject).

## TASK-0042 Content Pipeline Done — 2026-09-27

**Task:** TASK-0042
**Approval:** `APPROVAL-0056`
**Decision:** `DECISION-0082`
**Status:** Done

The live audit found 141—not 49—current, fresh multi-unit two-model agreements across all ten
subjects. With David's explicit external-transfer approval, all 141 packets were sent through Vercel
AI Gateway to `anthropic/claude-haiku-4-5` in a blind review that withheld the candidate label.
Results: 27 exact full-label confirmations, 66 disagreements, 48 rubric/scope holds, 0 call errors.
Applied `20260927184534_task0042_promote_blind_third_review_confirmations`; exactly 27 labels moved
to `validated`, while all 114 non-confirmations remained unpromoted.

Fresh current validated counts are Biology 23, Statistics 67, Calculus AB 36, Chemistry 65,
Precalculus 53, Calculus BC 45, Physics 1 85, Physics 2 50, Physics C Mechanics 50, and Physics C
E&M 75. `app.servable_items_census_selftest()` returned zero mismatches for all subjects.

David decided the nine non-Biology subjects do not need fixed quantity targets. The continuing
operating rule is to maximize safely usable current published inventory without weakening freshness,
rubric, or independent-review gates. This resolves the final policy blocker and closes TASK-0042.

---

## TASK-0042 Content-Pipeline QA Remediation Applied and Independently Verified — 2026-09-27

**Task:** TASK-0042 content-pipeline QA remediation
**Approval:** `APPROVAL-0056`
**Production:** `pcntajvbdfqhbeewmdry`
**Status:** Superseded snapshot — core remediation passed; final closeout is recorded above

Reconstructed original generation hashes for all 216 labels promoted by `20260926233500`.
Applied `20260927112814_reaudit_decision0066_single_unit_promotions`: 216 verified fresh,
0 reverted, 0 unverifiable. Applied the five-row DECISION-0061 correction (`20260927112232`)
and confirmed all five rows are Hard.

Hardened `extend_serving_labels_mcp.mjs` with exact resume matching, pre-write live-state/hash
guards, newer-label protection, the correct exporter filename, and a passing no-network fixture.
Applied guarded label migrations for E&M (96), Calculus BC (98), and Mechanics (76); Mechanics'
76 genuine model-call failures were retried, yielding 58 agreements and 18 holds. Promoted only
fresh single-unit agreements: E&M 71, Calc BC 36, Mechanics 45. At this intermediate snapshot, the
known 49 multi-unit agreements remained provisional pending DECISION-0066 third review; the later
live audit found and reviewed 141 across all subjects, as recorded in the Done entry above.

Post-write `app.servable_items_census_selftest()` had no mismatches for these subjects.
Independent Claude QA verified original hash provenance, ledger state, five difficulty rows, runner
guards/fixture, 216/216 validated state, and live counts (E&M 77, Mechanics 49, Calc BC 40).
Full evidence: `docs/product/CONTENT_PIPELINE_CODEX_HANDOFF_2026_09_27.md`.

During reconciliation with newer `main`, the locally chosen approval ID was found to collide with
TASK-0044's existing `APPROVAL-0051`. TASK-0042 was renumbered to `APPROVAL-0056`; Production
migration `20260927181002_correct_task0042_approval_note_provenance` changed exactly 152 affected
validation-decision notes, with 152 corrected and 0 old-ID notes remaining. Label state was unchanged.

**Superseded open items:** the independent third review and quantity policy were subsequently resolved
by the Done entry above and `DECISION-0082`. TASK-0042 is Done.

---

## `cell_scoped` No-Matching-Content Bug Resolved — Stale Edge Function Deploy — 2026-09-27

**What & why.** The prior session paused mid-diagnosis (per its own "SESSION CLOSE" section in
`LAUNCH_PLAN_STUDENT_HUB_2026_09_26.md`) on a bug where `student-session-items`'s `cell_scoped` mode
returned `no_matching_content` for every AP Statistics topic David tried live, despite 203 published
MCQs genuinely present for his exam pack version. This session's first and only task was to pick that
diagnosis back up.

**Root cause.** Not a query or data bug — a stale Edge Function deploy. Pulled the actual deployed
source for `student-session-items` from both Supabase projects via `get_edge_function` and compared it
directly against `main`:

- Neither deployed function had the `cell_scoped` mode at all — no branch for `input.mode ===
  "cell_scoped"`, no read of `content_item_topic_resolution`, and `MAX_ITEMS` was still `20` (the pre-
  taxonomy-rationalization value; `main` has been `999` since 2026-09-26 21:24 ET).
- `list_edge_functions`' `updated_at` confirmed neither project had redeployed this function since
  before commit `912699b2` ("Phase 2: add cell_scoped mode to student-session-items," 2026-09-26 22:15
  ET) — Production last deployed 19:54 UTC that day, Dev 18:48 UTC, both earlier than the commit.
  `git push` does not deploy a Supabase Edge Function; someone has to run the deploy separately, and
  nobody did after that commit (or the later `MAX_ITEMS` change) landed.
- Consequence: the stale function silently treated the unrecognized `mode: "cell_scoped"` as its
  default `"frq_only"` path. For David's real session shape (`ap_statistics`,
  `practice_format: "targeted_drill"`), that path calls `select_ordinary_combined_practice_items` —
  confirmed directly against Production (`execute_sql`, `exam_pack_version_id
  7c5a2975-8f0e-45b9-8fcc-7ec9b8d81ada`) that this RPC returns **zero rows** for that exact pack/format.
  That is the literal source of the `no_matching_content` — failing before any client-side topic
  filtering ever ran, exactly as the paused diagnosis had narrowed it down to.
- The data itself was never the problem: 203 published MCQ `content_items` and 203 matching published
  `content_item_versions`, reconfirmed identical on Dev.

**Side finding, fixed first.** 5 tests in `supabase/functions/student-session-items/index_test.ts` were
silently broken — they seeded `practiceRows` against the suite's default `ACTIVE_SESSION` fixture
(`practice_format: "mcq"`, `ap_statistics`), but that exact session shape has routed to
`select_ordinary_combined_practice_items` (seeded via `statisticsRows`, not `practiceRows`) since
"Unblock AP Statistics MCQ serving path." Bisected with a throwaway `git worktree` at `912699b2`: all 23
tests existing on that commit passed, because the ap_statistics/`mcq` combined-selector branch and the
topic/cell-resolution tests were developed on two separate lines that only became inconsistent once
both merged into `main`. Fixed by renaming the 5 affected mocks' `practiceRows` → `statisticsRows`,
matching the pattern the file's own passing Statistics tests already use elsewhere. Test-only — no
runtime code touched. Commit `707a1c52`. `deno test`: 26/26 pass; `deno check`: clean.

**Fix.** Redeployed the current `main` `student-session-items` function (`index.ts` plus its 5
unchanged `_shared/*.ts` dependencies) to Dev first, then to Production after explicit confirmation from
David via an `AskUserQuestion` prompt (this touches Production). Verified both deploys report the exact
same `ezbr_sha256` (`f3e6ebb3...`) — byte-identical bundles on both environments. `get_advisors`
(security) shows no new findings introduced by the deploy. Dev: function version 8 → 9. Production:
function version 24 → 25.

**Live verification: done.** David re-tested on `app.cramapple.com` immediately after the Production
deploy and confirmed content now loads. `cell_scoped` MCQ serving is healthy in Production again — this
bug is fully closed, no open follow-up.

**Process note.** Worth carrying forward: after a meaningful Edge Function change, confirm the function
actually redeployed — `list_edge_functions`/`get_edge_function`'s `updated_at` versus the relevant
commit's timestamp is a fast, cheap check. This particular gap sat live for most of a day before
anyone hit it in practice.

**Next Owner:** whoever resumes `LAUNCH_PLAN_STUDENT_HUB_2026_09_26.md`'s IDG-5 live-grading
verification, now unblocked. **Next Action:** attempt the real live grading round trip (sign-in →
submit → grade → `attempts` row update) IDG-5 has been waiting on. Full technical detail in that doc's
"RESOLVED, 2026-09-27" section.

---

## Session-Route Retirement Re-Audited — Two Real `public.sessions` Bugs Found — 2026-09-27

**What & why.** The prior session's "CORRECTION" entry (see that section, and the paused route-retirement
decision in `LAUNCH_PLAN_STUDENT_HUB_2026_09_26.md`) had found `TopicHome`'s Resume link and a subject
guard both still reference `/session/mcq`/`/session/frq`, and stopped short of executing retirement,
instructing a full re-trace of every Start *and* Resume entry point (not just Start) before raising the
question again. This session did that trace, reading the live Lovable source directly
(`56cae479-f7c9-4988-b536-56538c38ee4e`) rather than relying on the prior audit's own conclusions.

**Finding 1 — the Resume banner can never render.** `src/lib/home.functions.ts`'s `loadStudentHome`
computes `liveSession` (which drives `TopicHome.tsx`'s "Live session / Resume" section) from
`supabase.from("sessions").select("id, started_at, ended_at, goal").eq("user_id", userId)`. Checked
Production's actual schema via `information_schema.columns`: `public.sessions` (the table this hits,
since no `.schema("app")` is specified) has `student_id`, not `user_id`, and no `goal` column at all.
PostgREST errors on both bad references; the code only destructures `{ data: sessionRows }`, no `error`
check, so the failure is silently swallowed and `sessionRows` defaults to `[]`. `liveSession` is
therefore always `null` — the Resume banner the prior correction relied on as evidence of live reachability
literally cannot render, for any student, today.

**Finding 2 — the identical bug, independently, in a second file.** `src/routes/session.setup.tsx` — a
third, separate "start a session" UI, reachable live via `TopicHome` → "Learn more" →
"Start practicing" on the topic-explainer route — queries the same `public.sessions`/`user_id` shape to
compute `hasPriorSession`/`lastSummary` for its own "Returning student context" banner. Same silent
failure, same always-empty result. This is the identical bug *class* (wrong table/column reference, error
silently swallowed via `?? []`) as the `attempts` bug already documented and fixed earlier this week —
recurring unnoticed in an adjacent query nobody had re-checked.

**Finding 3 — the guard-based path is not confirmed either.** `session.index.tsx` (bare `/session`)
calls `useStudentGuard()` with no options — the subject-agnostic default — not `requireSubject: true`,
despite the guard's own JSDoc claiming it is "mounted on any `/session/*` route." That contradicts the
prior correction's second cited reachability path. `_ux.topic.tsx` does have its own, separate,
locally-implemented subject check that lands on `/setup/subject`, so that specific route stays reachable
from `/topic` — but `/topic` itself sits downstream of `/setup`, not upstream of the real default flow.
Not exhaustively ruled out: whether some other, unchecked route still invokes the guard with
`requireSubject: true`.

**Mapped the fuller cluster while tracing this**, confirming it is larger and internally consistent:
`/setup` → (`INTENT_ROUTES`) → `/session/mcq`, `/topic`, `/check-work`, `/bring-question`; `/topic` →
`/session/mcq`; `/session/uncertain` → `/session/mcq` + `/session/frq`; `/setup/subject` → `/setup`.

**Net effect.** The practical answer to "is this cluster reachable from real live traffic today" now
leans toward no — but because of two concrete, fixable frontend bugs, not because the routes are
provably dead by design. This is a different, more actionable situation than either the original audit
(called it dead) or the immediately-prior correction (called it definitely live): neither had confirmed
what a real student's browser actually does, only what the code contains.

**Not resolved — flagged, same as every scope question in this doc.** Fixing the two `public.sessions`
bugs would restore "Resume your session" and "Returning student," which also restores live reachability
of `/session/mcq`/`/session/frq` via the Resume path — the opposite direction from retirement. Whether to
fix the bugs, retire the cluster as currently-unreachable, or sequence both, is David's call.

**Next Owner:** David Bloom. **Next Action:** decide whether to fix the `public.sessions` query bugs
(small, contained — point both at `app.learning_sessions`/`public.learning_sessions`, which has the
correct columns and is what the live grading path already writes to), retire the session-route cluster
now that it has no confirmed live entry point, or both in sequence. Full detail in
`LAUNCH_PLAN_STUDENT_HUB_2026_09_26.md`'s "AUDITED, 2026-09-27" section.

---

## IDG-5 and `DECISION-0074` Mastery Capture Both Confirmed Live — 2026-09-27

**What & why.** Immediately after the `cell_scoped` fix above went live, David submitted a real answer
at `https://app.cramapple.com/session?minutes=10&mode=quick&unit=1&intent=review&topic=%221.13%22`, and
it graded. This is the real, non-synthetic grading round trip
`LAUNCH_PLAN_STUDENT_HUB_2026_09_26.md`'s "Exact next step" had been waiting on all session — IDG-5's
DB-scratch test was strong evidence the trigger fix worked, but not the same as a real HTTP round trip.
Queried Production directly rather than trusting the UI alone.

**`app.attempts` (IDG-5).** Attempt `d7663902-a06f-4423-8471-706fd4765d8e`, this session's own account
(`f5a26c6b-3566-4d58-9e97-979fbb947564`): `started_at` 18:29:26 UTC → `submitted_at` 18:30:04 →
`graded_at` 18:30:05.542 — under 1.5 seconds through the service-role grading write.
`status`/`result_state` both `"graded"`, `score_points: 0`, `score_possible: 1`,
`assistance_state: "independent"` (no pre-submit hints). This is the first confirmation, on real
traffic rather than a scratch row, that `attempts_prevent_client_grading_truth_update` (fixed last
session — a dead PostgREST GUC check) actually lets a real grading write land in Production. IDG-5 is
now closed.

**`app.student_cell_state` (`DECISION-0074` mastery capture).** A row was created for topic `1.13`,
skill `2.A`, same account: `last_event: "incorrect"` (matches the 0/1 score), `mastery_mcq_correct_count:
0` (correctly not incremented on a miss), `last_attempt_id` correctly linked back to the attempt above,
`next_due_at` scheduled ~24h out with `due_reason: "direct_miss"`, `rule_engine_version:
"cell-state-1.0"`. This is the first live confirmation of the entire `DECISION-0074` mastery-capture
backend built last session (schema → `assistance_state` derivation → mastery counters) — previously
verified only by 10 new unit tests and one synthetic before/after event on a Dev attempt, never by a
real student answer until now.

**Net effect.** Both of last session's two biggest unverified builds — the grading-truth trigger fix and
the full mastery-capture pipeline — are now confirmed working end to end on real Production traffic, in
the same single round trip.

**Not tried this pass.** A correct answer (only a miss was observed), a second topic/cell, and the FRQ
attempt path all remain unverified against real traffic — worth trying if more confidence is wanted
before calling the grading path fully proven.

**Next Owner:** open. **Next Action:** none required to consider IDG-5 or the mastery-capture build
closed; the untried paths above are optional further confidence-building, not blockers. Full detail in
`LAUNCH_PLAN_STUDENT_HUB_2026_09_26.md`'s second "RESOLVED, 2026-09-27" section.

---

## Documentation Cleanup — Architecture/Design Single Source of Truth — 2026-09-27

**What & why.** David asked for a docs-only cleanup: make the *current* architecture/design state easy
to find and the *legacy* state clearly out of the way, without destroying history and without making any
product decision. Diagnosed problem: the authoritative rebuild plan (`APP_REBUILD_MIGRATION_PLAN.md`)
carried no Task/owner/DECISION number and its §11 "open decisions" were largely resolved 2026-09-26
without in-place updates; canonical design docs still asserted the reversed fixed-plate rule; "Course
Mode" and "Open Hand" vocabulary was overloaded; three design systems (orange canonical vs. emerald v2
vs. red "Project-Crux") were in circulation.

**Verified against live systems (not docs), 2026-09-27:**
- Responsive-frame change is real: Lovable `56cae479` commit `44a0f59e` removes `width/height`/
  `overflow:hidden` from `Plate.jsx`, drops `--plate-height`, adds `--plate-min-width` + 899/520px
  breakpoints, and writes an `AGENTS.md` documenting the fluid plate. Read the diff directly.
- Canonical design (orange/light/Bungee/square) confirmed live in `56cae479`'s screenshot; the red
  "Project-Crux" palette is not what shipped.
- Two-repo hazard confirmed: the 6 frontend commits cited across docs are absent from this git repo;
  only Workstream E `1a6e8404` and follow-on `9fc0f75b` (plus the taxonomy commits) are in-repo.
- Live DNS: both domains on Cloudflare/Lovable (`185.158.133.1`); `app.cramapple.com` currently
  301-redirects to `cramapple.com` (flagged for re-confirmation of intended launch behavior).
- Decision numbering: highest is `DECISION-0074`; next free is `DECISION-0075`.

**Changes (docs-only):**
- **New:** `docs/product/ARCHITECTURE_AND_DESIGN_DECISIONS_CURRENT.md` — the canonical decided-vs-open
  one-pager (17 DECIDED rows each cited, 15 OPEN rows each with owner). Carries a blank
  DECISION-#### + owner slot for David to ratify.
- **New:** `docs/INDEX.md` — canonical source-of-truth per topic, the `STATUS:` header convention, and
  the superseded/historical list.
- **Annotated in place (no silent rewrites):** `new_design/VISUAL_IDENTITY.md` + `README.md`
  (fixed-plate rule superseded → responsive); `APP_REBUILD_MIGRATION_PLAN.md` (doc-level pointer +
  §11 rows 1/3/7/11/17/18/19/20/23/24 marked resolved/superseded with citations, genuine opens kept;
  §9.1 + Decision-1 prose annotated); `DESIGN_SYSTEM_CUTOVER_PLAN.md` (stale palette/"Project-Crux"
  banner); `USE_MODES_STRATEGIC_RECONCILIATION.md` + the three active `teaching/COURSE_MODE_*` specs
  (vocabulary banners: one mode "Learn"; components ≠ mode).
- **Entry-point pointers:** `PROJECT_SETUP.md` (ungoverned — done) and
  `team_charter/CRAMAPPLE_SESSION_START.md` (governed — **flagged PENDING RATIFICATION**, per David's
  choice this session to edit both and flag the governed one).

**Governance — resolved same session (David's calls):**
1. **Ratified** `ARCHITECTURE_AND_DESIGN_DECISIONS_CURRENT.md` as **`DECISION-0075`**, owner David Bloom;
   the two pointers in the governed `CRAMAPPLE_SESSION_START.md` are ratified and kept. Recorded in
   `DECISIONS_LOG.md`.
2. **Legacy-file handling: Option A (annotate-in-place, no move).** No `docs/legacy/` tree created;
   banners + `docs/INDEX.md` do the job. Proposal doc marked DECIDED.

**Status:** Committed via PR (docs-only, 2026-09-27). No product/design decision was created or reversed;
no files moved or deleted. The three pre-existing uncommitted files (`APP_LAUNCH_READINESS_INDEX`,
`LAUNCH_PLAN_STUDENT_HUB`, `LAUNCH_RUNBOOK`) were left untouched, not included in the PR.

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
