# TASK-0054 — Put Reference Content On The Taxonomy (FK + Skill Axis)

**Status:** Not started. **NOT launch gating** — see "Why this is not a launch gate".
**Tier:** Standard for the schema work; Hard-Gate for any Production apply.
**Owner:** TBD
**Product Owner:** David Bloom
**Date opened:** 2026-09-29
**Area:** Reference content / taxonomy / feedback inputs
**Depends on:** PR #268 (`taxonomy_source_versions.subject_id`), `TASK-0050` (skill labelling)
**Related:** `TASK-0053` (distractor-specific MCQ feedback), `DECISION-0085`,
`docs/research/TOPIC_GUIDE_PROTOCOL_ASSESSMENT_2026_08_21.md`,
`docs/product/CONTENT_TAXONOMY_RATIONALIZATION_PLAN_2026_09_26.md`

---

## Why this exists

David asked, 2026-09-29, whether `topic_explainers` and `topic_point_briefs` were authored from a
table carrying unit number, unit description, topic description and relevant skills. **They were
not.** They were authored as markdown documents (`docs/product/AP_*_UNIT*_TOPIC_POINT_BRIEFS.md`,
one per subject-unit) and loaded into two tables that store their taxonomy position as **plain
text**:

```
topic_explainers    (subject_key, unit_number, topic_code, title, core_idea, ...)
topic_point_briefs  (subject_key, unit_number, topic_code, title, class_importance, ...)
```

Three consequences, all of which block using this content as a feedback ingredient:

1. **No foreign key to `taxonomy_topics`.** The position is a string triple. Nothing stops a typo, a
   renamed topic code, or a CED edition change from orphaning a row silently.
2. **No skill reference at all.** Neither table has a `skill_code` or any link to
   `app.taxonomy_skills`. The structured thing that *does* carry skills —
   `app.authoring_briefs.assessable_skill_target_ids` — is the **item**-authoring path, and the
   explainers were never built from it.
3. **`unit_number` is unenforced** and can disagree with the taxonomy (noted in the 2026-08-21
   protocol assessment, §A/`(subject_key, topic_code)` uniqueness).

## Current state, measured on Production 2026-09-29

| Subject | Taxonomy topics | Briefs | Explainers |
|---|---:|---:|---:|
| ap_calculus_bc | 111 | 111 | 111 |
| ap_chemistry | 91 | 91 | 91 |
| ap_calculus_ab | 81 | 81 | 81 |
| ap_biology | 60 | 60 | 60 |
| ap_precalculus | 58 | 58 | 58 |
| ap_statistics | 55 | 55 | 55 |
| ap_physics_2 | 46 | 46 | 46 |
| ap_physics_1 | 43 | 43 | 43 |
| ap_physics_c_mechanics | 41 | 41 | 41 |
| **ap_physics_c_em** | **31** | **17** | **17** |

Two facts that shape the work:

- **Zero orphans.** No brief or explainer names a topic code absent from its subject's taxonomy. The
  FK can be added today without a data repair first.
- **One real content gap: AP Physics C: E&M is short 14 topics** in both tables. That is a content
  authoring job, not a schema job, and it is the only coverage hole.

Provenance, from `TOPIC_GUIDE_PROTOCOL_ASSESSMENT_2026_08_21.md`: the CED fact packs existed in the
repo but **protocol v1 referenced none of them by path**, so the corpus was authored without the
grounding artifacts it should have used. v2 requires a fact-pack section per topic. Re-authoring the
pre-v2 rows against the fact packs was recorded as a deferred batch and **has never been run**.
Current source notes: 603 briefs and 541 explainers `cramapple-authored`, 62 explainers
`generated-from-brief`.

## Scope

**A. Structural (small, safe, do first)**
- Add FK `(taxonomy_source_version, topic_code)` → `taxonomy_topics` to both tables, which requires
  first adding `taxonomy_source_version` to them. Depends on PR #268 so the subject link resolves by
  id rather than by a string transform.
- Make `unit_number` derived from, or checked against, `taxonomy_topics` instead of free-floating.
- QA script asserting zero orphans and zero unit mismatches, in the shape of
  `scripts/qa/taxonomy_subject_link_qa.sql`.

**B. Skill axis**
- Decide the grain: is a brief/explainer attached to a **topic** (today's assumption) or to a
  **topic × skill cell**? Per `DECISION-0088` the storage grain is the cell, so the default answer
  is the cell — but reference prose is plausibly topic-level, and this should be decided, not
  assumed.
- Whichever grain: add the link, and make `taxonomy_skills.label` reachable from a brief.

**C. Content**
- Author the 14 missing AP Physics C: E&M topics.
- Run the deferred re-authoring batch against the CED fact packs for pre-v2 rows, or explicitly
  retire that commitment.

**D. Feedback integration**
- Only once A and B land: expose brief/explainer fields to the MCQ feedback composer as registry
  ingredients (David, 2026-09-29: the composer should read from a registry of available fields, use
  2–3 per message, and not need rewriting when a field is added).

## Why this is not a launch gate

`TASK-0053`'s distractor-specific feedback ships without any of this: it reads the item's own
authored distractor rationale, which exists for **all 2,349 published distractors**. This task makes
the feedback *richer* and makes reference content safe to join against. It does not unblock it.

## Open questions

1. **Grain for B** — topic, or topic × skill cell?
2. **Physics C: E&M** — author the missing 14 now, or accept the gap and mark the subject partial?
3. **The deferred re-authoring batch** — run it, or formally retire the commitment? It has been open
   since 2026-08-21 and is currently neither done nor cancelled.
