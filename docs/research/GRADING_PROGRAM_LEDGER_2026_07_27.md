# Grading Program Ledger — Plan, Phase State, and Experiment Record

**As of:** 2026-07-27  
**Authority:** current operational ledger for TASK-0016  
**Purpose:** prevent grading work from being lost, contradicted, or recreated

This file answers three questions:

1. What is the phased plan?
2. What is the actual state of each phase?
3. Which experiments already ran, what did they show, and what should not be
   repeated?

Historical plans and reports remain evidence. This ledger is authoritative for
current status; it does not retroactively change the read tier of an experiment.

## 1. Binding plan and launch bar

The architecture is organized by rubric type, not question length:

1. **Engine 1 — Discrete/Analytical Text:** criterion-by-criterion text grading.
2. **Engine 2 — Holistic/Evaluative Text:** English/History essays; deferred.
3. **Engine 3 — Structured Multi-Modal:** formulas, symbolic equivalence, and
   error-carried-forward.
4. **Engine 4 — Spatial Multi-Modal:** graphs, curves, and diagrams.

AP Statistics is the first end-to-end launch subject. Its beta gate remains:

- 100 MCQ + 100 FRQ + 10 investigative items;
- at least 95% criterion agreement with adjudicated labels;
- end-to-end p50 at or below 1,000 ms, with p90/p99 measured;
- cost at or below $0.01/item;
- feedback grounding, error classification, and minimum-fix quality measured;
- shadow-first operation before authoritative learner-facing grading.

Primary sources:

- `grading_engine_rollout_plan_2026_07_08.md`
- `../tasks/TASK-0016-GRADING-ENGINE-ROLLOUT.md`
- `GRADING_RESEARCH_CANONICAL_PROCESS.md`
- `grading_cross_subject_takeaways.md`

## 2. Current phase ledger

| Phase | Intended outcome | State on 2026-07-27 | Proven | Still open |
| --- | --- | --- | --- | --- |
| **A — Router + typed deterministic engines** | Route by evaluator strategy; deterministic-first text checks; symbolic+ECF typed path | **Deployed narrowly, not complete program-wide** | Production router deployed 2026-07-12. Five AP Statistics keys are wired. Formula/ECF reference batteries pass. | Confirm real Production use; reconcile live content keys; expand beyond five keyed items; ensure boundary-contract/version provenance is recorded. |
| **B — Formula transcription** | Validate the transcription/checking architecture and author Statistics keys/ECF templates | **Complete for transcription architecture; CHECKER NOW KNOWN-DEFECTIVE.** A corpus-derived harness (`ENGINE3_HARNESS_RUN1_RESULTS_2026_07_28.md`, 2026-07-28, 211 expectations, $0) found **3 production bugs** the 62/62 + 6/6 + 7/7 batteries missed: `e`/`pi` bound as constants even when supplied as givens (silently mis-grades the **published, tutor-approved** `STATS-MOD1-E004`); `CORRECT_VIA_ECF` awarded to no-dependency parts with wrong answers; parser lacks `erf`/`factorial` used by shipped profiles. Core paths otherwise sound (97.7% on unaffected profiles; NAKED_ANSWER 44/44). Deterministic *check* latency measured at **p50 0.043 ms of CPU** — excludes HTTP/auth/DB/render, so it is not comparable to the model path's 1,428 ms end-to-end call; end-to-end deterministic request latency is still unmeasured. **All three FIXED 2026-07-28; harness now 211/211 and unit tests 13/13 (4 regression tests added). Fixes are in-repo but NOT deployed.** Remaining Engine 3 gap: the harness does not yet cover `detectAmbiguousTypedFormulaText` (the ABSTAIN-on-ambiguous-notation guardrail, called on the production path) — deferred to the integration test, which still awaits the routing/environment decisions. | Three models transcribed 9/9 synthetic render lines faithfully with zero silent corruption. Statistics keys and ECF templates validate. | Real-handwriting validation remains a follow-up risk test, not unfinished Phase B scope. Do not infer handwriting readiness from synthetic renders. |
| **C — Cross-subject calibration execution** | Execute grading calibration on tutor-reviewed MCQ/FRQ content; create response-level gold and measure the launch bar | **COMPLETE (Stages 1–6 executed 2026-07-27/28). Verdict: repair a named defect and rerun a fresh held-out slice — do NOT advance to a wider or learner-facing run.** Stage 6 ran 537 paid calls over 100 items / 433 criteria for **$0.6216** of a $5.00 cap. **Neither arm meets the launch bar:** criterion agreement **Arm A 90.6% / Arm B 92.4% vs the ≥95% bar**; end-to-end **p50 1,943 ms / 3,670 ms vs the ≤1,000 ms bar**. Cost is solved ($0.0039 / $0.0023 per FRQ, 4–5× under budget). **Named defect to repair: equivalent-form under-credit** — under-credit outnumbers over-credit 3.3×/5×, worst mechanism `equivalent_noncanonical_wording` at 75.0% (6 under, 0 over), worst archetype `boundary_adjacent` at 80.9%; weakest subjects AP Statistics 82.0% and AP Physics 1 85.2%. **Arm A retained** (Arm B's +1.8 pp verdict edge replicated a 3rd time but McNemar p≈0.229, and it regresses evidence-grounding 95.1%→81.3% and loses on latency). **Deterministic layer fired on 3/437 calls (0.7%)** — effectively absent. **Measurement gap: only 1 of the protocol's 5 feedback-quality dimensions (grounding) was measured**; the other four need a judging pass (~$0.30–0.60) and no feedback-quality claim should be made without it. Full report `grading_phase_c_calibration_2026_07_27/RESULTS.md`; new durable Lessons 9, 11, 12 promoted to `grading_cross_subject_takeaways.md`. Cumulative Phase C spend **$0.8839**. *(Prior state, retained for history:* **Executed through Stage 5; blocked on an architecture decision before Stage 6.** Frozen 100 FRQ + 100 MCQ manifest (Stage 1), MCQ integrity 100% (Stage 2, $0), 100-response calibration corpus + 437 adjudicated criteria (Stage 3), both grading arms frozen (Stage 4, $0). Stage 5's n=20 low-number gate **failed twice** on independent held-out slices: Arm A (parallel per-criterion) passed every bar both times (schema-valid 100%/98.9%, agreement 91.3%/90.1%, p50 1,685/1,712ms); Arm B (single structured multi-criterion call) failed the p50 latency ceiling both times and, after a brevity/token-budget repair, also dropped below the schema-validity bar on run 2 (truncation on 10-criterion items). See `docs/research/grading_phase_c_calibration_2026_07_27/README.md` and `stage5_v2_burned_run_record.md`. | **Arm B closed as a dead end for latency** (`ARM_B_ROOT_CAUSE_ANALYSIS.md`): measured `Arm B ≈ 610 + 637×n_criteria ms` vs Arm A flat ~1,700 ms; Arm B wins only at n=1 and 88/100 corpus items have ≥2 criteria. Its v2 schema failure was a self-inflicted token-cap artifact (3/3 recovered on a diagnostic rerun at a higher cap) — do NOT re-record that as an Arm B defect. Its max-of-N-tail motivation is refuted (Arm A per-call max 3,179 ms, no fat tail). Retained as untested hypotheses only: Arm B is ~2.4× cheaper and scored +2.8 pp criterion agreement (pooled 93.4% vs 90.6%, not significant) — revisit only if cost or criterion-boundary quality, not speed, becomes binding. **NEW BLOCKER outranking the arm choice: neither arm meets the p50 ≤ 1,000 ms launch bar — provider TTFB alone is ~588 ms (59% of budget), leaving ~110 output tokens against Arm A's 234/criterion, before network/auth/DB/render. Needs a faster provider path, streamed partial feedback, far wider deterministic coverage than today's 5 seeded keys, or an explicit revision of the 1,000 ms figure (Phase F decision).** Stage 6 (n=100, $5.00 cap) not run. Cumulative Phase C spend at that point: $0.26230.)* |

The Phase C inventory figures above describe tutor-approved content suitable for
an offline/gateway calibration harness. Only 43 FRQs and 64 MCQs are both
tutor-approved and published across Production today (35 and 7 respectively
for AP Statistics). A 100-item run through the authenticated Production
`evaluate-attempt` path therefore still requires publication or a harness that
does not require published status.
| **D — Spatial engine** | QR capture → observation → calibrated abstention → shadow | **Pending / longest pole. Execution owner: Claude (assigned 2026-07-27).** | Architecture, three quantitative-graph archetypes, reproducible development corpora, trace images, and historical smoke/bake-off artifacts exist. | Audit and reuse prior artifacts; QR flow; real handwritten dual-human gold; observation bake-off on mixed positive/negative cases; abstention calibration; 100%-human-reviewed shadow operation. |
| **E — Frontend grading experience** | Submit, render criterion/ECF feedback, help flow, QR capture | **In progress; no completion claim in recovered evidence** | Feedback envelope/runtime-context work exists. | Confirm live end-to-end Statistics experience and rendered-latency instrumentation. |
| **F — Launch review** | Evaluate all launch gates and approve rollout | **Pending** | None claimed. | Depends on C–E and real end-to-end measurements. |
| **Engine 2** | Holistic essay engine | **Deferred by plan** | Analytic-row decomposition strategy recorded. | Revisit only when English/History enters scope. |

## 3. Experiment register

### A. Text-grading and rubric-boundary experiments

| Experiment | Evidence/read tier | Result | Durable decision / do not repeat |
| --- | --- | --- | --- |
| FRQ-02 SP-1 boundary and routing investigation | One AP Biology FRQ; n=40 directional plus C2Direct-Low n=100 | Boundary-table revision was the largest quality gain. C2Direct-Low tied the control at 88.8% at n=100 while faster/cheaper. Original no-audit Gemini n=40 was 146/160 (91.2%), p50 935 ms, $0.00141/FRQ. | Do not begin with complex routing or a larger model. First freeze precise criterion boundaries and test a cheap single-model baseline across providers. |
| FRQ-02 label audit and frozen Gemini confirmations | 100 responses/400 labels adjudicated; two paired n=40 paid runs | 23 source labels corrected. Final-gold agreement was 151/160 and 155/160; pooled 306/320 (95.6%); verdict stability 156/160 (97.5%). Cost ≈$0.00140/FRQ. p50 latency was 1,041 ms then 1,348 ms; p95 ≈2.4 s. | Quality and cost are confirmed for this single FRQ; speed is not. Do not run FRQ-02 n=100 until request architecture/latency is addressed. |
| Confidence-based primary→fallback | Nuanced Bio packet, 80 criteria | Primary-only 72.5%; fallback-only 40.0%; combined 53.75%. Combined fixed one row and worsened 13; p50 4.67 s. | Do not recreate a generic confidence-triggered fallback. Self-reported confidence is not a reliable routing signal. |
| Multi-model boundary audit | Nuanced Bio packet, 80 criteria | GPT-4o-mini, GPT-5.5, and DeepSeek tied at 58/80; disagreement localized fuzzy boundaries. | Use multiple models to discover boundary defects, not as a production voting ensemble. |
| DeepSeek V4 Pro primary grader | Same nuanced Bio packet | 68.75% vs GPT-4o-mini 72.5%; about 5.9× slower median and 2.5× costlier. | Do not promote DeepSeek V4 Pro as the default grader on this evidence. |
| Reference layers, exemplars, oracle precedents, gated prompting, online flywheel | Multiple Bio reference-layer experiments | None beat the no-card boundary-contract baseline; some worsened quality or latency. | Do not rebuild retrieval/reference complexity until a new, adjudicated error class specifically requires it. |
| Kimi grading protocol | Pre-registered only | The repository contains an experiment design, not a completed result. | Do not cite Kimi performance as measured. Execute only if it answers a still-open question after the speed architecture test. |
| `exemplar_mode: "with_exemplar"` few-shot injection (AP Statistics, held-out gold set, 2026-08-10) | 4 held-out items / 30 responses / 5 trials per case×arm, `grading-model-assessment` harness | **Inconclusive, not a clean replication of the Bio row above.** Point estimate ~~+4.7pp overall accuracy (58.3% vs 52.4%), bootstrap CI [0, 12.2]pp~~ *(corrected 2026-08-11, see note below this table)* — but `clusterBootstrapDifference` has no item-level grouping and reported 30 (response-level) clusters against the design's true n=4, so the CI is anti-conservative and no claim, positive or negative, is supported. Full writeup: `exemplar_grading_pilot_2026_08/REPORT.md`. | Do not ship on this evidence. Do not re-cite the +4.7pp/CI as a real effect. If this question is re-asked, fix item-level cluster-bootstrap support in `harness.ts` first — do not re-run with the same scoring code. |

> **Correction (2026-08-11), applies to the `exemplar_mode` row above — old
> numbers retained struck-through, not deleted.** The +4.7pp / [0, 12.2]pp
> figures were corrupted by a replay-parsing defect in `to_result_cases.mjs`
> (idempotency-replay responses carry `result.criterion_results`, not
> `result.criteria`; 5 fully-correct baseline-arm trials were scored as
> empty). Corrected: baseline 57.1% vs candidate 58.3%, point estimate
> **+1.4pp**, response-level CI **[−2.5, +6.7]pp**; the item-level cluster
> bootstrap the row's do-not-repeat column demanded now exists
> (`harness.ts` `collapseToItemClusters`) and gives +2.0pp,
> **[−2.3, +8.3]pp** over the correct 4 clusters. Coverage, abstentions,
> exact-case accuracy, and FNR equalize between arms. A further confound:
> 13/30 cases were decided arm-invariantly by the deterministic Statistics
> gate, 8 of them through the defective `APSTATS-SFRQ-008` key
> (`DETERMINISTIC_KEY_AUDIT_2026_08_11.md`). Verdict unchanged: do not
> ship; the exemplar/few-shot prompt-content direction is **closed**. Full
> correction: `exemplar_grading_pilot_2026_08/REPORT.md` §"Correction —
> 2026-08-11"; policy re-analyses:
> `exemplar_grading_pilot_2026_08/POLICY_SIMULATIONS_2026_08_11.md`.

Primary records:

- `frq_grading_status_2026-06-18.md`
- `grader_speed_sp1_report.md`
- `grader_speed_sp1_summary.json`
- `frq02_label_audit_2026_07_27/`
- `apbio_primary_fallback_takeaways.md`
- `apbio_nuanced_boundary_calibration_takeaways.md`
- `apbio_deepseek_v4_pro_boundary_test_takeaways.md`
- `apbio_kimi_grading_experiment_2026-07-17.md`
- `exemplar_grading_pilot_2026_08/REPORT.md`

### B. Deterministic, symbolic, and multi-modal experiments

| Experiment | Evidence/read tier | Result | Durable decision / do not repeat |
| --- | --- | --- | --- |
| Numeric deterministic checker | 320 Chemistry+Statistics development responses | 100% specificity: zero false flags on 69 correct answers; caught numeric-error class at $0; abstained on conceptual items. Two extractor bugs were found and fixed. | Do not ask an LLM to own keyed arithmetic. Revalidate extraction on every new corpus and abstain outside the key's scope. |
| Symbolic formula equivalence | 62 asserted development cases | 62/62; accepted equivalent forms and detected wrong formulas. Known flat-fraction notation hazard can false-flag. | Reuse the checker. Do not recreate equivalence logic in prompts. Ambiguous notation must abstain or use structured input. |
| ECF reference engine | Reference battery and Statistics templates | Two-universe ECF behavior validated; Statistics templates progressed to 7/7 chain checks. | Preserve downstream credit on the student's own upstream value when the rubric permits it; keep explicit chain/guardrail policy. |
| Formula transcription bake-off | 9 lines, synthetic renders, three models | All models 9/9 faithful, zero silent corruption; Phase B architecture work completed. | This proves pipeline mechanics. Do not rerun synthetic renders. Real-handwriting performance is a separate follow-up claim. |
| AP Statistics full deterministic triage | 100 FRQs | 28 numeric/keyed, 68 conceptual, 4 corpus-defect/method-only; 44/44 canonical integrity, 7/7 ECF. | Do not rescan/reclassify the same 100 items. Extend only when content changes or a new checker type is added. |

Primary records:

- `deterministic_check_experiment_2026_07_08/`
- `math_formula_grading_experiment_2026_07_08/`
- `statistics_phase_b_2026_07_08/`
- `AP_STATISTICS_PHASE_C_TRIAGE_2026_07_10.md`
- `AP_STATISTICS_PHASE_C_REMEDIATION_LOG_2026_07_09.md`

### C. Gold-set and production-path experiments

| Experiment | Evidence/read tier | Result | Durable decision / do not repeat |
| --- | --- | --- | --- |
| Three subject gold-candidate build | 20 responses each for Bio, Stats, Chem; calibration/silver | Packages and blind-scoring harnesses built. Chemistry truncation-degenerate variants were identified and later replaced with genuine wrong-reasoning variants. Deterministic cross-check found numeric labels robust; conceptual independence remained the gap. | Do not treat provisional/silver labels as release evidence. Do not generate “wrong” answers by truncation. |
| Statistics Phase C corpus expansion | 100 FRQ, 220 responses; 100 MCQ | Candidate corpus and MCQ bank built; content defects remediated; full deterministic triage completed. | Do not recreate the corpus. The next work is adjudication and calibration, not more synthetic breadth. |
| **Phase C cross-subject paired calibration (Stages 1–6)** | **100 items / 433 criteria / 537 paid calls, 9 subject SKUs; calibration-tier labels (not dual-human gold)** | **Neither arm meets the launch bar: agreement Arm A 90.6% / Arm B 92.4% vs ≥95%; p50 1,943 / 3,670 ms vs ≤1,000 ms. Cost solved ($0.0039/$0.0023 per FRQ). Under-credit outnumbers over-credit 3.3×/5×, concentrated in equivalent-form wording (75.0%) and boundary-adjacent responses (80.9%). Deterministic layer fired on 0.7% of calls.** | **Do not rerun the arm comparison — single-call batching is closed (Lesson 9). Do not re-derive the equivalent-form defect (Lesson 11) or the deterministic-coverage gap (Lesson 12). Next work is authoring accepted_variants for AP Statistics + AP Physics 1, then a fresh held-out slice excluding all 100 items used here. 4 of 5 feedback-quality dimensions remain unmeasured — do not cite feedback quality from this run beyond grounding.** |
| Production Engine 1 grading + repair pilot | 30 real authenticated calls across 6 approved items | 20 graded, 10 uncertain. Median 17.48 s, p90 91.10 s, mean cost $0.00997/call. Usable grades had no tier inversion, but JSON truncation, timeouts, one integrity false negative, accepted-variant errors, and repair-class errors occurred. Cleanup fully verified. | Do not widen learner-facing rollout. Fix uncertainty/output handling, integrity validation, accepted variants, and repair classification; then run controlled revisions to measure repair efficacy. |

Primary records:

- `grading_gold_set_candidates_2026_07_08_report.md`
- `label_robustness_crosscheck_2026_07_08/`
- `ap_statistics_gold_set_candidate_2026_07_09/`
- `ap_statistics_mcq_launch_bank_2026_07_09/`
- `grading_repair_pilot_2026_07_27/RESULTS_2026_07_27.md`
- `grading_repair_pilot_2026_07_27/EXECUTION_LOG.md`

## 4. Durable cross-subject conclusions

These are the lessons that should shape all subjects:

1. **Boundary precision before model complexity.**
2. **Separate cause, operation, and outcome.** Correct vocabulary attached to
   the wrong object is not sufficient evidence.
3. **Grade criteria locally unless the rubric explicitly couples them.**
4. **Make negation, hedging, temporal scope, contradiction, and ECF policy part
   of the criterion contract.**
5. **Deterministic-before-model:** exact match, arithmetic, formula
   equivalence, units, graph geometry, and dependency chains where safe;
   otherwise abstain.
6. **Equivalent forms must earn.** Canonical wording or algebraic form is not
   the construct.
7. **Gold quality is semantic, not structural.** Valid JSON and a provisional
   approval field do not make labels gold.
8. **Report by criterion/archetype and repeat runs.** Aggregate accuracy hides
   persistent weak boundaries and provider variability.
9. **Measure feedback quality and repair efficacy, not just point agreement.**
10. **Latency is architectural.** Multiple parallel criterion calls produce a
    max-of-N tail; escalation makes it worse.

The reusable criterion-contract fields are recorded in
`frq02_label_audit_2026_07_27/RESULTS_REPEAT2_FINAL_GOLD_2026_07_27.md`.

## 5. Next work that advances the plan

> **FRAMING REVISION 2026-07-28** — the Product Owner confirmed Cramapple serves
> a **stable, defined question set per subject** (questions fixed, answers vary).
> This reframes grading from an open-domain generalization problem into a bounded
> per-item content-engineering problem, and changes the corpus/holdout discipline
> below. See `STABLE_ITEM_SET_EXPERIMENT_STRATEGY_2026_07_28.md`. Key consequences:
> Stage 6 errors are **concentrated — 73/99 items already at 100%, and repairing
> ~8 named items clears the 95% bar**; ~24% of the measured error mass is an
> artifact of spatial (Engine 4) items being scored as text; **held-out discipline
> moves from items to answers**; and **prompt caching becomes available**, newly
> targeting the binding latency constraint (TTFB = 59% of the 1,000 ms budget).

In order:

1. ~~Execute **Phase C on a bounded cross-subject slice**, comparing one
   structured multi-criterion call with the current parallel-per-criterion
   design.~~ **DONE 2026-07-28** — parallel-per-criterion retained; batching
   closed (Lesson 9). See `grading_phase_c_calibration_2026_07_27/RESULTS.md`.
   **Superseded by:** author explicit `accepted_variants` / equivalent-form
   boundary language for the under-credit cluster (Lesson 11), prioritising
   AP Statistics (82.0%) and AP Physics 1 (85.2%), then rerun on a fresh
   held-out slice excluding all 100 items already used.
2. ~~Create and adjudicate the **student-response gold labels**.~~ **DONE** at
   `calibration` tier (100 responses / 437 criteria). **Still open:** these are
   NOT dual-human adjudicated gold, and 4 of the 5 required feedback-quality
   dimensions (reason match, minimum-fix sufficiency, improved-answer
   correctness, error-class accuracy) remain unmeasured — only grounding was.
3. **Build an escalation path — NEW TOP PRIORITY, β2-A 2026-07-28.**
   Engine 1 **never abstains**. On 56 blind-adjudicated genuinely-undecidable
   criterion labels it returned a confident verdict on 54, before *and* after
   30 hand-authored `abstention_policy` fields (McNemar 1 fixed / 2 broken,
   **p = 1.00**). The base prompt already instructed abstention, so this is not
   a missing instruction — prompt text cannot buy it. `confidence` read `high`
   on 100% of ambiguous input and 100% of the grader's own errors, so it cannot
   serve as a triage signal either. **Nothing currently routes to a human.**
   Escalation must be built *outside* the grading call. **β2-B (2026-07-28)
   measured both candidate mechanisms:** inter-run disagreement is free and
   specific (precision 62.5% vs a 7.4% base rate, 2.2% volume, 20.8x enriched
   on undecidable content) **but catches only 18.5%**; adding a deterministic
   absent-artifact detector reaches ~37% union recall. Competing-claims and
   truncation detection remain unsolved and hold the rest.
   **Ship disagreement-routing now; do not call the gap closed.**
   β2-B also produced the program's first grader-reliability figure:
   **99.4% run-to-run agreement on decidable content** (97.8% overall).
   See `B2B_STABILITY_AND_ESCALATION_SIGNAL.md`.
   See `grading_phase_c_calibration_2026_07_27/B2_ABSTENTION_RESULTS.md`.
   **Do not report escalation avoidance as validated** — it was tested directly
   at adequate power and did not occur.
4. **Expand deterministic verification-profile coverage** (Lesson 12): it fired
   on 0.7% of criteria. This is the most direct joint lever on both accuracy
   and the unmet latency bar. Engine 3's three production bugs are fixed
   (harness 211/211, unit tests 13/13) but **not deployed**.
5. **Decide the 1,000 ms launch bar** (Phase F): provider TTFB alone consumes
   59% of it. Not resolvable by grader architecture.
6. Fix and re-run the **Production Engine 1 narrow pilot** after uncertainty,
   integrity, accepted-variant, and repair-class issues are addressed.
7. Run the **real-handwriting transcription follow-up** when the product needs
   a handwriting-readiness claim.
8. Continue Engine 4 only through its planned QR → observation → gold →
   abstention → shadow sequence.

Do not advance to broad n=100 or learner-facing rollout merely because a
single-FRQ quality number clears 90%; the production path and end-to-end speed
currently do not.
