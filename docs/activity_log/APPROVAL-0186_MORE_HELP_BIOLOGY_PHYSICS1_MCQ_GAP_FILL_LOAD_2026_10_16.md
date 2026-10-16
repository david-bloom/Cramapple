# APPROVAL-0186 — Load 52 Biology and Physics 1 practice MCQs to Production (2026-10-16)

**STATUS: EXECUTED 2026-10-16** (first attempt blocked by the tool permission classifier; owner granted a retry and it ran).
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

## Executed
Both chunks committed and independently verified on Production. Biology: found 32/32, text match 32/32, published 32/32, labels 32/32, topic cells 32/32, skill cells 28/28, difficulty 32/32. Physics 1: 20/20 on every check, skill cells 20/20.
Gap re-query (practice MCQs, worked examples excluded): Biology 2.2 / 2.4 / 2.5 / 2.9 now 8 each (were 0); Physics 1 1.1 = 8, 1.3 = 4, 2.2 = 8 (were 0). Biology 2.10 still 1 (not in scope).
Not done: blind re-judge sample; a service_role selector call per subject.
