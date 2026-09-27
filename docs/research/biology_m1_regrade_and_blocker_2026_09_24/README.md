# S-101 Re-grade After F.1, and Why M1 Is Blocked

**Date:** 2026-09-24. **Scope:** the DECISION-0052 grader gate re-run on `APBIO-FRQ-S-101` after
Codex's F.1 relabel (`76ac3066`), and a contract mismatch found while preparing M1.

---

## Part 1 — S-101 re-graded: 1 of 3 runs at 100%

Three runs of `app.qa_grade_frq()` against Codex's corrected text, all on deployment
`…_58` — **the same deployment as the M5 baseline**, so this is a like-for-like comparison and the
change is attributable to the text, not to a redeploy. All seven persistence flags `false` on every
run.

| Run | Points | Status | Confidence | `a-iv` | Integrity |
| --- | ---: | --- | --- | --- | --- |
| 1 | **4 / 4** | graded | high | earned, elided quote | none |
| 2 | 3 / 4 | uncertain | low | `unable_to_determine` | `evidence_not_found` |
| 3 | 3 / 4 | uncertain | low | `unable_to_determine`, quote null | `evidence_not_found` |

**S-101 does not meet DECISION-0052's bar** ("the production grader awards it 100%"). It clears it
once in three.

### Codex's fix was correct. It exposed a defect underneath it.

F.1 did what it was asked: the answer's sub-part labels now match the stem's. The M5 baseline's
complaint — *"the student did not provide a separate explanation explicitly answering part (a)(iv)"*
— is gone. That was a real presentation defect and it is fixed.

What the fix uncovered is that **the rubric's criterion keys are not aligned with the stem's
sub-parts**, despite keys (`a-i` … `a-iv`) that imply a one-to-one mapping:

| Stem asks | Earns |
| --- | --- |
| (a)(i) define synapomorphy **and** explain why more informative than symplesiomorphy | `a-i` **and** `a-ii` — two criteria |
| (a)(ii) construct the cladogram, identify the outgroup, explain reasoning | `a-iii` |
| (a)(iii) explain what "most parsimonious" means | `a-iv` — **one criterion covering both** |
| (a)(iv) explain why parsimony is preferred | ↑ |

`a-iv`'s stored `evidence_requirements` demands two things: *"States that the most parsimonious tree
requires the fewest evolutionary changes … **and** that parsimony is preferred because it requires
the fewest unsupported assumptions."*

Before F.1 both sentences sat in one paragraph, so a single contiguous quote could satisfy `a-iv`.
F.1 correctly split them into labelled `(iii)` and `(iv)` to match the stem — and in doing so made
`a-iv`'s evidence span two separated paragraphs. Run 1 coped by constructing an elided quote
(`"Most parsimonious" means … Parsimony is preferred … because …`); runs 2 and 3 could not find a
contiguous quote and returned `evidence_not_found`.

**The answer cannot satisfy both the stem's labelling and the rubric's single-criterion contiguity,
because the stem and the rubric disagree with each other.** That is a rubric defect. It is not
fixable by editing the answer, and it should not be worked around by un-doing F.1.

### Disposition

`S-101` is **held out of M1**. Writing its canonical now would foreclose the measurement forever —
the gate refuses any item that already has a `canonical_answer_1` — while the item is still failing
two runs in three.

The fix is a rubric change, which is a content change and needs Product Owner approval. The
straightforward option is to split `a-iv` into two 1-point criteria matching the stem's (a)(iii) and
(a)(iv), taking the item from 4 points to 5. An alternative is to re-key so criteria track stem parts
and let (a)(i) carry 2 points. Either is a real authoring decision, not a QA call.

### A generalisation worth running

Codex's F.1 scan looked for **label** mismatches and found S-102 and S-103 share the parent-split
pattern. That is a different scan from this one. Nobody has yet scanned for **criterion-to-stem-part
misalignment** — a rubric whose criterion count or boundaries do not match the sub-parts its stem
asks. S-101 was found only because the grader gate happened to reach it. The other 68 Biology FRQ
already carry canonicals and are refused by the gate, so this class is invisible to the gate on all
of them.

---

## Part 2 — M1 is blocked by a storage-contract mismatch

While preparing M1 I checked F's 71-item proposal against M0's `app.canonical_answer_spans` and
against Production. Three mismatches, any one of which blocks the write.

**Verified first:** all 71 items' spans concatenate exactly to their `full_text` (0 failures), and for
the long `APBIO-FRQ-L-*` items `full_text` is byte-identical in length to Production's stored
`canonical_answer_1` (L-003 4212, L-004 6185, L-006 5687, L-008 5389, L-012 5842, L-013 5378). For
those items F's output and M0's contract agree.

### 1. For 36 items, `full_text` is an assembled document spanning two stored fields

`APBIO-FRQ-S-009` is the clean example. Production stores `canonical_answer_1` (843 chars) and a
separate `canonical_answer_2` (161 chars). F's `full_text` is 1006 chars: spans 0–8 recovered from
`canonical_answer_1`, span 9 an `assembly_literal` (`\n\n`), span 10 recovered from
`canonical_answer_2`. 843 + 2 + 161 = 1006.

M0 stores `answer_field` as either `canonical_answer_1` or `canonical_answer_2`, and its stated
invariant is that spans ordered by ordinal concatenate back to **that field** exactly. An assembled
document that splices both fields has no single `answer_field` to belong to. **36 of 71 items are in
this shape.**

### 2. F's `source_field` vocabulary violates M0's check constraint

F emits `prior_canonical_answer_1`, `prior_canonical_answer_2` and `authored_work_order_F`. M0's
check allows only `canonical_answer_1`, `canonical_answer_2`, `parent_canonical_answer_1`,
`parent_canonical_answer_2`. **The insert would fail outright.**

### 3. The plan forbids the write that would make the invariant true

M1 as written says: *"Do not overwrite any existing `canonical_answer_1`."* But for those 36 items
the spans only concatenate to something that is not currently stored anywhere. Either the assembled
document becomes the stored answer, or the spans do not describe the stored answer.

### Why this is not a mapping QA should invent

Reconciling these would mean deciding that the assembled ca1+ca2 document replaces
`canonical_answer_1` on 36 published items, and inventing a `source_field` vocabulary to match. That
is authoring the reconciliation and then verifying it — the exact conflation DECISION-0055's model
exists to prevent. It is also a content decision about what a canonical answer *is*.

### The decision needed

**Does the assembled document become the stored `canonical_answer_1`?**

- **Yes** — then M0's shape is right, `source_field` needs `prior_*` mapped to the existing values
  plus a new `authored` value, M1 writes both the assembled answers and the spans, and the 36 items'
  `canonical_answer_2` becomes redundant. This is also arguably what DECISION-0052 wants: one
  complete answer as a student would write it. It does mean overwriting published content, which the
  plan currently forbids.
- **No** — then F must re-emit spans **per stored field**, one set concatenating to
  `canonical_answer_1` and one to `canonical_answer_2`, with assembly literals dropped rather than
  stored. That is a Codex re-run, not a repair here.

Until that is settled, M1 writes nothing.

---

## Findings

| ID | Finding |
| --- | --- |
| **M1-B-001** | `APBIO-FRQ-S-101` scores 100% on 1 of 3 grader runs on the same deployment. Held out of M1. Cause is a rubric defect: criterion `a-iv` requires evidence from two stem sub-parts that F.1 correctly separated. Needs a Product Owner rubric decision. |
| **M1-B-002** | Criterion-to-stem-part misalignment has never been scanned for across the Biology corpus. The grader gate cannot detect it on the 68 items that already carry a canonical. |
| **M1-B-003** | For 36 of 71 items F's `full_text` splices `canonical_answer_1` and `canonical_answer_2` into one document, which M0's `answer_field` cannot represent and the plan's no-overwrite rule will not let us store. |
| **M1-B-004** | F's `source_field` values (`prior_canonical_answer_1`, `prior_canonical_answer_2`, `authored_work_order_F`) are not in M0's check constraint. The insert fails as-is. |
| **M1-B-005** | Confirms M5-B-002. Three runs, same text, same deployment, same model: 4/4 high, 3/4 low, 3/4 low. A single grader run is not evidence of anything. Any DECISION-0052 ratification should record the run count. |
