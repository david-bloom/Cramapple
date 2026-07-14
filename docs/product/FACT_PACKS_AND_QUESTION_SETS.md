# Fact Packs and Short Question Sets

**Status:** Draft — awaits Learning Quality Owner review, subject-selection
decision (`EXPAND-001`), and Product Owner direction
**Owner:** Main Conductor (drafting) / Learning Quality Owner (review)
**Product Owner:** David Bloom
**Related Tasks:** `CONTENT-001`, `EXPAND-001`, `TASK-0007`
**Related Design:** `docs/product/BIO_REFERENCE_LAYER_PLAN.md`,
`docs/architecture/CONTENT_AUTHORING_AND_PROMPT_ARCHITECTURE.md`,
`docs/product/CONTENT_COVERAGE_BRIEFS.md`
**Date:** 2026-07-14

## 1. Purpose

This document defines two governed, subject-agnostic content artifacts for the
next round of subjects:

1. **Fact Pack** — a single governed record about one topic that exposes three
   scoped **views** of the same reviewed material: an *authoring view* (source
   material for question authoring), a *learner view* (condensed study content
   students may see), and a *grading view* (reference the grader may retrieve).
   This is the "all three, layered" model: one artifact, three access scopes,
   one review trail — not three parallel content stores that can drift apart.
2. **Short Question Set** — a compact, governed grouping of a few short items on
   one topic, sized for quick practice or a light diagnostic rather than a full
   exam-style bank.

It generalizes the AP Biology reference-card model
(`BIO_REFERENCE_LAYER_PLAN.md`) so it can carry non-biology subjects, and it
adds the learner-facing and authoring-source scopes that the bio plan left as a
grading-only concept.

### 1.1 Subject scope for this round

Per Product Owner direction: **AP Chemistry, AP Calculus AB, AP Calculus BC.**

- AP Calculus AB is a strict subset of AP Calculus BC (BC adds Unit 9,
  parametric/polar/vector, and Unit 10, infinite sequences and series). Fact
  packs and question sets tag `applies_to: [CALC_AB, CALC_BC]` where shared, and
  `applies_to: [CALC_BC]` for BC-only material, so BC reuses AB content instead
  of duplicating it.
- These subjects are recorded as selected by the Product Owner in `DECISION-0036`
  (execution scope still gated). Subject selection remains a Product Owner decision
  with Strategy Advisor and Learning Quality input.

### 1.2 Subsequent round — AP Physics (after Chemistry and Calculus)

Per `DECISION-0037`, the round **after** Chemistry and Calculus is the four AP
Physics exams, using the same artifacts defined here. Subject codes:
`PHYS1` (AP Physics 1, algebra-based), `PHYS2` (AP Physics 2, algebra-based),
`PHYSCMECH` (AP Physics C: Mechanics, calculus-based), `PHYSCEM` (AP Physics C:
E&M, calculus-based). The calculus-based Physics C exams reuse the Calculus
symbolic-equivalence verifier; the algebra-based exams use numeric checks. Launch
tasks: `docs/tasks/TASK-0017-AP-PHYSICS-1-2-LAUNCH.md`,
`docs/tasks/TASK-0018-AP-PHYSICS-C-LAUNCH.md`.

## 2. What this document is not

- **Not production content and not calibration evidence.** The seed fact packs
  and question-set items (§7) are *illustrative Draft format examples* authored
  to demonstrate the artifact shape. They are not admitted to any content pool,
  are not a human gold set, and do not count toward any coverage target. The
  production authoring baseline remains paid qualified tutors
  (`CONTENT_AUTHORING_AND_PROMPT_ARCHITECTURE.md` §2.2); these drafts are subject
  to replacement by tutor-authored, Learning-Quality-reviewed packages.
- **Not a subject-selection or expansion approval** (see §1.1).
- **Not a taxonomy of record.** Unit structures referenced here are the publicly
  known College Board framework structures at the unit level. Exact official
  topic identifiers must be confirmed against the current official Course and
  Exam Description before any pack is approved — the same caution the AP
  Statistics brief applied to unit naming
  (`AP_STATISTICS_PHASE4_CONTENT_AUTHORING_BRIEF.md`).

## 3. Governing rules (restated — not reopened)

1. **No official material as input.** No official AP question text, scoring
   guidelines, or identifiable official question structures enter a fact pack, a
   question set, an authoring prompt, or a model input
   (`CONTENT_AUTHORING_AND_PROMPT_ARCHITECTURE.md` §2.1). Facts are expressed in
   original Cramapple wording. For math and chemistry, established public-domain
   results (e.g. the power rule, the ideal gas law) are not copyrightable; the
   *wording, worked methods, and questions* must still be original.
2. **Tutor-authored production baseline.** Production content is authored by paid
   qualified tutors and independently validated. AI-drafted material is either an
   isolated experiment arm (`TASK-0007`) or a draft pending human authoring and
   review — never a production or calibration artifact by default.
3. **Same gates for every arm and every subject.** Each new subject receives the
   same originality, scientific/mathematical, teaching, grading, accessibility,
   and rights gates AP Biology receives (`CONTENT_GOVERNANCE_AND_VALIDATION.md`).
   A new subject does not get a lighter bar for being new.
4. **No answer leakage.** Learner-view and grading-view scoping must not reveal
   answer-bearing help before a cold attempt, consistent with the bio reference
   layer's non-goals (`BIO_REFERENCE_LAYER_PLAN.md` §3).
5. **Layered, not forked.** The three views are projections of one reviewed
   record. A fact changes in one place; the views expose scoped subsets of it.
   Views never hold independently edited copies of the same fact.

## 4. Fact Pack Artifact

### 4.1 Structure

A fact pack is one governed record for one topic. It contains a set of typed
**entries** (generalized from the bio reference-card types) and three **views**
that select which entries, and which fields of those entries, are exposed for a
given use.

Entry types (subject-agnostic):

| Entry type | Purpose | Bio-plan analogue |
| --- | --- | --- |
| `concept` | The core claim/definition for the topic | Concept Card |
| `method` | An ordered procedure or derivation that earns credit | Mechanism Chain Card |
| `formula_rule` | A formula, identity, unit rule, or deterministic check | Calculation/Data Rule Card |
| `misconception` | A common wrong model + discriminating probe + repair | Misconception Card |
| `worked_method` | A fully worked exemplar of the method on a neutral case | (teaching exemplar) |
| `boundary` | Accepted vs. insufficient wording for a scored criterion | Accepted-Variant / Insufficient-Wording / Boundary Contract |

### 4.2 The three views

Each view is defined by which entry types and `sensitivity` levels it may expose.
Sensitivity and use-scope reuse the bio reference-layer vocabulary
(`BIO_REFERENCE_LAYER_PLAN.md` §6) so a single grading pipeline can serve all
subjects.

| View | Audience | Exposes | Must never expose |
| --- | --- | --- | --- |
| `authoring_view` | Question authors, authoring prompts (manifest concern #6) | all entry types, including `boundary` and `worked_method` | official material; another author's proprietary package without rights |
| `learner_view` | Students, directly | `concept`, `formula_rule`, `worked_method`, `misconception` marked `teaching_safe` | `boundary`, anything `grading_sensitive` or `answer_bearing`, answers to active items |
| `grading_view` | The grader/feedback pipeline | `boundary`, `formula_rule`, `misconception`, `method` marked `grading_only` | nothing new that adds scoring criteria beyond the rubric |

A single entry carries a `sensitivity` (`teaching_safe` / `grading_sensitive` /
`answer_bearing` / `rights_restricted`) and a `use_scope` set; the view is the
filter, the entry's tags are the authority. An `answer_bearing` method entry can
appear in `authoring_view` and (after a cold attempt) `grading_view`, but never
in `learner_view` pre-attempt.

### 4.3 Identity, versioning, state

**Pack ID:** `FP-<subject>-<unit.topic>-<seq>` — e.g. `FP-CHEM-4.7-01`,
`FP-CALCAB-2.1-01`, `FP-CALCBC-10.13-01`. Subject codes: `CHEM`, `CALCAB`,
`CALCBC`.

**Version:** `Pack-Version: vNN`, immutable once released. Any change to a
`grading_sensitive` or `answer_bearing` entry creates a new version and triggers
grading revalidation, matching the bio plan's grading-sensitive release rules
(`BIO_REFERENCE_LAYER_PLAN.md` §11).

**State:** `Drafted` → `LQ-Reviewed` → `Approved` → `Released` → `Retired`.
Learning Quality advances to `LQ-Reviewed`; Product Owner (or delegated LQ Owner
in lane) to `Approved`/`Released`.

### 4.4 Data model

Generalizes `bio_reference_cards` (`BIO_REFERENCE_LAYER_PLAN.md` §6) to be
subject-neutral:

```text
fact_pack {
  pack_id: string                 # FP-<subject>-<unit.topic>-<seq>
  pack_version: string            # vNN
  state: enum
  subject: enum                   # CHEM | CALCAB | CALCBC | ...
  applies_to: enum[]              # subjects that may reuse this pack
  exam_pack_version_id: UUID
  unit: string
  topic: string                   # confirm against official CED before Approved
  skill_tags: string[]

  entries: fact_pack_entry[]      # see below
  views: {authoring_view, learner_view, grading_view}  # entry-id + field filters

  # governance (mirrors bio_reference_cards)
  source_status: enum             # cramapple_authored | expert_authored | ...
  rights_basis: string
  model_input_allowed: bool
  learner_display_allowed: bool
  official_material_boundary_checked: bool
  author_class: enum              # paid_ap_tutor | ai_draft_human_reviewed | ...
  author_id, reviewer_id, review_status
  supersedes_pack_id, defect_status, retired_reason
  created_at, released_at
}

fact_pack_entry {
  entry_id: string
  entry_type: enum                # concept | method | formula_rule |
                                  #   misconception | worked_method | boundary
  sensitivity: enum               # teaching_safe | grading_sensitive |
                                  #   answer_bearing | rights_restricted
  use_scope: enum[]               # grading_only | teaching_after_attempt |
                                  #   repair_after_grade | authoring_brief |
                                  #   learner_visible_summary
  body: string                    # original wording
  minimum_fix: string|null
  criterion_ref: string|null      # for boundary/accepted-variant entries
}
```

## 5. Short Question Set Artifact

### 5.1 Definition

A short question set is a governed grouping of **3–6 short items** on one topic,
delivered together for quick practice or a light diagnostic. It is a *delivery
grouping*, not a new inventory unit: each item is still one MCQ or one
independently answered short-FRQ prompt and still counts once against the
inventory rule (`CONTENT_QUANTITY_AND_DISTRIBUTION.md`). A set may draw items
from more than one coverage-brief slot.

Sets are intentionally lighter than full exam-style banks — good for onboarding a
new subject, seeding a diagnostic, or piloting an author's calibration — and each
item still requires its full package before production release.

### 5.2 Schema

```text
question_set {
  set_id: string                  # QS-<subject>-<unit.topic>-<seq>
  set_version: string             # vNN
  state: enum                     # Drafted -> LQ-Reviewed -> Approved -> Released
  subject: enum
  applies_to: enum[]
  unit: string
  topic: string
  intended_use: enum              # practice | diagnostic
  linked_fact_pack_id: string|null

  items: question_set_item[]      # 3-6
}

question_set_item {
  item_id: string
  form: enum                      # mcq | short_frq
  primary_topic: string
  science_or_math_practice: string[]
  task_verbs: string[]
  difficulty_band: enum
  # For production, each item resolves to the full MCQ (§8) or FRQ (§9)
  # package contract in CONTENT_AUTHORING_AND_PROMPT_ARCHITECTURE.md.
  # In a Draft set, an item may carry an illustrative stem + key + rationale
  # marked as a format example, NOT production content or calibration evidence.
  status_note: string
}
```

### 5.3 Relationship to coverage briefs

A short question set is a *lightweight sibling* of the coverage-brief system
(`CONTENT_COVERAGE_BRIEFS.md`): coverage briefs commission the full, versioned
package for one slot; a short question set groups a few items for quick delivery.
For production, a set's items should each trace back to an approved coverage
brief. For a brand-new subject with no briefs yet, a Draft set can precede briefs
as a scoping artifact, then be back-filled with briefs before release.

## 6. Rights and governance posture by view

| View | Rights posture | Release gate |
| --- | --- | --- |
| authoring_view | Cramapple-authored or licensed with model-input rights; no official material | Learning Quality review; author + reviewer named |
| learner_view | Cramapple-authored, no answer leakage; accuracy bar equal to learner-facing product | Learning Quality + (for public/marketing display) Marketing review |
| grading_view | Grading-sensitive; treated as rubric extension | Learning Quality approval + grader revalidation (`BIO_REFERENCE_LAYER_PLAN.md` §11.1) |

New-subject expansion additionally requires the `EXPAND-001` gates: subject
ranking, capability and validator gates, and equal source/rights/teaching/
grading/release quality to AP Biology.

## 7. Seed Artifacts (Draft — illustrative format examples)

The following seed files demonstrate the format end-to-end for each subject. All
are `state: Drafted`. Their factual content is original, expressed in Cramapple
wording, at an established public-domain level, and is **not production content
or calibration evidence** — it is subject to replacement by tutor-authored,
Learning-Quality-reviewed packages.

| Subject | Fact pack | Short question set |
| --- | --- | --- |
| AP Chemistry | `docs/content/ap-chemistry/FP-CHEM-4.7-01.md` (stoichiometry & the ideal gas law) | `docs/content/ap-chemistry/QS-CHEM-4.7-01.md` |
| AP Chemistry | `docs/content/ap-chemistry/FP-CHEM-8.1-01.md` (acids, bases & pH) | `docs/content/ap-chemistry/QS-CHEM-8.1-01.md` |
| AP Calculus AB | `docs/content/ap-calculus-ab/FP-CALCAB-2.1-01.md` (derivative rules) | `docs/content/ap-calculus-ab/QS-CALCAB-2.1-01.md` |
| AP Calculus AB | `docs/content/ap-calculus-ab/FP-CALCAB-6.1-01.md` (integration & the FTC) | `docs/content/ap-calculus-ab/QS-CALCAB-6.1-01.md` |
| AP Calculus BC | `docs/content/ap-calculus-bc/FP-CALCBC-10.13-01.md` (series convergence) | `docs/content/ap-calculus-bc/QS-CALCBC-10.13-01.md` |
| AP Calculus BC | `docs/content/ap-calculus-bc/FP-CALCBC-9.1-01.md` (parametric & polar) | `docs/content/ap-calculus-bc/QS-CALCBC-9.1-01.md` |

Launch tasks for these subjects: `docs/tasks/TASK-0014-AP-CHEMISTRY-LAUNCH.md`,
`docs/tasks/TASK-0015-AP-CALCULUS-LAUNCH.md`.

### 7.1 AP Physics round seed artifacts (subsequent round, `DECISION-0037`)

One fact pack + one short question set per physics subject, all `state: Drafted`
illustrative format examples with original public-domain-level content.

| Subject | Fact pack | Short question set |
| --- | --- | --- |
| AP Physics 1 | `docs/content/ap-physics-1/FP-PHYS1-2.1-01.md` (Newton's 2nd law & kinematics) | `docs/content/ap-physics-1/QS-PHYS1-2.1-01.md` |
| AP Physics 2 | `docs/content/ap-physics-2/FP-PHYS2-4.1-01.md` (DC circuits: Ohm's law & power) | `docs/content/ap-physics-2/QS-PHYS2-4.1-01.md` |
| AP Physics C: Mechanics | `docs/content/ap-physics-c-mechanics/FP-PHYSCMECH-1.1-01.md` (kinematics with calculus) | `docs/content/ap-physics-c-mechanics/QS-PHYSCMECH-1.1-01.md` |
| AP Physics C: E&M | `docs/content/ap-physics-c-em/FP-PHYSCEM-1.1-01.md` (Coulomb's law & electric field) | `docs/content/ap-physics-c-em/QS-PHYSCEM-1.1-01.md` |

Launch tasks: `docs/tasks/TASK-0017-AP-PHYSICS-1-2-LAUNCH.md`,
`docs/tasks/TASK-0018-AP-PHYSICS-C-LAUNCH.md`.

## 8. Open gates and questions

1. **Subject selection (`EXPAND-001`).** Product Owner decision — with Strategy
   Advisor and Learning Quality input — to formally select AP Chemistry, AP
   Calculus AB, and AP Calculus BC as the next round. Everything below waits on
   this.
2. **Learning Quality review.** Confirm the fact-pack entry types, the three-view
   sensitivity model, and the accuracy of the seed content per subject. Chemistry
   and calculus need a qualified reviewer in each domain, not the AP Biology
   reviewer.
3. **Official taxonomy confirmation.** Confirm exact official unit/topic
   identifiers against the current CED for each subject before any pack or set is
   `Approved` (§2, §3.3).
4. **Grading-view interaction.** Decide whether the grading view plugs into the
   existing grader-agent/boundary-contract pipeline
   (`BIO_REFERENCE_LAYER_PLAN.md`) unchanged, given that Phase 0 found generic
   fact cards did not improve grading — the grading view may be boundary-contract
   only at first for these subjects too.
5. **Calc AB/BC packaging.** Confirm the subset model (§1.1): one shared body of
   AB content reused by BC, plus BC-only packs, versus two independent subjects.
6. **Production authorship.** Who authors the production packs and sets for each
   subject once selected — the same paid-tutor model as Biology, cross-credentialed
   reviewers, or new recruitment.

## 9. What this document does not cover

- Admitting any seed pack or item to a content pool, or treating any of it as
  calibration evidence (Hard-Gated; §2).
- Pricing, bundling, or go-to-market sequencing for the new subjects.
- Physical database schema for fact packs (deferred with the rest of the content
  schema, `TASK-0009`).
- The full topic coverage for each subject — this draft defines the artifacts and
  seeds one slice per subject; scaling follows subject selection and a successful
  first slice.
