# Codex Work Order — Tag Biology & Statistics Items With Unit:Topic Pairs; Review FRQ Canonical Answers

DATE: 2026-09-22 | SUBJECTS: AP Biology (`biology`), AP Statistics (`ap-statistics`)
MODE: **Proposal only — no writes to published content.** Output files for review, then a
second AI runs QA (see the last section).

---

## 0. What you are doing, in one paragraph

Every published Biology and Statistics item (MCQ and FRQ) needs **exactly one primary
unit:topic** chosen from that subject's College Board CED closed list, and every published FRQ
needs its **canonical answer** checked (and, where missing, a draft proposed). Today **zero of
these items carry a topic label**, and a meaningful tail of FRQ have no canonical answer. You
produce a structured proposal; you do **not** write labels or answers into the database. A
second AI then QAs your proposal adversarially before any human review.

**Fill gaps; do not replace.** Before proposing anything you run an inventory of what content
already exists (Task 0) and you work **only** on what is missing. Existing canonical answers,
existing labels, rubrics, criteria and author prose are prior work to build on and preserve —
never to overwrite. Where existing content looks wrong you **flag it for a human**, you do not
replace it.

Work **read-only against Production** (`pcntajvbdfqhbeewmdry`). State the `WHERE` behind every
count you report. If a number you read disagrees with a number in this order, **say so** — do
not quietly work around it.

---

## 1. Scope and expected counts (verify before starting)

| Subject | `subject_key` | MCQ | FRQ | Total |
| --- | --- | ---: | ---: | ---: |
| AP Biology | `biology` | 43 | 75 | 118 |
| AP Statistics | `ap-statistics` | 304 | 80 | 384 |

Counts read 2026-09-22, filter: `public.content_item_versions` `status='published'`, grouped by
`subject_key, item_type`. Re-run and confirm; if the counts have moved, report the delta and
proceed with the live set.

**Every item in scope carries no topic label today** — verified: 0/384 Stats, 0/118 Biology have
a `coverage`-scope row in `app.content_taxonomy_labels` with a non-empty `assessed_topics`. So
this is a from-scratch labelling pass, not a correction pass.

---

## 2. Source material (everything you need is here)

### 2.1 The items
- `public.content_item_versions` — one row per version. Fields you need:
  `content_item_id`, `version_num`, `status` (filter `='published'`), `subject_key`,
  `item_type` (`'mcq'` | `'frq'`), `canonical_answer_1`, `canonical_answer_2`, `prompt_json`
  (the stem; `prompt_json->'subtopics'` is the **author's own topic prose**, and
  `prompt_json->'parts'` is structured multi-part data when present), and the stem text.
  Use the **latest published version** per `content_item_id`.
- `public.content_items` — `id`, `subject_key`, `subject_name`.
- `public.mcq_choices` — `choice_key`, `choice_text`, `is_correct`, `rationale` (per MCQ). You
  are in the **authoring context** and may read the full answer key; this is not the student
  serving path.
- `public.frq_criteria` — `learner_facing_text`, `points_possible`, `evidence_requirements`,
  `minimum_fix` (per FRQ criterion).

### 2.2 The CED closed list (the allowed unit:topic values)
- `app.taxonomy_topics` — `topic_code`, `topic_title`, `unit_number`, `unit_title`,
  `taxonomy_source_version`. **Pull the closed list per subject and select only from it** — an
  invented topic string is a hard failure.
  - **AP Biology:** `taxonomy_source_version = 'c676d1fc-3b58-4896-89e3-852d9bd1f81b'` — 60
    topics across 8 units.
  - **AP Statistics:** `taxonomy_source_version = 'dae3c72e-82ca-4960-9552-1b034bd347e5'` — 55
    topics.
  - Confirm each mapping yourself before use (the model runs already stored in
    `app.content_taxonomy_labels.taxonomy_source_version` for these subjects reference exactly
    these two versions).

### 2.3 Independent second signals already in the database (use, but do not treat as ground truth)
- `public.content_item_versions.prompt_json->'subtopics'` — the author's prose written at
  authoring time. The topic *codes* here are unreliable (many match no CED topic); the *prose* is
  real signal.
- `app.topic_explainers.mini_example_question` and `app.topic_point_briefs` — each of the ~170
  topics carries a worked mini-example. Matching an item against these is **retrieval**, a
  different failure mode from classification — use it as a cross-check on your primary-topic pick.
- `app.content_taxonomy_labels.source_payload` — stored prior model runs (155 for Stats, 75 for
  Biology). Read them as one more prior, not as an answer.

### 2.4 Protocol and governance (read before labelling)
- `docs/architecture/TAXONOMY_LABELING_PLAN_V3_2026_08_04.md` — the labelling protocol, the
  serving/coverage split, the 89%/44% agreement measurements and the granularity failure mode.
  **Amendment for this run:** the new design needs **one primary topic per item**, not a topic
  *set*. Target primary-topic agreement, not set equality.
- `docs/research/AP_*_TAXONOMY_SERVING_LABEL_RUN_2026_08_05.md` — the executed serving-label runs
  (units), for method and format precedent.
- `docs/architecture/CONTENT_GOVERNANCE_AND_VALIDATION.md` — INV-3 and the double-approve rule.
  Nothing you produce is `validated`; it is a proposal for human ratification.
- `docs/product/CONTENT_GAPS_RUNNING_LIST.md` — where this work is tracked (GAP-1, GAP-2).

---

## 3. Task 0 — Inventory what already exists (do this first, before any labelling or drafting)

**You may not propose a single label or canonical answer until this inventory is produced.** Its
purpose is to guarantee you fill gaps rather than replace existing work.

For the in-scope set, enumerate and report, per subject and item type:

1. **Topic labels that already exist** — items with any `app.content_taxonomy_labels` row
   (`coverage` scope, non-empty `assessed_topics`), and their `label_status`. (Expected: 0 today,
   but re-verify — if any exist, they are **out of scope for new proposals** and are preserved.)
2. **Canonical answers that already exist** — FRQ with a non-blank `canonical_answer_1`
   (and `_2`). These are **reviewed only** in Task B, never redrafted.
3. **Prior model runs** — items with a `source_payload` in `app.content_taxonomy_labels` (a prior
   attempt to build on, not ignore): expected 155 Stats, 75 Biology.
4. **Author prose present** — items with a non-empty `prompt_json->'subtopics'`.
5. **Rubrics/criteria present** — FRQ with `public.frq_criteria` rows (do not modify).

**Output `inventory.csv`** (one row per item: `content_item_id, subject_key, item_type,
has_topic_label, has_canonical_answer_1, has_prior_model_run, has_author_prose, criteria_count`)
plus a short summary table. Task A operates only on items where `has_topic_label = false`; Task B
drafts only where `has_canonical_answer_1 = false`. Everything already present is preserved and, at
most, flagged.

## 4. Task A — Assign one primary unit:topic per item (only where none exists)

Operate **only on items with `has_topic_label = false`** from Task 0 (today: all of them). For
each such published Biology and Statistics item:

1. Read the stem (and, for MCQ, the choices/rationales; for FRQ, the criteria) to determine what
   the item actually assesses.
2. Select the single best **primary** `topic_code` from that subject's CED closed list (§2.2).
   Also record the `unit_number` it rolls up to.
3. Cross-check against the author prose (§2.3) and the explainer retrieval (§2.3). Note when they
   agree and when they diverge.
4. Emit a **confidence** (high / medium / low) and a one-line rationale in the language of the
   item. Where a second topic is a near-tie (the granularity failure mode from the v3 plan),
   record it as `alt_topic_code`.
5. **Never invent a topic.** If nothing in the closed list fits, mark `primary_topic_code = null`,
   confidence `low`, and explain — that item routes to a human.

**Output `topic_labels_proposal.csv`** (or JSONL), one row per item:

```
content_item_id, subject_key, item_type, primary_unit_number, primary_topic_code,
primary_topic_title, alt_topic_code, confidence, agreement_with_author_prose (yes/no/na),
agreement_with_explainer_retrieval (yes/no/na), rationale, needs_human (true/false)
```

Set `needs_human = true` whenever confidence is low, the two independent signals disagree with
your pick, or `primary_topic_code` is null.

---

## 5. Task B — Review each FRQ for a canonical answer (FRQ only)

Measured 2026-09-22: **46 of 80** AP Statistics FRQ and **7 of 75** AP Biology FRQ have a null or
blank `canonical_answer_1` — those are the gaps to fill. The rest already have canonical answers
and are **reviewed, never replaced**. For **every** published FRQ:

1. Report whether `canonical_answer_1` (and `_2` where the item is multi-part) is present and
   non-blank (carry this from Task 0's `has_canonical_answer_1`).
2. **Where present (gap already filled):** sanity-check it against the criteria
   (`public.frq_criteria`) — does the canonical answer earn the points the rubric describes? Flag
   mismatches for a human. **Do not edit, redraft, or replace it.**
3. **Where missing (the gap):** draft a proposed canonical answer that satisfies the rubric
   (correctness and rubric alignment are what matter). Mark it clearly as a **draft proposal for
   human approval**, never as final.
4. For multi-part FRQ, note whether parts are structured (`prompt_json->'parts'`) or prose-only
   in the stem — this affects how the canonical answer maps to parts.

**Output `frq_canonical_review.csv`** (or JSONL), one row per FRQ:

```
content_item_id, subject_key, canonical_answer_1_present (true/false),
canonical_answer_matches_rubric (yes/no/na), parts_structured (true/false),
proposed_canonical_answer (draft, only when missing), flags, needs_human (true/false)
```

---

## 6. Rules of engagement (do not violate)

- **Fill gaps; never replace.** Propose a label only where none exists; draft a canonical answer
  only where one is missing. Existing labels, canonical answers, rubrics, criteria and author
  prose are preserved. Wrong-looking existing content is **flagged for a human**, not overwritten.
- **Read-only against Production.** No `UPDATE`/`INSERT`/`DELETE` on any content, label, or answer
  table. Your deliverable is `inventory.csv`, the two proposal files, and the summary in §7.
- **Closed list only** for topics (§2.2). Invented topic strings were the exact failure the v3
  plan flagged; they are a hard reject here.
- **One primary topic per item.** A set is not the deliverable.
- **State every filter.** Any count in your summary carries its `WHERE`.
- **Escalate, do not guess.** Low-confidence or signal-conflict items get `needs_human = true`,
  not a forced label.
- **Do not touch the serving contracts.** You read the answer key for authoring; you do not
  propose relaxing `public.mcq_choices` or any grant (that boundary is protected by PR #106 and
  is unrelated to this task).

---

## 7. Summary to report back

- The Task 0 inventory summary (what already exists vs what is a gap), per subject and item type.
- Confirmed in-scope counts per subject and item type, with filters.
- Topic labels: number high / medium / low confidence; number `needs_human`; number where the
  two independent signals agreed with your primary pick (this is the primary-topic agreement rate
  the plan wants measured).
- FRQ canonical answers: present vs missing per subject; number of rubric mismatches flagged;
  number of drafts proposed.
- Any disagreements with the counts in this order.

---

## 8. QA stage — instructions for a second AI (run after the proposal is produced)

**You are a different model from the one that produced the proposal. Your job is to break it, not
to agree with it.** Do not read the first model's rationale before forming your own judgment on a
sampled item.

**Inputs:** `topic_labels_proposal.csv`, `frq_canonical_review.csv`, and the same source material
in §2 (read-only Production, the CED closed list, the items).

**Procedure:**

1. **Structural checks on 100% of rows.**
   - Every `primary_topic_code` is a real code in the subject's closed list
     (§2.2 `taxonomy_source_version`). Any code not in the list is a **hard fail**.
   - `primary_unit_number` matches the unit that topic rolls up to in `app.taxonomy_topics`.
   - No item in scope is missing from the proposal; no out-of-scope item is present.
   - Every low-confidence / null-topic / signal-conflict row has `needs_human = true`.
   - **Fill-not-replace check:** no proposal row targets an item that already had a topic label,
     and no drafted canonical answer targets an FRQ that already had a non-blank
     `canonical_answer_1` (cross-check against `inventory.csv` and live Production). Any such row
     is a **hard fail** — the pass overwrote existing content.

2. **Independent re-derivation on a random sample.** Draw a random **20%** per subject per item
   type (minimum 15 items per cell), stratified to include every confidence band. For each
   sampled item, independently pick the primary unit:topic from the closed list **without** looking
   at the proposal's choice, then compare.
   - Record primary-topic **agreement rate** and the disagreement mode (granularity vs genuinely
     wrong topic vs wrong unit).
   - Genuinely-wrong-topic or wrong-unit disagreements are defects; pure granularity splits are
     noted but not counted as defects.

3. **Canonical-answer audit on a random sample** (20% of FRQ, plus **every** proposed draft
   answer). For each: does the canonical answer (existing or drafted) actually earn the rubric's
   points in `public.frq_criteria`? A drafted answer that misses a required point is a defect.

4. **Estimate the error rate and bound it.** Report the observed defect rate per subject with a
   simple confidence interval, and compare against the human-escalation threshold the v3 plan's
   triage logic sets (or, if none is set for topics yet, recommend one from these numbers).

5. **Verdict.** For each subject and task, output **PASS** (defect rate within threshold; route
   only `needs_human` rows to a person), **PASS-WITH-FIXES** (list the specific rows to correct),
   or **FAIL** (systematic problem — name it; the labelling pass is re-run, not hand-patched).

**QA output:** `qa_report.md` with the sample sizes, the agreement/defect rates with filters,
the row-level defect list, the recommended human-escalation threshold, and the per-subject
verdicts. Do not write anything to the database. Nothing here becomes `validated` without the
double-approve human step (`CONTENT_GOVERNANCE_AND_VALIDATION.md`).
