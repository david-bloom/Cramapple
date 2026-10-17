# Biology FRQ S-003 / L-003 images — Production repair result

**Date:** 2026-10-17. **Status:** Image availability repair applied and verified; independent QA and complete-question issues remain open.
**Approval:** [APPROVAL-0184](../activity_log/APPROVAL-0184_BIOLOGY_FRQ003_IMAGE_DELIVERY_2026_10_17.md), David: “Confirm both images should be served and make them servable.”
**PR:** [#483](https://github.com/david-bloom/Cramapple/pull/483).
**Task / Branch:** [WORK-BIOLOGY-FRQ003-IMAGE-DELIVERY](../tasks/WORK-BIOLOGY-FRQ003-IMAGE-DELIVERY.md), `codex/biology-frq-003-image-delivery`.
**Environment:** Production `pcntajvbdfqhbeewmdry`; commit applied **2026-10-17 12:13:36 UTC**.

## Result

Both exact current versions now pass the deployed v41 image gate in ordinary mode (`qaMode=false`), with approved accessibility metadata and required/approved visual decisions. Both private signed downloads return 200 and match the reviewed SHA-256 values; unsigned URLs remain denied. This establishes image availability through the existing image contract, not a full app/student-entitlement or whole-question certificate.

| Question / current version | Image decision | Current bytes |
| --- | --- | --- |
| S-003 / `c4da3229-8d7a-4cf9-8738-68b62af20372` | Corrected deterministic schematic; new immutable private path | 720×2240 PNG, 80,199 bytes; SHA-256 `f36f0e3337f393e1652e4d547eda5f2ac651fc740d56b13cc685aec8d73f8100` |
| L-003 v4 / `0c9b6720-639f-4dc4-8fab-c66e65271b1d` | Existing pedigree matches the written stimulus; original bytes/path reused | 1076×999 PNG, 50,281 bytes; SHA-256 `6cf98d6964144ae0946c729176917120efe1a0925454eb443ff5b88a02f8553c` |

The only published-version column changed was S-003's `stimulus_image_path`, to `questions/apbio-frq-s-003/v2/f36f0e3337f393e1652e4d547eda5f2ac651fc740d56b13cc685aec8d73f8100.png`. L-003 remains at `Biology/FRQ/APBIO-FRQ-L-003.png`. The two originals remain private and intact. There was no app/function/schema deployment or bucket-permission change.

## Validation of the images

The original S-003 schematic put its NADPH-production annotation/arrow on the labeled lumen side. NADP reduction uses protons from the stroma; proton pumping runs stroma→lumen and ATP-synthase flow runs lumen→stroma. This was checked against [OpenStax Biology 2e §8.2, Figure 8.17](https://openstax.org/books/biology-2e/pages/8-2-the-light-dependent-reactions-of-photosynthesis). Approving the old pixels unchanged would have endorsed an incorrect compartment. A fresh code-native SVG reconstruction corrects that placement and retains the four named complexes and process directions. No original bitmap was modified or overwritten; no model image-generation or paid calls were used.

The corrected SVG was visually inspected and browser-measured:31 text elements, no clipping or text overlap; 26-unit meaningful labels give 16.611px at 230 CSS pixels image width. SVG/PNG/manifest reproduce byte-identically. This is local diagram evidence; a live phone display must retain natural height/enlargement and must not shrink the tall diagram below the reading floor.

L-003's twelve individuals, affected states, sexes, pedigree lines and legend match its written stimulus. The new long description supplies equivalent diagram information and explicitly distinguishes the textual known-carrier condition from the figure’s shading. Its original layout was retained; no new phone-reading certificate is claimed.

## Release and verification

[Evidence / release packet](../../scripts/biology-frq003-image-delivery-2026-10-17/README.md): exact source/criteria/taxonomy/label hashes, image specs/build hashes, upload/checksum receipts, before/after metadata, reversible SQL, rehearsal and commit receipts, and gate proof. An initial connector request failed before any metadata appeared; the exact rehearsal was retried successfully after a fresh zero-row read.

The rehearsal applied the two metadata rows and two visual decisions, checked image delivery preconditions and content invariants, then exercised recovery and ROLLBACK. The Production transaction repeated its guards and committed. Live read-back confirms the intended rows and paths. Complete question/scoring fields, content items, taxonomy/serving labels and the retired L-003 v3 metadata/disapproved decision were verified unchanged. Both 900-second signed downloads match the checked images; public reads return 400 because the bucket remains private. Credentials and signed URLs were never committed.

The deployed `student-session-items` remains version41, and its shared gate source matches the tested source SHA-256 `f00785f0dd2c7422f81fb45b1a75c8209a468400419076f9dea810a23e2e3fe0`. Execution against live metadata read-back returns 2 deliverable / 0 omitted in ordinary mode. This is not a real-student JWT/HTTP/browser test or proof that all other selector/entitlement gates permit these questions.

## Content limits and next owner

S-003 still lacks actual question instructions. L-003's retired-version reviewer challenged the pedigree-only autosomal dominant/recessive inference; the text supplies a known-carrier condition, but that criticism is not erased or resolved by image metadata. New visual approval means the diagram matches the stated stimulus; it is not a grading-key or complete-question quality pass. No prompt, rubric, scoring or learner state was edited. The exact owner request covers L-003 as well as S-003; it does not expand into a later-unit Biology census.

**Next owner: content owner / independent QA.** Resolve S-003's actual instructions, reconcile the L-003 inference critique and complete authenticated desktop/phone delivery checks. The two-image availability operation is applied; no further owner approval is needed for it. Task closure and a whole-question certificate have not been asserted. Guarded recovery is available and retains all image objects and retired review records.
