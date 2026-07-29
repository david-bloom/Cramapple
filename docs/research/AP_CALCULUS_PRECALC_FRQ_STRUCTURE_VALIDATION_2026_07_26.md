# AP Calculus AB/BC and AP Precalculus FRQ Structure Validation

Date: 2026-07-26
Scope: Production content for `apcalcab`, `apcalcbc`, `apprecalc`
Method: Same structural-conformance check applied to AP Biology, AP Physics, and AP Chemistry this week — verify the real CED's FRQ structure directly from the primary source, then audit live content against it.

## Executive conclusion

Three distinct situations, not one uniform defect:

- **AP Calculus AB and BC: severe, uniform under-pointing.** Every single FRQ in both subjects is exactly 3 points; the real exam requires 9. 0/32 items conform. This is the worst compliance rate found across all five subjects audited this week (tied with Physics).
- **AP Precalculus: a different kind of defect.** Point *totals* are already correct (6 points per item, matching the CED exactly) — but the internal part structure is wrong (6 parts of 1 point instead of the CED's 3 parts of 2 points), and archetype classification is completely absent.
- **Unlike Physics, none of these are dormant** — live student-facing items exist in all three subjects.

## Ground truth (verified directly from primary sources)

`docs/teaching/ap-calculus-ab-and-bc-course-and-exam-description.pdf` (local, Fall 2020 edition) — **AB and BC share the identical FRQ structure**:

- 6 FRQs total: 2 in Part A (graphing calculator required), 4 in Part B (no calculator).
- **Every FRQ is worth exactly 9 points**, confirmed via literal "Total for Question N — 9 points" lines for all 4 sample questions shown.
- Each question has 3-4 lettered parts (A-D), individually worth 2-5 points (e.g., Q1: 2/2/2/3; Q2: 2/2/3/2; Q4: 5/2/2 with only 3 parts) — no single fixed part-count template, but the 9-point total is fixed across every question.

Google Drive `1ANP9L45EfpyqQXppNl0i1aLMifpbCv8y` (AP Precalculus CED, Fall 2026 edition, fetched and searched in full):

- Exam overview states explicitly: **"includes 42 multiple-choice questions and four 6-point free-response questions, each weighted equally."**
- 4 FRQ types, one of each on the real exam: Question 1 Function Concepts, Question 2 Modeling a Non-Periodic Context, Question 3 Modeling a Periodic Context, Question 4 Symbolic Manipulations (matches the existing CED fact pack for this subject, which already names these 4 archetypes but doesn't record point values).
- Each question has exactly **3 parts (A/B/C), each worth 2 points** — confirmed via literal "Total for part A/B/C — 2 points" lines for all 4 sample questions, all following the identical 2+2+2=6 pattern.

## Production audit

Project `pcntajvbdfqhbeewmdry`, every latest-version FRQ (16 per subject, 48 total):

| Subject | Items | Actual points (all items) | Actual parts (all items) | Target points | Target parts | Archetype tagged | Has submitted decision | Published live now |
|---|---:|---:|---:|---:|---:|---:|---:|---:|
| AP Calculus AB | 16 | **3** (uniform) | 3 | 9 | 3-4 (varies) | 0/16 | 12/16 | 2 |
| AP Calculus BC | 16 | **3** (uniform) | 3 | 9 | 3-4 (varies) | 0/16 | 0/16 | 1 |
| AP Precalculus | 16 | 6 ✓ (correct) | **6** (should be 3) | 6 ✓ | 3 | 0/16 | 16/16 | 1 |

**AB and BC: 0/32 items hit the correct 9-point total.** Every item, no exceptions, no variance — flat at 3 points regardless of question. This is a larger proportional gap than Bio's (which was missing 2 of 4 parts) and comparable in severity to Physics (2-6 actual vs. 8-12 required).

**Precalculus: point total is already right, structure isn't.** All 16 items sum to exactly 6 points — matching the CED. But they're built as 6 separate 1-point criteria instead of 3 criteria worth 2 points each, and none carries an archetype tag identifying which of the 4 required question types (Function Concepts / Modeling Non-Periodic / Modeling Periodic / Symbolic Manipulations) it represents. A points-only check would have missed this entirely — worth noting for whatever automated `EXAM_FORMAT_MISMATCH` check eventually gets built per the architecture-doc guardrail from the Bio fix; total points alone isn't sufficient.

## Review-decision safety — highest stakes of any subject audited this week

- **AP Precalculus: 16/16 (100%) already have a submitted review decision.** Any correction here requires forking every single item — there is no "edit in place" path available at all.
- **AP Calculus AB: 12/16 (75%) already reviewed.** Mostly fork, some in-place.
- **AP Calculus BC: 0/16 reviewed** — matches the reviewer-roster memory (Hutchings' packet was corrected to AB-only, BC has no reviewer assignment yet). Free to edit in place.

## Live exposure — not dormant, unlike Physics

4 items across these three subjects are currently `published` at both item and version level (2 AB, 1 BC, 1 Precalc) — real students could be served these today, same live-exposure situation found in Chemistry, not the dormant state found in Physics. Worth identifying the exact 4 content_keys and checking the same serving-layer path Codex traced for Physics before treating this as low-urgency.

## Recommendation

- **AB/BC need real content expansion** — going from 3 to 9 points per item is close to tripling each item's scope, similar in kind and scale to the Physics gap. Not a mechanical fix; this is an authoring project.
- **Precalc needs a mechanical merge, not new content** — same pattern as the Bio long-FRQ fix: merge pairs of existing 1-point criteria into 2-point criteria (3 merges per item, going from 6→3 parts), then classify each item's existing content against the 4 real archetypes. No new points need to be created. This is comparable in cost/risk to the Bio long-FRQ Haiku batch fix, not the AB/BC-scale authoring project.
- Given Precalc's 100% review-decision coverage, every one of its 16 items would need to fork — worth deciding whether that's worth doing for only 16 items, or whether a smaller number of forks (e.g. just the 1 currently-published item, if that's the actual exposure surface) is the more proportionate first move.
- AB/BC's authoring scope (tripling point value across 32 items, only 12 of which are pre-reviewed) is comparable in shape to the Physics correction — likely belongs in the same category of work (Codex-scoped authoring project), not a quick pass.

## Open questions for you

1. Want the exact 4 live-published content_keys identified and their serving-layer reachability checked (mirroring the Physics trace), before scoping remediation?
2. Precalc: worth doing the mechanical merge+classify fix now (cheap, but touches 16 already-reviewed items), or lower priority than AB/BC's larger authoring gap?
3. Should AB/BC correction go through the same validate→Codex-authors→review pipeline as Bio and (pending) Physics, given the similar scale?
