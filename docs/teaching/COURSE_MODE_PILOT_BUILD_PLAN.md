# Course Mode — Stats Pilot Build Plan

STATUS: v0.2 — PARTIALLY EXECUTED 2026-08-23. Fable round 2: GO-WITH-CONDITIONS; D1 approved (template release + spot-audit), D2 resolved (David reviewer of record). **Live status/handoff: see `COURSE_MODE_STATUS_AND_HANDOFF.md`.** DONE + verified: F1 (skill/cell registry in Dev), Track A generator (5 procedures, Fable GO), Track B 4.B slot-frame, and the 4-table Dev↔Prod convergence. NOT built: student experience/front-end, F2/F3 learner-state runtime, F4 servable-content path, scale seed content. scipy APPROVED (t/χ² procedures not yet built). D8 release bars RATIFIED 2026-08-25 (see D8). | DATE: 2026-08-22 (updated 2026-08-23)
AUDIENCE: LLM-first. Governed by `COURSE_MODE_LEARNING_MODEL.md` (decisions `CM-Dxx`, invariants `INV-x`, current-state facts `CM-FACT-20`). This plan implements the pilot: AP Statistics, supply-engine first.

CHANGELOG v0.2 (Fable review): removed CED-deleted content from the toolkit; added the "generated-instance → database" path (F4) as a first-class section — this is the pivotal gap; corrected cell seeding to per-LO (~130 cells, fact pack §3); shrank F1 (taxonomy already seeded, no CHECK relax, DB-registry only, UUID keying); specced the evidence-weight classifier and the session-null routing fix in F3/F2; added the template-level release mechanism, SME gate, and cell/taxonomy versioning to §7; noted gold-corpus is grader-regression-only; refined Track B (exclude 4.E, n=1 caveat).

## 0. Goal and non-goals

GOAL: Prove the content SUPPLY engine on AP Statistics, and the backend that lets generated items land as cell-tagged, gradeable, servable content and update cell-grain mastery — enough to retire the two biggest risks: (1) can a computational procedure library × scenario × form produce validated, near-unlimited Stats items that flow all the way to a graded cell update; (2) can an authored Practice-4 slot-frame cover conceptual/interpretation content at quality (CM-FACT-19, the load-bearing unknown).

NON-GOALS (explicitly out of scope):
- The student experience / session assembly / progress surface (deferred).
- Phase-2 graph triggers (prereq, thread-sibling) and the CED principle graph (INV-2, CM-D12).
- Other subjects; science item→topic backfill.
- General LLM item generation (PROHIBITED, INV-3).
- Ripping out the cram product's live subject-grain memory; we ADD a cell store beside it.
- Migrating/mapping the 90+ legacy DB Stats items into cells (they use an old namespace; explicitly EXCLUDED from cells for the pilot — see D6 in §7).

## 1. Shared foundation

F1 — Stats skill taxonomy + cell registry. STATUS: scope shrunk v0.2.
The `app.taxonomy_topics` registry for `ap_statistics` (55 topics) ALREADY EXISTS (`20260821090000_ap_statistics_taxonomy_topics_seed.sql`) — do NOT re-seed topics. Remaining work:
  - Add a `skill` layer (Practices 1–4; skills 1.A, 2.A–2.E, 3.A–3.E, 4.A–4.G) as a new table/column keyed by `taxonomy_source_version` uuid — NOT in `topic_code` (its CHECK forbids letter codes; leave the CHECK alone).
  - Cell registry: valid `(topic, skill)` cells seeded from the CED per-LO anchoring in `AP_STATISTICS_2027_CED_FACT_PACK.md` §3 (~130 cells, 1–4 skills/topic). Do NOT use a one-cell-per-topic spine.
  - Key everything by UUID (`subject_id`, `taxonomy_source_version`), never raw `subject_key` (hyphen vs underscore namespace trap; CM-FACT-20).
  - No `content/subject-packages/ap-statistics` file is required (math subjects have none either); do DB-registry only.
  Dependency: the §3 anchoring has DEFERRED SME (Jill) sign-off — see §7 D2.
  Acceptance: every Stats topic maps to its CED-anchored skill(s); practice→skill counts = P1:1, P2:5, P3:5, P4:7; all cell keys resolve by UUID.

F2 — Cell mastery store (schema). Additive to `app.*`.
  - `student_cell_state`: `user_id`, `subject_id` (uuid), `taxonomy_source_version` (uuid), `topic_code`, `skill_code`, `tier` (enum: unseen/exposed_unverified/supported/independent/confirmed), `fragile bool`, `weighted_evidence numeric`, `last_independent_success_at`, `next_due_at`, `due_reason`, versioned.
  - Evidence write path: extend the post-grade side effect to ALSO route each attempt's outcome to the cell(s) the item is tagged to via the item→cell tag (F4). Route on ATTEMPT/ITEM identity (`content_item_version_id`), NOT session presence — the current `persistGradingMemory` bails when `sessionId` is null (`_shared/grading-memory.ts:49-51`) and isn't passed the item version; extend all three call sites (`evaluate-attempt/index.ts:1142,1644`; `attempt-response/index.ts:997`). Pilot items are single-skill → item maps to exactly one cell; no criterion→skill attribution needed yet.
  Acceptance: a graded Stats attempt (including a sessionless/manual one) updates exactly one cell per the F3 rule engine; subject-grain memory unchanged.

F3 — Deterministic evidence-weight classifier + tier/trigger rule engine (Phase 1). INV-4.
  - Evidence-weight classifier: pure function `(attempt, prior cell history, item/template+params identity, session identity, assistance state) → weight ∈ {1.0, 0.65, 0.35, 0}` (CM-D07).
  - Tier/trigger rule table: pure function `(current tier, event, weight, timestamps) → (new tier, next_due_at, due_reason)` implementing decay clock, direct miss (→ fragile/reopen, INV-6), provisional-success confirm (INV-5), new-exposure consolidation (from `student_course_positions`). Bounded default constants, marked tunable.
  Pin two classifier rules: (a) "changed surface" = same template + DIFFERENT params (same params = not changed); (b) "same-session" (0.65 vs 1.0) for the sessionless attempts F2 supports is judged by a time-window rule, since session identity is null there.
  Acceptance: exhaustive unit tests over (tier × event × weight); no model inference (INV-4); Phase-2 triggers not implemented (interfaces left open).

F4 — Generated-instance → database path. STATUS: NEW in v0.2; the pivotal enabler (CM-FACT-20). Without this, Track A cannot reach its acceptance criterion.
  - Persist per-instance deterministic checks: add a checks column/table so the emitted `deterministic_checks` survive DB load (today they are dropped).
  - Generic data-driven verifier: add a new `evaluator_strategy` (current allowlist has no data-driven numeric path; production Stats uses a hardcoded per-`content_key` map in `_shared/statistics-verifier.ts`). The verifier reads the persisted checks and grades any generated instance without per-item code.
  - Item→cell tag: create the mapping the DB lacks — new `content_taxonomy_labels` scope `cell`, or a `content_item_cells` table — written at intake/emission; declare which side is authoritative (proposed: emission-time, from the generator, validated at intake).
  - Template-level release mechanism (D1 in §7; CM-D19, PROPOSED): approved template machine-stamps each conforming instance's `review_status` (approved) and serving/cell labels, recording template id + params as provenance. Needed because publish/serving gates today require per-instance human `validated`/approved and no MCQ can reach approved via code.
  - Prior art / collision check: a dropped Dev-only harness (TASK-0017: `deterministic_check_types`, `verifier_plugins`, `content_version_taxonomy_assignments`, `item_archetypes`; migration 20260821120000; restorable from `archive/codex-five-subject-20260727`) covered this territory — mine it for design, but do NOT collide with TASK-0027's schema-convergence disposition matrix on names.
  Acceptance: one generated instance flows end-to-end — emitted → checks persisted → cell-tagged → graded by the generic verifier → updates a cell — with NO per-instance human step, under an approved template.

## 2. Track A — Computational spine (CM-D15) + backend integration

A1 — Procedure library. Deterministic generators, each `params → (stimulus, question, correct answer, worked solution, deterministic_checks)`, for the 2026-27-VALID toolkit only:
  - one/two-sample z procedures for PROPORTIONS and t procedures for MEANS (CED convention: z for proportions, t for means); χ² tests for INDEPENDENCE/HOMOGENEITY only; CI / significance-test / p-value machinery; sampling distributions; normal-distribution + probability calculations; descriptive regression (r, slope, intercept are computed BY TECHNOLOGY per the CED — generate predict / residual / interpret tasks, never hand-compute-r-from-raw-data).
  - EXCLUDED (removed from 2026-27; fact pack §8): χ² goodness-of-fit; regression/slope inference (old Unit 9); geometric distribution; combining random variables; departures-from-linearity framing.
  - Each procedure declares which cell(s) it can populate (provisionally from fact pack §3 until F1 lands).
  Acceptance: every procedure maps to ≥1 cell in the 2026-27 registry; zero removed-content procedures.
A2 — Parameter guardrails (the real difficulty). Per-procedure constraint/rejection sampling guaranteeing validity (expected counts ≥ 5; sufficient n; clean-or-intentionally-messy numbers; sensible rounding). Include a "conditions deliberately violated" mode (covers much of skill 4.E — verify conditions).
A3 — Scenario layer. Curated, realistic context banks per procedure (authored, reviewable).
A4 — Question-form layer. MCQ, numeric-entry, short-response renderers over a generated instance.
A5 — Misconception-transform distractors. Distractor engine applying known Stats error transforms, each distractor tagged with the misconception it encodes. Sourcing: reuse the per-topic misconception catalog already compiled in `AP_STATISTICS_2027_CED_FACT_PACK.md` §10 (2025 Chief Reader Report-sourced) — materially cheaper than manual CED-prose extraction — BUT §10 is UNREVIEWED under the same D2 SME gate, so treat it as candidate until signed off.
A6 — Item-package emission. Emit instances into `content/item-packages/ap-statistics/…` with `taxonomy_refs` (unit, topic, skill), `deterministic_checks` per criterion, template id + params provenance; feed F4 so tags/checks/cell mapping persist to the DB.
A7 — Template validation gate (CM-D17). Per-procedure: human review of the template + a sample of instances; property tests over the param space (independent recompute; conditions hold; ranges valid); grader-behavior regression against the Stats gold corpus (NOTE: old-namespace — regression only, not coverage). Release = template passes → machine-stamp instances (F4/D1).
  Acceptance (Track A): ≥3 procedures released end-to-end through F4 (generate → checks persisted → cell-tagged → generic verifier grades → cell updates), producing dozens of validated instances per covered cell, with no per-instance human step.

## 3. Track B — Practice-4 slot-frame prototype (CM-D16, CM-FACT-19)

B1 — Choose one high-value Practice-4 interpretation skill NOT reachable by computation — e.g. 4.B ("justify a claim based on statistical calculations and results") or 4.G ("justify a claim based on inference results"). EXCLUDE 4.E (verify-conditions), which Track A's "conditions violated" mode covers.
B2 — Author the slot-frame: validated frame + slot pools (context, variable, provided result, correct interpretation, misconception-interpretation distractors). Correctness from validated slot-pairings, not generation (INV-3). Prefer a misconception-taxonomy MCQ form (checkable); optionally a short-response form graded by the pipeline with an authored rubric.
B3 — Instance generation; verify validity across slot combinations.
B4 — Validation: human review of frame + sampled instances; grader-behavior regression against gold exemplars (old-namespace caveat).
  Acceptance (Track B): one released Practice-4 slot-frame producing multiple valid instances, WITH a written estimate of authoring cost per frame and projected coverage of Practice 4's 7 skills → go/no-go input for scaling conceptual. Note n=1 limitation; if budget permits, add a second small frame in a different P4 family (e.g. 4.F) so the scaling estimate isn't a single point.

## 4. Sequencing and dependencies

- F1 → (F2, F3, F4, A6, B1). Skill taxonomy + cell registry unblock the tagging/routing.
- A1–A5 may start pre-F1 using provisional cell vocabulary from fact pack §3; A6/A7 require F1 + F4.
- Track A and Track B run IN PARALLEL after F1 (David's directive). A does not block B.
- F4 is on Track A's critical path AND gates Track B's "released" acceptance (both need F4 + the D1 release-mechanism sign-off to release an instance).
- Recommended order: F1 → then split — (F2, F3, F4) backend and (A1→A2→A3→A4→A5→A6→A7) and (B1→B2→B3→B4) concurrently; converge at "generated item updates a cell."

## 5. Validation / definition of done for the pilot

- Computational: ≥3 procedures released through F4, dozens of validated instances per covered cell, graded by the generic data-driven verifier, updating cell state deterministically, no per-instance human step.
- Conceptual: ≥1 Practice-4 slot-frame released, with a written authoring-cost-per-frame estimate and projected P4 coverage → go/no-go for scaling conceptual.
- Backend: cell store + evidence-weight classifier + Phase-1 rule engine + F4 path live in Dev; subject-grain memory unaffected; cell writes fire on sessionless grades; unit tests green over the classifier + rule table.
- Governance: no un-checkable content shipped (INV-3); generated items served only under an approved template (D1); SME disposition (D2) honored.

## 6. Key risks

- R1 (highest, CM-FACT-19): Practice-4 slot-frames may be too costly per frame to cover the conceptual majority → Track B is deliberately early to surface this.
- R2 (F4 / CM-FACT-20): the generated-instance→DB path is net-new plumbing (persisted checks, generic verifier, item→cell tag, template release) and gated on a governance change (D1); underestimating it blocks Track A's acceptance. Mitigation: F4 first-class, on the critical path.
- R3: Parameter guardrails (A2) are the true difficulty of the spine → property tests + gold-set behavior regression.
- R4: Cell store beside legacy subject-grain memory risks dual-source drift → subject memory read-only-compatible; cell store authoritative for cell decisions only; legacy DB Stats items excluded from cells.
- R5: Constants (weights, intervals) are guesses → bounded defaults, instrumented; not correctness-critical (CM-D13).

## 7. Decisions still needed before build

D1 — Template-level release mechanism (CM-D19). PROPOSED: human approves template + validation sample; pipeline machine-stamps conforming instances' review/serving/cell labels with provenance. Optional mitigation to make the invariant change easier to accept: an ongoing sampled spot-audit of served generated instances (n per template per period). Changes the per-instance-human review invariant. APPROVED 2026-08-23 (David); sampled spot-audit adopted. (Pivotal — Track A acceptance depends on it.)
D2 — SME (Jill) gate on §3 skill anchoring (deferred). IMPORTANT — this is not merely a serving-vs-release choice; it AMENDS an approved condition. `AP_STATISTICS_2027_CED_FACT_PACK.md` §3/§9-item-2 states Jill's confirmation must land BEFORE bulk Statistics authoring keys items off these tags, and the deferral's justification was that blast radius is zero UNTIL bulk authoring begins. This pilot IS bulk authoring keyed off those tags, so proceeding consciously supersedes that precondition (and fact pack §10, which A5 wants to reuse, is UNREVIEWED under the same gate). RESOLVED 2026-08-23: David is the reviewer/SME of record for the pilot and will confirm with Jill as necessary; the fact-pack §3/§9 amendment is made consciously by David. Build proceeds; student-facing serving is under David's review authority.
D3 — Item→cell tag home. PROPOSED: new `content_taxonomy_labels` scope `cell` (vs. a `content_item_cells` table); emission-time authoritative, validated at intake. (Technical; David to confirm/defer to build.)
D4 — Deterministic-check persistence + generic verifier strategy. PROPOSED: persist checks in the authoritative governance criterion model OR a NEW `content_item_checks` table keyed by (`content_item_version_id`, `criterion_key`) — NOT `app.frq_criteria` (a deprecated compatibility projection, schema_baseline.sql:2224); add a new data-driven `evaluator_strategy` that reads the persisted checks. (Technical; confirm.)
D5 — Cell/taxonomy versioning. PROPOSED: cell identity scoped to `taxonomy_source_version`; legacy DB Stats items EXCLUDED from cells. (Confirm.)
D6 — Subject-key normalization. DECIDED (from CM-FACT-20): key all joins by UUID; never raw subject_key.
D7 — Track B target skill (B1): 4.B or 4.G. David/reviewer to pick.
D8 — Release bars for A7/B4 (sample sizes, property-test coverage, gold regression thresholds). **RATIFIED 2026-08-25 (David), as proposed:** validation n=20/template; coverage ≥100/proc & ≥120/frame at 0 rejects + full context/tag coverage; gold-regression = 0 behavior-drift; ongoing spot-audit 5/template/30d; Gate-2 re-derivation (0 defects) added as a bar. Details: `COURSE_MODE_D8_RELEASE_BARS_PROPOSED_DEFAULTS_2026_08_25.md`.
D9 — Confirm no experience/session work in this pilot (NON-GOALS §0).
