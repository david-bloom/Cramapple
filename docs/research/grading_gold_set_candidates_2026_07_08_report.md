# Grading Gold-Set Candidates — Build Report, 2026-07-08

**Status:** Completed build of three `calibration`-tier gold-set-candidate packages
**Read tier:** Directional (20 responses per subject) — supports "worth
adjudicating" and boundary-sharpening; NOT a release decision
**Related:** DECISION-0034, APPROVAL-0032,
`grading_cross_subject_takeaways.md`, `GRADING_RESEARCH_CANONICAL_PROCESS.md`

## What was built

Per the depth-first direction (DECISION-0034), one adjudication-ready package per
subject, each with a locked composition-controlled response slice, criterion-level
AI provisional labels, a blind dual-scoring harness for human validators, and a
manifest. Labels are `calibration` (silver) — human dual-blind adjudication
upgrades them to `adjudicated_gold`.

| Subject | Package | Responses | Judgments | Adjudication queue | Deterministic targets | Corpus defect |
| --- | --- | ---: | ---: | ---: | ---: | --- |
| AP Biology | `ap_biology_gold_set_candidate_2026_07_08/` | 20 | 88 | 9 | 0 | none |
| AP Statistics | `ap_statistics_gold_set_candidate_2026_07_08/` | 20 | 68 | 11 | 2 | MOD8 has no dataset |
| AP Chemistry | `ap_chemistry_gold_set_candidate_2026_07_08/` | 20 | 68 | 22 | 0 | resolved (v2 wrong-reasoning variants) |

Each subject slice is 5 items × 4 response types (`fully_correct`,
`partially_correct`, `borderline`, `subtly_wrong`), meeting §12.2 minimums for
partial / boundary / contradictory proportions. Shared gaps across all three: no
equivalent-language variants, no explicit abstention cases (fill before any
package is a true archetype gold set).

## Findings that matter

1. **Chemistry corpus was degenerate — now fixed.** The v1 source corpus's
   non-canonical variants were truncations of the canonical answer
   (`partially_correct` ≡ `borderline` byte-for-byte; zero `partially_earned`
   judgments — the quantitative fingerprint of the defect), so it could
   calibrate incompleteness only. **Resolved 2026-07-08:** all 200 non-canonical
   responses across the full 100-item corpus were rewritten as hand-authored
   genuinely-wrong-reasoning answers, each injecting one identifiable
   misconception (`injected_error` field); the v1 corpus is preserved as a
   backup. The regenerated Chemistry candidate now has 5 `partially_earned`
   judgments and no identical variant pairs, and tests wrong-reasoning detection.

2. **Statistics is where deterministic checks pay off.** Two `subtly_wrong`
   responses fail on checkable arithmetic, not judgment: a standard-error error
   (`120/30` vs `120/√30`) that cascades into a wrong CI and wrong test
   conclusion (MOD3), and a miscomputed two-sample t that flips reject↔fail
   (MOD6). These are the concrete calibration cases for the AP Statistics
   calculation checker — build it to flag both at zero API cost.

3. **Biology's `subtly_wrong` responses are the best adversarial material.**
   Several are confidently-wrong-but-complete across every part (e.g., the
   insulin-signaling item asserts insulin works through cAMP throughout) — the
   exact failure a model's self-reported confidence cannot catch and the
   boundary contract must. One response (FRQ-L-033) contains an internal
   contradiction that the deterministic contradiction check should catch.

4. **Two "partially_correct" Statistics responses actually read as full credit**
   (MOD6, MOD7). Calibration signal worth adjudicating: does the grader
   over-penalize concise-but-complete answers? That would wrongly cost terse
   students points — a real product risk.

## Next steps (in priority order)

1. **Human-adjudicate the AP Biology package first** — it is the launch subject
   and the true release-gate blocker. Run blind dual-scoring on its 88 judgments,
   focusing on the 9-item adjudication queue.
2. **Build the AP Statistics calculation checker** against the 2 deterministic
   targets; add to the Statistics verification profile.
3. **Author wrong-reasoning Chemistry responses** to replace the truncation
   variants, then re-run the Chemistry package.
4. **Fill the shared composition gaps** (equivalent-language, abstention cases)
   before treating any package as an archetype gold set.
5. **Feed each adjudication-queue resolution back into the criterion-boundary
   contract** (a C2 change), per DECISION-0034.

## Claims supported / not supported

**Supported:** the harness runs end-to-end; the packages are composition-valid
and adjudication-ready; the Chemistry truncation defect is real and quantified;
the two Statistics deterministic targets are concrete and checkable.

**Not supported:** any release-threshold quality claim (labels are AI provisional,
not human-adjudicated); any cross-subject agreement comparison (these are
per-subject calibration corpora, not paired arms); Chemistry wrong-reasoning
grading (the corpus cannot test it).
