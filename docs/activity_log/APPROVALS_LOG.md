# Approvals Log

This log records approvals, rejections, Done decisions, and risk acceptances.

## Index

Most recent entries (full chronological list follows below):

- APPROVAL-0080 — Load and Publish 24 AP Biology Units 1-2 Variants (Production) — DECISION-0085
- APPROVAL-0079 — AP Biology Topic Correction: 73 Primary Topic Cells Replaced by Three-Family Consensus; MCQ-005 Relabeled to Unit 2 (Production) — DECISION-0085
- APPROVAL-0078 — Publish 131 AP Statistics Units 1-3 Variants with Inherited Validated Labels (Production) — DECISION-0085
- APPROVAL-0077 — Load 132 AP Statistics Units 1-3 Variants as Drafts; Retire 8 Statistics Items on CED-Removed Topics (Production) — DECISION-0085
- APPROVAL-0076 — AP Statistics Units 1-3 Pipeline v2: Repair 4 Published MCQ Rationales, Relabel 8 Items, Write 129 Skill Cells (Production) — DECISION-0085
- APPROVAL-0075 — Load and Publish 72 AP Chemistry Units 1-3 Variants; Fill `canonical_answer_1` on 49 Chemistry MCQs (Production) — DECISION-0085
- APPROVAL-0074 — AP Chemistry Units 1-3 Full Pipeline Run: Repair 8 Published MCQs, Create Topic Cells and the Skill Grid, Relabel 37 Items, Write 34 Skill Cells (Production) — DECISION-0085
- APPROVAL-0073 — AP Biology: Widen the Skill-Grid Practice Bound, Create the 22-Skill x 60-Topic CED Grid, Relabel 70 Live Items for Unit Serving, Label Skills by Model Consensus (DECISION-0085) — DECISION-0085
- APPROVAL-0072 — Relax `content_item_cells_validation_check` in Production So Model-Consensus Skill Labels Can Be `validated` (DECISION-0085 Route 1) — DECISION-0085
- APPROVAL-0071 — Fix Two Live AP Calc AB Seeds in Production: `apcalcab-mcq-026` Choice C and the `apcalcab-mcq-028` Serving-Label Units — DECISION-0093
- APPROVAL-0069 — Relabel 11 Held or Stale Serving Labels on Published AP Calc AB Items (Production) and Run the Units 2-3 Seeded-Variant Pilot — DECISION-0093
- APPROVAL-0066 — Repair 11 Published AP Calc AB MCQs in Production (Key Letter on `apcalcab-mcq-037`, 10 Distractor-Rationale Repairs) and Carry Their Serving Labels Forward — DECISION-0093
- APPROVAL-0065 — AP Calc AB Unit 1 Batch (136 Items) and Seeded Variants (24 Items) to Production, With AI-Gateway Spend — DECISION-0093
- APPROVAL-0064 — TASK-0056 to Production (Three Migrations) and the `evaluate-attempt` F2 Deploy — DECISION-0089
- APPROVAL-0063 — TASK-0056 in Development (Parity Replay, Reviewer Function, Revoke) and the Lovable Reviewer-Read Edit — DECISION-0089
- APPROVAL-0062 — Production Hotfix: Create `open_hand_scoring_exclusions` Table Only (Dev + Prod) — TASK-0051
- APPROVAL-0061 — Execute TASK-0051 Open Hand Unification in Development — DECISION-0086
- APPROVAL-0060 — Execute TASK-0050 Skill-Dimension Rollout in Development, with AI-Gateway Spend — DECISION-0085
- APPROVAL-0059 — Execute TASK-0041 Purchase Funnel in Development — DECISION-0083
- APPROVAL-0058 — Ship TASK-0039 BYOQ (Phases 1–2: Data Model, Typed Fallback, Phone/QR Capture, Practice Screen) to Production — DECISION-0084
- APPROVAL-0057 — Execute TASK-0046 Subject Onboarding Gate in Ordered Per-Subject Slices
- APPROVAL-0056 — TASK-0042 Cross-Cutting Content-Pipeline QA Remediation and Subject-Scoped Production Writes
- APPROVAL-0055 — Adopt Lean Source-of-Truth Startup Mode (Tier-First Reading, `AGENTS.md`, Log `INDEX_END` Markers) — DECISION-0081
- APPROVAL-0054 — Ratify Three Session-Start Bootstrap Edits (Live Front-Ends, Required First-Read, Anti-Stale Rule) — DECISION-0078
- APPROVAL-0053 — BYOQ Is Identity-Agnostic: `byoq_items.user_id` Not Required; Resolves the DECISION-0070/0068 Conflict
- APPROVAL-0052 — TASK-0039 BYOQ Phase Priority Corrected (Camera-First) and Ownership Confirmed (Claude, Not Codex)
- APPROVAL-0051 — Deploy the AP Statistics Combined Practice Selector (TASK-0044) to Production
- APPROVAL-0050 — BYOQ Data-Model Architecture (Option A) and TASK-0039 Phase 1 Scope
- APPROVAL-0049 — Pilot-Scale Operational Commitment for Hand-Drawn Manual Grading (TASK-0038 Phase 4)
- APPROVAL-0048 — Promote `APBIO-HDG-2026-GRAPH-002` to Human-Graded-Pilot-Approved (TASK-0038 Phase 2)
- APPROVAL-0047 — Device-Neutral Cramapple Bootstrap and Shared ChatGPT Project Contract
- APPROVAL-0046 — Confirm QR Handoff as Engine 4's Sole Capture Path; Approve Capture-Failure Handling Split
- APPROVAL-0045 — Retire Engine 4's Dual-Human-Adjudicated Gold Requirement; Adopt the DECISION-0045 Gold Model
- APPROVAL-0044 — Replace Free Score Check with 7-Day Trial; Enable GRADING_ENTITLEMENTS_ENABLED (TASK-0026)
- APPROVAL-0043 — Retire the ≤1000ms p50 Grading Latency Gate; Approve Engine 1/3 Go-Live Ahead of Full Gold-Set Certification
- APPROVAL-0042 — Lock TASK-0020 Launch Slice and Assessment Baselines
- APPROVAL-0041 — Execute Image and Drawn-Response Launch-Gating Assessment (TASK-0020)
- Older entries: [`APPROVALS_LOG-0001_to_0040.md`](archive/APPROVALS_LOG-0001_to_0040.md)

**Rotation rule:** once this log exceeds ~400 lines, archive the older entries to `docs/activity_log/archive/APPROVALS_LOG-<range>.md` and update this index to point at the archive. Keep the index itself to the last ~10 entries.

<!-- INDEX_END -->

## APPROVAL-0080 — Load and Publish 24 AP Biology Units 1-2 Variants (Production)

**Date:** 2026-10-02  
**Approved By:** David Bloom (2026-10-02 Claude session: "I think do 3 then 2 then 1", item 1 being load and publish the Biology variants)  
**Related Decision:** `DECISION-0085`, `DECISION-0093`; follows `APPROVAL-0079`  
**Decision:** Approved

**Approved scope (Production `pcntajvbdfqhbeewmdry`, pack `2d88ba5e-a6a3-43b8-bfae-9e5505a178a7`):** 24 AP Biology variant MCQs (keys `APBIO-MCQ-SV-<seed>-v1..v3`, from 9 seeds in Units 1-2) loaded as drafts in 3 atomic chunks (md5 24 of 24 against the build manifest), then approved and published with validated, hash-fresh serving labels and validated primary topic cells. Unit and topic are inherited from the seed after the topic correction of `APPROVAL-0079` (3 in Unit 1, 21 in Unit 2; topics 1.7, 2.1, 2.3, 2.6, 2.7, 2.8, 2.10). No skill or difficulty rows were written.

**Checks behind the variants:** two checkers (gemini-3.8-flash, deepseek-v4-pro) solved, audited and CED-scope-checked 30 drafts; no key disagreements and no scope flags; 2 patched (rationale wording) and re-audited clean; 6 dropped (all three `025` variants, whose seed rests on kidney ADH physiology outside the pack and whose v1 and v2 had real errors; `005-v2`, `014-v3`, `022-v2` placed at Unit 4 or higher by a checker).

**Not approved by this entry:** retiring or repairing seed `025` (its topic was corrected to 2.7 by `APPROVAL-0079`; its choice D rationale is weak); the seed-level CED scope check on the 10 Biology seeds; skill cells for the variants; FRQ variants.

## APPROVAL-0079 — AP Biology Topic Correction: 73 Primary Topic Cells Replaced by Three-Family Consensus; MCQ-005 Relabeled to Unit 2 (Production)

**Date:** 2026-10-02  
**Approved By:** David Bloom (2026-10-02 Claude session: "I think do 3 then 2 then 1", answering the open question whether to correct the Biology registered topics now)  
**Related Decision:** `DECISION-0085`; touches topics promoted by `DECISION-0079`; follows `APPROVAL-0078`  
**Decision:** Approved

**Approved scope (Production `pcntajvbdfqhbeewmdry`, pack `2d88ba5e-a6a3-43b8-bfae-9e5505a178a7`):** (1) For the 73 of 118 published Biology items whose registered primary topic disagrees with a three-family blind consensus (gemini-3.8-flash, deepseek-v4-pro, gpt-6.1-sol, 2 samples each) at >= 5 of 6 samples, the registered primary topic cell was superseded (never edited) by a new validated cell at the consensus topic; 3 of the 73 had no primary cell. The 42 changes that cross a unit boundary and the 31 within a unit are all included. (2) 21 existing skill cells were moved to the corrected topic (every pairing is valid in the grid; none held). (3) `APBIO-MCQ-005`, the only one of the 43 items validated earlier whose unit disagreed with the consensus (6 of 6), received a new validated serving label: Unit 2, required units 1 and 2 (it was Unit 1). The other 42 earlier-validated items' units matched the consensus.

**Method:** the 43 items validated before this session had never been topic-probed, so they were probed with the same method as the 75 non-servable items (258 gateway calls). Items whose topic agreement was below 5 of 6 (18 items) keep the registered topic. The transaction was rehearsed with a rollback, then applied.

**Not approved by this entry:** a re-vote of skill labels for the changed items (skill votes were cast with the registered topic as a hint); changes to items below 5 of 6 agreement; relabeling or republishing any Unit 4+ serving labels beyond MCQ-005.

## APPROVAL-0078 — Publish 131 AP Statistics Units 1-3 Variants with Inherited Validated Labels (Production)

**Date:** 2026-10-02  
**Approved By:** David Bloom (2026-10-02 Claude session: "Publish")  
**Related Decision:** `DECISION-0085`, `DECISION-0093`; follows `APPROVAL-0077`  
**Decision:** Approved

**Approved scope (Production `pcntajvbdfqhbeewmdry`, pack `548f06be-ccf4-426d-b82b-b424137a4438`):** the 131 loaded AP Statistics variant MCQs (`APSTATS-MCQ-SV-*`) were approved and published, each with a validated, hash-fresh serving label and a validated primary topic cell. Unit and topic are inherited from the seed (63 items in Unit 1, 33 in Unit 2, 35 in Unit 3); both variant checkers (gemini-3.8-flash, deepseek-v4-pro) placed every one in Units 1-3. The three `058` variants use topic 3.3 (their content is a proportion interval) instead of the seed's registered 4.2. The `010-CAL` seed carries only a provisional label; its variants were confirmed by both checkers at topic 3.2, Unit 3. No skill or difficulty rows were written for the variants.

**Held back:** `APSTATS-MCQ-SV-057-v2` stays a draft (its seed is registered at Unit 4 topic 4.1 and its siblings were dropped for a debatable central-limit claim).

**How it was used:** the publish transaction was rehearsed with a rollback (the first rehearsal stopped at a guard on the `010-CAL` seed and wrote nothing), then applied. Statistics census: published 293, unit-gated servable 261, validated labels 301, stale hashes 0.

**Not approved by this entry:** relabeling seeds `009`, `059`, `066`, `080` (both checkers place their variants in Unit 4); retiring `053` or `073`; the `037` choice D rationale repair; skill cells for the variants; FRQ variants.

## APPROVAL-0077 — Load 132 AP Statistics Units 1-3 Variants as Drafts; Retire 8 Statistics Items on CED-Removed Topics (Production)

**Date:** 2026-10-02  
**Approved By:** David Bloom (2026-10-02 Claude session: "Load. The 132"; "Retire the stats.")  
**Related Decision:** `DECISION-0085`, `DECISION-0093`; follows `APPROVAL-0076`  
**Decision:** Approved

**Approved scope (Production `pcntajvbdfqhbeewmdry`, pack `548f06be-ccf4-426d-b82b-b424137a4438`):** (1) 132 AP Statistics variant MCQs (keys `APSTATS-MCQ-SV-<seed>-v1..v3`, from 44 seeds) loaded as drafts in 12 atomic chunks; md5 of stem, choices, keys and rationales matches the build manifest for 132 of 132. They carry no labels, cells or difficulty rows and are not published. (2) Eight published items retired (item and version status `retired`): `APSTATS-MCQ-008-CAL`, `016-CAL`, `018-CAL`, `075`, `088`, `094`, `098`, `100` (topics the CED removed, per the fact pack). Only `008-CAL` was servable at the time.

**Checks behind the variants:** two checkers (gemini-3.8-flash, deepseek-v4-pro) solved, audited and CED-scope-checked all 144 drafts; no key disagreements and no scope flags; 15 variants patched (rationale wording, three confidence-interval numbers, one terminology fix) and re-audited clean; 12 dropped (`057` v1/v3 for a debatable CLT claim at n = 40-64; `009`, `059`, `066` and `080-v2` because both checkers put them in Unit 4).

**Not approved by this entry:** publishing the variants or giving them labels; retiring `053` or `073`; relabeling seeds `009`, `059`, `066`, `080`; the `037` choice D rationale repair; FRQ variants.

## APPROVAL-0076 — AP Statistics Units 1-3 Pipeline v2: Repair 4 Published MCQ Rationales, Relabel 8 Items, Write 129 Skill Cells (Production)

**Date:** 2026-10-02  
**Approved By:** David Bloom (2026-10-02 Claude session: "all subjects need this check done, but now lets finish stats, bio and calculus in that order. Only units 1-3 for now."; "rerun the skill votes in a fresh job")  
**Related Decision:** `DECISION-0085`; follows `APPROVAL-0075`  
**Decision:** Approved

**Approved scope (Production `pcntajvbdfqhbeewmdry`, pack `548f06be-ccf4-426d-b82b-b424137a4438`):** (1) Four published MCQs (`APSTATS-MCQ-045`, `047`, `048`, `080`) with false or misleading wrong-answer rationales received new version 2 records (rationale text only; choices and keys unchanged), approved and published, with topic cells, difficulty and the skill cell carried forward; the five rewritten rationales re-audited clean by two checkers. (2) Eight items (those four plus `MCQ-002`, `009`, `020`, `HDG-2026-GRAPH-019`) received new validated, hash-fresh serving labels from a two-family blind agreement; all eight verified published, validated and fresh after commit. (3) 129 skill cells in Units 1-3 scope set by four voters (claude-opus-5, gpt-5.5, gemini-2.5-pro, gemini-3.8-flash): 116 validated at >= 3 of 4, 1 provisional (unique 2-of-4), 12 held (ties or a vote that is not a valid cell for the topic: `MCQ-094`).

**How it was used:** repair/label and skill transactions were each rehearsed with a rollback, then applied. The first skill rehearsal failed a foreign key (topic 5.3 admits only skill 3.B) and wrote nothing; invalid pairs are now held with the prior cell kept. The skill votes from the earlier job had already completed (129 of 129 per model), so they were reused instead of rerun.

**Not approved by this entry:** retiring Statistics items on CED-removed topics (`008-CAL`, `016-CAL`, `075`, `100`, `018-CAL`, `088`, `094`, `098`); Statistics variants; the vague-rationale rewrite project; other units or subjects.

## APPROVAL-0075 — Load and Publish 72 AP Chemistry Units 1-3 Variants; Fill `canonical_answer_1` on 49 Chemistry MCQs (Production)

**Date:** 2026-10-02  
**Approved By:** David Bloom (2026-10-02 Claude session: "load the variants"; "We need canonical answers for Chemistry"; "publish")  
**Related Decision:** `DECISION-0085`, `DECISION-0093`; follows `APPROVAL-0074`  
**Decision:** Approved

**Approved scope (Production `pcntajvbdfqhbeewmdry`):** (1) 72 AP Chemistry variant MCQs (keys `apchem-mcq-sv-<seed>-v1..3`; 3 variants of each of 24 seeds; the 3 `007` variants were held out for a CED-scope concern) loaded as drafts in 12 atomic chunks (md5-verified 72 of 72 against the build manifest), then approved, given validated hash-fresh serving labels (units and topics inherited from the seed after a >= 5-of-6 three-family check, 75 of 75) and validated primary topic cells, and published; no difficulty or skill rows were written for them; (2) `canonical_answer_1` filled from the correct choice on 49 published Chemistry MCQs that had none (metadata only, no change to question content), with the 47 fresh serving labels carried forward (all 43 validated labels preserved).

**How it was used:** the publish transaction and the canonical-answer fill were each rehearsed with a rollback, then applied. Chemistry census: published 119 to 191, unit-gated servable 82 to 154, validated labels 85 to 157, stale hashes 20 (unchanged, outside Units 1-3). Loading used four agents (432,523 tokens, 7.5 minutes).

**Finding recorded with this approval:** MCQ grading reads `is_correct` on the choices (`evaluate-attempt`); `canonical_answer_1` is not used to score an MCQ. A sample across subjects shows 7 of 10 already carry a letter on every or nearly every MCQ (0 disagree with `is_correct`); Biology has 3 of 43, Statistics 0 of 304.

**Not approved by this entry:** seeds `007` and `028` (CED-scope question); the 3 held `007` variants; other units or subjects; FRQ variants.

## APPROVAL-0074 — AP Chemistry Units 1-3 Full Pipeline Run: Repair 8 Published MCQs, Create Topic Cells and the Skill Grid, Relabel 37 Items, Write 34 Skill Cells (Production)

**Date:** 2026-10-02  
**Approved By:** David Bloom (2026-10-02 Claude session: "let's run the full progression 1-7 on Chemistry, units 1-3. I want to get a sense of time, cost $ and cost tokens when we start from scratch")  
**Related Decision:** `DECISION-0085`; validator relaxation `APPROVAL-0072`  
**Decision:** Approved

**Approved scope (Production `pcntajvbdfqhbeewmdry`):** AP Chemistry, Units 1-3 only: (1) new versions of 8 published MCQs (`001, 008, 022, 025, 027, 031, 037, 039`): rationale rewrites, plus choice D of `037` and `039` replaced; keys and `is_correct` unchanged; (2) 36 primary topic cells (blind 3-family consensus, >= 5 of 6); (3) fresh validated serving labels for 37 in-scope items (2 items had duplicate active labels, both retired); (4) migration `apchem_skill_grid_units1_3` (28 skills, 136 cells); (5) 34 secondary skill cells on the four-voter rule (30 validated at >= 3 of 4, 4 provisional). Each write was an atomic guarded transaction; the repair and relabel scripts were rehearsed with a rollback first.

**Result (census, Chemistry):** unit-gated servable 65 to 82; topic-known items 0 to 36. Metrics for the run are in `scripts/content-seed/chem-units1-3-pipeline-2026-10-02/PIPELINE_REPORT.md`: about 86 minutes, 2,040 gateway calls, $7.55 gateway list price, about 0.9M Claude tokens.

**Not approved by this entry:** loading or publishing the 72 drafted variants; changing seeds `007` or `028` (CED-scope questions); other units or subjects; the 20 out-of-scope stale hashes.

## APPROVAL-0073 — AP Biology: Widen the Skill-Grid Practice Bound, Create the 22-Skill x 60-Topic CED Grid, Relabel 70 Live Items for Unit Serving, Label Skills by Model Consensus (DECISION-0085)

**Date:** 2026-10-02  
**Approved By:** David Bloom (2026-10-02 Claude session: "Assess Bio for how to make all 118 publishable, replace stale label hashes"; "Create the Bio CED grid, then do labels"; "widen that check")  
**Related Decision:** `DECISION-0085`, `DECISION-0088`; the validator relaxation is `APPROVAL-0072`  
**Decision:** Approved

**Approved scope (Production `pcntajvbdfqhbeewmdry`):** (1) migration `20261002170626_apbio_skill_grid_phase_a.sql`: widen `taxonomy_skills_practice_number_check` from 1..4 to 1..12; add the 22 AP Biology skills and the full 60 x 22 = 1320-cell grid (CED p. 30: exam questions can pair a topic with any skill) under taxonomy source version `c676d1fc`; (2) `scripts/content-seed/apbio-skills-and-labels-2026-10-02/serving_relabel_apply.sql`: new validated serving-label versions for 70 live items (old rows superseded), accepted only where >= 5 of 6 samples from three model families agree on the max required unit; (3) skill labels as secondary `content_item_cells` rows, validated on >= 2 of 3 models (gpt-5.5, gemini-2.5-pro, claude-opus-5), agreement tier recorded in `source`.

**How it was used (2026-10-02):** each step was rehearsed on Production with a rollback, then applied. Bio census before to after: unit-gated servable 43 to 110 of 118, items with no serving label 43 to 0, stale hashes 15 to 4. Five items stay held on a real unit split (`FRQ-L-013`, `FRQ-L-017`, `HDG-008`, `MCQ-017`, `MCQ-088`); 3 hand-drawn items are excluded from text serving by design.

**Skill labels (applied 2026-10-02):** 104 live Bio items carry a `validated` secondary skill cell (`is_primary = false`; the validated primary topic rows are untouched): 55 unanimous, 49 majority-earned (tier recorded in `source`), 49 paired with the registered topic and 55 with the consensus topic. MCQs were labeled from their visible text; FRQs from their text plus scoring criteria, because 45 of 75 FRQs show only a scenario sentence (criteria raised unanimous FRQ agreement 27 to 39 and cut no-majority 12 to 6). Not written: 13 items with no 2-of-3 majority and 1 with no usable topic. `servable_items_census().topic_known_skill_level` stays 0 because it counts only primary cells.

**Skill labels, revised to a four-voter rule (David, 2026-10-02: "option 2"):** after a `gemini-3.8-flash` swap test showed it only reshuffled labels (10 changed, 9 newly resolved, 4 lost a majority; it matched the written label on 77 of 104 versus 80 for `gemini-2.5-pro`), the four models (`claude-opus-5`, `gpt-5.5`, `gemini-2.5-pro`, `gemini-3.8-flash`) were treated as voters: `validated` only at >= 3 of 4, a unique 2-of-4 plurality is `provisional_model`, 2-2 ties and 1-1-1-1 splits are `held`. Final Bio skill cells (secondary rows): **86 validated (46 at 4 of 4, 40 at 3 of 4), 15 provisional, 13 held**; 3 items have no cell (split, no plurality) and 1 has no usable topic. No label changed; 5 validated cells were demoted, 13 were parked, 10 provisional cells were added. Script `skill_4voter.sql`.

**Finding recorded with this approval:** the registered primary topic cells (validated under `DECISION-0079`) disagree with a 6-of-6 three-family consensus on about 58 live Bio items, 36 of them across units (ten FRQs are registered `1.1`, e.g. barnacles on a whale, a mycorrhizal fungus, frog mating calls, which are ecology and speciation). The registered topics were NOT changed; they need a decision.

**Not approved by this entry:** changing the registered topic cells; retiring the 42 dead `published` Bio rows; other subjects.

## APPROVAL-0072 — Relax `content_item_cells_validation_check` in Production So Model-Consensus Skill Labels Can Be `validated` (DECISION-0085 Route 1)

**Date:** 2026-10-02  
**Approved By:** David Bloom (2026-10-02 Claude session: "change the validator rule in production from the human requirement to the AI requirement")  
**Related Decision:** `DECISION-0085` (the open Hard Gate it left: "Relax the CHECK (recommended)")  
**Decision:** Approved

**Approved scope:** one migration on Production (`pcntajvbdfqhbeewmdry`), `supabase/migrations/20261002164510_relax_cells_validation_check_ai_consensus.sql`: a `validated` cell needs `validated_at`, `validation_decision_id` and either a human `validated_by` or a `model_run_id`. Non-validated rows still may not carry a complete validation record.

**How it was used:** rolled-back rehearsal on Production (positive: AI-validated accepted; negative: validated with no decision id, validated with no human and no model run, and a non-validated row with a full record were all rejected), then applied via `apply_migration`; recorded version `20261002164510`; the constraint definition was re-read afterwards. No rows were changed. Existing human validations are unaffected (the new rule is a superset).

**Not approved by this entry:** writing any validated skill label (each subject's Phase B needs its own gate under `TASK-0050`); changing `DECISION-0085`'s roster or its agreement-tier recording rule (the tier must still be recorded on every row).

## APPROVAL-0071 — Fix Two Live AP Calc AB Seeds in Production: `apcalcab-mcq-026` Choice C and the `apcalcab-mcq-028` Serving-Label Units

**Date:** 2026-10-02  
**Approved By:** David Bloom (2026-10-02 Claude session: "fix them", in answer to the two seed issues raised in the Units 2-3 pilot report)  
**Related Decision:** `DECISION-0093`  
**Decision:** Approved

**Approved scope:** on Production (`pcntajvbdfqhbeewmdry`), two items, `scripts/content-seed/calc-ab-units2-3-seeded-2026-10-02/seed_fixes_apply.sql`. (1) `apcalcab-mcq-026`: choice C text `e²` replaced by `2e` (a real error: differentiating only x²), with a derived rationale; new version, never in place; key B, `is_correct` flags and the other choices unchanged; the validated serving label carried forward with its original validation record. (2) `apcalcab-mcq-028`: serving label required units changed from [2, 5] (provisional) to [1, 2], promoted to `validated` on the same basis as `APPROVAL-0065` and `0069` (6 of 6 blind samples from three models; the S0a audit found the item correct).

**How it was used (2026-10-02):** rolled-back rehearsal on Production passed every in-script assertion and left Production unchanged; then applied in one transaction. Calc AB census before to after: unit-gated servable 207 to 208, validated labels 209 to 210, hash mismatches 1 (unchanged, `frq-u13-003`). `026` is now version 3. Choice C's edit goes beyond a rationale rewrite (the choice text changed) because no error pattern produces e².

**Not approved by this entry:** loading or publishing the 30 pilot variants; any other item.

## APPROVAL-0069 — Relabel 11 Held or Stale Serving Labels on Published AP Calc AB Items (Production) and Run the Units 2-3 Seeded-Variant Pilot

**Date:** 2026-10-02  
**Approved By:** David Bloom (2026-10-02 Claude session: "I Confirm the Units 2–3 scope"; "I Authorize relabelling the 13 problem items"; checkers Gemini 3.8 Flash plus DeepSeek V4 Pro)  
**Related Task:** none (content readiness); follows `APPROVAL-0066`  
**Related Decision:** `DECISION-0093`  
**Decision:** Approved

**Approved scope:** (1) on Production (`pcntajvbdfqhbeewmdry`) write new serving-label versions for the held or stale AP Calc AB items that a blind three-model probe could label by consensus, and mark them `validated` under the `automated_spot_check` pattern of `APPROVAL-0065`; (2) AI-Gateway spend and authoring for a seeded-variant pilot on Units 2 and 3 (3 variants per seed). Loading and publishing the pilot variants is NOT approved by this entry.

**How (1) was used (2026-10-02):** the request said 13 items; the census shows 12 (10 held with stale hashes, 2 provisional with no hash). Eleven had at least 4 of 6 samples agreeing on max unit and topic (Gemini 3.8 Flash, DeepSeek V4 Pro, GPT-6.1 Sol, 2 samples each), and the consensus topic equals each item's existing primary cell. `scripts/content-seed/calc-ab-label-repair-2026-10-02/relabel_apply.sql` ran in one transaction after a rolled-back rehearsal on Production: old rows superseded (never edited), 11 new `validated` hash-fresh labels, 11 validation decisions. Calc AB census before to after: unit-gated servable 196 to 207, validated labels 198 to 209, hash mismatches 12 to 1. **Not relabelled:** `apcalcab-frq-u13-003` (max unit split 3 to 3 between Unit 2 and Unit 4) stays `held` for a Product Owner decision.

**Not approved by this entry:** item text changes; loading or publishing any pilot variant; other subjects.

## APPROVAL-0066 — Repair 11 Published AP Calc AB MCQs in Production (Key Letter on `apcalcab-mcq-037`, 10 Distractor-Rationale Repairs) and Carry Their Serving Labels Forward

**Date:** 2026-10-01  
**Approved By:** David Bloom (2026-09-30/10-01 Claude session: "Plan approved" for the 037 + TASK-0053 repair plan; "Yes, replace the two unexplained wrong-answer numbers in 031"; "Yes, draft the label carry-forward"; "Yes, do a rolled-back test run on Production"; and, to apply: "for calc, you register my approval in the activity log, put the id in the carry-forward approval and then you run the two scripts")  
**Related Task:** `TASK-0053` (distractor-specific MCQ feedback shows these rationales to students); handoff open items 1 and 2 of `SESSION_CLOSE_2026_09_30_SEEDED_GENERATION.md`  
**Related Decision:** `DECISION-0093`  
**Decision:** Approved

**Approved scope:** on Production (`pcntajvbdfqhbeewmdry`), run `scripts/content-seed/reviewer-qa-remediation/20260930_apcalcab_037_key_and_distractor_rationale_repair.sql` and then `20260930_apcalcab_label_carry_forward.sql` for exactly 11 items: `apcalcab-mcq-005, 007, 008, 016, 026, 030, 031, 037, 038, 080, np2-006`. Owner-remediation pattern (new version per item, never an in-place edit). Keys and `is_correct` flags unchanged. `037`: `canonical_answer_1` A to B (records only; grading reads `is_correct`). Distractor rationales corrected on 10 items. `031`: two distractor values with no derivation (-5.34, -3.81) replaced by 7.62 and -2.04 (approved). Serving labels carried forward: 5 `validated` items keep their original validation record (a human validation carried across a rationale-only change, hereby approved), 6 `provisional_model` items restored; no relabelling.

**Evidence:** `scripts/content-seed/calc-ab-pilot-2026-09-30/PILOT_REPORT.md`, `.../calc-ab-seed-audit-2026-09-30/AUDIT_REPORT.md`; every number independently recomputed; rolled-back run on Production 2026-09-30 (repair + carry-forward together) passed all in-script assertions and left Production unchanged.

**Not approved by this entry:** any other item, subject or unit; the 24 seeded Calc AB variants (to be re-checked against the repaired seeds separately); the unaudited published MCQs; anything touching a class B/C seed.

**How it was used (2026-10-01):** both scripts ran on Production as one transaction (all in-script assertions passed): 11 items got a new published version, 11 serving labels restored and re-pointed (5 `validated` with their original validation record, 6 `provisional_model`). Verified afterwards: one published version per item; `canonical_answer_1` equals the correct choice on all 11 (`037` is now `B`); `is_correct` unchanged; 0 stem/choice desync; 0 stale hashes on the 5 validated labels; no stale Calc AB serving labels; no `anon`/`authenticated` grant on `is_correct`/`rationale`. Calc AB counts unchanged: 279 published, 196 unit-gated servable, 198 validated labels. `030`'s provisional label never had a hash (pre-existing, unchanged). A rolled-back run on 2026-09-30 preceded the real run.

## APPROVAL-0065 — AP Calc AB Unit 1 Batch (136 Items) and Seeded Variants (24 Items) to Production, With AI-Gateway Spend

**Date:** 2026-09-30  
**Approved By:** David Bloom (2026-09-30 Claude session: "Execute all with my permission as product owner"; "I approve promotion to validated"; "I approve putting all of these questions in front of students"; checker picks "Gemini 3.8 Flash + DeepSeek V4 Pro"; "Run it as a blind calibration run")  
**Related Task:** none (content batch; see the handoff)  
**Related Decision:** `DECISION-0093`  
**Decision:** Approved

**Approved scope:** load, owner-approve, label, promote to `validated` and publish 136 AP Calc AB Unit 1 items (34 originals + 102 variants; 8 of them relabelled to Unit 2) and 24 seeded variants on Production (`pcntajvbdfqhbeewmdry`); Vercel AI Gateway spend for the model checks.

**How it was used:**

- All loads were atomic chunks verified by md5 against the source (136 of 136 and 24 of 24 exact; 0 letter/key inconsistencies). Approvals, labels, difficulty, cells and publish ran in transactions with a duplicate-published-version guard.
- After each publish: servable-items census and selftest (no mismatches, capped skips only), 0 stale label hashes, no column grant on `is_correct`/`rationale` for `anon`/`authenticated`. Calc AB moved from 119 to 255 to 279 published items and from 38 to 174 to 198 validated serving labels.
- Gateway spend was logged for the pilot, Unit 3 run, Fable calibration and 24-variant labeling: about $1.03 + $0.47 + $2.73 + $0.99 (checkers, calibration, labels). The Unit 1 run's spend was not logged (the scripts did not record usage); token logging was added afterwards.
- **Not approved by this entry:** any other subject or unit, changing an already-published item, or the repairs of the published seeds (separate tasks).

## APPROVAL-0064 — TASK-0056 to Production, Plus the `evaluate-attempt` F2 Deploy

**Date:** 2026-09-30  
**Approved By:** David Bloom ("You deploy the grading fix"; "Approved, apply the Prod migrations tonight", 2026-09-30 Claude session)  
**Related Task:** `TASK-0056-ANSWER-KEY-DIRECT-READ-EXPOSURE.md`; `TASK-0051` (F2)  
**Related Decision:** `DECISION-0089`  
**Decision:** Approved

**Approved scope:** apply `20260930120000`, `20260930120100` and `20260930120200` to Production, and
deploy `evaluate-attempt` with the F2 fix (`.maybeSingle()` → `.limit(1)`).

**How it was used:**

- Precondition: David published the Lovable reviewer-read edit (`783f6e04`) before the apply.
- All three migrations applied to Production. `…120100` and `…120200` went in one transaction, so no
  half-applied state was ever live. Each ledger entry is recorded under its file version, and its body
  MD5 matches the committed file and Dev.
- Guard (`scripts/qa/answer_key_exposure_guard.sql`) on Production: **no rows.**
- **`evaluate-attempt` deploy: not done from the cloud session.** The proxy blocks `api.supabase.com`, and
  the MCP deploy would have meant re-typing 24 files (about 340 KB). Handed to David as the repo's usual
  CLI command. Production v68 was confirmed byte-identical to `main` beforehand, so the deploy changes
  only the F2 lines.
- **Deploy done** (David, CLI): Production `evaluate-attempt` v70 was verified byte-identical to `main`
  (24 files) after PR #285 merged.

**Not authorized by this entry:** `get_open_hand_item` / the TASK-0051 Production gate, or Stripe
live-mode work.

## APPROVAL-0063 — TASK-0056 in Development, Plus the Lovable Reviewer-Read Edit

**Date:** 2026-09-30  
**Approved By:** David Bloom ("I approve all three", 2026-09-30 Claude session)  
**Related Task:** `TASK-0056-ANSWER-KEY-DIRECT-READ-EXPOSURE.md`  
**Related Decision:** `DECISION-0089`  
**Decision:** Approved

**Approved scope (as presented):**

1. Development: replay the committed `public.mcq_choices` fix (Dev never had it), and apply
   `public.get_review_item_version`.
2. Lovable app `56cae479`: the reviewer portal's `getReviewTask` edit.
3. Development: apply the answer-key revoke and confirm the guard is clean.

**How it was used:**

- (1) Replayed as ledger version `20260827010001`, byte-identical to Production's entry (MD5 match).
  Applied `20260930120000`. Tested: assigned reviewer 1 row with explanation, unassigned 0, admin 1,
  `anon` 42501.
- (2) Narrower than presented: `getReviewTask` never used `explanation`, so the edit drops it from the
  select instead of switching to the RPC. One line, Lovable commit `783f6e04`; typechecks. **Not
  published.** This works on Production today and after the revoke, without the new function.
- (3) Applied `20260930120100`. The guard then showed its column revokes were no-ops, because
  `authenticated` holds table-level SELECT. Added and applied `20260930120200` (table SELECT replaced by
  a safe-column grant, the `20260824060000` pattern). Same scope. Guard clean on Dev.

**Not authorized by this entry:** any Production change (migrations, `evaluate-attempt` deploy),
publishing the Lovable edit, or Stripe live-mode work.

## APPROVAL-0062 — Production Hotfix: Create `open_hand_scoring_exclusions` Table Only (Dev + Prod)

**Date:** 2026-09-29  
**Approved By:** David Bloom  
**Related Task:** `TASK-0051-OPEN-HAND-UNIFIED-ANSWER-KEY.md`, `TASK-0053`  
**Related Decision:** `DECISION-0086`  
**Decision:** Approved (option A of three presented; "Go with A but do Dev and Prod so they stay sync'd")

**Why:** `evaluate-attempt` v67 (the TASK-0053 MCQ-feedback deploy, 2026-09-29 12:26 UTC) was
deployed from a `main` that already carried TASK-0051's scoring-exclusion check. That check selects
from `app.open_hand_scoring_exclusions` before grading and returns HTTP 500
`open_hand_eligibility_check_failed` on any error. Production had no such table, so every graded
submission in Production would have failed. Zero attempts had reached Production since v67, so no
student was affected.

**Approved scope:** migration `20260929130754_open_hand_scoring_exclusions_table_only.sql` — the
table section of `20260929034129` copied verbatim, nothing else — applied to Development (a no-op
there) and Production, with both ledgers recording the same version.

**Not authorized by this entry:** `public.get_open_hand_item` in Production, or any other part of
`20260929034129`. The answer-key RPC stays behind TASK-0051's end-to-end test, independent QA and
Production gate.

## APPROVAL-0061 — Execute TASK-0051 Open Hand Unification in Development

**Date:** 2026-09-29  
**Approved By:** David Bloom  
**Related Task:** `TASK-0051-OPEN-HAND-UNIFIED-ANSWER-KEY.md`  
**Related Decision:** `DECISION-0086`  
**Decision:** Approved

Approves execution of TASK-0051 in Development/task-branch scope: amending `get_open_hand_item` to
the entitlement-scoped access model with a view-only staff/QA bypass, making
`open_hand_scoring_exclusions.learning_session_id` nullable, repointing the `open-hand-item` edge
function at the RPC, consolidating the two competing branches onto one, Development migrations and
Development function deploys, and the end-to-end Dev verification in the task's checklist.

This approval does **not** authorize: any Production migration or function deploy; wiring the plate
loop to live data for students; or changing the `open-hand-item` response contract (the list-vs-
single-item disclosure question in TASK-0051 item 5) or the exclusion's version-vs-item keying
(item 7) — both are frontend/integrity contract changes needing the Product Owner's confirmation
first.

_Correction, 2026-09-29: an earlier version of this entry also withheld authorization for "a
workaround for the `evaluate-attempt` bundle-size limit." No such limit applies — it belongs to the
Supabase MCP deploy tool, not the platform, and the function has been deployed to Production via the
CLI. That clause is withdrawn; deploying `evaluate-attempt` to Development via the CLI is within this
approval._

_Numbering note: this entry took 0061 because `APPROVAL-0060` was then claimed by the unmerged PR
#259. **#259 merged 2026-09-29**, so 0060 is on `main` and the sequence is correct._

## APPROVAL-0060 — Execute TASK-0050 Skill-Dimension Rollout in Development, with AI-Gateway Spend

**Date:** 2026-09-29  
**Approved By:** David Bloom  
**Related Task:** `TASK-0050-SKILL-DIMENSION-ROLLOUT.md`  
**Related Decision:** `DECISION-0085`  
**Decision:** Approved

Approves execution of TASK-0050 subject by subject in Development/task-branch scope: CED sourcing
into fact packs (Phase 0), topic × skill grid migrations applied to Development (Phase A), and
model-consensus skill labeling of published MCQ and FRQ items (Phase B) — including the Vercel
AI-Gateway spend, per David, 2026-09-29: "create a plan for adding the skill dimension to each
subject. I authorize the vercel gateway cost. Use the CEDs."

This approval does **not** authorize: Production migrations or Production writes of any grid or
label; relaxing `content_item_cells_validation_check` or creating a system/service profile
(`DECISION-0085`'s open item); changing `DECISION-0074`'s mastery rule; or authoring new content
items. Each remains a separate Hard Gate, and Production stays gated per subject on David's explicit
go-ahead for that subject's content.

## APPROVAL-0059 — Execute TASK-0041 Purchase Funnel in Development

**Date:** 2026-09-28  
**Approved By:** David Bloom  
**Related Task:** `TASK-0041-LAUNCH-PAYMENT-FLOW.md`  
**Related Decision:** `DECISION-0083`  
**Decision:** Approved

Approves immediate execution of TASK-0041 in Development/task-branch scope using prices $39.99 single / $69.99 two-subject / $89.99 three-subject. Includes code, Development schema migrations, Development Edge Function deployment, sandbox read-only verification and non-live test-session creation, Lovable code edits without publish, and QA evidence collection.

This approval does **not** authorize Production migrations/deployments, live Stripe writes/configuration, secret changes, enabling live paid sales, Lovable Production publish, or final risk acceptance. Those remain separate Hard Gates.

## APPROVAL-0058 — Ship TASK-0039 BYOQ (Phases 1–2) to Production

**Date:** 2026-09-28
**Approved By:** David Bloom
**Related Task:** `TASK-0039-BYOQ-PRODUCTION-OPERATIONAL.md`
**Related Decision:** `DECISION-0084`
**Decision:** Approved

### Summary

Product Owner direction, 2026-09-28: "Work through all phases unless blocked. The goal is to get task
0039 into production." This authorizes the following Production changes:

- the two BYOQ migrations (`20260928150000_task0039_byoq_core`, `20260928160000_task0039_byoq_hardening`);
- the `byoq` edge function (`verify_jwt=false`, with its own owner-key, JWT, and capability auth);
- two Vault secrets (`byoq_purge_token`, randomly generated server-side; `byoq_function_url`);
- the `learner-uploads` 20 MB object cap;
- publishing the App and Marketing Lovable projects with the BYOQ screens and homepage link.

### Notes

- Phase 3 (worksheet upload) is not covered. It stays blocked on its design doc's open decisions.
- 2026-09-28: David confirmed `DECISION-0084` items 1–2: access is free and open, with a limit of 30 new questions per owner per day and 120 new anonymous users per IP per hour.
- 2026-09-28: David also confirmed item 3 (30-day anonymous retention) and item 7 (stuck-routing deferred).
- 2026-09-28: David approved item 8 as topic-level step-by-step hints: up to four hints from the published point brief, revealed one at a time, never specific to the student's question and never recorded. Published in the App.
- The eight "New gaps" defaults in `DECISION-0084` were chosen by the implementer under this
  direction and are flagged for explicit Product Owner confirmation or revision.
- Independent QA ran before the Production apply: one Fail round, with all four blocking findings
  fixed and re-verified on Development.

## APPROVAL-0057 — Execute TASK-0046 Subject Onboarding Gate in Ordered Per-Subject Slices

**Date:** 2026-09-28
**Approved By:** David Bloom
**Related Task:** `TASK-0046-SUBJECT-ONBOARDING-GATE-FULL-PROGRAM.md`
**Decision:** Approved

### Summary

Authorizes execution of TASK-0046's read-only Production six-criteria verification program after confirming TASK-0042 is Done. Execute the eight non-Day-1 subject slices in this order: AP Chemistry, AP Calculus AB, AP Calculus BC, AP Precalculus, AP Physics 1, AP Physics 2, AP Physics C: Electricity and Magnetism, AP Physics C: Mechanics.

### Notes

- This approval covers read-only Production verification and documentation updates only; it does not authorize Production data writes, migrations, deployments, secrets/configuration changes, payments, or launch.
- Preserve TASK-0046's required one-subject-per-slice branch/PR structure and fresh independent QA before any slice is marked Done.
- TASK-0042 was verified Done on 2026-09-28 from the canonical task record before execution began.


## APPROVAL-0056 — TASK-0042 Cross-Cutting Content-Pipeline QA Remediation and Subject-Scoped Production Writes

**Date:** 2026-09-27
**Approved By:** David Bloom
**Related Task:** `TASK-0042-LAUNCH-CONTENT-PIPELINE.md`
**Decision:** Approved

### Summary

Authorizes Codex to implement and verify the content-pipeline QA remediation described in the
Product Owner's 2026-09-27 execution handoff, including necessary subject-scoped Production data
corrections: reconstructing and auditing the original hashes for 216 prior promotions; reverting
stale or unverifiable promotions; applying the five specified Medium-to-Hard corrections; hardening
the runner; and completing safe remaining single-unit label writes.

This is a Product Owner exception to TASK-0042's one-branch-per-subject rule for the cross-cutting
remediation. Production changes remain durable, subject-identifiable migrations with exact counts.

### Limits

- Does not weaken `DECISION-0066`: multi-unit labels still require genuine independent third review.
- Does not authorize invented quantity targets or attainment ratios.
- Does not authorize replaying applied migrations, exposing secrets, or leaving the CLI Production-linked.
- Final acceptance requires fresh independent QA by an agent that did not author the fixes.

### Closeout addendum — 2026-09-27

David explicitly approved transmitting 141 current question packets—including stems, answers, and
rubrics—to Vercel AI Gateway using `anthropic/claude-haiku-4-5` for DECISION-0066's blind third
review. The review completed with 27 exact full-label confirmations, 66 disagreements, 48 rubric or
scope holds, and zero call errors. Migration
`20260927184534_task0042_promote_blind_third_review_confirmations` promoted only the 27 exact
matches. David also decided that the nine non-Biology subjects have no fixed quantity targets; see
`DECISION-0082`.

### ID reconciliation

This authorization was initially recorded in the task branch as `APPROVAL-0051`. When current
`main` was merged, that ID was already occupied by TASK-0044, so this record was renumbered to the
next free ID, `APPROVAL-0056`. Migration
`20260927181002_correct_task0042_approval_note_provenance` updated the 152 affected Production
validation-decision notes; it did not alter labels or promotion outcomes.

## APPROVAL-0055 — Adopt Lean Source-of-Truth Startup Mode (Tier-First Reading, `AGENTS.md`, Log `INDEX_END` Markers)

**Date:** 2026-09-27
**Approved By:** David Bloom
**Related Docs:** `prompts/CODEX_NEW_SESSION_PROMPT.md`, `prompts/CLAUDE_NEW_SESSION_PROMPT.md`, `AGENTS.md` (new)
**Related Decision:** `DECISION-0081`
**Decision:** Approved

David reviewed the Codex-authored startup-cost analysis and Claude's revised protocol draft directly
in-session, requested six tightening edits (tier-classification pointed at `AGENT_OPERATING_MODEL.md`
rather than redefined inline; softened "follow Session-Start Procedure" wording; constrained `SYNC`
to the same index-marker/exact-ID discipline; a narrow branch-hygiene read rule; non-eager skill
loading; an explicit `AGENTS.md`/`INDEX_END` precondition note), and approved shipping once applied.
Applied to both `CODEX_NEW_SESSION_PROMPT.md` and `CLAUDE_NEW_SESSION_PROMPT.md`. See `DECISION-0081`
for full rationale and scope.

## APPROVAL-0054 — Ratify Three Session-Start Bootstrap Edits (Live Front-Ends, Required First-Read, Anti-Stale Rule)

**Date:** 2026-09-27
**Approved By:** David Bloom
**Related Doc:** `docs/team_charter/CRAMAPPLE_SESSION_START.md` (governed bootstrap)
**Related Decision:** `DECISION-0078`
**Decision:** Approved

David ratified the three session-start bootstrap edits merged in PR #232 (live Lovable front-ends in the
Repository Map; required first-read of `ARCHITECTURE_AND_DESIGN_DECISIONS_CURRENT.md` + `docs/INDEX.md`
for architecture/design/front-end/session-mode/launch work; the anti-stale rule). They change routing and
guidance, not authority order or hard gates. In-doc "pending ratification" flags flipped to ratified. See
`DECISION-0078` for full text.

## APPROVAL-0053 — BYOQ Is Identity-Agnostic: `byoq_items.user_id` Not Required; Resolves the DECISION-0070/0068 Conflict

**Date:** 2026-09-27
**Approved By:** David Bloom
**Related Task:** `TASK-0039-BYOQ-PRODUCTION-OPERATIONAL.md`
**Related Decision:** `DECISION-0077`
**Decision:** Approved

David resolved the DECISION-0070 (ungated/anonymous BYOQ) vs. DECISION-0068 (authenticated `user_id`-keyed
schema) conflict directly, 2026-09-27: BYOQ is identity-agnostic — `byoq_items.user_id` is nullable
(recognition, not a gate), BYOQ runs anonymously on the marketing page and recognized in the app with
identical behavior, and the anonymous scoping mechanism is build work under TASK-0039. Amends the
Option A schema approved under `APPROVAL-0050`/`DECISION-0068`; the parallel-tables architecture is
unchanged. See `DECISION-0077` for full text.

## APPROVAL-0052 — TASK-0039 BYOQ Phase Priority Corrected (Camera-First) and Ownership Confirmed (Claude, Not Codex)

**Date:** 2026-09-27
**Approved By:** David Bloom
**Related Task:** `TASK-0039-BYOQ-PRODUCTION-OPERATIONAL.md`
**Decision:** Approved

### Summary

Approves `DECISION-0076`: corrects `TASK-0039`'s phase priority so camera/phone capture (originally
labeled "Phase 2") is the primary, launch-required BYOQ intake method, with typed/pasted intake
("Phase 1") shipping as a fallback rather than the first-shipped path. Confirms BYOQ implementation
ownership as Claude, superseding an earlier direction that had it as Codex's workstream (Codex is
instead working on the content pipeline). Does not reopen `DECISION-0068`/`APPROVAL-0050`'s
architecture/schema approval.

### Notes

- Found and reported, not yet resolved: `DECISION-0070` (2026-09-26) states BYOQ ships "ungated, as an
  anonymous session" — structurally in tension with the approved owner-scoped RLS schema, which assumes
  an authenticated `user_id`. This approval does not cover that question; it remains open.

## APPROVAL-0051 — Deploy the AP Statistics Combined Practice Selector (TASK-0044) to Production

**Date:** 2026-09-26 (approval); Production deploy actually reached via PR #227, 2026-09-27
**Approved By:** David Bloom
**Related Task:** `TASK-0044-LAUNCH-SUBJECT-ONBOARDING-GATE.md` (found the gap)
**Decision:** Approved

### Summary

Approves building and deploying to Production a fix for a gap TASK-0044 found: AP Statistics had
101/101 published MCQ items content-ready but zero servable through any backend RPC on the
flat/`targeted_drill` practice path, because `select_practice_frqs` is FRQ-only by design and the only
existing combined FRQ+MCQ selector (`select_biology_practice_items`) is Biology-only by design. Approves
the deploy itself: a new, additive `app.select_ordinary_combined_practice_items` Postgres function
(Biology's own selector is untouched) plus the corresponding `student-session-items` edge-function
routing change.

### CORRECTION, 2026-09-27: which branch actually fulfilled this approval

The branch this approval was originally requested for (`claude/task-0047-ap-statistics-mcq-serving`)
built only a `targeted_drill`-only routing, and its migration/edge-function version were applied to
Cramapple Development only — **never to Production**, despite this entry's original text. The branch
that actually shipped this approval's intent to Production, via `main` PR #227 on 2026-09-27, is
`codex/task-0044-statistics-mcq` — a superset that routes both `mcq` (the real Home session format) and
`targeted_drill` to the same new RPC. Independently verified byte-for-byte identical (function body,
comment, deployed edge-function source) to what Production was already running before the PR formally
landed it in `main`'s git history, so this approval's substance — approving this class of fix for this
diagnosed gap — was correctly fulfilled, just not by the branch originally named.

### Evidence

- Focused handler suite passing on the shipped branch, including Statistics Home `mcq` routing,
  Statistics `targeted_drill` routing, answer-field redaction, and missing-choice fail-closed behavior.
- Applied to Cramapple Development and called live against Dev's real AP Statistics content: correct
  MCQ-only results in `mcq` mode.
- Live post-merge verification against Production: `app.select_ordinary_combined_practice_items`
  returns 7 FRQ + 13 MCQ for AP Statistics, matching the pre-deploy dry-run projection exactly;
  `app.select_biology_practice_items` re-verified unchanged at 12 FRQ + 8 MCQ — confirms AP Biology's
  serving path was not affected.

### Notes

- Does **not** close TASK-0044 — a fresh, independent QA pass and Main Conductor integration are still
  required before it is marked `Done`.
- Does **not** substitute for actually verifying the live, student-facing AP Statistics MCQ experience
  end-to-end (`LAUNCH_RUNBOOK_2026_10_02.md` item 4) — this approval covers the backend serving path
  only.

## APPROVAL-0050 — BYOQ Data-Model Architecture (Option A) and TASK-0039 Phase 1 Scope

**Date:** 2026-09-26
**Approved By:** David Bloom
**Related Task:** `TASK-0039-BYOQ-PRODUCTION-OPERATIONAL.md`, Phase 1
**Decision:** Approved

### Summary

Approves `DECISION-0068`: BYOQ (bring-your-own-question) gets its own parallel data model
(`app.byoq_items`/`app.byoq_responses`, and later `app.byoq_capture_pairing_tokens`/
`app.byoq_attachments`) rather than generalizing the live `app.attempts`/`app.response_versions`/
`app.response_attachments`/`app.capture_pairing_tokens` tables, after an adversarial review found the
generalize-in-place option would leave a real path for a BYOQ item to reach the human-grading queue.
Authorizes starting `TASK-0039` Phase 1: the `byoq_items`/`byoq_responses` schema, a separate BYOQ
Practice screen sharing components with (never branching inside) the live graded Practice screens,
and the Home entry point.

### Notes

- Does **not** authorize Phase 2 (QR photo capture) or Phase 3 (worksheet parsing) — both remain
  gated on their own open items (`TASK-0039`'s Pre-flight verification step for Phase 2; the Open
  Decisions in `docs/product/BYOQ_WORKSHEET_PARSING_DESIGN.md` for Phase 3).
- Does **not** resolve `TASK-0039`'s "New gaps" list (entitlement/trial gating, rate limits/quotas,
  retention/deletion, consent copy, the private-until-promoted boundary, subject/taxonomy scoping,
  stuck-BYOQ routing, the hints/deep-dive floor) — these still need an explicit Product Owner call
  before Phase 1 ships to real students, separate from this schema/scope approval.

## APPROVAL-0049 — Pilot-Scale Operational Commitment for Hand-Drawn Manual Grading (TASK-0038 Phase 4)

**Date:** 2026-09-23
**Approved By:** David Bloom
**Related Task:** `TASK-0038-HAND-DRAWN-CAPTURE-REAL-STUDENT-HUMAN-GRADED.md`, Phase 4
**Decision:** Approved

### Summary

Approves `DECISION-0059`: a pilot-scale operational commitment for manual
hand-drawn grading, scoped to one item (`APBIO-HDG-2026-GRAPH-002`) and one
grader (David Bloom). Sets a 24-hour grading SLA with at least daily queue
checks; adopts a manual, logged-correction interim stance for disputes
(no regrade tooling exists yet); accepts that manually-graded students
receive a score but no repair prompt (`highestValueGap` stays null); and
adopts a two-stage rollout -- Stage 1 (admin-gated, one real end-to-end run
by David) before Stage 2 (a small named group, never the general Biology
population), with no further widening without revisiting this decision.

### Notes

- Does **not** close TASK-0020 Program C's Hard Gate -- that still needs the
  full multi-owner design (Learning Quality, Operations, Privacy/Security)
  for any broader launch. This approval covers only the one-item, one-grader
  pilot scope named in `DECISION-0059`.
- Does not authorize lifting `/session-hand-drawn-pilot`'s admin gate by
  itself -- Stage 1's real end-to-end run must happen and be reported first.

## APPROVAL-0048 — Promote `APBIO-HDG-2026-GRAPH-002` to Human-Graded-Pilot-Approved (TASK-0038 Phase 2)

**Date:** 2026-09-23
**Approved By:** David Bloom
**Related Task:** `TASK-0038-HAND-DRAWN-CAPTURE-REAL-STUDENT-HUMAN-GRADED.md`, Phase 2
**Decision:** Approved

### Summary

Approves `DECISION-0058`'s operational definition of "approved" for hand-drawn
`label_status` (human-graded-pilot-ready; explicitly not AI-grading-ready, not
rights-cleared) and names `APBIO-HDG-2026-GRAPH-002` (`content_item_version_id
1c29347d-0f41-4f09-96a7-6f863be82eaf`) as the item promoted under it, after
reviewing its real `content_review_decisions` trail (one flagged concern, fixed and
re-approved 2026-08-08) rather than the `review_status` label alone. Authorizes
updating `prompt_json.label_status` on this item from `ai_provisional_unapproved` to
`human_graded_pilot_approved` in Production.

### Notes

- This approval covers this one item only; it does not blanket-approve the other 23
  reviewed-but-`ai_provisional_unapproved` hand-drawn items, and does not authorize
  Phase 3 (real `/session` frontend wiring) or Phase 4 (a real human-grading queue)
  — each remains its own go-ahead per TASK-0038's Hard-Gate tier.
- Does not certify automated grading readiness (DR-1 remains failed, unchanged) or
  content rights/authorship (`rights_status` remains
  `independently_authored_synthetic_research_seed_unverified`).

## APPROVAL-0047 — Device-Neutral Cramapple Bootstrap and Shared ChatGPT Project Contract

**Date:** 2026-09-22
**Approved By:** David Bloom
**Related Task:** Cramapple mobile/desktop context parity
**Decision:** Approved

### Summary

Approves DECISION-0054 and the narrowly scoped governance changes that make the existing
Cramapple ChatGPT Project use one current GitHub bootstrap across desktop, iPhone, ChatGPT Work,
Codex, and Claude. Approval covers the new session-start and Project-instructions documents,
their startup-prompt/README links, and the associated governance records.

### Notes

- Keep the existing Cramapple Project on Default memory while ChatGPT Work is part of the workflow.
- Do not create a separate mobile Cramapple Project.
- GitHub remains authoritative; Project memory and prior chats provide continuity but do not replace current repository or live-service verification.
- This approval does not authorize a Production deployment, migration, secret change, payment action, or other live-system mutation.

## APPROVAL-0046 — Confirm QR Handoff as Engine 4's Sole Capture Path; Approve Capture-Failure Handling Split

**Date:** 2026-08-19
**Approved By:** David Bloom
**Related Task:** TASK-0016 Phase D, TASK-0025
**Decision:** Approved

### Summary

Approves `DECISION-0051`: reaffirms QR handoff (System A) as Engine 4's sole capture path with no
direct-upload fallback, resolving the System A/System B ambiguity in favor of TASK-0016's original
decision #10. System B's `SameDeviceCapture` frontend stays superseded/pilot-only; its
`attach_capture`/`app.response_attachments` backend is approved for reuse as System A's storage
layer. Also approves the capture-failure handling split: generic retake guidance on image-quality
failures, bug-logged on technical failures.

### Notes

- Does not itself authorize any Production deployment or migration — Stage D2 implementation
  still follows this program's normal deploy discipline (diff-before-deploy, Dev-before-Prod).
- Does not resolve the pre-existing `capture_quality_state`/`capture_retake_reason` frontend/
  backend contract mismatch — separate follow-up.

## APPROVAL-0045 — Retire Engine 4's Dual-Human-Adjudicated Gold Requirement; Adopt the DECISION-0045 Gold Model

**Date:** 2026-08-19
**Approved By:** David Bloom
**Related Task:** TASK-0016 Phase D, TASK-0011
**Decision:** Approved

### Summary

Approves `DECISION-0050`: retires the ≥300-response, ≥40-per-archetype dual-human-adjudicated
gold-set requirement as a hard gate specifically for Engine 4 (spatial/hand-drawn grading), and
un-defers `DECISION-0045`'s Set C — Engine 4 gold-set construction now follows the same
AI-generation + two-independent-non-OpenAI-model-verification + reader-certification protocol
already governing every other engine, with the same independence constraints.

### Notes

- Does not waive corpus-readiness requirements (consent/provenance manifest, deduplication,
  metadata stripping) the existing photo corpus still needs per its own 2026-08-03 readiness
  audit.
- Does not retroactively certify the existing 200-photo real-Biology corpus's single-pass-AI gold
  as meeting the new standard — a `DECISION-0045`-protocol pass still needs to actually run
  against it before it's launch-qualifying evidence.
- Surfaced and requested during Stage D0 execution of TASK-0016 Phase D
  (`docs/research/grading_phase_d_spatial_2026_07_27/`), which had identified the old requirement
  as Engine 4's largest concrete blocker.

## APPROVAL-0044 — Replace Free Score Check with 7-Day Trial; Enable GRADING_ENTITLEMENTS_ENABLED (TASK-0026)

**Date:** 2026-08-15
**Approved By:** David Bloom
**Related Task:** TASK-0026
**Decision:** Approved

### Summary

Approves `DECISION-0047`: replaces the never-launched activation-limited
Free Score Check with a 7-day full-catalog trial, and authorizes enabling
`GRADING_ENTITLEMENTS_ENABLED=true` in Production as part of that change.

### Notes

- Resolves the gap `APPROVAL-0043`'s notes identified: that flag stayed
  `false` specifically because "no path for a new, unprovisioned student to
  get entitled" existed. `app.start_trial` is that path -- verified via
  direct RPC test against a real production attempt (both a pre-existing
  `beta` account, confirming no regression, and a freshly granted trial
  row, confirming the new path works) before flipping the flag.
- The flip was sequenced deliberately: migration + Edge Function deployed
  first, smoke-tested, then the flag set as a discrete, reversible secrets
  change -- not bundled with any other production change, given the
  documented history of an outage from flipping a related flag blind.
- FSC entitlement machinery (table, RPCs, Edge Function) was dropped from
  Production and Dev only after the trial path was verified working, so
  there was no window where neither model granted access.
- Does not itself approve the Loops lifecycle-email vendor choice or the
  day-2/day-7 PostHog scheduled-job gap -- those are tracked separately in
  TASK-0026, not launch-blocking.

## APPROVAL-0043 — Retire the ≤1000ms p50 Grading Latency Gate; Approve Engine 1/3 Go-Live Ahead of Full Gold-Set Certification

**Date:** 2026-08-14
**Approved By:** David Bloom
**Related Task:** TASK-0016
**Decision:** Approved

### Summary

Approves `DECISION-0046`: retires the ≤1000ms end-to-end p50 grading-latency
hard gate (originally set under `APPROVAL-0033`, 2026-07-08) in favor of a
two-SLA framing (time-to-acknowledgement / time-to-complete-feedback), and
authorizes Engine 1 (once its evidence-grounding P0 fix ships) and Engine 3
(shadow-only) to go live in Production ahead of the full 300+
dual-adjudicated gold-set certification originally required as a launch
gate. Full rationale and evidence in `DECISION-0046`.

### Notes

- Does not reopen the Quality > Speed > Cost priority order (2026-07-29
  owner decision) — the numeric latency target is what changed, not the
  ordering.
- The gold-set certification program continues in parallel as a dependency
  for later production-authority stages (per TASK-0016's 2026-08-13
  addendum, the five-stage model: offline → shadow → beta-audited →
  sampled-audit → broad), not waived outright.
- `GRADING_ENTITLEMENTS_ENABLED` (whether to gate grading behind
  entitlements at initial go-live) is explicitly **not** covered by this
  approval. **Resolved 2026-08-14, separately from this approval: stays
  `false`.** Investigation found `app.authorize_grading_access` requires an
  entitlement-granting path (`subject_entitlements` or `free_score_checks`).
  **Corrected 2026-08-14 (QA-caught, codex):** the original note here said
  this path "doesn't yet exist for any real student" — inaccurate;
  `subject_entitlements` has 71 active rows across 8 `student`-role
  accounts (all internal/family/test, none an unrelated real customer). The
  operative point stands — no path for a *new, unprovisioned* student to
  get entitled — but turning the flag on would not "block all grading,"
  it would leave the 8 already-provisioned accounts working. See TASK-0016
  addendum item 4 for the full correction.
- This approval covers the launch-bar scope change only. Each actual
  Production deploy/migration under this work still follows its own
  deploy discipline (diff-before-deploy, create→run→cleanup for any live
  test data) as already practiced in this program.

## APPROVAL-0042 — Lock TASK-0020 Launch Slice and Assessment Baselines

**Date:** 2026-08-03
**Approved By:** David Bloom
**Related Task:** TASK-0020
**Decision:** Approved with Notes

### Summary

Lock the deep assessment to all 48 published AP Statistics targeted-drill FRQs plus all 41 published AP Biology FRQs. Do not narrow the 89-item assessment scope to manufacture a readiness verdict.

### Notes

- Essential question visuals fail closed and may be replaced only with an already approved construct-equivalent item or representation.
- Manual review is the launch baseline for hand-drawn responses; automation remains shadow-only until its independent grading and repair evidence bars pass.
- Every officially supported answering-device class must have a viable paper-photo capture route; use QR/cross-device handoff where the answering device cannot satisfy that requirement.
- Any later item/archetype removal from launch scope requires a separate Product Owner and Learning Quality decision.
- Construct-sensitive classification and accessible-equivalence judgments still require Learning Quality validation before final launch verdicts.

## APPROVAL-0041 — Execute Image and Drawn-Response Launch-Gating Assessment

**Date:** 2026-08-03
**Approved By:** David Bloom
**Related Task:** TASK-0020
**Decision:** Approved with Notes

### Summary

Execute the read-only assessment in `IMAGE_AND_DRAWN_RESPONSE_LAUNCH_GATING_ASSESSMENT_PLAN_V5_2026_08_03.md`. Determine the launch blockers, safe named scope, and reliable implementation paths for required prompt visuals and hand-drawn response capture, preservation, review, grading, and repair.

### Notes

- Approval covers read-only repository, Production, deployment, storage-metadata, and browser/API assessment; reproducible inventory; launch verdicts; and proportional next-approval remediation handoffs.
- The cheap cross-course scan may begin immediately. Deep Step 2 requires the Product Owner-selected launch slice and the Product Owner/Learning Quality-approved minimum viable content volume.
- No schema, API, frontend, deployment, configuration, storage-object, learner-data, or Production mutation is approved.
- No real learner/minor image access, new vendor/model selection, operational manual-review setup, automated learner-facing grading, risk acceptance, or launch is approved.
- The quarantined branch `codex/image-workflows-design-sketch` at `a34a078` remains inert and must not be merged or used as baseline architecture.
- Final QA requires a genuinely fresh independent context before the task reaches an owner decision.

## Approval Format

```markdown
## APPROVAL-0000 — Approval Title

**Date:** YYYY-MM-DD
**Approved By:** David Bloom / [Delegated Domain Approver name]
**Related Task:** TASK-0000 / N/A
**Decision:** Approved / Rejected / Approved with Notes / Done / Not Done / Do Not Do / Approved (Batch) / Approved (Domain)
**Decided By:** (required when Decision is Approved (Domain) — names the domain approver)
**Applies To:** (required when Decision is Approved (Batch) or Approved (Domain) — agents/roles/tasks the approval covers)
**Expires / Review Trigger:** (required when Decision is Approved (Batch) or Approved (Domain); end-of-day inclusive, America/New_York, or a named condition)
**Status:** Active / Expired / Superseded (required when Decision is Approved (Batch) or Approved (Domain))

### Summary

What was approved or rejected?

### Notes

-
```

**Conflict rule:** if `Expires` has passed but `Status` still reads `Active`, the approval is treated as expired regardless of the recorded status — the date wins. `Status: Superseded` overrides date-based validity even before expiration.
