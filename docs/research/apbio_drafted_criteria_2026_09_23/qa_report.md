# QA Report — Work Order F (AP Biology, the 88 Still-Drafted Criteria)

**Disposition: ACCEPTED.** All 88 authored criteria are biologically correct, both open findings from
work order A are closed, and every segmentation invariant passes. **F is the cleanest authoring run
in the program.**

Three high-severity findings are recorded, and **none is against F's content.** Two concern the
production grader and the reach of DECISION-0052's gate; one is a repository/Production drift.

This line is the DECISION-0055 independent cross-model QA gate for work order F. It ratifies nothing.

- **QA model:** Claude Opus 5 (non-OpenAI, independent of the Codex builder), 2026-09-23
- **Producer:** Codex, work order F run of 2026-09-23 ~11:13
- **Production:** `pcntajvbdfqhbeewmdry`. Read-only except for the sanctioned no-persist QA grader
  path, which writes nothing — see below. Work order A's directory was not modified.

## The DECISION-0052 grader gate, exercised for the first time

DECISION-0052 §1 defines the rule: *"an answer is not canonical until it is written as a student
would write it AND the production grader awards it 100% against its own rubric."* No QA in this
program had run the second half. This report runs it.

**The mechanism.** `app.qa_grade_frq(content_item_version_id, answer_text)` exists in Production —
`SECURITY DEFINER`, capability-token gated, posting `qa_no_persist: true` to the live
`evaluate-attempt`. I read the deployed handler before invoking it: it reuses the live prompt
builders, model, grading arm, retry behaviour and sanitizer, creates no attempt, response or
grading-result row, and returns an explicit block with all seven persistence flags `false`. Every
call in this report returned those flags false.

**Result — 2 of 3 fail, and both failures are the grader's:**

| Item | Score | Status | Grader's own integrity flag |
| --- | ---: | --- | --- |
| `APBIO-FRQ-S-101` | **3 / 4** | uncertain, low | `earned_points_mismatch` on `a-iv` |
| `APBIO-FRQ-S-102` | 4 / 4 | graded, high | none |
| `APBIO-FRQ-S-103` | **4 / 5** | uncertain, low | `evidence_not_found` on `c-ii` |

On `S-103` `c-ii` the grader's own `decision_explanation` reads *"The response gives a valid reason
molecular data is more reliable (more characters, less convergence) and provides a real example
(whales and hippos)"* — and it then returns `unable_to_determine` and awards 0. Its prose affirms the
criterion while its status denies it, and its own integrity checker catches the contradiction.
`S-101` `a-iv` is the same shape: the answer states both halves the criterion asks for, and the
grader calls it "close but missing".

**Both failing spans are recovered, pre-existing text** from retired parent `APBIO-FRQ-L-025` — not
authored by F, and vetted long before this program. So the first real exercise of the 100% rule
implicates the grader, not the content. Recorded as **F-QA-001**, and it belongs in a grader lane
rather than as content rework.

## The gate reaches 4% of the corpus

The QA handler returns HTTP 409 `canonical_answer_already_present` whenever `canonical_answer_1` is
non-empty. That is a sensible default for its original purpose — grading drafts for items that have
no canonical — but it means:

- **7 of 75** published Biology FRQ can be graded at all; **68 are refused.**
- 4 of those 7 are hand-drawn and cannot be graded from text.
- **3 of F's 71 items** are reachable: about **4%**.

The same limit applies to every work order B and C item. As built, DECISION-0052's gate cannot
validate the library it was written for. Recorded as **F-QA-002**; widening it is a Production change
to a token-gated path and is a Product Owner call.

## A repository/Production drift

The deployed `evaluate-attempt` is **version 56 (2026-09-22T00:47Z)** and contains
`handleQaNoPersist`, `QA_NO_PERSIST_PATH_VERSION`, the `x-qa-grader-token` check, the
`verify_qa_grader_token` call and the persistence-flags response. **A grep across the whole
repository returns zero occurrences of any of it.** The supporting database functions exist in
Production too.

Production is running code `main` does not have — the same class as the 160 local-only files found on
2026-09-22. The path is well built and carries its own explanatory docstring, which makes it more
worth committing, not less. Recorded as **F-QA-003**.

## What F itself did, verified

| Check | Result |
| --- | --- |
| Authored spans read against stem, criterion and evidence requirement | **88 of 88 biologically correct, 0 errors** |
| Rubric restatement (mean word-level similarity to own criterion) | **0.219**, 0 at ≥0.70, 0 at ≥0.85 |
| Span exclusivity | **0 of 261** criteria without an exclusive span; 576 spans, none double-tagged; mean over-strike **0.00** |
| Exact concatenation | 71 / 71 |
| Full criterion coverage | 71 / 71 |
| Invented criteria | 0 |
| DECISION-0056 removals | **4 of 4 verify** against Production |

**A-QA-001 is closed.** `APBIO-FRQ-S-073` criterion `a` now reads: *"Because 2n = 4, the haploid
number is n = 2. Homologs separate in meiosis I, producing two cells that each have two chromosomes,
with two sister chromatids per chromosome. Sister chromatids separate in meiosis II, producing four
cells that each retain two chromosomes, now with one chromatid per chromosome."* Correct, and
**derived from the stem** rather than copied from the QA report, as the amended requirement asked.

**A-QA-002 is closed.** A's authored spans averaged 0.582 similarity to their own rubric text with 15
at or above 0.85 and three character-identical. F's average **0.219** with none above 0.70. The
difference is visible in the content: where A wrote "A peptide bond forms between the carboxyl group
of one amino acid and the amino group of the adjacent amino acid" — the criterion verbatim — F writes
"the carboxyl carbon of one amino acid becomes covalently joined to the amino nitrogen of the next;
the resulting C–N linkage is a peptide bond." F adds the mechanism the rubric omits, which is the
point of the work order.

**Span exclusivity deserves a note.** F achieved 0.00 over-strike **without the invariant** — Codex
merged `main` at 10:53 and the exclusivity rule landed at 10:56, three minutes later. It segmented at
criterion granularity unprompted. That makes F the worked example work order G.1 should copy, since
G's `ap-physics-1` batch sits at 176 of 176 and 1.00.

**DECISION-0056's first exercise is clean.** All four logged removals verify against Production — the
source version exists, belongs to the item, and the removed text is present verbatim in the named
field. Codex removed **4** of the 30 candidate items rather than forcing the count, which is what the
"candidates, not a quota" wording was added to produce.

## What this disposition does and does not authorise

**Does:** satisfies DECISION-0055's independent cross-model QA gate for work order F.

**Does not:** ratify any answer, or authorise a write to Production. And it explicitly does **not**
certify these answers against DECISION-0052's 100% rule: that gate could be exercised on 3 of 71
items, 2 of which failed for reasons that appear to be grader defects. Until F-QA-001 and F-QA-002
are resolved, the 100% rule remains unmet for this corpus — not because the answers are wrong, but
because the gate cannot yet be run on them.
