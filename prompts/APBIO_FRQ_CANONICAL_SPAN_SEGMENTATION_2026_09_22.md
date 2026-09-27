# Work Order — Segment AP Biology FRQ Canonical Answers Into Criterion-Tagged Spans

DATE: 2026-09-22 | SUBJECT: **AP Biology only** (`subject_key = 'biology'`)
AUDIENCE: an AI content author (Codex, Gemini, or any model — this file is model-neutral)
MODE: **Proposal only — no writes to published content.** Read-only against Production; return
files for review; a second AI (or a second run of this same file) QAs and is compared.

---

## 0. Why this exists, in one paragraph

Open Hand teaches an FRQ by showing the full-point answer with **each rubric criterion mapped to
the span of the answer that earns it**. When a student deselects a criterion, that span strikes
through and the answer visibly becomes a lower-scoring answer. This needs one thing per FRQ that
the library does not have yet: the canonical answer **segmented into criterion-tagged spans**
(the `creditedResponse` shape). Your job is to produce that segmentation for every published AP
Biology FRQ — reusing the existing canonical answer where one exists, drafting only what is
missing, and flagging anything a human must check.

This is **authoring-time, governed** work. You propose; a human ratifies (INV-3 / double-approve).
You never write to the database and you never generate at student-runtime.

---

## 1. Scope

Every **published AP Biology FRQ**: the **75 distinct items that have a `status='published'`
version**. Filter `public.content_item_versions` by `status='published'`, `subject_key='biology'`,
`item_type='frq'`, and take the **latest published version** per `content_item_id`. Of the 75,
~68 already have a `canonical_answer_1` and ~7 do not (verify the live counts yourself and report
them). MCQ are out of scope — Open Hand MCQ is a different mechanic.

**Scope note (reconciled 2026-09-22, read-only Production).** There are **157** Biology FRQ
`content_item` rows in total and **246** versions across them, but only **75** items carry a
published version. `public.content_item_versions` is a **view that exposes all 246 versions**, so
an unfiltered count reads 157/246 — that is why an earlier all-status pass saw 157. This work
order is **published-only (75 items)**: Open Hand serves published content, and the other 82
unpublished/draft items are out of scope until they are published. If a count you get is not 75,
you have not filtered to `status='published'` + latest version — do that, do not expand scope.

---

## 2. Where to find each input (read-only, Production `pcntajvbdfqhbeewmdry`)

Use the **latest published version** per `content_item_id`.

### 2.1 The question
`public.content_item_versions` — `content_item_id`, `id` (the version id),
`stem` (the question text; AP Biology carries parts as prose here, e.g. "(a) … (b) …"),
`stimulus` (extra stimulus text, may be null), `stimulus_image_path` (a figure reference, may be
null), `frq_form` (`short`/`long`), `prompt_json` (metadata: `modules`, `subtopics`, `total_points`).

### 2.2 The existing canonical answer(s) — read BOTH fields first
`public.content_item_versions.canonical_answer_1` **and `canonical_answer_2`** on that same latest
published version. **Both are vetted existing content and both must be reused.** On AP Biology,
`canonical_answer_2` is not an alternate answer — it is typically the **answer to a later part** of
a multi-part question (e.g. `canonical_answer_1` answers part (a), `canonical_answer_2` answers
part (b)). Treat `canonical_answer_1` + `canonical_answer_2` together as the **single existing
answer corpus**.

**Do not draft content for a criterion until you have checked whether either field already answers
it.** If a criterion's answer is present in `canonical_answer_1` or `canonical_answer_2`, segment
that existing text verbatim — never generate a fresh paraphrase of content that already exists.
Draft new text **only** for criteria that *neither* field covers.

### 2.3 The rubric components
`public.frq_criteria`, joined on `content_item_version_id` (= the version's `id`). Per criterion:
`criterion_key`, `learner_facing_text` (what the point is for), `points_possible`,
`evidence_requirements` (what earns it), `minimum_fix`, `accepted_variants` (jsonb). **These are
the criteria your spans must map to, one-to-one-or-more.**

### 2.4 The CED, for meaning only
`docs/teaching/ap-biology-course-and-exam-description.pdf` — consult when a criterion's intent is
ambiguous. It never adds a rubric point that `frq_criteria` does not list.

---

## 3. What to produce per FRQ

For each item, build a **self-contained record** carrying the question, the rubric, the canonical
answer, and your segmentation — so the same record can be handed to another AI and the results
compared. Two files (§4):

- a **packet** (question + rubric + existing canonical answer) — the shared input, identical for
  every model; and
- a **segmentation** (the packet plus your `credited_response`) — the part that differs per model
  and is compared.

### 3.1 The segmentation rules
1. **Every criterion maps to at least one span.** A span is a contiguous slice of the answer text
   tagged with one `criterion_key`.
2. **Connective words carry no criterion** (`criterion_key: null`) and are always shown. Literal
   punctuation is marked `literal: true`.
3. **Concatenating all spans' `text` in order must equal the full-point answer verbatim**, and
   that answer must read coherently.
4. **Removing any one criterion's span(s) must leave a coherent lower-scoring answer** — this is
   the whole point; check it.
5. **Follow rubric granularity.** A 2-point AP Biology criterion may own a multi-sentence span;
   do not invent finer criteria than `frq_criteria` lists.
6. **Reuse, don't rewrite — from BOTH `canonical_answer_1` and `canonical_answer_2`.** If either
   field already covers a criterion, segment its actual words. Draft new text only for criteria
   that *neither* field covers, and mark those spans as drafted. Re-paraphrasing content that
   already exists in `canonical_answer_2` is the specific failure this rule prevents. Assemble
   `full_text` as the complete answer in question order (part-a text, then part-b text, then any
   drafted gap spans in their proper place).
7. **Never invent a rubric point**, never relax any serving contract, never write to the DB.

### 3.2 When the combined existing answer is incomplete
First assemble the existing corpus from **both** `canonical_answer_1` and `canonical_answer_2`
(§2.2). Then, and only then, judge coverage:
- If `canonical_answer_1` + `canonical_answer_2` together cover **every** criterion: segment both
  verbatim, `source: "existing"`, nothing drafted.
- If together they cover only some criteria: segment what exists, **draft the minimal span(s)**
  for the criteria *neither* field covers, `source: "completed"`, list the uncovered criteria in
  `coverage.uncovered_by_existing_answer`, `needs_human: true`.
- If neither field exists at all: draft the whole answer, `source: "drafted"`, `needs_human: true`.

Record in `coverage` which criteria came from `canonical_answer_1`, which from
`canonical_answer_2`, and which were drafted, so a reviewer can see the provenance of every span.

---

## 4. Where to store / return it (single source of truth)

Working directory: **`docs/research/apbio_frq_segmentation_2026_09_22/`** (create it).

| File | Contents |
| --- | --- |
| `apbio_frq_packets.jsonl` | one record per FRQ: the shared input (question + rubric + existing canonical answer). **This is the file to hand to multiple AIs.** |
| `apbio_frq_segmentation.<model>.jsonl` | the packet fields **plus** your `credited_response`, `canonical_answer`, `coverage`, `flags`, `needs_human`. Name it with your model, e.g. `.codex.jsonl`, `.gemini.jsonl`, so runs can be compared side by side. |
| `SUMMARY.md` | counts (below), and anything that disagrees with this order. |

### 4.1 Packet record (shared input)
```json
{
  "content_item_id": "…",
  "content_item_version_id": "…",
  "subject_key": "biology",
  "frq_form": "short|long",
  "total_points": 4,
  "question": { "stem": "…", "stimulus": null, "stimulus_image_path": null },
  "rubric": [
    { "criterion_key": "a", "points_possible": 2,
      "learner_facing_text": "…", "evidence_requirements": "…", "minimum_fix": "…" }
  ],
  "existing_canonical_answer": { "canonical_answer_1": "…|null", "canonical_answer_2": null, "present": true }
}
```

### 4.2 Segmentation record (your output — packet plus these fields)
```json
{
  "…": "all packet fields above, unchanged",
  "canonical_answer": {
    "source": "existing | completed | drafted",
    "full_text": "the full-point answer = concatenation of all spans' text, in order"
  },
  "credited_response": [
    { "text": "…", "criterion_key": "a" },
    { "text": " ", "literal": true },
    { "text": "…", "criterion_key": "b" }
  ],
  "coverage": {
    "every_criterion_has_span": true,
    "uncovered_by_existing_answer": ["b"],
    "spans_concat_equals_full_text": true,
    "notes": "existing canonical answer covered only criterion a; criterion b span drafted"
  },
  "flags": [],
  "needs_human": true
}
```

---

## 5. Summary to report back (`SUMMARY.md`)

- Live counts: published Biology FRQ; how many had `canonical_answer_1`; how many had
  `canonical_answer_2`; how many criteria were covered by reusing `canonical_answer_1`, by reusing
  `canonical_answer_2`, and how many required drafting; how many items were `existing` /
  `completed` / `drafted`.
- How many records have `needs_human: true`, and why (drafted content vs coverage gap vs ambiguity).
- Any item where `frq_criteria` is empty or the parts/points don't add up — flag, don't guess.
- Any disagreement with the counts or assumptions in this order.

---

## 6. Worked example (real item — illustrative, not a substitute for reading the live data)

**Item `ee3aa8b2-c996-4f32-aad4-27cd68568a42`.**
Stem: *"Answer all parts… (a) Explain, in terms of fatty acid tail structure, why Bilayer B is more
fluid than Bilayer A at the same temperature. (b) Explain how the presence of cholesterol affects
membrane fluidity in each bilayer at 20°C versus 40°C."*
Rubric: `a` (2 pts, "Explain why unsaturated fatty acids increase membrane fluidity"), `b` (2 pts,
"Explain the role of cholesterol in maintaining membrane fluidity across a range of temperatures").
Existing `canonical_answer_1`: *"Unsaturated fatty acid tails have kinks from double bonds,
preventing tight packing and keeping the membrane fluid at lower temperatures."*

Note the gap: the existing answer covers **only criterion a**; there is nothing about cholesterol.
So: segment the existing sentence under `a`, **draft** a `b` span, mark `source: "completed"`,
`uncovered_by_existing_answer: ["b"]`, `needs_human: true`. Illustrative segmentation:

```json
"credited_response": [
  { "text": "Unsaturated fatty acid tails have kinks from double bonds, preventing tight packing and keeping the membrane fluid at lower temperatures.", "criterion_key": "a" },
  { "text": " ", "literal": true },
  { "text": "Cholesterol buffers fluidity across temperature: at 40°C it restrains phospholipid movement and lowers fluidity, and at 20°C it prevents tight packing and preserves fluidity.", "criterion_key": "b" }
]
```
(The `b` sentence is a drafted proposal for human approval, not authoritative content. This item
has **no** `canonical_answer_2`, so drafting `b` is correct here.)

**Contrast — item `APBIO-FRQ-S-007`, where `canonical_answer_2` already holds the answer.**
Rubric: `a` (Punnett square + 3:1 ratio), `b` (state the principle of segregation).
`canonical_answer_1` = *"Aa × Aa gives a 3 purple : 1 white … 25% white."* (part a).
`canonical_answer_2` = *"This follows the law of segregation: during meiosis I the two alleles
separate so each gamete gets only one allele of the gene."* (part b). **Criterion `b` is already
answered in `canonical_answer_2`.** The correct output segments `canonical_answer_2` verbatim under
`b` — it does **not** draft a fresh sentence about segregation. `source: "existing"` (both criteria
covered by existing text); nothing drafted. Generating a new `b` sentence here, while ca2 sits
unused, is the exact error this work order now forbids.

---

## 7. QA / comparison stage — for a second AI, or a second run of this same file

The point of a self-contained packet is that **the same input can be graded by more than one
model and the results compared.** Two ways to use it:

**A. Independent second run.** Give `apbio_frq_packets.jsonl` to a different model with §3's rules.
It writes `apbio_frq_segmentation.<other-model>.jsonl`. Compare the two per item.

**B. Adversarial QA.** A second AI reads the packets and a segmentation file and, **without
editing it**, writes findings.

Either way, the reviewer **never modifies another model's file** — it only points at potential
problems, each **flagged with an explanation**, for a human to investigate. Checks:

1. **Structural (100% of records):** every criterion has ≥1 span; `spans_concat_equals_full_text`
   is actually true (recompute it); connective/literal spans carry no criterion; no criterion
   invented beyond `frq_criteria`.
2. **Coherence:** removing each criterion's span(s) in turn still reads as a coherent, lower-scoring
   answer.
3. **Earns-the-point:** each span (especially drafted ones) actually satisfies that criterion's
   `evidence_requirements`. A drafted span that misses the requirement is a finding.
4. **Reuse fidelity:** where a canonical answer already existed, its wording was segmented, not
   silently rewritten.
5. **Cross-model comparison (mode A):** per item, do the two models tag the same criterion to
   roughly the same span? Record agreement and, for each disagreement, which model's mapping better
   satisfies the rubric — as a flag with explanation, not a fix.

**QA output — new files in the working directory, never edits to any segmentation file:**

- `qa_findings.csv`: `finding_id, target_file, content_item_id, criterion_key, issue_type
  (missing_span | concat_mismatch | incoherent_on_removal | span_misses_requirement |
  existing_answer_rewritten | invented_criterion | cross_model_disagreement | other),
  severity, explanation, suggested_investigation`
- `qa_report.md`: counts, structural pass/fail rates, cross-model agreement rate, and an overall
  recommendation (accept, investigate listed rows, or reconsider the run). No verdict overwrites
  the author's file; the human decides.

Write nothing to the database. Nothing becomes `validated` without the double-approve human step
(`docs/architecture/CONTENT_GOVERNANCE_AND_VALIDATION.md`).
