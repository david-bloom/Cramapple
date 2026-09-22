# Codex Prompt — Independent Grader QA of AP Biology Canonical Drafts

STATUS: orchestration prompt (hand to Codex) | DATE: 2026-09-22 | AUDIENCE: David
(orchestrator) → Codex (QA operator).

> Paste the block below into Codex. It is self-contained; the drafts are on the
> local machine and everything else lives in `david-bloom/cramapple` or the
> Cramapple Production Supabase project.

---

You are the QA operator for Cramapple's AP Biology canonical-answer drafts. Your
job is to test each draft through the **actual Cramapple Production grader**
against that item version's own Production rubric, and report the results. You do
not rewrite the answers, and you do not decide pass/fail from your own opinion.

**Independence — read this first.** You (Codex) authored these Biology drafts, so
you are NOT an independent judge of them. This task manages that: **PASS/FAIL is
decided ONLY by the production `evaluate-attempt` grader's mechanical
criterion-level scores — never by your own assessment of your own answer.** Any
scientific-error, CED-scope, or curricular concern you notice is **flagged to
Orly, not self-cleared by you.** You never promote, edit, or re-score an answer
on your own judgment.

## Read first (in this order)

1. `docs/proposals/2026-09-20-student-facing-canonical-answers.md`
2. `docs/GRADING_PROGRAM.md`
3. `docs/architecture/CONTENT_AUTHORING_AND_PROMPT_ARCHITECTURE.md`
4. `docs/product/AP_BIOLOGY_CED_FACT_PACK.md`
5. `scripts/content-seed/canonical-answers/APBIO_canonical_drafts_2026_09_21.json` (the drafts on this machine)
6. `scripts/content-seed/canonical-answers/APBIO_coverage_manifest.md`

## Production source of truth

- Supabase project: `pcntajvbdfqhbeewmdry` (Production), read-only for content.
- Subject: `app.exam_packs.exam_code = 'ap_biology'`.
- Read each draft's exact `app.content_item_versions` row by its `content_item_version_id`.
- Read every corresponding `app.frq_criteria` row: `criterion_key`,
  `evidence_requirements`, `accepted_variants`, `points_possible`.
- Before testing a draft, confirm it still targets the **latest** version and that
  `canonical_answer_1` remains null/empty on that version.

## QA method

1. Do not edit a draft before testing it.
2. Submit its `canonical_answer_1` through the **actual Production
   `evaluate-attempt` grader**, using the item's exact `content_item_version_id`,
   through the existing sanctioned grader-QA invocation path only.
3. Record the grader result criterion by criterion.
4. A draft **PASSES only if the production grader** awards:
   - every stored criterion its full points;
   - a total equal to the complete rubric-point total;
   - with no carry-forward / error-carried-forward rescue;
   - with no criterion skipped, waived, or inferred; and the required evidence is
     present in the answer itself.
5. The criterion coverage map in the draft is an **audit aid only** — never credit
   an item because the map claims coverage.
6. Absent `canonical_answer_2` is not a defect.
7. Do not QA the spatial/hand-drawn items the manifest lists as out of scope.
8. Do not begin Statistics.

## Grader-invocation guardrail (hard stop)

Invoke the grader only through the sanctioned QA path, and mutate **no content**
(canonical fields, rubrics, stems, criteria, scoring contracts). Do not write any
draft into `canonical_answer_1`/`canonical_answer_2`. Do not build new grading
machinery. Do not silently repair a failing answer and rerun it. **If the
Production grader cannot be invoked through an approved path without an
unauthorized Production content mutation, STOP and report the blocker** rather
than improvising.

## Curricular finding to preserve

`APBIO-FRQ-S-103` is a **short** FRQ whose Production rubric stores **five
1-point criteria (5 points total)**, which conflicts with the CED four-point
short-FRQ structure. Report this independently of whether its answer scores 5/5,
and send it to Orly.

## Output

Write a QA report to `scripts/content-seed/canonical-answers/APBIO_qa_report_2026_09_22.md`
(plus a machine-readable `APBIO_qa_report_2026_09_22.json`) containing:

- Production project and execution timestamp;
- grader/function version or deployment identifier;
- one row per draft: `content_key`, `content_item_version_id`, latest-version
  check, canonical-field-still-empty check, rubric points possible, points
  awarded, every `criterion_key` with awarded/possible points, carry-forward used
  (yes/no), PASS/FAIL/BLOCKED, and the exact grader rationale/evidence for every
  failed criterion;
- a separate curricular-review section (S-103 and any other rubric/content
  defects, for Orly);
- an overall count of passed, failed, and blocked drafts.

### Disposition rules

- **PASS** only for an unqualified full score on every criterion from the
  production grader.
- **FAIL** if any criterion loses any points (even if the total is rounded or
  otherwise reported as 100%), or if carry-forward contributes to the score.
- **BLOCKED** if the grader cannot be validly invoked, or the tested Production
  version/rubric no longer matches the draft.
- Send every FAIL or rubric/content defect to Orly without rewriting or promoting
  the answer.

## Safety

- Do not modify canonical answers, rubrics, stems, criteria, scoring contracts, or
  any other Production content; do not write drafts into the canonical fields.
- Treat authored canonicals as development artifacts, not certified gold-set
  evidence; do not expose these answer keys on any student-facing surface.

At the end, state explicitly: **"Independent QA complete. No canonical answer was
promoted or written to Production."** Stop after the AP Biology report.
