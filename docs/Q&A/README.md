# Q&A Repository

This directory stores question and answer datasets used for validation, grading model evaluation, and test case development.

## Contents

- `AP_BIO_STUDENT_ANSWERS.txt` — AP Biology exam responses with scoring labels and error annotations; used to validate grading model performance.
- `REVIEWER_QA_SWEEP_*.md` — periodic audits of human `subject_review` decisions (volume by
  reviewer, integrity/structure checks, QA signals, follow-ups). See "Reviewer QA sweeps"
  below.

## Usage

Files in this directory should be:
- Representative of real student work
- Annotated with correct answers and rubric scores
- Referenced in research protocols and grading validation documents
- Kept current as grading logic changes

## Reviewer QA sweeps

Owner instruction, 2026-08-06: all reviewer QA sweep reports live in this folder
(`docs/Q&A/`), not `docs/research/`. When a same-day sweep re-runs against a trailing
window, append it as an addendum section to that day's existing file rather than creating
a new one (see `REVIEWER_QA_SWEEP_2026_08_05.md` and `REVIEWER_QA_SWEEP_2026_08_06.md` for
the pattern). Name new sweeps `REVIEWER_QA_SWEEP_YYYY_MM_DD.md`.
