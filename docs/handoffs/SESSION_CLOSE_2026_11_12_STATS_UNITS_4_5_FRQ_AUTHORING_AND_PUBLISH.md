# Session Close: AP Statistics Units 4-5 FRQ authoring, cost measurement and content-only publish (2026-11-12)

**STATUS:** Done for the agreed scope. 30 FRQs live in Production as content only (no labels). PR #638 merged.
**OWNER:** David Bloom. **APPROVAL:** APPROVAL-0257 (`docs/activity_log/APPROVAL-0257_STATS_UNITS_4_5_FRQS_CONTENT_ONLY_PRODUCTION_2026_11_12.md`).
**Batch record:** `scripts/content-seed/frq-stats-u5-2026-11-12/README.md` (method, results, full cost report; batch 1 at the root, batch 2 in `r2/`).

## 1. What was asked
Author FRQs for Statistics Units 5 and 6 with exact cost. There is no Unit 6 (five units in the registry and the 2027 CED fact pack), so David confirmed Unit 4 as the stand-in. Then: add a difficulty target (anything rated Easy is too easy for AP level), re-author the Easy seeds with two variants each, publish, labels out.

## 2. What changed
1. **Batch 1:** 15 seeds + 15 variants (Unit 5: 5+5; Unit 4: 10+10), a rubric pattern library, a diff-style variant check (`frq_pipeline/variant_check.mjs`), a cost ledger. Gateway $5.7535 (450 calls): seed average $0.3191, variant $0.0507 (about 16 percent of a seed).
2. **Difficulty target** (`rubric.mjs` scale, `--min-difficulty=Medium`: any checker rating Easy rejects; variants flagged if easier than the parent). 10 of 15 batch-1 seeds had been rated Easy.
3. **Batch 2 (`r2/`):** 10 re-authored seeds (9 Medium by both checkers; 5.3 split Medium/Easy, owner-accepted as an exception) and 20 variants (two per seed), all diff-checked. Gateway $5.1715 (398 calls): seed average $0.4122, variant $0.0525. Combined gateway $10.925; authoring estimate about $0.5 marginal to about $9.1 whole-session (estimate, not measured).
4. **Publication (APPROVAL-0257):** 30 FRQs (`apstats-frq-u45r2-<topic>-s|v1|v2`) published to Production in one rehearsed transaction, content only: no topic cells, serving labels or difficulty rows. Tool: `r2/publish_frq_content_only.py`.
5. **PR #638** merged after fixes for review findings (unsafe-call blocklist in variant scripts, actual-shape structural check, difficulty gate in the authoring branch, restored an unrelated activity-log entry my edit had deleted).

## 3. Verified
- 30/30 published, text hashes match the plan, model answer on each, 177 criteria rows; 0 cells and 0 labels (as approved). Model answers graded 78/78 by a third family across batches. Seeds: 25 + 25 full-check runs; every checker flag arbitrated and recorded (`arbitration_u4.md`, `r2/arbitration.md`).

## 4. Not verified / open
- **The 30 FRQs are not servable by topic until labeled.** A fresh-context prompt for the labeling pass is `docs/handoffs/PROMPT_LABEL_GAP_AUDIT_AND_PUBLISH_UNITS_1_5_2026_11_13.md`.
- No student-side serving or grading check; no authenticated app check.
- Distinctness versus the 26 published Statistics 4.x/5.x FRQs was compared by title only (closest: published matched-pairs 5 km item for 4.4).
- Five batch-1 split-rated seeds (5.2, 4.1, 4.2, 4.8, 4.10) and their variants are unpublished and were not re-rated under the new gate. The superseded Easy batch-1 items are unpublished.
- Seed-side planted-defect controls were not re-run.
- 5.3 stays a topic-ceiling exception (one calculation plus extrapolation).

## 5. Lessons
- **No difficulty target means Easy items.** Author to a stated difficulty and gate on it; the checkers' "difficulty for a student who just studied the topic" scale hides it. Use "any checker Easy" not majority-with-ties-to-Medium.
- **Harder demands must be real:** failed condition checks, a trap in the context, critique of a student's claim, solving for an unknown. Longer prompts do not move the rating.
- **Pattern library + one template per topic** makes a variant a config diff; the diff check then costs about $0.04 and caught real variant defects (easier than parent; population wider than the sample frame; causal wording in an observational study).
- **Pilot every lint rule on real items** (the bare word "plot" in "residual plot" tripped the draw rule again).
- **Gateway balance is not attribution** on the shared key; price calls from token usage.
- **Python 3.9** here: no `statistics.correlation`, no backslashes in f-string expressions; a BSD `sed -i` needs `''`.
- **My own doc edit deleted another session's activity-log entry**; rebuild a log from `main` and add only your entries.

## 6. Exact next step
Run the labeling prompt in a new context window (labels for the 30 FRQs plus every other gap in Units 1-5, all subjects). Owner of the PR for any scripts: David.

## 7. Do not touch
- The 30 published `apstats-frq-u45r2-*` items: change only by new version or recorded retirement (rollback = retire those keys).
- The batch-1 items kept on record in `authored/`, `slots/`, `variants/` (not published; the comparison baseline).
