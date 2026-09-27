# Codex Overnight Run Protocol — 2026-09-22

Governs the unattended execution of work orders A, B, C and D on the night of 2026-09-22.
Answers the three clarifications Codex raised before starting. **This file overrides any
conflicting instruction in an individual work order.**

Work orders:
- A `CODEX_WORK_ORDER_A_APBIO_CANONICAL_RECOVERY_2026_09_22.md`
- B `CODEX_WORK_ORDER_B_APSTATS_CANONICAL_ANSWERS_2026_09_22.md`
- C `CODEX_WORK_ORDER_C_APSTATS_SEGMENTATION_2026_09_22.md`
- D `CODEX_WORK_ORDER_D_CALCAB_CHEM_TOPIC_LABELS_2026_09_22.md`

---

## 1. Count mismatches — do not halt the night, but distinguish two cases

Codex proposed: stop only the affected work order's proposal stage, produce its packet plus an
honest discrepancy report, then continue to the next work order. **That is approved in
principle, with one refinement — not every mismatch is equally serious.**

**Case A — the premise still holds.** The in-scope set differs from the work order by **10% or
less** and the task still makes sense (e.g. A finds 40 rubric-split items instead of 41; D finds
104 recoverable codes instead of 106). **Proceed with the observed set.** Do not halt. Record the
delta prominently in `open_questions.csv` and in `SUMMARY.md`, stating the work order's number,
your observed number, and the exact `WHERE` behind yours. Working from live state is correct;
silently working from live state is not.

**Case B — the premise is invalid.** The in-scope set differs by **more than 10%**, or a required
input is missing entirely (the closed list returns no rows; a named parent version is absent; the
published count has moved materially). **Produce the packet and a discrepancy report only, skip
that work order's proposal stage, and move to the next work order.** Do not attempt to proceed on
a foundation you have just shown to be wrong.

In both cases: continue to the next work order. Do not wake anyone.

## 2. Pre-existing artifacts — back up, never overwrite

**Approved as Codex proposed.** If an output directory already contains a non-QA artifact at a
required filename, move it aside to `<name>.<UTC timestamp>.bak` and write the new run to the
canonical filename. Record every backup you made in `SUMMARY.md`.

Three absolute constraints:

1. **Never create, edit, move or back up `qa_findings.csv` or `qa_report.md`.** Those belong to
   the QA model. If one exists, leave it exactly as it is.
2. **Never write into another work order's directory.** Each run owns exactly one directory.
3. **These two directories are prior records and must not be modified at all** — not edited, not
   backed up, not reorganised:
   - `docs/research/apbio_frq_segmentation_2026_09_22/`
   - `docs/research/bio_stats_topic_tagging_2026_09_22/`

   Read them freely. Both are named as source material. Neither is yours to change.

All four target directories should be new tonight, so this should not arise on a first run. It
matters if a work order is re-run.

## 3. Commit and push to a branch — do NOT leave the work uncommitted

**This overrides Codex's stated default.** Uncommitted output on one machine is not durable, and
this project has been bitten by exactly that: a set of 29 migrations whose content is live in
Production sat only in a local checkout for a month, and was committed only today. The
Synchronization Rule in `docs/README.md` is explicit that local-only work is not a durable record.

**Required behaviour:**

1. Work on a single branch for the night: **`codex/overnight-2026-09-22`**, created from current
   `main`.
2. **Commit after each work order completes**, one commit per work order, message naming the work
   order and the headline result (e.g. `Work order A: recover 118 drafted Biology criteria -> N
   recovered, M still drafted`).
3. **Push after each commit.** If the machine dies at 3am, everything up to the last completed
   work order survives.
4. **Do not open a pull request. Do not merge to `main`.** These are unratified proposals; they
   land on a branch and wait for QA and Product Owner approval under DECISION-0055.
5. Commit **only** the artifacts the work orders specify, under `docs/research/`. Do not commit
   scratch files, caches, credentials, or anything outside your four directories. If a `.bak` file
   was created under §2, commit it too — it is part of the record.
6. End commit messages with the attribution line this repository uses for agent commits.

If a push fails, retry once, then record the failure in `SUMMARY.md` and continue — but say so
loudly, because it means the work is not yet durable.

## 4. Judgement calls — all five confirmed, two with a refinement

Codex listed five judgement calls it is prepared to make unsupervised. **All five are correct.**
Two carry a refinement:

**4.1 A's "71 in-scope" — confirmed, with a permitted shortcut.** Segment all 71 non-graph Biology
FRQ; concentrate recovery analysis on the 41 rubric-split items plus `S-101/102/103`. The 71/71
concatenation invariant exists so the artifact is self-contained and QA can check it as one unit.

Refinement: for items where recovery changes nothing and the prior run
(`apbio_frq_segmentation_2026_09_22/`) already produced a clean segmentation, you **may reuse its
spans verbatim** rather than re-deriving them. If you do, set `provenance='unchanged_from_prior_run'`
on those spans and report the count in `SUMMARY.md`. This is a legitimate use of the night's
budget. It is not permission to skip the invariant — those items must still appear, still
concatenate exactly, and still be checkable.

**4.2 B and C disjoint with independent snapshots — confirmed, with one addition.** Record in each
`SUMMARY.md` the **maximum `version_num` observed per item** and the UTC time the snapshot was
taken. B and C both cover AP Statistics FRQ from separate snapshots taken hours apart; nothing
should change between them, and these two fields are what let QA prove it rather than assume it.

**4.3 Flag rather than paraphrase (Biology recovery)** — confirmed. Recovered text must be
verbatim; ambiguity is a finding, not something to smooth over.

**4.4 Flag rather than invent (Statistics arithmetic)** — confirmed, and this is the single most
important discipline in work order B. An unverifiable value that is flagged costs a reviewer two
minutes. An invented one that looks plausible can reach a student.

**4.5 Adjacent-topic ties in D** — confirmed: follow the rubric's assessed skill, retain the
runner-up in `alternative_topic_code`, set `needs_human=true`, move on. Do not spend the night on
ties.

## 5. Sequencing

A → B → C → D, serially, as Codex proposed. B is by far the heaviest (46 authored answers, 20 of
them at 10 criteria each, every numeric result independently derived).

**If the night runs short, D is the one to drop.** It serves breadth across two other subjects;
A, B and C serve Biology and Statistics launch readiness, which is the goal. Dropping D entirely
and reporting that honestly is a better outcome than four half-finished runs.

Within D, if it starts but cannot finish: **complete AP Chemistry before AP Calculus AB.**
Chemistry has the larger recoverable fraction (86 of 119 versus 20 of 122) and therefore the
better return per hour.

## 6. What happens in the morning

Every artifact produced tonight is a **proposal**. None of it serves students, and none of it is
written to Production. The DECISION-0055 gate is: AI build (tonight) → independent AI cross-model
QA (a different model, in the morning) → Product Owner approval.

Codex does not QA its own output. That includes tonight's four runs and the earlier
`bio_stats_topic_tagging_2026_09_22/` run, which is also still awaiting independent QA.
