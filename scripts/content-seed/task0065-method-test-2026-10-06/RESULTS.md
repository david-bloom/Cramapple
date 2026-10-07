# Method Test Results: Legacy Patch Loop vs Generate-and-Select

**Date:** 2026-10-06 to 07. **Task:** TASK-0065. **Design:** `docs/product/OPEN_HAND_CONTENT_METHOD_TEST_DESIGN_2026_10_06.md`.
**Scope:** units 1–3 for all four subjects (David). Sample of 24 topics, 6 per subject, fixed seed (`sample.py`).
Nothing was written to any database.

## Headline

| | Legacy (fresh run) | Pipeline | Shipped (live in Production) |
|---|---:|---:|---:|
| Topics attempted / items produced | 24 / 24 | 24 / 23 (Chem 3.9 escalated) | 24 / 24 (already live) |
| **Items with a confirmed accuracy or CED defect** | **4 (17%)** | **1 (4%)** | **3 (13%)** |
| Key correct and unique (Q1) | 24 / 24 | 23 / 23 | 24 / 24 |
| No false statement (Q2) | 21 / 24 | 23 / 23 | 22 / 24 |
| On topic (Q3a) | 24 / 24 | 23 / 23 | 24 / 24 |
| Within CED (Q3b) | 23 / 24 | 22 / 23 | 22 / 24 |
| Judges: publish as is (panel, before human review) | 18 clean, 6 disputed | 23 clean | 20 clean, 4 disputed |
| Pedagogy (named traps, action fixes) | 19 clean, 5 disputed | 23 clean | 20 clean, 4 disputed |
| Wall-clock, start to final set | 10.3 min | 13.7 min | n/a |
| Model cost | $3.14–4.44 | $16.91 | n/a |
| Cost per defect-free item | $0.16–0.22 | $0.77 | n/a |

**Reading it:**
- **Keys:** every key in every arm is correct. All 33 numeric keys were recomputed in sympy (`judging/recompute.py`).
- **Accuracy and CED faithfulness:** the pipeline had 1 defective item, legacy 4. That is the direction the
  pipeline was built for, but with 24 items per arm the difference is not statistically significant
  (Fisher exact p = 0.35).
- **Clean on every measure:** the pipeline was the only arm whose items all came out clean on pedagogy and on
  the judges' "publish as is" verdict.
- **Cost:** the pipeline costs about 3.5–4.9× more per defect-free item (about $0.77 vs about $0.19). The
  proposed decision rule capped this at 3×.
- **Speed:** close. Pipeline 13.7 minutes, legacy 10.3 minutes plus orchestration gaps.

## Decision rule (proposed in the design)

| Rule | Result |
|---|---|
| 1. Q1–Q3 not worse than legacy by more than 5 points; Q* at least equal | **Met.** Better or equal on every measure. Q* (human "publishable") was not run; the judge-panel proxy favours the pipeline. |
| 2. Pipeline yield at least 80% | **Met.** 96% (23/24). |
| 3. Cost per publishable item no more than 3× legacy | **Not met.** 3.5–4.9×. |

The design says that if the pipeline wins on quality but fails on cost, tune it rather than drop it. Kimi K3
and Claude Opus 5.5 were the largest costs in the Biology pilot.

## Defects found (adjudicated, blind to arm)

| Arm | Item | Defect |
|---|---|---|
| Legacy | Stats 2.12 | Key needs σ/√n (CED 4.1, later than 2.12) |
| Legacy | Stats 1.10 | Rationale asserts "patients chose for themselves"; the stem does not say so |
| Legacy | Chem 1.3 | C₃H₄ mass given as 40.07 g/mol; with the stem's masses it is 40.06. Both legacy checkers and its fix session missed it |
| Legacy | Stats 3.15 | States the chi-square condition as "exceeds 5"; the AP condition is at least 5 |
| Pipeline | Stats 2.12 | Key needs "less spread as n increases" (CED 4.1) |
| **Shipped (live)** | Stats 1.10 | Fix line says to look for **random** assignment to identify an experiment; the CED defines an experiment by assignment of treatments |
| **Shipped (live)** | Stats 2.12 | Key needs 24/√64 = 3 (CED 4.1) |
| **Shipped (live)** | Bio 2.10 | Rationale B: "all eukaryotic organelles have membranes" is false (ribosomes). The key also needs circular DNA and binary fission, which are outside CED 2.10 |

**Two upstream causes, not authoring errors:**
- **Statistics 2.12 failed in all three arms.** The topic point brief says students earn credit for
  "explaining that increasing sample size tightens the spread". That is CED 4.1 content. It is the same kind of
  brief overreach as the Biology 2.10 brief fixed under APPROVAL-0127.
- **The live Biology 2.10 item** was written against the old 2.10 brief that APPROVAL-0127 corrected.

**Live items:** 3 of the 24 sampled live items have a defect. At that rate, roughly 11 of the 91 live teaching
items would be affected. That is an extrapolation, not a count.

## How it was run

- **Legacy arm.** #340's `AUTHORING_SPEC.md` and inputs (brief, explainer, style seed from Production,
  read-only), with live teaching items excluded as seeds.
  - Four Claude subagents authored (one per subject, with Python recompute). Each took 2–3 minutes.
  - `method_test_legacy_check.mjs` checked the items. It is #340's checker plus usage logging only (Gemini 3.8
    and DeepSeek v4), and flagged 2 of 24 items.
  - A fix-session subagent found 1 valid flag and 2 false positives, and patched 1 item.
  - The re-check repeated only an already-judged false positive. All 24 kept.
- **Pipeline arm.** `teaching_pipeline/run.mjs`, unchanged.
  - It ran in two timed segments, because the gateway ran out of credit at 23:52 UTC.
  - Every candidate touched by a credit failure was discarded and regenerated (`pipeline/credit_cleanup.log`).
  - Six planted-defect controls ran first, and all six were caught.
- **Shipped arm.** The 24 items live in Production for the same topics (APPROVAL-0125), judged as they are.
- **Judges.** Mistral Large 4, GLM-5.3 and MiniMax M3. None of these families is used by either arm.
  - MiMo v2.6 Pro was replaced after it failed the output schema on every smoke-test call.
  - Each judge ran each item twice: a blind solve, then an audit against the topic's text extracted from the
    CED PDF.
  - 900 calls, 0 failed, $4.32 (charged to neither arm).
  - A judge's verdict counts only if both of its samples agree. A defect needs at least 2 of 3 judges; exactly
    1 means disputed.
- **Judge validity.** Four planted defects (wrong key, false rationale, wrong topic, out-of-CED term) were mixed
  into the blind set. **All four were caught on their intended measure.**

## Changes made during scoring (applied to all arms alike, blind to arm)

1. **Q1.** Two judges filled the free-text "defect" and "other defensible" fields with commentary. Q1 therefore
   uses only the structured answer and the audit's key verdict. Deterministic recompute settles numeric
   disputes: MiniMax mis-solved two items whose keys recompute correctly.
2. **Q2.** Judges listed each wrong choice's own text as a "false statement", but wrong choices are false by
   design. A Q2 defect must sit in the stem, a rationale or fix, or the keyed choice. The planted false rationale
   is still caught.
3. **Q3a.** Topic codes are parsed from the first number pair, because judges sometimes answered with CED codes.

The scorer was re-run after each change. The planted defects still score as caught.

## Limits

- **Small sample.** 24 items per arm detects only large differences. The design says to extend to 48 topics
  if the result is close.
- **Adjudicator.** Claude adjudicated the 17 disputed items, blind to arm, with a reason recorded for each
  (`judging/adjudication_reasons.json`). Claude is the same family as both arms' authors. A human reviewer
  should confirm or override these.
- **Pending human input.** The human "publishable as is" verdict (Q*) and David's 6-item pedagogy rating were
  not done.
- **Biology tuning bias.** Biology's units 1–3 topics are where the pipeline's rubric was tuned, which may
  favour the pipeline on Biology. It had 0 defects there; legacy also had 0 on Biology.
- **Legacy cost is a range.** Subagents report total tokens only, so the input/output split is bounded rather
  than measured.

## Files

| Area | Files |
|---|---|
| Sample | `sample.py`, `sample.json` |
| Legacy arm | `legacy/` (inputs, items, check logs, fix session, timing) |
| Pipeline arm | `pipeline/batch/` (state, `calls.jsonl`, `accepted.json`), `pipeline/timing.log` |
| Shipped arm | `shipped_items.json` |
| Judging | `judging/` (`review_set.json` blind, `review_key.json`, `ced_excerpts.json`, `planted.json`, `run/judgements.jsonl`, `item_status.json`, `scores.json`, `costs.json`, `recompute.json`, `adjudication*.json`) |
| Scripts | `build_review_set.py`, `score.py`, `costs.py`; `../../vercel-gateway-check/method_test_judge.mjs`, `method_test_legacy_check.mjs` |
