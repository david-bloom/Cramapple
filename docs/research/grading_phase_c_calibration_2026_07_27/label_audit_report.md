# Phase C Stage 3 — Response Corpus & Adjudication Label Audit

**Run date:** 2026-07-27
**Scope:** 100 frozen FRQ items from `FROZEN_ITEM_MANIFEST.json` (Stage 1).

## Method

Executed as a Workflow (`phase-c-stage3-response-corpus-v3`), 10 batches of 10
items, pipelined (generate → adjudicate per batch, no barrier). All Production
reads were via the Supabase MCP `execute_sql` tool against `pcntajvbdfqhbeewmdry`
(read-only; no rows written).

- **Generation:** one subagent per batch, given only `content_item_version_id`,
  `subject`, `frq_form`, and the requested `archetype`/`mechanism`. Each agent
  independently queried `app.content_item_versions` for `stem`/`stimulus` only
  and was explicitly instructed not to query `app.frq_criteria` or any
  rubric/answer table, and not to reuse or reference the rubric in any way --
  this keeps generation blind to the canonical answer and criterion labels, as
  the Stage 3 protocol requires. The generator is this session's model
  (Sonnet 5), which is **not** the model that will be used for either grading
  arm (Stage 4 freezes both arms on `google/gemini-2.5-flash`), satisfying the
  "not used as either grading arm" independence requirement.
- **Adjudication:** a separate subagent per batch (blind to the generation
  step's internal reasoning) queried `app.content_item_versions` and
  `app.frq_criteria` for the same items, then judged every criterion for every
  response in its batch against the reusable criterion-contract discipline
  (local/independent criteria, negation/hedging is not evidence, accept
  equivalent forms, apply ECF, `unable_to_determine` for genuine ambiguity,
  evidence must be grounded, self-audit invariants before finalizing).

## Corpus shape (target vs. actual)

| Archetype | Target | Actual |
|---|---:|---:|
| fully_correct | 20 | 20 |
| partially_correct | 20 | 20 |
| boundary_adjacent | 20 | 20 |
| confidently_wrong_complete | 20 | 20 |
| blank_off_topic | 20 | 20 |

Mechanism coverage (assigned only to multi-criterion items under
`partially_correct`/`boundary_adjacent`, 6 of each, matching the build plan):
`ecf_downstream_correct_from_wrong_upstream`, `correct_conclusion_wrong_reasoning`,
`correct_method_arithmetic_error`, `equivalent_noncanonical_wording`,
`contradiction_or_self_correction`, `negation_hedging_scope_temporal_near_miss`
-- each appears exactly 6 times (see `stage3_summary.json`).

Subject distribution matches the Stage 1 frozen manifest exactly (100/100
items generated and adjudicated; 0 missing).

## Criterion-level results

- 437 total criteria judged across 100 responses.
- 219 `earned`, 204 `not_earned`, 14 `unable_to_determine`.
- 20 individual criterion judgments were flagged `unresolved_human_review_flag=true`
  by the adjudicator (genuine ambiguity, not silently forced to a verdict).

These are **calibration labels produced under this protocol** -- not dual-human
launch gold. They exist to support the Stage 4-6 architecture comparison, not
a launch-readiness claim.

## Independent invariant audit (this script, not the adjudicator's self-report)

For every adjudicated response, this audit independently re-checked (not just
trusted the adjudicator's own `invariants_ok` flag):

- whether `evidence_quote` is an actual substring of the generated response text;
- whether `points_earned` exceeds `points_available`;
- whether the adjudicator's own self-reported `invariants_ok` was `false`.

**26 of 100 responses** raised at least one independent-audit flag. The
overwhelming majority (25/26) are a single pattern: **the adjudicator's
`evidence_quote` paraphrased or partially quoted the response rather than
reproducing it as an exact substring** (e.g. compressing a multi-sentence
argument into a shorter paraphrase, or fixing minor whitespace/punctuation).
This is a **quote-fidelity issue with the adjudication protocol's evidence
field, not a scoring-verdict error** -- spot-checking several of these against
the underlying `status` verdicts found the substantive judgments defensible;
the flagged cases are listed per-item in `stage3_summary.json` →
`audit_findings` for anyone who wants to re-verify the verdicts, not just the
quotes.

### One genuine content-quality finding (flag for Learning Quality, not a Phase C defect)

`APBIO-FRQ-L-025` (long-form Biology FRQ, molecular clock/cladistics item) has
an internal rubric inconsistency in Production `frq_criteria`:

- **Criterion `b`:** `evidence_requirements` computes the calibrated
  Human-Gorilla divergence as "4.0% × 2 Mya/1% = 8.0 Mya" (consistent with the
  item's stimulus table, which states 4.0% sequence difference), but the same
  criterion's `minimum_fix`/`accepted_variants` fields reference a different,
  inconsistent figure ("2.1% × 2 Mya/% = ~4.2 Mya") that does not match the
  4.0% given in this item's actual stimulus -- apparently a leftover from a
  different version of the item.
- **Criteria `a`, `b`, `c`:** the free-text point breakdowns embedded in
  `evidence_requirements` (e.g. "1 pt for synapomorphy definition + cladogram
  topology; 1 pt for parsimony explanation") describe more discrete sub-points
  than the criterion's actual `points_possible` column value (a=1, b=3, c=3),
  so the prose sub-point count and the DB's point allocation don't line up.

The adjudicator handled this correctly and transparently: it graded the
student response against the stimulus-consistent 8.0 Mya figure (which the
synthetic response matched) and scored holistically against the authoritative
`points_possible` column rather than the inconsistent prose breakdown, then
flagged the discrepancy instead of silently resolving it. **This is a content
defect in the live rubric, not a Phase C scoring defect** -- worth a content-ops
follow-up on `APBIO-FRQ-L-025`, separate from this calibration run.

## What this does and doesn't support

- Supports: proceeding to Stage 4 (freeze the two grading arms) and Stage 5
  (n=20 paid gate) using this corpus as the frozen response set.
- Does not support: a launch-readiness or gold-set claim (per
  `GRADING_RESEARCH_CANONICAL_PROCESS.md`'s corpus tier rules, this corpus is
  `calibration` tier, not `adjudicated_gold`).
- The one real content defect found (`APBIO-FRQ-L-025`) should be corrected in
  Production `frq_criteria` independent of whether Phase C proceeds.
