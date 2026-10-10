# Session Close: FRQ Coverage Audit, Topic Labels and FRQ Gap Fill, Units 1-3 (2026-10-09 to 2026-10-10)

**STATUS:** Done for the agreed scope. 126 new FRQs live in Production and Development; every Units 1-3 topic has at
least one FRQ. The original two-per-topic goal is not met (202 topics have exactly one).
**OWNER / PRODUCT OWNER:** David Bloom
**BRANCH:** `claude/frq-seeded-generation-2026-10-09` (worktree `.worktrees/frq-gen-2026-10-09`)
**PRs:** #396 (merged 2026-10-10: audit + topic labels, APPROVAL-0143); **#400 open** (gap fill, APPROVAL-0146; contains
scripts, so the merge is David's)
**APPROVALS:** APPROVAL-0143 (181 + 2 FRQ topic cells), APPROVAL-0146 (126 FRQs published). 0144/0145 are held by
open PRs #398/#399.
**BATCH RECORD:** `scripts/content-seed/frq-u13-gap-fill-2026-10-09/README.md` (method, rulings, outcome, spend)

## 1. Current task

Start an FRQ generation session using the content authoring protocol with existing FRQs as seeds; first audit which
Units 1-3 topics have no FRQ; label FRQs with the question-labeling protocol; then create FRQs. Scope as finally set by
David: **Units 1-3 only, one FRQ per topic that has none, never for a topic that already has one.**

## 2. What changed this session

1. **Coverage audit (read-only).** 126 of 271 Units 1-3 topics had no published FRQ.
   `docs/qa/FRQ_UNITS_1_3_TOPIC_COVERAGE_AUDIT_2026_10_09.md`.
2. **Topic labels (APPROVAL-0143, Production).** 339 untagged FRQs labelled with the Units 1-3 runbook six-vote probe
   (gemini-3.8-flash, deepseek-v4-pro, gpt-6.1-sol x2, accept at 5 of 6; $8.26). 181 validated primary topic cells
   written, plus 2 held items resolved from the official CED PDFs in `subject packs/` (Calc BC u13-015 → 3.6,
   Precalc np2-004 → 3.10). Units 4+ probe results were NOT written.
3. **FRQ pipeline built.** `scripts/vercel-gateway-check/frq_pipeline/` (`frq_pipeline.mjs run|report|controls|answers`,
   `rubric.mjs`, `validate.mjs`). Gates: lint, exact sympy recompute, six-vote topic probe, two checkers (GPT-6.1 Sol +
   DeepSeek V4 Pro, the Product Owner's pick) that solve blind then audit scope (AQP §4) and re-derive the rubric (§9),
   planted-defect controls (8/8 caught, re-run after rule changes).
4. **Paid-author run, then stopped.** Claude Opus 5.5 via the gateway authored 20 accepted FRQs for $47.09 (lint bugs and
   checker calibration wasted about $14; the gateway ran out of credit mid-run). David: "I cannot afford to spend
   another $45 to get 20 questions… Don't use Opus as primary author - that is your job… arbitrate and correct ambiguities."
5. **Session authoring.** 104 FRQs written in session (eight parallel sub-sessions, self-contained briefs in `briefs/`
   built from the CED PDFs and unit-scoped fact packs). Calc AB 1.1 and 2.1 are David's own drafts, rewritten to their
   CED topics. Checks only via the gateway: **$21.24 for 106 FRQs (about $0.20 each).**
6. **Arbitration (three rounds).** Genuine rubric defects fixed; wrong checker claims rejected after recomputation (e.g.
   Chemistry 3.12 photon energy, Precalc 2.6 residual); topic overlaps ruled by CED text. Every ruling is in the slot
   file's `arbitration.log`. Three items accepted on arbitration after every objection was rejected (Physics 1 2.2,
   Precalc 3.3, 1.4).
7. **Development (content-only, David's choice).** Exam packs created for the 8 subjects Development lacked (data only);
   126 FRQs published there (no unit labels or difficulty: Development lacks those tables and `taxonomy_relevant_hash`).
8. **Production (APPROVAL-0146).** 126 FRQs published, one rehearsed transaction per subject.

## 3. What was verified

| Check | Result |
|---|---|
| Production publish verify (text hash, primary topic, fresh validated label) | 126/126 |
| Development verify (text hash) | 126/126 |
| Units 1-3 topics with no FRQ, Production recount | 0 of 271 (was 126) |
| Model answers, third-family grading (gemini-3.8-flash) | 126/126 full credit |
| Biology model answers on the production grader (`app.qa_grade_frq`) | 10/10 full marks |
| Live selector `select_student_practice_items`, topic match | served (Calc AB 1.4, Bio 3.1, Stats 3.6) |
| Planted-defect controls, both checkers | 8/8 caught, before and after calibration |
| Topic-cell write APPROVAL-0143 | 183 cells, hash-verified, in `content_item_topic_resolution` |

## 4. What remains open

1. **202 Units 1-3 topics have exactly one FRQ.** David's original goal was two per topic. The same in-session method
   would cost about $40 in checks. Not started; needs David's go-ahead.
2. **Units 4+**: no audit-driven FRQ work; the 158 Units 4+ topic-probe labels from the audit were not written.
3. **Two serving labels** still give primary unit 2 for items whose topic is Unit 3 (`apcalcbc-frq-u13-015`,
   `apprecalc-frq-np2-004`); required units already include 3, so serving is unaffected.
4. **Development schema lag:** no `content_item_difficulty`, no `content_taxonomy_validation_decisions`, no
   `taxonomy_relevant_hash()`; 170 vs 331 migrations. The Development FRQs are a content copy, not a serving test.
5. **Production grader QA path** grades only published AP Biology; other subjects' model answers were verified by a
   third model instead (accepted by David for this batch).

## 5. Blockers and risks

- No blockers.
- Risk: `difficulty` on the new FRQs is a provisional checker majority (`confidence = low`) until attempt data exists.
- Risk: three FRQs were accepted on Claude's arbitration over a checker objection (recorded reasons in the slot files).
- The gateway account ran out of credit once; check the balance before any new paid run.

## 6. Files changed or checked

- New: `docs/qa/FRQ_UNITS_1_3_TOPIC_COVERAGE_AUDIT_2026_10_09.md` (+ `docs/qa/evidence/frq_units13_audit_2026_10_09/`),
  `scripts/content-seed/frq-topic-labels-u13-2026-10-09/`, `scripts/content-seed/frq-u13-gap-fill-2026-10-09/`
  (README, inputs, briefs, authored, arbitration, slots, plan.json, publish/dev loaders, answer_grades.json,
  production_grader_biology.json), `scripts/vercel-gateway-check/frq_pipeline/`, this handoff.
- Edited: `docs/activity_log/APPROVALS_LOG.md` (0143, 0143 amendment, 0146), `docs/activity_log/ACTIVITY_LOG.md`,
  `docs/INDEX.md` (pointer to this handoff).
- Read: AQP v0.6, seeded generation protocol, Units 1-3 runbook, CED PDFs in `subject packs/`, fact packs.

## 7. Commands and results (key ones)

```bash
node scripts/vercel-gateway-check/frq_pipeline/frq_pipeline.mjs run --batch=<dir> --checkers=openai/gpt-6.1-sol,deepseek/deepseek-v4-pro --no-author
python3 scripts/content-seed/frq-u13-gap-fill-2026-10-09/publish_frq_batch.py publish --env prod --approval APPROVAL-0146 --confirm-production
python3 scripts/content-seed/frq-u13-gap-fill-2026-10-09/load_dev_content.py load
```
Results: Production 10/10 subjects rehearsed, committed, verified, final verify 126/126; Development verify 126/126;
`app.qa_grade_frq` Biology 10/10 full marks.

## 8. Approval state

- APPROVAL-0143 and APPROVAL-0146 recorded before their Production writes; both executed and verified.
- Owner action still required: merge PR #400 (contains scripts). No other approval pending.

## 9. Exact next step

**Next owner:** David Bloom. **Single best next action:** merge PR #400, then decide whether to fill the second FRQ for
the 202 single-FRQ Units 1-3 topics with the same in-session method (author in session, gateway for checks only).

## 10. Do not touch next session

- The 126 published `*-frq-u13g-*` items and the 183 APPROVAL-0143 topic cells: change only through a new version or a
  recorded retirement, never in place.
- The unrelated dirty files in the main checkout (`claude/task-0067-production-records`); they belong to other sessions.
- Development exam packs created this session (they now hold the FRQ copies).

## Lessons (for the next FRQ run)

- **Author in session; pay the gateway only to check.** Cost per FRQ fell from about $2.35 to about $0.20.
- **Pilot every lint rule on real items before a batch.** The figure rule rejected normal maths wording ("tangent to the
  graph of f") and cost two restarts.
- **Calibrate checkers to AP level before the batch.** GPT-6.1 Sol flags research-level caveats unless told the standard.
- **Recompute before accepting a checker's numbers.** Two checker accuracy claims were wrong.
- **Follow-through credit:** documented for Calculus and Physics only; do not add it elsewhere.
- **Topic overlaps** (Calc 1.1/2.1, Bio 2.5/2.8, Physics 2 11.2/11.5) need a CED-text ruling, not more regeneration.
- **Watch gateway credit** with a cost guard; a credit stop silently turns every call into an error.

## Recommended prompt for the next agent

> Read `docs/handoffs/SESSION_CLOSE_2026_10_10_FRQ_GAP_FILL_UNITS_1_3.md` and the batch README
> `scripts/content-seed/frq-u13-gap-fill-2026-10-09/README.md`. If David approves, add a second FRQ for each of the 202
> Units 1-3 topics that have exactly one: author in session from the CED-PDF briefs, check with
> `frq_pipeline.mjs run --no-author` (GPT-6.1 Sol + DeepSeek V4 Pro), arbitrate flags yourself and record every ruling,
> rehearse, then publish under a new APPROVAL recorded first. Do not touch Units 4+.
