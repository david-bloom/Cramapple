# Codex Work Order A — AP Biology Canonical-Answer Recovery and Reconciliation

DATE: 2026-09-22 | SUBJECT: AP Biology (`biology`) | RUNS: overnight, unattended
MODE: **Proposal only. Read-only against Production. No writes to published content, ever.**

---

## Working location — read inputs here, return output here

**`docs/research/apbio_canonical_recovery_2026_09_22/`** (create it if it does not exist)

| File | Written by | Purpose |
| --- | --- | --- |
| `packet.jsonl` | you (Task 0) | model-neutral inputs, one row per item — the shared QA baseline |
| `recovery_proposal.jsonl` | you (Task 1–3) | your proposal, one row per item |
| `recovery_ledger.csv` | you (Task 1–3) | one row per item/criterion with provenance |
| `open_questions.csv` | you | anything you could not resolve, with the reason |
| `SUMMARY.md` | you (§6) | the report-back |
| `qa_findings.csv`, `qa_report.md` | **the QA model, not you** | never create or edit these |

## 0. What you are doing, in one paragraph

On 2026-08-12 a repair pass split short-FRQ rubrics from 2 criteria into 4 ("1-point-per-part
repair"). **The rubrics got finer; the canonical answers were never re-mapped.** Verified
2026-09-22: 41 published Biology FRQ have a finer rubric than their immediately prior version while
`canonical_answer_1` and `canonical_answer_2` are **byte-identical** to that prior version. This is
the root cause of the GAP-9 misalignment — it is a migration defect, not bad authoring.

A previous run (`docs/research/apbio_frq_segmentation_2026_09_22/`) responded by **drafting** new
text for 118 of 278 rubric criteria. That was the wrong first move, because it only ever looked at
the *published* version. Your job is to **recover before you draft**: for each affected item, read
the prior version's answer text and reuse whatever already earns a criterion in the current rubric.
Recovered text is already-vetted content; drafted text is fresh generation that must clear a much
higher ratification bar. Every criterion you can move from "drafted" to "recovered" lowers project
risk.

## 1. Scope and expected counts — verify each before starting, and report any disagreement

Read-only against **Cramapple – Production** (`pcntajvbdfqhbeewmdry`). State the `WHERE` behind
every count you report.

| Expected | Count |
| --- | ---: |
| Published Biology FRQ (latest version per item) | 75 |
| Items whose rubric is finer than the prior version AND whose answers are byte-identical | **41** |
| Items with no canonical answer in either field | 7 |
| — of those, split from a retired parent | 3 (`APBIO-FRQ-S-101`, `-102`, `-103`) |
| — of those, drawn-graph items (**out of scope**, see §5) | 4 (`APBIO-HDG-2026-GRAPH-002/003/008/010`) |
| Rubric criteria across all 75 items | 278 |
| Criteria the prior run marked `drafted` | 118 |

The 41 rubric-split items:

```
APBIO-FRQ-L-008, APBIO-FRQ-S-009, S-010, S-011, S-016, S-017, S-019, S-020, S-021, S-023,
S-025, S-026, S-028, S-032, S-033, S-036, S-038, S-040, S-046, S-047, S-048, S-051, S-052,
S-058, S-061, S-063, S-064, S-066, S-068, S-070, S-071, S-080, S-081, S-084, S-086, S-087,
S-089, S-090, S-095, S-097, APBIO-HDG-2026-GRAPH-010
```

If your own query returns a different set, **stop and report it in `open_questions.csv`** before
proceeding. Do not silently work with a different list.

## 2. Source material

- **Current published content:** `public.content_item_versions` (latest `version_num` where
  `status='published'`), and `public.frq_criteria` joined on `content_item_version_id`.
- **Prior versions — this is the material the previous run missed.** The same
  `content_item_versions` table holds superseded and `retired` rows for the same
  `content_item_id` at lower `version_num`. They carry the pre-split `canonical_answer_1/2`.
- **`prompt_json.qa_remediation`** records why a version exists, e.g.
  `"2026-08-12 short-FRQ 1-point-per-part repair (CED cross-check)"`. Use it to confirm you are
  looking at the right prior version.
- **`prompt_json.split_from`** names a parent item for `S-101/102/103` →
  `APBIO-FRQ-L-025` (retired, `version_num` 4, `canonical_answer_1` ≈ 5,530 chars, structured
  `(a)(i)(ii)(iii) (b)(i)(ii)(iii) (c)(i)(ii) (d)`).
- **Prior proposal:** `docs/research/apbio_frq_segmentation_2026_09_22/` — read
  `apbio_frq_segmentation.codex.jsonl` and `SUMMARY.md`. Treat its drafted spans as *candidates to
  be replaced by recovered text*, not as settled content.
- **Protocol:** `docs/research/CONTENT_AUTHORING_AND_QA_PROTOCOL.md`;
  `docs/product/CONTENT_GAPS_RUNNING_LIST.md` GAP-9;
  `docs/product/AP_BIOLOGY_CED_FACT_PACK.md` for grounding any genuinely new text.

## 3. Task 0 — build the packet first

For all 75 published Biology FRQ emit one `packet.jsonl` row:

`content_key`, `content_item_version_id`, `version_num`, `stem`, `canonical_answer_1`,
`canonical_answer_2`, the ordered `frq_criteria` (`criterion_key`, `learner_facing_text`,
`points_possible`), and — where one exists — `prior_version_id`, `prior_version_num`,
`prior_canonical_answer_1`, `prior_canonical_answer_2`, `prior_criteria`.

The packet is **model-neutral**: inputs only, no proposal. QA reads it to confirm you worked from
the real Production state. Emit it before you write any proposal rows.

## 4. Task 1 — recover

For each of the 41 items, and for `S-101/102/103` against parent `L-025`:

1. Read the prior version's `canonical_answer_1` and `canonical_answer_2` **in full**.
2. For each criterion in the **current** rubric, decide whether any span of that prior text already
   satisfies it. Reuse it **verbatim** — do not paraphrase, tidy or re-word vetted content.
3. Only where no prior text satisfies the criterion may you draft, and then ground it in the CED
   fact pack.
4. Record, per criterion: `provenance` ∈ {`recovered_ca1`, `recovered_ca2`, `recovered_parent`,
   `drafted`}, the `source_version_id` it came from, and the exact span.

For `S-101/102/103`, note the parent renumbered when it split: the parent's `(b)(iii)` supplies two
distinct reasons which became `b-iii` and `b-iv`; the parent's `(d)` supplies three lines of
evidence which became `d-i`, `d-ii`, `d-iii`. Map by **content**, not by label.

## 5. Task 2 — segment, and Task 3 — report the delta

**Task 2.** Produce the `creditedResponse` segmentation for each item, same shape as the accepted
Biology run: an ordered list of spans, each tagged with the criterion key(s) it earns, such that
concatenating all spans reproduces `canonical_answer.full_text` exactly.

**Task 3.** For every criterion the prior run marked `drafted`, state whether you recovered it
instead, and from where. The headline number QA will check is: **of 118 previously-drafted
criteria, how many are now recovered?**

**Out of scope — do not attempt:**
- The 4 `APBIO-HDG-2026-GRAPH-*` items. Text cannot be a full-credit answer for a drawn response;
  they need a spatial canonical on the Engine 4 path. Carry them in the packet, mark them
  `out_of_scope`, and leave them alone.
- The 9 point-total mismatches (`APBIO-FRQ-L-004/006/012/013/015/016/017/019/021`,
  `prompt_json.total_points=8` vs rubric sum 9). Note them; do not fix them here.

## 6. Rules of engagement

1. **Read-only against Production.** No `INSERT`, `UPDATE`, `DELETE`, no migrations, no edge
   function deploys. If you believe a write is required, stop and write it to `open_questions.csv`.
2. **Fill gaps; do not replace.** Existing canonical answers, rubrics and criteria are prior work.
   Where existing content looks wrong, **flag it for a human** — never overwrite it.
3. **Verbatim means verbatim.** A recovered span must appear character-for-character in the source
   field. QA will recompute this.
4. **Never invent a criterion** outside the item's stored rubric.
5. **State the `WHERE` behind every count.** If a number disagrees with this work order, say so in
   `open_questions.csv` and in `SUMMARY.md` rather than quietly working around it.
6. **Do not edit any file under `docs/research/apbio_frq_segmentation_2026_09_22/`.** It is the
   prior record.

## 7. Preparing your work for QA — read this before you start, not after

An independent model (a different one from you) will adversarially QA this overnight run without
access to your reasoning. It can only check what your artifacts let it recompute. Prepare for that
deliberately:

**7.1 Separate inputs from proposal.** `packet.jsonl` holds only what you read from Production.
`recovery_proposal.jsonl` holds only what you propose. QA re-derives the packet from Production
independently and diffs it against yours; if they disagree, your run is invalid regardless of how
good the proposal is. Do not mix the two files.

**7.2 Make every claim machine-checkable.** For each item emit, in `recovery_proposal.jsonl`:

- `spans[]` — each with `text`, `criterion_keys[]`, `provenance`, `source_version_id`,
  and `source_offset` (character index into the source field) where provenance is a recovery
- `full_text` — the assembled answer
- `coverage` — `{criteria_recovered_ca1[], criteria_recovered_ca2[], criteria_recovered_parent[],
  criteria_drafted[]}`
- `prior_run_drafted[]` — the criteria the earlier run drafted, so the delta is computable
- `flags[]` — your own self-identified risks, see 7.4

**7.3 State the invariants you expect QA to recompute.** Put these in `SUMMARY.md` as a checklist
with your own measured result for each, so a disagreement is immediately visible:

| Invariant | Expected |
| --- | --- |
| Spans concatenate exactly to `full_text` | 71 / 71 in-scope items |
| Every rubric criterion has ≥ 1 span | 71 / 71 |
| No span invents a criterion outside the stored rubric | 0 violations |
| Every `recovered_*` span appears verbatim in its named source field | 0 failures |
| Every `source_version_id` exists and belongs to the same `content_item_id` | 0 failures |
| Removing any one criterion's spans never empties the whole answer | 0 failures |
| Packet matches Production on version ids, both canonical fields, criterion counts and point sums | 0 differences |

Report your own count for each. **If one fails, report the failure — do not adjust the invariant.**

**7.4 Flag your own weak points.** QA's job is easier and your run is more credible if you
volunteer them. At minimum flag: criteria where the recovered span only partially satisfies the
criterion; spans where sentence-level wording entangles two criteria so hiding one leaves a
connective artifact; any item where you judged recovery possible but marginal; anything you drafted
despite prior text existing, with the reason.

**7.5 Make the run reproducible.** Record in `SUMMARY.md`: the UTC start and end time, the model
identifier, the Production project ref, and the maximum `version_num` you saw per item. QA uses
these to detect drift if content changed mid-run.

**7.6 Write `SUMMARY.md` last**, and include: the headline delta (of 118 previously-drafted
criteria, N recovered / M still drafted), the invariant table with your results, counts by
provenance, the out-of-scope items and why, everything in `open_questions.csv`, and an explicit
statement that this is a proposal requiring independent AI cross-model QA and Product Owner
approval under DECISION-0055 before any of it serves.

**7.7 Do not create `qa_findings.csv` or `qa_report.md`.** Those belong to the QA model. If either
exists when you finish, you have overwritten someone else's work.

## 8. Definition of done

- `packet.jsonl` covers all 75 items.
- `recovery_proposal.jsonl` covers all 71 in-scope items with full provenance.
- `recovery_ledger.csv` has one row per item/criterion.
- `SUMMARY.md` reports the 118-criteria delta and every invariant in 7.3 with your measured result.
- Nothing in Production changed, and nothing under `apbio_frq_segmentation_2026_09_22/` was edited.
