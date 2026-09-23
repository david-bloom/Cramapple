# Codex Work Order B — AP Statistics FRQ Canonical Answers

DATE: 2026-09-22 | SUBJECT: AP Statistics (`ap-statistics`) | RUNS: overnight, unattended
MODE: **Proposal only. Read-only against Production. No writes to published content, ever.**

---

## Working location — read inputs here, return output here

**`docs/research/apstats_canonical_answers_2026_09_22/`** (create it if it does not exist)

| File | Written by | Purpose |
| --- | --- | --- |
| `packet.jsonl` | you (Task 0) | model-neutral inputs, one row per item — the shared QA baseline |
| `canonical_proposal.jsonl` | you (Task 1–2) | your proposal, one row per item |
| `criterion_ledger.csv` | you | one row per item/criterion |
| `open_questions.csv` | you | anything you could not resolve, with the reason |
| `SUMMARY.md` | you (§6) | the report-back |
| `qa_findings.csv`, `qa_report.md` | **the QA model, not you** | never create or edit these |

## 0. What you are doing, in one paragraph

**46 of 80 published AP Statistics FRQ have no canonical answer at all** — both
`canonical_answer_1` and `canonical_answer_2` are null or blank (verified read-only, 2026-09-22).
A blank canonical weakens FRQ grading and leaves the Open Hand sample answer with nothing to show.
Your job is to author a **full-credit canonical answer for each**, grounded in that item's stored
rubric, and to segment it into criterion-tagged spans so Open Hand can strike the span that earns
each rubric point.

**This is genuine generation, not recovery.** I checked: of the 46 items, 10 have an earlier
version in `content_item_versions`, and **0 of those earlier versions carry a canonical answer in
either field**. Do not spend time hunting for prior text — there is none. (This differs from the
companion Biology work order A, where recovery is the whole point.)

## 1. Scope and expected counts — verify each before starting, and report any disagreement

Read-only against **Cramapple – Production** (`pcntajvbdfqhbeewmdry`). State the `WHERE` behind
every count you report. Filter: latest `version_num` per `content_item_id` where
`status='published'`, `item_type='frq'`, `subject_key='ap-statistics'`.

| Expected | Count |
| --- | ---: |
| Published AP Statistics FRQ | 80 |
| — with a canonical answer already (**leave alone**) | 34 |
| — with **no** canonical answer (your scope) | **46** |
| Items in scope with any prior version | 10 |
| Prior versions carrying a canonical answer | **0** |

The 46 items in scope, with `(criteria/points)`:

```
APSTAT-MOD3-E002 (1/1)    APSTAT-MOD3-E005 (1/1)    APSTAT-MOD3-H001-INV (5/5)
APSTAT-MOD4-H001-INV (4/4) APSTAT-MOD4-M001 (3/3)   APSTAT-MOD4-M003 (1/1)
APSTAT-MOD4-M004 (1/1)    APSTAT-MOD5-H001-INV (4/4) APSTAT-MOD5-M001 (1/1)
APSTAT-MOD6-H001 (3/3)    APSTAT-MOD6-H002-INV (4/4) APSTAT-MOD6-M002 (1/1)
APSTAT-MOD7-H002-INV (4/4) APSTAT-MOD8-M004 (1/1)
apstats-frq-u12-001 … -020  (each 10/10, except -005 which is 4 criteria / 10 points)
STATS-MOD1-E001 (1/1)  -E002 (1/1)  -E003 (1/1)  -E005 (1/1)  -M001 (1/1)
STATS-MOD3-H006 (1/1)  -M006 (1/1)  -M007 (1/1)
STATS-MOD4-E005 (1/1)  -H012 (1/1)  -M009 (1/1)   STATS-MOD9-H018 (1/1)
```

**Known inconsistency, do not silently fix:** `apstats-frq-u12-005` has 4 criteria summing to 10
points while its 19 siblings have 10 criteria summing to 10. Author against the stored rubric as
it is, and record the anomaly in `open_questions.csv`.

If your own query returns a different set of 46, **stop and report it** before proceeding.

## 2. Source material

- **The rubric is the specification.** `public.frq_criteria` for the item's published version —
  `criterion_key`, `learner_facing_text`, `points_possible`, `evidence_requirements`,
  `minimum_fix`, `accepted_variants`. A full-credit answer is one that earns **every** stored
  criterion. Do not answer a question the rubric does not ask.
- **The item itself:** `stem`, `stimulus`, `prompt_json` (including `parts` where present).
- **Grounding:** `docs/product/AP_STATISTICS_CED_FACT_PACK.md`.
- **Protocol:** `docs/research/CONTENT_AUTHORING_AND_QA_PROTOCOL.md`;
  `docs/product/CONTENT_GAPS_RUNNING_LIST.md` GAP-2.
- **Worked precedent for the segmentation shape:**
  `docs/research/apbio_frq_segmentation_2026_09_22/apbio_frq_segmentation.codex.jsonl`. The
  `creditedResponse` mechanic there is ACCEPTED; copy its structure, not its content.

## 3. Task 0 — build the packet first

For all 80 published AP Statistics FRQ (not just the 46) emit one `packet.jsonl` row:
`content_key`, `content_item_version_id`, `version_num`, `stem`, `stimulus`,
`canonical_answer_1`, `canonical_answer_2`, `in_scope` (bool), and the ordered `frq_criteria`
with all their fields.

Inputs only, no proposal. QA re-derives this from Production and diffs it against yours.

## 4. Task 1 — author, and Task 2 — segment

**Task 1 — author the canonical answer.** For each of the 46, write the answer a student would
give to earn full credit. Requirements:

1. **Every stored criterion must be earned by some part of the answer.** Work criterion by
   criterion; do not write prose first and hope it covers the rubric.
2. **Answer in context.** AP Statistics loses points overwhelmingly on missing contextual
   translation — a bare "reject H₀" earns nothing without the parameter, the population and the
   conclusion in context. Where the rubric asks for interpretation, name the variable and the
   population.
3. **Show the procedure where the rubric expects it.** If a criterion wants conditions checked,
   check them explicitly. If it wants a test statistic or interval, give the expression and the
   value.
4. **Statistical correctness is a hard requirement.** Re-derive every numeric result independently
   from the stimulus data rather than asserting it. If you cannot derive a value the rubric seems
   to expect, do not invent one — flag the item in `open_questions.csv`.
5. **Do not restate the question** as the answer, and do not exceed what the rubric asks.

**Task 2 — segment it.** Produce a `creditedResponse`: an ordered list of spans, each tagged with
the criterion key(s) it earns, such that concatenating all spans reproduces `full_text` exactly.
Every criterion must be covered by at least one span. Spans exist so that deselecting a rubric
point can strike exactly the text that earns it.

## 5. Rules of engagement

1. **Read-only against Production.** No `INSERT`, `UPDATE`, `DELETE`, no migrations, no edge
   function deploys. If you believe a write is required, stop and record it in
   `open_questions.csv`.
2. **Do not touch the 34 items that already have a canonical answer.** Carry them in the packet
   with `in_scope=false` and leave them alone. If one of them looks wrong, flag it — do not edit.
3. **Never invent a criterion** outside the item's stored rubric.
4. **Do not alter rubrics, stems or stimuli.** If the rubric appears internally inconsistent (as
   `apstats-frq-u12-005` does), author against it as stored and flag it.
5. **State the `WHERE` behind every count.** If a number disagrees with this work order, say so
   rather than quietly working around it.

## 6. Preparing your work for QA — read this before you start, not after

An independent model (a different one from you) will adversarially QA this overnight run without
access to your reasoning. It can only check what your artifacts let it recompute. For a generation
task the QA problem is harder than for a recovery task, because there is no prior text to diff
against — **the rubric is the only ground truth, so make the mapping to it explicit and
mechanical.**

**6.1 Separate inputs from proposal.** `packet.jsonl` holds only what you read from Production;
`canonical_proposal.jsonl` holds only what you propose. QA re-derives the packet independently and
diffs it. Do not mix them.

**6.2 Make every claim machine-checkable.** Per item in `canonical_proposal.jsonl`:

- `full_text` — the assembled canonical answer
- `spans[]` — each with `text` and `criterion_keys[]`
- `coverage` — `{criteria_total, criteria_covered[], criteria_uncovered[]}`
- `derivations[]` — for every numeric value that appears in the answer: the value, the criterion it
  serves, and the inputs it was computed from. **This is the single most important field for QA on
  this task**, because it is what lets a second model re-derive your arithmetic instead of taking
  it on trust.
- `flags[]` — your own self-identified risks, see 6.4

**6.3 State the invariants you expect QA to recompute**, in `SUMMARY.md`, with your own measured
result for each:

| Invariant | Expected |
| --- | --- |
| Spans concatenate exactly to `full_text` | 46 / 46 |
| Every stored criterion covered by ≥ 1 span | 46 / 46, 0 uncovered |
| No span invents a criterion outside the stored rubric | 0 violations |
| Every numeric value in `full_text` appears in `derivations[]` | 0 orphans |
| Every derivation's inputs trace to the stimulus or the stem | 0 unsourced |
| Removing any one criterion's spans never empties the answer | 0 failures |
| The 34 out-of-scope items are unmodified | 34 / 34 |
| Packet matches Production on version ids, canonical fields, criterion counts and point sums | 0 differences |

**If one fails, report the failure — do not adjust the invariant.**

**6.4 Flag your own weak points.** At minimum: any item where you were unsure the answer earns a
criterion as written; any numeric result you could not fully derive from the given data; any item
whose rubric seems to ask for something the stimulus does not support; any place where one sentence
earns two criteria and striking one would leave an artifact; and every item where you suspect the
stored rubric itself is wrong.

**6.5 Give QA a sampling handle.** 46 items is more than a reviewer will check line by line. In
`SUMMARY.md`, rank the items by your own confidence, lowest first, and say why the bottom five are
lowest. A QA model that knows where you are weakest spends its budget well. The 20
`apstats-frq-u12-*` items at 10 criteria each are the bulk of the work and deserve explicit
treatment.

**6.6 Make the run reproducible.** Record the UTC start and end time, the model identifier, the
Production project ref, and the maximum `version_num` seen per item.

**6.7 Write `SUMMARY.md` last.** Include: counts authored and segmented, the invariant table with
your results, the confidence ranking from 6.5, everything in `open_questions.csv`, and an explicit
statement that this is a proposal requiring independent AI cross-model QA and Product Owner
approval under DECISION-0055 before any of it serves students.

**6.8 Do not create `qa_findings.csv` or `qa_report.md`.** Those belong to the QA model.

## 7. Definition of done

- `packet.jsonl` covers all 80 items, correctly marked `in_scope`.
- `canonical_proposal.jsonl` covers all 46 in-scope items with full coverage and derivations.
- `criterion_ledger.csv` has one row per item/criterion.
- `SUMMARY.md` reports every invariant in 6.3 with your measured result, plus the confidence
  ranking.
- Nothing in Production changed, and the 34 out-of-scope items are untouched.
