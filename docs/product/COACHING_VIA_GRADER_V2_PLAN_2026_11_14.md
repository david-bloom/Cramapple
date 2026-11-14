# Coaching via the Grader Engines: v2 Plan

Status: DRAFT for owner review, 2026-11-14. Supersedes `COACHING_LIBRARY_V0_PLAN_2026_11_12.md` (not in this repo; lives on the owner's machine). No Production change is proposed or approved by this document.
Inputs: the v0 plan, an independent model review (Fable 5.2) and a read of the grader code in this checkout.
Not verified here: the parent plan `COACHING_ARC_PLAN_DRAFT_2026_11_11.md` and the prototype dir `scripts/content-seed/coaching-prototype-2026-11-11/` are not in this checkout. Voice rules, the judging recipe and the "3-4% real-error rate" are taken from the v0 plan and should be re-checked against the originals.

## 1. Why v2

v0 builds an offline library (requirement meanings, distractor labels, exemplars) with heavy provenance machinery, and its own conclusion is that no Production coaching release follows. Meanwhile the grader engines already hold almost everything coaching needs, in verified form. The owner's direction (2026-11-14): **produce coaching through the grader engines.** v2 makes coaching a rendering of the grader's own sanitized output, so it inherits the grader's grounding, uncertainty handling and fail-closed behaviour instead of re-creating them in files.

Goal is unchanged: *show students how to earn points.* Name what the question required, what the student did against it, why it matters, and the next move.

## 2. What the graders already give us (code anchors, this checkout)

- **FRQ, per criterion:** `status` (earned / partially_earned / not_yet_earned / unable_to_determine / not_applicable), `points_awarded`, `evidence_quote`, `decision_explanation`, `minimum_fix` (`_shared/grading-feedback.ts`, `CRITERION_STATUS_VALUES` and `FeedbackCriterionResult`; schema in `_shared/grading-contract.ts`).
- **Integrity already enforced:** evidence quotes must be found in the student's response or the criterion is zeroed (`evidenceIsGrounded`, `grading-feedback.ts`); integrity failures force the whole grading to `uncertain`; Statistics deterministic checks can mark criteria unresolved (`overrideCriteriaAsUnresolved`). The summary is composed from the verdicts so it cannot contradict them (`grading-contract.ts`).
- **MCQ today:** `composeMcqFeedback` (`evaluate-attempt/index.ts:418`) builds deterministic, template-varied text from the *chosen choice's* authored `rationale`, optional skill labels and unit number. It does not receive the correct choice's rationale, so it cannot leak the answer.
- **Reuse seam:** More help already has an allowlisted grounding boundary and a second-family verifier (`more-help/grounding.ts`, `more-help/verify.ts`); `MORE_HELP_DECISIONS_AND_DESIGN.md` names the grading engines as the reuse point.
- **Coverage gap:** `_shared/verification-profiles.ts` covers Statistics, Calculus and Chemistry. **Biology has no verification profile**, so Biology coaching rests on the LLM grader plus the sanitizer alone.

## 3. Principles

1. **Coaching renders the verdict; it never re-judges.** Points, statuses and criterion keys come from the sanitized grading payload and are not model-authored.
2. **Fail closed to today's text.** Any failed check, or any non-`graded` outcome, shows the existing composed feedback. Coaching is an enhancement that can disappear without harm.
3. **Source-bound claims.** Every substantive claim must trace to the item, the rubric fields, the chosen rationale, or the student's own quoted words. Unsupported claims are flagged, counted, and block that text.
4. **Never leak the answer.** MCQ coaching never states or implies the correct choice (existing rule; now an explicit check).
5. **Simple first.** No library, no label corpus, no snapshot/fingerprint apparatus in v0. Add authored data only where a test shows it earns its place.

## 4. FRQ approach

**Input** (already available post-grade): sanitized `criteria[]` with status, points, evidence quote, decision explanation, `minimum_fix`; `highest_value_gap`; the item part text; each criterion's `learner_facing_text` and `evidence_requirements`.

**Generate only when the grading is `graded`.** On `uncertain` or shadow review, show today's composed text.

**What coaching adds over the composed summary:** a short teacher-voice passage that (a) names the part's requirement in plain words, (b) says what the student's quoted words did or did not do against that criterion, (c) gives the "why this earns the point" reason, taken from `evidence_requirements`, and (d) one next move from `minimum_fix`. Highest-value gap first.

**Verb glossary (replaces layer 1).** About 10 rows in the prompt covering identify / describe / explain / justify / compare etc., drawn from the CED task-verb definitions *if* both CEDs define them (to confirm), else marked claude-authored for subject check. The item rubric always governs; the glossary only explains the word.

**Deterministic post-checks (fail closed):**
- points named equal the payload's points; criterion keys named exist in the payload;
- any quoted student text passes `evidenceIsGrounded` against the response;
- no criterion that was unresolved or `unable_to_determine` receives a confident claim;
- control-character stripping; length and banned-phrase checks from the voice rules.

**Optional second check:** reuse More help's cross-family verifier on a sample, not every attempt, to measure unsupported-claim rate.

## 5. MCQ approach

MCQ has one point and no rubric, so coaching ties the *chosen* answer's error to why that point was missed. It must not invent partial credit.

**Wrong answer (the main case).** Input: chosen choice text and authored `rationale`, the stem, skill labels, unit. No correct-choice rationale is passed. Coaching names what the chosen option claims, why that fails (from the rationale, not embellished), and gives a fix kind: *answer differently* (knew it, misapplied) or *learn first* (concept gap). Without a new field, the model infers fix kind from the rationale; it is **not** a stored label.

**Correct answer.** Brief confirmation tied to the skill label and what made the choice right *in general terms from the stem*, never by quoting a distractor's rationale (avoids teaching to eliminate by pattern). Praise copy stays prototype-only until the design-rules decision on praise exists.

**Repeat miss.** Same item or same skill missed again: pass only the *count and skill label*, never earlier response text. Synthetic fixtures only in testing.

**Thin or missing rationale.** Fall back to today's `composeMcqFeedback` output and log the item to a gaps list. Do not let a model invent the reason. Step 0 sizes this share.

**Post-checks:** no correct-choice text or letter; no content absent from the chosen rationale/stem/skill; no claim of partial credit; choice reference matches the chosen key even if option order is shuffled.

**Distractor labels (old layer 3): dropped.** They would paraphrase a field the runtime already reads, and their `requirement_lost` derives from the correct choice's rationale, which the runtime deliberately withholds. Revisit only if the test below shows a structured `error_type` or `fix_kind` improves coaching; then add them as authored columns on `mcq_choices`, not a parallel file.

## 6. Exemplars (replaces layer 5)

6 to 8 owner-approved example texts: MCQ miss, MCQ correct, FRQ partial, FRQ zero on a part, FRQ full credit. Two in the prompt at a time, rotated; the rest held out as regression fixtures. Encouragement and progress framing are excluded until real history and the design-rule decision exist. Seed from the 22 texts in `HUMAN_READ_PACKET.md` that David explicitly approves or revises; nothing is approved by inference.

## 7. Test and go/no-go

**Offline replay, no Production touch.** Run the coaching prompt over stored or gold-set grading payloads and synthetic responses (no real student text sent to any provider without owner approval). 60 cases: 15 MCQ and 15 FRQ per subject, including planted faults (wrong points, fabricated quote, leaked correct answer, claim not in rationale) and a negative control.

David reads all 60 blind against today's text (about 90 minutes). A subject reviewer checks every factual flag.

**Go only if all hold:**
- zero texts contradict the grader's points or the answer key;
- zero MCQ texts reveal the correct choice;
- at most 1 of 60 contains a claim unsupported by the item or rubric fields;
- David prefers coaching in at least 40 of 60 pairs;
- post-checks catch every planted fault;
- cost and latency fit a ceiling David sets first (suggested starting point: about $0.005 and 3 seconds per attempt).

Even a pass is a pilot result: 60 cases cannot certify a near-zero error rate; report counts and the specific failures.

**No-go:** keep composed text; spend the effort on thin rationales and `minimum_fix` quality, which feed the existing graders directly.

## 8. Sequence

0. Read-only counts: MCQ rationale quality and thin-rationale share; FRQ part verb inventory; whether both CEDs define task verbs; Biology grader accuracy baseline (no verification profile).
1. Draft coaching prompt, glossary and exemplars; owner approves exemplars.
2. Build the post-check module and its planted-fault tests as pure functions with unit tests (no deployment).
3. Offline replay of the 60 cases; owner read; go/no-go.
4. If go: design the release as its own plan (below). If no-go: stop.

## 9. Placement if it ships (separate approval)

Lowest-risk shape: a **separate post-grade call** that leaves grading latency and the locked grade untouched, writing coaching text as an optional field the card shows when present and otherwise shows today's summary. Alternatives (in-line in `evaluate-attempt`) add latency to the grading path.

## 10. Owner approvals required (hard gates; none requested yet)

- Any change to `evaluate-attempt` or a new edge function.
- A new stored field or migration.
- Sending student response text to a coaching model, and which provider.
- Raising the daily spend cap (`OPENAI_DAILY_CAP_USD`, `evaluate-attempt/index.ts:102`) or adding per-attempt model cost.
- The unresolved praise/encouragement design-rule decision.
- Replaying real student attempts offline.

## 11. Risks

- **Grader error becomes confident prose.** Coaching amplifies a wrong verdict; Biology has no deterministic verifier. Measure grader accuracy on the replay items, not just coaching accuracy.
- **Answer-key and rationale errors** pass through faithfully. Add a student "this seems wrong" route that feeds a gaps list (`report-question` function exists; check fit).
- **Ongoing cost:** one extra model call per graded attempt, indefinitely. Price it before the test, not after.
- **Owner review time** is the real bottleneck; the plan budgets about 90 minutes for the read plus exemplar approval.
- **No success metric yet.** Define one before any pilot: retry-earns-the-missed-point rate and More-help click rate.
- **Surface overlap:** feedback card, More help and Progress recommendations need a stated boundary before release.
- **Separate urgent item:** verify whether a gateway key was exposed in earlier transcripts and rotate through the approved path. Independent of this plan.

## 12. Decisions for David

1. Approve the grader-first direction and retiring layers 3, 8 and 9 as separate artifacts.
2. Which of the 22 packet texts are approved exemplars, as marked or after revision?
3. Name the subject reviewer for factual flags.
4. Set the per-attempt cost and latency ceiling.
5. Are praise and encouragement copy prototype-only for now?
