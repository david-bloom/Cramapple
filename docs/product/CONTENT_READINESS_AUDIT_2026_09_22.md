# Cramapple Content Readiness Audit — 2026-09-22

STATUS: HISTORICAL (a dated record, 2026-09-22).

> Recovered 2026-10-21. A point-in-time audit of the `web/` prototype, written 2026-09-22 and never committed until recovered from a Codex worktree. Its production counts and several blockers are obsolete. Read `docs/product/ARCHITECTURE_AND_DESIGN_DECISIONS_CURRENT.md` for the current picture:
> - fixed 1440×900 frame vs responsive (P1): superseded by D3, responsive;
> - multi-part FRQ representation (P1): decided in D8, render-time parser stopgap;
> - `validated` as a launch gate (P0): decided in D13, not a launch gate;
> - Open Hand answer-key serving (P0): method D17; serving contract `DECISION-0086` (O5).
>
> The `web/` copy fixes this audit describes as "completed" landed separately in the same PR that added this file.

**Scope:** the student-facing `web/` prototype, its six AP Statistics walkthrough
items, the eight real item packages wired to direct review routes, the 330 local
item packages those examples come from, and the legal copy available in `docs/`.

**Readiness call:** **not ready for a public student launch.** The walkthrough is
coherent enough for internal product review, but the content now shown on Home is
explicitly unreviewed sample material. The real-package routes are diagnostic
surfaces with deliberate missing-content notices, and the production library
still lacks the topic relationship that several student surfaces require.

This audit does not replace `CONTENT_GAPS_RUNNING_LIST.md`. That file owns the
production-library counts and closure evidence; this file is the launch-facing
checklist for what a student can currently see.

## What is ready for internal review

- All five screen templates have content: Home plus Practice/Open Hand for FRQ
  and MCQ.
- The six Home-facing AP Statistics samples form a consistent two-topic sequence
  with stems, answer choices or rubrics, hints, habits, reference material, deep
  dives, and coaching.
- All 190 local MCQ packages have four authored rationales; all 140 local FRQ
  packages have a non-empty `canonical_answers` entry. These are repository
  package counts, not production validation claims.
- The product voice rules are consistently represented in the main interaction
  patterns: `↻` for missed Practice points, `✕` only in Open Hand, one-word
  verdicts, explicit hint costs, and no celebratory copy.
- The wordmark fonts are self-hosted, so the fixed plate does not depend on an
  external font request.

## P0 — launch blockers

- [ ] **Replace or approve the six Home-facing sample items.** Every item in
  `web/src/content/sample/` is hand-written for the prototype, has no fact-pack
  references, and has not passed the content review pipeline. Do not present the
  walkthrough as reviewed AP practice until each item has provenance and the
  current approval gate.
- [ ] **Connect serving items to a trusted primary topic.** The current
  production evidence in `CONTENT_GAPS_RUNNING_LIST.md` records 0 of 1,346
  published items with a usable topic label. That blocks relevant Open Hand item
  selection, breadcrumbs, topic briefs, deep dives, habits, references, progress,
  and the study map. For the local package snapshot, 150 of 330 packages have a
  `topic-*` node; four of the eight packages wired to review routes do not.
- [ ] **Keep the eight real-package review routes out of the public product until
  they are enriched.** All eight lack a human pane title, habits, reference
  materials, hints, the three-section deep dive, per-verdict coaching, and
  per-distractor `Fix:` lines. The UI intentionally renders “Not in this package”
  diagnostics. Those notices are useful in QA and launch-blocking in a student
  experience.
- [ ] **Replace the local regex grader before scores are represented as product
  results.** The sample FRQ evaluator is explicitly a deterministic stand-in.
  Content can be reviewed against it, but its score and coaching claims are not
  a production grading contract.
- [ ] **Resolve answer-key serving for Open Hand without weakening the Practice
  boundary.** The method is approved; the serving contract remains open in
  `APP_REBUILD_MIGRATION_PLAN.md` decision 21. Practice must not receive
  pre-submit answer reasoning or correctness data. This audit removed the visible
  expected-reasoning leak from the current Practice screen, but the production
  contract still needs enforcement outside the client bundle.
- [ ] **Finish and publish accurate legal/support content.** Both legal documents
  are marked draft, describe the product as AP Biology-first while this surface
  is AP Statistics, and point to a support channel that is not identified or
  linked anywhere in `web/`. Obtain counsel/product approval, name a working
  contact route, and link Terms and Privacy from the product before collecting
  accounts, student work, uploads, or payment data.
- [ ] **Decide whether `validated` is a launch gate and enforce the answer.** The
  production tracker says no library content is currently `validated`. This is a
  governance decision, not a copy edit, and must have a named owner before launch.

## P1 — decisions or source material required

- [ ] **Approve the fixed-frame content limit or choose a responsive treatment.**
  The 1440×900 no-scroll plate is still an open product decision. Real multi-part
  FRQs and image stimuli cannot be safely copy-fit until that decision is closed.
- [ ] **Choose the multi-part FRQ representation.** The migration plan records
  hundreds of FRQs whose parts live only in prose. A parser, migration, or new
  presentation model is required before those items can enter this plate.
- [ ] **Author criterion-segmented FRQ answers.** Open Hand needs rubric-tagged
  answer spans. The production gap tracker documents missing and misaligned
  canonical answers, point-total mismatches, and graph responses that require a
  spatial canonical.
- [ ] **Add per-distractor fixes to the package schema and author them.** All 190
  local MCQ packages have rationales, but none has a `minimum_fix` field. A
  rationale explains the trap; it is not automatically a concise correction.
- [ ] **Complete stimulus and accessibility treatment.** The 330 local packages
  contain only text stimuli and none requires screen-reader review. Production
  image questions need approved assets, alt text, captions/source treatment, and
  a fixed-frame layout decision before they can be called ready.
- [ ] **Provide launch identity assets.** `web/` has no favicon, app icon, or
  social-share image. Supply approved brand artwork and alt/metadata guidance;
  do not improvise these from the wordmark.
- [ ] **Choose public naming and internal-ID policy.** The product wordmark uses
  “CramApple,” while editorial documents use “Cramapple.” Direct review routes
  also expose package IDs and “real package” in chrome. Keep those QA identifiers
  behind an internal mode or replace them with student-facing labels.
- [ ] **Define empty, unavailable, and bad-route copy.** Unknown URLs currently
  redirect silently to Home. Decide whether public launch needs a not-found or
  unavailable-item state with a useful recovery action.

## P2 — polish after the blockers

- [ ] Add a final editorial pass for concision after real AP Biology and
  multi-part FRQ stress tests; do not shrink required reading to make it fit.
- [ ] Review repeated instructions (“one point,” “one submission,” “nothing is
  scored”) once the final navigation and onboarding exist, and remove only true
  duplication.
- [ ] Add page-specific document titles/descriptions when routing moves beyond
  the single static prototype shell.
- [ ] Decide whether “Start over” needs confirmation copy once attempts persist
  beyond local storage.

## Safe fixes completed in this audit

- Removed the visible but nonfunctional hand-drawn attachment action.
- Stopped rendering package `expected_reasoning` in Practice before submission.
- Changed the post-submit claim from untrue “explained in the Answer Key” to
  accurate “listed in the Answer Key.”
- Standardized student-facing AP Statistics copy on US English (`Practice`,
  `randomized`, `center`, `memorize`).
- Replaced internal authoring language on Home with a student-facing availability
  statement and clarified that the set covers only part of one unit.
- Added an English-US language declaration, a descriptive page title, and a basic
  meta description.
- Renamed the Open Hand real-package label from internal “What the package does
  say” to student-facing “Answer reasoning.”

## Exit criteria

Public content readiness requires all P0 items closed with evidence. A limited
internal demo is ready when the build, grading unit tests, and screen/pane checks
pass; reviewers are told that the six walkthrough items are samples and the eight
direct package routes are gap-visualization fixtures, not student-ready content.

## Evidence used

- `web/README.md`
- `docs/new_design/CONTENT_AND_PEDAGOGY.md`
- `docs/product/APP_REBUILD_MIGRATION_PLAN.md`
- `docs/product/CONTENT_GAPS_RUNNING_LIST.md`
- `docs/legal/PRIVACY_POLICY.md`
- `docs/legal/TERMS_AND_CONDITIONS.md`
- Read-only scan of all 330 JSON files in `content/item-packages/`

