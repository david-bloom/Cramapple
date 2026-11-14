# Session close — Unit 5 question release and serving-label census (2026-11-14)

## 1. Current task

Finish Calculus AB and BC Unit 5, then Biology Unit 5, with new questions published topic by topic to Production; answer which subjects and units still need serving labels. Next owner: David Bloom.

## 2. What changed

- Calculus topics 5.1–5.12 received new questions in separate AB and BC served packs, with identical new content across the two packs. The last three topics, 5.10–5.12, were completed in this session. The old AB 5.11 R1 item `apcalcab-mcq-039` was retired after replacement. Full per-topic record: `docs/product/CALCULUS_AB_BC_UNIT5_TOPIC_RELEASE_STATUS_2026_11_12.md`; authorization: `APPROVAL-0268`.
- Biology topics 5.1–5.5 received 60 new R2/R3 MCQs, 12 per topic. The before audit found zero R1 items to retire. Full per-topic record: `docs/product/BIOLOGY_UNIT5_RELEVELING_STATUS_2026_11_13.md`; authorization: `APPROVAL-0287`.
- PR [#658](https://github.com/david-bloom/Cramapple/pull/658) contains the final Calculus packages and evidence; PR [#659](https://github.com/david-bloom/Cramapple/pull/659) contains Biology. Both are merged to `main`.

## 3. What was verified

- Every Calculus Unit 5 topic in both packs has at least 12 published MCQs with valid serving labels. Biology has 65/65 published and valid-serving Unit 5 MCQs: 5.1 13/13, 5.2 12/12, 5.3 12/12, 5.4 16/16, 5.5 12/12.
- Each new package passed structural validation and the owner-approved model checks, draft and post-publish payload hashes, a rolled-back publish rehearsal, validated serving labels, and the Production student selector. Independent Production counts verified the final topic totals. The Calculus AB 5.4 package had one blind-solver letter disagreement whose reasoning supported the recorded key; the per-topic status documents preserve that exception.
- A fresh read-only Production census across all ten subjects found **4,836/4,836 currently published, student-eligible items** with an active validated, hash-fresh serving label. Thus **no subject or unit has a remaining serving-label gap in that scope**. Another 129 published teaching-only items lack such a label; they are excluded from student question serving.

## 4. What remains open

No Unit 5 publication or student-item serving-label work remains. Optional subject-expert spot review and signed-in app rendering review were not performed in this session.

## 5. Blockers and risks

No blocker. David authorized a one-time exception from the standard four-checker/planted-control gate for these Unit 5 batches. The model difficulty tiers are uncalibrated; no subject-expert review is claimed. The 129 teaching-only items should not be mistaken for student-serving gaps.

## 6. Files changed or checked

Changed: the Calculus and Biology Unit 5 package folders under `scripts/content-seed/`, the two status documents named above, the release approval records, `docs/activity_log/ACTIVITY_LOG.md`, and `docs/INDEX.md`. This closeout adds only this handoff, an activity entry, and an index pointer. Checked: `prompts/CLOSE_SESSION_PROMPT.md`, `docs/team_charter/CRAMAPPLE_SESSION_START.md`, and the current merged PR states.

## 7. Commands, queries, and results

- `process_batch.sh` validated, built, blind-solved, and tier-audited each new topic package; final packages had no R1, duplicate, or disputed-key flags. The AB 5.4 blind-letter exception is recorded in the Calculus status document.
- `exec_package.py` published each topic to Production project `pcntajvbdfqhbeewmdry`; preflight, hashes, rehearsals, validated labels, and selector checks passed.
- Independent read-only SQL counted published versions with validated, hash-fresh active serving labels by topic, then all ten exam packs: 4,836/4,836 student-eligible published items had a valid label. Teaching-only count: 74 labeled, 129 not labeled.
- `gh pr view 658` and `gh pr view 659` both returned `MERGED` on 2026-11-14.

## 8. Approval state

The Production writes were authorized by David's topic-by-topic instruction and the named one-time QA exception, recorded in `APPROVAL-0268` and `APPROVAL-0287`. No further approval is pending for this completed release.

## 9. Exact next step

David can choose whether to request a subject-expert or signed-in student-app spot review of the now-live Unit 5 questions. No publication or label repair is queued.

## 10. Do not touch next session

Do not rerun the completed Production packages or treat the 129 teaching-only items as a student-serving label backlog. The hold on Physics 2 and Physics C content work remains in force. Do not overwrite the unrelated uncommitted files in the shared `/Users/davidbloom/Documents/Cramapple.nosync` checkout; this closeout was prepared in a clean worktree from current `origin/main`.
