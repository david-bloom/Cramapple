# PLOT_VALUES fix, second attempt (v2) — controlled evaluation — 2026-08-19

**Result: DO NOT PROCEED. v2 is a net regression, and the diagnostic work behind it shows
the underlying disagreement is mostly a gold-labeling problem, not a grader-tolerance
problem — no prompt-side PLOT_VALUES fix (v1's or this one) is well-targeted at the actual
cause.**

## Starting point

`ENGINE4_PRODUCTION_DESIGN_2026_08_18.md` §1 records the first `PLOT_VALUES` fix
(`hand_drawn_graph_real_photo_benchmark_gpt52_plot_values_prompt_run.mjs`, "v1" below) as
"reverted (net FAR/FRR regression)... needs a second controlled run or a narrower fix, not
a repeat of the same general-leniency instruction." New evidence not available when v1 was
written: `decision_0045_verification_2026_08_19/flagged_discrepancies.json`, where two
independent, blind, non-OpenAI verifier models (Gemini 2.5 Flash, Qwen3-VL) both disagree
with the existing single-pass gold on 11 `PLOT_VALUES` cases (gold says `not_earned` /
`unable_to_determine`, both verifiers independently say `earned`) plus 5 `X_SCALE` cases
(same direction).

## Diagnosis

Step 1 was to check what the **unmodified `gpt-5.2` baseline** (no fix at all) already
predicts on those exact 11 `PLOT_VALUES`-flagged photos, using the existing
`real_photo_benchmark_gpt52_results.jsonl` — no new calls needed for this part:

| Photo | Gold | Verifiers | Baseline (no fix) |
|---|---|---|---|
| CAT-004 | not_earned | earned | **earned** (matches verifiers) |
| CAT-009 | not_earned | earned | **earned** (matches verifiers) |
| CAT-016 | not_earned | earned | **earned** (matches verifiers) |
| CAT-017 (resp-02) | not_earned | earned | **earned** (matches verifiers) |
| SER-007 | unable_to_determine | earned | **earned** (matches verifiers) |
| SER-013 | not_earned | earned | **earned** (matches verifiers) |
| SER-015 | not_earned | earned | **earned** (matches verifiers) |
| SER-016 (resp-02) | not_earned | earned | not_earned (matches gold) |
| SER-017 (resp-02) | not_earned | earned | not_earned (matches gold) |
| SER-037 (resp-02) | not_earned (a point is genuinely missing — verified by direct read of gold's rationale) | earned | not_earned (**correctly matches gold**; verifiers made a perception error here) |
| SER-049 | not_earned | earned | not_earned (matches gold) |

**7 of 11 flagged cases: the unmodified production grader already agrees with the two
independent verifiers and disagrees with gold — with zero prompt changes.** This means the
disagreement mostly lives at the **gold layer**, not the grader layer: the grader isn't too
strict on these, it's already about as lenient as two independent outside models. A
prompt-side leniency fix has nothing to fix here; the fix is a gold review (per the
DECISION-0045 README's own recommended reader-adjudication step).

On the remaining 4 cases, the grader currently agrees with gold and disagrees with the
verifiers — and at least one of those (SER-037) is a case where gold is **objectively
right**: gold's rationale documents a completely missing plotted point (only 6 of 7
required points drawn), which both verifiers failed to notice. That is a verifier
perception failure, not a legitimate "too strict" gold call.

Step 2: checked what **v1's own already-existing run output**
(`real_photo_benchmark_gpt52_plot_values_prompt_results.jsonl`) did to these same 11 photos
— also free, no new calls. v1 combined two instructions: (a) small positional offsets are
fine (magnitude tolerance), and (b) a broken *required relative ordering* between points
must fail even if each point looks plausible alone (explicit strictness carve-out, written
specifically to handle CAT-004/CAT-009-style cases). Checking v1's predictions against the
11 flagged photos: v1 **flipped CAT-004 and CAT-009 away from the verifier consensus**
(baseline said `earned`, matching verifiers; v1 said `not_earned`, matching only gold) while
fixing only one case (SER-017) in the intended direction. Net: v1 moved *away* from verifier
consensus on the exact cases (CAT-004/CAT-009, the ordering-violation examples) it was
explicitly written to help. The likely mechanism: clause (b), the explicit
ordering-violation-must-fail instruction, made the grader more conservative than its own
unprompted default judgment — which happens to track two independent outside models better
than the explicit instruction does.

## v2 fix design

Narrower than v1 by subtraction, not addition: **keep only the magnitude-tolerance clause
(a), drop the ordering-violation strictness carve-out (b) entirely.** Let the model's own
default judgment handle relative-ordering questions rather than instructing it to be
stricter. Full prompt text in
`scripts/vercel-gateway-check/hand_drawn_graph_real_photo_benchmark_gpt52_plot_values_v2_prompt_run.mjs`.

## Controlled evaluation

Ran `gpt-5.2` with the v2 prompt on:
- **Flagged set (n=11):** the exact 11 `PLOT_VALUES`-flagged photos above.
- **Control set (n=30):** a stratified sample (10/archetype, mixed `earned`/`not_earned`
  gold) of photos where the **unmodified baseline already predicts `PLOT_VALUES`
  correctly** — the regression check.

Raw output: `runs/plot_values_v2_results.jsonl`. Subset definitions:
`flagged_plot_values.json`, `control_sample.json`, `subset_photos.json`.

### Flagged-set result — v2 did not move toward verifier consensus; it moved further away

| | Baseline (no fix) | v1 (reverted) | v2 (this run) |
|---|---|---|---|
| Matches verifier consensus (`earned`) | 7/11 | 5/11 | **3/11** |
| Matches gold (`not_earned`/`unable_to_determine`) | 4/11 | 5/11 | 6/11 |

v2 is **worse than both baseline and v1** at tracking the two independent verifiers on this
set — the opposite of the intended direction. CAT-016, CAT-017, SER-015 are the only 3 that
land on `earned`; CAT-009 and SER-013, which the unmodified baseline already got to
`earned` (matching verifiers), flipped to `not_earned` under v2. Removing the explicit
ordering clause did not restore the baseline's better-than-v1 agreement with verifiers —
ordinary prompt-perturbation noise on a small, already-borderline set can move judgments in
either direction, and here it moved the wrong way.

### Control-set result — real regression, concentrated in EST

All 30 control photos were, by construction, correctly graded on `PLOT_VALUES` by the
unmodified baseline. Under v2:

**24/30 correct (80%), 6/30 regressions (20%) — all 6 are new false-rejects (gold `earned`
→ predicted `not_earned`), none are new false-accepts.**

| Photo | Archetype | Gold | v2 predicted |
|---|---|---|---|
| CAT-007 (resp-02) | CAT | earned | not_earned |
| EST-048 | EST | earned | not_earned |
| EST-001 (resp-02) | EST | earned | not_earned |
| EST-008 | EST | earned | not_earned |
| EST-016 | EST | earned | not_earned |
| SER-004 (resp-01) | SER | earned | not_earned |

**4 of 6 regressions are in `continuous_relationship_graph_derived_estimate` (EST)** — the
same archetype `ENGINE4_PRODUCTION_DESIGN_2026_08_18.md` identifies as carrying the bulk of
`PLOT_VALUES`'s FAR contribution and the archetype the escalation policy already targets.
v2 made the grader measurably *more* conservative on exactly the archetype where the
production doc most wants a `PLOT_VALUES` win, and did so via new false-rejects, the same
direction v1's regression took (v1: false-rejects 32→40).

## Cost

| Item | Calls | Cost |
|---|---|---|
| Validation (1 photo) | 1 | $0.03 |
| Full run (41 photos: 11 flagged + 30 control) | 41 | $1.09 |
| **Total** | **42** | **$1.12** |

Well under the $10 autonomous cap.

## Recommendation: NEEDS-GOLD-CORRECTION-FIRST, not a prompt fix

Two independent lines of evidence now point the same direction:

1. On 7 of the 11 verifier-flagged `PLOT_VALUES` cases, the **unmodified production grader
   already matches the two independent verifiers** — there is no grader leniency gap to
   close on those cases via prompting. The gap is between gold and (grader + 2 verifiers).
2. Both prompt-side attempts to adjust `PLOT_VALUES` tolerance — v1 (add an ordering
   carve-out) and v2 (remove it, keep only magnitude tolerance) — made things **worse**, not
   better, on the very cases they targeted, and v2 additionally introduced a clean 20%
   regression on a stratified control sample, concentrated in the EST archetype that matters
   most for FAR.

This is not narrow-sample overfitting in the direction that matters (the control set exists
specifically to catch that) — it's a repeated, structural finding that `PLOT_VALUES`
prompt-tolerance wording is not a reliable lever, in either direction, at gpt-5.2's current
capability level. Any further nudge to this text risks another wash-or-regression cycle.

**Recommended next step is not a third prompt attempt.** It's the reader-certification /
gold-review step DECISION-0045's own README already scoped and left outstanding: a
qualified human reader adjudicates the specific flagged photos (starting with the 11 here,
extendable to the 5 `X_SCALE` flags) cold, against the rubric only, no grader/verifier/gold
label shown. Where the reader sides with the verifier consensus, gold gets corrected (not
the grader). Where the reader sides with gold (as SER-037's missing point suggests they
would), the corresponding grader behavior is already correct and needs no change. Either
way, the fix is downstream of a human read, not a further prompt iteration.

## Files in this directory

- `README.md` — this file.
- `flagged_plot_values.json` — the 11 flagged-set photos (item_id + file_name).
- `control_sample.json` — the 30 control-set photos (stratified, baseline-correct).
- `subset_photos.json` — resolved file paths for the 41-photo run (written by the script).
- `runs/plot_values_v2_results.jsonl` — raw v2 run output, 41 records.

## Script

`scripts/vercel-gateway-check/hand_drawn_graph_real_photo_benchmark_gpt52_plot_values_v2_prompt_run.mjs`
