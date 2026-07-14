# Codex Remediation — TASK-0016 Phase C (post-handoff QA, 2026-07-09)

Independent QA (fresh-context, claims verified from source — see method notes
inline) found one confirmed content defect and one confirmed scope shortfall in
the Phase C corpus-expansion handoff. The MCQ bank (100 items, 18 reused
byte-identical to the live batch, 6/82 new items hand-spot-checked) and the FRQ
package's internal count consistency (100 items / 220 responses / 320 criterion
judgments matching across `manifest.json`, `blind_scoring_template.csv`,
`adjudication_queue.csv`) are **verified PASS — do not touch these.** This note
covers only what needs fixing.

## R1 (blocking) — `APSTAT-MOD6-H007` is a wrong-answer item labeled gold

`docs/research/ap_statistics_gold_set_candidate_2026_07_09/provisional_labels.json`,
item `APSTAT-MOD6-H007`: a 90% CI (z*=1.645) needs its width halved — what
confidence level results? The rubric's `learner_facing_text` says "approximately
67% confidence," and the `fully_correct` synthetic response repeats "~67%
confidence," labeled `provisional_label: "earned"`, `confidence: "high"`,
`adjudicate: false`.

**This is wrong.** Halving the width halves the margin, which halves z*:
`z*_new = 1.645/2 = 0.8225`. Confidence level `= 2·Φ(0.8225) − 1 ≈ 0.5892`
(58.9%), not 67%. Verified independently (not just re-derived from your own
key) — and your own deterministic key for this item
(`docs/research/statistics_phase_b_2026_07_08/statistics_item_keys.json`,
`APSTAT-MOD6-H007` → `confidence_level` part) already has
`"canonical_answer": 0.58921`, which **contradicts** the item's rubric text and
its "earned/high-confidence" response label. Your own
`docs/research/AP_STATISTICS_PHASE_C_INVENTORY_AND_QA_2026_07_09.md` flagged
this exact item as a finding ("Medium-High" confidence) — the finding was
correct, but it was never acted on in the data. Flagging in a side note without
correcting the underlying label is not remediation; a Learning Quality reviewer
scanning `provisional_labels.json` would see "high confidence, no adjudication
needed" and never know to look.

**Do:**
1. Fix `provisional_labels.json`'s `APSTAT-MOD6-H007` rubric
   `learner_facing_text` to state the correct value (~58.9% confidence, not
   67%), or reframe the criterion to the reasoning method (halving the margin
   halves z*) rather than a specific memorized number, if that's a better
   rubric shape — your call, state which you chose and why.
2. Re-label the `fully_correct` response's `ci_width_calculation` criterion:
   it currently states the wrong number, so it cannot stand as `"earned"` /
   `"high"` confidence / `"adjudicate": false` under the corrected rubric. Set
   `adjudicate: true` at minimum, or correct the response text to the right
   value if you judge that's in-scope — either way, this cannot ship as a
   silent "earned."
3. Update `docs/research/AP_STATISTICS_MOD3_MOD6_BOUNDARY_CONTRACTS_2026_07_09.md`
   or add a short new note recording this as a fourth resolved content defect
   (parallel to MOD3/MOD6/MOD8), since it's the same class of issue this
   session already established a process for — don't invent a new pattern.
4. Scan the rest of the corpus for the same failure shape: a rubric or
   synthetic response asserting a specific numeric/percentage answer that you
   have not independently recomputed. This item was caught because it happened
   to get a deterministic key; items without one wouldn't surface this way —
   which is exactly why R2 below matters.

## R2 (blocking for the calibration to mean anything) — deterministic key coverage is materially incomplete

The handoff described the key set as "aligned" with the 100-item corpus. It
is not. `statistics_item_keys.json` has keys for **16 items total** (14 newly
added this round + the original 2). Independent scan of the corpus's rubric
text for numeric/calculation language (`calculat`, `test statistic`, `z-score`,
`p-value`, `confidence interval`, `standard error`, `expected value`,
`probability`, `regression`, `correlation`, `margin of error`) found **at least
22 additional items** with clearly checkable numeric criteria and no key at
all, including:

- `APSTAT-MOD4-H001-INV` — a two-sample t-test item **structurally identical**
  to the already-resolved `APSTAT-MOD6-H001` (same `(m1-m2)/SE_diff` shape),
  entirely unkeyed. Note this one is likely **directional** (H1 tests whether
  the program *reduces* heart rate, not just "differs") — don't blanket-apply
  the MOD6 non-directional sign-insensitivity resolution here without checking
  whether this item's hypothesis is one-tailed, since that changes whether sign
  is graded. State your reasoning either way.
- `APSTAT-MOD3-E005`, `APSTAT-MOD4-M002`, `APSTAT-MOD4-M005`,
  `APSTAT-MOD5-M001`, `APSTAT-MOD6-M005`, `APSTAT-MOD6-H002-INV`,
  `APSTAT-MOD7-M002`, `APSTAT-MOD7-H003`, `APSTAT-MOD7-H004`,
  `APSTAT-MOD7-H010`, `APSTAT-MOD7-H002-INV`, `APSTAT-MOD8-H003`,
  `APSTAT-MOD8-VH001`, `STATS-MOD1-E004`, `STATS-MOD1-M002`,
  `STATS-MOD1-M005`, `STATS-MOD3-M006`, `STATS-MOD3-M007`,
  `STATS-MOD9-H016`, `STATS-MOD9-H018`, `STATS-MOD9-VH005` — treat this as a
  starting list, not a ceiling; re-derive your own pass over the full corpus
  rather than only closing out these 22, since a keyword scan will both miss
  some real candidates and include some false positives (genuinely conceptual
  items your scan flagged only on vocabulary).

**Why this matters:** the whole point of Engine 1 is that deterministic-owned
criteria are checked before any human/LLM judgment. A calibration run against
a corpus where 3/4 of the checkable criteria have no key isn't measuring what
Phase C claims to measure — every unkeyed item silently falls through to
LLM/human grading with no deterministic floor, which understates how much
Engine 1 actually needs to catch before launch.

**Do:**
1. For each candidate item, decide numeric/formula-checkable vs. genuinely
   conceptual (same triage `statistics_item_keys.json` already uses:
   `numeric`, `numeric+ecf`, `symbolic_only`, or `conceptual`/`ABSTAIN`) and key
   the checkable ones, applying the three resolved boundary-contract rules
   (z*-vs-t* tolerance, sign-sensitivity only when direction is semantically
   meaningful, method-only/self-consistency scoping for any item with a
   missing-dataset defect) — same as C3 originally asked.
2. Extend `validate_keys.py`'s battery to cover every newly-keyed item; report
   the new N/N pass count. Do not lower the bar or silently drop an item whose
   declared/recomputed values don't reconcile — flag it as a content defect
   (same pattern as R1) instead.
3. Update `AP_STATISTICS_VERIFICATION_PROFILE.json`'s `key_payload` counts and
   `status` line to state the actual final coverage (e.g. "N of 100 FRQ items
   keyed, M conceptual-only, K corpus-defect-excluded") rather than "aligned,"
   which reads as complete.
4. If, after triage, some items are excluded because you judge them not worth
   deterministic coverage for cost/benefit reasons, say so explicitly with a
   count — a stated exclusion is fine, a silent gap dressed as "aligned" is
   not.

## R3 (small, do while you're in the file) — schema drift in `provisional_labels.json`

The original 5-item package's `deterministic_check_targets` field was a list
of `{item, response, criterion, note}` objects. The new 100-item file collapsed
this to a bare integer (`"deterministic_check_targets": 3`). The read-first
instruction was to match the existing file's schema exactly. Restore the
list-of-objects shape (one entry per deterministic-check target item, matching
what's actually in `statistics_item_keys.json` after R2), so anything
downstream expecting the original shape doesn't break.

## R4 (small) — cross-reference the two candidate packages

`docs/research/ap_statistics_gold_set_candidate_2026_07_08/` (5 items) and
`docs/research/ap_statistics_gold_set_candidate_2026_07_09/` (100 items) now
coexist with no stated relationship. Add a one-line note to each README stating
that `_09` supersedes `_08` for calibration purposes (or whatever the actual
intended relationship is, if not a straight supersession) — whoever runs the
actual blind-scoring pass needs to know which package is authoritative without
guessing from the filename dates.

## Do NOT change

- The MCQ bank (`ap_statistics_mcq_launch_bank_2026_07_09/`) — verified: 100
  items, schema matches `app.mcq_choices`, the 18 reused items are
  byte-identical to the live 2026-07-01 batch, 6/82 new items hand-verified
  correct. No action needed here.
- The FRQ package's item/response/criterion counts and cross-file consistency
  — verified matching across all four files.
- The three original resolved boundary-contract decisions (MOD3 z*/t*, MOD6
  sign convention, MOD8 method-only scoping) — apply them to newly-keyed items,
  do not re-litigate them.
- The C0a/C0b inventory-reconciliation and QA-findings docs themselves as
  artifacts — just make sure R1/R2 actually close out what they flagged,
  rather than leaving the finding-without-fix gap this remediation exists to
  close.

## Required Evidence on Completion

- `APSTAT-MOD6-H007`'s corrected rubric/label, and confirmation the
  deterministic key still matches (`validate_keys.py` green).
- The full list of items keyed in this remediation pass, with each one's
  triage decision (numeric / numeric+ecf / symbolic_only / conceptual) and
  which boundary-contract rule (if any) it invoked — same shape as the R1/R2/R3
  resolution log from the original boundary-contract doc, so Learning Quality
  can spot-check the highest-risk extrapolations rather than re-reviewing
  everything blind.
- `validate_keys.py`'s new pass/total count (must be 100%, no XX rows).
- Updated `AP_STATISTICS_VERIFICATION_PROFILE.json` status line reflecting
  actual final coverage, not "aligned."
- Confirmation `provisional_labels.json`'s `deterministic_check_targets` field
  is restored to the list-of-objects schema.
- The two READMEs' cross-reference note (R4).

## Next Expected Output

A commit (or PR) referencing `TASK-0016` Phase C that closes R1–R4, ready for
another independent QA pass (spot-check a fresh sample of the newly-keyed items
and re-verify the MOD6-H007 fix) before this package is handed to Learning
Quality for the actual human blind-scoring pass.
