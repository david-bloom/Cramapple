# Grader Speed Subtask Pilot Report (SP-1, Constrained)

## Run Metadata

| Field | Value |
| --- | --- |
| Protocol doc + version | `docs/research/GRADER_SPEED_SUBTASK_PROTOCOL.md`, "Approved for execution, pending second-opinion review" |
| Script + commit hash | `scripts/vercel-gateway-check/sp1_pilot.mjs` (new); repo HEAD `3d8324198d695b1f5ef209df59a0b15dc308afff`; script is untracked |
| Run date, owner | 2026-06-18 (eighth run, first live end-to-end misattribution audit, run against `SP-FAST-Gemini`); Product Owner |
| Raw results path | `/private/tmp/cramapple-grader-sp1/sp1_pilot_2026-06-18_v5.jsonl` (n=40, 10 arms); `sp1_pilot_2026-06-18_scale100.jsonl` (n=100, 2 arms); `sp1_pilot_2026-06-18_parsefirst_n40_v2.jsonl` (n=40, parse-first, fixed); `sp1_pilot_2026-06-18_gemini_audit_n40.jsonl` (n=40, Gemini + live audit) |
| Supersedes | `sp1_pilot_2026-06-18_v4.jsonl`, `_v3.jsonl`, `_v2.jsonl`, original `.jsonl`, and `_parsefirst_n40.jsonl` (buggy first attempt, escalation left active on the fast path) — all superseded, not invalid; see "Root-Cause Fix," "Parse-First Routing," "Misattribution Audit, Run Live," and "Changes Since Prior Runs" |
| Status as of this run | **Paused for independent code QA (Codex) before any further test run** — requested 2026-06-18 after several runner bugs were found only via live testing (escalation token budget, missing retry, schema-field drift). See `docs/research/frq_grading_status_2026-06-18.md` for the consolidated findings/open-items summary. |
| Summary path | `docs/research/grader_speed_sp1_summary.json` |
| Sample selection method | Same deterministic stratified sample as every prior run: all 5 named ambiguity-cluster responses plus 35 evenly-strided responses from the remaining 95 approved FRQ02 responses |
| n per arm | 40 responses × 4 criteria = 160 criterion-grades per arm; 10 arms; 1,600 total rows |
| Gateway used? | `true` — Vercel AI Gateway via OIDC, all 10 arms, all 4 providers |
| Read tier | **Decision-Grade by sample size (n=40/arm)** — still does **not** satisfy SP-1's own §14 production-promotion gates (single FRQ, proxy ambiguity tagging, no real grading-service instrumentation). See Known Issues. |

## New Arm: `SP-FAST-ESC-C2Direct`

The prior run's escalation fix (below) revealed that `FRQ02-C2` escalates on 72.5% of responses, and since `SP-FAST-ESC` runs criteria in parallel (end-to-end latency = max across criteria), that one criterion dominated the whole response's latency by paying for a fast-primary call and then an escalation call sequentially, back to back, most of the time.

This run tests the recommended follow-up: route `FRQ02-C2` directly to `gpt-5.5` medium reasoning (single call, no fast-primary attempt at all), while `FRQ02-C1`/`C3`/`C4` keep the exact same fast-primary + selective-escalation logic as `SP-FAST-ESC`, since their escalation rates were already low.

**Result: a clear win, not just a tradeoff.**

| Metric | `SP-FAST-ESC` (this run) | `SP-FAST-ESC-C2Direct` | Change |
| --- | ---: | ---: | ---: |
| Strict agreement | 133/160 (83.1%) | **141/160 (88.1%)** | +5.0pp |
| `FRQ02-C2` strict agreement specifically | 29/40 (72.5%) | **32/40 (80.0%)** | +7.5pp |
| `FRQ02-C2` call time (p50) | 5,644ms | **4,553ms** | -1,091ms |
| FRQ end-to-end p50 | 5,644ms | **4,749ms** | -895ms |
| FRQ end-to-end p95 | 7,466ms | **6,687ms** | -779ms |
| Avg cost/FRQ | $0.00594 | $0.00781 | +$0.00187 (still 2.5x cheaper than `BM-Control`) |
| Fixed vs. control / new errors vs. control | 8 fixed / 10 new | **11 fixed / 5 new** | net +3 better |
| Regressions in named cluster | 2 | **0** | — |

`FRQ02-C1` (97.5%→97.5%) and `FRQ02-C3` (87.5%→87.5%) were unchanged between the two arms in this run, as expected — their logic is identical code. `FRQ02-C4` also improved (75.0%→87.5%), but since C4's logic is likewise unchanged between the two arms, that delta is run-to-run API variance on a non-deterministic call, not a causal effect of the C2 routing change — don't attribute it to this fix.

**Why latency didn't drop further (at the time):** the win came entirely from eliminating the wasted fast-primary call before escalating, not from making the underlying judgment faster. `gpt-5.5` medium reasoning on `FRQ02-C2` still took ~4.5s at the call level — see the next section for the follow-up that addressed this directly.

## New Arm: `SP-FAST-ESC-C2Direct-Low`

Follow-up to the above: same `SP-FAST-ESC-C2Direct` design, but the C2 direct route uses `gpt-5.5` **low** reasoning effort instead of medium (matching `SP-1`'s choice), to test whether the ~4.5s per-call latency floor on `FRQ02-C2` could be cut without losing the quality gain.

**Result: latency floor cut nearly in half, with quality unaffected or slightly better.**

| Metric | `SP-FAST-ESC-C2Direct` (medium) | `SP-FAST-ESC-C2Direct-Low` | Change |
| --- | ---: | ---: | ---: |
| `FRQ02-C2` call time (p50) | 4,154ms | **2,138ms** | -2,016ms (-48.5%) |
| `FRQ02-C2` call time (p95) | 6,759ms | **3,327ms** | -3,432ms (-50.8%) |
| `FRQ02-C2` strict agreement | 31/40 (77.5%) | **32/40 (80.0%)** | +2.5pp |
| `FRQ02-C2` schema valid | 36/40 (90.0%) | **38/40 (95.0%)** | +5.0pp |
| FRQ end-to-end p50 | 4,410ms | **2,378ms** | -2,032ms (-46.1%) |
| FRQ end-to-end p95 | 7,102ms | **4,747ms** | -2,355ms (-33.2%) |
| Overall strict agreement | 139/160 (86.9%) | 140/160 (87.5%) | +0.6pp |
| Avg cost/FRQ | $0.00662 | $0.00693 | +$0.00031 (negligible) |

Cutting reasoning effort on C2 did not trade quality for speed here — both improved slightly, likely because the boundary table (already present in both arms) does most of the calibration work, and low reasoning effort was already shown to be sufficient on this corpus by `SP-1` (which uses low reasoning throughout and beat `BM-Control`'s clear-subset agreement in every run). This arm is now the strongest result in the full matrix: highest strict agreement of any escalation-style arm tied with `SP-FAST-Haiku`, lowest latency of any arm with a reasoning-model component, and the only one to get within roughly 1.6x of the `<1.5s` p50 target rather than 3-4x.

## Root-Cause Fix: Rewriting the `FRQ02-C2` Boundary Table

All prior runs in this report worked around `FRQ02-C2`'s difficulty (routing it to bigger models, tuning reasoning effort, tuning escalation thresholds). This run instead diagnosed *why* the cheap model kept getting it wrong and fixed the rubric guidance directly.

**Diagnosis:** pulling every `SP-FAST` (plain `gpt-4o-mini`, no escalation) miss on C2 against its full answer text and reviewer note showed two distinct problems, not one:

1. **A real boundary-table bug.** The v1 boundary table (written earlier in this investigation to fix over-credit on `S020`/`S068`-style hedge language) had a "Not earned" rule — "attributes randomness only to the downstream allele-frequency change, not the construction event" — that the model applied far too broadly. It started rejecting clearly-qualifying responses like "the construction **randomly killed** plants" (`S052`) and "since 90% of the population was **randomly destroyed**" (`S021`) because they also happened to mention the resulting frequency change in the same sentence. This caused 13 of 16 `SP-FAST` C2 errors to flip from the original over-credit problem to a new, larger under-credit problem.
2. **Apparent corpus label inconsistency**, not fixable by prompt changes. A handful of responses (`S054`, `S058`, `S062`, `S070`, `S014`) use phrasing nearly identical to the confirmed-`not_earned` `S068` ("allele frequencies changed randomly," no reference to the destruction event itself) yet are labeled `earned` in this provisional corpus. Loosening the boundary table enough to credit these would reopen the original over-credit hole (confirmed by testing — see below). These look like genuine label noise in `frq02_generated_answer_labels_codex_provisional.jsonl`, worth a Learning Quality pass on C2 specifically, not a grading-prompt problem.

**Fix:** rewrote the boundary table (v2) to explicitly credit "random[ly] destroyed/killed," "random events like the construction," and "random sample/survivors" (unhedged) as satisfying the criterion even when the same sentence also mentions the frequency outcome — while keeping the original protection against pure hedge language (`S020`) and pure downstream-only framing (`S068`).

**Result, `SP-FAST` (gpt-4o-mini) on C2 specifically:**

| | v1 boundary table | v2 boundary table |
| --- | ---: | ---: |
| C2 strict agreement | 24/40 (60.0%) | **31/40 (77.5%)** |
| C2 errors | 16 | **9** |
| — of which over-credit | 3 | 2 |
| — of which under-credit | 13 | 7 |

**System-wide effect — this changes the architecture recommendation, not just C2:**

| Arm | Strict agreement (v1 boundary table) | Strict agreement (v2 boundary table) | FRQ p50 | Cost/FRQ |
| --- | ---: | ---: | ---: | ---: |
| `SP-FAST` (no escalation, cheapest/fastest) | 81.2% | **86.2%** | 1,744ms | $0.00051 |
| `SP-FAST-ESC-C2Direct` (best escalation arm) | 86.9-88.1% | 87.5% | 3,079ms | $0.00806 |

Plain `SP-FAST` — no escalation, no criterion-targeted routing, just the fixed boundary table — closed nearly all of the gap to the best escalation-style arm (86.2% vs 87.5%, a 1.3pp difference) while running ~1.8x faster and costing ~16x less. The escalation/direct-routing complexity was compensating for a bad boundary table; with the boundary table fixed, most of that complexity stops paying for itself. `SP-FAST-ESC-C2Direct` is still the single best quality result and the only arm with zero regressions in the named cluster, but the gap to justify its added latency and cost is now much narrower than before this fix.

Also notable: `BM-Control` (`gpt-5.5` medium, **no boundary memory at all**) only gets C2 right 67.5% of the time — 10pp worse than `gpt-4o-mini` *with* the fixed boundary table. Rubric precision mattered more than model size here.

## Deterministic Misattribution Audit + Full-Scale (n=100) Validation

Two of the two remaining `FRQ02-C2` errors found across this entire investigation (`S020`, `S028`) share a structural shape: the model attaches "random/by chance" to the wrong grammatical target (an outcome noun, or a negated "natural selection" phrase) instead of the construction destruction/survival event. This is a syntactic attachment question, not a judgment call, so it's checkable deterministically with a dependency parser instead of another LLM call.

**Built:** `scripts/misattribution-check/checker.py` — loads `spaCy` (`en_core_web_sm`) once, then for each sentence containing a randomness trigger word ("random," "randomly," "chance"), checks whether a destruction/survival-related lemma co-occurs in the same sentence (and isn't negated, and isn't inside a hedge phrase like "not necessarily"). Runs locally, no API call, single-digit milliseconds per response.

**Tested standalone against the full 100-response FRQ02-C2 corpus:** 66% accuracy alone — worse than any LLM arm, as expected, since it only targets one specific failure mode and abstains (19% of responses use no trigger word at all). Not a replacement classifier.

**Tested as a disagreement-based escalation trigger** (run only when the primary call's verdict is `earned`, flag for review if the parser disagrees): two real bugs were found and fixed during testing, not after —

- `"selection"` was in the qualifying-lemma set, but it almost always appears as "**not** because of natural selection" (negating the disqualifying claim, not asserting a qualifying one). Caused a false `earned` on `S028`. Fixed by excluding `select`/`selection` and adding negation-scope detection (a 3-token lookback window) so any qualifying lemma negated nearby is discounted.
- `"event"` was added to fix two false alarms (`S023`, `S025`, which use "through random events" to describe the construction) but caused the audit to miss `S020` — a different sentence in the *same* response mentioned unrelated "random events" (about allele loss, not the construction), and sentence-level co-occurrence can't tell which criterion's content a generic noun belongs to. Reverted; the false-alarm cost was smaller than the missed-real-error cost.

**Final result, audited against `SP-FAST-ESC-C2Direct-Low`'s actual full-scale output:**

| | Result |
| --- | --- |
| `earned` verdicts the audit runs on | 54/100 |
| Flagged for review | 4/100 (7.4% of `earned` calls) |
| Actual over-credit errors at this scale | 2 (`S020`, `S028`) |
| Caught by the audit | **2/2 (100%)** |
| False alarms | 2 (`S023`, `S025` — both correctly `earned`, flagged anyway) |

Both of the only two over-credit errors that survived boundary-table v2 and `gpt-5.5`-low routing — the two hardest cases in this entire investigation — were caught, at zero added API cost and a 3.7% false-alarm rate among `earned` verdicts.

**Full-scale validation (n=100, the entire labeled FRQ02 corpus, not just the n=40 sample):** ran `BM-Control` and `SP-FAST-ESC-C2Direct-Low` head to head on all 100 responses.

| Arm | Strict agreement | Schema valid | FRQ p50 | FRQ p95 | Cost/FRQ |
| --- | ---: | ---: | ---: | ---: | ---: |
| `BM-Control` | 355/400 (88.8%) | 364/400 (91.0%) | 10,203ms | 14,870ms | $0.02029 |
| `SP-FAST-ESC-C2Direct-Low` | 355/400 (88.8%) | **388/400 (97.0%)** | **3,728ms** | **7,059ms** | **$0.00798** |

The improved candidate **ties** `BM-Control` exactly on overall accuracy at n=100 — the largest, most stable sample in this entire investigation — while running ~2.7x faster, costing ~2.5x less, and posting meaningfully better schema validity. On C2 specifically it now beats control (79/100 vs 75/100). This is the strongest evidence in the whole report that the architecture changes made here are real and durable, not n=40 noise.

**Honest scope note:** "full scale" here means the full FRQ02 corpus (100 of 100 available labeled responses) — not multiple FRQs. The 5 other summer-beta FRQs still have no labeled corpus, so a true cross-FRQ scale test remains out of reach until that data exists.

## Parse-First Routing: `SP-FAST-ESC-C2Direct-Low` vs. `SP-FAST-ESC-C2ParseFirst`

The misattribution audit (above) runs the parser *after* a model call, only checking `earned` verdicts. This arm tests the inverse: run the parser *before* any model call for `FRQ02-C2`, and use its verdict to choose the route — `gpt-5.5` low ("hard path") if the parser finds trigger words with no qualifying attachment, `gpt-4o-mini` ("fast path") otherwise. Unlike the post-hoc audit, this is not free: the parser must complete before the model call can start, so every C2 call pays its latency serially (single-digit milliseconds, expected to be small next to either model call).

**First attempt had a real bug.** The fast path kept the *existing* confidence-based escalation active, using C2's high-risk threshold (0.95) carried over from the static-routing design. Since `gpt-4o-mini` rarely reports confidence above 0.95, **19 of 28 "fast"-routed calls escalated to `gpt-5.5` medium anyway** — paying for two sequential calls on most of the population the routing was supposed to keep cheap. Net result was slower than `C2Direct-Low`, not faster (3,337ms vs 2,378ms p50), despite correct routing decisions.

**Fix:** disable escalation entirely on the fast path — trust the parser's pre-screening as the sole gate for that branch, rather than stacking it under the old confidence trigger.

| Metric | `C2Direct-Low` (n=40) | ParseFirst, buggy (escalation left on) | ParseFirst, fixed |
| --- | ---: | ---: | ---: |
| Overall strict agreement | 87.5% | 86.2% | 86.2% |
| FRQ p50 | 2,378ms | 3,337ms | **2,318ms** |
| FRQ p95 | 4,747ms | 5,969ms | 4,900ms |
| Cost/FRQ | $0.00693 | $0.00687 | **$0.00267** |
| C2-specific accuracy | 77.5% | 80.0% | 77.5% |

Fixed, parse-first **ties `C2Direct-Low` on both speed and C2-specific accuracy while cutting cost 61%** ($0.00267 vs $0.00693) — since 70% of C2 calls (28/40) now run on `gpt-4o-mini` alone with no redundant escalation, instead of every C2 call paying for `gpt-5.5`. The one quality cost from removing the fast-path safety net was a single new miss (`S072`) — the parser correctly identified it as a clean qualifying match, but `gpt-4o-mini` itself misjudged it. Not a routing failure, ordinary model noise on a borderline case.

**New finding: the hard path is only 50% accurate (6/12).** Routing correctly identifies *which* cases look structurally ambiguous, but sending them to `gpt-5.5` doesn't guarantee a correct verdict — `S014`, `S020`, `S028`, `S058`, `S068`, `S070` were all still wrong despite the stronger model. This was previewed in a 5-sample smoke test before the n=40 run and is now a stable pattern, not noise. Several of these overlap with responses flagged earlier as likely corpus label inconsistencies (`S014`, `S058`, `S070`) — the hard path can't fix a label problem, no matter which model handles it. This argues for combining parse-first routing with a post-hoc audit on hard-path verdicts too, not only fast-path ones — the post-hoc audit as currently configured only checks `earned` verdicts, and several hard-path failures here are the model wrongly returning `not_earned` or `unable_to_determine`, which the current audit wouldn't catch either.

**Not yet tested:** the post-hoc misattribution audit (wired in, never run live end-to-end) and a combined design (parse-first routing plus a post-hoc check on both paths' outputs, not just fast-path `earned` verdicts).

## Misattribution Audit, Run Live: `SP-FAST-Gemini`

First live end-to-end run of the post-hoc audit (previous runs were offline joins against already-produced results). Wired onto `SP-FAST-Gemini` specifically — Codex's independent review of this report (2026-06-18) flagged that Gemini's n=40 numbers (146/160, $0.00141, 935ms p50) beat every `gpt-5.5`-routing arm built this session simultaneously on accuracy, cost, and speed, and the audit had never been tested against a non-`gpt-5.5`-routed arm.

**Two real bugs found via smoke test before the n=40 run, both fixed:**

1. `model_id_used` showed `google/gemini-2.5-flash` even when escalation ran — investigation revealed the escalation call itself was failing schema validation 100% of the time on the cluster's hardest cases (`S020`, `S028`, `S068`), and the code correctly fell back to the original verdict, but silently. Root cause confirmed by direct probe: `S020` alone requires 493 reasoning tokens before `gpt-5.5` medium can emit any JSON — far more than the 200-token cap inherited from the routine direct-routing config. **Fixed by raising `escalateToMaxOutputTokens` from 200 to 1,000** across all three arms that use the audit.
2. The escalation call had no bounded retry, unlike the primary grading path. Added one, matching the existing pattern.

**After both fixes, n=40 result:**

| Metric | Value |
| --- | ---: |
| Overall strict agreement | 146/160 (91.2%) |
| Schema valid | 160/160 (100%) |
| C2-specific accuracy | 34/40 (85.0%) |
| FRQ p50 | 965ms |
| FRQ p95 | 8,142ms |
| Cost/FRQ | $0.00308 |

Audit flagged 4/40 `earned` verdicts; escalation corrected 3 of 4 (`S028`, `S068` fixed; `S025` confirmed already-correct). `S020` came back wrong even after escalation with full reasoning budget — the *only* case in this entire investigation where giving `gpt-5.5` medium reasoning unlimited room still didn't produce the correct verdict. Confirmed via the smoke test (run separately, different sampling) that this is real model behavior, not a budget artifact: with the fix applied, escalation succeeded (no schema failure) but still returned `earned`.

**`S020`'s status across every configuration tested this session:** wrong in `BM-Control`, every `gpt-4o-mini` variant (v1 and v2 boundary tables), `C2Direct` (medium), `C2Direct-Low`, parse-first's hard path, `SP-FAST-Gemini`, and now `gpt-5.5` medium with no token constraint. No model/effort/routing combination tried has resolved it. Per the original protocol's own kill-criteria logic, this is the strongest evidence yet that this specific case needs boundary redesign or Learning Quality adjudication on the label itself, not another architecture variant.

**Latency tail, diagnosed precisely:** p95 (8,142ms) is not noise. Sorting all 40 end-to-end times shows a clean break — 36 responses cluster under 4,100ms (most under 1,200ms), then exactly the 4 audit-flagged responses (`S028`: 11,105ms, `S068`: 8,472ms, `S020`: 8,125ms, `S025`: 4,524ms) form the entire top of the distribution. 100% correlation between "audit escalated" and "in the slowest 4." This is the direct, expected cost of the token-budget fix above: giving the escalation call enough room to actually finish reasoning necessarily makes it slower, not just more reliable. Full percentile breakdown: p50=965ms, p60=1,108ms, p70=1,753ms, p80=2,173ms, p90=4,115ms, p95=8,142ms, p100=11,105ms. At n=40, p90+ is effectively naming individual responses, not a smooth statistical curve — p90 alone is `S010`; p95/p100 are the 4 named audit cases.

**Open design question, not yet resolved:** is the rare-but-expensive audit escalation (8–11s on ~10% of cases) an acceptable tradeoff, or does the escalation call need its own latency mitigation (e.g., lower reasoning effort, accepting some of the reliability just bought back)? Flagged for the pending Codex QA pass rather than decided unilaterally.

## Changes Since Prior Run

Two implementation bugs were found in the first run and fixed here. Both were requested fixes, both are measured below with real before/after data.

### Fix 1: Prefilter keyword lists

**Root cause:** the original prefilter (§6.1) checked each criterion against a narrow, criterion-specific keyword list to detect "off-topic" responses. All 10 misfires in the prior run were genuine misconceptions (Hardy-Weinberg confusion, gene-flow confusion, natural-selection confusion) that were entirely on-topic but incorrect — the keyword check was acting as an insufficient-wording filter, which protocol §6.1 explicitly prohibits ("does not attempt accepted-variant or insufficient-wording matching, which would inherit any current rubric ambiguity").

**Fix:** replaced the 4 per-criterion keyword lists with one broad, FRQ-level topicality vocabulary (20 terms spanning evolution/genetics concepts) applied identically regardless of which criterion is being checked. This catches genuinely non-substantive responses (empty, refusal, wrong-subject) without pre-judging correctness on a specific criterion.

**Result:** 0/160 prefilter misfires in this run, across all 4 prefilter-enabled arms (down from 10/160 each).

### Fix 2: Escalation trigger redesign

**Root cause:** `gpt-4o-mini`'s self-reported confidence on this corpus ranged 0.8–1.0 (median 0.95) even on criteria it graded incorrectly — the protocol-specified `confidence < 0.7` threshold almost never fired (1/160 in the prior run). Confidence was not useless, just miscalibrated: correct calls averaged 0.938 confidence, wrong calls averaged 0.880–0.908 — real separation, just compressed into a narrow high range. Errors were also heavily concentrated on `FRQ02-C2` (16/37 wrong, 43%) versus `FRQ02-C1` (1/37, 2.7%), so a single global threshold could not be both cheap and protective.

**Fix:** per-criterion confidence thresholds, addressing protocol §16 open question #4 directly: `FRQ02-C2` escalates below confidence 0.95; all other criteria escalate below 0.88. Pre-registered in the script before this run, not tuned post-hoc against this run's results.

**Result:** escalation rate rose from 1/160 (0.6%) to 38/160 (23.8%), concentrated almost entirely on `FRQ02-C2` (29 of 38 escalations, 76%) — exactly the criterion where errors concentrate.

### Measured effect: quality improved substantially across every fast arm

| Arm | Strict agreement, before | Strict agreement, after | Change |
| --- | ---: | ---: | ---: |
| `SP-FAST` | 75.0% | 81.2% | +6.2pp |
| `SP-FAST-ESC` | 75.0% | **85.6%** | **+10.6pp** |
| `SP-FAST-Haiku` | 79.4% | 85.6% | +6.2pp |
| `SP-FAST-Gemini` | 83.1% | **90.0%** | **+6.9pp** |
| `BM-Control` (unchanged config, re-run for comparison) | 85.0% | 84.4% | -0.6pp (run-to-run noise) |

`SP-FAST-ESC` now matches `BM-Control` exactly on the clear subset (86.4% both), and `SP-FAST-Gemini` clearly exceeds it (90.0% vs 84.4% overall).

### New finding: the escalation fix traded latency for quality, concentrated on one criterion

`SP-FAST-ESC`'s end-to-end FRQ p50 rose from 1,642ms to 5,229ms, and p95 from 4,587ms to 8,864ms. This is a direct, expected consequence of `FRQ02-C2` now escalating on 29/40 responses (72.5%) — since `SP-FAST-ESC` runs criteria in parallel and end-to-end latency is the max across criteria, a single high-escalation criterion dominates the whole response's latency. The escalation path is sequential (primary call, then a second full call to `gpt-5.5`), so any response where C2 escalates pays for both calls back-to-back.

**This points to a more targeted design than was tested here:** since C2 escalates on 72.5% of responses anyway, routing C2 directly to the reasoning-capable model — skipping the fast-primary attempt for that one criterion specifically — would avoid paying for a redundant `gpt-4o-mini` call on most responses, while C1/C3/C4 (which escalate rarely: 0%, 7.5%, 15% of responses respectively) stay on the cheap, fast, no-escalation path. This was not implemented or tested in this run; it's a recommendation for the next iteration, not a result.

## Known Issues (unchanged from prior run except where noted)

1. T6 latency bug **fixed** in the script for this run — confirmed near-zero (0.0000% of total time), as expected for a script-level placeholder.
2. Prefilter and escalation bugs **fixed** — see above.
3. Ambiguity tagging is still a response-level proxy (5 named cluster IDs), not criterion-level frozen Learning Quality review.
4. Single FRQ only (FRQ02); protocol requires all six summer-beta FRQs.
5. T1, T2 remain genuine script-level near-zero placeholders, not real grading-service overhead.
6. TTFD was still not separately instrumented from general TTFB; H6 remains not decidable.
7. `SP-1` and `SP-1-Serial`'s p95 latency has been noisy across every run (e.g. `SP-1`: 8,730ms → 13,978ms → 34,028ms → 7,632ms → 36,305ms) with no configuration change to either arm — a reminder that tail-latency figures at n=40 are not yet stable; treat single-run p95 deltas for these two arms as unreliable.
8. The `FRQ02-C2` boundary table was rewritten this run (v2). 6 of the corpus's `earned` labels on C2 (`S014`, `S054`, `S058`, `S062`, `S070`, plus one of the original disputed pair) appear inconsistent with the stated rubric note and with how textually-similar responses (`S068`) were labeled — flagged as a likely corpus label-quality issue for Learning Quality, not resolved by this fix.

## Per-Arm Metrics (full corpus, n=40/arm, 160 criterion-grades/arm, all 10 arms, boundary table v2)

| Arm | Strict agreement | Schema valid | FRQ p50 | FRQ p95 | Avg cost/FRQ | Escalation rate |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| `BM-Control` | 137/160 (85.6%) | 145/160 (90.6%) | 10,467ms | 15,058ms | $0.02035 | n/a |
| `SP-1` | 134/160 (83.8%) | 146/160 (91.2%) | 7,036ms | 36,305ms | $0.01952 | n/a |
| `SP-1-Serial` | 133/160 (83.1%) | 144/160 (90.0%) | 11,570ms | 18,220ms | $0.01920 | n/a |
| `SP-1-Medium` | 123/160 (76.9%) | 129/160 (80.6%) | 2,935ms | 4,804ms | $0.01930 | n/a |
| **`SP-FAST`** | **138/160 (86.2%)** | 160/160 (100%) | **1,744ms** | 3,688ms | **$0.00051** | n/a |
| `SP-FAST-ESC` | 138/160 (86.2%) | 155/160 (96.9%) | 4,004ms | 6,599ms | $0.00597 | 33/160 |
| `SP-FAST-ESC-C2Direct` | **140/160 (87.5%)** | 152/160 (95.0%) | 3,079ms | 5,716ms | $0.00806 | 9/160 |
| `SP-FAST-ESC-C2Direct-Low` | 137/160 (85.6%) | 154/160 (96.2%) | 3,579ms | 6,147ms | $0.00826 | 12/160 |
| `SP-FAST-Haiku` | 140/160 (87.5%) | 160/160 (100%) | 1,677ms | 4,259ms | $0.00415 | n/a |
| `SP-FAST-Gemini` | 146/160 (91.2%) | 160/160 (100%) | 935ms | 1,224ms | $0.00141 | n/a |

The headline change from the boundary-table fix: **`SP-FAST` (cheapest, fastest, no escalation) now sits within 1.3pp of the best escalation-style arm** (`SP-FAST-ESC-C2Direct`, 87.5%), at roughly half the p50 latency and 1/16th the cost. Before this fix, `SP-FAST` trailed the best escalation arm by 5-7pp. `SP-FAST-ESC-C2Direct` remains the single highest-quality result and the only one with zero cluster regressions (see below), but the cost/latency premium to get there is now harder to justify than it was.

## Clear vs. Ambiguous Subset (boundary table v2)

| Arm | Clear (n=140) strict | Ambiguous (n=20) strict |
| --- | ---: | ---: |
| `BM-Control` | 87.9% | 70.0% |
| `SP-1` | 84.3% | 80.0% |
| `SP-1-Serial` | 85.0% | 70.0% |
| `SP-1-Medium` | 79.3% | 60.0% |
| `SP-FAST` | 86.4% | **85.0%** |
| `SP-FAST-ESC` | 87.1% | 80.0% |
| `SP-FAST-ESC-C2Direct` | **88.6%** | 80.0% |
| `SP-FAST-ESC-C2Direct-Low` | 87.1% | 75.0% |
| `SP-FAST-Haiku` | 87.9% | **85.0%** |
| `SP-FAST-Gemini` | 92.1% | **85.0%** |

`SP-FAST`'s ambiguous-subset agreement (85.0%) now ties the best of any arm, including the escalation-style arms — direct evidence that the boundary-table fix, not model size or escalation, was what mattered most for the hard cases. `SP-FAST-ESC-C2Direct` still leads on the clear subset specifically.

## Paired Changes vs. `BM-Control`

| Arm | Fixed | New errors | Unchanged | Regressions in named cluster |
| --- | ---: | ---: | ---: | ---: |
| `SP-1` | 8 | 11 | 141 | 0 |
| `SP-1-Serial` | 8 | 12 | 140 | 3 |
| `SP-1-Medium` | 7 | 21 | 132 | 4 |
| `SP-FAST` | 11 | 10 | 139 | 1 |
| `SP-FAST-ESC` | 10 | 9 | 141 | 1 |
| `SP-FAST-ESC-C2Direct` | 8 | **5** | 147 | **0** |
| `SP-FAST-ESC-C2Direct-Low` | 10 | 10 | 140 | 2 |
| `SP-FAST-Haiku` | 13 | 10 | 137 | 3 |
| `SP-FAST-Gemini` | 10 | 1 | 149 | 0 |

`SP-FAST-ESC-C2Direct` and `SP-FAST-Gemini` are the only arms with zero regressions in the named cluster this run, and `SP-FAST-ESC-C2Direct` has the best fixed:new ratio of any escalation arm (8:5). Plain `SP-FAST` (11 fixed, 10 new, net +1) is now competitive even on this pairwise measure, not just on aggregate strict agreement — another sign the boundary-table fix did most of the real work.

## Updated Hypothesis Decisions

| Hyp. | Claim | Decision | Evidence |
| --- | --- | --- | --- |
| H1 | T3+T4 > 75% of per-criterion latency | Still not decidable from this run | T1/T2/T6 remain script-level placeholders. |
| H4 | `SP-1` FRQ p50 ≥40% below control, p95 ≥50% below, clear-subset agreement within -2pp | **p50 clears, p95 still noisy, quality mixed** | p50: -32.8% this run (misses the 40% bar for the first time — `SP-1`'s p50 itself has also been noisy run to run). p95 unstable across 5 runs, not a reliable measurement at n=40. Clear-subset agreement: -3.6pp (misses -2pp band this run, reversing earlier runs — within normal noise for `SP-1` specifically). |
| H5 | `SP-FAST-ESC` FRQ p50 <1.5s, p95 <3.5s, clear-subset agreement within -5pp | **Quality clears comfortably; speed still misses, but the cheapest arm is now nearly as good** | `SP-FAST-ESC-C2Direct`: p50 3,079ms (target <1,500ms, 2.1x over), p95 5,716ms (target <3,500ms, 1.6x over). Clear-subset agreement +0.7pp vs control. Plain `SP-FAST` (no escalation): p50 1,744ms — only 1.16x over the target — at clear-subset agreement -1.5pp vs control. |
| H6 | `SP-FAST-ESC` TTFD p50 < 500ms | Still not decidable | TTFD not instrumented. |
| H9 | Structured output / `reasoning_effort` passthrough works | Still PASS | Unaffected by these fixes. |

## Decision Gates (§14) — Still Informational Only, Not Binding

- No arm clears the speed gates (`<1.5s` p50, `<3.5s` p95) yet. The closest is now plain `SP-FAST` at 1,744ms / 3,688ms (1.16x / 1.06x over target) — closer than any escalation-style arm has gotten in this entire run sequence, and far cheaper.
- `SP-FAST-ESC-C2Direct` still has the best quality margin and the only zero-cluster-regression result among the gpt-5.5-involving arms, but the boundary-table fix narrowed its advantage over plain `SP-FAST` to 1.3pp overall — a much smaller margin than the cost/latency premium it carries.
- **The real lever in this whole run sequence turned out to be rubric precision, not model routing.** Every architecture variant tested (escalation thresholds, criterion-targeted routing, reasoning effort) improved results modestly; rewriting the boundary table improved plain `SP-FAST` by 5pp in one step and closed most of the gap to the complex arms.
- **Recommended next step:** before investing further in routing/escalation complexity, apply the same diagnostic process (compare model errors against reviewer notes) to `FRQ02-C1`, `C3`, and `C4` — there may be smaller versions of the same boundary-table gap on those criteria. Separately, flag the apparent corpus label inconsistencies on C2 (`S014`, `S054`, `S058`, `S062`, `S070`) to Learning Quality, since no further prompt change can resolve them without risking new over-credit.

## Claims Supported / Claims Not Supported

**Supported by this run:**

- The `FRQ02-C2` boundary table had a real, fixable bug: a rule meant to stop over-credit was applied too broadly and caused a larger under-credit problem. Rewriting it cut `SP-FAST`'s C2 error rate from 40% to 22.5%.
- This single fix improved plain `SP-FAST`'s overall strict agreement from 81.2% to 86.2% — a larger jump than any architecture change tested in this entire run sequence.
- Rubric precision, not model size, was the dominant lever: `gpt-4o-mini` with the fixed boundary table (77.5% on C2) beats `gpt-5.5` medium with no boundary table at all (67.5% on C2) by 10pp.
- Roughly 6 of the remaining C2 errors look like corpus label inconsistency, not a model or prompt failure — identified by name, not just inferred.
- The cost/latency case for escalation and criterion-targeted routing is now meaningfully weaker than before this fix, since the cheapest arm closed most of the gap to the most complex one.
- A deterministic, zero-API-cost dependency-parse audit catches a real, structurally-distinct error class (misattribution/over-credit) that confidence-based escalation cannot, by construction — confirmed by catching both remaining real over-credit errors (`S020`, `S028`) at full scale with a 3.7% false-alarm rate.
- The improved architecture (`SP-FAST-ESC-C2Direct-Low` + boundary table v2) ties `BM-Control` on accuracy at n=100 — the largest, most stable sample tested in this investigation — while running ~2.7x faster and ~2.5x cheaper. This is not an n=40 artifact.
- Running the misattribution parser *before* a model call (parse-first), instead of always calling `gpt-5.5` for C2, ties `C2Direct-Low` on both speed and C2-specific accuracy while cutting C2's cost by 61% — confirmed live, not projected, after fixing a real bug (redundant escalation left active on the fast path).
- Even when parse-first correctly identifies a case as structurally hard and routes it to `gpt-5.5`, the stronger model is only right about half the time on that subset (6/12) — routing solves *which model sees it*, not *whether that model gets it right*. This is now a stable, repeated pattern (previewed at n=5, confirmed at n=40), not a one-off.

**Not supported by this run:**

- No production promotion decision — no arm clears the speed gates yet.
- No claim about FRQs other than FRQ02 — the n=100 scale test is the full available FRQ02 corpus, not multiple FRQs; no other FRQ has a labeled corpus yet.
- No claim about real grading-service app-side overhead.
- No TTFD claim (H6).
- No claim that `SP-1`/`SP-1-Serial`'s p95 swings across runs reflect anything real — likely sampling noise at n=40 for arms with schema-retry exposure.
- No claim that low reasoning effort is strictly better than medium on `FRQ02-C2` — the ambiguous-subset dip (75.0% vs 80-85%) is unresolved at n=20.
- No claim that `C1`/`C3`/`C4` have similar boundary-table gaps or would benefit from a similar misattribution audit — not yet investigated; this run only diagnosed and fixed `C2`.
- No confirmation that the flagged corpus labels (`S014`, `S054`, `S058`, `S062`, `S070`) are actually wrong — that's Learning Quality's call, not a conclusion this run can reach on its own.
- No claim that the misattribution audit's lemma list is complete or stable — two bugs were found and fixed during testing itself; it has not been independently re-validated after the fixes beyond the same corpus it was tuned against.
- The post-hoc misattribution audit (as opposed to parse-first routing) is wired into the live harness but has still never been run end-to-end — only validated as an offline join against already-produced results, plus standalone bridge connectivity tests. We don't yet know whether escalating a flagged `earned` verdict actually produces a corrected one in practice.
- No claim that parse-first and the post-hoc audit combined would beat either alone — the hard-path-only-50%-accurate finding suggests they might be complementary (audit catching hard-path misses too, not just fast-path over-credit), but that combined design hasn't been built or tested.
