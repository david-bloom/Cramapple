# TASK-0064 — Open Hand Teaching Pool: Show Everything, Never Scored

**Status:** In progress — Development backend built and verified (2026-10-06); edge-function deploy and Lovable front end pending  
**Tier:** Hard-Gate (schema, serving-path and Production changes)  
**Owner:** Claude (backend + Lovable wiring); content generation → content-pipeline owner  
**Product Owner:** David Bloom  
**Date opened:** 2026-10-06  
**Related:** `DECISION-0087` (its "Left open: reserved teaching pool" is resolved here), `DECISION-0086`, `DECISION-0074`, `TASK-0051`, `TASK-0052`, `docs/new_design/CONTENT_AND_PEDAGOGY.md` ("Open Hand is a teaching method — it shows everything")

## Why

On 2026-10-06 David reviewed live Open Hand and rejected it. It hid the answer behind a "Show the
worked answer" gate, and it served thin items from the scored assessment pool (e.g.
`apchem-mcq-058`, whose credited choice's rationale is just "Credited."). The design spec says Open
Hand shows everything on load: answer key, rubric, how points are earned and lost, reference pane,
deep dive.

The gate existed because every disclosed key removes that item from the student's scored pool
(`DECISION-0087`). Showing everything from the scored pool is not safe, as measured in Production on
2026-10-06 (published MCQs on active, non-retired packs, primary topic label):

| Subject | Topics | MCQs | Topics with ≥5 MCQs and a fully explained item |
|---|---|---|---|
| Biology | 27 | 58 | 2 |
| Chemistry | 18 | 97 | 7 |
| Statistics | 33 | 224 | 14 |
| Calculus AB / BC | 20 / 32 | 145 / 297 | 12 / 24 |
| Physics 1 / 2 / C:EM / C:Mech | 16 / 15 / 10 / 10 | 119 / 72 / 87 / 65 | 10 / 4 / 4 / 4 |
| Precalculus | 33 | 194 | 14 |

About 97 of 214 topics can spare one question. In Biology, one Open Hand view from the scored pool
leaves a topic with too few MCQs to meet `DECISION-0074`'s 2-correct-MCQ mastery bar.

## Decision (David, 2026-10-06): generate plus spare

1. **Teaching items are a separate pool and are never scored.** Open Hand shows only teaching items,
   with everything face-up on load and no gate.
2. **Interim spare pool.** In each topic with at least 5 published MCQs, designate one item as
   teaching. It must have ≥4 choices, a rationale of at least 25 characters on every choice, and no
   choices repeated inline in the stem. Remove it from every scored serving path.
3. **Generated pool.** Commission one never-scored, fully explained teaching question per topic
   (~214) from the content pipeline. Generated items replace spare items, which then return to the
   scored pool.
4. **Topics with no teaching item yet** show the reference pane and deep dive with "A worked example
   for this topic is coming soon." They never fall back to a scored item.

## Build plan

**Backend (Development first):**
- New table `app.open_hand_teaching_items (content_item_id pk, subject_id, topic_code, source
  ('spare'|'generated'), designated_at, released_at)`. RLS forced; service-role read.
- Add an exclusion predicate to every scored selector, following
  `20260923150000_exclude_hand_drawn_from_text_serving.sql`: `student-session-items`, the unit-gated
  and combined practice selectors, `get_home_start_queue`, the confirm-transfer selector, and the
  servable-items census. Enumerate them by search before writing the migration.
- New RPC `public.get_open_hand_teaching_item(p_subject_key, p_topic_code)`, entitlement-scoped like
  `get_open_hand_item`. It returns prompt plus full key for the topic's teaching item, or null. It
  writes no exclusion row because teaching items are never scored. `evaluate-attempt` rejects
  attempts on teaching items.
- A designation script picks the spare item per topic deterministically (best rationale coverage,
  then oldest), and its output is reviewed before applying.

**Front end (Lovable, behind the plate-loop flag, which stays OFF):**
- Open Hand calls the teaching RPC for the student's subject and topic and renders everything on
  load. Remove the face-down gate and consent line.
- Remove the scored-pool list path from Open Hand entirely.
- Fix "Loading topic notes" hanging forever: a query disabled for missing unit context must show the
  empty state, not loading.
- Keep round-2 fixes (active subject label, no internal IDs, guide-backed reference and deep dive,
  layout).

**Content:** a work order to the content pipeline for ~214 teaching MCQs, one per topic. Every
distractor carries why it tempts plus a one-line fix (pedagogy rule). Validated before publish.

## Verification

- [ ] Count of designated spare items per subject recorded; each verified absent from every scored
      selector (SQL per selector).
- [ ] `get_open_hand_teaching_item`: unentitled refused, entitled served with full key, no exclusion
      row written, null for a topic with no teaching item.
- [ ] `evaluate-attempt` rejects a teaching item.
- [ ] Open Hand shows everything on load; the topic with no item shows notes, deep dive and the
      coming-soon line; nothing hangs on "Loading".
- [ ] Desktop and 390px walkthrough by David in the preview before the plate loop is turned on.
- [ ] Fresh independent QA (Fable) of Open Hand plus the serving exclusions.
- [ ] Production: migration, function deploys and designation applied on David's explicit approval.

## Progress — 2026-10-06

**Development (`wmgjsdkphcyhngaffbqf`), applied and verified:**
- Migration `20261006004005_open_hand_teaching_pool.sql` adds three things: the table
  `app.open_hand_teaching_items`, the RPC `public.get_open_hand_teaching_item(subject_key, topic_code)`,
  and a backstop trigger `trg_refuse_attempt_on_teaching_item` on `app.attempts`. The file name
  matches Development's recorded version.
- Verified with every write rolled back:
  - anonymous call → `not_authenticated`
  - unentitled user → `open_hand:entitlement_required`
  - entitled student → full key returned (4 choices, `is_correct` present, topic title)
  - topic with no teaching item → `null`
  - inserting an attempt on a teaching item → refused `open_hand_item_not_scorable`
- Development content fails the 25-character rationale bar, so the real selection returns nothing
  there. Three Statistics items (topics 1.5, 1.6, 1.9) are designated as **Dev test fixtures**, marked
  in `note`.

**Serving filter (repo, not yet deployed):** `dropTeachingItems` is in
`_shared/student-item-delivery.ts`, and `student-session-items` calls it before the exclusion
annotation. It covers every serving mode because every mode funnels through that one point. It
fails closed with a 500 if the lookup errors. Tests: shared delivery 46/46 (3 new), serving 32/32
(1 new: cell_scoped never serves a teaching item). Typecheck shows no new errors. Run locally with
stand-ins for `deno.land`, `jsr:` and `esm.sh`, which this sandbox cannot reach.

**Grading:** `evaluate-attempt` is not changed. The trigger blocks any attempt on a teaching item at
the database, so grading never sees one. A by-hand redeploy of that function (24 files, ~8.8k lines)
was judged riskier than the trigger.

**Production selection (read-only dry run, 2026-10-06):** 97 items, one per eligible topic, from
`scripts/task0064/select_spare_teaching_items.sql`. The query is deterministic: re-run it at apply
time and review the output then. Per subject:

| Subject | Spare items |
|---|---|
| Calc AB | 12 |
| Calc BC | 24 |
| Chemistry | 7 |
| Physics 1 | 10 |
| Physics 2 | 4 |
| Physics C: E&M | 4 |
| Physics C: Mech | 4 |
| Precalculus | 14 |
| Statistics | 14 |
| Biology | 2 |

**Blocker for end-to-end testing:** the Lovable app, preview included, talks to **Production**
Supabase. Open Hand cannot be exercised against Development. Production order, each step on David's
approval:
1. Apply the migration. It is inert with zero designations: the trigger matches nothing and the RPC
   returns null.
2. Deploy `student-session-items` with the filter. This must happen BEFORE any designation, or live
   students could be served a teaching item that the trigger then refuses on submit.
3. Designate the 97 spare items.
4. Lovable switches Open Hand to the teaching RPC and David reviews in the preview with the plate
   loop still off.

**Edge deploy:** this sandbox cannot reach the Supabase Management API. Deploy from a machine with the
Supabase CLI:
`supabase functions deploy student-session-items --project-ref <ref>`, Development first.
