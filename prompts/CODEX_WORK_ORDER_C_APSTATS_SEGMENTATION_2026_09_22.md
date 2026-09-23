# Codex Work Order C — AP Statistics Criterion Segmentation (existing answers only)

DATE: 2026-09-22 | SUBJECT: AP Statistics (`ap-statistics`) | RUNS: overnight, unattended
MODE: **Proposal only. Read-only against Production. No writes to published content, ever.**

> **Run protocol:** `CODEX_OVERNIGHT_RUN_PROTOCOL_2026_09_22.md` governs count mismatches,
> pre-existing artifacts, and committing. It overrides any conflicting instruction below.


---

## Working location

**`docs/research/apstats_segmentation_2026_09_22/`** (create it if it does not exist)

| File | Written by | Purpose |
| --- | --- | --- |
| `packet.jsonl` | you (Task 0) | model-neutral inputs — the shared QA baseline |
| `segmentation_proposal.jsonl` | you (Task 1) | your proposal, one row per item |
| `criterion_ledger.csv` | you | one row per item/criterion |
| `open_questions.csv` | you | anything unresolved, with the reason |
| `SUMMARY.md` | you (§5) | the report-back |
| `qa_findings.csv`, `qa_report.md` | **the QA model, not you** | never create or edit these |

## 0. What you are doing, and what you are NOT

Open Hand needs each FRQ's full-credit answer **segmented into criterion-tagged spans**, so that
deselecting a rubric point strikes exactly the text that earns it. The mechanic is already ACCEPTED
for AP Biology (`docs/research/apbio_frq_segmentation_2026_09_22/`, 75/75 exact concatenation).
Your job is to apply that same mechanic to AP Statistics.

**Scope is deliberately narrow: the 34 published AP Statistics FRQ that already have a canonical
answer.** You are segmenting **existing, published, vetted text**. You are not authoring answers.

**Do not touch the other 46.** They have no canonical answer, and they are the subject of a
separate concurrent work order (B, `CODEX_WORK_ORDER_B_APSTATS_CANONICAL_ANSWERS_2026_09_22.md`),
which authors *and* segments them itself. If you segment them too you will collide with that run.
Carry them in the packet marked `in_scope=false` and leave them alone.

## 1. Scope and expected counts — verify before starting

Read-only against **Cramapple – Production** (`pcntajvbdfqhbeewmdry`). Filter: latest `version_num`
per `content_item_id` where `status='published'`, `item_type='frq'`,
`subject_key='ap-statistics'`. State the `WHERE` behind every count you report.

| Expected | Count |
| --- | ---: |
| Published AP Statistics FRQ | 80 |
| — **with** a canonical answer (your scope) | **34** |
| — without (work order B's scope, leave alone) | 46 |

**If your own query returns a different set, apply the run protocol's tiered rule:** at **10%
drift or less**, where the task's premise still holds, **proceed with the observed set** and record
the delta prominently in `open_questions.csv` and `SUMMARY.md`, stating this work order's number,
your observed number and the exact `WHERE` behind yours. At **more than 10%**, or if a required
input is missing entirely, produce the packet and a discrepancy report only, skip the proposal
stage, and move on. Never work from a changed set without saying so.

## 2. Source material

- `public.content_item_versions` — `canonical_answer_1`, `canonical_answer_2`, `stem`, `stimulus`,
  `prompt_json` (including `parts` where present).
- `public.frq_criteria` joined on `content_item_version_id` — the rubric you are mapping to.
- **The worked precedent:** `docs/research/apbio_frq_segmentation_2026_09_22/`. Read its
  `SUMMARY.md` and a few rows of `apbio_frq_segmentation.codex.jsonl`. Copy the **structure** of
  its `creditedResponse`, not its content.
- **The defect that run had to fix, which you must not repeat:** its first pass read only
  `canonical_answer_1` and ignored `canonical_answer_2` on all 52 items that had one, drafting
  fresh text for criteria the second field already answered. **Read both fields as one corpus
  before you conclude any criterion is uncovered.**

## 3. Task 0 — build the packet

For all 80 published AP Statistics FRQ emit one `packet.jsonl` row: `content_key`,
`content_item_version_id`, `version_num`, `stem`, `stimulus`, `canonical_answer_1`,
`canonical_answer_2`, `in_scope` (bool), and the ordered `frq_criteria` with all fields.

Inputs only, no proposal. QA re-derives this from Production and diffs it against yours.

## 4. Task 1 — segment

For each of the 34 in-scope items:

1. Read `canonical_answer_1` **and** `canonical_answer_2` as one corpus.
2. Produce an ordered list of spans covering the full text, each tagged with the criterion key(s)
   it earns, such that concatenating all spans reproduces `full_text` **exactly**.
3. Preserve existing text **verbatim**. Do not paraphrase, reorder, tidy or re-word published
   content. If the published answer reads awkwardly, that is not yours to fix here.
4. Where a stored criterion is **not** satisfied by any span of the existing text, do **not** draft
   replacement prose. Mark the criterion `uncovered`, record it in `criterion_ledger.csv` and flag
   the item. An honest uncovered criterion is a finding; invented text is a defect.
5. Where a `canonical_answer_2` exists but satisfies no stored criterion, preserve it verbatim as
   uncredited context and flag it — same treatment the Biology run used.

**Expect cross-criterion entanglement.** The Biology run found 23 items where one sentence earned
two criteria, so hiding one span left a dangling connective or punctuation artifact. Flag every
instance; do not rewrite the sentence to avoid it.

## 5. Preparing your work for QA

An independent model — a different one from you — will adversarially QA this run without access to
your reasoning. It can only check what your artifacts let it recompute.

**5.1 Separate inputs from proposal.** `packet.jsonl` is what you read; `segmentation_proposal.jsonl`
is what you propose. QA re-derives the packet independently and diffs it. If they disagree the run
is invalid regardless of proposal quality.

**5.2 Make every claim machine-checkable.** Per item: `full_text`; `spans[]` each with `text`,
`criterion_keys[]`, `source_field` (`canonical_answer_1` | `canonical_answer_2`) and
`source_offset`; `coverage` with `{criteria_total, criteria_covered[], criteria_uncovered[]}`;
and `flags[]`.

**5.3 State the invariants you expect QA to recompute**, in `SUMMARY.md`, with your own measured
result for each:

| Invariant | Expected |
| --- | --- |
| Spans concatenate exactly to `full_text` | 34 / 34 |
| Every span appears verbatim in its named source field at the stated offset | 0 failures |
| No span invents a criterion outside the stored rubric | 0 violations |
| No text was drafted — every span traces to a published field | 0 drafted spans |
| Each non-blank `canonical_answer_2` appears verbatim in its assembled answer | 0 failures |
| Removing any one criterion's spans never empties the answer | 0 failures |
| The 46 out-of-scope items are untouched | 46 / 46 |
| Packet matches Production on version ids, both canonical fields, criterion counts, point sums | 0 differences |

**If one fails, report the failure — do not adjust the invariant.** In particular, "0 drafted
spans" is a hard property of this work order: if you find yourself wanting to draft, the correct
output is an `uncovered` criterion plus a flag.

**5.4 Flag your own weak points.** At minimum: every uncovered criterion and why; every
cross-criterion entanglement; every off-rubric `canonical_answer_2`; any item where span boundaries
were a judgement call.

**5.5 Make the run reproducible.** Record UTC start and end time, model identifier, Production
project ref, **the UTC time you took the Production snapshot**, and the **maximum `version_num`
observed per item**. Work order B covered the other 46 AP Statistics FRQ from an earlier snapshot;
these two fields are what let QA *prove* the two snapshots agree rather than assume it.

**5.6 If you run out of time, stop cleanly.** Finish the item you are on, then write `SUMMARY.md`
reporting exactly which items are complete and which were not attempted. **Do not degrade quality
to finish the list, and do not report a partial run as complete.** A truthful partial result is
useful; an overstated complete one poisons the QA.

**5.7 Write `SUMMARY.md` last**, including the invariant table with your measured results, counts
of covered vs uncovered criteria, everything in `open_questions.csv`, and an explicit statement
that this is a proposal requiring independent AI cross-model QA and Product Owner approval under
DECISION-0055 before it serves students.

**5.8 Do not create `qa_findings.csv` or `qa_report.md`.** Those belong to the QA model.

## 6. Rules of engagement

1. **Read-only against Production.** No `INSERT`, `UPDATE`, `DELETE`, no migrations, no deploys.
2. **Never draft answer text in this work order.** See 4.4.
3. **Never invent a criterion** outside the item's stored rubric.
4. **Do not touch the 46 out-of-scope items**, and do not write into work order B's directory
   (`docs/research/apstats_canonical_answers_2026_09_22/`).
5. **State the `WHERE` behind every count**, and report disagreements rather than working around
   them.

## 7. Definition of done

- `packet.jsonl` covers all 80 items, correctly marked `in_scope`.
- `segmentation_proposal.jsonl` covers all 34 in-scope items, or fewer with an honest partial
  report per 5.6.
- `criterion_ledger.csv` has one row per item/criterion with covered/uncovered status.
- `SUMMARY.md` reports every invariant in 5.3 with your measured result.
- Nothing in Production changed; the 46 out-of-scope items and work order B's directory are
  untouched.
