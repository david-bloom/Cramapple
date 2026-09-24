# M5 Baseline — DECISION-0052 Grader Gate, AP Biology

**Captured:** 2026-09-24T12:36Z, before M1 writes any canonical answer
**Why now:** the QA grader path refuses any item that already has a `canonical_answer_1`
(HTTP 409 `canonical_answer_already_present`). M1 writes canonicals. **Once M1 runs, this measurement
becomes impossible for these items.** Capturing it first is the only way DECISION-0052's rule —
*"the production grader awards it 100% against its own rubric"* — can ever be evidenced for Biology.

**Method:** `app.qa_grade_frq(content_item_version_id, answer_text)`, no-persist mode. All seven
persistence flags returned `false` on every call. Answer text is work order F's proposed `full_text`
for each item — the exact text M1 would apply.

**Scope:** 3 items. Biology has 75 published FRQ; 7 have a blank `canonical_answer_1`; 4 of those are
hand-drawn and cannot be graded from text. These 3 are the entire reachable set.

---

## Results

| Item | Score | Status | Confidence | Integrity issues |
| --- | ---: | --- | --- | --- |
| `APBIO-FRQ-S-101` | **3 / 4** | graded | high | none |
| `APBIO-FRQ-S-102` | **4 / 4** | graded | high | none |
| `APBIO-FRQ-S-103` | **5 / 5** | graded | high | none |

**2 of 3 meet DECISION-0052's 100% bar. One does not.**

---

## Comparison with work order F's QA run, and what changed

F's QA ran the same three items on 2026-09-23 against edge-function deployment `…_56`. This baseline
ran against `…_58` — **the function was redeployed between the two runs.**

| Item | F's QA (deployment 56) | M5 baseline (deployment 58) |
| --- | --- | --- |
| `S-101` | 3/4 · uncertain · low · `earned_points_mismatch` on `a-iv` | **3/4** · graded · high · **no integrity issue**, different reason |
| `S-102` | 4/4 | **4/4** |
| `S-103` | 4/5 · uncertain · low · `evidence_not_found` on `c-ii` | **5/5** · graded · high · no integrity issue |

Two things follow.

### 1. `S-103`'s failure was a grader defect, and it is gone

F-QA-001 characterised both failures as grader defects — the grader's own explanation affirming a
criterion while its status denied it, with its own integrity checker flagging the contradiction. For
`S-103` that reading is now confirmed: **the same text scores 5/5 on the newer deployment with no
integrity issue.** The content never changed.

### 2. `S-101`'s failure is a content finding, not a grader defect — a correction to F-QA-001

`S-101` scores 3/4 on **both** runs, and the newer run gives a coherent, defensible reason with no
integrity flag:

> *"The student did not provide a separate explanation explicitly answering part (a)(iv) about why
> parsimony is preferred or fully defining 'most parsimonious' as required."*

That is right, and it exposes a real artefact of the 2026-08-12 item split:

- The item's **stem asks four sub-parts**: `(a)(i)` … `(a)(iv)`, and its rubric has four criteria
  `a-i` … `a-iv`.
- The **recovered answer text is labelled `(i)`, `(ii)`, `(iii)` only** — because it came verbatim
  from retired parent `APBIO-FRQ-L-025`, which asked a **three**-part question.
- The content earning `a-iv` is real but **buried inside the `(iii)` paragraph**.

Work order A mapped it correctly by content — the QA of A confirmed `a-iv`'s text is present and
earns the criterion. But **a student reading this canonical sees no part (iv)**, and the grader,
reading it as a student would, marks it missing.

So this is not the grader under-crediting. It is a **presentation defect created by splitting a
3-part parent into a 4-criterion child without re-labelling the answer's sub-parts.**

**Action before M1:** split `S-101`'s `(iii)` paragraph into labelled `(iii)` and `(iv)` matching the
stem, preserving the recovered wording. That is a re-labelling, not a re-authoring — and it should be
done by Codex, not by QA, then re-graded.

---

## Findings carried forward

| ID | Finding |
| --- | --- |
| **M5-B-001** | `APBIO-FRQ-S-101`'s canonical is labelled for a 3-part question against a 4-part stem. Split `(iii)` into `(iii)` and `(iv)` before M1. Blocks the "100% on every reachable item" condition. |
| **M5-B-002** | **The grader is not deterministic across runs or deployments.** `S-103` moved 4/5 → 5/5 and `S-101`'s failure mechanism changed entirely, with no content change. A single grader run is not a reliable gate — any future ratification resting on a 100% score should record the deployment id and, for a borderline item, run more than once. |
| **M5-B-003** | The function was redeployed 56 → 58 between 2026-09-23 and 2026-09-24. Neither deployment's source is in the repository (F-QA-003 records that the whole QA no-persist subsystem exists only in Production). Grader behaviour is changing in ways the repo cannot show or roll back. |

---

## What this baseline does not cover

- The 4 hand-drawn Biology items. Text cannot earn their spatial criteria; they are dispositioned as
  non-scoring except `APBIO-HDG-2026-GRAPH-002`, which is in the TASK-0038 human-graded pilot.
- The other 68 Biology FRQ, which already have a canonical and are therefore refused by the gate's
  `canonical_answer_already_present` guard. **DECISION-0052's rule cannot be evidenced for them
  without widening that guard** — recorded as F-QA-002.
