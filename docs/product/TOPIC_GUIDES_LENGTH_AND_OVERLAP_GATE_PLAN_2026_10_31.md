# Plan: length caps and overlap check for topic guides (Recommendation #4)

Status: DRAFT for Fable review, 2026-10-31. Docs and QA-script change only. No content, schema, Production writes or frontend change.

## Why
The AP Chem 2.1 case study (`CHEAT_SHEET_DEEP_DIVE_DIGESTIBILITY_AP_CHEM_2_1_2026_10_30.md`) found brief and explainer fields restating each other in reworded form (what_it_is vs core_idea, why_it_matters vs what_students_need_to_understand, how_points_are_earned vs how_this_becomes_points). PR #40 now hides the duplicates at render time, but nothing stops the pipeline from producing them again.

## What exists today (READ)
- Protocol `docs/product/TOPIC_BRIEFS_AND_LEARN_MORE_PRODUCTION_PROTOCOL.md`: "Recommended budgets" (what_it_is 80-260 chars, why_it_matters 80-260, answer_move 80-320, core_idea 100-360, point_attaining_answer 120-520), reviewer-notes-only; criteria C7 (core_idea not byte-identical to what_it_is), C8 (cross-row distinctness), C9 (budgets checked, over-budget rows listed).
- `scripts/qa/topic_guides_database_qa.sql`: read-only (transaction, temp tables, ROLLBACK). C7 and C9 are WARNINGs (grandfathered 2026-08-21), C8 hard only for non-grandfathered rows. Byte-identical is the only overlap test, which is why reworded twins pass.

## Gap
1. No near-duplicate test between paired brief and explainer fields.
2. Budgets are advisory and the 2.1 rows exceed them (to be measured, not assumed).
3. No cap on fields the page renders as paragraphs but the budget table omits (how_points_are_earned, how_this_becomes_points, what_students_need_to_understand, common_point_loss, practice_bridge).

## Steps
1. **Measure the baseline (read-only).** Run SELECTs against Production for all published pairs: field lengths vs current budgets, and pairwise similarity for the three twin pairs plus answer_move and common_point_loss (brief vs explainer). Record counts per subject, the AP Chem 2.1 values, and the distribution (median, p90) so thresholds come from data. Output a small results file under `docs/product/` (summary only, no row dumps).
2. **Choose the similarity method and thresholds from step 1.** Prefer a method computable in the existing SQL gate with no new extension if possible (word-set Jaccard on lowercased, stopword-stripped tokens); use `pg_trgm` only if already installed in both environments. Set the warn threshold so the known 2.1 twins flag and a sample of hand-picked legitimately-distinct pairs do not. Document false-positive/negative spot checks.
3. **Add criterion C13 (overlap) and widen C9 (caps) in the protocol.** Define: twin-field pairs; threshold; waiver mechanism via `source_note` (same pattern as C8); new rows must pass hard, existing rows are listed as grandfathered debt. Extend the budget table to the five missing fields using step 1 data. Keep "reviewer must record why" for exceptions.
4. **Implement in `scripts/qa/topic_guides_database_qa.sql`.** Add QA checks for C13 and the extended C9: WARNING with counts and a capped list of offending (subject, topic) for grandfathered rows; hard exception for rows published after a cutoff date or flagged new (reuse the existing grandfather mechanism, read how C8 does it first). Update the header coverage list (C1-C13). Keep it read-only and idempotent.
5. **Verify.** Run the script against Development, then Production (read-only), and confirm: it still passes all existing hard checks, 2.1's twins are flagged, the known-distinct controls are not, counts match step 1. Also run a negative control: a synthetic near-duplicate pair inside the transaction (rolled back) must trip the hard path.
6. **Record.** Update `docs/INDEX.md` entry, add ACTIVITY_LOG entry, update the protocol cross-reference in `MEMORY_HOOKS_AND_UNIT_REFERENCE_PRODUCTION_PROTOCOL.md` only if it duplicates the budgets. Open one docs+QA-script PR; merge only when CI is green and per docs-PR merge authority (code-bearing, so leave merge to David unless it is docs-only).

## Out of scope
Rewriting any existing content (that is recommendations #3 / generate-select regeneration), schema changes, frontend, Production writes. Warnings do not block releases for grandfathered rows.

## Risks / open questions
- A Jaccard threshold tuned on Chemistry may misfire on math-heavy subjects (symbols, short fields). Mitigation: per-subject breakdown in step 1.
- Hard-gating new rows needs a reliable "new row" signal; confirm how C8 identifies grandfathered rows.
- Production has no local secret key; reads go through the Supabase CLI `--linked`, which resolves to Production from the home dir (see memory), so pin `--workdir` deliberately for Dev vs Prod.

---

# Revision after Fable review (2026-10-31) — supersedes conflicting steps above

Fable (read-only review, checked against the script and protocol) raised four must-fix and six suggestions. Disposition:

| # | Comment | Disposition |
|---|---|---|
| 1 | The script's "grandfathered" set is only rows whose `source_note` ends `grandfathered-2026-08-21` (script ~L445-457, five repair migrations), not "rows that existed on 2026-08-21". Reusing it for C13 would hard-fail ~360 rows on day one. | **Accepted.** Do not reuse it. C13 uses a `published_at` cutoff constant (set at the first run of the new gate) plus a temp-table allowlist of `(subject_key, topic_code)` seeded from the measured baseline, like `topic_guides_qa_expectations`. Rows published after the cutoff are hard; the rest are WARNING with counts. |
| 2 | A negative control inside the main script aborts the run (`raise exception`) and a synthetic insert fires table triggers. | **Accepted.** Control lives in a separate file expected to fail, run on Development only, evidence recorded. Not part of the main script. |
| 3 | Hard C9 caps contradict protocol L107-108 ("not automatically wrong"). | **Accepted: C9 stays advisory.** Widen the budget table and the counts/capped-list report; no hard path. Hard gating only applies to C13 for post-cutoff rows. Waiver tag lives on the explainer `source_note`, as C8 does. |
| 4 | Three positive examples, one subject; 2.1 twins are semantic paraphrases and may not separate lexically. | **Accepted.** Decision rule: threshold from the Production per-pair distribution (above p90 per field-pair), and require >= 10 hand-labelled pairs across >= 3 subjects including Calculus/Physics before any hard path ships. If the known twins do not separate by a comfortable margin, C13 ships WARNING-only and I say so. |
| 5 | Method. `pg_trgm` is installed in Prod and Dev. Prefer overlap coefficient over Jaccard (asymmetric budgets). Tokenize: lowercase, strip LaTeX/`$...$`, drop 1-2 char tokens, small stopword list, skip pairs with < 8 content tokens; threshold per field-pair. | **Accepted.** Step 1 computes trigram `similarity()` and overlap coefficient; choose on data. |
| 6 | Fold C7 into C13. | **Accepted.** C7 becomes the similarity-1.0 special case inside C13 (kept as a named sub-check so existing release evidence keeps its label). |
| 7 | Give authors field-role definitions, not just a gate. | **Accepted.** Add field-role definitions to the protocol: what_it_is = card definition; core_idea = mechanism/why; how_points_are_earned = exam move; how_this_becomes_points = rubric path. |
| 8 | Single source for budgets. | **Accepted.** Budgets live in a temp table in the script; protocol cites it. |
| 9 | Script header says C1-C11. | **Accepted.** Update to C1-C13; mark C12 not covered by this script. |
| 10 | Scope: PR #40 already hides twins at render time; goal must be named. | **Accepted.** Goal is pipeline hygiene so regeneration does not recreate twins. Named alternative, out of scope: drop the redundant brief fields from the model (schema change). |

Revised step order: 1 measure (Prod read-only, plus hand-labelled pairs) -> 2 choose method/threshold by the decision rule -> 3 protocol edits (C13, C7 fold, field roles, budget table cite) -> 4 script (budget temp table, C13 with cutoff + allowlist, C9 advisory widening, header) -> 5 verify on Dev then Prod read-only, separate failing negative-control file on Dev only -> 6 record (INDEX, activity log) and one PR.
