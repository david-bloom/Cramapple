# Coaching Arc — Planning Draft (rev 2: model-default)

STATUS: DRAFT (planning exercise, not a decision; no approvals recorded)
DATE: 2026-11-11
OWNER: David Bloom
Related: `TASK-0053` (distractor feedback, the deterministic floor), `TASK-0054` (reference content model),
`TASK-0050` (skill labelling), `TASK-0064`/`0065` (Open Hand), `docs/new_design/CONTENT_AND_PEDAGOGY.md`,
`DECISION-0074` (mastery rule), O11/O12 in the one-pager.

## Goal (David, 2026-11-11)

Make Cramapple a more dynamic teacher, not a glorified decision tree that hands out canned text keyed to the
specific error. Coaching should respond to what this student did, wrote, and has already seen. Cost must be
tracked, and MCQs (the majority of questions) must carry minimal cost impact.

## What changed from rev 1

Rev 1 composed coaching from authored fields and called a model only on repeats or "explain more". That is a
lookup with an escape hatch. Rev 2 reverses it: **the model authors coaching by default**, grounded on the
authored content, and the deterministic text from `TASK-0053` becomes the instant floor and the fallback.

## Decisions (David, 2026-11-11)

1. **Scope:** three layers as one arc (per answer, per session, across sessions).
2. **Generation: model by default**, grounded on authored content. Deterministic composition is the floor and
   the fallback, not the main path. (Reverses rev 1.)
3. **Surface:** inside the existing feedback card.
4. **Tone/format (amends `CONTENT_AND_PEDAGOGY.md`):** concise, but coaching may reference longer concepts,
   vocabulary, formulas or diagrams. Praise when earned; encouragement when struggling. Needs a DECISION record.
5. **Verdict:** stays "Correct" / "Incorrect" in one word, with coaching beneath it.
6. **Emoji:** allowed, at most once per card; the ✓ ✕ ↻ glyph set stays.
7. **"Explain more"** is the equivalent of a hint (cost surfaced before disclosure, receipt kept, listed in
   "Hints used"). Mastery impact follows the O11 hint-timing definition.
8. **Open Hand:** coaching is offered as an invitation asking what is confusing. It suggests likely confusions
   and also lets the student describe a different problem. Nothing is scored; student-initiated.
9. **Praise rule (approved):** full credit on an item previously missed, or on a cell with prior misses, or
   first-time full credit on a hard item. No praise for routine correct answers.
10. **Encouragement rule:** when the student improves without full credit, and when the student shows no
    improvement but tries again. Both get it, framed differently (progress versus persistence).
11. **First slice:** AP Biology and AP Statistics, MCQ and FRQ.
12. **Cost:** tracked per call; MCQs must have minimal cost impact (see Cost architecture).
13. **Tiers approved (2026-11-11):** T0 floor, T1 shared and cached, T2 personal, as described under Cost
    architecture. The T2 share of MCQ misses and the cost ceiling are still to be set from the prototype.

## What "dynamic" means here

1. Authored content is the teacher's knowledge, not the output. Briefs, explainers, rubrics, rationales,
   vocabulary, formulas and diagrams are retrieved as context for a model that reasons about this student.
2. It reads the student's own work. FRQ grading already stores an `evidence_quote` and a
   `decision_explanation` per criterion, so coaching can respond to what the student wrote.
3. It uses history: prior misses, hints used, what has already been explained, so it does not repeat itself.
4. It supports a short exchange (Open Hand "what's confusing?", "explain more").
5. Authored content is also the check: checker models and planted-defect controls test that generated
   coaching does not contradict the CED, the rubric or the key.

## Coaching unit (what the model is asked to produce)

Miss → point → cause → move, expressed in the model's own words: which rubric point or habit the miss cost,
why (reasoning trap, knowledge gap or execution slip), and one specific next action, optionally pointing at a
vocabulary term, formula, diagram or explainer section. Praise and encouragement follow decisions 9 and 10.

## Cost architecture

### Baseline (Production, measured 2026-11-11, small pilot sample)

- MCQ grading is deterministic: cost $0, no model call, instant (99 results).
- FRQ grading calls a model: avg $0.0091 (max $0.0157) per result, avg 1,734 input and 560 output tokens, about
  9 s latency, 0 cached tokens (34 results).
- About 29% of recorded MCQ attempts were incomplete (29 of 100); tiny sample including internal accounts, so
  use it only as an order-of-magnitude hint that misses are a minority of MCQ answers.

### Tiers

| Tier | When | Cost shape |
|---|---|---|
| T0 floor | Always, instantly: verdict plus the `TASK-0053` composed text | $0, no latency; shown immediately and kept if anything below fails |
| T1 shared | MCQ miss with no relevant personal history | Model-authored, grounded, short (hard token ceiling), cached per (item version, chosen choice); cache hit costs $0 |
| T2 personal | FRQ always; MCQ miss with relevant history (repeat in cluster, prior hints, recurring cell), "explain more", Open Hand questions | Per-student call, small context, capped per answer and per student per day |

### Why this keeps MCQ cost low

- Misses only: correct answers need no model call (earned praise and encouragement use short frames unless the
  student has history worth responding to).
- **Cache fill ahead of time.** The slice has 861 published MCQs (Statistics 460, Biology 401), about 2,583
  distractors. T1 text for every (item, distractor) can be generated once in a batch, checker-reviewed under the
  existing generate-and-select policy, and served from cache at runtime. Marginal runtime cost for the common
  MCQ miss is near zero.
- Personalised T2 calls run only when there is something personal to respond to, so the share of MCQ misses
  that cost money is a controllable fraction, not all of them.
- Static context (item, rationales, brief, explainer excerpt) goes first in the prompt so provider prompt
  caching applies to T2 calls.
- Use the smallest model that passes the quality bar for T1 and T2; reserve larger models for FRQ and for
  escalations.

### FRQ

FRQ already pays about $0.009 per grade. Prefer producing coaching in the same grading call (a few hundred more
output tokens) over a second call; decide after the offline prototype measures both.

### Tension to decide

A shared cache is closer to "prepared explanation" than a live reply. The dynamic quality comes from T2 and
from the personal-history triggers. How often T2 fires on MCQs is the dial between "dynamic" and "cheap", and it
should be set from measured quality and cost, not guessed.

### Tracking and controls

- Log every model call used for coaching with model id, prompt version, input/output/cached tokens, estimated
  cost, latency, tier and cache hit. Reuse the columns on `app.grading_results` where they fit, otherwise add a
  coaching events table (schema to be proposed; Hard-Gate to apply in Production).
- Per-answer token ceilings, per-student daily budget, a global feature flag and kill switch. When a cap is hit
  the card shows T0 and nothing breaks.
- Weekly cost report by subject, item type and tier, plus cache hit rate and T2 share of MCQ misses.
- Budget target left for David: a ceiling such as maximum coaching cost per 100 MCQ answers and per active
  student per day. The prototype in Phase 2 supplies real numbers to set it.

## Layers on the model-default design

- **Layer 1, per answer:** the grounded context is the item, chosen distractor or missed criteria, the student's
  own response, the topic brief, and relevant reference entries.
- **Layer 2, per session:** the context adds this session's misses, hints and clusters, so coaching can name a
  pattern in its own words rather than through a fixed rule. Encouragement follows decision 10.
- **Layer 3, across sessions:** the context adds recurring-gap history from `student_cell_state` and past
  attempts, and the card can route to the explainer and offer re-practice (left open in `TASK-0053`). Blocked on
  O11 (hint-timing definition) for anything that touches mastery, and on skill labels for skill-level history.

## Labels and retrieval

Labels now serve retrieval and grounding as well as serving. Phase 0 findings (Production, read-only,
2026-11-11, non-retired packs, published items):

- Skill labels are partial. Statistics (pack `548f06be`): MCQ 88 of 460, FRQ 69 of 110. Biology (pack
  `2d88ba5e`): MCQ 146 of 401, FRQ 74 of 89. The 203 skill-coded Statistics MCQs found earlier sit on retired
  pack `7c5a2975`, which students are not served. Codex is to run `TASK-0050` Phase B for these.
- Point briefs are complete and published: Biology 60 of 60, Statistics 55 of 55. They are short prose, so
  distractors and FRQ criteria still need links to specific brief habits and explainer anchors (a retrieval
  index, not a script).
- Every FRQ criterion has a `minimum_fix`. (Earlier counts of 785 and 913 covered all statuses; published-only
  criteria totals were not re-run. Published FRQ items: Statistics 110, Biology 89.)
- Placeholder feedback is gone (0 of 133 grading results); results come from only 5 users, so real-student
  evidence is thin.

## Privacy and provider

Coaching sends student responses to a model provider. Decide before building: which provider and gateway, what
is sent (no names, emails or user ids; only item context and the student's response), retention, and consent
copy. Treat as a hard gate alongside cost.

## Phasing

0. **Baseline and cost model.** Done in part (above). Verify what the live card shows (Lovable `56cae479`).
1. **Context assembly and labels.** Skill labels via Codex; distractor and criterion links to brief habits and
   explainer anchors; reference entries (vocabulary, formulas, diagrams) indexed per topic.
2. **Offline prototype.** Generate T1 and T2 coaching for a sample of real pilot attempts. Judge quality with
   held-out model judges and planted wrong-teaching controls, measure tokens, cost and latency, compare with the
   T0 floor, and pick models. Output: the numbers David needs to set the cost ceiling.
3. **Cost-controlled runtime.** T0 floor, T1 cache with batch fill, T2 path, flag, caps, cost logging.
   Production changes are hard-gated.
4. **FRQ coaching** in the grading call, if the prototype supports it.
5. **Layers 2 and 3** as context features; Open Hand dialogue.

## Phase 2 prototype, first pass (2026-11-11)

Full detail: `scripts/content-seed/coaching-prototype-2026-11-11/RESULTS.md`. Eight published MCQs (four per
subject), synthetic misses and histories (no student data sent), three generator models, two held-out judges,
four planted-wrong controls (all four caught by both judges). Total spend about $0.81.

- **Quality:** model coaching beats the T0 floor by about 1.5-2 points of 5 on every axis; the largest gap is
  naming the exam point (0.5 for T0 versus 3.3-3.8).
- **Accuracy:** about 1 in 24 texts carried a real inaccuracy (one invented fact, one misattributed brief habit).
  Unreviewed live output is a risk; T1 cache-fill needs the checker step, and live T2 needs a cheap guard.
- **Cost per call:** T1 $0.0002-$0.00035; T2 $0.0003-$0.0005. Filling T1 for all 2,583 Biology and Statistics
  distractors costs roughly $0.53-$0.91 per pass. A T2 call is about 3-6% of the price of one FRQ grade.
- **Models:** haiku-5.5 best quality and fast (2.7 s) but runs long (100 words against a 90-word rule); gpt-6-luna
  cheapest and shortest but weaker; deepseek-v4-flash good quality but 8-23 s from reasoning tokens, poor for a live
  card.
- **Limits:** small sample, synthetic inputs, model judges only, no FRQ yet, T0 is an approximation.

## Phase 2 prototype, second pass: 30 MCQs and 10 FRQs (2026-11-11)

Detail: `scripts/content-seed/coaching-prototype-2026-11-11/RESULTS.md`. 15 Biology + 15 Statistics MCQs (every distractor),
10 FRQs with synthetic responses that miss known criteria, three generators, two held-out judges, 7 of 7 planted controls caught.
Spend $1.52. No student data sent; the existing grading engines are not involved (standalone script).

- **Quality:** model coaching scored about 4.2-4.6 of 5 on "would help" versus 2.8 for the floor; naming the exam point 3.9-4.4
  versus 1.5. FRQ coaching (reads the student's own wording) scored 4.0-4.8 and 0 of 30 texts were flagged.
- **Accuracy:** 13 of 330 texts were flagged and about 9 were real errors (wrong arithmetic direction, an invented probability,
  misattributed brief habits). So about 3-4% need rejecting; the review gate stays mandatory. DeepSeek flash accounted for 7 of 13.
- **Models:** gpt-6-luna best for MCQ (quality, 53 words, never over the cap, $0.0002/text); haiku-5.5 best for FRQ (4.75, $0.0006/call);
  ranking changed between passes with the prompt, so freeze the prompt before choosing.
- **Measured review cost:** $0.00164 per judge call, so two judges over 2,583 texts is about $8.5. One-time pre-fill total about $9-10.
- **Still untested:** real student data, hand-drawn FRQs, human read of outputs, wiring into `evaluate-attempt`.

## Coaching voice rules (David's human read, 2026-11-12)

**Organizing principle (David, 2026-11-12): we are showing students how to earn points.** That may require teaching concepts or giving information, but coaching always connects to a rubric, and a student can discern the rubric from the question. So every coaching text answers: what does the question require, what did the response do or not do against that, and what earns the point. Concept teaching is in service of that, never free-standing. MCQs are not rubric-based (David, 2026-11-12). For them, each distractor is the guide to how a point is lost: coaching identifies the specific error or gap that distractor represents and links it to the lost point. So the MCQ unit is distractor error or gap, then what a correct answer must show, then the lost point. The authored `mcq_choices.rationale` per distractor is the grounding for this; it already names the error. This resolves the earlier open question about brief linkage: the brief is background, the distractor rationale is the anchor. Caveat from rule 1: the rationale tells us what is wrong with the choice, not why this student picked it.

From marking MCQ 5 and FRQ 6 of the read packet. These replace the first-pass prompt's wording and must be in the frozen prompt before models are chosen.

1. **No claimed causes about the student's thinking.** "You picked A because you treated flexibility as the protection" asserts a motive. The authored rationale only tells us what is wrong with choice A. Say what the choice claims and why that fails ("Choice A says..."); name a habit only when the student's history shows it, and hedge it ("this may be...").
2. **Label the defect and the improvement explicitly.** Every text has two named parts: what was wrong (or missing) and what to do to earn the point. No implication, no "that matches the exam's move".
3. **Say how more points could have been earned.** Two kinds, and the text must say which: answer differently (restructure or reframe the answer to match the rubric), or improve knowledge (for example use the formula correctly). Link to the rubric criterion and the point it carries.
4. **Rubric linkage, both directions.** Name points earned ("Your 10% check is correct and earns that point") and points lost ("You did not verify the expected-count condition, which cost you a point"). Plain declarative framing of the loss; no "costing that point" asides. For MCQs, which have no rubric points, link to the exam skill or reasoning the question tests and say so plainly.
5. **Drop jargon.** "Move", "trap" and "habit" are internal terms. Use "what the exam wants you to do". Write what the student should do next as an instruction.
7. **FRQ coaching is anchored to what the question asks (David, 2026-11-12).** The question's own parts are the guide to the points. Structure: "The question asks you to do x, y and z. You did x but not y or z." Each lost point is tied to the specific criterion it came from, and the text shows where that criterion comes from (the wording of the part, or the rubric line).
8. **Say why the response is required, not just that it is missing.** For each lost point, state why the question requires that piece for full credit (for example, the part says "justify", so a bare conclusion cannot earn it; a condition check is required because the procedure is only valid when it holds). The first-pass FRQ texts mostly said what was absent without this reason.
9. **Consequence for inputs:** the FRQ call needs the question text split by part, each criterion's `learner_facing_text` and `points_possible`, and the reason the part requires it. The rubric is already broken out per element in `frq_criteria` (David, 2026-11-12), so this needs no new content: the reason a piece is required is derived from the criterion text and the part's wording, not invented. The prototype's FRQ input already carried these fields; the first-pass failure was the prompt not asking for the reason, not missing data.
10. **Open item:** MCQ coaching can reference the exam skill, but the distractor-to-brief linkage does not exist today (see the labels section), so any "the rubric rewards..." claim on an MCQ must come from the brief's `how_points_are_earned`, not be inferred.

Consequence for the existing numbers: first and second pass quality scores were judged against the old prompt and old judge rubric. Re-run on the same 40 items with the revised prompt, and add judge criteria for "no unsupported claim about the student's reasoning" and "defect and fix both named", before choosing models.

## Judging recipe (frozen 2026-11-12)

The review that gates every coaching text, in the prototype and later in pre-fill. Frozen as a process; model names are refreshed per run (see the checker policy), but the structure and rules below stay.

1. **Two judges from different families, neither a generator of the text.** Current pair: `google/gemini-3.8-flash` and `alibaba/qwen3.8-flash`. Cost about $0.003 and $0.0015 per call.
2. **Replaced: `zai/glm-5.3-flash`.** It returned all-1 scores on texts it also marked factually correct (70 of 437 in pass 2; Gemini and Qwen: near zero). Also tested and rejected: MiniMax m3.1-flash (same fault, 4 of 52), Mistral Large 4 and Mimo v2.6-flash (structured output failed on every call).
3. **Incoherence rule.** Discard any judge record that marks a text factually correct but scores "would help" and "actionable" both 1, and re-run it. Count discards per run and report the rate; a judge above about 2% is replaced.
4. **Timeouts are retried, never dropped.** Per-call cap 120 s, at most 4 parallel batches, up to 3 attempts; a text with no complete judgement from both judges is not scored. (The 2026-11-12 re-score lost 49 of 349 to a 60 s cap under 6 batches: do not repeat.)
5. **Factual flag handling.** A flag from either judge blocks the text. It is regenerated once; if it is flagged again it goes to a human or a third judge. In pass 2, either-judge flagging caught 21 of 330 texts while the two judges agreed on only 5, so requiring both would have let real errors through.
6. **Criteria.** Factual correctness (judges recompute arithmetic), tone and student-state compliance, would help, actionable fix, plus the voice rules: no unsupported claim about the student's reasoning, defect and fix both named, fix kind stated (answer differently / learn first), jargon-free, links to the requirement (FRQ criterion and part; MCQ distractor error), explains why the requirement is needed. For FRQ also faithful to the student's response.
7. **Planted controls every run.** Seven known-wrong texts (4 MCQ, 3 FRQ) go through the same pipeline; a run is invalid unless both judges catch 7 of 7.
8. **Library rule: soft.** There is no approved coaching library yet. Until there is, the grounding set is the item's own authored fields (stem, choices and rationales, rubric criteria, topic explainer, point brief). A claim not supported by those is flagged as `unsupported` for human review and counts against the text in the report, but is not an automatic reject if both judges find it factually correct. Revisit when a library exists: the plan then moves to cited claims checked deterministically.
9. **Known limits.** Gemini scores almost everything 4.9 to 5.0 and separates little; Qwen discriminates more. Scores are not comparable across judge pairs, so any change of pair needs a re-score of the reference set. No human has yet read more than the first packet; the human read is the ground truth for these judges.

## Coaching library v0 (David approved layers 1, 3, 5 on 2026-11-12)

A coaching library is more than facts. Layers considered: (1) command-word and requirement meanings, (2) why each condition or step is needed, (3) error labels per distractor, (4) answer frames, (5) approved example coaching texts, (6) concept and vocabulary snippets, (7) do-not-say list, (8) provenance and versions, (9) gaps register.

**Approved for v0:** 1 (what each command word requires and why a bare conclusion cannot earn it), 3 (error labels on distractors, tied to the skill-labelling work), 5 (human-approved example texts by case: MCQ miss, FRQ partial credit, repeat miss, praise, encouragement; seed from the human-read packet).

**Deferred, with reasons:** 2, 4, 6, 7 grow from the gaps register. Layer 6 is deferred because topic explainers already hold concepts and formulas and a second snippet set would drift from them; the risk is that explainers are too long to cite cleanly. A small audit of Biology and Statistics explainers for citability is part of v0; if explainers cannot be cited, layer 6 moves into v0. Layers 8 and 9 (provenance, gaps register) are needed from the start and cost little.

Until the library exists the soft library rule in the judging recipe applies.

## How we would know it works

- Accuracy: held-out judges and planted defects as in the method test. Coaching must never teach something
  wrong or contradict the rubric.
- Behaviour: next-attempt result on the same cell after coaching versus the T0 floor.
- Cost: cost per 100 MCQ answers, T2 share of misses, cache hit rate, FRQ marginal cost.
- Production has few real students, so early evidence is offline plus pilot users such as Orly; say so rather
  than overclaiming.

## Hard gates and dependencies

- Production changes to `evaluate-attempt` and the feedback card (Hard-Gate).
- A DECISION amending `CONTENT_AND_PEDAGOGY.md` (tone, emoji, model-authored coaching).
- Model-call cost, privacy and provider approval; a recorded cost ceiling.
- Frontend work is in Lovable (`56cae479`), reviewed by commit SHA.
- Layer 3 blocked on O11 and skill labelling.

## Open questions

1. Cost ceiling: per 100 MCQ answers and per active student per day (Phase 2 supplies numbers).
2. How large a share of MCQ misses should be T2 (personal) versus T1 (shared and cached)?
3. Provider, gateway and what student data may be sent; retention.
4. Does an Open Hand "explain more" count toward mastery? Proposal: no, nothing there is scored.
5. Copy for the two encouragement framings, to be generated and checked.
6. FRQ: coaching inside the grading call or a second call?
