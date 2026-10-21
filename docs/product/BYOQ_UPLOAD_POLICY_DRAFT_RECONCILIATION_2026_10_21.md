# BYOQ Upload-Policy Draft — Reconciliation (2026-10-21)

STATUS: HISTORICAL (a dated reconciliation record). It adopts nothing and makes no new policy promises.

**What this is.** Codex wrote a discussion draft, `BYOQ_UPLOAD_POLICY_AND_DATA_LIFECYCLE_DISCUSSION_2026_09_23.md`, on 2026-09-23. It was never approved and never committed to `main`. The original is preserved unchanged on branch `archive/byoq-upload-policy-discussion-2026-09-23`. This page says where each part of the draft went: decided elsewhere, not adopted, or still open in the governance backlog (`docs/MASTER_TODO.md` §5). Current BYOQ policy direction lives in `BYOQ_PHOTO_EXTRACTION_PLAN_V2_2026_10_08.md` and the decisions it cites.

## Decided elsewhere (the record is the source, not the draft)

| Draft section | What was decided | Record |
|---|---|---|
| §4 first-upload disclosure, §5 personal-information reminder | Simple consent copy with a PII reminder. Not a blocking step, no recorded-acceptance event. Shown before and during hand-drawn capture. | David's direction, 2026-09-23 (`activity_log/archive/ACTIVITY_LOG-2026-09-22_to_2026-09-30.md`, "Hand-Drawn Capture Reviewed Against a Separate Codex BYOQ Upload-Policy Discussion Draft") |
| §8 student-initiated deletion | Disregarded ("discussion only, not a decision"). It conflicts with the `app.response_attachments` immutability trigger kept for grading-dispute integrity. The privacy policy makes no deletion promise and none is planned. | Same 2026-09-23 entry; extraction plan v2, current-state table row 3 |
| §2 teaching invariant (Open Hand uses the Cramapple library) | BYOQ items are never graded, never Open Hand, never a canonical answer. | `DECISION-0057` |
| §3 / §11 GOV-001 public, canonical and marketing reuse | Private study use only; no promotion path without a separate review. | `DECISION-0084` (restated in extraction plan v2) |
| Identity and anonymous use | Identity-agnostic: identity changes persistence, not capability. Anonymous items are purged after 30 days. | `DECISION-0077`, `DECISION-0084` |
| §9 / §10 policy text for extraction | No privacy-policy change; the live policy already covers extracted content. | David, 2026-10-08 (extraction plan v2, privacy section) |
| §6 personal information in recognised content | The model flags `possible_personal_information`; the student is warned, not blocked. | Extraction plan v2 §4.6 |

## Not adopted

- **§7 storage lifecycle:** the 12-month inactivity archive and the reactivation scheme.
- **§9 a dedicated, versioned Upload Policy document:** disclosure uses the Terms and Privacy Policy plus the consent notice.
- **§3 internal-improvement permission as a granted use:** never approved. It remains an open question (below), not a permission.

## Still open: mapped to the governance backlog

The draft's §12 review questions that no later record answers:

| Draft question | Backlog item |
|---|---|
| Q1 whether uploads may be used for internal Cramapple improvement; Q8 whether Terms/Privacy marketing and public-publication language should be narrowed to private study use | GOV-001 (student-upload copyright and reuse rules) |
| Q3 whether extracted text and derived data outlive a deleted upload; Q4 what counts as account expiration; Q5 archive storage, access and restore; Q6 deletion-completion period and backup expiry | GOV-002 (retention for uploads; learner deletion and revocation) |
| Q1 again, as a dataset question: requirements for any anonymous or deidentified improvement dataset | GOV-002 (improvement-dataset requirements) |
| Q7 whether providers may retain submitted content or use it for model training | GOV-003 (provider retention, training and minor-data terms) |
| Q9 the evidence and quality threshold before a proposed classification selects library teaching content | No backlog owner yet. Learning-quality question for the Product Owner. |
| Q10 accessibility alternatives for students who cannot use the camera or document upload | No backlog owner yet. Product/accessibility question. |

Q2 (is voluntary upload enough as opt-in?) was answered in practice by the 2026-09-23 direction: simple non-blocking consent copy.
