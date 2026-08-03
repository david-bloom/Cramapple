# AP Chemistry FRQ Structure Validation

Date: 2026-07-25
Scope: Production content for `apchem` (AP Chemistry)
Method: Same structural-conformance check applied to AP Biology and AP Physics this week — verify the real CED's FRQ point structure directly from the primary source, then audit live content against it.

## Executive conclusion

Real, confirmed structural gap — but meaningfully smaller and differently shaped than the Bio and Physics ones, and **currently live to students**, unlike Physics.

## Ground truth (verified directly from the primary source)

`docs/teaching/ap-chemistry-course-and-exam-description.pdf` (already in this repo, Fall 2024 edition). Section II: Free-Response:

| Question type | Count | Points each | Total |
|---|---:|---:|---:|
| Long questions | 3 | 10 | 30 |
| Short questions | 4 | 4 | 16 |
| **Total** | **7** | | **46** |

Confirmed via literal scoring-guideline headers in the sample-exam section: "Scoring Guidelines for Question 1: Short-Answer — 4 points" and "Scoring Guidelines for Question 2: Long-Answer — 10 points."

**Unlike Bio (fixed "Part A/B/C/D" template) and Physics (4 fixed archetypes with fixed subpart patterns), Chemistry has no fixed part template.** The sample short question shown has 3 lettered parts (a)(b)(c), one of which is itself worth 2 points via two sub-bullets. The sample long question shown has 8 lettered parts (a) through (h). Part count varies per question; only the **total** (4 for short, 10 for long) is fixed by the CED. This changes the nature of the fix relative to Bio/Physics — there's no missing "Part D" to add or archetype to reclassify, just a point total to hit, with reasonable flexibility in how the parts underneath get there.

Also unlike Physics, Chemistry's `frq_form` field (`short`/`long`) already maps 1:1 onto the CED's two question types — no taxonomy or archetype-reclassification gap exists here.

## Production audit

Project `pcntajvbdfqhbeewmdry`, every latest-version Chemistry FRQ (28 long + 38 short = 66 total):

### Long FRQs (target: exactly 10 points)

| Total points | Count |
|---:|---:|
| 4 | 6 |
| 7 | 2 |
| 8 | 7 |
| 9 | 12 |
| 10 | 1 |

**Only 1 of 28 (4%) hits the correct total.** Average 7.57 points — under-pointed, but the gap is much smaller than Physics (which was 2-6 vs. a required 8-12).

### Short FRQs (target: exactly 4 points)

| Total points | Count |
|---:|---:|
| 2 | 10 |
| 3 | 4 |
| 4 | 20 |
| 5 | 3 |
| 6 | 1 |

**20 of 38 (53%) already hit the correct total exactly.** The remaining 18 split between under (14, at 2-3 pts) and over (4, at 5-6 pts).

## Review-decision safety

11 of the 66 FRQs already have a submitted review decision (3 long, 8 short) — all from Zeeshan's eval work. Small enough that the same fork-on-submitted-decision rule used for Bio applies cleanly without much overhead.

## Serving-layer exposure — this is live, not dormant

Checked whether any of these items are actually reaching students (same check that found Physics's defect dormant). **Chemistry is different: 2 FRQs are currently `published` at both item and version level and could be served right now**:

- `apchem-frq-l-001` — tagged `long`, actually worth **4 points** (should be 10).
- `apchem-sfrq-001` — tagged `short`, actually worth **2 points** (should be 4).

Both under-pointed. Unlike the Physics finding, this is not a dormant defect waiting for a future publish — if the same serving hook pattern found in the Lovable frontend applies to Chemistry (not independently re-verified for this subject, but it's the same codebase/pattern), students could be getting these truncated FRQs right now.

## Recommendation

Smaller-scope fix than Bio or Physics, but the live-exposure finding means it shouldn't wait as long:

1. **Immediate, cheap first step**: verify whether `apchem-frq-l-001` and `apchem-sfrq-001` specifically are reachable through the live serving path today (same trace Codex did for Physics — check `use-published-frq.ts` and equivalent Chemistry routes). If reachable, this is the one urgent piece.
2. **No taxonomy/archetype work needed** — `frq_form` already correctly encodes long vs. short.
3. **Correction is point-total reweighting/expansion, not a Part-D-style structural rebuild** — for under-pointed items, either add genuinely new sub-parts or expand existing ones with real additional work (not point inflation on unchanged content, same caution Codex raised for Physics). For the 4 short items sitting at 5-6 points, trim rather than expand.
4. Same versioning-safety rule as Bio/Physics: fork a new version for any of the 11 items with a submitted decision, edit in place for the rest.
5. Given the much smaller scope (66 items, mostly needing point adjustment rather than net-new content on the missing-part scale Bio/Physics needed), this may not need a Codex-scale authoring pass — worth deciding whether this is small enough for a supervised Haiku batch pass (like the Bio long-FRQ fix) rather than a full authoring project.

## Open question for you

Given the two already-published items, do you want the serving-layer reachability check done first (to confirm/rule out active student exposure) before deciding how to scope the correction, or should both happen in parallel?
