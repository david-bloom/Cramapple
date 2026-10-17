# Biology FRQ S-003 / L-003 image delivery

**Owner:** Codex / Main Conductor. **Tier:** Hard-Gate. **Status:** In Progress.
**Created / Approved:** 2026-10-17. **Product Owner:** David Bloom.
**Branch:** `codex/biology-frq-003-image-delivery`. **PR:** pending creation.
**Approval State:** APPROVAL-0184. Owner directed: “Confirm both images should be served and make them servable.” No further approval is needed for this exact image repair.

## Scope and acceptance

Make the existing image contract servable for exactly two current published Production versions: S-003 `c4da3229-8d7a-4cf9-8738-68b62af20372` and L-003 version4 `0c9b6720-639f-4dc4-8fab-c66e65271b1d`. Both original private PNGs download with known SHA-256 values, but both current versions lack matching asset metadata and visual decisions.

L-003's existing pedigree matches the written stimulus and is reused unchanged. S-003's original image incorrectly places NADPH formation on the lumen side; a new deterministic SVG/PNG reconstruction places it in the stroma and preserves the old PNG. Correcting this finding is within the owner-requested image validation/servability slice. The new diagram retains the stated PSII/ETC/PSI/ATP-synthase schematic, with no question/scoring changes.

Add exact-version approved alt/long descriptions and required/approved image decisions; change only S-003's image path. Preserve private storage, all original files, question/scoring fields, item/pack status, taxonomy/labels and retired L-003 version3 decisions. No app/function/schema deployment, learner-state action, content re-authoring or broader audit.

## Verification and recovery

[Release packet](../../scripts/biology-frq003-image-delivery-2026-10-17/): reviewed source hashes, checksummed assets, storage receipts, exact guarded attach/rehearsal/recovery SQL. Rehearse attachment and recovery with ROLLBACK before commit. Verify new metadata/visual decisions, immutable-object checksum and unsigned denial, and the exact deployed delivery gate in ordinary mode. Record real HTTP/browser limits accurately.

Local corrected SVG:31 text elements; no clipped or overlapping text;26-unit labels give16.611px at230px image width. L-003 is visually inspected against the full written pedigree. This is conductor review, not fresh independent QA.

## Known content limits

S-003 still contains a scenario without actual question instructions; this image repair does not recover them. A retired-version reviewer questioned L-003's inheritance inference (diagram alone does not distinguish autosomal dominant/recessive; the text supplies a known-carrier condition). The historical disapproval is preserved. Neither image approval is a complete-question, answer-key, ordinary-student entitlement or phone-reading certificate.

**Next owner:** Codex for the scoped live repair and verification; content owner for the separate question-quality issues. **Done Decision:** not made; independent QA remains open.
