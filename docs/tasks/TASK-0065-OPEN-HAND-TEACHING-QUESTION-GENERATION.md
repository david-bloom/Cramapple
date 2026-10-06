# TASK-0065 — Generate Open Hand Teaching Questions (One per Topic, Never Scored)

**Status:** In progress — authoring (Claude session, 2026-10-06)  
**Tier:** Standard for authoring in Development; Hard-Gate for Production publish and designation  
**Owner:** Claude session (authoring); outside-family checkers via AI Gateway  
**Product Owner:** David Bloom  
**Date opened:** 2026-10-06  
**Parent:** `TASK-0064` (teaching pool), `DECISION-0087` ("reserved teaching pool")

## Why

Open Hand now shows everything on load and draws only from `app.open_hand_teaching_items`, which are
never scored. On 2026-10-06, 95 topics lent one scored MCQ as a stopgap. Thin topics, including 25 of
27 Biology topics, have no Open Hand question at all. Generated teaching questions fill every topic
and let the borrowed items return to scoring.

## Scope

One teaching MCQ per topic for every active subject: about 214 topics, minus any topic that already
has a generated item. Priority order:
1. AP Biology and AP Statistics, the day-1 subjects
2. AP Chemistry
3. the rest by active-student count

## Item standard (from `docs/new_design/CONTENT_AND_PEDAGOGY.md`)

- The question sits squarely on the topic and is answerable from that topic's content. Its primary
  topic label must match the designated topic.
- Four choices with exactly one correct.
- **Every distractor is a named trap.** Its rationale says (a) why it tempts and (b) the one-line fix.
  The correct choice's rationale explains *why* it earns the point, never just "Credited."
- The stem never repeats the choices inline.
- How points are earned and how points are lost: three short habit lines each, consistent with the
  topic's point brief.
- No calculator-only or figure-dependent items unless the asset ships with the item.
- Validated before publish by the same model-consensus labeling and checker policy as other generated
  items (`DECISION-0085` / `DECISION-0093` pattern). Human spot-check per subject before the first
  publish.

## Delivery

- Load as drafts in Development, validate, then publish in Production on David's approval.
- For each published item, insert a row into `app.open_hand_teaching_items` with
  `source = 'generated'` for its topic, and set `released_at = now()` on that topic's `spare` row,
  which returns the borrowed item to scoring. `get_open_hand_teaching_item` already prefers
  `generated` over `spare`.
- Report per subject: topics covered, items rejected by the checker and why, spares released.

## Verification

- [ ] Each generated item passes the item standard; a sample is human-checked per subject.
- [ ] After designation, each topic's RPC call returns the generated item, and the released spare is
      served again by the selectors.
- [ ] 0 generated teaching items are served by any scored selector (same 30-seed check as TASK-0064).

## Scope decision — 2026-10-06 (David)

"Do bio, stats, chemistry and calc AB." Other subjects wait until they have real students; the QA-round
frontend routes a topic with no worked example to Practice and finds the nearest worked example.

Gap measured in Production against published topic point briefs (the topics a student can land on):
Biology 58, Statistics 41, Chemistry 84, Calc AB 69, for **252 items**. The earlier "~214 for every subject"
estimate undercounted, because it used topics with scored content rather than every brief.

Batch directory: `docs/research/open_hand_teaching_batch_2026_10_06/` (`AUTHORING_SPEC.md`,
`FACT_PACK_QUERY.sql`). Habit lines come from each topic's point brief on screen, so items carry stem,
choices and per-choice rationales only.

**Blocked:** the two outside-family checker stages (DECISION-0093). `ai-gateway.vercel.sh` is denied by
this environment's network policy, and no `AI_GATEWAY_API_KEY` is set. No item is loaded until both
checkers have cleared it.
