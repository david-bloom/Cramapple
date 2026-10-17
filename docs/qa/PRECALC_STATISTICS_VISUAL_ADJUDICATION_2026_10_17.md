# Precalculus / Statistics: adjudication of the 49 visual cases

> **FOLLOW-UP 2026-10-17:** [All twenty graphical-choice specifications are resolved and built locally](STATS_GRAPHICAL_CHOICES_RESOLUTION_2026_10_17.md): each retains its two original histograms and replaces the ambiguous categorical/stemplot choices with explicit histogram distractors. The twenty specification blockers below are historical. Independent QA and live release remain open; the overall 23/26 adjudication is unchanged.

**Date:** 2026-10-17. **Status:** Conductor adjudication complete; repairs, fresh independent QA and authenticated delivery verification remain open.
**Tier:** Standard, source review and documentation. **Authorization:** David: “Adjudicate the 49.”
**Branch / PR:** `codex/question-images-precalc-statistics-u1-u3` / [#480](https://github.com/david-bloom/Cramapple/pull/480).

## Verdict

**23 need visual repairs; 26 can remain text-only for their stated task.** Of the 23, three have sufficient source for stimulus artwork; twenty need graphical answer choices and authoring decisions about under-specified distractors. None is missing the numerical information needed to answer the existing written question.

| Reviewed group | Count | Adjudication | Next action |
| --- | ---: | --- | --- |
| Precalculus 1.3 teaching graph | 1 | Uphold required graph for construct fidelity | Source-ready piecewise-linear graph |
| Statistics 1.4 and 2.1 teaching charts | 2 | Uphold required charts for scale/segmented-bar reading | Source-ready, with limits below |
| Statistics 1.5 teaching histogram | 1 | Downgrade missing-image finding; conceptual text is complete | Retain text; no invented bins |
| Precalculus residual-pattern questions | 4 | No required image | Retain supplied verbal patterns |
| Statistics `graphs-105000`–`105019` | 20 | Require graphical answer-choice repair for display recognition | Specify distractors before rendering all choices |
| Statistics `boxplots-108000`–`108019` | 20 | No required image | Preserve explicitly requested descriptions |
| Statistics `APSTATS-MCQ-022` | 1 | No required image | Retain verbal boxplot-feature question |
| **Total** | **49** | **23 visual repairs / 26 retain text** | **3 source-ready / 20 need choice specifications** |

These judgments replace the original four/45 triage split for this exact queue. They are conductor pedagogical judgments, not database `image_needed` approvals or a fresh independent QA certificate. Historical source ledgers remain unchanged.

## Rule applied and evidence read

I read the full stem, stimulus, actual MCQ choices, authored part prompts and all supported presentation subtrees for each of the 49 pinned versions. No scoring criteria, keys or rationales were used. The [per-version ledger](../../scripts/image_readiness/precalc-statistics-u1-u3-2026-10-16/adjudications-2026-10-17.json) records every version ID, original source digest, presentation SHA-256, prior classification, verdict, concrete evidence and next action. It also pins the complete frozen inventory/queue/review file checksums and source commit `578ab8223e2e75b5dfb49a5420283c7af8ab28a1`.

Answerability and representation are separate. When the task calls for reading a graph, comparing plotted scales, or recognizing a displayed representation, text that pre-reads the display can bypass the intended skill. When the pattern is an explicit given and the task asks for its implication, or explicitly asks for a description, a graphic is not required merely because the topic concerns graphs. This is an adjudication of the authored operation; original author intent is not independently established by a topic title.

Controls: `APSTATS-OHT-1.1` asks for an investigative first move, so its hypothetical table is not required; `APSTATS-OHT-3.14` asks for a test design, so the unshown cell counts are not required; `apprecalc-frq-013` asks the learner to construct a sign chart from a complete polynomial, so supplying the completed chart would answer part of the task. These controls were reread, not added to the 49-case denominator.

This session adjudicates the committed source snapshot. It did not requery Production, establish present-day source equality, exercise an authenticated browser or run a separate reviewer. Current-source comparison remains a prerequisite for implementation. Independent QA remains open; the same continuation session is not relabeled independent review.

## The three source-ready stimulus repairs

1. **`apprecalc-oht-1.3`** — uphold. Show straight segments joining (0,1), (2,7), (5,1), (7,3) on labeled axes. The stem asks about the graph on an interval; currently students receive only coordinates. Do not annotate the tested slope or direction.
2. **`APSTATS-OHT-1.4`** — uphold. Use two explicitly partial Pop-only bar panels: freshman count 60 with n=200, senior percentage 40 with n=50. Label the separate count/percent axes. Other genres are unspecified; do not invent their bars or print the converted freshman percentage in the artwork. A partial chart must be identified as showing Pop only.
3. **`APSTATS-OHT-2.1`** — uphold. Equal-total 100% segmented bars for Chess/Art, with 40%/75% online and 60%/25% not online. Equal bar totals represent percentages, not equal membership. No group counts or invented meeting-preference categories.

The exact versions and digests are in the ledger. Source-ready means sufficient authored givens for a proposed build; it does not grant build, attachment or Production authority.

## Why Statistics 1.5 is downgraded

`APSTATS-OHT-1.5` asks whether a grouped histogram can establish that at least two students scored exactly 85. It supplies the only bin needed for that inference: 11 scores in [70,90), among 25 scores. The distinction being tested is grouped versus individual-value information, not recognizing the bar or reading its height. Other bin counts do not resolve the exact-value claim and are not missing givens for this question. Retain the existing conceptual text.

A full exact histogram remains unrecoverable from the supplied facts. Do not fabricate the remaining 14 scores, use zero-height bars for unknown bins, or supply an invented dotplot/stemplot. A future visual-reading redesign would be a separate authoring action. This differs from the two chart-reading teaching items above: their distractors concern plotted scale units or equal normalized bar heights, whereas this question concerns the information grouping discards even when the grouped counts are known.

## Twenty graphical-choice repairs

All `apstat-u1-5-3a-graphs-105000` through `105019` ask which representation correctly **displays** twelve given observations. Actual choices are written histogram counts, stemplot strings and a generic categorical-bar description. They are answerable frequency/specification exercises, but show no graphical displays to inspect. For representation-recognition fidelity, adjudicate all twenty as needing **answer-choice graphics**, rather than a common stem image.

The original raw observations and both histogram options are complete. Recounting the data confirms that each item has one matching histogram specification; each other histogram moves a count. Future artwork must preserve each option's own counts, including the deliberate mistakes. Generating every option from the raw data would erase the distractors. Adding only the correct histogram to the stem would give the answer away.

**All twenty have two authoring prerequisites:** the categorical-bar choice specifies no concrete categories or heights, and the stemplot gives no explicit key/leaf unit. An unconventional stem/leaf scale can alter whether a purported distractor is correct. Do not silently infer the key, redraw a correct conventional stemplot, or invent a categorical display. Settle those option specifications and answer uniqueness before building/releasing any four-choice set. If the owner prefers to keep text specifications instead, explicitly re-author the question as a specification-selection task and run content QA; that is an alternative product/content decision, not an image attachment.

## Twenty-six text-complete cases

- **Four Precalculus residual questions:** the U shape, random scatter or ordered sign pattern is the supplied evidence; the choices ask for its implication for model adequacy. No magnitudes or exact coordinates are needed. Preserve the text; newly invented residual values would create a new example.
- **Twenty modified-boxplot items:** each explicitly asks “Which modified boxplot description matches this summary?” Q1, median, Q3, actual whisker endpoints and outlier extrema are supplied, and the options are complete descriptions. The endpoints are not the IQR fences. Keep that format; changing to graphical choices would redesign the requested task.
- **`APSTATS-MCQ-022`:** a long right whisker and high outlier are explicitly stated, and the choices ask for the matching qualitative description. No exact coordinates are needed. This narrow verdict does not prove the skewness of an unseen raw dataset or certify the answer key.
- **`APSTATS-OHT-1.5`:** the grouped-information limitation is complete in prose, as explained above.

## Verification and next owner

The 49 ledger identities and digests reconcile exactly with the original queue and inventory. Counts reconcile to 3 required stimuli, 20 graphical-choice repairs and 26 retained-text cases. Arithmetic cross-checks cover all 40 histogram options against their twelve supplied observations and all 20 boxplot summaries against the 1.5×IQR rule; these support source sufficiency and do not constitute a scoring/answer-key certificate. Original corpus/review/queue artifacts remain byte-identical.

**Next owner: content/visual maintainer.** Scope the three exact-version stimulus builds and resolve the twenty option specifications; then use the master handoff's deterministic build, private-storage, guarded-attachment and actual student-browser workflow. Keep 26 text cases out of the required-image build queue. Obtain fresh independent subject QA and authenticated desktop/phone delivery evidence before certification. No image, question, label, visual-requirement row, student state or deployment was changed here; seven scope boundaries and other subjects remain outside this adjudication.
