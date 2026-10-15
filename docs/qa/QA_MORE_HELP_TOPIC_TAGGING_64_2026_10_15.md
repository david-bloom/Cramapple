# Independent64-topic load source review — 2026-10-15

Reviewer `/root/grounding_final_qa`. **Proposed static PASS; ready for actual rollback rehearsals.** No SQL execution PASS is implied and reviewer performed no DB writes.

Reviewed package `scripts/content-seed/more-help-topic-tagging-65-2026-10-15/`: builder, manifest, apply/rehearse/verify, recovery and insert-then-recovery rehearsal.

-64 unique accepted version/cell IDs,20BC44Chemistry; owner-pending `apchem-mcq-043` excluded.
- All source/version/classification hashes, item/registry/serving-label provenance and final BC primaries match frozen review evidence. Eight-field expected mapping MD5s recomputed independently.
- Apply/rehearse SQL bodies are byte-identical; header comments and final COMMIT/ROLLBACK differ.
- Freshness requires exact published latest version, full version-row MD5, taxonomy-relevant source/key/rubric hash, current validated unsuperseded label/version/hash, exact exam-pack UUID and subject, exact subject taxonomy registry/topic, and zero existing cells.
- Short SHARE locks now cover content, labels, registry, exam-pack and subject rows/tables. Content cells use SHARE ROW EXCLUSIVE for atomic64 insertion.5-second lock timeout/30-second statement timeout bound waits.
- Insert changes only new primary topic cells, with model-run provenance and deterministic APPROVAL-0178 decision UUID. No question, unit-label, student, auth or provider changes.
- Postinsert checks exact64 mapping/validation fields and unchanged version/source fingerprints.
- Recovery deletes only the deterministic64 new cell IDs after expected mapping/source guards, rejects additional cells and human validator changes, and asserts restoration of original zero-cell state. Recovery remains unexecuted absent a current recovery decision.

Initial static findings (label race, missing pack/subject-registry linkage, recovery human-validator drift) were corrected before this verdict. Actual successful insert/rollback and insert/inverse/rollback evidence remains required before Production commit.

## Executed rehearsal checkpoint

The conductor reports actual Production transaction rehearsals: a deliberately wrong first-version MD5 rejected before insertion with `Stale or changed question source`; the unchanged64-row body inserted/verified64 and rolled back; insert+guarded inverse verified restoration of original absence and rolled back. An initial recovery-tool request-state expiration was treated as uncertain, followed by a fresh zero-cell read and a successful full retry rather than assuming failure or success.

I independently reran the SELECT-only postcheck after these rehearsals: **64 planned /0 exact inserted cells /64 unchanged sources**. This corroborates no committed batch and unchanged source hashes. I did not independently execute write rehearsals.

**Updated proposed PASS for the exact guarded64-row write under APPROVAL-0178**, using the already-reviewed/rehearsed body with COMMIT as its sole transaction-finalization difference. Require the same immediate postcommit64/64/64 verification and preserve owner-pending043 exclusion. This does not authorize unrelated content or unit-label changes or mark the broader More help release complete.

## Independent postcommit verification

After the conductor's successful commit, I independently reran the exact SELECT-only verifier: **64 planned /64 exact cells /64 unchanged sources**. This supersedes the precommit0-cell snapshot above for current live state. A separate read verifies all64 batch cells retain primary/validated/unsuperseded/null-skill/null-human-validator state with a nonnull validation timestamp.

**Proposed QA PASS for the64 accepted topic assignments and source invariance in Production.** This is the metadata batch outcome, not a full More help release or a claim that new reference content exists for every newly mapped topic. Owner-pending043 remains outside the accepted batch.
