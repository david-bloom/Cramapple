# TASK-0016 Phase D — Execution Log

Per the Phase D execution prompt's logging requirement. UTC timestamps approximate (session-local
clock; exact to the minute where available).

---

**2026-08-19T~19:40Z — Stage D0 start**
- Operation: directory recovery/freeze inventory, per Phase D prompt Stage D0.
- Environment: local session, repo `/Users/davidbloom/Documents/Cramapple.nosync`, main branch.
- Approval dependency: none (D0 is pure investigation, no mutation).
- Action: launched three parallel investigation passes (subagents) covering (1) corpus/script
  inventory + verification of historical benchmark claims against raw result files, (2) live
  Supabase Dev/Prod database and storage object inventory via the Management API
  (`~/.supabase/access-token`, read-only `database/query` and `storage/buckets` calls — no
  mutation), (3) full read of the 8 remaining "Read first" documents named in the Phase D prompt.
- Cost: $0 (no model-API calls beyond agent orchestration; no paid provider calls).
- Cleanup action: none required (read-only).
- Evidence tier change: none by this action alone — it surfaces existing evidence, doesn't create
  new corpus/gold data.

**2026-08-19T~19:55Z — Corpus/script inventory complete**
- Result: 9 corpora + manifest directories classified; all found to be `DEVELOPMENT_ONLY` or
  `REGRESSION_FIXTURE` except the 200-photo real-photo corpus (`HOLDOUT_ELIGIBLE_PENDING_DUAL_HUMAN_ADJUDICATION`).
  Four historical numeric claims (97.33%/99.478%/3393.5ms/$0.003943 on the VISION_FAST_ESC n=150
  benchmark; 87.0% on the 23-image sample; 50/50 on the batch-50 smoke test) independently
  reverified against raw JSONL/CSV result files and confirmed correct. 9 exact-duplicate
  `" 2"`-suffixed files identified via `diff -q`; none deleted.
- Output: folded into `CURRENT_STATE.md` §3 and `ARTIFACT_INVENTORY.json`.

**2026-08-19T~20:05Z — Live DB/storage inventory complete**
- Result: `app.response_attachments` 0 rows (Dev+Prod); `capture_sessions` table does not exist
  in either project (existed in Prod as of 2026-07-09 per a stale generated types file, removed
  since with no migration record); `capture-research` bucket does not exist in either project;
  `learner-uploads` 0 objects (Dev+Prod); `grading_results` with `model_id='manual-review'` 0
  rows (Dev+Prod); `human_shadow` content items unchanged at 59 (Prod). Frontend worktree
  (`.worktrees/task0019-frontend`, commit `369e4e8`) confirmed 16 commits behind `origin/main`.
- Queries: read-only `SELECT`/`information_schema` queries via Management API, no writes.
- Output: folded into `CURRENT_STATE.md` §2 and `ARTIFACT_INVENTORY.json`.

**2026-08-19T~20:15Z — Required-reading pass complete**
- Result: all 8 remaining documents read in full and summarized; no new contradictions found
  against TASK-0016/the ledger; confirmed the Phase-1 spec's 3-archetype freeze and 300/100-90-60-120-30
  corpus target are already the operative numbers (nothing to redo); confirmed TASK-0011 is still
  `Research`/`Pending` and the one human pilot attempt was QA-blocked with no recorded resolution.
- Output: folded into `CURRENT_STATE.md` §4.

**2026-08-19T~20:30Z — Stage D0 deliverables written**
- Output: `CURRENT_STATE.md`, `ARTIFACT_INVENTORY.json`, `DECISIONS_AND_BLOCKERS.md` (this
  directory).
- Approval dependency: none for writing the deliverables themselves (documentation, not a
  Production mutation). The decisions listed in `DECISIONS_AND_BLOCKERS.md` remain open and are
  flagged for the Product Owner, not resolved by this action.
- Cleanup action: none (no test data created; all DB/storage access was read-only).
- Evidence tier change: none — this stage classifies and freezes existing evidence tiers, it does
  not promote anything to a higher tier (in particular, the 200-photo corpus's gold remains
  single-pass AI, explicitly not reclassified as adjudicated by this stage).

**Stage D0 status: complete.** Next stage per the Phase D prompt is D1 (freeze the spatial
contracts) — not started; see `DECISIONS_AND_BLOCKERS.md` item 5 for the owner decision on how to
sequence D1 against the corpus-collection blockers.

---

**2026-08-19T~21:00Z–22:15Z — DECISION-0050 + AI-verification pass**
- Operation: (1) drafted and logged `DECISION-0050`/`APPROVAL-0045` (retire Engine 4's
  dual-human-adjudicated gold requirement, adopt `DECISION-0045`'s model instead) at the owner's
  direct instruction; (2) executed the AI-verification half of that protocol against the
  200-photo real-photo corpus.
- Approval dependency: `DECISION-0050`/`APPROVAL-0045` themselves are the approval — owner gave
  the instruction directly in-session ("Ignore the dual-human-adjudicated gold standard" →
  clarified as "formal decision, log it").
- Models/cost: `google/gemini-2.5-flash` + `alibaba/qwen3-vl-235b-a22b-instruct`, ~423 calls,
  ~$2.15 total spend, under the $10 autonomous cap (no mid-task approval checkpoint triggered).
  `moonshotai/kimi-k2`/`kimi-k2-thinking` probed and rejected (no vision support / unreliable
  structured output) rather than substituted with a disallowed OpenAI/Anthropic model.
- Output: `docs/research/hand_drawn_graph_real_photo_benchmark_2026_08_18/decision_0045_verification_2026_08_19/`
  (README.md, 2 raw JSONL files, analysis_summary.json, flagged_discrepancies.json); 3 new
  scripts in `scripts/vercel-gateway-check/`.
- Result: 91.5%/89.7% verifier-vs-gold agreement (n=133 usable photos), 88.5% verifier-vs-verifier
  unanimity, 31 flagged criterion-level discrepancies across 26 photos (not applied to gold).
- Cleanup action: none required — no test data created in any database; all spend was against the
  gateway's real usage, already accounted for above; existing gold file confirmed untouched via
  `git status`/`git diff`.
- Evidence tier change: the 200-photo corpus's gold has NOT been promoted to certified
  `DECISION-0045` gold by this action alone — the human reader-certification step is still
  required before that promotion is complete. This action completes the AI-verification
  precondition for that step, nothing more.
- `CURRENT_STATE.md` and `DECISIONS_AND_BLOCKERS.md` updated in place to reflect all of the above.

---

**2026-08-19 — Stage D1: freeze the spatial contracts**
- Operation: read `scripts/drawn_response/schemas/*.schema.json` (7 draft schemas) in full, read
  `app.response_attachments`'s migrations, and read the `decision_0045_verification_2026_08_19`
  raw JSONL output shape, then produced versioned (`contract_version: "v1"`) JSON Schemas for the
  8 Stage-D1-required record types plus `partition_manifest` as supporting infrastructure. 5 of 9
  schemas are rename+version-stamp reuses of the existing drafts; `criterion_decision_result.v1`
  reconciles the draft's `MET`/`NOT_MET`/`ABSTAIN`/`NOT_APPLICABLE` vocabulary with the
  `earned`/`not_earned`/`unable_to_determine` vocabulary actually emitted by production grading
  calls (added `rubric_contract`, `archetype`, kept `cited_observation_ids`); two record types
  (`confidence_and_abstention_result`, `feedback_result`) had no prior draft and are new.
- Deliverables: `SPATIAL_CONTRACT.md`, `CROSS_SUBJECT_MAPPING.md`, `schemas/*.v1.schema.json` (9
  files), `schemas/fixtures/*.jsonl` (9 valid + 6 adversarial fixture files), plus
  `scripts/drawn_response/validate_phase_d_spatial_contracts.py` (schema engine +
  citation-integrity checker + CLI) and `scripts/drawn_response/test_phase_d_spatial_contracts.py`
  (13-test unittest suite: schema validation, citation integrity, 6 fail-closed adversarial cases,
  one end-to-end CLI check).
- Verification: `python3 scripts/drawn_response/validate_phase_d_spatial_contracts.py` exits 0
  (all 9 valid fixtures pass schema validation, the valid citation chain has zero integrity
  errors, all 6 adversarial fixtures fail closed as intended).
  `python3 -m unittest test_phase_d_spatial_contracts -v` (run from `scripts/drawn_response/`):
  13/13 tests pass, including
  `test_criterion_decision_citing_missing_observation_fails_closed` (the specific case the Stage
  D1 spec calls out: "A criterion decision that cites a missing observation must fail closed").
  Confirmed the pre-existing `test_capture_session_contract.py` suite (10 tests) is unaffected —
  no draft schema file was modified.
- Approval dependency: none (documentation/schema/test authorship only; no DB, migration, capture
  UI, observation pipeline, or grading integration touched, per Stage D1's explicit scope).
- Cleanup action: none (no test data created in any database or storage bucket).
- Evidence tier change: none. This stage freezes contract *shape*, not evidence quality — no
  corpus's gold tier changes as a result of this work. `CROSS_SUBJECT_MAPPING.md` is explicit that
  its 5-subject mapping is extensibility evidence only, not authorization to grade Statistics
  beyond the already-frozen 3 archetypes, nor Biology/Chemistry/Economics/Physics at all in V1.
- Known incompleteness, stated rather than hidden: `decision_0045_verification_2026_08_19`'s
  existing raw output is not itself a conforming `criterion_decision_result.v1` record (it has no
  observation citations) — backfitting it was out of scope for this stage and is flagged in
  `SPATIAL_CONTRACT.md` §2.5 as follow-up work, not silently treated as already done.

**Stage D1 status: complete.** Next stage per the Phase D prompt is D2 (implement and verify the
QR capture MVP) — not started; Stage D0's blockers 1/2 (System A currently broken against live
Production, no owner decision yet on QR-vs-direct-upload) remain the relevant precondition to
resolve before D2 work can proceed cleanly.

## Stages D4 + D5 — packaged from existing evidence, one paid confirmation run — 2026-08-20

- Owner directive: "do the first two options, D4 and D5." Both stages packaged into their
  prompt-named artifacts from the already-collected 2026-08-18/19 evidence (per
  `D3_D4_D5_STATUS.md`'s "repackage over re-run" recommendation), plus two new re-analyses and one
  bounded paid confirmation run. **Owner selected arm 4's reading** = design-doc option (d)
  (gate-on-escalation), the ~$0 reading, over the prompt's literal perception-reconciliation arm.
- **D4 → `BAKEOFF_RESULTS.md`.** All four arms mapped to existing evidence; primary run's aggregate
  independently recomputed from raw rows and reproduces the source doc exactly (38.5% exact / 93.3%
  F1 / 19.0% FAR / 8.0% FRR). New zero-spend arm-4 re-analysis
  (`analysis/arm4_gate_on_escalation.py`): gate-on-escalation is **near-neutral vs. gating the raw
  primary** (auto-slice FAR 12.05% vs 12.2%, identical F1/FRR, +2pp coverage) — escalation and
  confidence-gating are redundant levers, neither clears FAR. Honestly flags the real remaining D4
  gap: no pre-registered locked holdout (D4d), gold is `ai_provisional`.
- **D5 → `ABSTENTION_CALIBRATION.md` + `abstention_thresholds.json`.** Thresholds built from
  OBSERVED per-(archetype,criterion) false-accept rates (`analysis/d4_d5_evidence_repackage.py` →
  `analysis/d4_d5_summary.json`), not model confidence. `abstention_thresholds.json` generated
  deterministically (`analysis/gen_abstention_thresholds.py`): **only 3 of 24 (archetype,criterion)
  cells are provisionally auto-eligible** even at a generous R&D bar (FAR ≤5%, ≥8 negative support);
  11 fail on high FAR, 10 lack negative support. Encodes the required behaviors (withhold total on
  any point-bearing abstention; retake only for fixable capture defects).
- **Paid confirmation run: self-consistency full-corpus (the one outstanding D5 paid item).**
  Extended the n=39 pilot to all 200 photos — 2 extra `gpt-5.2` passes each, 322 new calls,
  **$6.64, 0 errors** (under the ~$10 autonomous research cap). Harness patched non-destructively
  (`SC_INPUT_JSON`/`SC_OUTPUT_JSONL` env overrides; the pilot's n=39 invocation and its output file
  are untouched). Report: `analysis/self_consistency_fullcorpus_report.json`. Result — the pilot's
  directional read **holds at scale but attenuates, did NOT reverse** (contrast the escalation
  reversal): majority-earned (2 of 3) FAR 19.0→14.7 (FRR 8.0→9.4, F1 flat); unanimous 3/3 FAR
  →9.5 (FRR →11.7). Helps CAT/EST, does nothing for SER. Still fails ≤2% DR-1; a candidate
  shadow-mode lever at 3× cost, not adopted as default.
- Verification: primary-run aggregate reproduced exactly (harness validated); SC baseline row
  reproduces the canonical 19.0/8.0/93.3/38.5 baseline exactly; SC run 400/400 rows, 0 `ok:false`,
  all 200 photos have both extra runs. `abstention_thresholds.json` re-validated as parseable JSON.
- Evidence tier change: **none.** Every number remains R&D-tier — `ai_provisional` gold, iterated
  corpus, no locked holdout. Both artifacts label themselves shadow-only throughout. Nothing here
  advances any corpus's gold tier or authorizes automated authoritative grading.
- Approval dependency: none for the analysis/packaging itself. The paid run fell under the
  established ~$10 autonomous research-spend precedent. No DB, migration, capture UI, or grading
  integration touched.

**Stages D4/D5 status: packaged (R&D-tier).** The genuine remaining work in both is gated on D3
(reader-certified gold + corpus volume) before a locked D4d holdout can be frozen — not closeable
by an AI agent. See `BAKEOFF_RESULTS.md` §5–6 and `ABSTENTION_CALIBRATION.md` §7.
