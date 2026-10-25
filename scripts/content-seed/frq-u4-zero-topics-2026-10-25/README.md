# FRQs for zero-FRQ topics, Biology and Statistics Units 1-4 (authored 2026-10-25)

**Request (David Bloom, 2026-10-25):** for each topic with zero published FRQs in Units 1-4 of AP Statistics and AP
Biology, make 2 new FRQs, authored in session.

**Source of the topic list:** read-only census of Production (`pcntajvbdfqhbeewmdry`) on 2026-10-25, published FRQs by
primary topic cell on the latest published version. Zero-FRQ topics: Biology 4.2, 4.6; Statistics 4.2, 4.4, 4.6, 4.7,
4.8, 4.9. That is 8 topics and 16 FRQs.

**Status: AUTHORED AND LOCALLY VALIDATED ONLY. NOT CHECKED BY THE GATEWAY CHECKERS. NOT PUBLISHED.**

| Gate | Result |
|---|---|
| Lint (`frq_pipeline/rubric.mjs`) and exact recompute (`validate.mjs`) | 16 of 16 pass |
| Six-vote topic probe | not run |
| Two checkers (GPT-6.1 Sol + DeepSeek V4 Pro), blind solve, scope audit, rubric re-derivation | not run (paid; needs David's go-ahead) |
| Planted-defect controls | not run |
| Production grader QA (`app.qa_grade_frq`) | not run |
| Publish | not done; needs a recorded APPROVAL first |

Method follows `scripts/content-seed/frq-u13-gap-fill-2026-10-09/README.md`: author in session against the CED fact packs
(`docs/product/AP_BIOLOGY_CED_FACT_PACK.md`, `docs/product/AP_STATISTICS_2027_CED_FACT_PACK.md`), gateway only for checks.
The official CED PDFs (`subject packs/`) were not available in this cloud session, so the fact packs were the only scope source.

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

## Self-review notes (not yet checked by a second model)
- One recompute failure found and fixed: Stats 4.7 (tomato yield) degrees of freedom were 24.0, not 23.8; interval is
  (−0.01, 0.91), which includes 0.
- Weakest items to watch at the checkers: Biology 4.2 (a) criterion 2 and Biology 4.6 (a) criterion 1 (reading a trend
  from a table), and Stats 4.2 (a) which has three condition criteria.
