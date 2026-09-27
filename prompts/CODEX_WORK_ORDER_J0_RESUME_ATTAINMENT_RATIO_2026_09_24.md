# Codex Work Order J.0 Resume — Compute Biology's `attainment_ratio`

**Authorization: DECISION-0065** (`docs/activity_log/DECISIONS_LOG.md`). Read it in full before
starting — it answers all four questions your own `DISCREPANCY.md` raised, precisely, and this work
order does not restate the reasoning behind each rule, only the rule itself.

**This is a resume, not a fresh start.** Your 2026-09-23 run (`docs/research/
difficulty_reconciliation_2026_09_23/`) correctly stopped rather than invent a ratio method, and its
evidence is exactly right — reuse `j0_reproduction.csv`'s `detected_verbs` column and your 81/81
exact band reproduction rather than re-deriving them.

Paste the block below into Codex.

```text
Work order J.0 resume — compute attainment_ratio for AP Biology's 81 task-verb items.

Merge main first:

    git fetch origin
    git switch codex/project3-2026-09-23
    git merge origin/main

The checkout must be clean before starting. Commit and push to codex/project3-2026-09-23 as you go
(this is the branch your original J.0 discrepancy report is already on -- Claude committed it there
after your session ran out of usage before you could push it yourself; confirm it's present after
merging). Do not open a PR and do not merge to main. Read-only against Production throughout.

READ FIRST, in this order:
  1. docs/activity_log/DECISIONS_LOG.md -- DECISION-0065 (index entry at top).
  2. docs/research/apbio_j0_ratio_decision_2026_09_24/README.md -- the exact scope and rules this
     order implements. It was computed directly against your own j0_reproduction.csv, not estimated
     -- if your re-derivation of the 87-row scope disagrees with crr_rows_to_verify.csv in that same
     directory, STOP and report the discrepancy rather than silently using your own number.
  3. Your own docs/research/difficulty_reconciliation_2026_09_23/DISCREPANCY.md and
     j0_reproduction.csv -- the problem statement and the per-item verb detection you already did.
  4. docs/research/apbio_difficulty_calibration_2026_09_22/README.md -- the existing categorical
     method and its task-verb tier table (section 3), which DECISION-0065's tier-fallback rule
     reuses directly.

STEP 1 -- TWO-AI VERB VERIFICATION (DECISION-0065 rule 1), scoped to exactly 87 rows

docs/research/apbio_j0_ratio_decision_2026_09_24/crr_rows_to_verify.csv lists the 87
crr_calibration_all_subjects.csv rows that matter: 10 from AP Biology's own 18, 77 from six other
subjects (Chemistry 31, Calculus AB 19, Calculus BC 14, Physics C: E&M 6, Physics C: Mechanics 5,
Precalculus 2) -- specifically the rows whose verb_auto (after normalizing inflection) matches a
verb detected somewhere in Biology's 81 task-verb items. Do NOT expand this to the full 316 rows and
do NOT shrink it to Biology's 18 -- both were considered and rejected in DECISION-0065's own
derivation; if you believe a different scope is correct, report why rather than silently using it.

For each of the 87 rows, verify verb_auto against the true task verb or Science Practice using two
independent models. Record both models' answers per row, not just the final one.

  - AGREE: that row's verified verb is the agreed value. Use it.
  - DISAGREE: that row contributes NOTHING -- no ratio derives from it, for any item, under either
    the exact-match or tier-fallback rule. Log it plainly; do not adjudicate by picking one model's
    answer, and do not average the two answers if they resolved to genuinely different verbs.

Produce verb_verification.csv: subject, question, label, verb_auto (as-is), model_1_verb,
model_2_verb, agree (bool), verified_verb (null if disagree).

STEP 2 -- COMPUTE PER-ITEM attainment_ratio (DECISION-0065 rules 3, 4, 5)

For each of Biology's 81 task-verb items:

  1. For each detected verb (from your own j0_reproduction.csv detected_verbs column, normalizing
     inflection the same way that file already does -- e.g. describes -> describe):
     a. Look for an EXACT match among the verified (agreed) rows from Step 1. If found, that verb's
        ratio is the verified row's ratio (normalized per rule 4 below if the row is not AP Biology).
     b. If no exact match, and the verb is one of the 8 with zero CRR presence anywhere (apply,
        classify, contrast, distinguish, label, name, support, trace), fall back to the MEAN of the
        verified, exact-matched ratios for OTHER verbs in that verb's own difficulty tier (Easy /
        Medium / Hard, per the tier table). Tag this verb's contribution ratio_source=tier_fallback.
        If a verb's entire tier has zero verified exact matches (e.g. every same-tier row landed in
        a Step-1 disagreement), that verb contributes nothing -- do not fall back further.
     c. Otherwise (verb detected zero times in the CRR file, and not one of the 8 -- should not
        happen given the scope, but verify) that verb contributes nothing.
  2. Cross-subject normalization (rule 4): for any ratio sourced from a non-Biology row (exact or
     tier-fallback), do NOT use its raw ratio. Express it as (source_ratio - source_subject_mean),
     then re-anchor: biology_ratio = biology_subject_mean + that same offset, clipped to [0, 1].
     Subject means are in apbio_difficulty_calibration_2026_09_22/README.md section 2's table (or
     recompute from crr_calibration_all_subjects.csv directly -- state which you did).
  3. Item's attainment_ratio = MEAN of all its verbs' resolved, normalized ratios (rule 5). If NO
     verb on the item resolved to a ratio (every verb either had a Step-1 disagreement or an empty
     tier), the item's attainment_ratio is null -- this should be rare given DECISION-0065's own
     computation found 0 permanently-unreachable items, but report honestly if your run differs.
  4. Assign ratio_status: 'computed' (at least one verb resolved) or 'unavailable' (none did), and
     ratio_basis: 'all_exact' (every contributing verb was exact_verb), 'mixed' (some exact, some
     tier_fallback), or 'all_tier_fallback'.

Cut-point check (rule 6, informational only -- do NOT re-band): using Hard <= 0.49, Medium the open
interval (0.49, 0.75), Easy >= 0.75, compare each item's computed ratio against its ALREADY-COMMITTED
categorical band from your 2026-09-23 run. Where they disagree, report it as a finding -- it means
the ratio and the categorical method (which uses modal task-verb tier, not attainment data) measure
something related but not identical, which is expected and worth having on record, not a bug to fix
by adjusting either number.

The 37 judgment-basis items are untouched -- remain null, exactly as your original run left them.

STEP 3 -- OUTPUT

Produce, in your existing docs/research/difficulty_reconciliation_2026_09_23/ directory (this is a
resume of that same work, not a new directory):

  - attainment_ratio_proposal.csv: content_key, content_item_version_id, attainment_ratio (or null),
    ratio_status, ratio_basis, contributing verbs and their individual ratio_source values.
  - A revised SUMMARY.md (or an addendum -- your call) recording: rows verified (87), agreement rate,
    items with a computed ratio vs. null, the exact/tier_fallback split, the cross-subject
    normalization applied per item, and the cut-point-vs-categorical-band comparison from Step 2.
    Keep your original DISCREPANCY.md as the historical record of why this was blocked -- do not
    edit or delete it.

WHAT WOULD MAKE THIS REJECTED AT QA

  - Any row from outside the 87-row scope used without flagging the disagreement with
    crr_rows_to_verify.csv first.
  - A raw (non-normalized) ratio copied from a non-Biology row.
  - Tier-fallback used when an exact match existed, or used silently without the ratio_source tag.
  - Re-banding any item's categorical Easy/Medium/Hard label. That label is untouched by this order.
  - A Step-1 disagreement resolved by picking one model's answer instead of contributing nothing.
  - Production writes of any kind. This is a proposal; Claude QAs it and applies M3's data load.

Proposal only. No Production writes. Claude QAs this and applies the data load to
app.content_item_difficulty.
```

## What stays with Claude

- QA of `verb_verification.csv` (spot-check the two-model agreement claims are real, not asserted)
  and of the ratio computation (recompute a sample by hand against the stated rules).
- Applying the data load to `app.content_item_difficulty` (M3) once QA passes.
- Closing FF-6 in `docs/product/AP_BIOLOGY_FAST_FOLLOW.md`.
