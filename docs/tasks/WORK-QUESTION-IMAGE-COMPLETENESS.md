# WORK-QUESTION-IMAGE-COMPLETENESS — Required question visuals

**Status:** Proposed implementation plan; pilot source review complete, independent review and browser verification pending.
**Owner:** Codex / Main Conductor. **Product Owner:** David Bloom.
**Tier:** Standard (audit and planning); implementation and Production promotion retain their gates.
**Created:** 2026-10-14 America/New_York (2026-10-15 UTC).
**Branch:** `codex/question-image-audit-plan`. **PR:** [#455](https://github.com/david-bloom/Cramapple/pull/455).
**Authorization:** David requested a session to find questions needing missing images and plans for identification, rendering, storage and student delivery. Standing Approval Lane 1 covers this read-only work and proposed plan. No new product decision is recorded as approved.

## Active pilot scope — owner direction, 2026-10-14

David narrowed the next work to **the existing 350 potential candidates, Chemistry and Calculus AB, Units 1–4**, as test subjects. This supersedes the all-subject census and Physics/Biology starting queue as the immediate next action. The wider plan below remains future expansion; it is not this pilot's execution scope.

Re-running the original candidate rule yields the same 105 subject candidates (27 Chemistry, 78 AB). Use canonical primary-topic units when present; otherwise current, nonsuperseded **validated** unit-serving labels. Include only candidates whose resolved units all fall in 1–4. Do not infer units from content keys, accept provisional labels as validated, or treat scope membership as proof of selector availability.

| Subject | In Units 1–4 | Scope unresolved | Beyond Unit 4 |
| --- | ---: | ---: | ---: |
| Chemistry | 20 (8 MCQ, 12 FRQ) | 5 | 2 |
| Calculus AB | 71 (46 MCQ, 25 FRQ) | 5 | 2 |
| **Total** | **91** | **10** | **4** |

There are **no confidently resolved Unit 4 candidates in this subset**. Chemistry's `apchem-frq-l-016` has provisional units `[1,3,4]` and stays in the unresolved queue. This is not a claim that all Unit 4 questions have adequate visuals; the original keyword screen is incomplete by design.

Pilot queue: classify these 91 for required visuals and resolve the unit scope of the 10 uncertain rows separately. Preserve the four beyond-scope rows as excluded evidence. The read-only membership query and all 105 version identities/unit evidence are frozen in `scripts/image_readiness/question_image_pilot_scope.sql` and `question_image_pilot_scope.json`.

**Source review completed, 2026-10-15 UTC:** all 91 reviewed question by question. **86 have no missing prompt image identified; four have visual-construct concerns (3 AB, 1 Chemistry); one Chemistry item needs periodic-table delivery checked.** No question-specific numerical givens were found missing solely because an image was absent. Per-question source evidence and reasons: `scripts/image_readiness/question_image_pilot_review.json`; report: `docs/qa/QUESTION_IMAGE_PILOT_SOURCE_REVIEW_2026_10_14.md`. These are preliminary source classifications, not independent QA, browser delivery certification or database image-need decisions. No image repairs have been performed.

## Outcome and boundary

Long-term goal: find every published question version that cannot deliver its intended task because a required visual is absent, inaccessible or dropped in delivery. Produce a reviewable repair queue, then create and deploy exact-version visuals in approved batches. Cover MCQs, FRQ part prompts, visual answer choices and worked examples across all ten subjects. Prioritize currently reachable questions; keep published-but-withheld questions visible in the backlog. The active pilot is the narrowed scope above.

An absent PNG is not proof of a defective question. A table may already contain all givens, a formula may define the complete task, or the student may be asked to draw the graph. Conversely, a complete prose description may make a question mathematically answerable while removing the intended graph-reading skill. Record both **answerability** and **construct fidelity**.

Out of this slice: learner handwriting/capture, BYOQ private photos, general reference-note illustrations, grading changes, question rewriting, paid model runs, asset uploads, migrations and deployments. Repairs may need later slices; this plan does not silently authorize them.

## Verified starting point

Read-only Production checks against `pcntajvbdfqhbeewmdry`, 2026-10-15 UTC; the snapshot file records the final check time. Source baseline `david-bloom/Cramapple` `88a070804064d96d7cbf7c1a663a66dadecf4f69`.

- 2,915 published current versions, all in published packs. A separate all-published-version count also gives 2,915 versions on 2,915 published items: no older published version was hidden by the initial latest-version screen at this snapshot. Selector eligibility remains a separate check.
- 224 of those items have an unreleased teaching designation. This is an inventory count, not the number the one-per-topic teaching RPC actually chooses.
- Six published versions have `stimulus_image_path`, all Biology; all six referenced objects exist. One has matching approved asset metadata; five do not. Object existence does not prove student delivery.
- Four versions have an existing `image_needed='yes'` decision: one approved-with-edits and three marked missing. 432 are `no_not_needed`, 44 `no_constructs`, and 2,435 have no requirement decision. Absence of a decision means unreviewed.
- Re-running the historical `scripts/image_readiness/cross_course_scan.sql` first query finds **350 possible missing-visual/context candidates**. These are lexical leads, not confirmed defects. Its structured-marker test checks key existence, including empty `stimuli` and answer-side `expected_graph_spec`; use it only as a reproducible baseline.
- 79 published figures and 87 figure uses exist; **zero uses target a question version**. Reference figures do not currently establish question-stimulus coverage.
- `content-assets` is private. Current deployed `student-session-items` is v40, SHA-256 `f8c0995a7ddc2a4f1d1d5232e52ea0f786900f1a1b86af9bbe6e362d8d2f0c57`. It has both ordinary signed-media delivery and a `teaching_image` path. Repository main's function lacks that teaching-image branch: reconcile this source/deployment drift before any later deploy.
- Student-app GitHub main and Lovable latest commit both identify `7b81177f1f933ffe16cb4b55ec23fc28b08fcc7f`. This establishes source alignment, **not** that this revision is the published bundle or that a signed-in browser renders an asset successfully.
- The original inventory query was executed successfully: 2,915 distinct version rows, zero non-latest versions, 456 visual-language signals (including choices/part prompts), five explicit-reference signals and 19 construction signals. **Correction:** that version incorrectly used legacy `frq_criteria.learner_facing_text` as question prompts; some contain scoring answers. Those historical signal counts and the initial snapshot's query digest describe the old query. The current query uses authored `parts[].prompt`/`prompt_text` only; the pilot was re-read from corrected source. Its saved corpus is restricted to the 91 scoped questions.

| Subject | Published current versions | Baseline lexical candidates |
| --- | ---: | ---: |
| Biology | 268 | 16 |
| Calculus AB | 448 | 78 |
| Calculus BC | 429 | 63 |
| Chemistry | 278 | 27 |
| Physics 1 | 210 | 18 |
| Physics 2 | 135 | 16 |
| Physics C: E&M | 162 | 6 |
| Physics C: Mechanics | 134 | 10 |
| Precalculus | 312 | 56 |
| Statistics | 539 | 60 |
| **Total** | **2,915** | **350** |

The older TASK-0020 audit's 288 published items / 36 possible gaps is historical evidence, not today's catalogue. The index has reference-figure entries but lacked a dedicated question-image completeness entry when this session began.

## 1. Identify and classify

### 1a. Freeze an inventory before judging

Run `scripts/image_readiness/question_image_inventory.sql` read-only and save its output, query digest, timestamp and environment. It includes every published version on a published item, pack state, teaching designation, stem, stimulus, choices, authored question-part prompts, presentation subtrees, image decisions, asset metadata, storage-object existence and question-figure links. It excludes rubric criteria, keys, rationales, expected graphs and learner data from the review packet. Do not substitute `frq_criteria.learner_facing_text` for question-part prompts: real rows contain scoring answers. Treat nested presentation data as untrusted content; check it for accidental answer-bearing fields before model submission.

Use `(environment, content_item_version_id)` as the review identity and keep `content_key` for humans. The audit digest detects same-version edits; version ID alone is insufficient. Group mirrored AB/BC items and shared seed families for repair efficiency, but preserve a disposition for every served version. Resolve Development UUIDs from verified natural keys and digests, never by copying Production UUIDs blindly.

Reconcile this inventory with actual practice and teaching selection rules. Do not infer reachability from `published`, a designation, or a raw selector count. Use source and read-only function inspection first; any authenticated probe that creates sessions, scoring exclusions or attempts belongs to an authorized QA slice.

### 1b. Use signals to prioritize, then read all questions

Start with recorded required/missing decisions, broken paths, unapproved metadata and explicit “figure below” / labelled-choice references. Expand to curves, circuits, pedigrees, microscopy, maps, particle models, axes, labels A/B and incomplete numerical givens. Scan choices and every learner-facing FRQ part, as well as stem/stimulus and supported item-package presentations.

For the active pilot, **review every in-scope candidate semantically**. In a future full-catalogue expansion, include keyword-negative rows too, to catch a missing figure with no figure keyword. A broad lexical screen only orders the work. Separate absent data from dropped presentation: inspect both stored content and what the active adapter/screen actually displays.

For each row, a reviewer sees the student-facing material with the answer key hidden and records: required givens, where each is supplied, the operation being assessed, whether it can be completed, and which visual dependency is absent. Use another independent reviewer for every proposed defect and construct-sensitive case. Disagreements remain unresolved until reconciled; consult rubric/key only in a second validation pass to detect contradictions, never to invent missing givens.

A paid two-model full-catalogue pass is a proposed option, not executed here. Before running it, pin the complete prompt, supported models, batch size, cost estimate and authorization. Include known-missing controls, complete-table controls, formula-only controls and “student draws the graph” controls; any missed control invalidates that batch's automatic acceptance.

### 1c. Give each question a durable disposition

| Disposition | Meaning / next action |
| --- | --- |
| `required_visual_absent` | Task or intended representation depends on a visual not supplied; specify exactly what is missing. |
| `required_visual_broken` | Asset/spec exists, but access, adapter, renderer or load fails; repair delivery first. |
| `visual_approval_missing` | Object exists without version-matched approved metadata/content review. |
| `structured_render_needed` | Complete data/spec exists; render a semantic table or deterministic figure. |
| `text_sufficient` | Complete formula, table or prose supports the intended task; no image repair. |
| `construct_changed_by_prose` | Answerable in words, but intended visual skill is removed; curriculum adjudication. |
| `learner_constructs_visual` | Student must draw it; do not show a completed answer graph. May coexist with a separate required prompt visual. |
| `source_insufficient` | Necessary values/topology cannot be recovered; hold, re-author or retire in a separate approved content slice. |
| `uncertain` | Needs subject review; cannot be counted as resolved. |

Use one primary disposition plus separate construction/construct-risk flags. Record reviewers, exact evidence excerpts, reason, priority, required representation, source sufficiency, existing asset/spec links, repair estimate, and QA state. Every row gets a decision; summarize counts by subject/type and distinguish published, selectable, delivered and browser-verified counts.

## 2. Historical cross-subject leads and negative controls

The Physics/Biology leads below remain recorded evidence, **outside the active Chemistry/AB pilot**. Do not process them ahead of the owner's selected subjects. The Chemistry/AB pilot membership is frozen in the active-scope artifacts above; use the relevant AB negative controls below when classifying it.

These three are **already recorded as requiring missing images**, not newly proven unanswerable in this session:

| Question / Production version | Proposed visual | Limits |
| --- | --- | --- |
| `apphycm-frq-008` / `6700878c-423e-447e-be05-9e11b15b013b` | v–t graph for v(t)=αt², α>0, x(0)=0 | Supply the input velocity graph only. Do not draw the requested a(t), x(t), slope interpretation or average-velocity answer. Use normalized axes if α and T are symbolic. |
| `apphycm-frq-050` / `8e3d19be-4792-4fc0-a1d4-32d4a3c889d3` | Vertical-circle setup, radius 0.800 m, mass 0.400 kg, top speed 3.00 m/s | Draw supplied geometry and givens; do not add the force decomposition or calculated tensions/speeds being assessed. Reconfirm whether required for construct fidelity despite complete prose. |
| `apphycem-frq-051` / `47ee5fb8-949f-4ae8-aba1-ab5999ab7945` | Uniform charged rod centered on x-axis, L=0.800 m, Q=8.00 nC, point P on perpendicular bisector at y=0.300 m | Label supplied geometry; do not add the solution integral, charge-density result or answer. Reconfirm necessity versus helpfulness. |

In a later Biology slice, inspect the five paths without approved metadata before commissioning any replacement. Their keys are in `question_image_initial_snapshot.json`.

Real negative/adjudication controls found in the spot-check:

- `APBIO-MCQ-074`: “primer shown above,” but the target and complementary primer are supplied as text. This is not automatically a missing-image defect.
- `apcalcab-mcq-u2n-004`: complete values of f are embedded in the stem. Render the table accurately; no image is inherently required.
- `APSTATS-HDG-2026-GRAPH-028`: complete commute-time data and a request to construct a dotplot. Rendering the completed dotplot would disclose the task's answer.
- `apcalcab-frq-u13g-1-3`: graph described through segments, open/closed points and an asymptote. Numerical information is present; assess construct fidelity before deciding to draw it. The description does not uniquely specify every curve, so any interpolation must be checked against the task.

The spot-check is not a semantic census or a fresh independent QA pass.

## 3. Render and store the repairs

### Choose by representation, preserving exact question data

| Need | Author/render | Durable storage and delivery |
| --- | --- | --- |
| Complete table | Typed rows/columns with units; semantic HTML | Versioned data in the item presentation; render a table. Do not rasterize it. |
| Quantitative graph | Validated deterministic spec using existing Lane A families where suitable | Reuse `app.figures` + version-specific question uses only after settling the currently reserved question-target contract and extending the serving API/client. Lane A remains spec storage, never a bucket image. |
| Spatial/schematic diagram | Constrained grammar/component library; reviewed authored vector or raster only when needed | Prefer deterministic specs if supported. For actual binary assets, retain source + rendered derivative and approved metadata in private `content-assets`. |
| Existing adequate image | Recover original source and approve the exact derivative | Repair version linkage, metadata or signing/rendering; avoid unnecessary regeneration. |

Do not attach an illustrative reference chart merely because it shares the topic. A question needs its own values, axes, labels, topology and scale. No model generates at student request time. Do not use free-form AI images for precise scientific diagrams; current four-lane direction excludes them from Production.

For deterministic figures, adapt the existing Figure Production Protocol: scientific property checks, rendered geometry/label checks, visual inspection and independent reader gates. Reference-figure alt/caption conventions must be rechecked for question answer leakage. Do not inherit a teaching caption, marked trend or ≥80-character alt rule as proof of assessment equivalence.

For stored assets, proposed object names are `questions/<content-key>/<visual-revision>/<sha256>.<ext>` within `content-assets`; names are immutable and reveal no answer. Keep editable source, data/spec, renderer/version, dimensions, MIME type, byte size, derivative checksum, provenance/rights, alt/long description and review evidence in a committed manifest. Choose checksummed PNG as a conservative delivery derivative where the existing image contract is used; retain governed SVG source when applicable. Never store arbitrary executable SVG or sign an arbitrary client-supplied path.

The manifest maps every question version to each ordered component and its role (`prompt`, `choice`, `part`, `solution`). Source and runtime bytes are separate; only approved prompt/choice/part components go to an unanswered practice question. New multi-component fields and the missing `question_version_id` FK/order/approval semantics are design work to approve, not columns assumed to exist. Existing `stimulus_image_path` supports one legacy image and `content_asset_metadata` already binds bucket/path/accessibility approval to a version.

Pin visual revision and content digest. The current `app.figures` slug is mutable, so linking a question to a reused slug alone does not establish immutable assessment content. Propose a versioned ID per revision, or a versioned artifact contract, before allowing published question dependencies to mutate. A change to data, geometry, alt, component order or renderer invalidates prior verification of affected questions.

## 4. Deliver the same approved visual to the student

Trace and verify the actual active route:

1. Question selector resolves the exact published version and its required components, under existing subject/session/entitlement rules.
2. Backend validates requirement/approval, resolves version-matched metadata/specs, and signs only that question's approved private binary objects. Keep the bucket private and signing credentials server-side. Preserve the current 900-second signed-URL TTL unless deliberately revised.
3. Serving payload carries ordered components, alt/long description, visual revision, checksum/spec identity and expiration for binaries. Return required-component failure explicitly. Practice payloads contain no solution spec, answer/rationale, expected answer graph or reference-only answer annotation.
4. Active `/question` normalization, `serve.ts` and `withSignedMedia` must preserve and render those components. Worked examples use their separate teaching RPC/image path. Pin teaching image to the same version as the displayed example: a second topic lookup can otherwise choose a different version after content changes.
5. Required visuals must finish rendering before answer submission is enabled. On missing object, unknown family, invalid spec, authorization failure, expired URL, decode failure or browser `img.onerror`, withhold scoring and show retry/next-item behavior. Renew a signed URL through the authorized backend, bound to the same version. Do not allow a note saying “figure unavailable” to stand in for the required task.

Current evidence: ordinary delivery's `partitionDeliverable` rejects known required/missing images and unapproved metadata, but **unknown requirement rows are permissive**. The v40 teaching-image branch checks access/metadata but returns `no_image` when the selected item has no path; it does not check `content_visual_requirements` in that branch. The active app renders `item.media`, and fetches teaching images, but the inspected image tags have no load-error handler and the unavailable note is not a completeness gate. Treat these as source-level repair/QA targets, not a claim that an incomplete question was observed in a real student's session.

Before backend changes, recover/reconcile the deployed v40 teaching branch into source so deploying current main cannot erase it. Before figure changes, verify renderer-family whitelist support and Python/TypeScript parity at the published app revision. Successful database insertion or a merged app PR is insufficient release evidence.

## 5. Quality gates and rollout

1. **Audit gate:** every inventoried version dispositioned; all proposed defects independently checked; disagreements and negative controls reconciled. Separate initial triage counts from confirmed required-visual counts.
2. **Content gate:** recoverable source/givens, rights/provenance, correct key/rubric unchanged, no invented geometry, and no answer leakage in picture/filename/alt/long description. If repair changes the assessed task, re-author and re-QA the question rather than silently attaching an image.
3. **Rendering gate:** scientific invariants plus pixels at real desktop/phone widths. Meaningful axis titles, annotations, data labels and legends meet the 16px rendered-glyph floor (DECISION-0120; ticks excepted). A required value cannot disappear in compact layout. Test zoom/enlarge, 200% browser zoom, high contrast/non-color cues and assistive access without leaking the interpretation.
4. **Development gate:** named, small pilot batch; content/spec/bytes/metadata hashes match the reviewed manifest. Test both ordinary MCQ/FRQ and worked-example routes with actual authenticated student roles; staff/service-role success is insufficient. Test the missing/expired/wrong-version/unapproved/unknown-family/browser-failure cases above and submission blocking, plus an unrelated text-only item.
5. **Production gate:** owner approval names the exact batch, migrations/functions/app revision, assets/specs and acceptance evidence. Promote dependencies in a compatible sequence, publish the app explicitly, then verify signed-in desktop/mobile delivery and a controlled answer submission. No claim of release from storage presence alone.
6. **Rollback:** disable affected versions through the approved availability mechanism and revert their dependency manifest; restore the prior backend/app revision if needed. Do not delete bytes referenced by historical attempts. Record the representation revision actually delivered and retain reproducibility evidence.

Future authoring/publishing must include an explicit visual-requirement decision and reference validation, so new questions cannot quietly join the unreviewed population. Introduce that gate for new/repaired items first; do not bulk label all 2,435 unknown rows “not needed,” or abruptly withhold the full unknown catalogue without an approved transition plan.

## Deliverables, ownership and next action

- **Completed:** source orientation, live baseline, reproducible SELECT-only queries, frozen pilot scope, all 91 preliminary per-question source classifications and this proposed execution plan. No full-catalogue semantic audit, independent QA verdict or image repair is claimed.
- **Next owner: independent subject reviewer / audit conductor.** Adjudicate the four visual-construct concerns, check periodic-table delivery and actual student rendering of tables/FRQ prompts, and resolve the unit scope of ten uncertain candidates separately. Deliver the independently reconciled pilot audit and first exact repair manifest. Preserve all-subject expansion and Physics/Biology leads for later work.
- **Then:** subject reviewer validates construct/source sufficiency; implementation owner builds an approved Development pilot; independent QA checks it; David approves the named Production promotion.
- **Implementation boundaries:** TASK-0006's broader unapproved design is a reference proposal, not blanket approval. Existing figure and Biology-delivery approvals do not authorize new all-subject question writes. Development repair, schema/API changes, paid checker calls and Production changes need their applicable scope approval; no approval question is needed to finish this plan.
- **Do not touch:** the original checkout's unrelated edits; learner uploads; grading/rubrics; existing Production content; concurrent figure PR #454 or ASCII-math PR #449 (both independently use DECISION-0123). Do not resolve their decision-number collision in this slice.

## Sources and verification limits

Session/bootstrap + `docs/INDEX.md`; `TASK-0006`, `TASK-0020`, `TASK-0021`; `docs/architecture/VISUAL_STIMULUS_AND_RENDERING_SYSTEM.md`; `docs/product/FIGURE_PRODUCTION_PROTOCOL.md`; current design glyph-size rule; `scripts/image_readiness/cross_course_scan.sql`; Production schema/metadata and deployed v40 source; pinned student-app `normalize.ts`, `serve.ts`, `worked-example.ts`, `QuestionExperience.jsx`.

The old one-pager's Lovable-only topology and old QA's missing-renderer statement conflict with newer source and handoff evidence. This packet uses the verified private `ap-prep-blueprint` app repo + Lovable path, without silently changing the architecture one-pager. No signed-in browser certification, no Production mutation, no paid model calls, and no learner records were used.
