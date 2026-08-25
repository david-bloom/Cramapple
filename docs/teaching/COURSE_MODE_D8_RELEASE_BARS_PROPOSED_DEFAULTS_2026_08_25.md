# Course Mode — D8 Release Bars: Defaults (RATIFIED)

STATUS: **RATIFIED as proposed — David, 2026-08-25.** D8 is no longer ON HOLD. | DATE: 2026-08-25 |
OWNER OF DECISION: David | DRAFTED BY: integration session (LLM), from the current harness numbers
+ the CM-D17 gold-corpus constraint.

D8 was ON HOLD with the numbers deliberately left blank ("no defaults should be invented"). This
doc filled that blank with a concrete slate; **David ratified it as proposed on 2026-08-25.** The
four bars (§1–§4) plus the Gate-2 re-derivation bar (§5) are now the release predicate. CM-D19
stamping can now be built against them. Nothing is *served* by this ratification — release of any
instance still runs each template through these bars first, and Prod remains untouched.

Companion: `COURSE_MODE_RELEASE_PATH_DECISION_BRIEF.md` §5 (the decision *shape*).

---

## 0. The slate at a glance

| # | Bar | Proposed default | What it costs you |
|---|---|---|---|
| 1 | Validation sample size *n* (human spot-audit per template) | **20 instances** | ~20 items to eyeball per template at release |
| 2 | Property-test coverage (automated) | **≥100 instances/computational procedure, ≥120/MCQ frame, 0 rejects; every scenario context and every expected misconception tag exercised ≥1×; answer position varies** | none (already automated) |
| 3 | Gold-set regression threshold | **0 grader-behavior changes** vs the old-namespace Stats gold corpus (behavior-drift bar only, NOT coverage) | re-run on grader-engine changes only |
| 4 | Ongoing spot-audit rate (post-release safety net) | **5 served instances per template per 30 days** (or per 500 served, whichever first); any confirmed defect → quarantine template | ~5 items/template/month of SME time |
| 5 | **Gate-2 independent re-derivation** (proposed addition) | **key + every distractor hand-recomputed on the sample; 0 defects** | folded into the n=20 review |

Rationale and the "why this number" for each below.

---

## 1. Validation sample size *n* per template — propose **20**

- **What it is:** how many generated instances a human (you, as reviewer of record — D2) inspects
  before the template is trusted and its instances may be machine-stamped.
- **Why 20:** it's the number already in the pilot plan's "D8 SME 20-instance review," so it
  matches established practice and your own review muscle. 20 diverse instances is enough to
  surface a *systematic* authoring error (a mislabeled distractor, a wrong key formula, an
  off-register scenario) — which is the failure mode that matters, since the generator is
  deterministic and errors are systematic, not random. A bad template fails on instance 1, not
  instance 50.
- **The trade-off:** higher *n* = more confidence, more review labor per template. With ~10
  pilot cells, n=20 is ~200 items of review total — a day's focused work, once.
- **Selection rule (recommend):** the 20 should be a *spread* — sampled across scenario contexts
  and (for computational) across the stat/parameter variants, not 20 consecutive seeds. The
  harness can emit a stratified sample.

## 2. Property-test coverage — propose the bar the harness already clears, made explicit

- **What it is:** what the automated harness must exercise before a template is eligible.
- **Proposed bar (all must hold at 0 rejects):**
  - **Volume:** ≥100 instances per computational procedure; ≥120 per MCQ frame. *(Current sweep
    runs 80/proc and 120/frame; 100/proc rounds the computational bar up slightly for headroom.)*
  - **Scenario coverage:** every context in the template's scenario bank appears ≥1×.
  - **Misconception coverage:** every misconception tag in the frame's expected set appears ≥1×
    across the sample. *(Already a meta-test: `all_frame_expected_tags_used`.)*
  - **Answer-position variation:** correct-answer position varies across {0,1,2,3} for MCQ.
    *(Already a meta-test.)*
  - **Catalog self-checks pass:** `misconceptions.validate_catalog() == []` and
    `scenarios.validate_scenarios() == []`.
- **Why not a "fraction of parameter space" number:** for these generators the space is
  enumerable via the scenario banks, so "every context exercised" is a *stronger and clearer*
  bar than an abstract coverage %. Volume + full-context + full-tag coverage is the meaningful
  definition of "enough."
- **The trade-off:** essentially free — this is what `generator.py` / `slot_frames.py` already
  run on every pass. The bar just formalizes it as a release predicate.

## 3. Gold-set regression threshold — propose **0 behavior changes** (drift bar only)

- **What it is:** re-run the grader against the Stats gold corpus and require its verdicts not to
  change.
- **Critical caveat (CM-D17):** the gold corpus is **old-namespace**. It is valid for detecting
  grader-*behavior* drift, NOT for making any coverage claim about the new Unit-1 cells. This bar
  can only ever mean "a grader-engine change did not alter established behavior."
- **Why 0:** a behavior-drift bar is naturally zero-tolerance — any change in a gold verdict is
  either a regression to fix or an intended change to re-baseline. There is no "acceptable drift %"
  for a determinism guard.
- **When it runs:** only on changes to the **grader/evaluation engine**, not on adding a content
  template (content templates don't touch grader behavior). So this bar rarely gates content
  releases; it gates engine changes.
- **The trade-off:** near-zero ongoing cost; it's a guardrail that fires only when the engine moves.

## 4. Ongoing spot-audit rate — propose **5 / template / 30 days**

- **What it is:** the post-release safety net you already approved as the CM-D19 mitigation that
  made *template-level* (rather than per-instance) release acceptable. It needs a rate.
- **Proposed:** re-audit **5 served instances per template per 30 days**, or per 500 served
  instances of that template, whichever comes first. Any confirmed defect → **quarantine the
  template** (stop serving new instances) pending fix; already-served instances flagged for the
  affected students.
- **Why these numbers:** 5/period is enough to catch a latent template defect that only shows on
  rare parameter combinations the release sample missed, without becoming a review burden. The
  "per 500 served" clause scales the audit to actual usage so a heavily-served template gets more
  eyes.
- **The trade-off:** this is the recurring cost of template-level release. Lower rate = less
  labor, slower defect detection.

## 5. Proposed addition — Gate-2 independent re-derivation as a named bar

- **Why add it:** the automated harness has a structural blind spot — it verifies a distractor is
  *tagged* and *unique*, but **cannot** verify the distractor's *value* equals the transform its
  misconception name claims, nor that the key is correct (see the Gate-2 record,
  `..._GATE2_REDERIVATION_2026_08_25.md`). Only independent hand-recomputation closes it.
- **Proposed bar:** on the n=20 validation sample, the reviewer independently recomputes the key
  **and every distractor**; release requires **0 defects**. This folds into the §1 review (it *is*
  what the review should consist of), so it adds rigor, not a separate step.
- This session ran Gate-2 across all seven pilot cells → 0 defects. Codifying it means every
  future template clears the same blind-spot check.

---

## 6. What ratifying this unblocks

With §1–§4 (and §5) now ratified, CM-D19 stamping becomes a well-defined build: a template that
clears these bars → the pipeline machine-stamps its conforming instances' review/serving/cell
labels with provenance. D8 was the single highest-leverage gate on the path; it is now set.

**Ratified 2026-08-25 (David), as proposed.** The next build step is CM-D19 stamping against these
bars; it remains a separate, David-gated step and nothing is served until a template is actually
run through them. Prod untouched.
