# BC image mirror and Biology Units 1–3 audit — checkpoint

**Task:** WORK-BC-IMAGE-MIRROR-BIOLOGY-U13. **Branch:** `codex/question-images-bc-biology-u1-u3`.
**State:** Exact shared BC mirror is live; bounded Biology conductor audit completed with findings, ready for independent review. No whole-question certificate or Done decision.

## Changes and verification

David asked to mirror AB images into BC and audit Biology Units1–3 only. The exact shared question `apcalcbc-mcq-ab-060` explicitly references AB's exact source version under APPROVAL-0090. Stem/stimulus/choices match; same-suffix BC questions otherwise have different data. Under APPROVAL-0183 the existing private AB v2 PNG was attached to BC, with BC-version-specific approved accessibility metadata and a required/approved decision. Nothing was copied/uploaded or drawn; no question/scoring/taxonomy/label changed. Source/path/choice guards and attachment/recovery mutation rehearsals passed. Six original approved objects remain untouched. The live BC practice page displays and decodes the exact hash-named image and correct alt text. Desktop screenshot/measurements are saved. Chrome disconnected during the phone-viewport step, so no new narrow-browser PASS or viewport-reset confirmation is claimed.

Biology report: [BIOLOGY_U13_QUESTION_VISUAL_AUDIT_2026_10_16.md](../qa/BIOLOGY_U13_QUESTION_VISUAL_AUDIT_2026_10_16.md). Complete presentation review of221 canonical-mapped published versions; four later-unit serving conflicts retained as boundary exceptions,217 strictly in scope. No confirmed missing prompt-image file among the complete questions. Existing S-003 image exists/downloads but lacks metadata and is omitted by deployedv41;15 canonical-scope legacy FRQs lack actual instructions (14 strictly in scope). Image need for those incomplete prompts remains undetermined. Full paging finds193 practice candidates,192 after image gating; all22 teaching-topic RPC selections match audited versions. Browser checks cover representative Biology3.4 MCQ, FRQ fallback and worked-example routes, using the owner admin profile in student-facing views. No answers submitted, no student-authorization/scoring/expiry certification. Source drift recheck:221 unchanged.

## Limits, approvals and next step

The Biology work was read-only for question/asset/label data. No new Biology image, source repair, metadata approval, paid run, migration or frontend/backend deployment occurred. Four conflicting later-unit labels and two unassigned graph exercises were preserved as boundary records; no later-unit or other-subject audit was undertaken. Reference-note diagrams remain outside question-image scope.

Two questions were sent to David during execution: whether different BC questions should get newly adapted diagrams, and whether to authorize one fresh read-only QA agent. Neither has been answered at this checkpoint. **Do not treat silence as either authorization.** No subagent was started and the conductor's review is not relabeled independent.

Next owner David/content maintainer: authorize and scope recovery of the actual instructions for the14 strictly in-scope legacy FRQs, starting with S-003; only then decide its required diagram and metadata repair. A fresh QA agent may challenge this packet once authorized. New BC drawings are separate from the completed exact mirror. The broader image-completeness task stays open.

## Local and live state

All durable artifacts are under `scripts/image_readiness/biology-u1-u3-2026-10-16/`, `bc-ab-mirror-2026-10-16/`, `storage-evidence/` plus `verify-audit-storage.mjs`. Download/signing credentials stayed in process memory; no token or signed URL is saved. Only public object paths/checksums are retained. Current `student-session-items` isv41, with teaching-image and current-answer branches; no function was redeployed.

Temporary QA changed the owner's selected subject/positions through the UI. Biology was restored through the UI to1.4. After Chrome disconnected, a guarded exact-user/exact-pack restoration returned BC to Unit2 with no topic and the active subject to the original Physics1 pack; Biology1.4 and Physics1 position2.3 were confirmed. No answers/grades were written. Temporary learning sessions remain; do not delete them casually.

Verification commands: `prepare.py` asserts exact source/choice/provenance and generates guarded SQL; `write_review.py` reconciles221 version identities and explicit classifications; `check-delivery.mjs` executes the exact deployed pure delivery gate; storage helper verifies downloads/checksums/public denial. `git diff --check` passes. Source/scoring/choice/taxonomy invariance is verified inside the Production transaction. Browser screenshot shows the complete mirrored graph and BC context.

Do not overwrite approved objects, rerun the now-one-shot attach, alter question/scoring/taxonomy data, promote labels, bypass missing-image metadata, publish app main or expand beyond Biology Units1–3 from this handoff. Recovery SQL is guarded and unexecuted except for its successful ROLLBACK rehearsal. The original dirty primary checkout was not edited.
