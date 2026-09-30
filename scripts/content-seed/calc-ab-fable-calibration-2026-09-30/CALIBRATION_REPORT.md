# Fable blind calibration run (2026-09-30)

**Question:** are we just swapping defects each time we review? Does a stronger, independent-of-our-pair reviewer find things the Gemini 3.8 Flash + DeepSeek V4 Pro pair (plus patching) missed?
**Design.** Fable 5.1 (`anthropic/claude-fable-5.1`) blind solve + rationale audit on 48 anonymized, shuffled items, no prior flags shown:
24 final post-patch variants (pilot 16 + Unit 3 8); 4 pre-patch versions of variants known to be defective (positive controls); 10 published seeds the pair flagged and
I verified (positive controls); 10 published seeds the pair did not flag (negative controls). Plus a fixed-point rerun: the same two original checkers, fresh samples, on the 24 unchanged final variants.
Fable is an Anthropic model, the same family as the author (Sonnet 5.5): it is a ceiling check, not an independent gate. Files: `anon_items.json`, `anon_map.json` (key to group), `out_fable/`, `out_rerun/`, `analysis_output.txt`.

## Results
Counting only **substantive** flags (a key judged wrong, or a per-choice rationale judged inaccurate), not the free-text `other_defects` list, which Fable used for style notes:

| Group | Fable substantive flags | Reading |
|---|---:|---|
| Pre-patch controls (4) | 4 of 4 (005-v1 only via a minor-wording note) | It finds the defect class |
| Published seeds the pair flagged (10) | 10 of 10 (`080` only via a loose-wording note) | Independent confirmation of every pair flag, including those raised by only one model |
| Published seeds the pair did not flag (10) | **0 of 10** | No misses by the pair on seeds |
| **Final variants (24)** | **0 of 24** | **No evidence of swapped defects** |
| Blind solve vs key, all 48 | 0 disagreements | Keys correct, again |

Style-level `other_defects` notes: Fable raised 25 of 48 items on these (Unicode vs ASCII, terse rationales, "no calculator needed"). Most are not defects. Two are real content notes on
`pilot-031-v1/v2` ("a graphing calculator is required" when the arithmetic is easy by hand; the seed has the same wording).

**Fixed-point rerun** (2 original checkers, unchanged text, fresh samples): 1 flag row in 48 audit calls. It was DeepSeek on `np2-006-v1` choice D (a loosely worded "omits the initial condition"),
which neither the first pass nor Fable flagged. Patched (now "sets C = 0 instead of using y(0) = 4"), then all three models re-checked it: clean.

## What this tells us
1. **Not swapping defects, on this evidence.** Fable found zero substantive defects in 24 final variants, and the pair's repeat pass on unchanged text found one borderline wording issue (about 2% of audit calls).
2. **Single-model flags were real.** Three flags raised by only one model of the pair (005 A by Gemini; 038 B/C and the 038-v2 distractor by DeepSeek) were all confirmed by Fable. So treat the **union** of flags as candidates to verify by hand, not the intersection.
3. **Fable's high recall on this defect class is not independent proof of ours**: same family as the author, 48 items, and the positives were chosen because the pair had already found them. It can also over-flag; keep its `other_defects` channel separate from rationale accuracy.
4. **Cost and time:** Fable $2.50 for 96 calls (81k in, 34k out, about 2.4 minutes); the rerun $0.23. About $0.05 per item for a Fable audit, roughly the same as the whole two-model math pass per item.

## Recommendation
Keep the two-checker pair as the standard stage; run one patch loop; do not add Fable as a standing third stage. Use Fable for (a) a sample calibration per batch, (b) adjudicating single-model flags cheaply, and
(c) any batch where the fixed-point rerun disagrees with the first pass. Verify flags by hand or sympy before acting on any of them.
