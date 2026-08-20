# TASK-0016 Phase D — Stage D1: Spatial Contract (v1, frozen 2026-08-19)

**Status:** Stage D1 deliverable. Freezes the versioned, schema-validated record contracts for
Engine 4 (spatial/hand-drawn grading), per `prompts/CLAUDE_TASK0016_PHASE_D_SPATIAL_ENGINE_2026_07_27.md`
("## Stage D1 — Freeze the spatial contracts"). Builds directly on Stage D0
(`CURRENT_STATE.md`, `ARTIFACT_INVENTORY.json`, `DECISIONS_AND_BLOCKERS.md`, same directory) —
read those first if you have not; this document does not re-derive their findings.

**Scope discipline, restated from the Phase D prompt:** this is schema/contract design,
documentation, and tests only. No database, migration, capture UI, observation pipeline, or
grading integration is touched or implemented here (Stage D2+). V1 is capped at the 3 archetypes
already frozen in Stage D0 — `categorical_comparison_supplied_uncertainty`,
`continuous_measured_series_supplied_uncertainty`, `continuous_relationship_graph_derived_estimate`
— and at the 300-response/100-per-archetype release-corpus target already specified in
`TASK-0011_PHASE_1_EXECUTION_SPEC.md`. Neither is re-litigated here.

---

## 1. Why these contracts, and what "frozen" means here

"Frozen" means: every record type below has a versioned JSON Schema file
(`schemas/*.v1.schema.json`), every schema requires a `contract_version` field pinned to `"v1"`
by JSON Schema `const`, and no downstream stage may silently reshape a record without minting a
new version (`v2`, etc.) and documenting the migration. A schema is not "frozen" because it is
hard to change — it is frozen because *changing it without bumping the version is itself the
defect this stage exists to prevent.*

The non-negotiable architecture from the Phase D prompt is the organizing constraint for every
schema decision below:

> Keep these records separate and versioned: `capture_quality_result`, `visual_observation_result`,
> `criterion_decision_result`, `confidence_and_abstention_result`, `feedback_result`. The image
> pipeline observes evidence. It does not directly award points. Criterion decisions cite locked
> observation IDs and the applicable rubric contract. Feedback cites locked criterion decisions.
> Model self-reported confidence is diagnostic metadata, never a release control.

Every one of those five record types below is its own schema file, with no shared/merged shape.
Every cross-record reference (an ID cited by another record) is validated for existence by
`scripts/drawn_response/validate_phase_d_spatial_contracts.py`'s citation-integrity check — not
just documented as an intention. See §4.

## 2. Reuse ledger — what came from `scripts/drawn_response/schemas/` and what is new

Per the Stage D1 spec's explicit instruction ("Reuse, don't recreate"), every draft schema in
`scripts/drawn_response/schemas/` was read before writing anything new. Five of seven drafts
already matched a Stage D1 requirement closely enough to freeze with only a rename and a
`contract_version` stamp; one needed real reconciliation against a second, independently-evolved
shape; two Stage-D1-required record types had no prior draft at all.

| Stage D1 v1 contract | Source | Change from source |
|---|---|---|
| `pairing_submission_provenance_event.v1` | `capture_session_event.schema.json` | Rename only (the draft's own `$comment` already frames it as the pairing/provenance contract) + version stamp. Structurally identical. |
| `capture_image_record.v1` | `capture_image_record.schema.json` | Version stamp only. Added an explicit field-mapping note to `app.response_attachments` (§2.2) since none existed before. |
| `capture_quality_result.v1` | `capture_quality_record.schema.json` | Rename (`_record` → `_result`, matching the non-negotiable-architecture name) + version stamp. Structurally identical. |
| `visual_observation_result.v1` | `observation_record.schema.json` | Rename (`_record` → `_result`) + version stamp. Structurally identical. |
| `criterion_decision_result.v1` | `criterion_decision_record.schema.json` | **Reconciled**, not just renamed — see §2.5. This is the one contract where "reuse the draft as-is" would have been wrong. |
| `experiment_telemetry.v1` | `method_run_log.schema.json` | Rename (matches the Stage D1 spec's own bullet name) + version stamp + renamed one field (`criterion_ids_produced` → `criterion_decision_ids_produced`) for precision — see the schema's own `$comment`. |
| `partition_manifest.v1` | `partition_manifest.schema.json` | Version stamp only. Not one of the 8 Stage D1 bullets, but directly supporting infrastructure Stage D0 already confirmed correct (archetype freeze + release-corpus target). Included so corpus governance stays versioned alongside the records it gates access to. |
| `confidence_and_abstention_result.v1` | **None — new in Stage D1.** | See §2.6. |
| `feedback_result.v1` | **None — new in Stage D1.** | See §2.7. |

The original draft files in `scripts/drawn_response/schemas/` are **left untouched** — they remain
the historical research-protocol record of `TASK-0011_PHASE_1_EXECUTION_SPEC.md`'s sections 4–8,
and `scripts/drawn_response/validate_records.py`/`test_capture_session_contract.py` continue to
validate against them unchanged. The v1 contracts in this directory are the Stage-D1-frozen,
production-vocabulary-reconciled versions that Stage D2+ and any future grading integration should
build against.

### 2.1 Pairing and submission provenance

`pairing_submission_provenance_event.v1.schema.json` is the draft `capture_session_event` schema,
renamed and stamped. It is already an append-only, hash-only (never a raw pairing secret),
fail-closed event stream with a full state-machine of `event_type`s covering session creation,
QR/fallback pairing, capture, quality labeling, retake, submission, and every terminal/rejection
path. `scripts/drawn_response/validate_records.py`'s `validate_capture_session_event_semantics`
and `validate_capture_session_stream` already enforce strict-sequence ordering, single-use pairing
handles, and terminal-state lockout — those functions are unchanged and still apply to v1 records
(they operate on field shape, not the schema file's `$id`).

### 2.2 Raw and derived image identity/checksums — consistency with `app.response_attachments`

`capture_image_record.v1.schema.json` is a **logical/corpus-scoped** identity record (it exists
to track provenance/consent/metadata status for images ingested from many sources — research
corpora, synthetic renders, real captures), not a description of any specific database table. It
is explicitly consistent with, not a duplicate encoding of, the real production table
(`app.response_attachments`, `supabase/migrations/20260815130526_response_attachments.sql` +
`20260818011720_response_attachments_fixes.sql`):

| `capture_image_record.v1` field | `app.response_attachments` column | Note |
|---|---|---|
| `image_id` | `id` | Both are opaque unique identifiers for one exact byte sequence. |
| `image_role` (`ORIGINAL`/`ORIENTATION_CROP`/`DOCUMENT_NORMALIZED`/`EXPERIMENTAL_ENHANCEMENT`) | `kind` (`original`/`derived`) | The DB collapses all non-original roles into one `derived` value; the contract keeps the finer-grained taxonomy because Stage D2+ observation/decision work needs to know *which* transform produced an image, not just that one was applied. A future production `attach_capture` implementation that wants finer roles would need a DB column addition, not a contract change. |
| `source_image_id` | *(no direct column)* | The DB's nearest concept is `replaces_attachment_id`, but that is a **different edge**: it chains successive *originals* across a retake (`kind='original'` only, per the migration's own `response_attachments_replaces_only_original` check). `source_image_id` instead points a *derivative* at the single original it was computed from. Both edges are real and distinct; a production schema mirroring this contract would need both a retake-lineage column (already present) and a derivation-source column (not yet present). |
| `sha256` | `sha256_digest` | Same 64-lowercase-hex-character invariant, enforced by both the DB `check` constraint and this schema's `minLength: 64` + the corpus validator's `re.fullmatch(r"[0-9a-f]{64}", ...)`. |
| `byte_length`, `pixel_width`, `pixel_height` | `byte_size`, `pixel_width`, `pixel_height` | Same fields, same positivity constraints. |
| `media_type` | `media_type` | The contract additionally allows `image/heic` (a real capture-device format the DB does not yet accept — a known, not accidental, gap: the DB's `check` constraint is production-launch-scoped to formats already normalized client-side). |
| `consent_status`, `provenance_status`, `metadata_status` | *(no equivalent columns)* | These are deliberately **research-corpus-only** fields. `app.response_attachments`' own migration comment explains why: a student's own live submission under product ToS does not need a consent/provenance declaration the way an externally-sourced historical photo being ingested into a research corpus does. A production capture record is a strict subset of this contract's concerns, not an incompatible shape. |
| `storage_scope` | `storage_bucket` (currently always `'learner-uploads'`) | The contract's enum is broader (`LOCAL_FIXTURE`/`PRIVATE_RESEARCH`/`PRIVATE_SHADOW`/`PRIVATE_PRODUCT`) because it also has to describe non-production corpus storage; `PRIVATE_PRODUCT` is the value that corresponds to `learner-uploads`. |

No field in `capture_image_record.v1` contradicts a real constraint in `app.response_attachments`
— every apparent difference is either (a) the contract covering a broader case (research corpora)
the DB table correctly doesn't need to, or (b) a genuine gap noted above for whoever builds Stage
D2's production capture pipeline against this contract.

### 2.3 Capture-quality labels and disposition

`capture_quality_result.v1.schema.json` — renamed/stamped from the draft, unchanged structurally.
Already exactly matches the non-negotiable-architecture name. `CAPTURE_DISPOSITION`
(`ACCEPT`/`RETAKE`/`HUMAN_REVIEW`) is the only field from this record type that gates anything
downstream, and it gates *whether an image proceeds to observation at all* — it is not itself an
abstention/release signal for a criterion decision (that is `confidence_and_abstention_result.v1`,
§2.6). Per the draft's own inherited discipline, this record describes the **image**, never the
student's graph correctness.

### 2.4 Visual observations

`visual_observation_result.v1.schema.json` — renamed/stamped from the draft, unchanged
structurally. This is the second non-negotiable record type: the image pipeline observes evidence
here and must never assert a scoring decision in this record (enforced by the schema's own
`additionalProperties: false` — there is no field here a `criterion_decision_result` could
populate even if someone tried).

### 2.5 Criterion decisions with cited observation IDs — the one real reconciliation

This is the contract where two independently-evolved shapes actually needed to be reconciled, not
just renamed:

- **Shape (a):** the research-protocol draft (`criterion_decision_record.schema.json`), defined by
  `TASK-0011_PHASE_1_EXECUTION_SPEC.md`. `decision` ∈ `{MET, NOT_MET, ABSTAIN, NOT_APPLICABLE}`,
  with `cited_observation_ids`, `reason_code`, `rubric_version`, `method`.
- **Shape (b):** the `criterion_statuses[]` shape actually emitted by real grading calls in this
  program, confirmed live in `decision_0045_verification_2026_08_19`'s raw JSONL output
  (`docs/research/hand_drawn_graph_real_photo_benchmark_2026_08_18/decision_0045_verification_2026_08_19/runs/*.jsonl`):
  `criterion_statuses` is a map of `criterion_label` → status ∈
  `{earned, not_earned, unable_to_determine}`, plus a single `confidence` and one free-text
  `rationale` for the whole record — and **no observation citation of any kind.**

`criterion_decision_result.v1.schema.json` adopts shape (b)'s status vocabulary as canonical,
because it is what production grading calls already emit — inventing a third vocabulary that
matches neither existing system would be pure churn. It then layers shape (a)'s citation/rubric
discipline on top, because shape (b) as measured has no citation mechanism at all, and the Phase D
prompt's non-negotiable architecture requires one. The explicit mapping:

| Shape (a) `decision` | v1 `status` |
|---|---|
| `MET` | `earned` |
| `NOT_MET` | `not_earned` |
| `ABSTAIN` | `unable_to_determine` |
| `NOT_APPLICABLE` | `not_applicable` |

**Important caveat, stated plainly:** the `decision_0045_verification_2026_08_19` raw JSONL output
is **not itself a conforming `criterion_decision_result.v1` record today** — it has `confidence`
and `rationale` (both adopted verbatim into v1) but no `cited_observation_ids` and no
`rubric_contract` reference. Backfitting that pass's output with real observation citations was
out of scope for this stage (it would require re-running or re-deriving observation-level evidence
that pass never separately recorded) and is flagged as follow-up work, not silently glossed over.
`method_decision_0045_verifier` was added to the `method` enum specifically so that backfit work,
when it happens, has a value to record it under.

`criterion_decision_result.v1` also adds two fields neither prior shape had:
- `archetype` — the response's frozen V1 archetype, so a downstream consumer can group/gate by
  archetype without a join back to the item definition.
- `rubric_contract` (`{rubric_id, rubric_version}`) — the explicit "applicable rubric contract"
  citation the non-negotiable architecture requires. The draft only had a bare `rubric_version`
  string; v1 pairs it with `rubric_id` so the citation is unambiguous even across items that might
  reuse a version string coincidentally.

`confidence` on this record is **explicitly documented in the schema itself** as diagnostic
metadata only, never a release control — see §3 for how that rule is made structural, not just
written down.

### 2.6 Calibrated abstention/retake/human-review signals — new record type

`confidence_and_abstention_result.v1.schema.json` has no prior draft; it is new in Stage D1. It
exists because nothing in the prior schema set could represent "a *calibrated*, measured decision
about whether to release an automated score, distinct from what the model said about its own
confidence." Key design choices:

- `scope` ∈ `{CRITERION, RESPONSE}` — some abstention decisions are per-criterion (a single
  ambiguous mark), others are response-level (capture quality was bad enough that no criterion
  decision should be trusted, or too many criteria came back `unable_to_determine` to release any
  score for the response).
- `input_signals` is a **record of what fed the decision** (self-reported confidence echoed for
  audit only, self-consistency agreement rate, independent-verifier agreement rate, capture-quality
  disposition) — explicitly not itself the release gate. The Engine 4 FAR investigation
  (`project_engine4_far_investigation_2026_08_18` memory; see also
  `ENGINE4_PRODUCTION_DESIGN_2026_08_18.md`) found self-consistency/majority-vote works as a
  calibratable signal and adversarial re-check is a decisive failure mode — this record shape is
  built to carry exactly the signals that investigation found actually predictive, not an
  unstructured grab-bag.
- `calibration_policy_id` + `measured_false_accept_rate_at_decision` are **both required fields**
  whenever `decision` is `RELEASE_AUTOMATED` (schema-required always; semantically-required
  non-null by the citation-integrity checker specifically for that decision value — see §3).

**Program-policy note, stated in the schema's own `$comment` and repeated here:** per this
program's current policy (100%-human-reviewed AP Statistics shadow, no authoritative automated
learner score — see memory `feedback_no_human_grading_in_production` for the inverse constraint,
and the Phase D prompt's own objective #5), **no real learner response should ever produce a
`confidence_and_abstention_result` with `decision = RELEASE_AUTOMATED` under V1.** The schema
still defines that value because Stage D1's job is to define the record shape a future calibrated
bake-off could legitimately produce, not to build the bake-off itself — but until that bake-off
happens and is owner-approved, this value must not appear in real shadow-operation data. The valid
fixture set (`schemas/fixtures/confidence_and_abstention_result.valid.jsonl`) includes one
illustrative `RELEASE_AUTOMATED` record purely to prove the schema and its calibration-evidence
rule are enforceable, and one `ABSTAIN_HUMAN_REVIEW` record reflecting the actual current policy.

### 2.7 Feedback — new record type

`feedback_result.v1.schema.json` has no prior draft; it is new in Stage D1. The fifth
non-negotiable record type: feedback must cite locked criterion decisions. Design choices:

- `cited_criterion_decision_ids` + `per_criterion_feedback` (each entry re-stating its
  `criterion_decision_id`) — every piece of learner-facing text traces to a specific criterion
  decision; there is no "feedback" field that isn't attributable.
- `cited_confidence_and_abstention_result_id` — when a response's release was suppressed, the
  learner/reviewer sees *why* via a real calibrated record, not an unexplained withholding.
- `release_status` must agree with the cited abstention record's `decision` — enforced by the
  citation-integrity checker (§3), not just documented.

### 2.8 Experiment telemetry

`experiment_telemetry.v1.schema.json` — renamed/stamped from `method_run_log.schema.json`. One
field renamed for precision: `criterion_ids_produced` → `criterion_decision_ids_produced` (it was
always a list of *decision record* IDs, not criterion IDs; the old name was ambiguous against the
new `criterion_decision_result.criterion_id` field).

## 3. How the non-negotiable rules are enforced, not just documented

Two of the Phase D prompt's non-negotiable rules are structural facts about the schema, checkable
by inspection alone:

- *"The image pipeline observes evidence. It does not directly award points."* —
  `visual_observation_result.v1` has no `status`/`decision`/`points` field of any kind
  (`additionalProperties: false` makes this a hard schema fact, not a convention).
- *"Model self-reported confidence is diagnostic metadata, never a release control."* —
  `criterion_decision_result.v1.confidence` and `confidence_and_abstention_result.v1.decision` are
  fields on two different record types with no automatic aggregation between them. Nothing in
  either schema lets a `confidence` value alone produce a `decision` value — a
  `confidence_and_abstention_result` must independently carry `calibration_policy_id` +
  `measured_false_accept_rate_at_decision`.

The remaining rules are cross-record and cannot be expressed in JSON Schema alone (JSON Schema
has no foreign-key concept), so they are enforced by
`scripts/drawn_response/validate_phase_d_spatial_contracts.py`'s `check_citation_integrity`
function, which every schema-conforming record must additionally pass:

1. Every `criterion_decision_result.cited_observation_ids` entry must resolve to a real
   `visual_observation_result.observation_id` in the same evaluation batch.
2. A `criterion_decision_result` with `status != not_applicable` must cite at least one
   observation (empty citations are a schema violation, not a legitimate zero-evidence decision).
3. Every `confidence_and_abstention_result.criterion_decision_id` (when `scope=CRITERION`) and
   every ID in `cited_criterion_decision_ids` must resolve to a real `criterion_decision_result`.
4. A `confidence_and_abstention_result` with `decision = RELEASE_AUTOMATED` must carry a non-null
   `measured_false_accept_rate_at_decision` and a non-empty `calibration_policy_id` — this is the
   line of code that makes "self-reported confidence alone can never satisfy the release gate" an
   enforced rule rather than a comment.
5. Every `feedback_result.cited_criterion_decision_ids` entry, and every
   `per_criterion_feedback[].criterion_decision_id`, must resolve to a real
   `criterion_decision_result`; `cited_confidence_and_abstention_result_id` (when non-null) must
   resolve to a real `confidence_and_abstention_result`.
6. A `feedback_result.release_status` of `RELEASED_TO_LEARNER` requires the cited
   `confidence_and_abstention_result.decision` to be `RELEASE_AUTOMATED`, and vice versa —
   inconsistent pairs fail closed.

**A criterion decision that cites a missing observation fails closed**, per the Stage D1 spec's
explicit requirement — this is rule 1 above, and it is exercised by a real adversarial fixture
(`schemas/fixtures/criterion_decision_result.adversarial_missing_observation.jsonl`) and a real
passing test (`scripts/drawn_response/test_phase_d_spatial_contracts.py::CitationIntegrityTests::test_criterion_decision_citing_missing_observation_fails_closed`).
See `EXECUTION_LOG.md` for the actual test-run transcript.

## 4. Files

```
docs/research/grading_phase_d_spatial_2026_07_27/
  SPATIAL_CONTRACT.md                    <- this file
  CROSS_SUBJECT_MAPPING.md
  schemas/
    pairing_submission_provenance_event.v1.schema.json
    capture_image_record.v1.schema.json
    capture_quality_result.v1.schema.json
    visual_observation_result.v1.schema.json
    criterion_decision_result.v1.schema.json
    confidence_and_abstention_result.v1.schema.json
    feedback_result.v1.schema.json
    experiment_telemetry.v1.schema.json
    partition_manifest.v1.schema.json
    fixtures/
      *.valid.jsonl                       <- one full, internally-consistent citation chain
      *.adversarial_*.jsonl                <- six fail-closed cases, one per broken-citation rule

scripts/drawn_response/
  validate_phase_d_spatial_contracts.py  <- schema engine + citation-integrity checker + CLI
  test_phase_d_spatial_contracts.py      <- unittest suite (schema, citation, adversarial, e2e)
```

Run `python3 scripts/drawn_response/validate_phase_d_spatial_contracts.py` for a human-readable
pass/fail report, or `python3 -m unittest scripts.drawn_response.test_phase_d_spatial_contracts -v`
(from the repo root, with `scripts/drawn_response` on `PYTHONPATH`, or `cd scripts/drawn_response
&& python3 -m unittest test_phase_d_spatial_contracts -v`) for the regression suite.

## 5. What Stage D1 does not decide

- **Does not** re-open the archetype freeze or the 300-response corpus target (Stage D0, already
  settled).
- **Does not** decide whether/when a calibrated bake-off ever legitimately produces a
  `RELEASE_AUTOMATED` `confidence_and_abstention_result` in production — that is Stage D5/D6/D7
  and an owner decision, not something this contract freeze authorizes.
- **Does not** backfit `decision_0045_verification_2026_08_19`'s existing output into conforming
  `criterion_decision_result.v1` records (no observation citations exist for that pass today) —
  flagged as follow-up, not done here.
- **Does not** authorize grading any subject/form beyond the 3 frozen archetypes — see
  `CROSS_SUBJECT_MAPPING.md` for the explicit extensibility-vs-authorization boundary.
