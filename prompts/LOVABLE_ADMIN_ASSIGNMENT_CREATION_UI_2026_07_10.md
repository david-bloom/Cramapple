# Lovable — Admin Assignment Creation UI (Reviewer Portal)

Add the missing admin assignment-creation surface for the Cramapple reviewer
portal/admin experience.

## Context

Production backend is Supabase project `pcntajvbdfqhbeewmdry`. The canonical
content review workflow is `content_review_*`, not legacy
`review_assignments` / `review_decisions`.

The frontend already has `src/lib/review.functions.ts` with
`createAssignmentsForVersion`. Use that existing server function. Do not loosen
or bypass its contract.

## Required Contract

`createAssignmentsForVersion` must be called with:

- `versionId`: `content_item_version_id` UUID
- `reviewerIds`: exactly two distinct tutor reviewer UUIDs
- `reviewKind`: `mcq` or `frq`
- `dueAt`: optional ISO/date string
- no stage other than `tutor_question`

The backend edge function is `assign-for-review`. It creates exactly two
`tutor_question` assignments sharing one `blind_group_id`.

## Build

Add a focused admin-only page or dashboard section for assignment creation.
Keep it quiet, utilitarian, and consistent with the existing dashboard/reviewer
styles.

Minimum UI:

- content item version UUID input
- reviewer A UUID input
- reviewer B UUID input
- review kind selector (`mcq` / `frq`)
- optional due date input
- submit button
- result panel showing `blind_group_id`, inserted assignment count, and
  assignment IDs
- clear validation/error messaging

Client-side validation:

- require all three UUIDs
- require exactly two reviewer IDs
- reviewer A and reviewer B must be distinct
- require review kind
- do not allow/offer stage selection; this UI is tutor-question assignment only

## Do Not Use

- `review_assignments`
- `review_decisions`
- `user_roles`
- `has_role(...)`
- direct browser writes to review tables
- `grade-frq`

## Verification

After implementation, verify:

1. The admin page is reachable only for admins.
2. The submit path calls `createAssignmentsForVersion`, not raw Supabase table
   writes.
3. The payload contains exactly `versionId`, two reviewer IDs, `reviewKind`, and
   optional `dueAt`.
4. A successful call displays the returned `blind_group_id` and assignment
   count.
5. More/fewer than two reviewers cannot be submitted from the UI.
