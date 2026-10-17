# APPROVAL-0191 — Version-matched image metadata for the S-003 v2 draft (2026-10-17)

**STATUS: EXECUTED 2026-10-17 by the owner (part 1 and part 2).** Requested by David Bloom in chat 2026-10-17 ("prepare the S-003 metadata script"). Follow-up to APPROVAL-0189 (v2 draft with question instructions) and APPROVAL-0190 (v1 image metadata).

## Why
APPROVAL-0190 approved image metadata for S-003 v1 only (`c4da3229…`). The APPROVAL-0189 draft v2 (`bf317c96-1289-4803-b71f-b0aff4620844`) points to the same corrected image (verified identical path and private object) but has no metadata or visual decision of its own, so the deployed image gate would withhold it again once published.

## Two parts
1. `scripts/content-seed/reviewer-qa-remediation/20261017_apbio_frq_s003_v2_image_metadata_part1_unapproved.sql`: copies v1's already-approved alt text and long description onto v2 as an UNAPPROVED row (`approved_by/approved_at` null). Guards: v2 is the APPROVAL-0189 draft successor of v1, same image path, no existing rows, private PNG object present. Records no approval; the gate still withholds v2.
2. `..._part2_OWNER_APPROVE.sql`: **owner-run only.** Approves that row and inserts the required visual decision (`yes` / `approved`), as APPROVAL-0190 did for v1. The agent does not run or generate approval records.

## Order of operations
Rehearse part 1 (rollback), run part 1, review the v2 question and image, run part 2, then publish the S-003 draft with the other 13 (owner step 2 of APPROVAL-0189). Publishing v2 before part 2 leaves the image withheld.

## Rollback
Part 1: delete the v2 metadata row. Part 2: delete the v2 visual decision and null `approved_by/approved_at` on the metadata row.

## Executed
Part 1 ran at 14:08 UTC (the unapproved v2 metadata row was created; a second run correctly stopped at the guard `v2 already has metadata`). Part 2 ran at 14:22 UTC: metadata approved and visual decision `yes`/`approved` recorded for v2 (`bf317c96-1289-4803-b71f-b0aff4620844`). S-003 v2 was then published under APPROVAL-0189 step 2 and its image path, metadata and visual decision were read back as consistent.
