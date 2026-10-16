# APPROVAL-0186 — Load 52 Biology and Physics 1 practice MCQs to Production (2026-10-16)

**STATUS: APPROVED, NOT YET EXECUTED** (the publish command was blocked by the tool permission classifier; update this record when it runs).
**Approver:** David Bloom (chat, 2026-10-16: "Approved").

## What
Publish the accepted output of the generate-and-select run `more-help-gap-fill-bio-phy1-2026-10-16` (see `scripts/content-seed/more-help-gap-fill-bio-phy1-2026-10-16/RESULTS.md`):
- Biology: 32 items (8 seeds `APBIO-MCQ-132..139`, 24 variants `APBIO-MCQ-SV-nnn-vk`), topics 2.2, 2.4, 2.5, 2.9.
- Physics 1: 20 items (5 seeds `apphy1-mcq-051..055`, 15 variants `apphy1-mcq-sv-nnn-vk`), topics 1.1, 1.3, 2.2.
Via `scripts/content-seed/publish_mcq_batch.py publish --env prod --approval APPROVAL-0186 --confirm-production`. No human review (DECISION-0102); difficulty `provisional_model`; variants inherit seed labels.

## Evidence before the write
Planted-defect controls 6 of 6 caught; 52 of 52 accepted items passed lint, four non-author solves and audits, and the author-family veto. Production preflight clean (no key collisions, packs and owner resolved). Production rehearsals rolled back: Biology `REHEARSAL OK: published=32 skill_cells=28`, Physics 1 `REHEARSAL OK: published=20 skill_cells=20`. Blind re-judge sample NOT run.

## Rollback
Retire the 52 `content_key`s (new versions are additive; no existing item changes). The load transaction is per chunk, so a failure leaves nothing behind.

## After the write (to do)
`publish_mcq_batch.py verify` for both plans; call each subject's real selector as `service_role`; re-run the gap query; note that a new version flips an old label stale only for re-published items (none here).
