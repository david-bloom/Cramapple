# FIX15 report — 15 blocked Open Hand teaching MCQs (2026-10-06)

Source: `SCOPE_UNITS_1-3.json` (read-only) → `items_before.json`. Output: `items_after.json` (15 items, same schema). No DB writes, no commit.

## Summary

- **15/15 pass all three checks** after round 1 (lint, C3 trap on both models, blind solve + fact-pack audit on both models).
- Stems, choice texts and keys unchanged, except for the `!=` → `≠` swap in the stems of calc 1.11 and 1.13 (wording only). Sympy recompute, unchanged: lim (x²−16)/(x−4) at 4 = 8; x²−4x−5 = (x−5)(x+1); lim (x²+x−12)/(x−3) at 3 = 7.
- One audit flag (biology 3.3, deepseek scope). Adjudicated **not real** (see below).

## Rounds

| Round | Check | Out dir | Result |
|---|---|---|---|
| 1 | lint.py | — | 15/15 PASS |
| 1 | C3 trap (gemini-3.8-flash, deepseek-v4-pro) | `r1_c3/` | 30/30 calls pass (15 items × 2 models) |
| 1 | Blind solve + audit (both models) | `r1_oh/` | 29/30 calls clean; blind solve = key on all 30; no key dispute; no rationale flag. 1 flag: biology 3.3 deepseek `scope_contains_out_of_scope_content` |
| 2 | Audit resample, biology 3.3, deepseek only | `r2_oh_bio33/` | Same scope flag ("ATP hydrolysis / energy coupling"); key_correct true, all 4 rationales accurate, blind solve A = key |

## Adjudication — biology 3.3 scope flag

Not a real defect. Deepseek says ATP hydrolysis and energy coupling are out of scope because the local fact pack's 3.3 entry (EK 3.3.A.1–3, 3.3.B.1) never names coupling. But the published Production brief for ap_biology 3.3 (`app.topic_point_briefs`, the reference this task names) is explicitly about it: what_it_is = "Cells use energy coupling and ATP to drive processes that require energy input"; how_points_are_earned = "explaining how ATP hydrolysis or coupled reactions make an unfavorable process possible"; common_point_loss = "Saying ATP is energy without explaining how phosphate transfer or coupling supports the process." The fact pack also covers ATP as the energy for cellular work (EK 2.8.A.1, 3.5.A.1). The same deepseek flag appeared on the original item in `../check_run_1` (before this rewrite), and Gemini rated the item fully in scope. Deepseek flagged it twice, so this is a consistent gap in the fact pack, not variance. The item stays as written.

## Per-item changes

Each change is a rewrite of the distractor rationales into the form "Tempting if <specific slip> — but <why wrong>. Fix: <action>." Every item's author_flags now ends with `[fix15 2026-10-06: rationales rewritten]`.

### ap-calculus-ab:1.2 — Defining Limits and Using Limit Notation

C3 'tempt' (C). C now names the slip: reading 4+ as approaching from below. A and D now have action fixes (read it aloud; label the input and output numbers).

### ap-calculus-ab:1.11 — Defining Continuity at a Point

Lint: `!=` → `≠` in the stem and verification. Distractor fixes are now actions (compute and compare the limit and g(4); factor and cancel). Keyed rationale tightened.

### ap-calculus-ab:1.12 — Confirming Continuity over an Interval

C3 'tempt' (A). A names the slip: treating a closed endpoint as safe. B names the numerator-zero confusion (x = -2). C names the dropped 'on their domain' clause. All fixes are actions.

### ap-calculus-ab:1.13 — Removing Discontinuities

Lint: `!=` → `≠` in the stem and verification. Distractor fixes are now actions: factor and cancel on 0/0, compute the limit before setting k, substitute x = 3 into x + 4.

### ap-calculus-ab:1.16 — Working with the Intermediate Value Theorem

C3 'tempt' + 'fix_not_action'. A and B now name the slip of treating a possible dip or overshoot as guaranteed. C names the IVT/MVT mix-up. Fixes: check the target against f(2) and f(8); write the interval [3, 11]; list the theorem's hypotheses.

### biology:1.1 — Structure of Water and Hydrogen Bonding

C3 both. D names the slip of stretching evaporative cooling too far, with an action fix (check against the observed slight warming). A and C fixes rewritten as actions.

### biology:1.4 — Carbohydrates

C3 both. D names the dehydration/hydrolysis confusion, with an action fix (label each reaction). A and B fixes are actions.

### biology:1.7 — Proteins

C3 'tempt' (C). C names the misconception that the strong covalent disulfide bond holds helices together. Fixes: sort bonds by what they connect; count the chains; check the sequence.

### biology:2.9 — Cell Compartmentalization

C3 both. B names the link to mitochondrial ATP. C names the 'enclosed = sealed off' slip. D names overgeneralizing from organelle enzymes and gives the cytosolic glycolysis counterexample. All fixes are actions.

### biology:3.2 — Environmental Impacts on Enzyme Function

C3 both. A names the confusion of denaturation with peptide-bond digestion. B names the slip of treating any activity drop as inhibition. C names attributing everything to substrate. Fixes: use the recovery at pH 7 as evidence; identify what changed (pH).

### biology:3.3 — Cellular Energy

C3 both. B names the confusion of lowering activation energy with supplying energy (fix: ask whether the molecule is used up). C names the heat misconception (fix: trace the phosphate). D names taking 'energy currency' literally (fix: write ATP → ADP + phosphate). No bond-breaking-releases-energy wording.

### ap-statistics:1.12 — Potential Problems with Sampling

C3 'tempt'. A names the 'say random = complete' slip. C names the belief that discarding repeats harms randomness. D names the systematic/SRS confusion. All fixes are actions.

### ap-statistics:2.3 — Estimating Probabilities Using Simulation

C3 'tempt'. B names the shot vs. trial confusion. D names confusing the 4 shots with the number of trials. A's fix is now a computation (make digits / digits in use).

### ap-statistics:3.6 — p-Values

C3 both. A names the flipped conditional. B names the 1 − p slip. D names reading 0.03 on the proportion scale. Fixes: start with 'Assuming H₀ is true'; do not subtract from 1; ask 'probability of what?'.

### ap-statistics:3.14 — Setting Up a Chi-Square Test for Homogeneity or Independence

C3 'tempt' (D). D names the memorized 'three rows' shortcut, with a design-based action fix. A and B fixes rewritten as actions (count samples; count rows and columns).

