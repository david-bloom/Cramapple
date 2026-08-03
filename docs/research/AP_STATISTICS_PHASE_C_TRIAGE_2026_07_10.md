# AP Statistics Phase C — Full-Corpus Deterministic-Key Triage — 2026-07-10

**Scope:** completes C3 (deterministic verification-key expansion) from
`prompts/CODEX_TASK0016_PHASE_C_REMEDIATION_2026_07_09.md` R2. The prior
remediation pass closed the 22 items explicitly flagged in QA; this pass
triages the remaining 63 to give the full 100-item corpus an explicit
disposition, so "development — N of 100 keyed" in
`AP_STATISTICS_VERIFICATION_PROFILE.json` reflects a completed scan, not a
partial one.

## Final coverage (100/100 accounted for)

| Bucket | Count |
| --- | ---: |
| Numeric/numeric+ecf (deterministic key exists) | 28 |
| Conceptual (verbal/qualitative, no fixed numeric target) | 68 |
| Corpus-defect / method-only (missing or unusable dataset) | 4 |

`validate_keys.py`: **44/44 canonical-integrity checks, 7/7 ECF-chain checks
pass** (up from 31/31 and 4/4 before this pass — 7 new items, 13 new numeric
parts added).

## 7 items newly keyed this pass

All values independently recomputed via `ecf_engine.eval_formula` before being
written, not just asserted (the MOD6-H007 lesson from the prior remediation
round):

- **`APSTAT-MOD3-E001`**, **`STATS-MOD3-E006`** — both ask for the percentage
  of values within 1 SD of the mean (the empirical rule). Keyed as a constant
  (`68`), since the ~68% figure doesn't depend on the item's specific mean/SD —
  it's the same universal constant either way.
- **`APSTAT-MOD7-M003`** — false positive rate = `1 - specificity` =
  `1 - 0.90 = 0.10`.
- **`APSTAT-MOD7-H002`** — mutually exclusive events: `P(A or B) = P(A)+P(B) =
  0.5`, `P(A and B) = 0`. Two independent parts, no dependency chain between
  them (each is a direct given-arithmetic result, not one feeding the other) —
  `validate_keys.py`'s ECF-behavior check was fixed to skip items like this
  (see "Validator fix" below).
- **`APSTAT-MOD8-M002`** — R² = 0.64 is stated directly in the prompt; keyed as
  an echo-check so a response confusing R² with r, or with `1-R²`, gets caught.
- **`APSTAT-MOD8-M004`** — slope = 3 from the given `y = 3x + 5`; same
  echo-check rationale (catches confusing slope with intercept).
- **`STATS-MOD1-M004`** — frequency table from a given sequence
  (`A,B,A,C,B,A,B,A` → A=4, B=3, C=1 of 8). Six independent constant parts
  (3 raw frequencies + 3 relative frequencies), no dependency chain.

## Validator fix: independent multi-part items

`validate_keys.py`'s ECF-behavior check (`check_ecf`) previously ran on *any*
item with 2+ `ecf_parts`, assuming a dependency chain and expecting all
non-root parts to become `CORRECT_VIA_ECF` when the root is corrupted. The two
new multi-part items above (`APSTAT-MOD7-H002`, `STATS-MOD1-M004`) have
independent parts by design — no part's `deps` references another — so this
assumption doesn't apply and the check false-failed on first run. Fixed the
validator to only run this check when at least one part declares `deps`
(i.e., an actual chain exists); items with only independent constants are
correctly skipped rather than held to an ECF-chain contract they don't have.

## 56 items newly marked conceptual this pass

No fixed numeric target is derivable from a text response for any of these —
they ask for verbal explanation, categorical classification, methodology
design, or interpretation of an unprovided visual (scatterplot/histogram/
residual plot referenced but not attached as data). Grouped by why:

**Verbal/qualitative interpretation, no numbers involved at all** — shape
description, bias/confounding discussion, study-design tradeoffs, definitional
questions: `APSTAT-MOD3-E002`, `APSTAT-MOD4-M001`, `APSTAT-MOD4-M003`,
`APSTAT-MOD4-M004`, `APSTAT-MOD5-H001-INV` (pre-existing gap in the profile's
bookkeeping, not from this expansion — picked up and closed here),
`APSTAT-MOD5-M002`, `APSTAT-MOD5-M003`, `APSTAT-MOD5-M005`,
`APSTAT-MOD6-H005`, `APSTAT-MOD6-H006`, `APSTAT-MOD6-H008`,
`APSTAT-MOD6-H009`, `APSTAT-MOD6-H010`, `APSTAT-MOD6-M002`,
`APSTAT-MOD6-M004`, `APSTAT-MOD7-H006`, `APSTAT-MOD7-H008`,
`APSTAT-MOD7-H009` (established convention: p-value-vs-α *conclusions* are
graded as conceptual even when the numbers are given, matching how
`APSTAT-MOD3-H001-INV`'s hypothesis-test conclusion is already treated —
consistency, not a new rule), `STATS-MOD1-E001`, `STATS-MOD1-E002`
(categorical classification — a determinate answer exists, but it's non-numeric
label-matching, outside what the numeric-extraction checker can validate;
flagging as a future checker-type gap, not a content defect), `STATS-MOD1-E003`,
`STATS-MOD1-E005`, `STATS-MOD1-E006`, `STATS-MOD1-M001`, `STATS-MOD1-M003`,
`STATS-MOD3-H006`, `STATS-MOD3-H007`, `STATS-MOD3-H008`, `STATS-MOD3-H009`,
`STATS-MOD4-E005`, `STATS-MOD4-E006`, `STATS-MOD4-H011`, `STATS-MOD4-H012`,
`STATS-MOD4-H013`, `STATS-MOD4-H014`, `STATS-MOD4-H015`, `STATS-MOD4-M008`,
`STATS-MOD4-M009`, `STATS-MOD4-M010`, `STATS-MOD9-H017`, `STATS-MOD9-H019`,
`STATS-MOD9-H020`, `STATS-MOD9-VH001`, `STATS-MOD9-VH002`, `STATS-MOD9-VH003`,
`STATS-MOD9-VH004`.

**References a visual not attached as data** (scatterplot, histogram, residual
plot referenced in the stem but no coordinates/table given — nothing to
extract-and-check): `APSTAT-MOD8-M001`, `APSTAT-MOD8-M003`, `APSTAT-MOD8-H002`.

**General symbolic rule, no concrete numbers to plug in** (the relationship is
correct in the abstract but the item gives no specific data to compute
against): `APSTAT-MOD5-M004` (mean shifts by `20/n`, but `n` is never
specified — no fixed value possible), `APSTAT-MOD6-H002` (CI width formula
stated qualitatively, no data), `APSTAT-MOD6-H004` (residual-plot pattern
description), `APSTAT-MOD8-H004` (slope CI formula with no `b`/`SE_b`/`df`
given), `STATS-MOD3-E007` (SD = √variance, definitional, no numbers),
`STATS-MOD3-H010` (transformation rule "×2 affects mean/median/SD by ×2", no
concrete dataset to apply it to).

## Do NOT change

- The 28 already-keyed items (7 from this pass + 21 from before) and their
  `validate_keys.py` results.
- The 4 corpus-defect/method-only exclusions and their resolutions
  (`AP_STATISTICS_MOD3_MOD6_BOUNDARY_CONTRACTS_2026_07_09.md`).
- Any of the 68 conceptual items' rubric text — this pass only classified them
  for the deterministic layer's purposes; it did not touch grading criteria.

## Open follow-up (not blocking, noted for later)

- `STATS-MOD1-E002` (categorical variable classification) has a fully
  determinate answer but isn't checkable by the current numeric-extraction
  checker (`extractNumbers`/`matchesTarget` in `statistics-verifier.ts` only
  parses numbers, not category labels). If a future checker adds label-matching
  support, this item (and any similar classification items) should be
  revisited — not a defect in the current scope, just a capability gap.
