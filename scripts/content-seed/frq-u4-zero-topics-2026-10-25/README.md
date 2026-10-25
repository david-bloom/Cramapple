# FRQs for zero-FRQ topics, Biology and Statistics Units 1-4 (authored 2026-10-25)

**Request (David Bloom, 2026-10-25):** for each topic with zero published FRQs in Units 1-4 of AP Statistics and AP
Biology, make 2 new FRQs, authored in session.

**Source of the topic list:** read-only census of Production (`pcntajvbdfqhbeewmdry`) on 2026-10-25, published FRQs by
primary topic cell on the latest published version. Zero-FRQ topics: Biology 4.2, 4.6; Statistics 4.2, 4.4, 4.6, 4.7,
4.8, 4.9. That is 8 topics and 16 FRQs.

**Status (2026-10-25): 16 of 16 ACCEPTED by the checkers. NOT PUBLISHED.**

| Gate | Result |
|---|---|
| Lint (`frq_pipeline/rubric.mjs`) and exact recompute (`validate.mjs`) | 16 of 16 pass (every revision re-run) |
| Six-vote topic probe (gemini-3.8-flash, deepseek-v4-pro, gpt-6.1-sol x2) | 16 of 16 on target (5 or 6 of 6) |
| Two checkers, GPT-6.1 Sol + DeepSeek V4 Pro (blind solve, scope audit, rubric re-derivation) | 16 of 16 pass both on the accepted text |
| Model answers graded by a third family (gemini-3.8-flash, `answer_grades.json`) | 16 of 16 full credit |
| Planted-defect controls | not re-run for this batch; the Units 1-3 run's 8 of 8 (same checker pair, same rules) is the only evidence |
| Production grader QA (`app.qa_grade_frq`) | not run (its QA path grades published AP Biology only) |
| Publish | not done; needs a recorded APPROVAL first |

**Spend:** $4.59 gateway total (446 calls), about $0.29 per accepted FRQ: GPT-6.1 Sol $2.56, DeepSeek V4 Pro $1.80,
gemini-3.8-flash $0.23. Three check rounds plus Biology 4.2 reworks.

**Rounds:** round 1 accepted 4 of 16; round 2 accepted 9; round 3 and the Biology 4.2 reruns accepted all 16. Every
ruling is in the slot file's `arbitration` entries (`slots/*.json`). Raw calls: `calls.jsonl`.

## Publishing
`publish_frq_batch.py` (plan, preflight, rehearse, publish, verify; adapted from the Units 1-3 script) and `APPROVAL_DRAFT.md`
(a proposed approval entry, not recorded). `plan.json` is generated locally from the accepted slots. Nothing has been run
against Production or Development.

## Open item for the Product Owner: Biology 4.2 versus 4.3
Five versions of a Biology 4.2 item built on a signaling cascade (second messenger, phosphorylation, amplification;
EK 4.2.A.2 and 4.2.B.2 are 4.2 content in the CED) each got 6 of 6 topic votes for 4.3, including after the scenario was
changed from epinephrine and glycogen (the CED's own 4.3 illustrative example) to a generic ligand. I did not override
a unanimous vote on my own item. The slot now holds a receptor-recognition item (EK 4.2.B.1) that passed 5 of 6 for
4.2. Consequence: neither accepted Biology 4.2 FRQ tests cascade amplification. If that content should be covered, it
needs a ruling (override the vote on a CED-text basis, or label such items 4.3).

Method follows `scripts/content-seed/frq-u13-gap-fill-2026-10-09/README.md`: author in session against the CED fact packs
(`docs/product/AP_BIOLOGY_CED_FACT_PACK.md`, `docs/product/AP_STATISTICS_2027_CED_FACT_PACK.md`) and the official CED topic text already extracted into `inputs/ced_topic_excerpts.json`, gateway only for checks.
The CED PDFs (`subject packs/`) were not in this cloud session; the extracted CED topic text and the fact packs were the scope sources.

Files: `build_bio.py`, `build_stats.py` (generate the JSON), `authored_bio.json`, `authored_stats.json`, `authored_all.json`.

## Topic rulings made while authoring
- Stats 4.4 and 4.9 are set-up items only (parameters, hypotheses, procedure, conditions); no test statistic, p-value or
  conclusion, which belong to 4.5 and 4.10.
- Stats 4.2 and 4.7 stop at the interval and its interpretation; claims from an interval belong to 4.3 and 4.8.
- Stats 4.8 items supply the interval and ask only for claims justified from it.
- Biology 4.2 items avoid pathway-mutation prediction (4.3) and stay on components, receptors and amplification.
- Biology 4.6 avoids named cyclin-CDK pairs and growth factors (CED exclusion).
- Critical values and Welch degrees of freedom are given in the stimulus; the recompute scripts re-derive each with mpmath.
- Follow-through credit is not used (Statistics and Biology, per the Units 1-3 batch ruling).

## Notes
- Recompute caught one error of mine before any paid check: Stats 4.7 (tomato yield) degrees of freedom are 24.0, not 23.8;
  the interval is (−0.01, 0.91), which includes 0.
- GPT-6.1 Sol failed 17 of 33 checks and DeepSeek V4 Pro 4 of 33, nearly all on `rubric_points`. Every GPT flag was a real
  rubric defect or a rubric that rejected a valid alternative; none was rejected as wrong.
- `frq_pipeline.mjs` gained `--max-unit=N` (topic lists and the probe's unit rule extend to Unit N); default unchanged.
- `build_*.py` hold the final text; `revise_round1.py` is the record of the first round of edits only.
