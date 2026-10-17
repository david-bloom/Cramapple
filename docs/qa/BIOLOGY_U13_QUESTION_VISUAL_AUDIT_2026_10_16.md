# Biology Units 1–3 question-visual and delivery audit — 2026-10-16

> **CORRECTION / FOLLOW-UP 2026-10-17:** [S-003 image availability is repaired in Production](BIOLOGY_FRQ003_IMAGE_DELIVERY_RESULT_2026_10_17.md) under APPROVAL-0184; corrected NADPH compartment, approved exact-version metadata/visual decision and ordinary-mode image-gate pass. The F1 missing-metadata finding below is historical. Its missing question instructions remain unresolved; audit counts below are historical, not a new live-catalogue certificate. The same exact-owner-request slice also repairs L-003 image metadata without a broader Biology audit.

**Result:** Source review completed; complete-question delivery cannot be certified.
**Task:** [WORK-BC-IMAGE-MIRROR-BIOLOGY-U13](../tasks/WORK-BC-IMAGE-MIRROR-BIOLOGY-U13.md).
**Environment:** Production `pcntajvbdfqhbeewmdry`, 2026-10-17 UTC / October 16 America/New_York.
**Reviewer:** Main conductor in the implementation session. This is not a fresh independent QA verdict. Independent-agent authorization was requested and has not been received.

## Scope and evidence

David authorized Biology Units 1–3 only. A metadata-only subject census routed the boundary; the source query opened **221 published versions currently mapped by canonical topic resolution to Units 1–3**, including 187 MCQs and 34 FRQs. U1:104; U2:80; U3:37. Every stem, stimulus, written choice, authored FRQ part and supported presentation subtree was read; no keyword screen substituted for reading negative rows. No later-unit source census, other-subject audit, paid model call or Biology content/asset/label write was performed.

Four rows have conflicting validated serving scope that requires later units: `APBIO-FRQ-S-040`, `APBIO-MCQ-024`, `APBIO-MCQ-030`, `APBIO-MCQ-061`. They remain boundary exceptions, excluded from ordinary Unit-3 practice by the existing selector; no later-unit follow-up or relabeling was performed. Thus **217 versions remain inside the strict Units 1–3 boundary after excluding these four conflicts**, with 14 rather than 15 incomplete legacy presentations inside that strict boundary. The 221-row frozen corpus retains their discovery evidence rather than silently discarding them.

Two unassigned graph exercises are explicit boundary records. `APBIO-HDG-2026-GRAPH-008` was checked only to determine scope: it supplies seed-germination counts and asks the learner to construct a dotplot; it has no canonical unit and is not silently assigned to Unit 3. `...-010` has stale unit-8/ecology metadata; its source was not opened. No serving label was promoted.

Artifacts: `scripts/image_readiness/biology-u1-u3-2026-10-16/` contains the corrected inventory SQL/JSON, exact-version review ledger, summary, selector probe/results, deployed gate source/hash/result, source-drift reconciliation and browser evidence. Source recheck: **221 unchanged digests, zero missing/new identities**. Stem/stimulus/parts/prompt/package/choice digest fields match the prior approved audit method; answer-bearing scoring criteria were not treated as authored prompts.

## Findings

**F1 — Existing photosynthesis image is withheld from students.** `APBIO-FRQ-S-003`, version `c4da3229-8d7a-4cf9-8738-68b62af20372`, points to `Biology/FRQ/APBIO-FRQ-S-003.png`. The private object downloads (54,446 bytes, SHA-256 `a04a4f2604635854a864f98a2d919f360e218d79da3b2f5724ad1f384d1abe8a`); its public URL is blocked. There is **no matching `content_asset_metadata` row**. Executing the exact deployed v41 `partitionDeliverable` against frozen records omits this item with `asset_metadata_missing`, even in staff QA mode: missing metadata and unapproved metadata are different cases. The raw practice selector includes it, so this is an active downstream delivery blocker, not merely an unused object. Its existing diagram was visually inspected; resolving its missing question instructions and judging assessment equivalence/readability must precede approving it. Do not simply insert an approval to bypass the gate.

**F2 — Fifteen canonical-scope legacy FRQs contain only a scenario, with no actual question instructions.** Fourteen are within the strict boundary; S-040 is one of the four later-unit scope conflicts above. The affected source keys are S-003,019,021,023,025,026,028,029,032,033,036,038,040,071,080 (all prefixed `APBIO-FRQ-`). `parts[].prompt` / `prompt_text` are absent, and the stem/stimulus do not ask a question. For example S-021 says a student compares amino acid/monosaccharide/fatty-acid structures but supplies neither structures nor an actual instruction; S-026 mentions electron microscopy without giving a task. **Image need is undetermined for these records**, rather than automatically “missing image” or “no image needed.” Do not reconstruct instructions from answer-bearing `frq_criteria.learner_facing_text`. Thirteen pass the ordinary Unit-3 selector and image gate; S-003 is blocked by F1 and S-040 requires Unit 4. Content recovery/re-authoring is a separate approval, outside this audit.

**F3 — Complete tables arrive as flattened prose in the tested question plate.** The Biology 3.4 MCQ (`APBIO-MCQ-128`) shows all light-intensity/oxygen/carbohydrate values, but rows appear in a paragraph rather than a semantic table. A fallback 3.2 FRQ (`APBIO-FRQ-L-012`) likewise shows both enzyme tables as text. No missing numbers were identified in these samples; this is a presentation/readability limitation, not evidence that a PNG is required. The reusable repair should preserve semantic rows/columns rather than rasterize tables. No frontend change was made.

## Source classifications and delivery

Across the 221 mapped/boundary-reviewed records: 159 complete-text questions; 45 complete-table questions; two learner-construction questions with complete input tables; 15 insufficient-instruction FRQs. The strict 217-row subset removes one table question, two complete-text questions and one insufficient-instruction FRQ. **No missing prompt-image file was confirmed among the complete questions.** The insufficient prompts prevent a blanket all-questions visual-completeness claim.

The two construction controls are `APBIO-FRQ-L-008` (graph sucrose/mass values) and `APBIO-HDG-2026-GRAPH-002` (construct boxplots from both supplied five-number summaries). Supplying completed graphs would disclose the requested response. Written membrane arrangements, DNA sequences, R-group descriptions and shape observations were also distinguished from references to missing figures.

Published is not synonymous with ordinary practice eligibility. A read-only, no-history selector probe at current Unit 3 returned **193** distinct versions after paging offsets 0/51/102/153 (final page40; offsets204/255 empty). The function clamps requests to51, so an initial single-page count was not treated as coverage. The 28 remaining rows are 22 teaching designations, two held practice questions and four later-unit serving conflicts. Image gating then omits S-003, leaving **192** eligible practice versions in this no-history probe. This does not certify entitlements, real-student JWTs, every photo policy or every browser rendering. Passing the image gate also does not repair F2's absent instructions.

The read-only teaching RPC was also exercised for all22 in-scope teaching topics with an authenticated SQL caller using the existing owner admin profile. All22 selected version IDs match the frozen audited teaching versions. Only version IDs were retained; this is additional selector evidence, not a normal-student authorization test or22 browser views.

The deployed `student-session-items` is **v41**, including the teaching-image branch; the earlier v40 source-drift warning is superseded by the current source read. Its shared delivery file SHA-256 is `f00785f0dd2c7422f81fb45b1a75c8209a468400419076f9dea810a23e2e3fe0`, identical to backend source at the audit checkout. The app source inspected is `cbaa4acbdb85189ab9447d226efe0239be8c0d7c`; source inspection is separate from evidence that every commit is published.

## Browser verification and limits

Using the existing owner admin profile in student-facing views, no answers typed or submitted:

- Biology Unit3/topic3.4 practice MCQ loads APBIO-MCQ-128 with its full data and written choices.
- Switching the same practice URL to FRQ reports no questions for3.4 and falls back to a complete enzyme FRQ from3.2. This is consistent with F1; the exact omission reason is established by live metadata/deployed gate, not inferred from the notice alone.
- Learn from a question for3.4 loads APBIO-OHT-3.4, which is answerable from its text/choices and needs no prompt image. A separate reference-note diagram's “Text only for now” notice is not a missing question image and was not repaired.

Screenshots are in `browser-evidence/`. These are representative desktop checks, **not 221 individual browser checks**, phone certification or ordinary-student authorization. Expired URLs, image decode failure and submission/scoring were not exercised. No claim of complete-question delivery is made. Biology course position was restored to Unit1/topic1.4; the audit's temporary sessions remain distinguishable from graded work.

## Next action and boundaries

Next owner: David / content maintainer. Resolve the actual authored instructions for the 14 strictly in-scope legacy FRQs, starting with S-003; then review its existing image and accessibility metadata before a separately authorized repair. Preserve current question/scoring/taxonomy source during this read-only audit. No work on later Biology units or other subjects is queued by this report. Fresh independent QA remains pending authorization; the broader visual-completeness task is not closed.
