# Session close — Coaching via the grader engines, v2 plan, UI and Lovable build (2026-11-14 to 2026-11-15)

## Current task and outcome

Started as an assessment of `COACHING_LIBRARY_V0_PLAN_2026_11_12.md` (a local file that was never pushed; the review used a pasted copy). The owner redirected to **producing coaching through the grader engines** and the work became:

1. An independent review of v0 (with a second model, Fable 5.2) that cut the offline library: layer 3 (distractor labels) dropped, layers 8/9 dropped as separate artifacts, layers 1 and 5 shrunk.
2. A **v2 plan**, `docs/product/COACHING_VIA_GRADER_V2_PLAN_2026_11_14.md`: coaching renders the grader's sanitized output and never re-judges; every failure falls back to today's text.
3. Offline measurements (timing, cost, uncertain-grading causes, history adaptation, prompt variants).
4. A UI for a coaching slot and a 1 to 5 "Helpful?" rating, built in the `web/` prototype and then, via a Lovable draft, in the production app.

Outcome: the v2 plan and evidence are committed (PR #665); the **production app now has the feedback card and rating live with coaching switched off**, so students see no coaching yet and ratings are stored on the device only.

## Owner decisions made this session

Formal `DECISION-` numbers were not assigned (check open PRs before numbering, past collisions). Recorded in the v2 plan:

- Use the grader engines for coaching content (direction).
- MCQ coaching **never names the correct answer** (so a student can still retry); coaching explains the error and returns a question.
- **Use the three-rule lean prompt for v0**, to keep it simple. The owner's blind read found both versions worked and the longer texts more helpful, but the owner is not the target audience, so the student rating is the quality signal and a longer variant stays a candidate to test.
- Add a subtle 1 to 5 rating; scrolling and the other hard layout rules are guidelines (consistent with DECISION-0132 and DECISION-0133, two-pane layout).
- Revert the "Next step" hint move in the production side panel; the card repeats the composed text in its own slot.
- Lovable draft accepted and published.

## What the evidence says (details in the v2 plan section 9 and `scripts/content-seed/coaching-grader-v2-2026-11-14/`)

- **Existing history is recorded, not used for feedback text.** The grader writes student memory and Course Mode cell state across sessions (`grading-memory.ts`, `cell-state.ts`, `student_cell_state`); the Home start queue reads cell state. `evaluate-attempt` loads recent attempts and memory but reads only the subject key from them, and `composeMcqFeedback` takes no history. (An early statement in the session that the grader had no history input was wrong and was corrected.)
- **Timing and cost (Development, synthetic):** coaching about 1.9 s median per question, about $0.00015 per MCQ and $0.00026 per FRQ; deployed grade about 1.1 s (MCQ) and 7.3 s (FRQ); render 16 to 50 ms. Estimated submit to render about 3 s MCQ and about 9 s FRQ (grade leg is from recorded Development timings, not a live run).
- **Uncertain gradings:** 54 of 64 uncertain FRQ model gradings on Development were OpenAI billing exhaustion (Nov 1, 2, 8); the rest were malformed output (4), abstention (3), a one-off request bug (2), integrity (1). Latest run: 13 of 15 non-billing gradings graded. Production has 35 FRQ model gradings (26% uncertain, all July except one in September), none since, so the current Production rate is unmeasured. Billing failures are indistinguishable from grader doubt in the data.
- **History adaptation:** when the model counted history itself it miscounted 6 of 15 steps and escalated on the third miss 0 of 3 times; with counts and directives computed in code, 0 miscounts and 3 of 3 escalations (three scripted sequences, one student each; both arms now share one fixed script of questions and wrong answers, after a review caught that an earlier run gave them different distractors).
- **Prompt and checks:** the three-rule prompt always ended with a question (20 of 20 vs 3 of 20), ran shorter and faster, but did not reduce answer-naming (14 vs 15 of 20 flagged); one retry after a failed check lifted passing from 6 to 14 of 20 (70% coverage).
- **Authored rationales may name the answer:** 5 of 20 sampled distractor rationales were flagged (model-judged, not verified). The shipped feedback shows those rationales verbatim.

## Code and systems changed

- **Cramapple repo (PR #665, ready for review, checks green at last check, merge pending):** v2 plan, `web/` prototype (feedback slot, `FeedbackRating`, session storage of the rating, `?coachdemo=1` demo stub), design-system readme note, `web/README.md` note, and `scripts/content-seed/coaching-grader-v2-2026-11-14/` (harness and results). No Supabase function, migration or Production data was changed. Dev data was read only; Production was read once for aggregate grading counts.
- **Lovable project "New Cramapple App" (production, `56cae479-f7c9-4988-b536-56538c38ee4e`):** draft `drft_01m7e59aemfxktpt2ecb8btj2z`, commit `9487891dcd0ebe1a1146b5411f4b3823609ff108`, merged 2026-11-14 23:40 UTC and published by the owner. Adds `src/lib/coaching.ts`, a feedback card in the `/question` task pane, `VITE_COACHING` (default off), two test files, notes in `AGENTS.md` and `roadmap.md`. An unrequested dependency bump (`@lovable.dev/vite-tanstack-config` 2.26.5 to 2.27.1) was reverted at review. The side panel is unchanged from main.

## Verification and approval state

- Verified by reading the diff and tests; not verified by running the live site or confirming the draft's CI results. The preview needs a sign-in; Lovable also could not see a real scored question.
- **No approvals were requested or consumed.** Everything that needs one is still open (below).
- Model calls used the session's AI Gateway key for synthetic content only (a few cents). The v0 plan's open item to check whether an earlier transcript exposed a gateway key and rotate it was not resolved here.

## Open work and next owner (David Bloom decides; approvals are hard gates)

1. **Build `coach-attempt` and `feedback-rating`** (the contract the Lovable adapter codes against; proposed, not built). Needs a build plan and approval: new edge functions, a new stored field or event, and a decision on provider and sending student response text to a coaching model.
2. **`evaluate-attempt` changes:** reason codes on uncertain grading, one retry on malformed output, raw-output logging, billing alert (plan section 7). Approval needed. The billing alert is useful regardless of coaching.
3. **Real-grader replay on Development** (at least 30 FRQ attempts through the deployed grader) to get a clean current uncertain rate and the coverage gate. Needs a synthetic student account in Development and working OpenAI credits there.
4. **Audit authored MCQ distractor rationales for answer-naming** (5 of 20 flagged) and decide who rewrites them.
5. **Cross-session history test** (at least 3 synthetic students, 2 sessions each) using the persisted cell state.
6. **Set** the coverage floors (starting 90% FRQ, 99% MCQ), the coaching latency ceiling (starting 4 s), the cost ceiling, and approve rating capture (decision 12) and history sources (decision 10).
7. **Look at the live site signed in** (graded MCQ and FRQ) to confirm the card renders and the side panel is unchanged.
8. **Decide whether to hide the rating row** until server capture exists; today it collects nothing the team can read.
9. After real ratings exist, test a longer structured prompt variant against the three-rule prompt.
10. Merge PR #665 when satisfied.
11. The `.claude/skills/cramapple-design` mirror still describes three panes (DECISION-0133 records it as stale).

## Do not

- Do not turn `VITE_COACHING` on until the endpoints exist and are approved; with it on and no endpoint, the app silently falls back.
- Do not treat the model-judged leak and coverage figures as verified; none were human-checked, and the sequence results are one scripted student each.
- Do not rely on the first `run_test.py` run (invalid, reasoning left on); only the rerun counts.
- Do not send student response text to any model provider without owner approval.

## Where things are

- Plan: `docs/product/COACHING_VIA_GRADER_V2_PLAN_2026_11_14.md`. Evidence and harness: `scripts/content-seed/coaching-grader-v2-2026-11-14/` (README explains how to rerun).
- PR #665 on GitHub; the superseded v0 plan exists only on the owner's machine.
