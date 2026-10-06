# Orly pooled-practice clean-room batches (2026-10-06)

Two batches, run together under `DECISION-0098`. Both stop at **checked drafts**: nothing is loaded to Dev or Production.

| Batch | Families | Drafts | Checked drafts | Held |
|---|---|---|---|---|
| `apchem-orly-cleanroom-2026-10-06/` (AP Chemistry, Units 1 and 3) | F1-F8 | 24 | 20 | 3 out of CED scope (F4), 1 on its topic label (f6-v2) |
| `apcalcab-orly-cleanroom-2026-10-06/` (AP Calculus AB, topic 2.1) | C1-C2 | 6 | 6 | 0 |

Source: practice sets pooled by Orly and classmates, reworded from released AP exam items (seed class D). See
`docs/research/orly_source_log/SOURCE_LOG.md` and `docs/research/orly_source_log/2026-10-06_ap_chemistry_pooled_practice_mcqs.md`.
**The source text is not in the repository.**

## Who saw what (seeded protocol §4, S7)

| Context | Saw the source | Wrote |
|---|---|---|
| Orchestrator (main session) | Yes | `family_specs.json`, scrub, divergence adjudication, patches, independent re-derivation |
| Author A (fresh agent) | No | Chemistry F1-F4 + `verify_F1_F4.py` |
| Author B (fresh agent) | No | Chemistry F5-F8 + `verify_F5_F8.py` |
| Author C (fresh agent) | No | Calculus C1-C2 + `verify_C1_C2.py` |
| Checkers (`openai/gpt-5.6-sol`, `deepseek/deepseek-v4-pro-0813`) | No | `out_*` |

Authors received only `family_specs.json`, the subject's CED fact pack and our own bank stems for the same topics.
Rewrite requests after the divergence check were sent as negative constraints only (for example "do not use iron"),
never as source text.

## Pipeline as run

1. **S1/S2 specs and scrub.** Mechanical check (no shared numbers other than small integers, no source
   formulas or compounds, no shared 4-word phrases other than generic topic wording). **Pending David's scrub sign-off.**
2. **S3 authoring.** Correct answer written at A, every value recomputed by the author's verify script.
3. **S4 divergence.** Run from outside the repo; `divergence_report.json` stores numbers only. Source word-Jaccard
   was at most 0.23 (Chemistry) and 0.26 (Calculus). Four Chemistry drafts had independently converged on a source
   instance (same compound, salt pair, element and sample mass, or apparatus) and were **rewritten** (f2-v1, f5-v3,
   f6-v3, f7-v2); f7-v3 was rephrased. Sibling and bank near-duplicate Jaccard is below 0.7 everywhere
   (`similarity_report.json`).
4. **Letters.** `assemble.py` draws a balanced random key (6 per letter for Chemistry). The first unbalanced draw
   (11 of 24 on D) was replaced before any check ran. Never re-run it.
5. **Checks.** `subject_audit_check.mjs` (blind solve + rationale audit), `subject_ced_check.mjs` and
   `subject_label_probe.mjs` (2 samples per model), each with both checkers.
   - **Blind solve:** both models solved all 30 items to the key.
   - **Independent re-derivation:** `rederive_independent.py` in each batch, written from the stems and not from
     the authors' scripts. All 30 keys confirmed.
6. **Adjudication and patches** (`patch_round1.py`; text only, no key or letter changed). Each patched item was
   re-checked in full (`out_audit_r1`, `out_audit_r2`, `out_ced_patched`): clean.

## Adjudicated flags

- **GPT-5.6 Sol "key wrong" on f1-v3, f2-v1, f2-v2, f2-v3: not defects.** The audit prompt tells the model to
  treat numbers as exact, so percentages rounded to 4 significant figures do not give exactly whole-number
  ratios (for example Cl:Ge = 4.0002). This is a rounding artifact; DeepSeek did not flag them, and both solved
  them correctly.
- **f8-v3 "key wrong" (pre-patch): fixed.** The item asserted the error direction when constant mass had only not
  been verified. The stem now asks how the result "most likely" compares.
- **Real text defects, patched:**
  - f7-v1: gauge vs absolute pressure.
  - f7-v1 and f7-v2: the rationales claimed "no liquid means no vapor"; the gas is now stated to be dry.
  - f6-v3: rationale arithmetic display.
  - f3-v1: "weighs out 2.00 mol".
  - c1-v1: a rationale was worded backwards.
- **F4 (density): held.** Both checkers flagged density as outside the CED fact pack, and the fact pack does not
  contain it. It is readiness content (OMP §4; the 2026-08-24 summer-assignment note says the same) under
  `DECISION-0095`.
- **f8-v3, single-model CED flag after the patch: kept.** It cites the 3.8 exclusion on percent by mass of
  solutions, but wet crystals are a heterogeneous mixture (1.4), not a solution.
- **f6-v2 topic split: held for its label.** GPT-5.6 Sol voted 4.5 on both samples and DeepSeek voted 3.7 on both.
  The recommended CED-text tiebreak is 3.7. f3-v2, f5-v3, f6-v3 and f8-v1 were 3 of 4 on the spec topic, with the
  dissenting vote in the same unit.

Per-item status: `status_manifest.json` in each batch. Final item text: `items_assembled.json`
(pre-patch: `items_assembled_prepatch.json`).

## Not done (needs a separate approval)

- Product Owner scrub sign-off.
- Skill labels (four-voter run).
- Difficulty band confirmation.
- Loading to Dev or Production.
- Content keys `apchem-mcq-orly-*` and `apcalcab-mcq-orly-*` are proposals.
- Family membership exists only in these files (seeded protocol §7).
