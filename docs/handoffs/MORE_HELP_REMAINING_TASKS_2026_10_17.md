# More help: remaining tasks to support every in-scope subject (handoff, 2026-10-17)

STATUS: CURRENT as of 2026-10-17 ~04:30 UTC. Written so a new session can execute without re-analysing. Facts below were re-verified read-only on 2026-10-17 unless marked **[unverified]**.
Supersedes the *state* sections of `SESSION_CLOSE_2026_10_16_MORE_HELP_STATISTICS_LAUNCH.md` (its procedures and traps are still right). Start with `AGENTS.md`, then `docs/INDEX.md`; do not re-derive anything marked VERIFIED. Companion records: `qa/MORE_HELP_PER_SUBJECT_ROLLOUT_RUNBOOK_2026_10_16.md` (steps), `qa/MORE_HELP_UNSUPPORTED_SUBJECTS_U1_3_GAP_CATALOG_2026_10_16.md` (gap evidence, section 7-8 = leak protection), `qa/CONTENT_CREATION_ARMS_TEST_PHYCM_2026_10_17.md` (content-pipeline test), approvals `APPROVAL-0184..0188` in `docs/activity_log/`.

## 1. Where things stand (VERIFIED)
| Item | State |
| --- | --- |
| Production `more-help` | **v5** (deployed 2026-10-17 01:49 UTC from PR #478 source). Contains: unit gate, FRQ stated-conclusion rules (direction/value/law; verdict prompt-only), MCQ pre-submit coaching boundary, **runtime answer-leak check** (Gemini 3.8 Flash judges each pre-submit MCQ draft against the server-held key) with **up to 2 reviewer-guided rewrites**, fail-closed on checker outage. Unauthenticated POST returns 401. |
| Production policy table | AB, BC, Chemistry: all units. Statistics, **Physics 1, Biology**: units 1-3. Nothing else. |
| App (ap-prep-blueprint) | PR #34 merged (`ap_biology`, `ap_physics_1`, units 1-3) at `cbaa4ac`; Lovable latest commit = `cbaa4ac`; **publish was requested via the Lovable tool (deployment f9bf1815..., status pending) and is [unverified]**. Owner logged in on his phone and saw the More help link on Physics 1; that test was on v4 and one conceptual MCQ (`apphy1-mcq-004`) was refused. v5 repairs that question in an offline replay (6 of 6) but it has **not been re-tried in the live app**. |
| Content loaded 2026-10-16 (APPROVAL-0186) | Biology 32 MCQs (topics 2.2, 2.4, 2.5, 2.9) and Physics 1 20 MCQs (1.1, 1.3, 2.2), all verified. Biology 2.2/2.4/2.5/2.9 now 8 practice MCQs each; Physics 1 1.1 = 8, 1.3 = 4, 2.2 = 8. |
| Repo | Production-affecting code and approvals 0184-0188 are on `main`. **One commit is unmerged** on branch `claude/more-help-unsupported-subjects-gap-catalog` (`4053b560`): the arms-test tooling and `qa/CONTENT_CREATION_ARMS_TEST_PHYCM_2026_10_17.md`. Other open PRs (not mine): david-bloom/Cramapple #479 (Biology visuals audit, AB graph mirror into BC) and #480 (Precalculus and Statistics visuals audit): relevant to the image-question tasks below. |
| Quality evidence | 200-seed sample (10 subjects): 5.9% of first-draft MCQ help flagged, all repaired by one rewrite, 0 of 185 refused after rewrites (upper bound 1.6%). 20 conceptual-MCQ sweep: 3 flagged, 3 repaired. See the gap catalog sections 7-8 and the arms-test record. |

## 2. Owner rules in force
- Units 1-3 only for any newly enabled subject; ask before unit 4+. "One subject at a time" is the default; the owner explicitly waived it for Physics 1 + Biology on 2026-10-16.
- **Physics 2 (registry units 9-11) and Physics C: E&M (8-10) are out of scope.**
- Every Production write needs a new `APPROVAL-####` (next free number: check `main`, open PRs and remote branches; 0188 is the highest used) and the owner's explicit go in chat. The tool permission classifier blocks Production writes/deploys until the owner replies that he grants retry permission; do not work around it, ask.
- Never hand-edit generated content; never swap identities or clear receipts to get past the synthetic account's 30-delivered-per-24h quota.
- Owner preferences: acts fast, often on his phone (cannot run bash); does not want to read output packets; accepts a live smoke test; values honest uncertainty over confident summaries.
- Budget: AI Gateway credits were $64.18 on 2026-10-16; roughly $20 has been spent since (estimate from tokens x list price; check the Vercel dashboard before relying on it).

## 3. Task catalog
Legend: **[OWNER]** needs an owner decision or approval; **[PROD]** writes to Production (needs an APPROVAL row); effort S/M/L.

### A. Finish Physics 1 and Biology
| ID | Task | How / evidence of done |
| --- | --- | --- |
| A1 | Verify the app publish. | In Lovable (project `56cae479-f7c9-4988-b536-56538c38ee4e`) confirm the last publish succeeded after `cbaa4ac`; if not, **[OWNER]** publishes (Lovable `deploy_project` without `name`, or the editor). Done when a student account sees More help on a Biology unit 1-3 question. |
| A2 | Owner smoke test on v5 (owner or a student account he controls). | One calculation-style Physics 1 MCQ, one Physics 1 FRQ, one Biology MCQ, one Biology FRQ; plus retry `apphy1-mcq-004`. Watch for "couldn't connect" (a checker-model/gateway problem in Production: roll back by redeploying v3 from commit `111e1ffd`), slow first responses, and MCQ headlines that state a finding. |
| A3 | Close the loop. | Run `docs/qa/more_help_release/05_smoke_checks.sql` on Production (read-only), record results, mark APPROVAL-0187 fully done. [PROD-adjacent, read-only] |
| A4 | Merge the unmerged branch. | Open a PR from `claude/more-help-unsupported-subjects-gap-catalog` (1 commit ahead of `main`). Code PRs go to the owner; docs-only may be merged by the agent when CI is green. |
| A5 | **[OWNER]** Rule on soft leaks. | Prompt-only "explain/justify/what does this show" asks can still be hinted at (Dev v19 read: Precalculus 2.7 composition, Physics 1 2.3 ideal-cable). Accept, or extend the deterministic rules. |
| A6 | **[OWNER]** Runtime check for FRQs? | Not built (FRQs rely on the stated-conclusion rules + prompt). The FRQ answer key/rubric is not read server-side today; scope the build if wanted (M). |
| A7 | **[OWNER]** Biology 3.4 image question ruling. | One image-bearing Biology question (3.4) needs a grounding ruling; More help refuses it until then. Read PR #479 (Biology visuals audit) first. |
| A8 | Biology leftovers (content backlog, not blockers). | 2.10 has 1 practice MCQ; thin topics (3-5): 2.1, 2.3, 2.6, 2.8, 3.1-3.5; no owned vocabulary for 1.2, 1.6, 2.2, 2.9; no memory hooks. Source: `qa/BIOLOGY_UNITS_1_3_CONTENT_SURVEY_2026_10_16.md`. |
| A9 | Physics 1 leftovers. | Topic 1.3 has only 4 MCQs (its second seed escalated, skill 3.C); 12 held-label questions have no unit. |
| A10 | Trace multipart prompt fidelity (gap H08). | Physics 1 has 37 of 47 FRQs with parts inside the stem text. Compare an FRQ's authored parts, the `get_question_experience` RPC output and the model context for one such question. (S-M) |

### B. Next subjects (units 1-3). Use the runbook steps B-E for each.
**B-PC Physics C: Mechanics** (in scope; emptiest). 20 topics, 65 practice MCQs, **10 topics with zero** (1.1, 1.4, 1.5, 2.1, 2.3, 2.4, 2.6, 2.7, 2.8, 3.1), 6 thin (1.3, 2.2, 3.4, 2.5, 2.9, 2.10).
| ID | Task | How |
| --- | --- | --- |
| B1 | Preserve and review the generated seeds. | **29 accepted seeds** (30 slots, 15 topics: the 10 empty + 1.3, 2.2, 3.4, 2.5, 2.9) are in `scripts/content-seed/arms-test-phycm-2026-10-17/batch_A/` inside worktree `.worktrees/mh-gap-catalog` (untracked) and **backed up to `tmp/more-help-mechanics-seeds-2026-10-17/` in the main checkout** (gitignored, also untracked; private question text and keys stay out of git). They passed the standard pipeline (4 non-author families + author-family veto + lint); the one escalated slot is **1.3 slot B**. Not loaded anywhere. |
| B2 | **[OWNER]** Variants? | Owner pattern for Bio/Phys 1 was 2 seeds + 3 variants per topic. Variants for Mechanics: `node seed_pipeline.mjs run --batch=batch_A --plan=plan.json --skills=inputs/skills/ap-physics-c-mechanics.json --variants=3 --rounds=2 --conc=8` (resume fix generates only missing variants; about $0.19-0.21 per accepted item, about 87 variants, ~$13-18, ~30 min). Needs the gateway key symlink (see section 4). |
| B3 | **[PROD]** Load. | `publish_mcq_batch.py plan-from-seed-batch --batch batch_A --key-prefix apphycm-mcq --first-seed <max existing + 1> ...` (look up the max existing `apphycm-mcq-NNN` first), then `preflight`, `rehearse --env prod`, then `publish --env prod --approval APPROVAL-#### --confirm-production`, then `verify` and the gap re-query. The tool cannot load into Dev (schema drift), do not try. |
| B4 | **[OWNER]** `apphycm-frq-044`. | Topic 3.4 vs unit-7 7.4 (held). |
| B5 | Dev proof. | Dev holds no Physics MCQs; use Dev FRQs (11 for Mechanics) for the function proof and rely on the owner smoke test for MCQs. Steps: runbook B (Dev policy row, `scripts/more-help-qa/fixtures.sql`, `run.mjs --cap N`, replay). |
| B6 | App + enable. | App PR adding `ap_physics_c_mechanics: [1,2,3]` to `MORE_HELP_UNITS` in `src/lib/more-help.ts` (+ test in `src/lib/__tests__/more-help.test.tsx`; mirror PR #34), merge; **[PROD]** `docs/qa/more_help_release/02_enable_subject.sql` with `ap-physics-c-mechanics` and `{1,2,3}`; then publish the app; then smoke. Backend first, app last. |

**B-PRE AP Precalculus.** 44 topics, **11 with zero practice MCQs** (1.1, 1.3, 1.11, 2.1, 2.2, 2.8, 2.9, 2.14, 3.4, 3.8, 3.15), 5 with 1-2; 3 topic-held FRQs (`apprecalc-frq-020`, `-np2-007`, `-np2-010`, multi-topic, not forced); `apprecalc-mcq-sv-037-v3` label says unit 2 but topic 1.13 is unit 1. No images found at the census (read PR #480 audit before relying on that). Value-style FRQs (21 of 81 ask midline/period/domain/range) are the most affected by the stated-conclusion rule.
| ID | Task | How |
| --- | --- | --- |
| B7 | Fill the 11 zero topics (+ thin) with seeds (+ variants if the owner wants). | Same pipeline as B2/B3 with `skills/ap-precalculus.json`; check whether the plan needs per-topic `allowed_skills` (calculus/chemistry/statistics use a grid; read `seed_pipeline.mjs` header and `inputs/skills/`). Key prefix `apprecalc-mcq`. |
| B8 | Dev proof, app PR, enable, smoke. | As B5/B6 with `ap-precalculus` (Dev has Precalculus FRQs; MCQ availability in Dev **[unverified]**). |

**Not planned:** Physics 2 and Physics C: E&M (owner: out of scope). If that changes, their registry unit numbers are 9-11 and 8-10; counts: Physics 2 has 6 zero-MCQ topics, E&M 3.

### C. Quality hardening (all optional; owner picks)
| ID | Task | Note |
| --- | --- | --- |
| C1 | Record per-request outcome codes. | Production keeps no reason for a refusal (receipts have no reason column; the Supabase logs API returned 410). Diagnosing the 2026-10-16 smoke refusal needed an offline replay. Add a counts-only outcome field (`delivered`, `leak_flagged`, `rewritten`, `refused`, `check_error`) so the next smoke test is not blind. (M, needs a migration: **[PROD]**) |
| C2 | Calibration set for the runtime check. | Build the way the content pipeline does: known-leaky hints must be flagged, known-clean passed. Start with the 3 known leaks (Biology 3.1, 2.2, 3.5 old hints) and 7 clean ones (see gap catalog section 8). |
| C3 | Widen the identify/define protection. | Deterministic procedure-name validator is Statistics-only; Statistics FRQs that ask to identify the procedure still show "couldn't connect". **[OWNER]** decides what counts as disclosure per subject. |
| C4 | Measure the check's cost and latency. | Not measured. One extra cheap call per pre-submit MCQ; rewrites add 1-2 author calls on ~6% of requests (estimate). First live request took 26 s in Dev (cold start suspected). |
| C5 | Re-test live after the function replacements. | Never re-tested live: AB/BC/Chemistry More help, the graded ("after") phase, FRQ `after`, and the 6 image questions (AB unit 1: 4, Chemistry unit 3: 2). |
| C6 | Held serving labels (~77 rows, units mostly 4+). | Low value for units 1-3; **[OWNER]** protocol call on comparing primary unit vs identical unit sets. |

### D. Content-pipeline findings worth acting on (from `qa/CONTENT_CREATION_ARMS_TEST_PHYCM_2026_10_17.md`)
- Cost is dominated by checking, not writing: audit 42%, authoring 25%, veto 13%, labels 11%, solve 9%. Measured about $0.19-0.21 per accepted seed (Mechanics seeds $6.10 for 29).
- Cheaper checker profile D (`CHECKER_PROFILE=D`) cut evaluation cost 59% but is **not faster** (slow reasoning models: DeepSeek, Meta, Qwen about 27 s per call vs 5-7 s for Opus/Haiku/Gemini/GPT) and its safety is **unproven** (13 of 14 planted defects caught; accepted 8 of 13 candidates the standard profile rejected). Optional next step: adjudicate the 14 disagreements with blind/informed review (`review.mjs`, about 56 judge calls, under $1). Another lever: a fast fourth checker family.
- Do **not** build an authoring-time leak gate: the runtime loop already covers it (sample result above).

## 4. Commands and traps (verified this session)
- **Supabase CLI targets Production when run from the home directory.** For Production read/write: `cd ~ && supabase db query --linked -f <file>` (confirm the ref, `pcntajvbdfqhbeewmdry`). For Development use a scratch workdir: `mkdir -p $TMP/devwd/supabase && supabase link --project-ref wmgjsdkphcyhngaffbqf --workdir $TMP/devwd`, then `supabase db query --linked --workdir $TMP/devwd -f <absolute path>` (relative paths resolve against the workdir). Deploy: `supabase functions deploy more-help --project-ref <ref> --workdir <repo> --use-api`, explicit ref always.
- Production publish tool needs `~/.supabase/access-token`; Dev rejects it (missing columns, skill grid): load Production only.
- Gateway key for the pipeline lives in the main checkout's `scripts/vercel-gateway-check/.env.local` (gitignored); symlink it and `node_modules` into a worktree, never paste or commit it. The key is also what `help_gate.ts`/`review.mjs` read (`AI_GATEWAY_API_KEY`).
- Synthetic QA identities (Dev only, `@example.invalid`): `eefb99e4-c310-423a-baee-50852074c37b` and `843f8e06-bb7e-483e-a6ac-9455f8ce8d59`. Each is limited to 30 delivered per 24 h and 6 attempts per minute; the second had about 29 used on 2026-10-16. Their Dev entitlements expire; add temporary rows to `app.subject_entitlements` (source tag, a few hours) and delete after. Dev policy rows for `biology` and `ap-physics-1` (note "DEV owner-approved rollout proof") are still in Dev.
- Registry vs reference keys: `biology` vs `ap_biology`; Calculus BC uses AB's reference entries; `app.unit_reference_entries` id column is `reference_entry_id`; the question stem is `app.content_item_versions.stem`.
- Worked examples are `-OHT-` content keys; exclude them when counting practice MCQs.
- PRs merge as a snapshot of what was pushed at that moment: later commits on the same branch need a new PR (this happened with #477).
- Lovable lags merges by about 2 minutes; compare `latest_commit_sha` with `main` before publishing; the live bundle could not be crawled (app host serves stub chunks to curl), so verify in the UI.
- `app.question_help_receipts` has no failure reason; leak refusals show to students as "More help couldn't keep this explanation within setup guidance" (`answer_disclosure`), outages as "couldn't connect" (`help_unavailable`).
- Production ledger: rows for `20261015175446` and `20261016000100` were inserted by hand (APPROVAL-0184); `20261015175807` is still unrecorded (guarded no-op in Production). Do not `db push` blindly.
- Resend email connector needs reconnecting with more access if delivery status must be read.

## 5. Decisions waiting on the owner (collected)
A5 soft leaks; A6 FRQ runtime check; A7 Biology 3.4; B2 Mechanics variants (and the 2-seeds-x-3-variants pattern for Precalculus); B4 `apphycm-frq-044`; C3 identify/define scope; C6 labeler rule; whether to adjudicate arm D; whether Mechanics or Precalculus goes next (recommendation: Mechanics, because 29 seeds already exist and it needs only variants + load).

## 6. Suggested order for the next session
1. A1-A3 (confirm publish, owner smoke, close APPROVAL-0187). 2. A4 (merge). 3. B1-B6 Mechanics (seeds exist). 4. B7-B8 Precalculus. 5. A5-A10, C1-C5 as the owner prioritises.
