# Launch Plan — Content Pipeline (Question Templates) — 2026-09-26

**Status:** In progress | **Owner:** David Bloom | **Tier:** Standard
**Part of:** `APP_LAUNCH_READINESS_INDEX_2026_09_26.md`

## Product Goal

The system that turns raw exam content into servable, validated questions works end to end without
manual per-item authoring at scale. This plan covers two related but distinct systems plus the
quantity target they feed. Under `DECISION-0072`, it is **not a Friday-launch blocker**: AP Biology
and AP Statistics launch on their flat practice paths, which do not require unit-gated labels or
difficulty. It remains the execution plan for post-launch unit-gating and full all-subject readiness.

## CORRECTION, 2026-09-26 (same day, after a second AI review)

**This plan originally described the labels/difficulty pipeline as something to build.** It already
exists and has been run manually, per subject, via `scripts/taxonomy/extend_serving_labels_mcp.mjs` /
`extend_math_serving_labels.mjs`, DECISION-0066's two-model-agreement promotion rule, and per-subject
Codex work orders (e.g. `prompts/CODEX_WORK_ORDER_AP_CHEMISTRY_LABELS_AND_DIFFICULTY_2026_09_25.md`).
It has already produced a real result: FF-3 (`AP_BIOLOGY_FAST_FOLLOW.md`, closed 2026-09-24 under
DECISION-0066) promoted 229 two-model-agreed labels across 9 subjects, moving unit-gated servable
items from 8 to 141 product-wide. **This plan's actual remaining work is running the same
already-proven lane for the subjects/items not yet covered — not building new infrastructure.**
Difficulty has a related but separate method (DECISION-0061/0065).

`DECISION-0072` also resolves the launch-path dependency that remained in the first correction:
Statistics joins Biology on the flat practice path for Friday. Criteria 3 and 5 therefore do not
block either Day-1 subject. Do not use completion of this plan as a prerequisite for the free Friday
launch; use it to unlock the deferred unit-gated experience and to establish full commercial/
all-subject readiness.

**UX-003 (Content Authoring Workbench) was demoted out of this plan's critical path** — it's gated on
human domain reviews no AI agent can close, and isn't what's blocking subjects from passing the
servability gate. Track it as a separate content-ops-tooling item, not launch-critical, unless David
says otherwise.

**UX-004 (BYOQ intake) is re-promoted to launch-critical, but owned by the marketing-home-page plan,
not this one** (`DECISION-0070`, 2026-09-26): BYOQ ships ungated and anonymous on the new home page.
Its pending domain reviews (Learning Quality, accessibility, security, privacy, rights,
academic-integrity) are therefore launch-blocking, not deferrable — see
`LAUNCH_PLAN_MARKETING_HOME_PAGE_2026_09_26.md` for the acceptance criteria. This plan still lists it
below for reference since it's part of "the three pieces," but does not own its execution.

## The three pieces (UX-003 below is reference only; UX-004 is owned by the marketing-home-page plan)

1. **Content Authoring and Revision Workbench** (internal tool for authors/reviewers) —
   `docs/product/CONTENT_AUTHORING_AND_REVISION_WORKBENCH_DESIGN.md` (17-section UX spec), task
   `docs/tasks/UX-003-CONTENT-AUTHORING-REVISION-WORKBENCH.md` (In Progress, needs multiple domain
   reviews before Done).
2. **Student-Provided Question Intake (BYOQ)** — `docs/product/STUDENT_PROVIDED_QUESTION_INTAKE_DESIGN.md`
   (14-section UX spec), task UX-004 (In Progress, needs Learning Quality/accessibility/security/
   privacy/rights/academic-integrity/Product Owner review). Note: the design doc has a duplicate "6.4"
   section numbering — flag to whoever owns the doc rather than silently resolving it.
3. **Content quantity and coverage targets** —
   `docs/product/CONTENT_QUANTITY_AND_DISTRIBUTION.md` (inventory unit, approved planning targets,
   unit distribution, official topic coverage matrix, launch/reporting rule).

## Current execution state (documented through 2026-09-26)

The stages below are deliberately separate. **Generated** labels are not necessarily servable:
independent cross-QA must finish, eligible labels must be promoted to `validated` under
`DECISION-0066` (including a third review for multi-unit agreements), content-hash freshness must
hold, and the live selector must then be called. A difficulty row is a separate criterion and does
not promote a label.

Counts in this table are documented run results, not a substitute for a fresh Production census.
The selector figures marked “pre-run” come from the 2026-09-25 readiness audit and predate the Pair
1/2 writes; re-run the selector after promotion before claiming current unit-gated coverage.

| Subject | Label generation | Independent cross-QA | Validation promotion | Live unit-gated selector verification | Difficulty coverage |
| --- | --- | --- | --- | --- | --- |
| AP Biology | Earlier lane executed; remaining FF-7/FF-8 label gaps are tracked in `AP_BIOLOGY_FAST_FOLLOW.md` | FF-3 promotion received independent multi-unit review | Partial existing FF-3 promotion; fresh subject-level census required | Fresh unit-gated check pending; flat practice path is independently verified and is the Friday path | **118/118 complete** (FF-6) |
| AP Statistics | **Complete:** 126 decisions (107 provisional, 19 held) | **Complete:** Codex cross-QA, PR #193 | 23 fresh single-unit rows promoted this pass; 67 fresh validated live | **Verified:** direct selector returned 48 at unit 5 (RPC eligibility/cap rules apply) | **170/170 complete** |
| AP Chemistry | **Complete:** 42 decisions (33 provisional, 9 held) | **Complete:** independent cross-QA, no issues | 25 fresh single-unit rows promoted; 65 fresh validated live | **Verified:** direct selector reached the 50-row RPC cap at unit 9 | **119/119 complete** |
| AP Calculus AB | **Complete:** Pair 2 run and follow-up fixes | **Complete:** independent cross-QA and remediation | 24 fresh single-unit rows promoted; 31 fresh validated live; older/multi-unit rows remain provisional | **Verified:** direct selector returned 31 at unit 7 | **122/122 complete** |
| AP Precalculus | **Complete:** Pair 2 run; disagreement remediation applied | **Complete:** two cross-QA passes and metadata remediation | 25 fresh single-unit rows promoted; 52 fresh validated live | **Verified:** direct selector reached the 50-row RPC cap at unit 3 | **117/117 complete**, including metadata reconciliation |
| AP Calculus BC | **Blocked before model transfer:** 98 candidates exported; explicit Vercel-intermediary approval required | Pending | 4 fresh validated; old provisional/stale/legacy/no-label rows remain | **Verified unchanged:** direct selector returned 4 | **127/127 complete** (`20260926234400`) |
| AP Physics 1 | **Complete:** 107 candidates re-labeled; current live state 77 validated / 17 provisional / 23 held | Independent result-shape and migration checks complete; multi-unit third review remains | 70 fresh single-unit rows promoted this pass | **Verified:** direct selector reached the 50-row RPC cap at unit 8 | **117/117 complete** (`20260926234000`) |
| AP Physics 2 | **Complete:** 66 candidates re-labeled; current live state 50 validated / 2 provisional / 16 held | Independent result-shape and migration checks complete; multi-unit third review remains | 49 fresh single-unit rows promoted this pass | **Verified:** direct selector reached the 50-row RPC cap | **68/68 complete** (`20260926234100`) |
| AP Physics C: Mechanics | **Blocked before model transfer:** 76 candidates exported; explicit Vercel-intermediary approval required | Pending | 0 fresh validated | **Verified unchanged:** direct selector returned 0 | **77/77 complete** (`20260926234200`) |
| AP Physics C: E&M | **Blocked before model transfer:** 96 candidates exported; explicit Vercel-intermediary approval required | Pending | 1 fresh validated | **Verified unchanged:** direct selector returned 1 | **97/97 complete** (`20260926234300`) |

Evidence: `TIER3_PAIR1_STATUS_2026_09_25.md`, `TIER3_PAIR2_STATUS_2026_09_25.md`,
`AP_BIOLOGY_FAST_FOLLOW.md`, and
`docs/content/CODEX_QA_REPORT_READINESS_AUDIT_WORK_ORDERS_AND_SELECTORS_2026_09_25.md`.

## The actual remaining work: finish execution, promotion, and live verification

`SUBJECT_SERVABILITY_CRITERIA.md` criteria 3 (validated serving labels) and 5 (difficulty values) are
still open for most subjects — not because the pipeline doesn't exist, but because label generation,
cross-QA, governance promotion, and live verification have not all been completed for every subject.
Pair 1 (Statistics/Chemistry) and Pair 2 (Calculus AB/Precalculus) have completed generation,
difficulty, and cross-QA; their new `provisional_model` labels still need the separate promotion and
live-selector stages. Pair 3, Pair 4, and Calculus BC remain to be run. Hand-authoring the remainder
isn't viable at the current pace; continue the established per-subject work-order pattern.

## Acceptance Criteria

- [ ] For each subject not yet fully covered, issue or continue a Codex work order following the
      pattern in the examples above, and independently re-verify its output (per this repo's own
      practice of an independent re-check after every Codex-proposed batch).
- [ ] Every promoted label passes a spot-check against `select_unit_gated_practice_items`'s actual
      requirement (verify by calling it — do not assume from reading the promotion rule) and honors
      DECISION-0066's content-hash freshness rule (a label promoted against stale content is not
      valid — this is why some Physics C/Calc BC candidates were flagged stale).
- [x] Difficulty rows are produced per DECISION-0061/0065 (null `attainment_ratio` acceptable with an
      honest `basis`; a fabricated ratio is not).
- [ ] Any model-call-based *grader-gate reachability* check specifically is run 3+ times before being
      trusted (this 3+ rule is about grader reachability, not the label-agreement step itself, which
      already has its own two-model-agreement design per DECISION-0066 — don't triple the label-run
      cost by conflating the two).
- [ ] `CONTENT_QUANTITY_AND_DISTRIBUTION.md`'s approved planning targets are checked against actual
      current AP Biology bank size. Its approved targets — 600 MCQs, 300 short FRQs, and 64 long FRQs
      (964 total) — are **Biology-only**. **David decision required:** whether equivalent targets are
      needed for the other 9 subjects. Until that decision is recorded, do not invent targets or
      treat this quantity criterion as checkable for those subjects.
- [ ] Once a subject's labels/difficulty are updated, its entry in `SUBJECT_SERVABILITY_CRITERIA.md`'s
      "Applied so far" table is updated with real numbers, cited to the migration or run that produced
      them. **This table is shared with `LAUNCH_PLAN_SUBJECT_ONBOARDING_GATE_2026_09_26.md` — this plan
      owns writing criteria 3/5 updates to it; plan 5 owns criteria 1/2/4/6. Do not both edit the same
      row concurrently without checking the other plan's latest edit first.**

## Execution update — 2026-09-26

- Completed Pair 3 labeling and applied the Physics 1 / Physics 2 migrations.
- Promoted 216 current, fresh, single-unit two-model agreements under DECISION-0066. Older labels
  and all multi-unit labels were deliberately excluded.
- Completed and applied 486 difficulty rows, closing criterion 5 for all ten live packs.
- Re-ran the real selector and the census self-test: 0 mismatches.
- Checked Biology quantity against its approved target: 43/600 MCQ, 59/300 short FRQ, 16/64 long
  FRQ. The other-subject target decision remains open.
- Remaining execution depends on two explicit inputs: approval to send the three outstanding
  subjects through Vercel AI Gateway to OpenAI/Gemini, and a Product Owner quantity-target decision
  for the other nine subjects.

## Out of Scope

UX-003 and UX-004 (see correction above) — track separately, not on this plan's critical path unless
David says otherwise.

## Method Note

Don't conflate "reviewed/approved" (criterion 1, a human content-review gate) with "servable"
(criteria 3, 5, 6 combined) — this exact conflation is what produced AP Biology's same-day correction
in its own launch-readiness doc. Verify pipeline output against live serving RPCs, not against the
reviewer tool's published-item count.
