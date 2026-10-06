# TASK-0065 — Generate Open Hand Teaching Questions (One per Topic, Never Scored)

**Status:** In progress — checker pilot (Biology) done 2026-10-06; two checker-policy questions open before the full batch  
**Tier:** Standard for authoring in Development; Hard-Gate for Production publish and designation  
**Owner:** Claude (named by David, 2026-10-06)  
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

## Progress — 2026-10-06 (checker pilot)

David's direction: Claude owns the task; build and prove the checkers on a small Biology pilot first;
an item fails a check if **either** checker flags it.

Pilot: 5 clean items (topics 1.1, 2.5, 3.1, 5.3, 7.5) plus 4 controls with one planted defect each.
Full report: `scripts/content-seed/task0065-bio-pilot-2026-10-06/PILOT_REPORT.md`. New tooling:
`scripts/vercel-gateway-check/teaching_item_check.mjs` (C3 named-trap audit, C6 habit lines) and the
pilot's `lint.py`. Nothing written to any database.

- All 4 planted defects were caught by the intended check, by both checkers, in both rounds.
- After one patch round, 2 of 5 clean items pass (3.1, 7.5). The checkers found real defects in the
  rest. 2.5 is dropped because of a 2.5/2.8 topic overlap.
- Open before the full batch: (1) C6 "brief core covered" vs "pairs with item", which pull against
  each other; (2) give the topic probe the CED text, not just titles; (3) scope: Production has 61
  Biology topic briefs, not 27.
