# AP Biology — Launch Decision and Fast-Follow Tracker

**Launch path: PRACTICE** (`select_practice_frqs`), decided by the Product Owner 2026-09-24.
**Status: live tracker.** Update it as items close; do not let it become a snapshot.

Every figure here was measured against Production by calling the live serving functions, not by
modelling them. Re-measure with `scripts/qa/servable_items_check.py` rather than trusting this table
once it is more than a few days old.

---

## What ships on day one

| | Count |
| --- | ---: |
| `targeted_drill` FRQ a student can be served | **71** |
| …of which carry a canonical answer | 70 |
| …of which carry credited-response segmentation | 67 |
| `full_exam_frq` items | **0** |
| Hand-drawn pilot items | 1 (`GRAPH-002`) |
| **MCQ reachable on this path** | **43 of 43** (FF-1, closed 2026-09-24) |

### Two things about that table that are not obvious

**The practice path now serves a Biology-scoped FRQ+MCQ mix.** Until FF-1, `select_practice_frqs`
filtered `item_type = 'frq'` and Biology's 43 published MCQ were unreachable through it. As of
2026-09-24, a Biology `targeted_drill` session instead calls the new
`app.select_biology_practice_items`, which serves both: at today's pool (71 eligible FRQ, 43 MCQ) a
20-item request returns 12 FRQ + 8 MCQ, interleaved and session-stable. Every other subject still
calls `select_practice_frqs` unchanged. `select_confirm_transfer_item` (a parallel-item flow
requiring a source item, not a general queue) and the unit-gated path (dark — see FF-3) are
unaffected.

**`full_exam_frq` returns zero items.** If any surface offers a full-exam Biology session, it will
return an empty queue. `student-session-items` answers `session_practice_format_unset` when the
format is missing, but a *set* format with no matching content simply returns nothing.

**Why the practice path is a sound launch choice anyway:** it does not depend on the taxonomy label
layer at all. None of the label breakage found on 2026-09-24 — the August republish that silently
stripped 20 MCQ, M1 dropping 28 more, the zero validated labels — can affect it. It is the one
serving path in the product that is not currently fragile.

---

## Fast-follow, ranked

Rank is by student impact on the chosen path, not by effort.

| ID | Item | Impact | Owner | Blocked on |
| --- | --- | --- | --- | --- |
| ~~**FF-1**~~ | 43 MCQ unreachable | **CLOSED 2026-09-24** — a Biology-scoped combined selector (`app.select_biology_practice_items`) now serves both FRQ and MCQ on `targeted_drill`; verified live with a real-student-token probe (12 FRQ + 8 MCQ served, no answer-key leak by any path, correct/incorrect MCQ graded 1/1 and 0/1 via `rule-based-mcq`) | Codex, QA'd and applied by Claude | — |
| ~~**FF-2**~~ | `full_exam_frq` returns 0 | **Downgraded to Low** — verified 2026-09-24: the API accepts the format but **no session has ever used it** (117 sessions, all time). Not a day-one risk; one frontend toggle from being one | — | — |
| ~~**FF-3**~~ | Unit-gated path dark product-wide (8 items across 10 subjects) | **Mostly CLOSED 2026-09-24 (DECISION-0066)** — promoted 229 existing two-model-agreed serving labels to `validated` across 9 subjects, then caught a real process gap: 26 were multi-unit, which the taxonomy plan's own design reserves for full human validation, not blanket two-model promotion ("no tiebreaker" risk). Reverted those 26, then Claude independently re-reviewed each against the full item content and unit closed list as a third opinion: **22 confirmed** (promoted), **2 genuine over-tags** (safe direction — only delays availability, doesn't show content early) and **2 genuinely unresolved** left at `provisional_model` pending `prompts/CODEX_WORK_ORDER_UNIT_TAG_DISTRACTOR_REPAIR_2026_09_24.md`. Net unit-gated servable: **8 → 141** product-wide (re-measured directly after the revert/re-promote cycle, not carried forward from the earlier 143 estimate). Self-test clean throughout (93/93, 0 mismatch). **Still dark: Physics C Mechanics** (0 of 4 candidates fresh) **and Calc BC** (0 of 17 fresh) — need fresh relabeling, not promotion | Claude (executed + tiebreak review); Codex (2 remaining ambiguous items + relabeling the 2 dark subjects) | — |
| **FF-4** | `APBIO-FRQ-S-101` has no canonical | Medium — one item missing from 71 | Codex (work order F.2) | **Decided 2026-09-24 (DECISION-0064)** — split criterion `a-iv` into two; in queue |
| **FF-5** | `S-021`, `S-023`, `S-058` have no segmentation | Medium — Open Hand cannot strike on them; re-verified 2026-09-24 that `S-021`/`S-058` are worse than "no spans" — their stored answers don't answer their own rubric | Codex (work order F.2) | **Decided 2026-09-24 (DECISION-0064)** — rewriting authorized; in queue |
| **FF-6** | 0 of 118 items carry a difficulty value | Medium — no difficulty targeting is possible | Codex (J.0 resume) | **Decided 2026-09-24 (DECISION-0065)** — AI cross-model verb verification scoped to exactly 87 CRR rows, same-tier borrowing for the 8 verbs with zero CRR presence, mean aggregation, non-overlapping cut points. Work order in queue |
| **FF-7** | 43 short FRQ have no serving label | **None on this path**; blocks FF-3 | Codex (work order N) | In queue |
| **FF-8** | 5 MCQ serving labels QA rejected | None on this path; blocks FF-3 | Codex (work order N.1) | In queue |
| **FF-9** | Topic labels are `provisional_model` | None on serving; blocks coverage reporting (T8) | — | **Decided 2026-09-24 (DECISION-0067)** — stays deferred, zero live cost (nothing reads `assessed_topics`); revisit only when coverage reporting is prioritized. Researching whether better sources could raise the 44% two-model agreement rate before that revisit |
| **FF-10** | 3 hand-drawn items score nothing | Low — dispositioned under D5 | — | Engine 4 spatial verifier |
| **FF-11** | Grader gate unreachable for 65 items | Low now, high before any claim about canonical quality | — | Widening `evaluate-attempt`'s `canonical_answer_already_present` guard |
| ~~**FF-15**~~ | An empty item queue reports `status: ok, items: []` with no reason — indistinguishable from "you finished everything" | **CLOSED 2026-09-24** — the ordinary-queue response (all three modes: `frq_only`, `unit_gated`, `hand_drawn_pilot`, which all funnel through the same response block) now always carries `result.reason`: `null` when items are present, `"no_matching_content"` when the selector RPC returned nothing, `"all_items_omitted"` when it returned candidates but the media/answerability gates withheld all of them (detail remains in `omitted`). `session_practice_format_unset` and confirm-transfer's `no_parallel_item` already had reasons and are unchanged. Covered by 2 new tests in `index_test.ts`, 14/14 passing | Claude | — |
| ~~**FF-12**~~ | `servable_items_check.py` runs only by hand | **CLOSED 2026-09-24** — `.github/workflows/servable-items-check.yml` runs it daily (09:00 UTC) + on demand via `workflow_dispatch`, against Production with a dedicated least-privilege role (`ci_servable_items_reader`: `USAGE` on schema `app` and `EXECUTE` on exactly the two census functions, nothing else). Verified with a real triggered run: self-test 93 ok / 0 MISMATCH, census `PASS` against baseline | Claude | — |
| ~~**FF-13**~~ | `mcq_choices.is_correct` readable by authenticated users | **CLOSED** — verified 2026-09-24. All three parts of the coordinated fix are live; column grants expose `choice_text` and block `is_correct`/`rationale`. **FF-1 is not gated on it** | — | — |
| **FF-14** | `content_hash` stale on edited items | Low — nothing verifies it at grade time | — | Would need the intake payload stored |

---

## Notes that change how some of these should be read

**FF-1 and FF-13 were said to be coupled. They were not, and both are now closed.** That coupling
claim rested on a memory note from 2026-08-24 describing a live exposure. Verified 2026-09-24: all
three parts of the coordinated fix are live, `authenticated` can read `choice_text` but is denied
`is_correct` and `rationale`, and `anon` is denied everything. The mechanism is column-level
grants — serve the choices, withhold the key. Details and the methodological trap that produced the
wrong first reading are in `docs/research/ff2_ff13_verification_2026_09_24/`. FF-1 itself closed the
same day: design in `docs/research/ff1_mcq_serving_design_2026_09_24.md`, implementation in
migration `20260924200000_ff1_biology_combined_practice_selector.sql` and
`supabase/functions/student-session-items/index.ts`.

**FF-7 and FF-8 do nothing for launch.** They are the largest in-flight work and they change zero
items on the practice path, because that path ignores taxonomy labels. They matter for FF-3. Worth
being explicit so their completion is not mistaken for launch progress.

**FF-12 is the one that prevents repeats.** Three silent serving failures were found by hand on
2026-09-24, one of which had been live for six weeks and one of which was introduced that morning.
The check now exists and self-verifies against the real RPCs; what it lacks is a trigger. Until it
runs on a schedule, the next silent drop is found the same way — by someone happening to count.

---

## Definition of done for this tracker

Biology's fast-follow is complete when FF-1 through FF-6 are closed or explicitly accepted as
permanent limitations, and FF-12 is running unattended. FF-1, FF-2, and FF-13 are closed as of
2026-09-24. FF-7 through FF-9 belong to the unit-gated path and should be tracked against FF-3
rather than against launch.

## Related

- `docs/product/AP_BIOLOGY_LAUNCH_READINESS_2026_09_24.md` — the six-condition assessment, including
  the correction to its own servable figures
- `docs/research/servable_items_baseline.json` — per-subject baseline the check diffs against
- `docs/research/apbio_mcq_serving_label_qa_2026_09_24/qa_report.md` — the MCQ label QA and
  finding MCQ-QA-001
- `prompts/CODEX_WORK_ORDER_N_BIOLOGY_SERVING_LABELS_2026_09_24.md` — work orders N and N.1
