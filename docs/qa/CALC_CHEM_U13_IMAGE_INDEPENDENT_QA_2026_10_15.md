# Independent question-image QA — 2026-10-15

Reviewer: fresh read-only agent `/root/independent_image_qa`, explicitly authorized by David. Report returned to the conductor verbatim below.

**PASS for the two prepared attachments’ source, artifacts and transaction design. Live visual-completeness certification remains pending release and delivery verification.**

Independent coverage was **198 distinct questions: 115 Calculus AB and 83 Chemistry**:

- All 126 visual/construction signal-positive questions.
- All 31 signal-negative questions classified as tables, external references, structures or other special representations.
- A systematic sample of 41 remaining signal-negative formula/context questions, selecting every fourteenth row in inventory order.

This includes all 67 table classifications, all 17 owner-accepted external-reference classifications, all ten unit resolutions and all six source/visual pairs. **I did not independently reread all 726 sources.** Mechanically, I verified all 726 inventory/review identities: unique versions and keys, matching review version IDs, no missing reviews or orphan reviews, and matching recorded ledger file hashes.

I found **no additional required visual among the 198 independently reviewed questions**. Meaningful negative controls included complete tabular derivative data (`apcalcab-mcq-u2n-004` and variants), formula-defined asymptotes, prose-defined Lewis structures, graph-description answer choices, and student-constructed ICE tables/titration curves. Rendering their requested answers would introduce answer disclosure.

All six compact PNGs were inspected with `view_image` against their complete source pairs. The graphs preserve the supplied branches, endpoints, open/filled markers and asymptotic behavior. The unspecified interior curves in `apcalcab-frq-u13g-1-3` are acceptable illustrative choices because the assessed endpoint limits, continuity and monotonicity remain fixed.

The new Chemistry model correctly shows **P: six Na⁺ and six Cl⁻; Q: four Ca²⁺ and eight Cl⁻**, in equal-size boxes explicitly representing equal volumes. Charges remain readable without color. No calculated concentration or requested water orientation appears. Both new images and their descriptions repeat givens without annotating the requested answers. The earlier Chemistry model has eight versus sixteen particles with the correct 100/200 mL labels.

I independently verified recorded hashes for all 14 SVG/PNG layout pairs, both renderers and both specification files. I did **not** rerun render/build tests, which would rewrite artifacts during this read-only review. Pixel inspection covered the six compact PNGs, not every full/expanded rendering or live phone layout.

All ten unit resolutions are acceptable **audit-membership judgments**, with serving labels preserved. In particular, the conservative Units 2/4 treatment of `apcalcab-frq-u13-003` is defensible because part (c) requires interpreting the instantaneous rate in context; this aligns with [College Board Topic 4.1](https://apcentral.collegeboard.org/media/pdf/ap-calculus-ab-and-bc-course-and-exam-description.pdf). The inclusion of `apcalcab-frq-u13-006` under derivative estimation is also defensible. These judgments do not constitute serving-label validation.

Two transaction-design findings were corrected during review:

- Attachment/rehearsal now pin the complete frozen source digest, including ordered choices, authored parts, full prompt/package and image path, with appropriate row locks and choice invariance checks.
- Recovery now locks versions, choices, metadata and requirements; checks the frozen source with **only image_path normalized to NULL**; and requires exact released metadata/requirement row hashes.

The final reviewed SQL SHA-256 values are:

- Attachment: `e87cc020a2629dd21ae83c5731ddf18681a1ae4c6d954feb8be938fc35da2178`
- Rehearsal: `7d9698383aa9858bc6991f9f2ab72725e9071d2cb85e3a748dc55eb170216162`
- Recovery: `76b4edc39f4c7233a2a91356d32b2712bb89bf88684e66f2ff4eb416d7e2ddf8`

Attachment and rehearsal match except for their terminal COMMIT/ROLLBACK. Recovery’s `NOT_RELEASED` placeholders deliberately prevent execution until actual released row hashes are captured. SQL execution and rollback behavior were not independently exercised.

The minimal periodic-table link passes source review: Chemistry-only, inside the existing assistance/loading gate, descriptive new-tab text, and `noopener noreferrer`. Its [official College Board PDF](https://apcentral.collegeboard.org/media/pdf/chemistry-periodic-table-2020.pdf) loaded successfully. App CI/publication remains the release owner’s separate gate; the owner-accepted periodic-table dependency does not block these image attachments.

**No remaining source/artifact blocker was found for attaching the two named visuals.** Final certification still requires successful SQL rehearsal, verified private/signed bytes, captured recovery ownership hashes, and actual desktop/phone delivery evidence. This review does not certify live delivery, failed/expired-image scoring behavior, submitted-answer behavior, or the separate subject-switch stale-question defect.
