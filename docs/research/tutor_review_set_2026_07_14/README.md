# Tutor Content-Review Set — 2026-07-14

**Purpose:** onboard the two grading tutors (AP Statistics + newly hired AP
Biology) on a **content-review** pass, ramping from a small batch to a larger one.
**Manifest:** `tutor_review_set_manifest_2026_07_14.csv` (140 items).
**Environment:** items are **Production** (`pcntajvbdfqhbeewmdry`) content. This set
was built **read-only**; no Production assignment has been created yet.

## What this is — and is NOT

- **IS:** content review — the tutor verifies each *item* (stem correctness, answer
  key for MCQ, rubric/answer for FRQ, clarity, AP alignment). A tutor approval here
  does **not** publish an item or change a grade.
- **IS NOT** the grading-calibration gold set. Calibration adjudicates *responses*
  (dual-blind + Lead) to validate the grader; that's a separate, later artifact.
  **This item-review pass is the prerequisite** — you calibrate on items whose
  rubrics are already verified.

## Batches (non-overlapping ramp)

| Batch | Subject | MCQ | FRQ | Total |
|---|---|---:|---:|---:|
| `STATS-RV-B1` | AP Statistics | 10 | 10 | 20 |
| `STATS-RV-B2` | AP Statistics | 25 | 25 | 50 |
| `BIO-RV-B1` | AP Biology | 10 | 10 | 20 |
| `BIO-RV-B2` | AP Biology | 25 | 25 | 50 |

Start with **B1** (20 items/subject) to validate the tutor + workflow, then **B2**
(50 fresh items/subject). B2 does not repeat B1.

## Selection method

Deterministic stratified spread (no randomness): round-robin across item families,
evenly spaced within each, balancing status where both exist.
- **Stats FRQ** spans `APSTAT-MOD*`, `STATS-MOD*`, `APSTATS-SFRQ*`, and
  `APSTATS-HDG*` (hand-drawn graph), mixing **published (live)** and **draft**.
- **Stats MCQ** includes live **published** items (verifies production surface) +
  draft, incl. `-CAL` (calculator) items.
- **Bio** is entirely **draft** (all 254 Bio items are unpublished) — spanning
  `APBIO-FRQ-L` (long), `APBIO-FRQ-S` (short), `APBIO-HDG` (graph), and `APBIO-MCQ`.

`selection_reason` on each row records why it was picked.

## Reviewers (confirmed in Production)

- **1 tutor** with an **active grading qualification for AP Statistics** → the Stats batches.
- **1 tutor** with an **active grading qualification for AP Biology** (your new hire) → the Bio batches.

This is a **single-reviewer** content pass (one qualified tutor per subject). The
**second blind reviewer + Lead adjudication** is the later *calibration* phase, not
this one — so `tutor_b_status` is `not_required` here.

## Review dimensions

Reuse the existing scoring template
`docs/research/tutor_content_assessment_feedback_template_2026_07_12.csv`
(accuracy, clarity, answerability, difficulty_fit, `mcq_option_quality`,
`frq_rubric_alignment`, `grading_boundary_precision`, `repair_usefulness`,
accessibility_rendering, required_change, rationale). The `grading_boundary_precision`
and `frq_rubric_alignment` fields are the ones that feed directly into calibration.

## ⚠️ Two flags before assigning

1. **Stats content is 2026-format.** The selected Stats items are the current
   Production corpus (9-module scheme — note `STATS-MOD9-*`). AP Statistics is being
   rebuilt to the **2027 format (5 units)** per DECISION-0036, so some of this may be
   **retiring**. Decide whether the Stats tutor should review the current corpus
   (catches live defects, but some items may be retired) or wait for 2027-slice
   content. **Bio has no format change — its review is fully forward-valuable.**
2. **HDG items are spatial/human-shadow** (hand-drawn graph). They're a different
   review type (graph prompt + rubric, not a text answer key). Flagged as
   `hdg_spatial_modality`; drop them if you want the onboarding batch text-only.

## Next step — assignment (Production write, needs your go-ahead)

The tutors are qualified and the items are pinned (content_item_version_id in the
manifest). Creating the live assignments (`content_review_assignments` via
`assign-for-review`) is a **Production write** — I did not do it. On your go-ahead I
can create the B1 assignments (20 items to each tutor's queue) so they appear in
`/reviewer` for review. Assigning B2 after B1 clears is the natural cadence.
