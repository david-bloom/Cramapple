# changes_requested backlog QA sweep — 2026-08-09

## Scope

Following the np2 QA session (`ABDUL_NP2_QA_2026_08_09.md`), reviewed the full
`changes_requested` backlog across Biology, Calculus AB, Chemistry, Physics
(all four courses), and Precalculus — the pool of items sent back for edits
after human review but never actually remediated. Triaged into three tiers
by defect type, since each needed a different QA method:

- **Tier 1 — genuine content defects.** Wrong facts, distractor
  values/rationales that don't reproduce, missing computation steps. Fixed
  via full independent re-derivation (protocol
  `docs/research/CONTENT_AUTHORING_AND_QA_PROTOCOL.md` §9).
- **Tier 2 — rubric-granularity gaps.** Math/content already correct, but
  multi-step criteria bundled as one all-or-nothing point block. Fixed by
  splitting into independently-gradable sub-criteria, point totals preserved.
- **Tier 3 — wording/precision gaps.** Physics C: E&M / Physics 1 np1 batch,
  reviewed by Muhammad Saood — math independently re-derived and confirmed
  correct in every item; the gaps are missing conventions (`|·|`, `V=0` at
  infinity), unstated assumptions, or edge cases with an undefined direction.

All three tiers follow the same remediation mechanics (protocol §9.4): new
version per item, old version retired (never edited in place),
`owner_remediation_approval` decision, structural QA gate, then publish.
Scripts: `scripts/content-seed/reviewer-qa-remediation/20260809_tier{1,2,3}_*.sql`.

## Tier 1 — 11 fixed, 2 deferred (13 total)

| Item | Defect | Fix |
|---|---|---|
| `APBIO-FRQ-S-068` | Clownfish/anemone stem calls a mutualistic relationship "commensal" | Replaced with a genuinely commensal example (barnacles/whales) |
| `apchem-sfrq-003` | Missing ° symbols, criteria state formula+answer without substitution shown | Added °, substituted-value computations, precise standard-state language (chemistry re-verified correct: ΔG°=−48.2 kJ/mol, K=2.9×10⁸) |
| `apchem-sfrq-036` | Missing ° symbols; a2 criterion oversimplifies entropy justification | Added °; sharpened a2 for hydration-ordering nuance |
| `apcalcab-mcq-036` | Choice B (3/2) rationale doesn't reproduce the value | Replaced with verified mechanism (reports avg. rate of change directly, value→4) |
| `apcalcab-mcq-040` | Choices A/B/C all fail to reproduce their stated values | All three replaced with verified equal-spaced/correct-width left/right sum mechanisms |
| `apcalcab-mcq-044` | Choice B rationale imprecise | Corrected to "raw integral, not divided by interval length" |
| `apcalcab-mcq-045` | Choice C rationale reproduces B's value (2.0), not its own (1.75) | Replaced with verified one-step-improved-Euler mechanism |
| `apcalcab-mcq-047` | Choice B doesn't reproduce 1/4; choice D's own rationale gives 5/6, not 1/2 | B replaced (upper-curve-only, →1/2); D's value corrected to 5/6 |
| `apcalcab-mcq-050` | Choice A rationale vague | Corrected to "doubles horizontal interval" (2×1.4=2.8) |
| `apphycem-mcq-np1-006` | Choice D rationale generic | Corrected to infinite-sheet-formula conflation (verified) |
| `apphycem-mcq-np1-001` | Field-magnitude wording didn't specify λ>0 | Added λ>0 to stem |
| `apcalcab-mcq-048` | 3 of 4 distractors unverifiable after extensive attempts | **Deferred** — flagged for full author-level reconstruction |
| `apcalcab-mcq-049` | Choice D unverifiable (Fresnel-integral-level computation) | **Deferred** — same reason |

## Tier 2 — 18 fixed (18 total)

7 Calculus AB FRQs (004, 005, 006, 007, 009, 010, 015) and 10 Biology FRQs
(`APBIO-FRQ-S-{019,036,038,046,066,080,084,086,087,095}`) had every
multi-step criterion split into 1-point sub-criteria, point totals
unchanged (Calc AB: 9 pts/item across 3 parts; Biology: 4 pts/item across 2
parts). Notable non-mechanical fixes folded into the same pass:

- **Systemic finding:** all 7 Calc AB items had `prompt_json.parts[].points`
  stuck at 1 while `frq_criteria.points_possible` was 3 per part — the exact
  inconsistency Shazia Fazal flagged specifically on `apcalcab-frq-005`.
  Fixed for all 7, not just the one explicitly flagged.
- `APBIO-FRQ-S-019`: removed the "inner-membrane composition" evidence
  option from part (a), since it overlapped with part (b)'s expected answer.
- `APBIO-FRQ-S-080`: part (b) rewritten to distinguish primary structure
  (directly changed) from tertiary structure (whose altered folding causes
  the functional loss).
- `APBIO-FRQ-S-087`: part (b) sharpened to require comparing both mean *and*
  variance between stabilizing/directional selection.
- `APBIO-FRQ-S-095`: part (a) refocused on genetic-variation contribution
  rather than mechanistic transposition detail, to stay within AP Biology
  CED scope.
- `apprecalc-frq-u12-004`: part (c) rewritten — it was conflating "the
  model's stated domain" (given, 0≤x≤20) with "the interval where profit is
  positive" (0≤x<18.2), a materially different question Saood flagged.

## Tier 3 — 23 fixed, 1 no-defect, 1 deferred (25 checked, 24 in scope + 2 already fixed in Tier 1)

24 of the 26-item Physics 1 / Physics C: E&M np1 batch (minus 2 already
repaired in Tier 1 for having confirmed value defects). All wording/stem
clarifications; no answer, criterion point value, or MCQ correct-key
changed. Examples: `apphy1-frq-np1-002`'s interval notation fixed to avoid
an undefined instant at the shared boundary; `apphycem-frq-np1-005`'s
ambiguous "the side facing the field" replaced with explicit +x/−x
labeling; five MCQs got λ>0 / V=0-at-infinity / end-effects-negligible
convention notes added to their stems.

One flagged numeric claim was checked and found **not** to be a defect:
`apphycem-frq-np1-004`'s rubric value 124.680 V was independently
re-derived (V=kQ/√(x²+R²), k=8.99×10⁹) and confirmed correct to three
decimals — only the convention wording was added, the value was untouched.

Two items got no content version bump:
- `apphycem-mcq-np1-010`: reviewed against Saood's note; option D's
  rationale already states a concrete, correct mechanism. Approved as-is.
- `apphycem-mcq-np1-008`: options C/D's claimed values (59.9 V, 539.4 V)
  could not be reproduced by any tested mechanism. **Deferred**, same
  discipline as the two Tier 1 items left unrepaired.

## Totals

**52 items published** (11 + 18 + 23) out of 55 reviewed. **3 deferred**
(`apcalcab-mcq-048`, `apcalcab-mcq-049`, `apphycem-mcq-np1-008`) — left in
`changes_requested`, flagged for author-level reconstruction rather than a
speculative spot-fix, per protocol §9's discipline against repairing on an
unverified basis.

Remaining backlog after this sweep (not in scope for this session): the
~29-item AP Physics 2 / Physics C: Mechanics regular-pool `assigned` queue,
the Statistics `assigned` queue, and further Physics C: E&M
`pasted-prompt-rubric` pattern items flagged in
`docs/Q&A/REVIEWER_QA_SWEEP_2026_08_08.md` §QA signal 1.
