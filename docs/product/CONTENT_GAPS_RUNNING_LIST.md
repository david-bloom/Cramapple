# Content Gaps — Running List

STATUS: living tracker | STARTED: 2026-09-22 | OWNER: unassigned

The standing list of **content** gaps between the published library and what the
rebuilt app needs to render and wire. This is the render-and-wire counterpart to
`APP_REBUILD_MIGRATION_PLAN.md`: the plan explains *why* each gap matters and the
serving surface it blocks; this list tracks *closing* it, item by item, and is
updated as work lands.

**How to use this file**
- One row per gap. Newest evidence wins; keep the filter behind every count.
- Every count is read-only against **Cramapple – Production**
  (`pcntajvbdfqhbeewmdry`) unless stated. State the `WHERE` behind any number.
- When a gap closes, move it to **§3 Closed** with the closing evidence, do not
  delete it.
- Do not solve a gap by weakening a security boundary (see GAP-7 and
  `APP_REBUILD_MIGRATION_PLAN.md` risk 3). Content gaps are closed with content
  and vetted labels, not by relaxing serving contracts.

---

## 1. Blocking gaps

### GAP-1 — Topic labels (unit:topic pairs) on published items
- **Scope:** **0 of 1,346** published items carry a topic label. Verified per
  subject: `ap-statistics` 0/384, `biology` 0/118 (filter: published
  `content_item_versions` LEFT JOIN `app.content_taxonomy_labels` on
  `content_item_id`, `label_scope='coverage'` with non-empty `assessed_topics`,
  2026-09-22).
- **Why it blocks:** breadcrumb, habits pair, reference pane, deep dive, progress,
  study map — and **Open Hand's shown item must be relevant to the unit:topic**
  (`APP_REBUILD_MIGRATION_PLAN.md` §4.2, §5.4). Six-plus surfaces dark until this
  closes.
- **Source material to run against:** `docs/architecture/TAXONOMY_LABELING_PLAN_V3_2026_08_04.md`
  (protocol), the executed serving-label runs in
  `docs/research/AP_*_TAXONOMY_SERVING_LABEL_RUN_2026_08_05.md`, and the CED
  closed lists in `app.taxonomy_topics` (Biology = 60 topics / 8 units,
  `taxonomy_source_version = c676d1fc-3b58-4896-89e3-852d9bd1f81b`; AP Statistics
  = 55 topics, `dae3c72e-82ca-4960-9552-1b034bd347e5`).
- **In-house second signals** (not a second CED-reading model):
  author prose in `content_item_versions.prompt_json->subtopics`, and the
  `mini_example_question` on each `topic_explainer` used as a retrieval target.
- **Note before buying a second source:** the v3 plan's 44% agreement measured
  *set equality* on `required_topics`; the new design needs **one primary topic**
  per item. Re-score the 15 stored model runs (`source_payload` in
  `app.content_taxonomy_labels`; 155 stored for Stats, 75 for Biology) for
  primary-topic agreement first (§6.2 of the plan).
- **Owner:** — · **Status:** OPEN · **First subjects in flight:** Biology, AP
  Statistics (see `prompts/CODEX_BIO_STATS_TOPIC_TAGGING_AND_FRQ_CANONICAL_REVIEW_2026_09_22.md`).

---

## 2. Non-blocking gaps

### GAP-2 — FRQ canonical answers missing on a tail of items
- **Scope (partial, Bio/Stats measured 2026-09-22):** `ap-statistics` **46 of 80**
  published FRQ have no `canonical_answer_1`; `biology` **7 of 75**. Filter:
  `content_item_versions status='published'`, `item_type='frq'`,
  `canonical_answer_1 IS NULL OR btrim(canonical_answer_1)=''`. **Full-library
  count across all ten subjects not yet run.**
- **Why it matters:** FRQ grading and the Open Hand sample answer read the
  canonical answer; a blank one weakens both. (`canonical_answer_1` is the FRQ
  field — it is *not* where MCQ correctness lives; that is `mcq_choices.is_correct`.)
- **Source material:** `docs/research/CONTENT_AUTHORING_AND_QA_PROTOCOL.md` and the
  double-approve review path (`CONTENT_GOVERNANCE_AND_VALIDATION.md`).
- **Owner:** — · **Status:** OPEN · **In flight:** Bio/Stats, in the Codex prompt above.

### GAP-3 — `rubric_type` missing on a tail of items
- **Scope:** 92 AP Statistics MCQ, 14 AP Statistics FRQ, 1 AP Biology FRQ
  (`APP_REBUILD_MIGRATION_PLAN.md` §8.2 — re-verify count before working).
  Mechanical / schema-level.
- **Owner:** — · **Status:** OPEN.

### GAP-4 — Multi-part FRQ inconsistently modelled
- **Scope:** of 563 published FRQ, **168 carry structured `prompt_json.parts`**;
  **323 carry parts only as prose** in the stem (plan §8.4). Longest stem 2,205
  chars. Any per-part design implies a content migration or a parser — a
  deliberate choice (decision 11).
- **Owner:** — · **Status:** OPEN, decision-gated.

### GAP-5 — Stimulus-image plate treatment
- **Scope:** 6 published Biology FRQ carry a `stimulus_image_path`
  (`content_asset_metadata` + signed URLs exist; no plate treatment). Ties to
  decision 1 (fixed frame). Plan §8.3.
- **Owner:** — · **Status:** OPEN, design-gated.

### GAP-6 — Item-package payload coverage
- **Scope:** 203 of 1,346 items carry an `item_package_payload` (all AP
  Statistics MCQ); the other 1,143 serve from relational columns (plan §5.5,
  decision 23). Backfill vs dual-read adapter — a decision, not an accident.
- **Owner:** — · **Status:** OPEN, decision-gated.

### GAP-7 — Practice feedback never emits the authored rationale (wiring, not content)
- **Scope:** the authored per-choice rationale exists on all 783 MCQ but
  `evaluate-attempt` returns a generic line; only `public.get_chosen_distractor_rationale`
  emits it (plan §5.3). Small, well-bounded wiring change. **Not** to be solved
  by relaxing `mcq_choices` (that is the same boundary Open Hand's decision 21
  respects).
- **Owner:** — · **Status:** OPEN.

### GAP-8 — Nothing in the library is `validated`
- **Scope:** every label/item sits at `provisional_model`, `legacy_unvalidated`
  or `published`, never `validated` (plan §8.5). Whether that gates a beta launch
  is a **governance decision** (decision 24), not engineering.
- **Owner:** — · **Status:** OPEN, decision-gated.

---

## 3. Closed

_None yet._

---

## 4. Sources

- `docs/product/APP_REBUILD_MIGRATION_PLAN.md` — §5 (wiring), §6 (labelling), §8
  (content gaps), §11 (decisions 21–25).
- `docs/architecture/TAXONOMY_LABELING_PLAN_V3_2026_08_04.md` — labelling protocol.
- `docs/architecture/CONTENT_GOVERNANCE_AND_VALIDATION.md` — INV-3, double-approve.
- `docs/research/CONTENT_AUTHORING_AND_QA_PROTOCOL.md` — authoring + QA.
