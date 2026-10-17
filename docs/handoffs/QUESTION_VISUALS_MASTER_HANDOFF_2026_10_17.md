# Question images — start-here handoff for the next session

**Updated:** 2026-10-17 America/New_York. **Owner:** David Bloom. **Tier of this update:** Micro, documentation only.
**Purpose:** finish finding required question visuals, create supported images when needed, and prove students receive them.
**Canonical repo:** `david-bloom/Cramapple`. **Current work:** [PR #480](https://github.com/david-bloom/Cramapple/pull/480), branch `codex/question-images-precalc-statistics-u1-u3`. PR #479 (BC mirror/Biology) is merged; #480 was open at this handoff. Recheck both on restart.

This is the consolidated restart pointer. The detailed reports below retain the per-question evidence and limits. No new audit, image build, deployment or Production change was performed to write this document.

## Start in five minutes

1. Read [session bootstrap](../team_charter/CRAMAPPLE_SESSION_START.md), `AGENTS.md`, and [docs index](../INDEX.md). Follow the current task-tier rules and inspect the current activity/approval indexes before exact-ID lookups. Do not broadly scan corpora, output directories or archived logs.
2. Fetch current GitHub state. Continue #480 if still open; if merged, create a clean branch from current main. The original checkout at `/Users/davidbloom/Documents/Cramapple.nosync` contains unrelated work; preserve it. The working checkout used here is `/private/tmp/cramapple-question-images-precalc-statistics`, but GitHub and committed artifacts must be sufficient without this local path.
3. Read the status table and immediate queue below. Distinguish a finished source review, a live attachment, a browser verification and an independent completeness certificate.
4. Recheck live source digests, taxonomy/serving labels, deployed delivery code and browser access for the exact chosen slice. Historical counts are checkpoints, not today's guaranteed catalogue.
5. Best next action: independently adjudicate the **four Precalculus/Statistics missing-visual findings and 45 uncertain cases**, then prepare supported deterministic builds. After those, audit **Calculus BC Units 1–3**, then the four Physics subjects Units 1–3, one bounded subject at a time. Biology source recovery is a separate prerequisite described below.

## Subjects and units: coverage and remaining work

**Working boundary is Units 1–3.** The requests expanded subjects, not the unit range. This table is a backlog and sequence for future sessions, not permission to start new Production changes. No later Biology unit was authorized. Units 4+ across the catalogue are outside the current completion claim and need a separately requested scope; use the live subject registry rather than inventing unit counts.

| Subject | Units | Current evidence | What the next session must do |
| --- | --- | --- | --- |
| Calculus AB | 1–3 | Required-visual completeness certified PASS; six approved images across AB/Chemistry are live with desktop/320 CSS evidence. | Preserve approved images. Re-audit only new/changed versions. Separate whole-question/FRQ-part delivery defects remain; this was not a whole-question certificate. |
| Chemistry | 1–3 | Same bounded certificate as AB; approved images live. | Preserve and check only deltas. Periodic-table access was accepted by David; online-link publication is a separate question, not an image-completeness blocker. |
| Calculus BC | 1–3 | **Full complete-question visual audit remains to do.** One exact AB-derived question image was mirrored and verified on desktop. | Read every scoped published presentation, including BC-specific questions and keyword negatives. Reuse AB visuals only on exact, proven shared questions. Create reviewed BC-specific visuals where justified; matching suffixes are insufficient. Finish phone delivery evidence for the existing mirror. |
| Biology | 1–3 only | 221 mapped/boundary source versions read;217 strictly in scope. No missing image file confirmed among complete questions. One existing image is withheld;14 strict-scope legacy FRQs lack actual instructions. | Recover/re-author instructions through a separately scoped content process; then reassess image need. Review existing S-003 image and repair approved metadata/delivery if appropriate. Independent review and a bounded completion decision remain open. Do not audit later Biology units. |
| Precalculus | 1–3 | 312 full source reviews;1 proposed missing graph,4 uncertain residual-plot cases. | Independently adjudicate, build supported required visuals, attach under scoped authority, and verify actual student delivery. No images were created in the audit. |
| Statistics | 1–3 | 489 candidate reviews;482 strict plus7 boundary-only.3 proposed missing charts,41 uncertain cases. | Independently adjudicate; resolve source limits before building charts. Attach under scoped authority and verify actual student delivery. Preserve7 scope exceptions; no label repair implied. |
| Physics 1 | 1–3 | **Full complete-question visual audit remains to do.** Earlier lexical leads are not coverage. | Full census, source/construct review, existing-asset delivery checks, then create supported missing diagrams and verify. |
| Physics 2 | 1–3 | **Full audit remains to do.** | Same complete workflow. |
| Physics C: Mechanics | 1–3 | **Full audit remains to do.** | Same complete workflow; preserve exact vectors, geometry, axes and physical conditions. |
| Physics C: Electricity & Magnetism | 1–3 | **Full audit remains to do.** | Same complete workflow; preserve circuit connectivity, polarity, field direction and given labels. |

Canonical completed-slice evidence: [AB/Chemistry certificate](../qa/CALC_CHEM_U13_VISUAL_COMPLETENESS_CERTIFICATE_2026_10_15.md), [final independent QA](../qa/CALC_CHEM_U13_IMAGE_FINAL_QA_2026_10_15.md), [reusable workflow and session close](SESSION_CLOSE_2026_10_15_QUESTION_VISUAL_COMPLETENESS.md). Do not interpret their source census of all AB/Chemistry versions as certification of later units.

## Immediate image and repair queue

### Four Precalculus / Statistics findings

These are conductor judgments pending independent subject review. All four are currently selected teaching examples with **no image path and no visual-requirement decision**. Their numerical answers are recoverable from prose, but the intended graph-reading representation is absent.

| Question / Production version | Image to create if upheld | Source constraint |
| --- | --- | --- |
| `apprecalc-oht-1.3` / `8040df49-303d-4b32-bec5-397ed92f2858` | Piecewise straight-line graph through (0,1), (2,7), (5,1), (7,3). | Exact geometry is recoverable; do not annotate the answer or trend being tested. |
| `APSTATS-OHT-1.4` / `a80b545f-efde-4b1b-a857-4b67651bec5f` | Count-axis freshman pop bar at60 (n=200), percent-axis senior pop bar at40% (n=50). | Other music genres are unspecified; do not invent their bars. |
| `APSTATS-OHT-1.5` / `abfbe038-21b9-4860-808b-a5db0f3a331b` | Histogram/bin-interpretation visual. | Only25 total scores, width20 bins starting50 and tallest [70,90) count11 are known. **Do not fabricate other bin counts.** Obtain source/design adjudication for a truthful partial representation or separately re-author; a complete exact histogram cannot currently be reconstructed. |
| `APSTATS-OHT-2.1` / `5f75f226-dba1-4457-8f92-f8a5761fba20` | Segmented percent bars: Chess40% online, Art75% online; complements60%/25%. | Membership totals are unknown; widths/labels must not imply known counts. |

The **45 uncertain cases** are4 Precalculus residual-plot questions and41 Statistics questions:20 histogram/stemplot-choice descriptions,20 explicitly requested boxplot descriptions, and `APSTATS-MCQ-022`'s verbal boxplot. They are not45 confirmed missing-data defects. Intentional prose questions may remain prose. Exact identities and reasons are in [review-queue.json](../../scripts/image_readiness/precalc-statistics-u1-u3-2026-10-16/review-queue.json); [full report](../qa/PRECALC_STATISTICS_U13_IMAGE_AUDIT_2026_10_16.md).

### Biology: recover the question before commissioning an image

Strict Units1–3 incomplete FRQs, all prefixed `APBIO-FRQ-`: **S-003, S-019, S-021, S-023, S-025, S-026, S-028, S-029, S-032, S-033, S-036, S-038, S-071, S-080**. Scenario text exists but actual question instructions do not. Image need remains **undetermined** until instructions are recovered. Do not turn scoring criteria or keys into invented prompts.

`APBIO-FRQ-S-003`, version `c4da3229-8d7a-4cf9-8738-68b62af20372`, already references `Biology/FRQ/APBIO-FRQ-S-003.png`. Its private object exists, but version-matched accessibility metadata is absent, so delivery omits it with `asset_metadata_missing`. Inspect and judge the existing image after recovering the task; do not bypass the gate by inserting an approval blindly. Four later-unit conflicts, including S-040, and two unassigned graph exercises remain boundary records. [Biology report](../qa/BIOLOGY_U13_QUESTION_VISUAL_AUDIT_2026_10_16.md), [checkpoint](SESSION_CLOSE_2026_10_16_BC_MIRROR_BIOLOGY_VISUAL_AUDIT.md).

### BC: preserve the exact mirror, then audit the rest

`apcalcbc-mcq-ab-060`, version `fdeb1925-dcae-4331-935b-890751635487`, explicitly shares AB source version `f492bfbf-5434-434f-a4d8-50b058477139`. Its existing approved AB v2 PNG was reused under [APPROVAL-0183](../activity_log/APPROVAL-0183_BC_QUESTION_IMAGE_MIRROR_2026_10_16.md), with BC-version metadata. Desktop decoding/alt text passed; phone check was interrupted. No object was copied or redrawn.

Three superficially similar BC questions had different givens from the AB originals; no blanket mirror was performed. Recheck full stem, stimulus, choices, geometry and provenance before reuse. An AB reference-pack alias does not establish question-image equivalence. Do not rerun the one-shot attachment SQL.

## How to audit a remaining subject

Use [WORK-QUESTION-IMAGE-COMPLETENESS](../tasks/WORK-QUESTION-IMAGE-COMPLETENESS.md) for the governing method; its older baseline counts and v40 warnings are historical. v41 was verified in the latest audit; re-fetch deployed code before any new implementation.

1. **Freeze scope before source review.** Use current canonical topic/unit resolution and current nonsuperseded validated serving labels whose hashes match. Inspect metadata first; open source only for Units1–3 and needed boundary adjudication. Never infer unit from a key/module name. Retain excluded/conflicting records with reasons; do not silently relabel them.
2. **Inventory every published version in scope.** Capture exact version/item IDs, source digest, pack state/latest flag, teaching designation, stem, stimulus, actual choice text, authored `parts[].prompt` / `prompt_text`, supported presentation subtrees, image path, asset approval/object presence and question-targeted figure uses. Exclude keys/rationales/scoring evidence. Never substitute answer-bearing `frq_criteria.learner_facing_text`.
3. **Read complete presentations, including keyword negatives.** Lexical searches only order the work. Judge both whether the task is answerable and whether prose removes the intended visual skill. Empty `stimuli[]`, a complete formula/table or a topic reference diagram does not prove a missing/present question image.
4. **Persist a per-version disposition and evidence.** Distinguish adequate image, missing/broken delivery, missing metadata, complete text/table/equation, student constructs representation, absent instructions/data, and unresolved construct fidelity. Keep a source digest so same-version edits invalidate stale judgments.
5. **Challenge findings independently and reconcile controls.** Include graph-reading, complete-table, formula-only and student-draws controls. Do not show a finished graph when drawing it is the task. Current audits classified33 such construction questions in Precalculus/Statistics. A conductor review is not independent QA; use only currently authorized agent/reviewer arrangements.
6. **Recheck scope and source at completion.** Record changed/added versions and reopen their review. State separate counts for published, strict-scope, ordinary-selectable, teaching-selected, image-gate passing and browser-verified records.

Reusable inventory template: [published-source-inventory.sql](../../scripts/image_readiness/calc-chem-u13-certification/published-source-inventory.sql). Latest bounded example: [Precalculus/Statistics artifacts](../../scripts/image_readiness/precalc-statistics-u1-u3-2026-10-16/). Copy query structure, not frozen subject IDs or another subject's judgments. `record_review.py` records supplied judgments **after** reading; it is not a semantic classifier.

## How to create, attach and verify images when found

1. **Settle task fidelity first.** Pin exact source/version, required axes, points, open/closed markers, units, topology, particle counts/charges, labels and rights/provenance. Missing source information is a content recovery/re-authoring issue. Do not invent a plausible picture or use the answer key to invent givens.
2. **Use deterministic scientific artwork.** For these question repairs, follow the proven JSON/spec → Python/Matplotlib or governed SVG → checksummed PNG workflow. Reuse the engine/examples in [question-visuals-pilot](../../scripts/question-visuals-pilot/) and the verified [phone-v2 renderer/manifest](../../scripts/question-visuals-phone-v2/README.md). Retain editable spec/source and SVG plus the PNG derivative. Do not use free-form AI image generation for precise scientific diagrams or generate images at student request time. Complete tables should be semantic tables. Reference Lane A figures are a different contract; do not assume they automatically render as question stimuli.
3. **Inspect and test the artifact.** Verify scientific invariants and source equivalence, then visually inspect the actual rendering. Check clipping, text overlap, non-color cues, no answer annotations and non-leaking alt/long descriptions. Match accessible information to the graph without narrating the answer.
4. **Design for the actual phone pane.** Meaningful labels require at least16 rendered CSS pixels (ticks excepted by DECISION-0120). Measure image width, not just viewport width. The existing340px-artwork/26px-label solution rendered at about230.66 CSSpx and achieved about17.6px labels. Test desktop,320 CSS viewport, enlarge/zoom and200% browser zoom; record actual measurements.
5. **Commit a reproducible manifest.** Include exact version/digest, visual revision, spec/renderer hashes, PNG/SVG checksums, dimensions/MIME/bytes, provenance, accessibility text and reviewer evidence. Use immutable `content-assets/questions/<content-key>/<revision>/<sha256>.png` objects. Keep the bucket private; retain prior bytes/revisions.
6. **Prepare a narrowly scoped release.** Reuse the guarded attach/rehearsal/recovery patterns in [phone-v2](../../scripts/question-visuals-phone-v2/) and [BC mirror](../../scripts/image_readiness/bc-ab-mirror-2026-10-16/). Guard expected current source/path/status, bind approved metadata and a correct visual-requirement decision to the exact version, and assert question/scoring/choices/taxonomy/serving labels unchanged. Rehearse attachment and recovery with ROLLBACK. Do not copy old UUIDs or re-execute old one-shot releases. Development/Production work must have the applicable current scoped authority; this handoff is not a blanket deployment approval.
7. **Verify storage and actual delivery separately.** Check private-object bytes/SHA, public denial, metadata and path. Trace ordinary selector → deployed image gate → signing → payload → app normalization → decoded image. Check worked examples separately through `get_open_hand_teaching_item` and `student-session-items`'s `teaching_image` branch. Preserve the900-second signed URL TTL unless deliberately changed; never commit tokens or signed URLs.
8. **Exercise real student-facing routes.** Page selectors at their real clamp (51 at this checkpoint) until exhausted. Staff/admin SQL and pure gate tests do not prove ordinary-student entitlement or HTTP/browser rendering. Verify exact served version, every required image/part, correct alt text, complete decode, desktop/phone fit, renewal/failure behavior and that a missing required visual cannot become a scored attempt. Submit answers only in an authorized controlled QA scope; restore temporary course selections and preserve concurrent learner state.
9. **Recheck and report honestly.** Re-read source/metadata after release, record deployed revisions and evidence, and obtain required independent QA before a bounded completeness PASS. Storage existence, a successful insert or passing CI alone is insufficient.

**Known delivery traps:** unknown visual-requirement decisions are permissive. The deployed v41 teaching branch returns `no_image` for null paths. Missing metadata can omit an existing image (Biology S-003). A separate app defect omitted authored FRQ parts even where an image rendered; an image-completeness certificate is not a whole-question certificate. The Precalculus/Statistics browser check reached an unsigned-in login page, so authenticated rendering remains unverified.

## Durable records and a ready-to-use restart prompt

- Overall method/task: [WORK-QUESTION-IMAGE-COMPLETENESS](../tasks/WORK-QUESTION-IMAGE-COMPLETENESS.md).
- Completed AB/Chemistry slice: [session close](SESSION_CLOSE_2026_10_15_QUESTION_VISUAL_COMPLETENESS.md), [certificate](../qa/CALC_CHEM_U13_VISUAL_COMPLETENESS_CERTIFICATE_2026_10_15.md), `scripts/image_readiness/calc-chem-u13-certification/`, `scripts/question-visuals-phone-v2/`.
- BC/Biology: [merged PR #479](https://github.com/david-bloom/Cramapple/pull/479), [checkpoint](SESSION_CLOSE_2026_10_16_BC_MIRROR_BIOLOGY_VISUAL_AUDIT.md), `scripts/image_readiness/biology-u1-u3-2026-10-16/`, `bc-ab-mirror-2026-10-16/`.
- Precalculus/Statistics: [PR #480](https://github.com/david-bloom/Cramapple/pull/480), [report](../qa/PRECALC_STATISTICS_U13_IMAGE_AUDIT_2026_10_16.md), [checkpoint](PRECALC_STATISTICS_IMAGE_AUDIT_CHECKPOINT_2026_10_16.md), `scripts/image_readiness/precalc-statistics-u1-u3-2026-10-16/`.
- Production project at the last check: `pcntajvbdfqhbeewmdry`. Reconfirm environment and tools; do not assume credentials or a signed-in browser persist. Student-app source was `david-bloom/ap-prep-blueprint` plus the governed Lovable publication path; consult current records before any app change.

Suggested next-session prompt:

> Read `docs/handoffs/QUESTION_VISUALS_MASTER_HANDOFF_2026_10_17.md` and current GitHub/activity state. Continue the Units1–3 question-image work from the recorded queue. First independently adjudicate the four Precalculus/Statistics missing-visual findings and45 uncertain cases, then prepare supported deterministic visual builds without inventing missing histogram counts. Preserve completed AB/Chemistry assets and the exact BC mirror. Full audits still needed: Calculus BC, Physics1, Physics2, Physics C Mechanics and Physics C Electricity & Magnetism, Units1–3. Biology needs its14 incomplete prompts recovered before image judgments; no later Biology units. Follow the audit/build/storage/student-delivery workflow and existing approval boundaries, keep an exact-version ledger, and record a bounded result with browser evidence and honest limits.

The next owner should update this matrix and the activity/index pointers as each subject is completed, rather than repeating historical source reviews or calling unresolved findings certified.
