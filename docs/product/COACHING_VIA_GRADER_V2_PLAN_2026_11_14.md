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
- **Past student activity is already recorded across sessions, by the engines themselves.** (This corrects an earlier draft of this plan, which said the grader had no history input; that came from a search of one file.)
  - *Student memory:* `_shared/grading-memory.ts` and `_shared/student-memory.ts` record a per-attempt memory event and keep a snapshot per student (last result, latest gap criteria, repair prompts, `preferred_help_style`, `preferred_feedback_density`). Development has 44 snapshot rows.
  - *Course Mode cell state:* `_shared/cell-state.ts` is a deterministic, no-model rule engine (its header says pure functions, INV-4) that moves a student's tier on each topic-and-skill cell through unseen / exposed / supported / independent / confirmed, with decay dates, a direct-miss recheck and an "uncertain grading never advances a tier" rule. `persistCellState` writes it to `app.student_cell_state` after each grade for cell-tagged items. Development has 14 rows for 3 users, last updated 2026-08-26.
  - *Who reads it today:* the Home start queue (`20260927211624_home_start_queue_rpc.sql`) reads cell state to decide what to practise next (decay, direct miss).
  - *Who does not:* the **feedback text**. `evaluate-attempt` calls `loadLearningRuntimeContext`, which returns student memory, recent attempts and recent gap criteria, but the function reads only the subject key from it. `composeMcqFeedback` takes no history input. A search of the functions found no other consumer of `preferred_help_style`, `recent_gap_criteria` or `recent_attempts`. So history is recorded and used for scheduling, and is not yet used to adapt the words the student reads. This is a static read of the code on `main`; it has not been confirmed by running the deployed grader.
- **Coverage gap:** `_shared/verification-profiles.ts` covers Statistics, Calculus and Chemistry. **Biology has no verification profile**, so Biology coaching rests on the LLM grader plus the sanitizer alone.

## 3. Principles

1. **Coaching renders the verdict; it never re-judges.** Points, statuses and criterion keys come from the sanitized grading payload and are not model-authored.
2. **Fail closed to today's text.** Any failed check or coaching error shows the existing composed feedback (tier 2); grading failures follow tiers 1 and 3 (section 6). Coaching is an enhancement that can disappear without harm.
3. **Source-bound claims.** Every substantive claim must trace to the item, the rubric fields, the chosen rationale, or the student's own quoted words. Unsupported claims are flagged, counted, and block that text.
4. **Never leak the answer.** MCQ coaching never states or implies the correct choice (existing rule; now an explicit check).
5. **Simple first.** No library, no label corpus, no snapshot/fingerprint apparatus in v0. Add authored data only where a test shows it earns its place.

## 4. FRQ approach

**Input** (already available post-grade): sanitized `criteria[]` with status, points, evidence quote, decision explanation, `minimum_fix`; `highest_value_gap`; the item part text; each criterion's `learner_facing_text` and `evidence_requirements`.

**Generate only on a trustworthy grade.** Full coaching requires `graded`; abstention-only uncertain gets tier 1 partial coaching; every other non-graded outcome and every coaching failure follows the tiers in section 6.

**What coaching adds over the composed summary:** a short teacher-voice passage that (a) names the part's requirement in plain words, (b) says what the student's quoted words did or did not do against that criterion, (c) gives the "why this earns the point" reason, taken from `evidence_requirements`, and (d) one next move from `minimum_fix`. Highest-value gap first.

**History for FRQ.** Same rule as MCQ: only computed facts and directives from persisted state (for example, the same criterion appearing in the student's recent gap criteria again), never earlier response wording, never on an uncertain grading. Not yet tested for FRQ.

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

**History-aware coaching (repeat misses and recovery).** Adaptation uses the history the engines already persist, and **code, not the model, computes it**.
- *Source:* topic-level miss and correct counts from the student's attempts (the same data `recent_attempts` carries), plus the student's cell tier and `due_reason` from `student_cell_state` where the item is cell-tagged. Never earlier response wording.
- *Code computes the facts and picks the directive.* Example: "COMPUTED FACT: this is the student's third miss on this topic. DIRECTIVE: say so plainly and recommend stepping back to the topic's key idea before another attempt." The model only writes the sentence around it. Directives by situation: first miss, no history language; second same-topic miss, name it and tie it to the requirement; third or later, step back to the key idea; correct after earlier misses, one factual sentence on the recovery, no gushing; anything on a different topic, never mentioned.
- *Why not let the model do it:* in a scripted 5-question sequence (section 9), when the model was handed the history and asked to apply the rules, it miscounted every time it mentioned the count (said "first miss" on the second, "second" on the third, "third miss" on a correct answer) and did not escalate on the third miss. With facts and directives computed in code, it got every count right and escalated correctly.
- *Cross-session:* because the source is persisted state, it carries across sessions. Tier changes follow the cell-state rules, including that an uncertain grading never advances a tier; coaching must not treat an uncertain attempt as a miss or a success.
- *Boundaries:* only on the same topic; no inference about the student's state or feelings ("the distinction is now clicking" is an unsupported claim and fails the check); never "you keep" or "you always".

**Thin or missing rationale.** Fall back to today's `composeMcqFeedback` output and log the item to a gaps list. Do not let a model invent the reason. Step 0 sizes this share.

**Post-checks:** no correct-choice text or letter; no content absent from the chosen rationale/stem/skill; no claim of partial credit; choice reference matches the chosen key even if option order is shuffled. **New:** (a) a deterministic ordinal check: any "first/second/third miss" or "after N misses" claim must equal the code-computed count (it caught all four miscounts in the sequence test); (b) a semantic answer-naming check, since the exact-text check missed it (see below); (c) no claims about the student's state or feelings; (d) history language only when the computed directive calls for it.

**Open design conflict: naming the correct answer.** The shipped MCQ feedback deliberately never states the correct choice's rationale, because the item may be re-served, and it hands back a question rather than a correction (`evaluate-attempt/index.ts`, `composeMcqFeedback` comment). The coaching prompt used in testing explained why the chosen answer was wrong and, in a model-judged check, stated the correct method in 7 of 12 wrong-answer texts (not human-verified), including texts with no history. Either coaching follows the shipped rule (explain the error and return a question, never name the answer; the check then fails closed) or the owner decides that post-submit practice coaching may name the correct answer (the Answer Key is already visible after submit). This is a product decision, listed in section 14.

**Distractor labels (old layer 3): dropped.** They would paraphrase a field the runtime already reads, and their `requirement_lost` derives from the correct choice's rationale, which the runtime deliberately withholds. Revisit only if the test below shows a structured `error_type` or `fix_kind` improves coaching; then add them as authored columns on `mcq_choices`, not a parallel file.

## 6. Graceful failure: the response without coaching

Coaching is an enhancement. Every failure path ends in a complete, honest result for the student, never a blank card, a spinner that doesn't resolve, or coaching the checks did not clear. The result is delivered in tiers; the student always gets the highest tier the evidence supports.

| Tier | When | What the student sees |
|---|---|---|
| 0. Full coaching | Grading is `graded`, coaching generated, every post-check passes, within the latency ceiling | Verdicts and score, plus the coaching text |
| 1. Partial coaching | Grading is uncertain only because the grader abstained on some criteria (`grader_abstained`); the other criteria are resolved and sanitized | Coaching on the resolved criteria only, plus a plain line that the unresolved part could not be scored and is held for review. Never any claim about the unresolved criteria |
| 2. **Response without coaching** | Grading is `graded` but coaching is skipped, fails a post-check, times out or errors | Today's composed result unchanged: score, per-criterion verdicts, quoted evidence, `minimum_fix` for FRQ; chosen-answer rationale and skill label for MCQ. No placeholder, no "coaching unavailable" apology. The student cannot tell anything was skipped |
| 3. Result unavailable | Grading itself did not complete (`provider_unavailable`, `provider_timeout`, `output_malformed`, `output_empty`, `integrity_failed`, `request_invalid`) | An honest "we couldn't score this one right now" message, the student's response saved, no score shown, no coaching, and a retry path. This tier is today's behaviour and is not changed by coaching |

Rules that hold at every tier:
- **Grade first, coaching second.** The verdict and score render as soon as grading returns. Coaching is a separate post-grade call that fills the card when ready. If it has not arrived by the latency ceiling (starting point: 4 s after the grade renders, owner to set), the card stays at tier 2 and the late result is discarded, not inserted afterward.
- **Fail closed, silently.** A failed post-check (points mismatch, quote not in response, correct choice leaked, claim not in source fields, length or banned phrase) drops to tier 2 and records the reason code. The student sees no error.
- **Never coach through an integrity or provider failure.** Tiers 1 and 0 require a trustworthy grade; tier 1 applies only to abstention, never to integrity or provider failures.
- **The tier is recorded** with the reason code on every attempt (section 7) so coverage can be measured.
- **Fixture rule:** the tier 2 card must render identically to today's card for the same grading row. The offline test (section 9) includes a regression check that coaching-off output is byte-for-byte unchanged.

## 7. Reason codes for uncertain grading and skipped coaching

Today every non-graded outcome lands in one `uncertain` status, so a provider billing failure, malformed JSON, a failed integrity check, a real abstention and a by-design human-review route are indistinguishable. On Development, 54 of 64 uncertain FRQ gradings were OpenAI "no credits remaining", which looks identical to grader doubt in the data. v2 adds a reason code so each cause can be counted and acted on separately.

**Grading-stage codes (proposed):**

| Code | Meaning | Retry? | Counts against grader quality? |
|---|---|---|---|
| `provider_unavailable` | Provider refused or failed: billing or quota exhausted, persistent 5xx or 429 | After the existing single transient retry | No, but counts against availability and triggers an alert |
| `provider_timeout` | Request exceeded the timeout | Existing single retry | No (availability) |
| `output_malformed` | Model returned invalid or truncated JSON | **Retry once (new)**, logging raw output and token counts | Yes |
| `output_empty` | Provider returned no output text | Retry once (new) | Yes |
| `request_invalid` | Our request shape was rejected (for example a response-schema error) | No; alert, it is a code bug | No (defect) |
| `integrity_failed` | Sanitizer integrity issue (`SanitizationIssue` code recorded as detail) | No | Yes |
| `grader_abstained` | Model returned `unable_to_determine` on one or more criteria | No | Yes |
| `routed_human_review` | Spatial, holistic or structured item routed to shadow or human review by design | No | No (out of automated scope) |
| `deterministic_unresolved` | A deterministic verifier marked criteria unresolved | No | Reported separately |

**Coaching-stage codes (proposed):** `coaching_skipped_uncertain`, `coaching_check_failed` (detail: which check), `coaching_timeout`, `coaching_provider_error`, `coaching_disabled` (flag off or subject not enabled).

**Storage options (owner decision):**
1. *No-migration option:* prefix the existing `uncertainty_reason` text with the code (`output_malformed: Unterminated string at position 195`) and add a small parser. Lowest risk, usable for the offline replay immediately, but queries need string matching.
2. *Column option:* add `reason_code` (grading) and `coaching_tier` / `coaching_reason_code` (coaching) to `grading_results`. Cleaner counts and alerting, but it is a migration and an `evaluate-attempt` change, both hard-gated.

Recommendation: use option 1 for the offline replay and the pilot, and take option 2 to the owner as part of the release design if the go/no-go passes.

**Retry and diagnostics changes:** one retry on `output_malformed` and `output_empty` (today parse failures are never retried), and failed attempts must store the raw response and token counts. The stored Development failures have neither, so it cannot be confirmed whether they were truncations by `OPENAI_MAX_OUTPUT_TOKENS`.

**Billing alert:** a `provider_unavailable` count above a small threshold in an hour should alert the owner. This is independent of coaching and arguably urgent.

## 8. Exemplars (replaces layer 5)

6 to 8 owner-approved example texts: MCQ miss, MCQ correct, FRQ partial, FRQ zero on a part, FRQ full credit. Two in the prompt at a time, rotated; the rest held out as regression fixtures. Encouragement and progress framing are excluded until real history and the design-rule decision exist. Seed from the 22 texts in `HUMAN_READ_PACKET.md` that David explicitly approves or revises; nothing is approved by inference.

## 9. Test and go/no-go

**Evidence so far (2026-11-14, Development data, synthetic students, nothing written).**
- *20 items (10 MCQ, 10 FRQ), coaching only:* median 1.9 s to generate, about $0.00015 per MCQ and $0.00026 per FRQ; the deployed grade adds about 1.1 s (MCQ) and 7.3 s (FRQ). Render is 16 to 50 ms. 2 of 10 FRQ texts quoted words the student never wrote.
- *Why gradings end uncertain (Development):* 54 of 64 uncertain FRQ gradings were OpenAI billing exhaustion; the rest were malformed output (4), abstention (3), a one-off request bug (2) and an integrity failure (1). Latest run: 13 of 15 non-billing gradings graded.
- *5 MCQs in sequence, one student, one topic:* adaptation works only when code computes the history (section 5). Model-judged quality comparisons were mixed and are not relied on. Single scripted sequence, one generation per cell, so this is a feasibility signal, not a rate.

**Offline replay, no Production touch.** Run the coaching prompt over stored or gold-set grading payloads and synthetic responses (no real student text sent to any provider without owner approval). 60 cases: 15 MCQ and 15 FRQ per subject, including planted faults (wrong points, fabricated quote, leaked correct answer, claim not in rationale) and a negative control.

David reads all 60 blind against today's text (about 90 minutes). A subject reviewer checks every factual flag.

**Coverage gate (new).** Coverage is the share of eligible attempts that reach tier 0 or tier 1, reported with counts. Eligible means every submitted FRQ or MCQ attempt in the replay, excluding `routed_human_review`. Report four numbers separately, split by reason code: *coverage* (tier 0 or 1), *availability* (a trustworthy grade exists), *grader-quality uncertainty* (`output_malformed`, `output_empty`, `integrity_failed`, `grader_abstained`) and *provider failures* (`provider_unavailable`, `provider_timeout`, `request_invalid`). Provider failures count against availability and the alert, not against grader quality. The replay must run through the real Development grader with at least 30 FRQ attempts, so a single run's billing outage cannot decide the result. Treat coverage as a pilot figure with its denominator.

**Go only if all hold:**
- zero texts contradict the grader's points or the answer key;
- zero MCQ texts reveal the correct choice;
- at most 1 of 60 contains a claim unsupported by the item or rubric fields;
- David prefers coaching in at least 40 of 60 pairs;
- post-checks catch every planted fault;
- cost and latency fit a ceiling David sets first (suggested starting point: about $0.005 and 3 seconds per attempt);
- FRQ coverage is at least 90% and MCQ coverage at least 99% (starting thresholds for David to set), with every shortfall attributed to a reason code;
- the tier 2 card is identical to today's card for the same grading row, and tier 3 messages render for every grading-failure code.

Even a pass is a pilot result: 60 cases cannot certify a near-zero error rate; report counts and the specific failures.

**No-go:** keep composed text (tier 2 everywhere); spend the effort on thin rationales and `minimum_fix` quality, which feed the existing graders directly.

## 10. Sequence

0. Read-only counts: MCQ rationale quality and thin-rationale share; FRQ part verb inventory; whether both CEDs define task verbs; Biology grader accuracy baseline (no verification profile).
1. Draft coaching prompt, glossary and exemplars; owner approves exemplars.
1b. Define the history inputs: topic miss counts from attempts and, for cell-tagged items, tier and `due_reason` from `student_cell_state`; write the directive table and its tests.
2. Build the post-check module and its planted-fault tests as pure functions with unit tests (no deployment). Add the tier resolver (grade outcome and coaching outcome in, tier and reason code out) with a unit test for every row of the section 6 table and every code in section 7.
3. Offline replay of the 60 cases (including a cross-session history set: at least 3 synthetic students, 2 sessions each, with a gap between sessions), plus at least 30 FRQ attempts through the real Development grader for the coverage gate; owner read; go/no-go.
4. If go: design the release as its own plan (below). If no-go: stop.

## 11. Placement if it ships (separate approval)

Lowest-risk shape: a **separate post-grade call** that leaves grading latency and the locked grade untouched, writing coaching text as an optional field the card shows when present and otherwise shows today's summary. Alternatives (in-line in `evaluate-attempt`) add latency to the grading path.

## 12. Owner approvals required (hard gates; none requested yet)

- Any change to `evaluate-attempt` or a new edge function.
- A new stored field or migration (including the optional `reason_code` and `coaching_tier` columns, section 7).
- Reason-code tagging, the one retry on malformed output, and raw-output logging in `evaluate-attempt`.
- Creating a synthetic student account in Development for the replay.
- Reading student memory or `student_cell_state` into a coaching call (a read path that does not exist for feedback today). The offline replay uses synthetic students only.
- Sending student response text to a coaching model, and which provider.
- Raising the daily spend cap (`OPENAI_DAILY_CAP_USD`, `evaluate-attempt/index.ts:102`) or adding per-attempt model cost.
- The unresolved praise/encouragement design-rule decision.
- Replaying real student attempts offline.

## 13. Risks

- **Coverage may be the binding constraint.** On Development only 63% of non-billing FRQ model gradings were `graded` (87% on the latest run); Production has no FRQ model gradings since September, so the current uncertain rate there is unmeasured. Until the replay shows otherwise, expect coaching on a minority of FRQs, not all.
- **Provider billing failures are invisible today** and look like grader doubt; the reason codes and alert address this.
- **Grader error becomes confident prose.** Coaching amplifies a wrong verdict; Biology has no deterministic verifier. Measure grader accuracy on the replay items, not just coaching accuracy.
- **Answer-key and rationale errors** pass through faithfully. Add a student "this seems wrong" route that feeds a gaps list (`report-question` function exists; check fit).
- **Ongoing cost:** one extra model call per graded attempt, indefinitely. Price it before the test, not after.
- **Owner review time** is the real bottleneck; the plan budgets about 90 minutes for the read plus exemplar approval.
- **No success metric yet.** Define one before any pilot: retry-earns-the-missed-point rate and More-help click rate.
- **Surface overlap:** feedback card, More help and Progress recommendations need a stated boundary before release.
- **Separate urgent item:** verify whether a gateway key was exposed in earlier transcripts and rotate through the approved path. Independent of this plan.

## 14. Decisions for David

1. Approve the grader-first direction and retiring layers 3, 8 and 9 as separate artifacts.
2. Which of the 22 packet texts are approved exemplars, as marked or after revision?
3. Name the subject reviewer for factual flags.
4. Set the per-attempt cost and latency ceiling.
5. Are praise and encouragement copy prototype-only for now?
6. Set the coverage floors (starting: FRQ 90%, MCQ 99%) and the coaching latency ceiling (starting: 4 s after the grade renders).
7. Reason-code storage: prefix in `uncertainty_reason` for now (option 1), or take the column migration (option 2) to the release design?
8. Approve a Development synthetic student account for the real-grader replay.
9. May post-submit MCQ coaching name the correct answer, or must it follow the shipped rule (explain the error, return a question, never name the answer)?
10. Confirm the history sources: attempt-derived topic counts plus cell tier and `due_reason`, with student memory fields (`preferred_help_style` etc.) left out of v0.
