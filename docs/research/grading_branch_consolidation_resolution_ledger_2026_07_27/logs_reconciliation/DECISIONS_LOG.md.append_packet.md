<!-- source: codex/five-subject-harness-and-content@c5f539294c4d -->
## DECISION-0042 — Adopt the AP Biology Depth-Threshold Boundary Policy; Approve `L-001/b` at 1/2; Resolve `L-009/b` at 1/2 (Coaching Contract); Ratify the `L-001/a_i` Variant-Scope Fix

**Date:** 2026-07-17
**Decision Owner:** David Bloom (Product Owner / Final Approver)
**Status:** Approved (Product Owner gate). Curriculum sign-off interface noted below.
**Related:** TASK-0010 (grading calibration); DECISION-0034 (five grading standards; boundary contracts required, §9.1); DECISION-0041 (TASK-0010 on the critical path to any publish); `docs/research/AP_BIOLOGY_CRITERION_BOUNDARY_CONTRACT_SHARPENING_2026_07_17.md`
**Area:** Grading / Criterion-Boundary Contracts / AP Biology

### Context

The AP Biology gold-set candidate (`ap_biology_gold_set_candidate_2026_07_08/`) surfaced a 9-item adjudication queue. A 2026-07-17 pass drafted §9.1 boundary-contract language for each flagged criterion and found that **five of the nine items are the same underlying question**: on a 2-point *describe / explain / trace* criterion, does a response that gives the correct direction/outcome and names the correct actors — but omits a finer mechanistic step the rubric also lists — earn full, partial, or nothing?

### Decision

David Bloom, as Product Owner, makes three calls:

1. **Adopt one governing depth-threshold policy** for all AP Biology "describe/explain/trace" criteria (resolving queue items `L-001/a_i`, `L-009/b`, `L-017/a`, `L-033/b`, `L-033/c` consistently):
   > A required element earns its point when the response **(1) names the correct actor(s)** and **(2) states the correct causal relationship, direction, or outcome** the element tests. Omitting a finer sub-mechanistic intermediate the rubric lists as *enrichment* does **not** void the point. A required element does **not** earn when the response **(a)** states the wrong direction/outcome (fluent, complete, confident wrong answers still earn nothing — model self-reported confidence is not evidence), **(b)** gives only a definitional restatement in place of the required causal link, or **(c)** omits a *distinct required transformation/step* (not merely a finer detail of a step it already has).

2. **Approve the `APBIO-FRQ-L-001 / b` disposition at `partially_earned` (1/2)** — one step up from the AI provisional `not_earned` — on the **independent-element reading**: on a 2-point criterion scored "two of three elements for full credit," one cleanly-correct required element earns 1 pt; a directionally-reversed mechanism (here, reversed proton-pump direction) voids the element it describes but does not retract a separately-correct element.

3. **Ratify the `APBIO-FRQ-L-001 / a_i` variant-scope fix** (executed 2026-07-17): the definitional restatement `"net O2 is zero"` was removed from the criterion's `accepted_variants` and an explicit boundary clause added to `evidence_requirements`, so the definitional phrasing identifies the compensation point but no longer satisfies the required rate-equality explanation.

4. **Resolve `APBIO-FRQ-L-009 / b` at `partially_earned` (1/2)** — Learning Quality (Orly)'s call, closing the last of the four ranked decisions. P1 (process backbone: fixation → nitrification → uptake → assimilation) earns; P2 is withheld. Rationale is product-driven, not only rubric purity: the coaching engine (`grading-feedback.ts` → `highest_value_gap`, ranked by `points_possible / estimated_repair_effort`, surfaced with `minimum_fix` + `predicted_improvement`) is built to push students to their cheapest next point; a whole-pathway response at **1/2** reads as "one specific addition from a point" (the high-leverage repair the ranking prioritizes), while **0/2** makes the same content look like a vaguer rebuild. 1/2 also matches the real modern AP standard (process points generally are not gated on memorized genus names) and still signals incompleteness (not 2/2), preserving coaching pressure.

   **Coaching contract (authored):** the score does not coach — the `minimum_fix` does. Coaching for `L-009/b` **must name both point-2 gaps**: (a) the **nitrate-reduction step** (NO3- → NH4+ in the plant), the point-securing element in either reading; and (b) **organism naming** (Rhizobium, Nitrosomonas/Nitrobacter). Framing of the organism gap follows one factual input — does the operational AP standard require genus names? **If required →** imperative ("you must name…"); **if enrichment →** "naming the organisms strengthens this; the missing point is the nitrate-reduction step" (so students are not sent to memorize genera they do not need). **Working default = enrichment** (moderate-high confidence). The live `minimum_fix` was updated 2026-07-17 to an **enrichment-safe** wording that names both gaps and frames organisms as "strengthen further" without asserting they are optional — correct even if the standard is stricter. The sole residual is Orly confirming whether the target standard requires genera, which flips the wording to imperative (a one-line C2 edit; no score or student-behavior change).

### What this changes

- These become the guard rails the AP Biology adjudicated gold set is scored against. Each encoded contract is a **C2 change** under `CONTENT_GOVERNANCE_AND_VALIDATION.md` §16.3.
- The `L-001/a_i` fix is applied to the four corpus/calibration artifacts that carried the inconsistent variant list (`ap_biology_frq_bootstrap_corpus_2026_07_07.json`, `ap_biology_frq_full_export_2026_07_07.json`, `apbio_frq_tutor_ready_packet.json`, and the candidate package's `provisional_labels.json`).

### What this does NOT change / authorize

- **Does not upgrade the package to `adjudicated_gold`.** Labels remain `calibration` until **two qualified human Grading Validators score blind + a Lead adjudicates** (§12.1). These dispositions are inputs to that human pass, not a substitute for it, and do not by themselves satisfy the DECISION-0041 grading/calibration publish gate.
- **Curriculum sign-off interface:** `L-009/b` was resolved by Learning Quality (Orly) at 1/2 in this same session (see call 4 above); no ranked decision remains open. The sole residual is an emphasis-only coaching confirmation (enrichment vs imperative genus-name wording). If curriculum review later conflicts with any disposition here, it reopens as a C2 revision.
- No Production or Dev change; no other gate lowered; `QA-pass ≠ launch approval` still holds.

### Consequences

- The depth policy applies uniformly: tightening or loosening it later moves all five depth-governed items together, by design.
- Feeds the DECISION-0041 critical path — but only the human dual-blind adjudicated run is the gating artifact.

<!-- source: codex/five-subject-harness-and-content@c5f539294c4d -->
## DECISION-0041 — Accept the DECISION-0039 Consequence: TASK-0010 Grading Calibration Is on the Critical Path to ANY Publish

**Date:** 2026-07-14
**Decision Owner:** David Bloom
**Status:** Approved
**Related:** DECISION-0039 (fail-closed publication repair); TASK-0010 (grading calibration); TASK-0016 (grading engines); AP Statistics 2026-27 rebuild; AP Biology publish gap
**Area:** Governance / Content Publication / Grading

### Context

DECISION-0039 repaired the publication path to be **fail-closed on a full evidence contract** — nothing publishes until verified source, valid rights, approved `review_status`, a passed **grading/calibration** validation run *and* a security/privacy validation run (both targeting the exact content version), a release approval, and policy-version IDs all exist. That decision explicitly left one item **open for explicit acceptance**: the consequence that requiring a passed grading/calibration run puts **TASK-0010 grading calibration on the critical path to ANY publish**.

### Decision

David Bloom **explicitly accepts** that consequence. The fail-closed evidence contract stands as designed; **no interim carve-out or waiver was requested**. Accordingly:

- **No content publishes** — not the AP Statistics 2026-27 rebuild, not any AP Biology draft content, not any other subject — until a passed **TASK-0010 grading/calibration** validation run exists for the exact content version, alongside the other evidence-contract requirements.
- TASK-0010 calibration is therefore a **launch-gating dependency**, not a parallel nice-to-have. It should be resourced and sequenced as such.

### What this changes

- The AP Statistics rebuild and the AP Biology publish gap are both **blocked on TASK-0010 calibration** (in addition to their own content/QA gates). The push-button AP Statistics calibration harness built 2026-07-14 (`scripts/grading-model-assessment/calibrate-ap-statistics.ts`) becomes authoritative only once **human dual-blind adjudicated gold** and **real grader captures** replace the provisional inputs — that adjudicated run is the gating artifact.

### What this does NOT change / authorize

- No change to the fail-closed design itself (already decided in DECISION-0039).
- Does not lower any other gate; `QA-pass ≠ launch approval` still holds.
- No Production or Dev change is authorized by this record; it is a governance acceptance only.

### Consequences

- DECISION-0039's "Noted consequence — open for explicit acceptance" is **resolved: Accepted (2026-07-14)**.
- TASK-0010 moves onto the critical path for all publication.

<!-- source: codex/five-subject-harness-and-content@c5f539294c4d -->
## DECISION-0037 — Open TASK-0017 (Subject-Onboarding Harness); Publication-Trust P0 Repair; Gate-Waivability, Canonical-Record, and School-Year Policy

**Date:** 2026-07-13
**Decision Owner:** David Bloom
**Status:** Approved (task opened; design approval still required before Dev migrations)
**Related Task:** TASK-0017 (new), relates to TASK-0016, TASK-0014/0015, TASK-0009, `DECISION-0036`, `DECISION-0035`, `DECISION-0034`
**Area:** Architecture / Content Governance / Publication Trust

### Context

Following the AI-led content-authoring shift (`DECISION-0036`), the dominant repeat-work cost for launching a new subject (or a new annual exam version) is the hand-built per-subject machinery: schema/taxonomy instantiation, ingestion/staging, deterministic verification, reviewer qualification, and publication gating. Codex reviewed the proposed reusable-harness prompt and returned a detailed set of required structural revisions plus a verified P0 publication-trust defect. David resolved the open decisions.

### Decision

1. **Open TASK-0017 — Reusable Subject-Onboarding Harness** as a Hard-Gate task, design-approval-first (`docs/tasks/TASK-0017-SUBJECT-ONBOARDING-HARNESS.md`). Implementation is Codex's lane; content authoring stays Claude's (`DECISION-0036`); calibration stays Claude + Learning Quality.
2. **Publication-trust P0 repair, first.** `admin-content` `changeArtifactState` flips `content_items`/`content_item_versions` to `published` before validating the release manifest and gates, non-atomically — a rejected publish can leave content served/gradeable (verified 2026-07-13, `supabase/functions/admin-content/index.ts` ≈ lines 638–660 vs 663–714). Repair: compute eligibility server-side from authoritative evidence, apply state/serving/manifest/release atomically with rollback, prove reviewed-version == activated-version, add a regression test.
3. **Gate-waivability policy:** publication eligibility is evidence-derived. A Product Owner may waive **content-clearance only** (tutor/content review — consistent with `DECISION-0035`) with a recorded exception. **Grading/calibration, rights, and security/privacy gates are never waivable.**
4. **Canonical question-version record (v1) = `content_item_versions.id`** (serving, review, attempts, grading, release manifests all reference it). `artifact_versions` (0 rows in Production) is not resurrected as a parallel canonical record; any consolidation is `TASK-0009`'s call.
5. **Canonical school-year identifier uses academic-year form (`YYYY-YY`) derived from the official exam date.** A legacy `"2026"` row with a May 2026 exam becomes `2025-26`; a May 2027 exam becomes `2026-27`; do not blanket-map `"2026"`.
6. **AP Chemistry (TASK-0014) / AP Physics (TASK-0015)** adopt the harness once ready; no net-new bespoke scaffolding for them in the meantime (not paused, no new one-offs).
7. **Harness supports both** `create-subject` and `create-exam-pack-version` (annual revision preserving historical taxonomy/labels/content/attempts/calibration).
8. **Deprecate the legacy manifest name.** `exam_pack_manifests.artifact_version_ids` is not the durable canonical name for v1 content-version manifests. H0/H1 must design a correctly named, typed replacement and backward-compatible migration; the legacy field may remain only as a temporary P0 carrier.
9. **Typed validation-suite registry.** Replace unconstrained suite-category text with a typed/versioned registry, including `security_privacy` as a first-class publication-gate category.
10. **Typed content-clearance exceptions.** H5 must introduce a dedicated immutable record with scope, Product Owner approval, rationale/evidence, effective/expiry bounds, and revocation/supersession. It can waive content clearance only; grading/calibration, rights, and security/privacy remain non-waivable.
11. **Schema authority split:** TASK-0017 does not supersede TASK-0009. TASK-0017 supplies approved v1 consumer constraints; TASK-0009 retains conceptual schema/governance authority and must ratify and incorporate them before related physical DDL.
12. **Chemistry fixture scope:** AC4 tests reconciliation of the existing AP Chemistry subject/exam-pack/taxonomy scaffold. AP Chemistry content is not authorized for publication.
13. **August pilot release intent:** human-verified AP Biology and AP Statistics content is authorized for the August pilot with live checking/monitoring. The content is AI-generated and treated as Cramapple-authored candidate material, subject to the recorded human verification and evidence requirements.
14. **No gate fiction:** the August authorization does not mark P0 verified, manufacture source/rights/security/grading evidence, or waive non-waivable gates. Release execution follows only after the required database tests and authoritative records are complete.

### Rationale

The harness removes the fixed per-subject engineering cost so future subjects are config-and-content drops. The P0 must precede any automation built on the publish path, or the harness would industrialize an unsound gate. Waivability mirrors `DECISION-0035` (content review waivable) while hard-protecting grading/rights/security. `content_item_versions` is already the de-facto canonical record; formalizing it avoids magnifying today's drift.

### Consequences / guardrails

- **Design approval before any Dev migration**; Dev migrations separately approved; Production is a distinct Hard-Gate review (migration + rollback + evidence). Dev-first (`wmgjsdkphcyhngaffbqf`); no Production schema change without a recorded approval ID.
- Harness makes subjects fast to **stand up**, never fast to **publish** — content/grading/publication gates remain hard stops (H5 proves eligibility from authoritative records).
- Config never executes arbitrary code (declarative checks + reviewed plugins). Reviewer *people* stay out of reusable configs.
- Gold-set/calibration tooling and frontend implementation remain out of scope; the harness only emits calibration status and a Lovable UI-capability handoff.
- The three design directions in items 8–10 are approved. Their schema implementation and any Dev/Production application still require the task's design, migration, QA, and environment approval gates.
- AP Biology/AP Statistics August release intent is approved, but publication execution remains a separate evidence-backed operation. AP Chemistry is explicitly excluded.
- This opens the task and records the policy calls; it does not approve the harness design, any migration, or any Production change — those are later gates.

### Update 2026-07-13 — AP Statistics tutor owns the review chain

David reassigned the AP Statistics review chain to the qualified subject tutor: the tutor (1) reviews/approves the **fact pack** (G0A — was Orly's confirmation under this decision's Q7), then (2) reviews **content** against the approved fact pack (G4A), then (3) reviews **grading & repair** once content is **released to the tutor**. Clarified: "released" = handed to the tutor for review, **not** a student-facing publish — so the non-waivable grading-calibration gate (G4B) is unchanged and all three tutor reviews occur before any student sees content. Orly remains Curriculum Owner. Reflected in `AP_STATISTICS_2027_CONTENT_REBUILD_ORCHESTRATION.md` (gate table + responsibilities) and `AP_STATISTICS_2027_CED_FACT_PACK.md` (status/reviewer).

<!-- source: codex/five-subject-harness-and-content@c5f539294c4d -->
## DECISION-0038 — Approve TASK-0009 Schema-Governance Reconciliation Scope (with conditions)

**Date:** 2026-07-13
**Decision Owner:** David Bloom
**Status:** Approved — scope only (conceptual model returns for final Hard-Gate approval before DDL)
**Related Task:** TASK-0009; relates to TASK-0017, `DECISION-0037`
**Area:** Architecture / Content Governance

### Context

TASK-0009 (Schema and Governance Reconciliation) is a conceptual-model task — translate the approved governance contracts into a coherent data model before any physical Postgres/RLS design. It contains no DDL to approve yet; the deliverable is the model + a gap/contradiction report. Reviewed at David's request; it overlaps the canonical-record and manifest decisions made in `DECISION-0037`/`TASK-0017`.

### Decision

Approve the **scope/approach to proceed**, with two binding conditions. The actual conceptual model + gap report return for the final Hard-Gate approval before any DDL.

1. **Directional canonical-identity reconciliation.** The "stable identity + immutable version" concept must map onto the existing `content_items`/`content_item_versions` records (v1 canonical per `DECISION-0037`). The model must not resurrect `artifact_versions` (0 rows in Production) as a parallel canonical record; conflicts return an explicit compatibility/migration decision to TASK-0017. Added as a named acceptance criterion.
2. **Fast-track the two slices TASK-0017 H1/H2 depend on** — immutable item-package/archetype identity and multi-scheme taxonomy per `exam_pack_version` — so this task does not become the long-pole blocker on the August AP Statistics rebuild's staging path.

### Rationale

The scope is at the right altitude (model before DDL), its invariants are correct (immutable versioned payloads, append-only reviews/state, projections separated from authoritative evidence), and its Authority Boundary section already arbitrates the TASK-0017 overlap correctly. The two conditions prevent the one real drift risk (a resurrected parallel canonical record) and the one real schedule risk (a comprehensive model exercise blocking the narrow schema the rebuild needs).

### Consequences

- TASK-0009 status → "Approved with conditions — conceptual-model deliverable pending." Approval State records scope approval; the model deliverable remains Pending for the final Hard-Gate.
- TASK-0017 H1/H2 DDL remains gated on TASK-0009 ratifying the relevant slices; Condition 2 keeps that from stalling August.
- This approves scope, not the model; it does not authorize any DDL, migration, or physical design.

<!-- source: codex/five-subject-harness-and-content@c5f539294c4d -->
## DECISION-0040 — Ratify TASK-0009 Fast-Track Conceptual Slices (H1 item-package/archetype identity; H2 multi-scheme taxonomy)

**Date:** 2026-07-13
**Decision Owner:** David Bloom
**Status:** Approved
**Related Task:** TASK-0009; unblocks the `DECISION-0039`-endorsed designs and TASK-0017 H1/H2
**Area:** Architecture / Content Governance

### Context

`DECISION-0038` approved TASK-0009 scope and directed a fast-track of the two conceptual slices TASK-0017 H1/H2 depend on; `DECISION-0039` endorsed the delivered designs but routed them "through TASK-0009 M0 ratification + a separate additive migration approval." That ratification was the remaining Pending gate.

### Decision

Ratify the two TASK-0009 fast-track **conceptual** slices as delivered in the TASK-0017 H0/H1 design packet:
1. **Immutable item-package / archetype identity**, mapped onto the canonical `content_items` / `content_item_versions` records (no resurrected `artifact_versions` parallel record — `DECISION-0038` Condition 1 preserved).
2. **Multi-scheme taxonomy per `exam_pack_version`** (historical schemes preserved; annual revision coexists with the prior pack).

This satisfies the "TASK-0009 M0 ratification" precondition in `DECISION-0038`/`0039`.

### What this unblocks

- Codex may now produce the **physical H1/H2 design** (DDL/migrations) and the manifest-relation / validation-registry / exception schema — the `DECISION-0039`-endorsed designs may proceed to physical design.
- Satisfies the ratification half of TASK-0017's next checkpoint.

### What this does NOT approve (still separate gates)

- The **produced physical H1/H2 design** returns for its own Hard-Gate design/migration review before any environment.
- A **separate Dev execution approval ID** is still required before applying ANY migration to Dev — **not issued here** (David to provide when ready).
- The P0 SQL regression tests must **re-run green in the Dev execution packet** (verification, separate from authorization).
- No Production change; the full TASK-0009 conceptual model + gap report still return for the final Hard-Gate.

### Consequences

- TASK-0009: fast-track slice ratification → Approved (2026-07-13); full model deliverable still Pending.
- TASK-0017: ratification checkpoint met; physical H1/H2 design may proceed; Dev application still gated on a separate approval ID.

### Product Owner execution clarification — 2026-07-13

David Bloom subsequently clarified DECISION-0040's repository-execution boundary: Codex is approved to build the H1/H2 physical design and additive migration artifacts, the compiler/persistence layer, and H3–H5 in the repository, and to verify them locally. This clarification supersedes the narrower wording above that limited the next step to producing a design packet only.

The environment boundary is unchanged: no migration or function may be applied to Dev without a separate Dev execution approval ID, and no Production migration, deployment, configuration change, or publication is authorized. The completed repository implementation and local evidence return for Hard-Gate review before environment execution.

<!-- source: codex/five-subject-harness-and-content@c5f539294c4d -->
## DECISION-0034 — Adopt Five Grading Standards (Boundary Contracts, Gold-Set Depth, Deterministic Layer, Feedback-Quality Evaluation, Single-Grader Default)

**Date:** 2026-07-08
**Decision Owner:** David Bloom
**Status:** Approved
**Related Task:** TASK-0010, TASK-0005
**Area:** Architecture

### Context

A second-opinion assessment of Cramapple's grading approach reviewed the vision,
the research canonical process and reporting standard, the governance/calibration
gates, and the actual experimental evidence across AP Biology (the deep FRQ02
investigation), AP Statistics, and AP Chemistry. The strongest, most-repeated
finding across every isolated test was that rubric-boundary precision — not model
size, routing, escalation, exemplar retrieval, or flywheel volume — is the
dominant grading-quality lever, yet that finding lived only in scattered research
reports. Related findings: deterministic zero-cost checks catch error classes
model confidence cannot; feedback quality (the product's actual promise) was not
being measured; and the only decision-grade evidence was a single question
against a provisional corpus with suspected label defects.

### Decision

Adopt five standards for the grading program and record them in the durable docs:

1. The **criterion-boundary contract is a required, authored artifact** for every
   FRQ criterion, authored with the rubric and sharpened (not invented) during
   calibration. A criterion without one is an incomplete package that cannot
   enter validation.
2. **Redirect research effort from breadth to depth** — one fully-adjudicated AP
   Biology gold set before further synthetic breadth corpora; corpora carry an
   explicit tier label and only adjudicated/held-out evidence may support quality
   claims.
3. Ship a **required per-subject deterministic-check layer**, declared in a
   `verification_profile`, run independently of the model and version-pinned to
   the grading result.
4. **Measure feedback quality** — grounding, minimum-fix sufficiency, and
   error-classification accuracy — in every grading experiment, not only the
   criterion earned/not-earned decision.
5. Make the **single fast grader + boundary contract + deterministic checks the
   default runtime**; retire confidence-triggered escalation, fallback ensembles,
   and reference layers from the default; use multiple models only as boundary
   auditors.

This decision changes documentation and standing research/engineering direction.
It does not by itself approve any content for launch, close TASK-0010, accept
quality risk, or ratify the numeric §12.3 release thresholds (still to be tested
against the first real adjudicated gold set).

### Rationale

The evidence base is cited in `docs/research/grading_cross_subject_takeaways.md`
(the new durable home for these lessons). Several of these concepts already
existed in partial form in the docs (§9 named boundary contracts as "preferred";
§12.3 already carried feedback thresholds; §7 listed deterministic checks); this
decision elevates them to required and wires the research evaluation layer to the
governance requirements so the lessons stop being re-derived.

### Consequences

- Docs updated: `CONTENT_AUTHORING_AND_PROMPT_ARCHITECTURE.md` (§7.1, §7.2, §9.1;
  Last Updated bumped), `CONTENT_GOVERNANCE_AND_VALIDATION.md` (v0.2, §10.5),
  `TASK-0010` (adopted-standard section + acceptance criteria),
  `GRADING_RESEARCH_CANONICAL_PROCESS.md` (standing direction, corpus tiers,
  feedback evaluation), `grading_packet_backlog_2026_07_07.md` (superseding
  depth-first priority).
- New artifacts: `docs/research/grading_cross_subject_takeaways.md` and
  `docs/research/AP_BIOLOGY_VERIFICATION_PROFILE.json`.
- The boundary contract becomes a blocking FRQ package element; existing
  candidate FRQs without one are incomplete until it is added.

### Risks / Follow-ups

- The FRQ02-derived lessons need replication on other criteria and a second
  subject before being treated as fully general (assessment next-experiment #1).
- The §12.3 thresholds may prove infeasible; that is tested by follow-up #2 (one
  adjudicated gold set), which is now the top research priority.
- Grading tail-latency (escalation's 8-11s outliers vs. the brand-critical
  exam-week window) remains an open product decision, not resolved here.
- Index note: this entry is DECISION-0034 on branch
  `claude/ap-statistics-mcq-short-frq-prompts`; if another branch also claims
  0034, renumber whichever merges second and update the index.

<!-- source: codex/five-subject-harness-and-content@c5f539294c4d -->
## DECISION-0033 — Publish and Publicly Expose Unreviewed AP Statistics Content for Feedback and Tutor Recruiting

**Date:** 2026-07-01 through 2026-07-03
**Decision Owner:** David Bloom
**Status:** Approved
**Related Task:** TASK-0013
**Area:** Content Governance / Product

### Context

`TASK-0013` Phase 4's authoring brief (`docs/product/AP_STATISTICS_PHASE4_CONTENT_AUTHORING_BRIEF.md`)
states pilot content gets "the same originality, scientific/statistical,
and teaching/grading gates Biology content goes through — no shortcut for
being 'just a pilot.'" As of 2026-07-01, 48 AP Statistics items (18
Claude-generated MCQs, 18 David-supplied short FRQs, 12 Codex-generated
hand-drawn graph-response FRQs) existed with zero tutor/reader review and
zero formal rights-clearance record (`content_item_versions.review_status`
null on all items; no `app.rights_records` row for any of them). This
decision retroactively records three related, previously chat-only
instructions as durable governance, per `feedback_governance`'s "chat-only
decisions don't count" rule.

### Decision

1. **Publish despite no tutor review (2026-07-01).** David instructed
   directly: "fix the errors and publish." 36 of the 48 items (the MCQ and
   short-FRQ smoke batch) were promoted from `content_ingest_rows` staging
   into the live `content_items`/`content_item_versions` tables
   (`status = 'published'`), after two confirmed computational errors were
   found and fixed by independent recomputation (see
   `docs/research/ap_statistics_phase4_mcq_smoke_batch_2026_07_01/README.md`).
   `content_item_versions.review_status` was deliberately left `NULL`
   rather than fabricated, and no `app.release_candidates`/`rights_gate`
   assertion was written, since neither was true. The remaining 12
   hand-drawn graph-response items were staged only (per explicit
   instruction that tutors would review those before publish) and remain
   in `content_ingest_rows`, not yet promoted.
2. **Rights/originality clearance is not a blocking concern for this
   content (2026-07-03 clarification).** David: "Rights/originality
   clearance is not an issue. By rule we are not using College Board
   questions." This restates, rather than reopens, the rights posture
   already settled in `DECISION-0031` ("no official CollegeBoard material
   as model input or exemplar") and the general policy in
   `CONTENT_GOVERNANCE_AND_VALIDATION.md`: because all AP Statistics
   content is independently authored synthetic material by construction,
   not derived from copyrighted CollegeBoard exam content, the
   infringement risk the formal `rights_records`/`rights_gate` process
   exists to catch does not apply here. This does **not** mean the formal
   DB-level rights gate has been run (it hasn't, and the `content_gate`
   comment in `supabase/functions/admin-content/index.ts:156-186` about
   client-asserted-but-unverified gates still stands as a real system gap)
   — it means the underlying risk is judged not present for this specific
   content by policy, so the absence of that DB record is not itself a
   blocker.
3. **Show it as live/selectable on the public site despite no review
   (2026-07-03).** David: "we are showing cramapple to students and tutors
   and so need the site to look live even though payment is not live and
   tutors and readers have not reviewed. this is necessary for user
   feedback and tutor recruiting." This authorizes
   `prompts/LOVABLE_SIGNUP_DYNAMIC_SUBJECTS.md`'s design: AP Statistics
   renders as "Available" (not "Coming Soon") on `/signup`, selectable by
   real external users, specifically because real payment processing is
   not currently live site-wide (no financial exposure) and because
   showing it to tutors is part of how it gets reviewed. This is a
   deliberate, scoped exception — it does not authorize marketing AP
   Statistics as launch-ready, does not authorize enabling real payment
   for it, and does not extend to any other unreviewed subject without a
   separate decision.

### Rationale

Cramapple's stated near-term need (per this decision) is user feedback and
tutor recruiting, not a commercial AP Statistics launch. With payment not
live, the actual risk surface of showing unreviewed content is bounded —
no student can be charged for it, and the tutors seeing it are exactly the
population meant to review it. The rights concern is resolved by the
project's standing no-official-material authoring policy, not by this
decision creating a new exception.

### Consequences

- AP Statistics MCQ/short-FRQ content (36 items) is live and gradeable in
  Production without tutor review. The 12 hand-drawn graph-response items
  remain staged, not published, pending tutor review as originally
  instructed.
- `/signup` may render AP Statistics as purchasable-looking even though no
  real purchase should be expected to complete meaningfully differently
  from Biology's current (possibly also non-live) payment state — see the
  open question this raises about Biology's own `evaluate-attempt` publish
  gate, tracked separately, not resolved by this decision.
- This decision does **not** constitute a Done decision, a QA pass, or a
  production launch approval for AP Statistics per `feedback_governance`'s
  Definition of Done — tutor review, rights-gate formalization (if ever
  desired), and a genuine launch-readiness review remain separate, future
  decisions.
- Test reviewer accounts (`tutor-a`, `tutor-b`, `reader-a`,
  `admin@cramapple-test.internal`) were disabled (`auth.users.banned_until`
  set to 2099, not deleted — deletion was blocked by real historical
  `content_review_assignments`/`content_review_decisions` rows that would
  have cascade-deleted) ahead of real tutors being recruited under this
  decision.
