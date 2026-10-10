# FRQ gap fill, Units 1-3, all subjects (2026-10-09)

**Goal (Product Owner, David Bloom, 2026-10-09):** "Every unit/topic pair must have 2 FRQs or more. Use the content
creation protocol to create FRQs in any unit/topic with 0 or 1 FRQ. Limit this exercise to units 1-3 in all subjects.
Do not look at any unit 4 or greater." Then, at the pre-run questions: "cut the run to 1 FRQ per subject/unit/topic.
If a unit topic has 1 or more FRQs, do not create another", confirmed: "Do not make FRQs if there is even a single
FRQ in the topic."

**Scope as run:** one FRQ for each of the **126** Units 1-3 topics with zero published FRQs (topic = primary topic cell
on a published version, after APPROVAL-0143). Physics 2 = registry units 9-11; Physics C: E&M = 8-10.
`inputs/slots.json` is the plan (126 rows, `need = 1`); `inputs/slots_all_202_before_scope_cut.json` is the earlier
202-topic / 328-FRQ plan, kept for the record only. The publish step re-checks Production and skips any topic that has
gained an FRQ since.

| Subject | Topics filled |
|---|---|
| AP Biology | 10 |
| AP Calculus AB | 11 |
| AP Calculus BC | 13 |
| AP Chemistry | 18 |
| AP Physics 1 | 8 |
| AP Physics 2 | 14 |
| AP Physics C: E&M | 4 |
| AP Physics C: Mechanics | 11 |
| AP Precalculus | 23 |
| AP Statistics | 14 |

## Protocol and pre-run answers (`CONTENT_AUTHORING_AND_QA_PROTOCOL.md` §2.1, §3.2 rule 3)
- **Author:** `anthropic/claude-opus-5.5` (non-OpenAI, so the model answer is not written by the grader's family, §3.1).
- **Checkers (Product Owner pick, 2026-10-09):** `openai/gpt-6.1-sol` and `deepseek/deepseek-v4-pro`. The OpenAI checker is
  never shown the model answer. Menu offered: GPT-6.1 Sol, DeepSeek V4 Pro, Gemini 3.8 Flash, Muse Spark 1.3; all four
  smoke-tested in `pilot/` (valid structured output on every call).
- **Variants:** none.
- **Publish:** approved in principle, conditional on every check passing and each model answer scoring 100% through the
  production grader (`app.qa_grade_frq`) on an unpublished draft. Human review waived (precedent: Calc AB Unit 1 batch).
  The Hard-Gate approval is recorded in `APPROVALS_LOG.md` before any Production write.
- **Topic labels:** the runbook six-vote probe (gemini-3.8-flash, deepseek-v4-pro, gpt-6.1-sol x2), >= 5 of 6 on the
  target topic, no required unit later than the topic's unit.

## Method (FRQs: protocol §4-§6 and §9; seeded protocol class A for format)
Per topic, up to 3 candidates, each accepted whole or discarded whole (no hand edits; a failing candidate is regenerated):
1. Author against the unit-scoped CED fact pack, the official CED topic text extracted from the course and exam
   description PDFs in `subject packs/` (`inputs/ced_topic_excerpts.json`), the Units 1-3 topic list, and one house-format
   example FRQ per subject (`inputs/seed_items.json`; format only, never content).
2. Deterministic lint (`frq_pipeline/rubric.mjs`): part and point counts per subject, 1 point per criterion, fix <= 25 words,
   no figure/diagram/drawing, no LaTeX/HTML.
3. Deterministic recompute: the author's sympy script, run with an import allowlist in an empty directory.
4. Six-vote topic probe.
5. Both checkers solve blind, then audit scope (§4) and re-derive the rubric against their own solution (§9). A flag counts
   only if it repeats on one re-sample.
6. Planted-defect controls gate the batch (`controls_result.json`): eight known-bad copies of two pilot items; if the pair
   passes any of them, the batch is void.

Tooling: `scripts/vercel-gateway-check/frq_pipeline/` (`frq_pipeline.mjs run|report|controls`, `rubric.mjs`).
Inputs: `prepare_inputs.py` (read-only Production queries). Pilot (11 topics, all four menu checkers, $3.02): `pilot/`.

## Pilot lessons applied to the rubric before the batch
Hard limits stated to the author; fix lines counted to 25 words; accepted variants may not accept a bare value where work
is required; criteria may not prescribe an unrequired method; magnitudes stated as magnitudes; no figure or diagram words.

## Change of method, 2026-10-10 (Product Owner direction)
David Bloom: "I cannot afford to spend another $45 to get 20 questions. That is too expensive and too slow. Where there
are edge cases, you should arbitrate and correct ambiguities. Don't use Opus as primary author - that is your job."
- **Author:** Claude in the working session (parallel sub-sessions, one per subject group, briefs in `briefs/`), not a
  paid gateway model. The gateway is used only for the checks (six-vote topic probe; GPT-6.1 Sol + DeepSeek V4 Pro),
  about $0.10 per item. `frq_pipeline.mjs run ... --no-author` never calls an author model.
- **Arbitration:** Claude decides edge cases (topic overlap, scope, ambiguity) and corrects flagged items directly
  instead of escalating. A corrected item is a new draft and goes through every gate again. Each correction is recorded
  in the slot file (`arbitration` entries).
- **Rulings so far:** Calculus 1.1 vs 2.1 overlap: a 1.1 FRQ uses only average rates over shrinking intervals,
  the zero-length interval point and interpretation (no limit notation or derivative); 2.1 covers difference quotients
  and the limit of a difference quotient without derivative rules or table estimation (2.3). AB 1.1 and AB 2.1 are the
  Product Owner's own drafts, rewritten to those rulings.
- **Spend before this change:** $47.09 for 20 accepted FRQs (see the session discussion: $8.81 lost to checker
  calibration, about $5 to an over-broad lint rule, the rest to a 1-in-8 acceptance rate with a paid author).

## Outcome, 2026-10-10
- **126 of 126** zero-FRQ topics in Units 1-3 have an accepted FRQ: 20 from the paid-author run, 2 Product Owner drafts
  (Calculus AB 1.1 and 2.1, rewritten to their CED topics), 104 authored in session.
- **Checks:** every item passed lint, the exact recompute, the six-vote topic probe (or a recorded CED-text topic
  ruling) and both checkers, except 3 accepted by recorded arbitration after every objection was rejected (Physics 1
  2.2, Precalculus 3.3 and 1.4). Three arbitration rounds; each ruling is in the slot file's `arbitration.log`.
- **Model answers:** 126/126 earn full credit when graded criterion by criterion by a third family
  (`answer_grades.json`, gemini-3.8-flash). The production grader's QA path cannot verify them (published AP Biology only).
- **Rulings worth knowing:** follow-through credit is used for Calculus and Physics (documented in their CED fact packs),
  not for Biology, Chemistry, Precalculus or Statistics. One checker accuracy claim was rejected after recomputation
  (Chemistry 3.12). Topic rulings by CED text: Biology 2.5, Physics 2 11.2, Calculus AB/BC 1.1, Physics 1 2.2, Physics C
  E&M 8.2, Precalculus 1.1, 1.3, 1.4, 3.3, 3.4, Statistics 1.1, 3.4, 3.11.
- **Spend:** $47.09 before the change of method (20 FRQs); $21.24 after it (106 FRQs, checks only, about $0.20 each).
- **Development:** all 126 loaded and published as a content-only copy (`load_dev_content.py`; packs created for the 8
  subjects Development lacked; no unit labels or difficulty, which Development's schema does not have). Verified 126/126.
- **Production:** not written. Preflight shows every target topic still empty; a full rollback rehearsal passes in all
  10 subjects. Publishing needs the Product Owner's Hard-Gate approval.
