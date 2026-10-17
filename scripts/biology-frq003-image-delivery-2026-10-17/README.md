# Biology FRQ003 image delivery — applied

**Current result — 2026-10-17 15:53:08 UTC:** S-003 published v2 (`bf317c96-1289-4803-b71f-b0aff4620844`) now serves the requested **4:3 horizontal** diagram (2400×1800), with exact-version approved accessibility metadata. Live signed SHA-256 matches; unsigned reads remain denied. The deployed v41 ordinary-mode image gate returns 2 deliverable / 0 omitted for current S-003 and L-003. S-003 instructions were separately repaired before this change; L-003 and retired versions remain unchanged. [Horizontal follow-up PR #494](https://github.com/david-bloom/Cramapple/pull/494). Earlier sections below record the initial 12:13 repair.

**Production:** `pcntajvbdfqhbeewmdry`, 2026-10-17 12:13:36 UTC.
**Authority:** [APPROVAL-0190](../../docs/activity_log/APPROVAL-0190_BIOLOGY_FRQ003_IMAGE_DELIVERY_2026_10_17.md).
**Result:** The two exact current versions pass the ordinary-mode deployed v41 image gate; both private image downloads return 200 with reviewed SHA-256 values, and unsigned reads are denied. This is an image-availability result, not a whole-question or ordinary-student/browser certificate.

- S-003 `c4da3229-8d7a-4cf9-8738-68b62af20372` uses the new checksum-addressed PNG in `manifest.json`. The original had NADPH formation on the lumen side. The new SVG reconstruction places it in the stroma, retains PSII/ETC/PSI/ATP-synthase and electron/proton directions, and preserves the old private PNG.
- L-003 version4 `0c9b6720-639f-4dc4-8fab-c66e65271b1d` reuses the original pedigree without changing its bytes or path. The drawing matches its written stimulus. The retired version3 disapproval and metadata remain unchanged.

Two version-matched approved accessibility rows and two required/approved visual decisions were inserted. Only S-003's image path changed. Complete question/scoring columns, content items, taxonomy/labels and the retired control were guarded and verified unchanged.

## Evidence and recovery

`before.json`, `after.json` and `targets.json` pin identities and content/criteria/taxonomy/label hashes. `original-storage-check.json`, `upload-receipt.json` and `live-storage-check.json` bind objects, bytes, private signed downloads and public denials without credentials or signed URLs. `visual-review.json` records the source/diagram review. `rehearsal-receipt.json` and `production-receipt.json` record the rolled-back attach/recovery rehearsal and the actual commit. `delivery-gate-check.json` records both ordinary-mode gate passes against source matching the live deployment.

`attach_production.sql` is **one-shot and already applied**. Do not rerun it. `rehearse.sql` exercised attach and recovery under ROLLBACK. `rollback_production.sql` is prepared with exact path/metadata/decision/source guards; it restores original paths and absent current-version metadata/visual decisions while retaining every private object. It does not change retired rows or erase the earlier reviewer critique.

The corrected S-003 SVG has 31 browser-measured text elements with no clipping/overlap, and 26-unit labels yield 16.611px at 230px image width. This is a local diagram check, not a live phone test; a tall-image height cap must not shrink it illegibly. L-003 retains its original layout and has no new phone-reading certificate.

Reproduce the local build with `node build-photosynthesis.mjs` (`sharp` required; an optional second argument selects a shared Node dependency root). Reproduce the pinned gate/hash assertions with `node verify-delivery.mjs` on a Node version supporting TypeScript stripping. `storage.mjs verify` performs operator signing/download checks through existing CLI access; `storage.mjs upload` is a completed immutable upload, not a routine verification command. Never log credentials or signed URLs.

## Content limits

S-003 still lacks actual question instructions. L-003's earlier review raised an inheritance-inference concern: the diagram alone does not distinguish autosomal dominant from recessive, while the text gives a known-carrier condition. Image approval does not settle that content issue or certify a grading key. No question/rubric re-authoring, learner-state change, schema/function/app deployment, broad Biology audit or task closure occurred. Independent QA and authenticated app/browser checks remain open.

## Horizontal extension — owner requested, 2026-10-17

Owner: “This image will render awkwardly. Can you reframe it to horizontal?” The reviewed replacement is a 4:3 landscape, 2400×1800 PNG with lumen above and stroma below. NADPH/ATP remain on the stroma side; proton and electron directions are preserved. All 17 text elements have no browser-measured clipping or overlap; 84 source units give 16.1px labels at 230px image width. PSII/ETC/PSI abbreviations are expanded in the accessible long description.

Fresh Production discovery found S-003 v1 retired and v2 `bf317c96-1289-4803-b71f-b0aff4620844` published at 14:26:47 UTC by the separate APPROVAL-0189 instructions repair. V2 now has question parts (a) and (b). This extension targets only that current v2 image path and adds its exact-path approved metadata, preserving its newly authored instructions/scoring, existing metadata/visual decision, retired S-003 v1 and both L-003 controls. The earlier missing-instructions statements describe the pre-publication state.

Preparation: `horizontal-manifest.json`, `horizontal-before.json`, `horizontal-visual-review.json`, `horizontal-attach-production.sql`, `horizontal-rehearse.sql`, `horizontal-recovery.sql` in the release packet. The original tall v2 asset and records remain historical evidence. Recovery restores the current published version's tall image path while retaining both immutable assets and metadata. Apply only after immutable upload and guarded rollback rehearsal; no further owner confirmation is required for the requested image reframe.

**Horizontal release applied:** 2026-10-17 15:53:08.770922 UTC. Exact immutable path: `questions/apbio-frq-s-003/v3/1e362c43a81c1f35ad88738751ccceae83c7e6b0c7a05d286b923fb2db737234.png` (132,560 bytes). Guarded attach/recovery rehearsal passed under ROLLBACK, then the current-v2-only image swap and one new approved metadata row committed. Existing metadata/visual decisions, question/scoring/taxonomy/labels, retired S-003 v1 and both L-003 controls are unchanged. Live signed PNG SHA-256/dimensions match and unsigned access returns 400. Exact deployed v41 ordinary-mode gate: 2 deliverable / 0 omitted.

[PR #494](https://github.com/david-bloom/Cramapple/pull/494), branch `codex/biology-frq003-horizontal`. Evidence uses `horizontal-*` filenames, with `verify-horizontal.mjs` for reproducible invariants/gate checks. `horizontal-attach-production.sql` is one-shot and already applied; do not replay it. `horizontal-recovery.sql` restores the prior tall path while retaining both immutable assets and metadata. Local 230px/620px layouts pass (172.5px/465px image heights); no authenticated app/learner or independent complete-question QA is claimed.
