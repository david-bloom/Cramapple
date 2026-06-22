# Drawn-Response Rubric-Match Bake-Off Protocol (DR-1)

**Status:** Proposed; not approved for execution. Blocked on the section
3.2 authoring/preflight gate for at least one item.
**Owner:** Product Owner with Learning Quality Owner / Technical Owner
**Last Updated:** 2026-06-18
**Related Tasks:** `TASK-0011`
**Related Specs:** `docs/research/TASK-0011_PHASE_1_EXECUTION_SPEC.md`
(section 8), `docs/research/TASK-0011_OFFLINE_EVALUATION_HARNESS_DESIGN.md`
**Related Reports:** None yet — no run has occurred.
**Template:** Structured after `docs/research/GRADER_SPEED_SUBTASK_PROTOCOL.md`

## 1. Purpose

Turn the phase-1 spec's offline bake-off (section 8.2-8.5, already
approved as research specification) into a runnable experiment: confirm
which of the four candidate grading methods reproduces locked human gold
criterion decisions for hand-drawn AP Biology graphs, and at what
sample-size tier that confirmation is trustworthy.

This protocol does not change the spec's metrics or thresholds — section
9 below restates them verbatim. What this protocol adds is the missing
operational layer: pre-registered hypotheses about which method wins where,
an explicit corpus-state read-tier gate (the spec assumes a fully assembled
locked holdout; today the corpus has zero authored items), and a procedure
that says exactly what to run, in what order, against what.

## 2. Priority Order (Binding)

Unlike the general FRQ grader-speed track, rubric-match accuracy here is a
binary gate, not a speed/cost trade space:

1. **Safety** — zero severe errors, false-abstention rate within the
   spec's bound. A method that is fast or cheap but wrong is not a
   candidate at any tier.
2. **Coverage** — how many criteria classify as `AUTOMATION_CANDIDATE`
   (section 8.5) rather than `HUMAN_REVIEW_REQUIRED` or `UNSUPPORTED`.
3. **Latency and cost** — reported, not gated. Drawn-response capture and
   review is not a live-typing FRQ flow (UX-008's cross-device handoff
   already assumes the learner can "continue, wait, or leave safely"), so
   this track does not inherit the sub-2-second urgency of text FRQ
   grading (contrast `docs/research/GRADER_SPEED_SUBTASK_PROTOCOL.md`).

## 3. Goals

1. Identify which of the four section 8.2 methods best matches gold per
   `criterion_label` and archetype, and whether the hybrid method actually
   improves on its single-method inputs or just averages them down.
2. Get an early per-criterion classification (section 8.5) to learn,
   before the full locked holdout is assembled, whether phase-1's six-item
   grammar should narrow, proceed as planned, or stop (spec section 9 stop
   conditions).
3. Validate the offline evaluation harness against real labeled data for
   the first time — it has only run against synthetic fixtures so far
   (`TASK-0011_OFFLINE_EVALUATION_HARNESS_DESIGN.md` section 6).
4. Surface reason-code disagreement patterns early enough to repair the
   rubric before the locked holdout opens (a rubric defect found after the
   holdout opens invalidates and relabels affected partitions per spec
   section 6.2 step 10 — expensive; finding it on the development
   partition is cheap).

## 4. Non-Goals

- Do not make a production-release decision from any tier below
  Locked-Holdout (section 8 below).
- Do not test feedback quality or usefulness — that is
  `DRAWN_RESPONSE_FEEDBACK_USEFULNESS_PROTOCOL.md` (DR-2), which assumes
  this protocol's gold criterion decisions as a fixed input so the two
  questions don't confound each other.
- Do not run on real student or learner data. Phase 1 has no production
  data; all responses are expert-development or properly authored
  synthetic/expert-pilot cases under spec section 3.2.
- Do not select a production vendor or model from this protocol
  (Architecture Review section 4.2: "No provider should be the
  architecture").
- Do not skip or compress the section 3.2 authoring/preflight gate to get
  data faster.

## 5. Pre-Registered Hypotheses

1. **H1 (geometry wins on measurement):** `method_deterministic_geometry
   _ocr` will exceed `method_direct_multimodal` exact agreement on
   `PLOT_VALUES`, `X_SCALE`, and `Y_SCALE` by at least 10 percentage
   points, because these are measurement-extraction tasks where pixel
   geometry should outperform holistic visual reasoning (Architecture
   Review section 6, Priority 3).
2. **H2 (multimodal wins on ambiguity):** Among disagreements tagged
   `AMBIGUOUS_MARK`, `method_multimodal_observation_then_criterion` will
   resolve correctly (matching gold) more often than
   `method_deterministic_geometry_ocr`, because semantic disambiguation of
   overlapping or unclear marks is a visual-reasoning task, not a
   measurement task.
3. **H3 (hybrid is not strictly dominated):** For every `criterion_label`,
   `method_hybrid_reconciliation`'s exact agreement will be at or above
   `min(geometry_exact_agreement, multimodal_exact_agreement)` minus 2
   percentage points. A hybrid method that scores meaningfully below both
   of its inputs on any label indicates the reconciliation logic is
   actively hurting, not helping, and should be flagged before it's
   treated as a default "safe choice."
4. **H4 (estimate-linking criteria are hardest):** `ZERO_INTERCEPT
   _ANNOTATION`, `PLATEAU_ANNOTATION`, and `BEST_FIT_RELATIONSHIP` will
   show the lowest cross-method exact agreement of all criterion labels,
   because they require correctly linking two pieces of evidence (a fitted
   relationship and a reported value) rather than detecting one feature's
   presence.
5. **H5 (development-tier abstention is not the production estimate):**
   `false_abstention_rate` measured on the development partition will run
   materially higher than what section 8.4 ultimately requires, because
   the development partition is deliberately enriched with edge cases
   (section 8.1: 15% partial-credit, 10% contradictory, 10% ambiguous).
   This is pre-registered so a high development-tier abstention number is
   not mistakenly read as a production estimate.

## 6. Methods Under Test ("Arms")

The four methods from spec section 8.2, each run against the same gold
file for a given corpus snapshot:

| Method | What it is | Status |
| --- | --- | --- |
| `method_direct_multimodal` | One multimodal-model pass straight to criterion decisions | Not yet implemented |
| `method_multimodal_observation_then_criterion` | Multimodal observation pass, then a separate criterion grader | Not yet implemented |
| `method_deterministic_geometry_ocr` | Deterministic pixel/geometry analysis plus OCR, then a separate criterion grader | Not yet implemented |
| `method_hybrid_reconciliation` | Reconciles the deterministic and multimodal observations before grading | Not yet implemented |

**This is the protocol's central open dependency:** none of the four
methods exist as runnable code yet. Building a throwaway, bake-off-grade
implementation of each (not a production candidate — Architecture Review
section 4.2 explicitly forbids treating bake-off code as a vendor
commitment) is prerequisite engineering work, tracked separately from this
experiment design. This protocol can validate its own plumbing (section 10
step 2) without them, but cannot produce H1-H5 results until at least two
methods exist to compare.

## 7. Instrumentation

Reuses existing tooling, no new instrumentation needed:

- `scripts/drawn_response/schemas/criterion_decision_record.schema.json`
  — the `method` field already distinguishes gold from each candidate.
- `scripts/drawn_response/schemas/method_run_log.schema.json` — latency,
  cost, and reviewer-burden per invocation.
- `scripts/drawn_response/evaluate_offline.py` — metrics, decision gates,
  outcome classification.
- `scripts/drawn_response/report_offline_eval.py` — markdown report,
  including the read-tier framing this protocol depends on.

## 8. Corpus and Read-Tier Gate

The phase-1 spec (section 8.1) describes the target end-state corpus: 300
responses across six items, partitioned into development (90),
calibration (60), locked holdout (120), and challenge (30). Today that
corpus has **zero** responses — no item has passed the section 3.2
authoring/preflight gate. This protocol defines three read tiers tied to
corpus state, borrowing the sample-size tiering convention from
`docs/research/bio_reference_layer_reporting_standard.md`:

| Tier | Corpus state | n (per criterion_label, approx.) | What it's for |
| --- | --- | --- | --- |
| **Single-Item Smoke** | First item passes section 3.2 gate; its development partition (15 responses) is labeled | Up to 15 | Sanity-check the harness end-to-end on real (not synthetic) data; first directional signal on H1/H2/H4 for one archetype only |
| **Multi-Item Development** | At least 3 of 6 items reach development partition | Up to 45 | Directional read across more than one archetype; early rubric-repair signal (Goal 4) |
| **Locked Holdout** | All six items pass section 3.2, full corpus assembled per section 8.1 partition targets, locked-holdout partition opened per section 6.2 | 20 per item / 120 total | The only tier that may apply section 8.4's decision gates or section 8.5's outcome classification as a production-relevant result |

No tier below Locked Holdout may be cited to promote a method to
production-candidate status. This mirrors the read-tier discipline in
`docs/research/bio_reference_layer_reporting_standard.md` section 3 and
the `evaluate_offline.py` `decision_grade_n` mechanism, applied here at
the corpus-assembly level rather than just the per-run sample level.

## 9. Metrics and Pass Thresholds

Restated verbatim from `TASK-0011_PHASE_1_EXECUTION_SPEC.md` section 8.4
— this protocol does not modify them:

| Metric | Required threshold |
| --- | --- |
| Criterion exact agreement | At least 95% overall and at least 90% for every criterion |
| Criterion precision | At least 0.93 for every criterion and 0.95 macro average |
| Criterion recall | At least 0.93 for every criterion and 0.95 macro average |
| Long-FRQ total-score exact agreement | At least 80% |
| Total score within one point | At least 98% |
| Mean absolute total-score error | At most 0.25 points |
| Weighted Kappa | At least 0.80 where appropriate |
| Over-scoring rate | At most 5% |
| Under-scoring rate | At most 5% |
| Severe error rate | Zero |
| Ambiguity/escalation recall | At least 90% |
| False abstention on scorable responses | At most 10% |

**Gap this protocol flags but does not close:** spec section 8.4 does not
carry forward the two feedback-quality release metrics that
`docs/architecture/CONTENT_GOVERNANCE_AND_VALIDATION.md` section 12.3
already requires for general FRQ grading ("Feedback evidence grounding,"
"Generic or rubric-recycled feedback defect"). This protocol is
rubric-match only and does not test feedback text. See
`DRAWN_RESPONSE_FEEDBACK_USEFULNESS_PROTOCOL.md` (DR-2) section 3, which
proposes extending those two metrics to drawn-response feedback
specifically, and flag to Learning Quality that TASK-0011's section 8.4
table should likely be amended to include them before any locked-holdout
run is treated as a complete release gate.

## 10. Procedure

1. **Confirm the blocking dependency.** At least one `DRG-P1-*` item must
   have passed the section 3.2 authoring/preflight gate (immutable item
   package, reproducibility check, Learning Quality approval, source-
   isolation review, Product Owner participant-use approval). This step
   is owned by item authoring work, not this protocol.
2. **Harness dry run (no blocking dependency).** Re-run the synthetic
   fixture smoke test in `TASK-0011_OFFLINE_EVALUATION_HARNESS_DESIGN.md`
   section 6 to confirm the harness is still correct before trusting it
   on real data. This step can and should happen now, independent of item
   authoring.
3. **Assemble the partition manifest** for the available item(s) using
   `scripts/drawn_response/check_partition_manifest.py`; resolve any
   governance findings before labeling begins.
4. **Run the human-labeling protocol** per
   `docs/research/DRAWN_RESPONSE_ANNOTATION_HANDBOOK.md` to produce locked
   `human_lead_adjudication` gold criterion-decision records for the
   available partition.
5. **Implement bake-off-grade method code** for as many of the four
   section 8.2 methods as are ready (see section 6's open dependency).
   Run each against the same locked gold file and the same response set.
6. **Run `evaluate_offline.py`** once per method, against the same gold
   file, same corpus snapshot.
7. **Run `report_offline_eval.py`** per method; collect the resulting
   reports.
8. **Aggregate a cross-method comparison** — a short report comparing all
   available methods' per-criterion-label tables side by side, naming the
   read tier per section 8 and explicitly declining to draw
   Locked-Holdout-only conclusions at lower tiers.
9. **Learning Quality reviews disagreement clusters** (grouped by
   `reason_code` and `criterion_label`) and proposes rubric repairs where
   a pattern suggests a rubric defect rather than a method weakness.
10. **Repeat at the next corpus tier** as more items clear the section 3.2
    gate, re-running steps 3-9 against the larger snapshot.

## 11. Analysis Plan

- Decide H1-H4 directly from the `evaluate_offline.py` per-criterion-label
  table. Do not pool across criterion labels if per-label deltas disagree
  in sign.
- Decide H5 by comparing the development-partition `false_abstention_rate`
  against the section 8.4 target (10%) and stating explicitly whether the
  gap is expected per the pre-registration in H5, not as a new finding.
- Report results with the read tier (section 8) attached to every claim,
  per `bio_reference_layer_reporting_standard.md` section 3's permitted-
  language rules for each tier.
- Do not introduce new metrics post-run; if a finding suggests a new
  metric is needed, propose it as a protocol revision, not a silent
  addition to the report.

## 12. Decision Gates

**Promote a method to production-candidate status:** only at
Locked-Holdout tier, meeting every section 9 threshold above, with no
unresolved scope mismatches and no `abstain_override_count` greater than
zero on any criterion (an abstain-override — the method confidently
deciding a case humans themselves couldn't — is treated as a standalone
blocker regardless of aggregate metrics, consistent with spec section
8.4's closing rule that "passing aggregate metrics does not override a
repeated... severe... defect").

**At Smoke or Development tier**, the only gate is a process gate: is the
harness producing schema-valid, correctly-paired output with an empty
integrity-check failure list (`report_offline_eval.py`'s Integrity Check
section). A Smoke/Development-tier quality number, good or bad, gates
nothing.

**Narrow or stop phase 1** (per spec section 9 stop conditions) if, at
Multi-Item Development tier or later, no method is within reach of the
section 9 thresholds on more than half of criterion labels — that is
early evidence worth escalating to the Product Owner before the full
locked-holdout investment.

## 13. Out of Scope

- Item authoring itself (spec section 3.2; separate work).
- Feedback quality or usefulness (DR-2).
- Production deployment, vendor selection, or pricing decisions.
- Automated capture-quality detection (no prototype authorized per
  `docs/product/HANDWRITTEN_GRAPH_CAPTURE_EXPERIENCE_DESIGN.md`).
- Image-overlay/localization features (Architecture Review section 4.6).

## 14. Open Questions for Reviewers

1. Who builds the four bake-off-grade method implementations, and in what
   order? Building all four before any data exists is wasted effort if
   H3 already predicts hybrid won't be tested until the other two exist;
   recommend building geometry/OCR and direct-multimodal first since H1
   and H2 only need those two.
2. Is a single-item Smoke-tier read (n≤15, one archetype) worth reporting
   at all, or should the first report wait for Multi-Item Development
   tier to avoid a misleadingly clean or messy single-archetype result
   anchoring expectations?
3. Should the rubric-repair loop in procedure step 9 block progression to
   the next corpus tier, or run in parallel with continued item authoring?
4. How should this protocol's results feed the decision in spec section
   8.5's "whether the six-item grammar should proceed to a 100%-human-
   reviewed shadow prototype" — is that decision made once at
   Locked-Holdout tier, or can Multi-Item Development tier results justify
   narrowing the grammar (e.g., dropping an archetype) before the full
   corpus is built?
