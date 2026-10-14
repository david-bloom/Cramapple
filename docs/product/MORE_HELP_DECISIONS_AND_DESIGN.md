# More help — decisions, design and demo contract

**Status:** Approved
**Date:** 2026-10-13 (America/New_York)
**Owner:** David Bloom
**Execution:** David confirmed real Calculus AB/BC and Chemistry questions in app.cramapple.com. Backend is implemented in Development and the app PR is draft; Production is unchanged. Actual generation is blocked by exhausted API credits. David requested [Claude adversarial QA](../qa/MORE_HELP_CLAUDE_ADVERSARIAL_QA_PROMPT_2026_10_13.md), including the API-versus-subscription choice. See [production work order](../tasks/WORK-MORE-HELP-PRODUCTION.md).
**Canonical repository:** david-bloom/Cramapple
**Restart handoff:** [MORE_HELP_SESSION_HANDOFF_2026_10_13.md](../handoffs/MORE_HELP_SESSION_HANDOFF_2026_10_13.md)
**Preserved mocks/source:** [More help artifact bundle](../design-reference/more-help/README.md)

## Goal and agreed direction

Cramapple's mission is **the best score with the least study time**. Help must make the next scoring action clearer, rather than simply show more information. The student should not need to diagnose their own difficulty beyond “I don't get it.”

David's starting idea combined a narrow, defined content set with a flexible explanation agent: highlight what matters in the current question and explain how the answer follows from that information. Discussion refined this into targeted repair: connect a few relevant facts to the question, then focus on the specific missing piece (such as what a formula means, how to use it, a unit conversion or a way to remember it).

The name is **More help**. “Get unstuck,” “I'm stuck” and “I don't get it” were earlier working labels. “Still struggling” describes the focused-help state, not another mandatory entry screen.

## Entry and interaction decisions

Both entry paths start on a question page:

1. Student answers an MCQ or FRQ, receives grading, then chooses **More help**.
2. Student cannot answer and chooses **More help** directly.

Both paths land immediately in the focused “still struggling” experience. Do not require a first explanation screen followed by another “still struggling” click. Do not require a diagnostic microquiz before explaining. An optional small check or fresh question can follow useful help; it is not the price of admission.

Keep the current question and answer visible. Preserve any existing grading and typed work. When the student skipped grading, do not invent a score, answer or diagnosed misconception. A selected distractor suggests a possible gap; only the student's reasoning or evidence can establish it.

The initial help should connect a small number of relevant pieces of information to this exact question and show what the student needs to do to earn the next point. If that does not click, offer focused follow-ups such as “Why divide by time?”, “Why convert to liters?”, “How does the formula work?”, “Help me remember”, or an appropriate visual. Keep the explanation short and the next action manageable. Do not grow this into an unbounded chat or a full lesson on every related topic.

## Two-pane help template

This is a **new help template**, launched from the ordinary question page; it does not replace the existing ordinary question-page layout.

| Left pane: current question | Right pane: More help |
| --- | --- |
| Subject/topic, full question and necessary stimulus | A direct, short explanation of the likely missing piece |
| Relevant words/quantities highlighted without removing context | Approximately 1–3 checked facts/formulas/definitions linked to the question |
| Student answer/optional reasoning, and grading when available | How those facts lead to the answer or rubric point |
| Preserve the answer while opening/closing help | One manageable next step, followed by focused help options |

Desktop: side by side. Phone: stack vertically, maintaining reading order and access to the question. Use the canonical Cramapple orange/light design, square corners, readable Source Sans 3 text and appropriate math typography; avoid motion. The preserved screenshot is the actual earlier mock, not a new redesign.

Useful states: before answer, graded answer, help loading, focused repair, narrower follow-up, connection/error with preserved work, optional retry/transfer question, and reviewer feedback. The old scripted mock includes an initial microstep and earlier labels; that is historical implementation, **not** a reversal of the later direct-to-focused-help decision.

## Where the explanation comes from

Agreed direction: dynamically generate the repair from the current question and checked reference content, with relevant persistent student engagement information when the production integration can supply it reliably.

Use:
- exact question/choices/stimulus and scoring criteria;
- the student's current answer and explicit reasoning, if provided;
- authored reference-pack entries, vetted relevant hooks and available figures;
- criterion-level grading and repair information, when available;
- relevant prior attempts/help or engagement evidence that actually exists.

The narrow content set is the grounding boundary. A flexible agent explains relationships and adapts the explanation; it does not invent source facts, prior history, mastery, or a permanent misconception. Do not treat absent/sparse history as evidence that the student knows or does not know a concept. Model-generated phrasing is an explanation, not automatically a new checked reference entry or memory hook.

**Reference availability, verified October 12:** 1,083 published entries and 13 hooks were identical between Development and Production across 33 stored subject/unit groups. Chemistry covers Units 1–9; the other subjects' currently built packs cover their first three registry units; Calculus BC inherits AB reference content. “All reference packs in Production” does not mean every subject's future units are already authored. See [reference parity audit](../qa/REFERENCE_PACK_PARITY_AND_HOOK_HELP_POLICY_2026_10_12.md).

**Hooks/hints rule:** DECISION-0118 / APPROVAL-0164 permits directly relevant, vetted published hooks in hints, post-miss feedback and student-requested targeted help, with the reference entry, expansion and caution. Pre-submission help remains assistance; post-submission help does not retroactively change independence. Practice answer-disclosure and BYOQ boundaries still apply. Demo-authored recall phrases are not represented as published hook-bank entries. See [production protocol §1.3](MEMORY_HOOKS_AND_UNIT_REFERENCE_PRODUCTION_PROTOCOL.md).

## Existing FRQ engines: reuse opportunity, not completed integration

David noted that the three FRQ grading engines could also help here. Use existing verification/criterion-feedback/repair services where they fit instead of duplicating grading logic. Candidate seams in the backend include `_shared/grading-router.ts`, `_shared/deterministic-verifier.ts`, `_shared/math-verifier.ts`, `_shared/grading-feedback.ts` and `_shared/grading-repair.ts`.

The source audit found multiple routed strategies, including deterministic numeric checks, symbolic/method/ECF checks and model text grading. The `symbolic_ecf` route was profile-bound and non-authoritative shadow work in `evaluate-attempt`; unknown/unparseable inputs can abstain. Do not claim every engine is authoritative or interchangeable. `buildRepairPlan` can rank missed criteria by points/leverage/priority/effort when supplied with the required metadata and preserves the locked grade. Re-check current source before production wiring.

**Neither preserved demo uses those production engines or production student history.** The demos check two fixed MCQs against verified keys. The production integration remains future work.

## Demo questions and expected repair

### Calculus: average rate of change

Question supplied by David:

> The volume of water in a tank is V(t) = t² + 4t liters, where t is measured in minutes. What is the average rate of change of the volume from t = 1 to t = 5 minutes?

Demo choices: A 40 L/min; **B 10 L/min**; C 14 L/min; D 45 L/min. These are the demo's authored choices; do not assume they are an export of the production item.

Checked chain: V(1)=5 L; V(5)=45 L; change in volume=40 L; elapsed time=4 min; average rate=(45−5)/(5−1)=10 L/min. Highlight “average rate of change” and the two times. Selecting A can suggest stopping at volume change, but the agent should not assert that diagnosis without reasoning. Useful focused repairs: the meaning of rate, evaluating V(5), dividing by elapsed time, secant slope versus derivative, or remembering “change in water over change in time.”

The original production-page URL was https://app.cramapple.com/question?mode=practice&type=mcq&topic=%222.1%22&from=home&worked=%221%22. It is a serving route, not a durable identifier for this exact tank question; the next session must use the preserved stem/lesson data.

### Chemistry: molarity

Demo question:

> A solution contains 0.30 mol of NaCl in a total solution volume of 150 mL. What is the molarity of the solution?

Demo choices: A 0.0020 M; **B 2.0 M**; C 0.50 M; D 45 M.

Checked chain: M=moles of solute/liters of total solution; 150 mL=0.150 L; 0.30/0.150=2.0 mol/L=2.0 M. Highlight the amount, total volume and requested quantity. A 0.0020 result can suggest dividing by mL rather than liters. Useful focused repairs: what molarity measures, why liters matter, formula structure, a recall aid, or a volume/concentration visual.

Exact lesson facts, source IDs and focused buttons are preserved in [lessons.ts](../design-reference/more-help/lessons.ts).

## Kids' feedback and what remains open

**Update, 2026-10-13:** David reports “Student feedback on the mock design and content is very positive” and directs moving calculus and chemistry into production. Treat the mock design/content as accepted on that report; no individual student reactions or live-generation result are inferred. The [production work order](../tasks/WORK-MORE-HELP-PRODUCTION.md) records the current-source audit, proposed app slice, release checks and pending destination question. The pause described below is the prior historical state, superseded for production preparation by this instruction. No demo/app publication occurred in this orientation.


David sent screenshots to both kids. He then explicitly said: **“Do not build the demo. If they ask for a live demo I will tell you to restart. For now, do nothing.”** The live build is paused. The current request authorizes documentation/preservation only, not further rendering, invitations, publication, model calls or production implementation.

The intended test when restarted: answer a question, try More help, say whether it helped and what remained confusing. The saved live candidate has a 1–5 helpfulness rating and comments, storing the answer, generated explanation and feedback for David's owner-only `/feedback` view. At the original paused checkpoint, screenshot feedback had not yet been supplied. The October 13 update above records David's later positive report; do not invent individual reactions.

Questions for feedback: what specifically helped; which step still failed to click; whether the text was too long; whether the question staying visible helped; whether a hook/visual made the next action clearer; and whether they could then attempt a similar problem. Treat these as test prompts, not a required new research project.

Open decisions include production history selection/retention, the final response contract/latency budget, real grading-engine routing and verification, assistance receipts in the new surface, and how to measure independent performance on a follow-up question. Resolve only the next small slice needed after feedback. The mock does not prove a score improvement or time-saving claim.
