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
| **MCQ reachable on this path** | **0 of 43** |

### Two things about that table that are not obvious

**The practice path serves FRQ only.** `select_practice_frqs` filters `item_type = 'frq'`. Biology's
43 published MCQ are unreachable through it. They can only be served by the unit-gated path (dark —
see FF-3) or by `select_confirm_transfer_item`, which is a parallel-item flow requiring a source
item, not a general queue.

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
| **FF-1** | 43 MCQ unreachable | **High** — a third of Biology's corpus is invisible | — | Needs a decision: MCQ practice path, or FF-3 |
| **FF-2** | `full_exam_frq` returns 0 | **High if exposed** — an empty session is worse than an absent feature | — | Verify whether any surface offers it |
| **FF-3** | Unit-gated path dark product-wide (8 items across 10 subjects) | **High, strategic** | — | Promotion of serving labels to `validated` — the T9 vs DECISION-0055 question |
| **FF-4** | `APBIO-FRQ-S-101` has no canonical | Medium — one item missing from 71 | Codex after decision | Product Owner rubric call: criterion `a-iv` spans two stem sub-parts |
| **FF-5** | `S-021`, `S-023`, `S-058` have no segmentation | Medium — Open Hand cannot strike on them | Product Owner | Call on whether drafting over published text is acceptable |
| **FF-6** | 0 of 118 items carry a difficulty value | Medium — no difficulty targeting is possible | Codex (J.0) | In queue |
| **FF-7** | 43 short FRQ have no serving label | **None on this path**; blocks FF-3 | Codex (work order N) | In queue |
| **FF-8** | 5 MCQ serving labels QA rejected | None on this path; blocks FF-3 | Codex (work order N.1) | In queue |
| **FF-9** | Topic labels are `provisional_model` | None on serving; blocks coverage reporting (T8) | Product Owner | DECISION-0062's deferred question |
| **FF-10** | 3 hand-drawn items score nothing | Low — dispositioned under D5 | — | Engine 4 spatial verifier |
| **FF-11** | Grader gate unreachable for 65 items | Low now, high before any claim about canonical quality | — | Widening `evaluate-attempt`'s `canonical_answer_already_present` guard |
| **FF-12** | `servable_items_check.py` runs only by hand | Medium — it exists precisely because silent failures went six weeks unnoticed | — | Scheduling it |
| **FF-13** | `mcq_choices.is_correct` readable by authenticated users | **Becomes High the moment FF-1 lands** | Product Owner | Held for your go (PR #103-style revoke) |
| **FF-14** | `content_hash` stale on edited items | Low — nothing verifies it at grade time | — | Would need the intake payload stored |

---

## Notes that change how some of these should be read

**FF-1 and FF-13 are coupled.** Making MCQ reachable without first closing the answer-key exposure
would put 43 items in front of students whose `is_correct` and `rationale` any authenticated user
can already read. FF-13 should land first or at the same time, not after.

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
permanent limitations, and FF-12 is running unattended. FF-7 through FF-9 belong to the unit-gated
path and should be tracked against FF-3 rather than against launch.

## Related

- `docs/product/AP_BIOLOGY_LAUNCH_READINESS_2026_09_24.md` — the six-condition assessment, including
  the correction to its own servable figures
- `docs/research/servable_items_baseline.json` — per-subject baseline the check diffs against
- `docs/research/apbio_mcq_serving_label_qa_2026_09_24/qa_report.md` — the MCQ label QA and
  finding MCQ-QA-001
- `prompts/CODEX_WORK_ORDER_N_BIOLOGY_SERVING_LABELS_2026_09_24.md` — work orders N and N.1
