# APPROVAL-0190 — Biology FRQ003 image availability

**Date:** 2026-10-17. **Approved By:** David Bloom. **Decision:** Approved.
**Related Task:** [WORK-BIOLOGY-FRQ003-IMAGE-DELIVERY](../tasks/WORK-BIOLOGY-FRQ003-IMAGE-DELIVERY.md).
**Status:** Applied and verified, 2026-10-17 12:13:36 UTC; exact operation only.

Owner instruction: “Confirm both images should be served and make them servable.” This authorizes the necessary two-version Production image repair after image/source review; no repeat confirmation is required.

Scope: current S-003 and L-003 version4 only. Reuse L-003's checksum-confirmed original pedigree. Replace S-003's incorrectly located NADPH product with the reviewed deterministic reconstruction in an immutable private object, retaining its original file. Set exact-version approved accessibility metadata and required/approved visual decisions; swap only S-003's image path. Use owner profile `f5a26c6b-3566-4d58-9e97-979fbb947564`, verified admin/David, for the recorded owner-authorized image decisions.

Required implementation checks: private signed downloads/public denials; source/scoring/taxonomy/label/retired-review invariance; guarded attach and recovery rehearsals; read-back and deployed delivery-gate proof. This approval does not authorize schema, function/app deployment, learner-state changes, prompt/key/rubric re-authoring, overriding retired decisions or certifying either whole question. S-003's missing instructions and L-003's inheritance-inference critique remain explicit follow-ups.

[Applied result and remaining content limits](../qa/BIOLOGY_FRQ003_IMAGE_DELIVERY_RESULT_2026_10_17.md). Two metadata/visual approvals and one S-003 image-path swap are live; signed checksums, private denial, source invariants and ordinary-mode image gate pass.

**Identifier correction:** The initial pushed preparation/SQL comments accidentally used APPROVAL-0184, already assigned to the More help migration/ledger repair. APPROVAL-0190 is the canonical identifier for this two-image operation. This corrects bookkeeping only: the owner instruction, approved scope, approver, operation and verification receipts are unchanged; the earlier More help record is untouched.

## Horizontal extension — owner requested, 2026-10-17

Owner: “This image will render awkwardly. Can you reframe it to horizontal?” The reviewed replacement is a 4:3 landscape, 2400×1800 PNG with lumen above and stroma below. NADPH/ATP remain on the stroma side; proton and electron directions are preserved. All 17 text elements have no browser-measured clipping or overlap; 84 source units give 16.1px labels at 230px image width. PSII/ETC/PSI abbreviations are expanded in the accessible long description.

Fresh Production discovery found S-003 v1 retired and v2 `bf317c96-1289-4803-b71f-b0aff4620844` published at 14:26:47 UTC by the separate APPROVAL-0189 instructions repair. V2 now has question parts (a) and (b). This extension targets only that current v2 image path and adds its exact-path approved metadata, preserving its newly authored instructions/scoring, existing metadata/visual decision, retired S-003 v1 and both L-003 controls. The earlier missing-instructions statements describe the pre-publication state.

Preparation: `horizontal-manifest.json`, `horizontal-before.json`, `horizontal-visual-review.json`, `horizontal-attach-production.sql`, `horizontal-rehearse.sql`, `horizontal-recovery.sql` in the release packet. The original tall v2 asset and records remain historical evidence. Recovery restores the current published version's tall image path while retaining both immutable assets and metadata. Apply only after immutable upload and guarded rollback rehearsal; no further owner confirmation is required for the requested image reframe.

**Horizontal release applied:** 2026-10-17 15:53:08.770922 UTC. Exact immutable path: `questions/apbio-frq-s-003/v3/1e362c43a81c1f35ad88738751ccceae83c7e6b0c7a05d286b923fb2db737234.png` (132,560 bytes). Guarded attach/recovery rehearsal passed under ROLLBACK, then the current-v2-only image swap and one new approved metadata row committed. Existing metadata/visual decisions, question/scoring/taxonomy/labels, retired S-003 v1 and both L-003 controls are unchanged. Live signed PNG SHA-256/dimensions match and unsigned access returns 400. Exact deployed v41 ordinary-mode gate: 2 deliverable / 0 omitted.

[PR #494](https://github.com/david-bloom/Cramapple/pull/494), branch `codex/biology-frq003-horizontal`. Evidence uses `horizontal-*` filenames, with `verify-horizontal.mjs` for reproducible invariants/gate checks. `horizontal-attach-production.sql` is one-shot and already applied; do not replay it. `horizontal-recovery.sql` restores the prior tall path while retaining both immutable assets and metadata. Local 230px/620px layouts pass (172.5px/465px image heights); no authenticated app/learner or independent complete-question QA is claimed.
