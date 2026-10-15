# Session close — required question visuals, 2026-10-15

**Status:** session ended at David’s request. Calculus AB/Chemistry Units 1–3 required-visual slice is complete and certified PASS. Broader subject coverage and separate student-question defects remain open.

**Task:** [WORK-QUESTION-IMAGE-COMPLETENESS](../tasks/WORK-QUESTION-IMAGE-COMPLETENESS.md). **Source:** `david-bloom/Cramapple`, branch `codex/question-image-audit-plan`, [PR #457](https://github.com/david-bloom/Cramapple/pull/457) (open at close). The original plan/scope PR #455 is merged. The [visual certificate](../qa/CALC_CHEM_U13_VISUAL_COMPLETENESS_CERTIFICATE_2026_10_15.md) and [final independent QA](../qa/CALC_CHEM_U13_IMAGE_FINAL_QA_2026_10_15.md) define the completed slice and its limits.

## 1. Current task or issue

David asked to find questions that require images but lack them, and to plan how to render, store and deliver those images to students. He narrowed the initial 350 lexical leads to Chemistry and Calculus AB Units 1–4, asked that complete tables/equations and student-drawn responses be distinguished from missing visuals, then directed “Build the 4” and “attach to live student questions.” He subsequently requested the full audit, resolution of the ten uncertain unit records and certification of Units 1–3. He explicitly authorized a fresh read-only independent QA agent. Periodic-table access was accepted as external reference access; an online link is a convenience, not a certification blocker.

Initial pilot: 105 Chemistry/AB lexical candidates, of which 91 had resolved Units 1–4 scope, ten had uncertain scope and four were beyond Unit 4. Reviewing the 91 produced four construct-fidelity repairs and one reference-access check. The later audit expanded to **every published question in both subjects**, including keyword-negative and unit-uncertain rows: **726 versions, 448 AB and 278 Chemistry**. This superset closes the Units 1–3 source-audit scope without trusting a content-key prefix or provisional unit label.

## 2. What changed this session

Six exact Production questions now have approved private v2 visuals:

| Question | Representation |
| --- | --- |
| `apcalcab-frq-u13-002` | Piecewise segment graph and open/filled markers |
| `apcalcab-frq-u13g-1-3` | Piecewise graph, points and vertical-asymptote behavior |
| `apcalcab-oht-1.3` | Teaching graph with distinct left/right branches |
| `apchem-oht-3.8` | Eight/16 particles, stated 100/200 mL volumes |
| `apcalcab-mcq-060` | Line/parabola with open `(3,4)` and filled `(3,6)` |
| `apchem-frq-u13g-3-8` | Equal-volume models: P has six Na⁺/six Cl⁻; Q four Ca²⁺/eight Cl⁻ |

The current manifest and release record are in `scripts/question-visuals-phone-v2/`. The earlier builds in `scripts/question-visuals-pilot/` and `scripts/question-visuals-certification/` are retained as historical immutable evidence. All ten uncertain scopes were resolved for audit membership: one entirely within Units 1–3, nine requiring later units; three within the original Units 1–4 pilot. No held/provisional serving label was promoted.

The Chemistry-only full-periodic-table link is merged in [student-app PR #28](https://github.com/david-bloom/ap-prep-blueprint/pull/28), commit `ce2e4799a50acf06967cc244c837ae73dd012018`, with passing CI and the existing assistance gate retained. **Its publication is not verified.** At the image-certification checkpoint, publication was held because main contained separately owned renderer work. Subsequent main records now show that work published under APPROVAL-0175 at `2fbb345`, with batch-4 live confirmation under APPROVAL-0176. Those records do not prove that the later periodic-table-link commit is published. No publication was performed as part of session close.

### Reusable plan for finding where images are needed

The following is the reusable workflow for another subject/unit batch. A missing PNG or a visual keyword alone is never sufficient evidence.

1. **Freeze a complete published-version inventory.** Pin environment, timestamp, item/version identities, publication/pack state and same-version source digest. Read stem, stimulus, actual choices, every authored part prompt, supported prompt/package presentation subtrees, current image paths, asset approval/object presence and question-targeted figure uses. Include all published versions, not only latest rows or positive keyword hits. Keep held/provisional/uncertain scope visible. Exclude keys, rationales, scoring evidence, expected answer graphs, learner work, tokens and signed URLs from the review packet.
2. **Resolve scope using evidence.** Prefer canonical primary-topic resolution, then current validated serving labels whose content hash matches. If those are absent or conflicting, read the whole question and all parts to make an explicitly recorded audit-membership judgment against the course topic definitions. Do not promote a serving label or infer scope from `u13` in a key. Review uncertain rows anyway so exclusions cannot hide missing visuals.
3. **Use lexical/structural signals only to order work.** Search for figure/graph/diagram/spectrum/particle references, “shown above,” labelled choices, absent referenced components and construction verbs. Inspect choices and parts as well as the stem. Empty `stimuli` keys and answer-side `expected_graph_spec` fields do not establish prompt-visual coverage. Read keyword-negative questions too; the original 350-lead screen was not a completeness audit.
4. **Review answerability and construct fidelity separately, question by question.** A complete table or equation may supply all givens; graph-description choices and prose-defined molecular structures may be intentional. A request to draw a graph, Lewis structure, ICE table or diagram is generally a response task: supplying the completed answer would leak it. Conversely, prose may preserve all numbers while replacing the intended graph-reading or particle-model skill. Record that distinction, the exact evidence and a per-version reason. Categories include adequate existing visual, broken delivery/linkage, complete text/table/equation, learner constructs the visual, recoverable required prompt visual, construct changed by prose, insufficient source and unresolved.
5. **Recover only supported givens.** A required visual needs the question’s exact axes, values, labels, topology, open/closed points, particle counts, charges and stated volumes. Do not substitute a generic topic illustration. If necessary information cannot be recovered, hold/re-author in a separately scoped content change. Any non-unique illustrative interpolation must preserve every assessed invariant and be documented; it is not permission to invent assessed data. Check accessibility text and filenames for answer leakage too.
6. **Independently challenge the findings and negative controls.** A fresh reviewer checks proposed defects, source/visual pairs, scope decisions, complete tables/formulas and student-construction cases. For this session the conductor read all 726; the independent reviewer read **198**: all 126 visual/construction positives, 31 special negatives and every fourteenth ordinary negative (41), including all ten scope resolutions and six repair pairs. The exact 198 identities, frozen file hashes and selection recipe are saved. Do not call this an independent 726-source census.
7. **Trace delivery, not just stored bytes.** Verify selector eligibility separately from publication and teaching designation. Confirm the actual question version, approved asset metadata, private object, signed payload, client normalization and visible decoded image. Test practice and worked-example routes independently, at actual desktop and narrow CSS widths. A stored object, successful SQL statement, merged app PR or admin-only read is not sufficient proof of ordinary-student delivery. Record the account role and untested failure cases.
8. **Close the exact batch and retain the backlog.** Reconcile all inventory/review identities and source drift, attach only approved repairs, preserve all negative controls, record unresolved items and issue a bounded certificate with explicit limits. New or changed question source invalidates that version’s previous review. A general authoring/publication completeness gate is future work; it was not silently added to the database in this session.

**Queries and review sources:**

- `scripts/image_readiness/question_image_inventory.sql`: corrected general inventory approach.
- `scripts/image_readiness/question_image_pilot_scope.sql` / `.json`: original 105-candidate scope evidence.
- `scripts/image_readiness/question_image_pilot_review.json`: first 91 source reviews.
- `scripts/image_readiness/calc-chem-u13-certification/published-source-inventory.sql` / `.json`, `reviews.json`, `ten-unit-resolutions.json`, `independent-review-coverage.json` and `summary.json`: complete two-subject frozen corpus, decisions and closure.

**Critical audit lesson:** do not read `frq_criteria.learner_facing_text` as authored question instructions. Real legacy rows contain scoring answers there. This audit corrected that mistake and reads authored `parts[].prompt` / `prompt_text` instead. Preserve presentation-only extraction; do not feed entire answer-bearing prompt/package objects into an external reviewer.

### Rendering, storage and student-delivery plan

Use deterministic graph/diagram source for exact scientific content. Preserve editable JSON/specification and SVG alongside checksummed 2× PNG delivery derivatives. Complete tables should remain semantic tables rather than raster images; do not turn equations or response tasks into unnecessary pictures. No runtime image/model generation is needed. Precise scientific diagrams were not generated with free-form AI artwork.

For this batch, the existing one-image-per-version contract was sufficient: each image combines its required panels. Store immutable objects under private `content-assets/questions/<content-key>/<revision>/<sha256>.png`; bind the exact question version/path to approved alt text and long description in `content_asset_metadata`. Record required/approved decisions in `content_visual_requirements`. Keep old bytes and approved metadata for historical attempts. The four-lane figure architecture remains a design reference; no new question-figure schema or renderer family was introduced here.

Before publication, lock target versions and related rows; check the complete reviewed source digest, current path, status and existing approval state. Guard choices and authored parts as well as stem/stimulus. Verify object existence and checksums, perform an atomic attachment/metadata transaction, and assert unchanged scoring, choices, taxonomy hashes/labels and visual decisions. Rehearse with ROLLBACK. Recovery must guard current source/paths and previous approved metadata/object presence; the final v2 recovery changes only six paths and retains both revisions. It was successfully rehearsed with ROLLBACK.

Serve through the existing deployed `student-session-items` signing path, with the 900-second TTL and private bucket intact. Credentials remain server-side; verification helpers kept service credentials in process memory and did not save them. Confirm signed bytes match the manifest, public reads are denied, and the browser displays the same version/hash/alt text. Future expiry/decode-error submission behavior remains a separate delivery requirement, not a result proven here.

**Phone lesson:** measure the actual image width after pane padding. The original 22px artwork labels scaled below the 16px meaningful-glyph floor at a 320 CSS-pixel page. All six compact v2 images now use 26px labels and conservative 230px minimum image width; the measured minimum glyph is **17.638px** at 230.65625px image width. Chemistry footers were wrapped/repositioned without changing wording. Graph ticks remain excepted. The browser’s existing 75% zoom was not changed; temporary viewport settings were evaluated using measured CSS width and then reset.

## 3. What was verified

- 726 frozen sources/reviews reconciled, zero missing/orphan identities; all 726 digests unchanged before release. After release only the six intended image-path targets changed; their source digests normalized only for image path still match.
- Independent semantic/source/asset review passed, with the exact 198-row coverage boundary and all ten decisions recorded. Reviewer caught and rechecked source-freshness, recovery-ownership and old-asset recovery guards.
- Original four-image build: eight tests passed; two follow-up builds: four tests passed; final phone v2: three tests passed, including text bounds/overlap, ion labels inside circles, footer clearance, reproducible rebuild and hashes. No assessed source/geometry changed in v2.
- Final attachment and non-destructive recovery mutation rehearsals passed with ROLLBACK. Six v2 paths committed **2026-10-15 11:30:14 UTC** and remained after recovery rehearsal.
- Six signed downloads checksum-match; six unsigned public reads are blocked. Source/scoring/choice/taxonomy/visual-decision invariance passed.
- All six images decoded in 12 saved browser views: desktop 1695 CSS pixels and narrow 320 CSS pixels. Natural image width 680px; current v2 hash filenames and alt text match. Independent QA inspected all 12 screenshots and returned final visual PASS.
- App link: targeted tests, typecheck, production build and final CI passed. Backend PR #457 checks passed on the implementation checkpoint; closing documentation is a Micro-tier update and does not rerun or change live content.
- No answers were typed/submitted. Chemistry course position restored to 1.5 and AB to 2.1. Concurrent work selected Precalculus 2.15; that active selection was preserved. The old temporary credential file is absent; no service credentials or signed URLs are committed.

## 4. What remains open

**Best next action — student-app maintainer:** repair `apcalcab-frq-u13-002`’s missing authored part-a/b/c display. The source inventory contains those prompts, but both saved live screenshots show only the generic stem, description and image before the response box. Add actual part rendering and a regression test, then verify the normal FRQ route. This is not a missing-image blocker, and the certificate explicitly does not certify complete question delivery.

Separate source-correctness leads remain in the audit report: legacy/current equation or choice drift on AB FRQ-005 and MCQ-012/013, plus Chemistry MCQ-030 wording/alternatives. These were not silently rewritten or certified for correctness. Other subjects/units, including the original wider lexical backlog, remain future work.

## 5. Open blockers and risks

Also open: subject-switch stale worked content, a reused-session/topic empty notice, and 3px of whole-document overflow on the Calculus teaching page at 320px (its image fits). Browser evidence used the owner admin profile with QA mode, not a complete ordinary-student authorization test. No scoring or expired/failed-image checks were performed. The earlier v1 recovery-delete rehearsal returned connector errors; do not claim it passed. The final non-destructive v2 recovery was successfully exercised.

These limits remain explicit; none is silently treated as a passing whole-question, student-authorization or scoring check. No additional image-slice approval is outstanding.

## 6. Files changed or checked

- Governing plan/task: `docs/tasks/WORK-QUESTION-IMAGE-COMPLETENESS.md`.
- Source, independent and final QA reports: `docs/qa/CALC_CHEM_U13_IMAGE_*_2026_10_15.md`; certificate linked above. Earlier four-image browser report: `docs/qa/QUESTION_IMAGE_LIVE_BROWSER_CHECK_2026_10_15.md`.
- Frozen queries, corpus, decisions and independent identities: `scripts/image_readiness/calc-chem-u13-certification/`.
- Current renderer/spec/manifest, guarded attach/rehearsal/recovery SQL, release JSON and 12 screenshots: `scripts/question-visuals-phone-v2/`.
- Final backend evidence checkpoint before close: `57e45d5cea0937c8c82d50f67613e95ccd658a31`; session-close commit follows it. Latest main was merged into this branch during closeout, including the separate batch-4 records; none of those figures were edited or redeployed.

## 7. Commands, queries and tests with results

- Rebuild/check in its pinned environment: `MPLCONFIGDIR=/tmp/cramapple-cert-mpl arch -x86_64 python3 render.py`, then `verify.py`. Matplotlib 3.9.4/NumPy 1.26.4. Rebuilds write artifacts; a read-only reviewer should hash/inspect rather than regenerate.
- App validation used targeted `vitest`, `tsc --noEmit -p .`, `npm run build` and GitHub CI. Local baseline npm lockfile was out of sync, so dependencies were installed without modifying it. No dependency change is included.
- Final backend evidence checkpoint before close: `57e45d5cea0937c8c82d50f67613e95ccd658a31`; session-close commit follows it. Latest main was merged into this branch during closeout, including the separate batch-4 records; none of those figures were edited or redeployed.
- Inventory/source-drift SELECTs and exact-version attachment/recovery rehearsals/results are preserved in the source and release folders above. `git diff --check` passed for closeout; this documentation-only update did not modify live state.

## 8. Approval and synchronization state

APPROVAL-0173 records the first four attachments (originally labelled 0168 on this branch, reconciled after main used that ID for More help). APPROVAL-0174 records the follow-up image/certification work and necessary phone-label remediation. David explicitly authorized independent QA; final PASS was integrated. No additional owner approval is outstanding for the completed image slice.

PR #457 is open; this closeout does not merge it or publish the app. **Next owner David:** review/merge the durable audit and closeout PR when ready. **Next implementation owner student-app maintainer:** fix authored FRQ-part display first. A later app publication must use the then-current reviewed scope; do not infer unrestricted publication permission from this session-close request.

## 9. Exact next step and restart note

**Single best next action:** fix the missing authored FRQ-part display on the current `/question` screen, using `apcalcab-frq-u13-002` as the regression case. Start from this closeout, the bounded certificate and the current student-app source; reproduce with a fresh correctly scoped session before changing code.

Suggested next-session prompt: “Read the question-visual session close and certificate. Reproduce and fix the authored FRQ parts missing from `apcalcab-frq-u13-002` on the live question plate. Preserve the six approved images and question/scoring content. Add a regression and provide a narrowly scoped release plan.”

## 10. Do not touch next session

Do not regenerate or overwrite the six approved immutable image objects, alter question/scoring/taxonomy source, promote serving labels, make the bucket public or rerun an old attachment transaction. Do not redeploy backend main’s `student-session-items` over deployed v40: the deployed teaching-image branch was absent from repository main when inspected. Reconcile that drift before any future function deployment. Do not touch unrelated dirty files in `/Users/davidbloom/Documents/Cramapple.nosync`, or separately owned reference-figure batches. Temporary `/tmp` files and chat memory are not required to resume; use committed artifacts and GitHub records.
