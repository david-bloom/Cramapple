# Independent QA: 23 Precalculus / Statistics Units 1–3 visual repairs

**Proposed content/math verdict: Pass.** No blocking content/math finding in this 23-question packet. This is a scoped reviewer recommendation, not final approval or a Done claim.

## Review method and authorization

Reviewed in a fresh independent context under David’s explicit release/QA authorization relayed by the conductor. The task’s earlier no-agent audit restriction is superseded for this reviewer only. Read `docs/INDEX.md`, `docs/tasks/WORK-PRECALC-STATISTICS-IMAGE-AUDIT-U13.md`, and `docs/research/CONTENT_AUTHORING_AND_QA_PROTOCOL.md` §§4, 5, 6/Phase 6, and 9.

Read the blind packet first. Parsed all twenty raw data lists from the stems, independently tallied lower ≤ x < upper, and independently solved the three teaching items. Recorded all 23 answers in `independent-qa-report.json` at 2026-10-17T20:34:07.579661+00:00 before opening `live-before.json` or `release-plan.json`. Subsequently compared stored keys, revised choices/rationales/packages, SVG geometry and all 23 PNG renderings.

## All-question results

Counts are ordered left to right across the specified bins. Every row has one uniquely correct option and agrees with the historical stored `mcq_choices.is_correct` key and the proposed choice key. The Statistics histogram versions have null historical `canonical_answer_1`; their authoritative choice flags agree.

| Content key | Independent key | Independent result | Verdict |
|---|---|---|---|
| apprecalc-oht-1.3 | D | (1−7)/(5−2) = −2; decreasing | Pass |
| apstat-u1-5-3a-graphs-105000 | D | 3, 4, 3, 2, 0 | Pass |
| apstat-u1-5-3a-graphs-105001 | A | 2, 4, 5, 1, 0 | Pass |
| apstat-u1-5-3a-graphs-105002 | D | 4, 5, 3, 0 | Pass |
| apstat-u1-5-3a-graphs-105003 | D | 3, 4, 3, 2, 0 | Pass |
| apstat-u1-5-3a-graphs-105004 | A | 3, 4, 3, 2, 0 | Pass |
| apstat-u1-5-3a-graphs-105005 | C | 3, 7, 2, 0 | Pass |
| apstat-u1-5-3a-graphs-105006 | D | 3, 4, 3, 2, 0 | Pass |
| apstat-u1-5-3a-graphs-105007 | B | 3, 4, 3, 2, 0 | Pass |
| apstat-u1-5-3a-graphs-105008 | A | 1, 2, 1, 3, 1, 2, 1, 1, 0 | Pass |
| apstat-u1-5-3a-graphs-105009 | C | 1, 2, 2, 1, 2, 2, 1, 1, 0 | Pass |
| apstat-u1-5-3a-graphs-105010 | C | 1, 2, 2, 2, 1, 2, 2, 0 | Pass |
| apstat-u1-5-3a-graphs-105011 | A | 2, 10, 0 | Pass |
| apstat-u1-5-3a-graphs-105012 | D | 4, 8, 0 | Pass |
| apstat-u1-5-3a-graphs-105013 | B | 1, 2, 1, 2, 2, 2, 1, 1, 0 | Pass |
| apstat-u1-5-3a-graphs-105014 | A | 1, 1, 3, 2, 1, 2, 1, 1, 0 | Pass |
| apstat-u1-5-3a-graphs-105015 | A | 4, 3, 3, 2, 0 | Pass |
| apstat-u1-5-3a-graphs-105016 | C | 2, 7, 3, 0 | Pass |
| apstat-u1-5-3a-graphs-105017 | D | 1, 7, 4, 0 | Pass |
| apstat-u1-5-3a-graphs-105018 | A | 1, 1, 1, 2, 2, 1, 2, 1, 1, 0 | Pass |
| apstat-u1-5-3a-graphs-105019 | D | 4, 6, 2, 0 | Pass |
| APSTATS-OHT-1.4 | C | 60/200 = 30%; seniors 40% > 30% | Pass |
| APSTATS-OHT-2.1 | D | Art 75% > Chess 40%; counts cannot be inferred | Pass |

## Findings and evidence

- **Mathematical correctness and uniqueness:** all twenty stems contain twelve observations; all correct counts sum to twelve. Each question has four distinct nonnegative frequency vectors summing to twelve. Each of the sixty wrong options moves exactly one observation to an adjacent bin. These are plausible counting/endpoint errors without duplicates or a second correct answer. Each wrong rationale names precisely the two incorrect bars and their actual versus required counts; every claim was checked.
- **Intervals and visual equivalence:** all eighty SVG panels have contiguous equal-width rectangles. Independently checked actual rectangle x/y/width/height against the axis calibration and choice counts, rather than trusting only `data-count`. Every x-axis endpoint label matches the blind packet’s left-inclusive/right-exclusive boundaries. All A–D panels use the same scales within a question, include Count and the variable/unit, and are fully represented in the alt text and long description. The explicit stimulus states the endpoint convention.
- **No answer leakage in accessibility content:** all twenty alt/long descriptions enumerate A–D with their complete data, including distractors, and never mark the correct choice. SVG descriptions agree exactly. Teaching descriptions reproduce given coordinates, counts/percentages, and legend information without naming an answer or providing the slope/comparison conclusion.
- **Teaching figures:** Precalculus polyline maps to (0,1), (2,7), (5,1), (7,3), with correct x and f(x) axes. Statistics 1.4 uses separate Count and Percent panels, n=200/n=50, heights 60/40, and explicitly labels the Pop-only excerpt without inventing other genre counts. Statistics 2.1 displays Chess online 40% and Art online 75%, their complementary segments, equal 100% totals, and no invented club size. The original choices and rationales are correct.
- **Package consistency:** all eighty package `mcq_form.options` texts/correct flags match proposed `mcq_choices`; package prompt/part prompt preserve the stem; package criterion `required_evidence` matches the independently correct histogram; stored source values and bin counts agree. All twenty repair entries specify a new version ID and old version number + 1. Forty historical histogram descriptions are preserved exactly; forty former ambiguous options are replaced by explicit histograms.
- **Artifact/readability inspection:** visually inspected all twenty repository all-choice PNGs and three staging teaching PNGs. Labels, axes, panel A–D labels, units and bars are readable in the inspected artifacts, with no observed clipping, missing panel or content mismatch. Verified all 23 staging PNG SHA-256/byte counts against the release plan and all twenty copied choice PNGs against repository originals. Each sheet is one column with four stacked panels; this requires scrolling. Smallest histogram SVG text is 20 px at a 340 px image width (18.82 px at 320 CSS image width); teaching minimums are recorded per question in JSON. This calculation does not establish app viewport sizing.

## Source-specific evidence

- Staging `blind-qa-packet.json`: all 23 supplied stems and choices; independent derivation timestamp and per-question working retained in JSON.
- Staging `live-before.json`: all 23 current snapshot version IDs, stems, historical choice keys/rationales.
- Staging `release-plan.json`: all 23 PNG hashes, accessibility content; twenty new versions, proposed choices, rationales and package revisions.
- Repository `scripts/stats-graphical-choices-2026-10-17/assets/105000-all-choices.{svg,png}` through `105019-all-choices.{svg,png}`: all 80 panels inspected/checked.
- Staging `apprecalc-oht-1-3.{svg,png}`, `apstats-oht-1-4.{svg,png}`, `apstats-oht-2-1.{svg,png}`: teaching geometry, labels and visual inspection.

Input SHA-256 values (pin this report to the reviewed packet):

- `blind-qa-packet.json`: `4ea0c1f9ef16bd9b35b8440f52fa772447c239373e80a9a6a76f0bb85641a37d`
- `live-before.json`: `c6416888b32fa029b9d459e8148a93cf7690930b5283daae68cfdf76bf0cd075`
- `release-plan.json`: `f16051f46c5a3f6ee62698cf69b3e9b0d780aa41b0661efe8a90e16cf7e251b4`

## Limits and remaining release evidence

- This is fresh-context §9 content/math QA within the same model family, not §4 two-independent-family CED conformance. No full fact packs were supplied or reviewed.
- No authenticated live student browser QA, live storage readback, signed URL delivery, rendering-in-app, or server-grading interaction was performed by this reviewer.
- No final owner approval or Phase 6 Done claim. Review-state allowlist and publication transaction remain the release maintainer’s responsibility.
- Font metrics describe 320 CSS pixels of image width, not a 320-pixel viewport after app padding. Live student text sizing remains unverified.
- Scope is exactly the 23 supplied versions and proposed assets; no full corpus audit.

The conductor supplied the current app image contract (max-width 100%, height auto, no height cap, shared stimulus and Histogram A/B/C/D choice labels). This reviewer did not independently inspect or authenticate that app. No database changes, uploads, deployment, source edits or commits were performed. Only these two QA report files were written.

## Spacing remediation recheck

The conductor’s browser measurement detected a 1.0 SVG-unit left clip in the rotated Percent label that the original visual inspection did not identify. The label origin moved from x=23 to x=26, a 3-unit right shift. Independently re-inspected the corrected PNG and SVG: Percent is fully visible with left margin, no visible overlap, unchanged bar geometry (Chess 40/60%, Art 75/25%), axis labels, legend and mathematical meaning. Confirmed new PNG hash/bytes and all other 22 asset hashes; blind packet and live-before hashes remain unchanged. Browser measurement itself is conductor evidence, not an independently repeated browser measurement.

Proposed content/math verdict remains **Pass**. Revised `APSTATS-OHT-2.1` PNG SHA-256: `65ffbc3e2a1900b15ac29cd9f531c37bd73a9132e4a5d0d468de2667c8b1d74f`. The release-plan pin above now identifies the revised packet. The earlier no-observed-clipping statement describes the limits of the initial inspection and is superseded for this label by this correction.

## Serving eligibility and recovery addition — scoped follow-up

**Proposed verdict: Pass for the supplied snapshot; no blocking finding.** This follows the conductor’s expanded, owner-authorized release scope. The twenty revised questions remain held pending separately requested two-family scope-check spending approval. Content/math verdicts above are unchanged.

Verified all twenty `live-before.json` records lack serving labels and all twenty `cells-before.json` records have exactly one active primary authored topic **1.5 / skill 3.A**. The canonical taxonomy plan (`docs/product/CONTENT_TAXONOMY_RATIONALIZATION_PLAN_2026_09_26.md:59`) documents why serving labels require empty `assessed_topics`; topic and skill stay in `content_item_cells`.

`serving-labels.sql:2` limits creation to the twenty choice repairs. Lines 3–8 create Unit1 serving labels, attach confirmation decisions, and pin validation to the exact successor UUID and `taxonomy_relevant_hash`. `rehearse-choices.sql:17` rejects any intervening unsuperseded label; lines 28–29 copy authored cells. Lines 60–61 assert twenty valid labels and that `public.select_student_practice_items` actually returns all twenty successor UUIDs under unit1/MCQ/topic1.5. Embedded packets in combined and split SQL match the reviewed release plan exactly.

`rehearsal-final-receipt.json` reports a successful combined publication-plus-recovery rehearsal at **2026-10-17T20:50:40.154192+00:00**, with outer **ROLLBACK**, including the all-twenty selector assertion. This is inspected conductor execution evidence; this reviewer did not query or mutate a database.

`recover-choices.sql:12` marks only `APPROVAL-0194_visual_release` labels tied to the named successors stale and clears their validated taxonomy hash. Lines 13–16 retire successors, restore predecessors through `reviewed_approved` → `published`, and preserve parent publication. Labels, validation decisions, choices and version records remain for audit. This intentionally withdraws the repaired questions from serving eligibility rather than manufacturing validation for predecessors that originally had no labels. Retained stale labels cause the existing-label guard to reject a blind rerun; retry requires an explicit revalidation/supersession path.

`publish-teaching.sql` is limited to the three existing-version image attachments, with source/key/item guards and post-write taxonomy/content equivalence checks. Its packet contains no choice repairs, serving-label writes or MCQ insertions. The twenty-choice split is isolated from these attachments. The combined publish file must not be reused after teaching attachments, since its original visual-history/source guards will reject the changed teaching state.

**Nonblocking hardening recommendation QA-LABEL-01:** the primary-cell guard currently checks only that one active primary cell exists (`rehearse-choices.sql:18`), while the selector assertion filters topic but not skill. Pinning `topic_code`, `skill_code`, and `taxonomy_source_version` to the reviewed source tuple would also reject a skill-only cell change after this snapshot. No such drift exists in the inspected snapshot.

This was static SQL and supplied-evidence review only: no learner data, live selector call, authenticated browser, database mutation or app change. The JSON append pins each reviewed SQL/evidence file by SHA-256. Neither this addition nor the supplied rollback rehearsal substitutes for the outstanding scope checks or final student-browser verification.
