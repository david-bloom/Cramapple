# TASK-0067 / TASK-0066 Phase B pilot — unit reference entries and memory hooks

**Batch:** `task0067-reference-pilot-2026-10-09`. **Scope:** AP Statistics Unit 1, AP Chemistry Unit 4
(`DECISION-0105` R1–R4). **Environment:** Development only. Production is a Hard Gate.

## Provenance (protocol v0.6 §3.2 rule 3)

| Role | Model id | Family | Note |
| --- | --- | --- | --- |
| Extractor (not an author: extraction from the CED pages + fact pack) | `anthropic/claude-sonnet-5.5` | Anthropic | smoke 3/3 |
| Checker 1 | `google/gemini-3.5-flash` | Google | menu slot B; smoke 3/3 |
| Checker 2 | `openai/gpt-6-sol` | OpenAI | menu slot A (scope-sensitive subjects); smoke 3/3 |
| Own-family veto (reject-only) | `anthropic/claude-opus-5.5` | Anthropic | smoke 3/3 |

**Pick made by the Claude session on 2026-10-09 from the live gateway roster, pending the Product
Owner's ratification** (§2.1 says the PO picks; David had said "go ahead and start the implementation
branch" and was not present for the pick). Neither checker shares the extractor's family.

## Method

1. `extract.py`: one call per unit with the CED unit pages (`pdftotext -layout`, Stats pp. 28–59,
   Chem pp. 79–94) and the fact-pack section. Output `out/candidates_*.json`.
2. `check.py`: both checkers judge every entry (a factual, b topic codes, c CED-required, d caution) and
   every hook (e expansion, f admissible). A flag is re-sampled once; only a repeated flag counts. Both
   must accept; then the veto may reject. Six planted controls per unit must all be rejected.
3. `load.py`: accepted rows → `out/load_*.sql`, applied with `supabase db query --linked -f` (no retyping).
   At most 8 hooks published across the pilot.

## Results (2026-10-09, Development only)

| Unit | Extracted | Round 1 accepted | Round 2 (stateless re-extraction of the rejected) | Loaded | Escalated | Hooks loaded |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| AP Statistics Unit 1 | 80 | 67 | 12 of 13 | **79** | 1 | 1 (z-score formula sentence) |
| AP Chemistry Unit 4 | 22 | 20 | 2 of 2 | **22** | 0 | 1 (OIL RIG) |

Controls: Statistics 6/6 rejected. Chemistry run 1 was **void** (5/6): my control "ideal gas law is
another unit" was wrong, because CED 4.5 names the ideal gas law for gas stoichiometry and the
extractor had independently pulled it as a 4.5 formula; the checkers were right. Replaced by Hess's law
(Unit 6) and the six Chemistry controls re-run: 6/6 rejected (`out/verdicts_ap_chemistry_u4_controls_run1_void.json`
keeps the voided run). No candidate verdicts were touched by the re-run.

**Aggregation bug found and fixed mid-run.** The first `check.py` let a rejected hook reject its entry.
Entry and hook verdicts are independent by design (TASK-0066 Phase B). `recompute.py` re-derived every
verdict from the stored samples under the corrected rule; one entry changed (Statistics "Elements of a
description of a quantitative distribution": entry accepted, hook SOCS still rejected). Pre-recompute
files are kept as `*_pre_recompute.json`.

**SOCS, for the Product Owner.** The Statistics CED itself names "SOCS (Shape, Outliers/Gaps, Center,
Spread)" on its own pages; both checkers accepted the hook on that basis. The own-family veto rejected it
twice on check (e): the extracted entry lists its items in the CED sentence's order (shape, center,
variability, unusual features) while SOCS runs shape, outliers, center, spread. The rule says no hand
edits, so SOCS is **not loaded**. Options: a round-3 re-extraction of that one entry, or accept that a
hook's order need not match the entry's item order when the CED itself sanctions the hook.

**Escalated (protocol §0.4):** Statistics 1.13 "Scope of conclusions from an experiment": GPT-6 Sol held
in both rounds that 1.10 (1.10.A.3, 1.10.E.4) first requires the scope distinction, so 1.13 is the
wrong owner. Not loaded; a Product Owner call on owner topic, then regenerate.

**Rejection pattern worth knowing:** 11 of the 14 round-1 Statistics rejections were check (b): a
`topic_codes` reuse tag on a later topic whose learning objectives do not use the entry. The stateless
round 2 with the instruction to tag only topics whose LOs use the entry cleared 12 of 13.

**Cost (gateway list prices, from `out/logs_*`):** $20.29 — Opus veto $11.37 (126 calls), Gemini $4.07,
GPT-6 Sol $4.45, Sonnet extractor $0.40. The reject-only veto is 56% of the spend; worth revisiting
for Units 2+.

**Verified in Development after load:** 101 published entries + 2 published hooks; zero orphan topic
codes; owner units match the taxonomy; both views emit the registry subject key; `get_topic_point_guides`
returns `reference[]` (18 for Stats 1.7 including entries owned by 1.1/1.2/1.6, 79 for Unit 1, 4 for
Chem 4.9) and `memoryHooks[]`, and empty arrays with unchanged briefs for a subject with no entries.
