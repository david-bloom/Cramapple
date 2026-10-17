# Biology FRQ003 image delivery — applied

**Production:** `pcntajvbdfqhbeewmdry`, 2026-10-17 12:13:36 UTC.
**Authority:** [APPROVAL-0184](../../docs/activity_log/APPROVAL-0184_BIOLOGY_FRQ003_IMAGE_DELIVERY_2026_10_17.md).
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
