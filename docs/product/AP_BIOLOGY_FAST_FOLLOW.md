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
| …of which carry a canonical answer | 71 (was 70; S-101 written 2026-09-24, see FF-4) |
| …of which carry credited-response segmentation | 68 (was 67; S-101's 9 spans added) |
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
| ~~**FF-3**~~ | Unit-gated path dark product-wide (8 items across 10 subjects) | **Mostly CLOSED 2026-09-24 (DECISION-0066)** — promoted 229 existing two-model-agreed serving labels to `validated` across 9 subjects, then caught a real process gap: 26 were multi-unit, which the taxonomy plan's own design reserves for full human validation, not blanket two-model promotion ("no tiebreaker" risk). Reverted those 26, then Claude independently re-reviewed each against the full item content and unit closed list as a third opinion: **22 confirmed** (promoted), **2 genuine over-tags** (safe direction — only delays availability, doesn't show content early) and **2 genuinely unresolved** left at `provisional_model`. Net unit-gated servable: **8 → 141** product-wide (re-measured directly after the revert/re-promote cycle, not carried forward from the earlier 143 estimate). Self-test clean throughout (93/93, 0 mismatch). **The 2 genuine over-tags corrected 2026-09-24**: `apchem-mcq-048` ([5,6,7]→[5]) and `apchem-frq-l-004` ([1,3,4]→[1,4]), via new label versions (append-only history, old versions marked `superseded_by`), verified independently after applying. **Deliberately not corrected**: `APBIO-MCQ-012` and `APBIO-MCQ-041` — both `retired` (not currently servable) and both carry a pre-existing data-quality ambiguity (two non-superseded label rows each), which the work order itself flagged as needing a decision first rather than a guess; `APBIO-MCQ-041` also needs a distractor content edit, held for the same reason. **Still dark: Physics C Mechanics** (0 of 4 candidates fresh) **and Calc BC** (0 of 17 fresh) — need fresh relabeling, not promotion | Claude | Decide how to handle the 2 retired items' duplicate label rows before correcting them; relabel the 2 dark subjects |
| ~~**FF-4**~~ | `APBIO-FRQ-S-101` has no canonical | **CLOSED 2026-09-24** — `20260924210000_apbio_s101_criterion_split.sql` split `a-iv` into `a-iv`/`a-v` (item now 5 points, matching the stem's separate (a)(iii)/(a)(iv)); grader gate cleared 3/3 at 5/5 high-confidence, 0 integrity issues (was 1/3 before the split), confirming M1-B-001's rubric-boundary diagnosis. `20260924220000_apbio_s101_canonical_write.sql` then wrote the same grader-tested text as `canonical_answer_1` plus 9 `canonical_answer_spans` rows (one exclusive span per criterion, verified in-migration and independently re-verified after: reconstruction exact, all 5 criteria covered). Biology FRQ canonical coverage is now 71/71 | Claude | — |
| ~~**FF-5**~~ | `S-021`, `S-023`, `S-058` have no segmentation | **CLOSED 2026-09-24** — migration `20260924230000_apbio_s021_s023_s058_canonical_rewrite.sql` replaced all three `canonical_answer_1` values with Codex's F.2 proposal (rubrics unchanged), cleared `canonical_answer_2` on all three (S-023's b2 clause relocated verbatim as its own exclusive span, not lost), and wrote 7 spans each. Each proposed answer cleared `qa_grade_frq` 3/3 at 4/4, high confidence, 0 integrity issues, before writing. Verified independently after: all three have exact span reconstruction, `canonical_answer_2` null, 4/4 criteria with exclusive spans | Claude | — |
| ~~**FF-6**~~ | 0 of 118 items carry a difficulty value | **CLOSED 2026-09-24** — loaded Codex's J.0 resume proposal into `app.content_item_difficulty` (first data load into this table; it was created empty by M3). 118/118 rows: 81 `calibrated_task_verb` (71 with a computed `attainment_ratio`, 10 with the band only — verb unresolved after two-model CRR disagreement) + 37 `calibrated_judgement` (ratio null by design). Difficulty band itself is unchanged (75 Medium/23 Easy/20 Hard, reproducing the prior committed bands with zero drift). Verified before writing: hand-checked one item's verb-ratio aggregation by hand (exact match) and confirmed rubric/band partitioning; verified after: exact row/band/basis counts, 0 rows outside published Biology items | Claude | — |
| **FF-7** | 43 short FRQ have no serving label | **None on this path**; blocks FF-3 | Codex (work order N) | In queue |
| **FF-8** | 5 MCQ serving labels QA rejected | None on this path; blocks FF-3 | Codex (work order N.1) | In queue |
| **FF-9** | Topic labels are `provisional_model` | None on serving; blocks coverage reporting (T8) | — | **Remeasured 2026-09-24 (Codex work order), DECISION-0067 stands.** Fixing the subject-key normalization bug (hyphens vs underscores) that broke topic-explainer retrieval did NOT improve agreement — it measured 28.9% in this packet, worse than the original 44%. Byproduct: that same namespace bug affects topic-explainer retrieval for all 10 subjects, not just Bio/Stats, worth knowing for any future topic-labeling run. No further action pending a genuinely fresh, fully independent re-run |
| **FF-10** | 3 hand-drawn items score nothing | Low — dispositioned under D5 | — | Engine 4 spatial verifier |
| ~~**FF-11**~~ | Grader gate unreachable for 65 items | **CLOSED 2026-09-24** — deployed to Production (`evaluate-attempt` v60) via the Supabase CLI and verified live: called `app.qa_grade_frq` against `APBIO-FRQ-S-102` (a real canonical-bearing item, 1412-char `canonical_answer_1`) with a deliberately weak answer; it graded (0/4, sensible per-criterion feedback) instead of refusing with `canonical_answer_already_present`, and all seven persistence flags were `false`. Found en route: `evaluate-attempt/index.ts` in the repo was 322 lines behind what Production actually ran -- the entire `qa_no_persist` QA-grading subsystem (added directly to Production 2026-09-22) was undocumented and untracked in git, confirming F-QA-003. Reconciled the repo file to match deployed Production exactly, restored the DI-testable `handleEvaluateAttempt` export the live hotfix had dropped (deployed used a bare `Deno.serve` closure, which is why `index_test.ts` only had 1 test), then removed the guard -- it added no security (already gated by `verify_qa_grader_token`) and `canonical_answer_1/2` were read only for that check, never fed into the prompt or response. **Deploy mistake caught and fixed same-turn:** the first CLI deploy used `--no-verify-jwt`, which silently flipped the function's `verify_jwt` from `true` to `false`; caught via `list_edge_functions`, redeployed without the flag, confirmed `verify_jwt: true` restored on v60 (same code hash as the erroneous v59, only the JWT setting changed). 2 tests passing (1 new), `deno check` clean | Claude | — |
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
