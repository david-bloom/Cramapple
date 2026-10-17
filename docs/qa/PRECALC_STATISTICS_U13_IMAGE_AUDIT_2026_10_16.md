# Precalculus and Statistics Units 1–3: question-visual audit

**Date:** 2026-10-16 America/New_York (2026-10-17 UTC). **Result:** complete conductor source census; missing-visual findings and review queue remain open. This is not a visual-completeness PASS, independent QA, scoring review or complete-question delivery certificate.

David's “Now do precalculus and statistics” continues the preceding Units 1–3 audit. No Production data, question, image decision, serving label, asset, student state, app or function was changed. No paid calls or independent agents were run.

## Coverage and method

| Subject | Candidate versions read | MCQ / FRQ | Strict Units 1–3 | Boundary only |
| --- | ---: | ---: | ---: | ---: |
| Precalculus | 312 | 225 / 87 | 312 | 0 |
| Statistics | 489 | 417 / 72 | 482 | 7 |
| Total | 801 | 642 / 159 | 794 | 7 |

A metadata-only routing query covered 851 published versions in the two subjects. It selected 801 candidates using canonical Units 1–3 topics, current hash-matched validated serving labels and uncertain Precalculus scope. The other 50 Statistics versions were outside this source census. No content-key inference or provisional label promotion was used.

The conductor read complete stems, stimuli, actual MCQ choices, authored part prompts and nonempty presentation subtrees, including keyword-negative questions. Scoring criteria, keys, rationales and expected answer plots were excluded. Empty presentation arrays do not establish visual coverage. Per-version judgments, exact IDs, reasons and source digests are in `reviews.json`; the batch-recording utility materializes judgments after reading and does not classify unseen questions.

No candidate has a prompt-image path, asset-metadata row or question-targeted figure use. This fact alone was not treated as a defect. At final read-back all 801 source digests and all metadata rows matched; the 851-row routing metadata also matched exactly.

## Missing prompt visuals: conductor findings

All four are recoverable in prose for answering, but their intended graph-reading representation is absent. Each is currently returned by the live teaching RPC at the stated topic. All four have no visual-requirement decision and no attached image.

| Subject/topic | Question / version | Required representation and source limits |
| --- | --- | --- |
| Precalculus 1.3 | `apprecalc-oht-1.3` / `8040df49-303d-4b32-bec5-397ed92f2858` | Piecewise straight-line graph through (0,1), (2,7), (5,1), (7,3). All geometry is specified. |
| Statistics 1.4 | `APSTATS-OHT-1.4` / `a80b545f-efde-4b1b-a857-4b67651bec5f` | Count-axis freshman pop bar (60 of 200) and percent-axis senior pop bar (40%, n=50). Do not invent other music-genre bars. |
| Statistics 1.5 | `APSTATS-OHT-1.5` / `abfbe038-21b9-4860-808b-a5db0f3a331b` | Histogram bin interpretation: 25 scores, width-20 bins starting at 50, tallest [70,90) bin count 11. Other bin counts are unspecified; a full exact histogram cannot be reconstructed without additional source/design adjudication. |
| Statistics 2.1 | `APSTATS-OHT-2.1` / `5f75f226-dba1-4457-8f92-f8a5761fba20` | Segmented percentage bars for Chess (40% online) and Art (75% online). Group totals are intentionally unknown; a drawing must not imply known membership counts. |

These are proposed repairs pending a fresh independent subject review. No diagrams were built or attached under this audit instruction.

## Construct-fidelity review queue

There are **45 additional uncertain cases**, not 45 confirmed missing-data defects:

- Precalculus: `apprecalc-mcq-012` and `apprecalc-mcq-sv-012-v1/v2/v3` (4) describe residual-plot patterns in prose. The patterns are sufficient for the written choices; review whether actual residual plots are necessary for the intended skill.
- Statistics: `apstat-u1-5-3a-graphs-105000` through `105019` (20) provide complete raw data but histogram/stemplot choices as written counts or notation.
- Statistics: `apstat-u1-8-3a-boxplots-108000` through `108019` (20) explicitly ask for modified-boxplot descriptions, with complete quartiles, whiskers and outliers. These may be intentional text questions; subject review must decide before replacing them with graphics.
- Statistics: `APSTATS-MCQ-022` (1) asks about a verbally described long right whisker/high outlier rather than showing a boxplot.

No missing numerical givens or absent authored FRQ instructions were identified in the reviewed source. This does not prove those authored instructions reach every app screen.

Negative controls include complete tables, equations, standard-function/unit-circle recall, conceptual expected histogram shape, and 33 questions explicitly classified as learner construction (8 Precalculus, 25 Statistics). The Statistics construction group includes 18 hand-drawn graph tasks with complete tables/data. Their completed graphs would answer the task and should not be supplied as prompt images. The hypothetical table in `APSTATS-OHT-1.1` and cell-count table mentioned in `APSTATS-OHT-3.14` are unnecessary for the actual procedure/design choices.

Separate source-consistency observations: actual MCQ choices and legacy duplicate question text differ in Precalculus `apprecalc-mcq-006`, `015`, `019`. Actual choice-table content was reviewed; no correctness repair was made.

## Scope decisions

Six unassigned Precalculus records were read and resolved for audit membership only: `apprecalc-frq-006` →1; `apprecalc-frq-020` →2; `apprecalc-frq-np2-001` →1+2; `np2-007` →2+3; `np2-008` →1; `np2-010` →1+3. Their complete inputs are present. No labels were promoted.

Seven Statistics boundary records are excluded from strict totals:

- `APSTAT-MOD3-H001-INV` and `APSTAT-MOD4-H001-INV` combine sampling/design with population-mean inference, which reaches current Unit 4.
- `APSTATS-MCQ-009`, `009-CAL`, `057`, `058`, `059` have canonical Unit 4 topics but current hash-matched validated serving labels in Unit 2 or 3. These are boundary-only source checks pending taxonomy reconciliation. Their complete inputs are present; no later-unit census or label change was performed.

The live Statistics taxonomy puts sampling/design in Unit 1, probability/distributions in Unit 2 and proportion/chi-square inference in Unit 3. Old module numbers and content keys were not used as current unit definitions.

## Student delivery: what was verified

The exact deployed v41 shared visual gate was executed against the frozen records in ordinary-student mode: **801 pass, 0 omitted**. This shows that unknown visual decisions plus null paths remain permissive; it does not mean the questions have images. Current `teaching_image` code returns `image:null, reason:no_image` before signing when the selected version has no path. Thus the four selected teaching findings have no image to deliver.

Paged live `select_student_practice_items` calls used the active packs, current unit 3, a synthetic no-history user ID and limit 51, offsets 0 through 561. Results: **230 Precalculus and 244 Statistics ordinary practice candidates**, all within the frozen inventory, all passing the visual gate, with later pages empty. These are selector results, not final HTTP response counts or actual-student entitlement proof. The retired Statistics pack advertises units [1,5]; a unit-3 probe rejects `unit_not_in_subject`, so it is not represented as an active Unit-3 delivery pass.

Transaction-local authenticated-role teaching probes used the existing owner/admin profile and rolled back. They returned **44 Precalculus and 40 Statistics topic examples**, all within the inventory, including all four missing-visual findings. Staff bypass means this is not ordinary-student authorization proof.

Actual browser access in the available in-app browser redirected `https://app.cramapple.com` to the unsigned-in marketing page. The visible Log in link opened `https://cramapple.com/login`, showing Sign in, Continue with Google and an email-code field. No authenticated subject question was available. No sign-in email, attempt, answer, scoring exclusion, course-position change or session was created. Authenticated HTTP/image decoding, desktop/phone rendering, expired-image behavior and actual authored-part rendering remain unverified for this slice.

## Durable evidence and next action

Evidence: [artifact directory](../../scripts/image_readiness/precalc-statistics-u1-u3-2026-10-16/), including corpus/query, all 801 judgments, review queue, scope/summary, source-drift check, paged selector SQL/results, teaching SQL/results and deployed v41 source snapshots. Run `node scripts/image_readiness/precalc-statistics-u1-u3-2026-10-16/check-delivery.mjs` with Node's TypeScript stripping support to reconcile identities and reproduce the pure gate check.

**Next owner: subject reviewer/conductor.** Independently adjudicate the four proposed missing visuals and 45 uncertain representations using the complete source and negative controls. Determine a supported histogram treatment without inventing bin counts. Any image construction/attachment or question/taxonomy repair is a separately scoped implementation action. Complete authenticated browser checks before claiming a student-rendering PASS. No content repair or completeness certificate is claimed here.
