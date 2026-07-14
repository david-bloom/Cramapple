# Stats + Bio Tutor Content Assessment Pilot

**Status:** STALE. This document's "Current operational blocker" section (below) describes a state that a later session in the same day superseded. It is kept as a design/procedure reference only — **do not read it as the current operational status report.** See "2026-07-12 status update" below for the corrected state, `docs/activity_log/ACTIVITY_LOG.md`'s "Tutor Content-Review Pipeline Repaired..." entry for the full primary source, and `DECISION-0035` in `docs/activity_log/DECISIONS_LOG.md` for the Product Owner's call on whether tutor review gates the August pilot.  
**Scope:** Content quality only. This workstream does not launch, change, or validate the grading runtime.  
**Subjects:** AP Statistics (`ap-statistics`) and AP Biology (`biology`)  
**Pilot batch:** `tutor_content_assessment_batch_01_2026_07_12.csv`

## 2026-07-12 status update (post-authoring)

This section corrects the rest of the document, which was written earlier the same day and describes an obsolete blocker. Full detail is in the ACTIVITY_LOG entry cited above; this is a summary.

**Onboarding / pipeline state:** The tutor invite/review pipeline (which this document's "Current operational blocker" section below describes as blocked) was repaired and verified end-to-end in Production with a real invite, not merely a local test. Bugs fixed and deployed to Production (`pcntajvbdfqhbeewmdry`): `reviewer-invite` (existed in repo but had never been deployed — now deployed, v3); a `prevent_profile_role_change` trigger that silently blocked legitimate service-role profile updates; a Lovable admin-check bug that hid the whole `/reviewer/users` admin nav; a stray Lovable edit that had reverted the invite call to a broken hand-rolled query. A real invite form (role + subject-qualification picker) now exists at `/reviewer/users`.

This confirms the pipeline *works*. It does **not** by itself confirm that the two named hired tutors have completed onboarding and hold live `role = 'tutor'` production accounts with real assignments — that step is not separately documented as done. Treat "pipeline functional" and "hired tutors onboarded and assigned" as two different claims; only the first is confirmed.

**Current tutor qualifications:** Subject-scoped qualifications now exist as a real mechanism (Product Owner decision), not just a plan. Stored in `app.validator_qualifications` (`qualification_type='grading'`, `exam_ids[]`). `assign-for-review` rejects assignments outside a tutor's qualified subjects; `review-queue` filters each tutor's queue by qualification (fails open — a reviewer with no qualification rows still sees queue, to avoid breaking existing seed data). Two required columns (`qualification_policy_version_id`, `expires_at`) are populated with placeholder/far-future values — **there is no formal qualification-policy framework yet**; this is a functioning mechanism without a governance record behind it.

**Review-flow behavior change (Product Owner decision):** MCQ review no longer splits question approval and per-answer-choice approval into two rounds — `review-decision`'s `tutor_question` stage now requires all `answer_approvals` in the same submission as the question decision. A `note` is hard-required (400 `note_required`) whenever the question or any answer choice isn't fully approved. This document's "Review procedure" and "Controlled issue codes" sections above are otherwise still accurate. A `diagnostic_flag` control was added to the reviewer UI (first draft, not yet reviewed by Learning Quality). Module/topic tagging and learner-facing surfacing timing were deliberately deferred, not built.

**Assignment status:** No evidence this session created real paired `tutor_question` assignments for the two hired tutors against this pilot's 24-item batch or any other batch. The blocker described below (no production Auth/profile rows for the two hired tutors) may or may not still hold — it was not re-verified in the 2026-07-12 pipeline-repair session, which focused on fixing the mechanism, not on running it against real hired-tutor accounts. Confirm current assignment state directly against Production before assuming either way.

**Content QA pass results (full corpus, not just this 24-item batch):** All 200 draft AP Biology + AP Statistics MCQs and all 254 draft FRQs were reviewed via parallel review agents, with fixes applied directly in Production. 17 confirmed content defects, all fixed:

- 2 MCQ defects: `APBIO-MCQ-005` (glucose/galactose mislabeled as structural isomers — actually stereoisomers/epimers); `APBIO-MCQ-082` (stated allele frequency 20.8% didn't match the founder-effect math — corrected to 16.7%).
- 3 FRQ procedural/labeling defects: `APSTAT-MOD3-H001-INV` and `APSTAT-MOD6-M003` used z*-based confidence intervals when only sample SD was known (corrected to t*-based, right df/bounds); `STATS-MOD1-E002` mislabeled a student-ID number as quantitative (corrected to categorical).
- 12 FRQ rubric/canonical-answer mismatches (mostly AP Biology): canonical answers that didn't actually satisfy their own rubric criterion (missing probability calculations, missing named concepts like "directional selection"/"bottleneck effect," missing numeric results).

An initial "12 Bio HDG items with no data" finding from one QA pass was a false alarm (wrong `content_key` filter pattern); not counted among the 17.

**Bio canonical-answer backfill:** Backfilled full-credit canonical answers for all 42 `APBIO-FRQ-L-*` (long-form) items, which previously had none. In the process, found and fixed two additional structural defects: `APBIO-FRQ-L-028` (stem only presented part (a), but the rubric graded parts (b)-(d) on content never shown to the student — stem extended to set up all four parts) and `APBIO-FRQ-L-004` (stem referenced "the 6th base" of a template strand for a point mutation, which didn't match the described sequence — corrected to the actual matching position and updated codon-change reasoning). Separately, **canonical answers were confirmed to be editorial/reference data only** — `evaluate-attempt` doesn't read them, and `statistics-verifier.ts`'s deterministic table was a one-time manual copy, not a live read of this field. Canonical-answer completeness is not the same as grading readiness.

**Stats HDG projection remediation:** Found and fixed a real data-integrity bug in **published** content — all 40 `APSTATS-HDG-2026-GRAPH-*` items (hand-drawn graph FRQs, live in Production) were missing their `app.frq_criteria` projection, even though the correct rubric already existed in `content_item_versions.prompt_json`. Fixed via a direct SQL projection from the existing JSON (no content invented) — 160 criteria rows inserted across the 40 items. A systemic linkage sweep across the entire corpus (not just drafts) found no other orphaned items. This same `prompt_json`-vs-`frq_criteria` consistency check has **not** yet been run against published content outside this 40-item HDG set — that remains open per the ACTIVITY_LOG entry's next-action list.

**Grading-telemetry dashboard bug (unrelated to tutor review, found same session):** `loadDashboardOverview` silently returns zero rows for every admin because it queries `auth.uid()`-gated views using the service-role client. Fix is fully specified but blocked on Lovable workspace credits as of session end — not yet shipped.

## Purpose

Give two hired tutors a fast, structured way to assess representative Cramapple content while Claude owns the grading launch. Tutor decisions identify content that is safe for a beta slice, content that needs revision, and gaps that could undermine grading or repair. A tutor approval never publishes an item and never changes a learner grade.

## Pilot shape

Batch 01 contains 24 immutable content versions:

- 6 published Stats MCQs;
- 6 published Stats short FRQs;
- 6 draft Bio MCQs;
- 6 draft Bio FRQs.

Both tutors review all 24 items independently. This creates a direct agreement signal, makes subject differences visible, and keeps the first workload small enough to finish in one or two sessions. Stats samples the currently published beta surface. Bio samples the draft inventory that must be cleared before any later publication decision.

## Review procedure

For each assigned content version:

1. Review the stem and stimulus without editing them.
2. For MCQ, inspect every option, the designated key, and each rationale.
3. For FRQ, inspect every criterion, evidence requirement, accepted variant, canonical answer, and minimum fix.
4. Complete every required field in the structured feedback template.
5. Choose exactly one disposition:
   - `1 / Yes`: suitable without substantive modification;
   - `2 / Maybe`: plausible, but a specific change is required;
   - `3 / No`: unsuitable in the current version.
6. Submit and lock. Revisions become new content versions and receive fresh reviews.

Tutors must not see each other's decisions until both have submitted the item.

## Assessment rubric

Score each dimension `pass`, `minor_issue`, `major_issue`, or `not_applicable`.

| Dimension | Pass standard |
| --- | --- |
| AP alignment | Tests a real course concept/skill at an appropriate depth without relying on copyrighted exam wording. |
| Scientific/statistical accuracy | Stem, data, calculations, key, rationale, canonical answer, and rubric are correct. |
| Clarity and completeness | A prepared student can understand what is asked; all data, units, labels, and referenced visuals are present. |
| Answerability | The item has enough information and exactly the intended solution boundary. |
| Difficulty fit | Intended difficulty is credible and recorded on the five-label scale. |
| MCQ option quality | Exactly one correct answer; distractors are plausible, mutually distinct, and free of unintended clues. |
| FRQ rubric alignment | Each criterion maps to the prompt, awards the stated points, and is not double-barreled. |
| Grading boundary precision | Evidence requirements, accepted variants, counterexamples, and minimum fix make over-credit and under-credit boundaries explicit. |
| Repair usefulness | The minimum fix teaches the smallest concrete change that could earn the missed point without giving away unrelated answers. |
| Accessibility/rendering | Text, notation, tables, and visuals remain understandable with the supported learner interface and alternatives. |

## Controlled issue codes

The live review API currently accepts `Accuracy`, `Ambiguity`, `Rubric gap`, and `Other`. Use those as the top-level codes. The structured template adds a non-authoritative `detail_code` for triage:

- `missing_asset`
- `bad_key`
- `weak_distractor`
- `missing_variant`
- `double_barreled_criterion`
- `calculation_or_unit_error`
- `repair_too_vague`
- `scope_or_difficulty_mismatch`
- `accessibility_or_rendering`
- `rights_or_provenance`
- `other`

## Acceptance criteria

An item is `tutor_clear` only when:

- both tutor scores are `1 / Yes`;
- neither tutor records a `major_issue` in any dimension;
- neither tutor flags `Accuracy`, `Ambiguity`, or `Rubric gap`;
- MCQs have exactly one correct option and all four options pass answer review;
- FRQs have complete criteria, positive point totals, explicit evidence requirements, and a concrete minimum fix for every criterion;
- any required stimulus or visual exists and renders;
- no unresolved rights/provenance concern exists.

Outcomes:

- `2` aggregate (`Yes + Yes`) -> `tutor_clear`, eligible for the next gate;
- `3` aggregate (`Yes + Maybe`) -> `revise_and_reassess`;
- `4-6` aggregate -> `exclude_current_version`;
- any critical accuracy, missing-asset, bad-key, or rights issue overrides the aggregate and blocks the version.

No outcome in this pilot directly publishes content. Release remains a separate owner-controlled action.

## Status and quality tracking

Track these counts by subject and item type:

- assigned, opened, submitted;
- `Yes`, `Maybe`, and `No` votes;
- exact tutor agreement rate;
- `tutor_clear`, `revise_and_reassess`, and `exclude_current_version`;
- issue-code frequency;
- FRQ criterion defects and MCQ key/distractor defects;
- missing labels/assets/canonical answers;
- median review minutes per item.

Batch completion requires 48 locked decisions (24 per tutor), 24 aggregated outcomes, and a written gap summary.

## Handoff to grading and repair

For every `tutor_clear` FRQ, hand Claude the immutable `content_item_version_id` plus:

- criterion keys and point totals;
- evidence requirements and accepted variants;
- minimum fixes;
- canonical answer status;
- both tutor difficulty labels;
- confirmation that no unresolved grading-boundary or repair-usefulness issue remains.

This is input to Claude's existing grading contract. Tutors do not alter evaluator strategy, model prompts, grading results, or repair runtime behavior.

## Current operational blocker (STALE — see "2026-07-12 status update" above)

This section is preserved for record, but it describes the state *before* the same-day pipeline-repair session. The pipeline it describes as broken was fixed and verified with a real invite later that day. Whether the two hired tutors specifically have completed onboarding is unconfirmed either way — see the status update above.

Production contains only internal test tutor accounts (`Tutor Alpha` and `Tutor Beta`). The two hired tutors do not yet have production Auth/profile rows. Before live assignment, each tutor must sign in once, then an admin must set `app.profiles.role = 'tutor'` and `review_queue_scope = 'my_queue'`. Do not assign hired work to the internal test identities.

Once the two real `user_id` values exist, create paired `tutor_question` assignments for every manifest row using one shared `blind_group_id` per content version. Use the existing `assign-for-review` function; do not insert decisions or bypass the immutable review API.

## Codex preflight findings (2026-07-12 production read)

The 24 manifest IDs were verified against production before handoff.

- All 12 MCQs have four choices and exactly one designated correct choice.
- All 12 FRQs have four or five rubric criteria.
- The six Stats SFRQs have canonical answers, but all 24 criterion rows are missing both `evidence_requirements` and `minimum_fix`. This is a launch-relevant grading/repair content gap and fails this pilot's `tutor_clear` standard until a successor version supplies boundary evidence and concrete fixes.
- Stats SFRQ display content is split: the relational `stem` is only `Answer all parts of the following question.`, while the actual stimulus and part prompts live in `prompt_json`. Tutor and learner tooling must render the structured prompt; a stem-only view is incomplete.
- The six Bio FRQs have populated evidence requirements and minimum fixes for all 26 criteria, but none has `canonical_answer_1` or `canonical_answer_2`. Tutor review can assess the rubrics now, but a production handoff needs an explicit canonical-answer decision.
- All 24 items have zero `content_item_labels` rows. Stats draft calibration content has unit labels elsewhere, but the published Stats beta surface and selected Bio inventory do not. This weakens coverage reporting and subject/module sampling.
- All selected Bio items remain draft; no tutor outcome should be confused with publication authorization.

These are structured-content findings, not claims about Claude's grading implementation.
