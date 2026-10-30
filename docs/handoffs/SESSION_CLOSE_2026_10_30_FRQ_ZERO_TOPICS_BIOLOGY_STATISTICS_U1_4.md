# Session Close: FRQ Census and 16 New FRQs for Zero-FRQ Topics, Biology and Statistics Units 1-4 (2026-10-25 to 2026-10-30)

**STATUS:** Authored, checked and approved; **NOT published.** The Production publish (`APPROVAL-0201`) has not run.
**OWNER / PRODUCT OWNER:** David Bloom
**BRANCH:** `claude/frqs-jjjc96` (restarted from `main` after each merge; currently equal to `main`)
**PRs:** #566 (the 16 FRQs, batch, pipeline change, draft script and approval entry; merged 2026-10-25) and #571 (`APPROVAL-0201` recorded; merged 2026-10-28)
**APPROVALS:** `APPROVAL-0201` (publish 16 FRQs to Production), recorded before any Production write. Executed: no.
**BATCH RECORD:** `scripts/content-seed/frq-u4-zero-topics-2026-10-25/README.md`

## 1. Current task

Start a session on FRQs, which became: explain why a student is never served an FRQ, compare FRQ-variant cost with in-session authoring, census published FRQs by topic for Biology and Statistics Units 1-4, then author two new FRQs for every topic with none, check them, and publish them to Production.

## 2. What changed this session

1. **Why a student may never see an FRQ (analysis only, no change).** The backend selector `select_student_practice_items` (migration `20261022131017`) serves an FRQ only if it is published, short or long form, has a validated hash-matched serving label, is not a teaching item, is at or below the student's unit, and has not been attempted or opened in Open Hand. It mixes MCQ, quantitative and FRQ items in one queue ordered by topic match, then highest required unit, then publish date; it has no FRQ quota. When the app asks for FRQs (modes `frq_only`, `unit_gated`, `cell_scoped`, an `item_type` filter) is decided in the Lovable client, which is not in this repo and was not read. The "2 MCQ + 1 FRQ" mastery rule (D7) is unbuilt. An early claim that Units 4+ "have no FRQs" was wrong and was corrected: the Units 1-3 session only did no work on Units 4+.
2. **Variant cost (analysis only).** The repo has no cost data for FRQ variants (all recorded variant runs were MCQ). Measured comparison point: in-session authoring with gateway checks cost about $0.20 per FRQ in the Units 1-3 batch.
3. **Census (read-only, Production, 2026-10-25).** Published FRQs by primary topic, Units 1-4: Biology 38 (36 servable), Statistics 77 (74 servable). Zero-FRQ topics: Biology 4.2, 4.6; Statistics 4.2, 4.4, 4.6, 4.7, 4.8, 4.9. Topics with FRQs that are not servable: Biology 4.3 (its only FRQ), Statistics 4.1 (its only FRQ); one unservable FRQ each in Biology 2.1 and Statistics 1.13 and 3.15. Why they are unservable was not diagnosed.
4. **16 FRQs authored** (2 per zero-FRQ topic) in `scripts/content-seed/frq-u4-zero-topics-2026-10-25/`, checked with the existing pipeline over three rounds, all 16 accepted. `frq_pipeline.mjs` gained `--max-unit=N` (default unchanged).
5. **Publish script and approval drafted, then approved and recorded** (`publish_frq_batch.py`, `plan.json`, `APPROVAL-0201`). David approved: "I approve document it and run those steps".
6. **Publish not run.** See section 5.

## 3. What was verified

| Check | Result |
|---|---|
| Lint and exact recompute (t critical values and Welch df re-derived with mpmath) | 16/16 pass, re-run after every revision |
| Six-vote topic probe | 16/16 on target (5 or 6 of 6) |
| GPT-6.1 Sol and DeepSeek V4 Pro (blind solve, scope audit, rubric re-derivation) | 16/16 pass on the final text; rounds accepted 4, then 9, then 16 |
| Model answers graded by a third family (gemini-3.8-flash, `answer_grades.json`) | 16/16 full credit |
| Accepted text equals the authored file for all 16 slots | yes (checked) |
| Production preflight, read-only via the Supabase connector, 2026-10-28 | both exam packs published; none of the 8 topics has a published FRQ; none of the 16 `frq-u4z` keys exists. Not re-run since. |
| `publish_frq_batch.py` offline | compiles; builds `plan.json` (16 rows, 2 per topic, unique keys); renders the rehearse and commit SQL for both subjects with the topic guard present |
| `APPROVAL-0201` on `main` | yes, no number collision (0202 and 0203 are other records) |

Gateway spend: **$4.59** (446 calls): GPT-6.1 Sol $2.56, DeepSeek V4 Pro $1.80, gemini-3.8-flash $0.23.

## 4. What remains open

1. **Run the Production publish** (`rehearse`, `publish --confirm-production`, `verify`), then recount the census (each of the 8 topics should have exactly 2).
2. **Biology 4.2 versus 4.3 ruling (owner).** Five cascade/amplification versions of a Biology 4.2 item each voted 6 of 6 for 4.3, including after the CED's own 4.3 example (epinephrine and glycogen) was replaced. The vote was not overridden. The accepted Biology 4.2 items test receptor location and ligand recognition (EK 4.2.B.1), not cascade amplification (EK 4.2.B.2). Decide: override on CED text, or label such items 4.3.
3. **The five unservable FRQs** in the census (Biology 2.1 and 4.3, Statistics 1.13, 3.15 and 4.1) are undiagnosed (missing or stale label, teaching flag, or form).
4. **Optional:** a Development content-only copy of the 16 (as the Units 1-3 batch had); not requested.
5. **Optional:** a measured FRQ-variant cost pilot (about 10 seeds, 30 variants) if the variant-versus-new-FRQ comparison is wanted.
6. **Delete the Supabase access token** David created once the publish is verified (it is account-wide, so it reaches Production).

## 5. Blockers and risks

- **Blocker: the token is not available to the session that was running.** `publish_frq_batch.py` reaches Production with a Supabase CLI access token (`SUPABASE_ACCESS_TOKEN` or `~/.supabase/access-token`). None existed in this cloud container. David then added `SUPABASE_ACCESS_TOKEN` as an environment variable, but environment variables reach only sessions started afterwards; the script's preflight in the running session found no token and stopped before any request. Nothing reached Production.
- Hand-pushing the generated SQL (about 113,000 characters) through the Supabase connector was rejected: the in-transaction hash check covers question text and rubric, not model answers, titles or stored metadata, so a transcription slip could reach Production unnoticed.
- The auto-mode classifier denied one Production command (an unnecessary `publish --env prod` guard test, my error) and one credential presence check. Neither is a repo issue; the script itself is the only thing that should read the token.
- Gaps accepted in `APPROVAL-0201`: planted-defect controls not re-run for this batch (the Units 1-3 run's 8/8 is the only evidence); production grader QA not run; human review waived; difficulty provisional; CED scope from extracted topic text plus the fact packs.
- The Supabase connector disconnected and reconnected several times in the session; do not rely on it for the publish.

## 6. Files changed or checked

- New: `scripts/content-seed/frq-u4-zero-topics-2026-10-25/` (README, `build_bio.py`, `build_stats.py`, `revise_round1.py`, `authored_*.json`, `inputs/`, `slots/` with every check and arbitration ruling, `answer_grades.json`, `calls.jsonl`, `summary.json`, `publish_frq_batch.py`, `plan.json`, `APPROVAL_DRAFT.md`).
- Edited: `scripts/vercel-gateway-check/frq_pipeline/frq_pipeline.mjs` (`--max-unit`).
- Records: `docs/activity_log/APPROVAL-0201_FRQ_ZERO_TOPICS_BIOLOGY_STATISTICS_U1_4_PRODUCTION_PUBLICATION_2026_10_28.md`, `APPROVALS_LOG.md` index, this handoff, `ACTIVITY_LOG.md`, `docs/INDEX.md`.
- Read: `docs/handoffs/SESSION_CLOSE_2026_10_10_FRQ_GAP_FILL_UNITS_1_3.md`, `scripts/content-seed/frq-u13-gap-fill-2026-10-09/` (README, publish script, inputs), the two CED fact packs, `supabase/migrations/20261022131017_task0078_align_student_rpcs.sql`, `supabase/functions/student-session-items/index.ts`.

## 7. Commands and results (key ones)

```bash
node scripts/vercel-gateway-check/frq_pipeline/validate.mjs authored_all.json          # 16/16 pass
node scripts/vercel-gateway-check/frq_pipeline/frq_pipeline.mjs run --batch=<dir> --checkers=openai/gpt-6.1-sol,deepseek/deepseek-v4-pro --max-unit=4
node scripts/vercel-gateway-check/frq_pipeline/frq_pipeline.mjs answers --batch=<dir>  # full credit 16/16
python3 publish_frq_batch.py plan                                                       # 16 FRQs planned: biology 4, statistics 12
python3 publish_frq_batch.py preflight --env prod                                       # failed before any request: no token in that session
```

Production reads were SQL `SELECT`s only (census, preflight) through the Supabase connector. No Production or Development write happened this session.

## 8. Approval state

`APPROVAL-0201` is recorded and approved by David Bloom for the Production publish. Remaining owner decisions: the Biology 4.2/4.3 ruling; whether to run the optional Development copy or variant pilot. No other approval is pending.

## 9. Exact next step

**Next owner:** David Bloom starts a new session in this repo (the `SUPABASE_ACCESS_TOKEN` environment variable now exists, so the new session will see it). **Single best next action:** in that session, run the `APPROVAL-0201` publish steps and record the result.

## 10. Do not touch next session

- The 126 published `*-frq-u13g-*` items and the 183 `APPROVAL-0143` topic cells (change only via a new version or recorded retirement).
- The accepted slot files and `plan.json`: do not edit items in place (the stored-text hash would stop matching). Regenerate `plan.json` only with `publish_frq_batch.py plan`, and only if an item is re-accepted.
- Do not re-run the paid checkers unless an item changes.
- Do not override the Biology 4.2 topic vote without David's ruling.
- Do not push the generated SQL through the Supabase connector by hand.
- Never paste the token into chat; delete it after the publish is verified.

## Recommended prompt for the next agent

> Read `docs/handoffs/SESSION_CLOSE_2026_10_30_FRQ_ZERO_TOPICS_BIOLOGY_STATISTICS_U1_4.md` and `docs/activity_log/APPROVAL-0201_*.md`. `APPROVAL-0201` is approved and recorded. In `scripts/content-seed/frq-u4-zero-topics-2026-10-25`, run `python3 publish_frq_batch.py preflight --env prod`, then `rehearse --env prod --approval APPROVAL-0201`, then `publish --env prod --approval APPROVAL-0201 --confirm-production`, then `verify --env prod`, and recount the census for Biology and Statistics Units 1-4 (each of the 8 topics should have exactly 2). If the token is missing, stop and say so. Then fill in the Execution section of the approval record, add the result to the activity log, and open a PR.
