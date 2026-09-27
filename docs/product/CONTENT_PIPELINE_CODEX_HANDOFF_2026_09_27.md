# Content Pipeline Remediation Handoff — 2026-09-27

## Outcome

The authorized TASK-0042 cross-cutting remediation is complete and independently QA-verified.
Production project: `pcntajvbdfqhbeewmdry`. Approval: `APPROVAL-0056`.

### Freshness audit

Migration `20260927112814_reaudit_decision0066_single_unit_promotions` is applied. All 216
labels promoted by `20260926233500` were reconstructed from original pre-promotion migrations
and checked against the current published version plus the original generation-time taxonomy hash.

| Subject | Verified fresh | Reverted | Unverifiable |
| --- | ---: | ---: | ---: |
| AP Calculus AB | 24 | 0 | 0 |
| AP Chemistry | 25 | 0 | 0 |
| AP Physics 1 | 70 | 0 | 0 |
| AP Physics 2 | 49 | 0 | 0 |
| AP Precalculus | 25 | 0 | 0 |
| AP Statistics | 23 | 0 | 0 |
| **Total** | **216** | **0** | **0** |

Row evidence:
`docs/research/content_pipeline_freshness_2026_09_27/DECISION_0066_PROMOTION_FRESHNESS_AUDIT_2026_09_27.csv`.
The original `20260926233500` source now requires exact generation-hash equality; timestamp
ordering is no longer treated as freshness evidence.

### Difficulty correction

`20260927112232_correct_remaining_difficulty_predict_integrate` is applied. Exactly five rows
moved from Medium to Hard under DECISION-0061:

- `apphycm-frq-017`, `apphycm-frq-024`
- `apphycem-frq-021`, `apphycem-frq-025`
- `apcalcbc-frq-np1-006`

The five base migrations remain reproducible at their applied values; the correction is separate.
Exact source packet snapshots now live under
`docs/research/content_pipeline_difficulty_2026_09_26/source_packets/`, so the builder no longer
depends on `/private/tmp`.

### Runner hardening

`scripts/taxonomy/extend_serving_labels_mcp.mjs` now:

- reuses a prior result only when exam, content key, content-item identity, current version,
  generation taxonomy hash, and recomputed input-packet hash all match;
- never reuses `model_call_failure`;
- aborts generated SQL before writing on wrong subject/key, inactive pack, non-current version,
  taxonomy-hash drift, or a newer current label;
- has a no-network regression fixture at
  `scripts/taxonomy/fixtures/runner_safety_fixture.json`;
- points operators to the correct exporter,
  `scripts/taxonomy/fetch_candidate_serving_label_packets.sql`.

Checks: `node --check` passed; `--self-test-fixture` passed.

### Remaining subject writes completed

The prior E&M and Calculus BC results were strictly revalidated and reused. All 76 Mechanics
`model_call_failure` rows were genuinely retried; final Mechanics outcome was 58 provisional
agreements and 18 held (17 model disagreements, 1 rubric failure).

Applied guarded writes:

- `20260927113442_apphysicscem_tier3_labels_guarded` — 96 rows
- `20260927113502_apcalculusbc_tier3_labels_guarded` — 98 rows
- `20260927113945_apphysicscmechanics_tier3_labels_guarded` — 76 rows

Applied fresh single-unit promotions:

- `20260927114120_promote_apphysicscem_fresh_single_unit` — 71
- `20260927114124_promote_apcalculusbc_fresh_single_unit` — 36
- `20260927114128_promote_apphysicscmechanics_fresh_single_unit` — 45

The values above record the state before the blind third review. No multi-unit label was promoted
without that review.

### Blind third review and final promotion

A new live audit found 141—not the earlier partial count of 49—current, fresh, provisional
multi-unit two-model agreements across all ten subjects. With David's explicit approval to transmit
the question stems, answers, and rubrics, every packet received a blind review through Vercel AI
Gateway using `anthropic/claude-haiku-4-5`; the reviewer did not receive the candidate label.

| Outcome | Rows |
| --- | ---: |
| Exact full-label confirmation | 27 |
| Disagreement | 66 |
| Rubric/scope hold | 48 |
| Call error | 0 |
| **Total** | **141** |

Applied `20260927184534_task0042_promote_blind_third_review_confirmations`; exactly 27 confirmations
moved to `validated`. All 114 non-confirmations remained provisional or held. Four results matching
the candidate `required_units` but disagreeing on `primary_unit` were conservatively excluded because
the promotion rule required an exact full-label match.

Evidence:
`docs/research/content_pipeline_third_review_2026_09_27/REPORT.md`, `reviews.json`,
`reviews.jsonl`, `summary.json`, and `packets.json`.

### Approval provenance correction

The work was initially recorded locally as `APPROVAL-0051`. Reconciliation with newer `main`
showed that ID was already assigned to TASK-0044, so TASK-0042 was renumbered to `APPROVAL-0056`.
Production migration `20260927181002_correct_task0042_approval_note_provenance` corrected exactly
the 152 validation-decision notes created by the three promotions; verification returned 152 notes
on `APPROVAL-0056` and zero remaining on the conflicting ID. No label state changed.

### Live verification

`app.servable_items_census_selftest()` returned no mismatches across all ten subjects. Fresh current
validated counts and maximum eligible unit-gated pools are Biology 23, Statistics 67 (selector cap
48), Calculus AB 36, Chemistry 65, Precalculus 53, Calculus BC 45, Physics 1 85, Physics 2 50,
Physics C Mechanics 50, and Physics C E&M 75.

## Independent QA

Claude independently verified the two sampled original hashes in their pre-promotion migration,
confirmed 216/216 validated with zero reversions, queried all five Hard rows, reviewed the runner
guards and fixture, confirmed all nine new Production migrations in the ledger, and verified the
three live subject counts. Verdict: core remediation passed; the documentation and cosmetic exporter
reference were the only follow-up findings, now corrected here.

## Closeout

- The multi-unit review is complete. The 114 non-confirmations are evidence-backed exclusions, not
  an unfinished queue.
- Biology remains at 43/600 MCQ, 59/300 short FRQ, and 16/64 long FRQ against its planning targets.
- Under `DECISION-0082`, the other nine subjects have no fixed quantity targets; they maximize safely
  usable current published inventory without weakening content, freshness, rubric, or review gates.
- TASK-0042 is Done.
