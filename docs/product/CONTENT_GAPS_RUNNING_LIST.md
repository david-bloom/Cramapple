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
- **Source material:** `docs/research/CONTENT_AUTHORING_AND_QA_PROTOCOL.md`. Human
  double-review is **paused** (DECISION-0055); the gate is now AI cross-model QA +
  Product Owner approval.
- **Two more requirements surfaced 2026-09-22 (see GAP-9):** a canonical answer must
  also be (a) **criterion-segmented** into rubric-tagged spans for Open Hand, and
  (b) actually **aligned to its rubric** — many are not.
- **Owner:** — · **Status:** OPEN · **In flight:** Bio/Stats, in the Codex prompt above.

### GAP-9 — Biology FRQ canonical answers are misaligned with their rubrics; Open Hand needs criterion-segmented answers
- **What this is:** the Open Hand plate needs each FRQ's full-point answer
  **segmented into criterion-tagged spans** (`creditedResponse` shape) so deselecting
  a rubric point strikes the span that earns it. Producing that segmentation for the
  75 published Biology FRQ exposed that the stored canonical answers are substantially
  misaligned with their stored rubrics.
- **Evidence (read-only Production, 2026-09-22; full QA record in
  `docs/research/apbio_frq_segmentation_2026_09_22/`):**
  - **118 of 278 rubric criteria (42%) had no answer text** in either
    `canonical_answer_1` or `canonical_answer_2` and had to be freshly drafted.
  - **18 items had *every* criterion drafted** — the stored answers do not match the
    item's rubric at all (e.g. `APBIO-FRQ-S-021`).
  - **15 items carry a `canonical_answer_2` that satisfies no stored criterion**
    (off-rubric text, preserved as uncredited context).
  - **9 items** have `prompt_json.total_points = 8` but a rubric summing to **9**
    (`APBIO-FRQ-L-004/006/012/013/015/016/017/019/021`) — a points data bug.
  - **4 drawn-graph items** (`APBIO-HDG-2026-GRAPH-002/003/008/010`) need a spatial
    canonical; text cannot be a full-credit answer.
  - **7 items** have no canonical answer at all (fully drafted, highest risk).
  - Two independent AI runs (Codex + Claude) agree on the fix and the worst items, so
    this is a real content-integrity issue, not a model artifact.
- **Status of the segmentation mechanic:** ACCEPTED for Biology (DECISION-0055 gate) —
  the `canonical_answer_2` reuse fix is verified; all 52 ca2 items reuse it verbatim,
  75/75 exact concatenation. The **drafted answer content is the open work**, not the
  segmentation.
- **Action:** author/reconcile the misaligned Biology canonical answers to their
  rubrics (the 118 drafted criteria, 18 all-drafted items, 15 off-rubric ca2, 7
  no-canonical), fix the 9 point-total mismatches, and route the 4 drawn-graph items to
  the spatial-canonical / Engine-4 path. Then extend the segmentation to the other
  subjects. Gate: AI cross-model QA + Product Owner approval (DECISION-0055).
- **Owner:** — · **Status:** OPEN · **In flight:** Biology segmented + QA'd; drafted
  content awaits Product Owner sign-off.

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
- **Decision landed (`D8`, `ARCHITECTURE_AND_DESIGN_DECISIONS_CURRENT.md`):** cheap render-time parser
  stopgap (`src/lib/frq-prose-parts.ts`, TASK-0047 Workstream B, commit `c52c3fd6`), not a content
  migration. No longer decision-gated for that reason — tracked open now only for the bug below.
- **Bug found + fixed, 2026-09-27:** the parser silently dropped any text after the last labeled
  `(a)/(b)/(c)` block — a closing instruction like "Justify your answer using the data above." never
  reached the student, a real scoring-fairness defect (reported by David from a Lovable error surface).
  Root cause: the function computed the preamble before the first label but never captured anything
  after the last one. Fixed by appending trailing blocks to the last part's body instead of discarding
  them, with a new regression test. Sent to Lovable 2026-09-27 (see `LAUNCH_PLAN_STUDENT_HUB_2026_09_26.md`
  for the outcome once verified) — this repo's own copy of the parser (none exists here; the file lives
  only in the Lovable frontend) was not touched, so this fix is Lovable-only.
- **Owner:** — · **Status:** OPEN pending verification of the trailing-text fix; otherwise the parser
  stopgap itself is considered shipped and working as decided.

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

### GAP-10 — Mastery cells missing a servable MCQ or FRQ (blocks `DECISION-0074`)
- **Renumbered 2026-09-27 (new session):** this entry collided with the pre-existing GAP-9 above
  (Biology FRQ canonical-answer/rubric alignment, 2026-09-22) — two unrelated gaps had the same ID.
  Renumbered this one to GAP-10 (the next unused number); the launch plan doc's own "GAP-9 measured"/
  "GAP-9 remediation" section headers still say GAP-9 in their prose and haven't been renamed, but they
  are this same finding — cross-reference by content/date, not the old number, until that doc is touched
  again for another reason.
- **Measured 2026-09-27 (first pass, before `DECISION-0079` promotion):** **0 masterable cells in both
  Statistics and Biology.** Root cause was labeling, not content — see the launch plan doc's "B. GAP-9
  measured" section (pre-renumbering title, same finding).
- **Re-measured 2026-09-27, after `DECISION-0079` promoted all 293 `provisional_model` labels to
  `validated`:** still **0 masterable cells** in both subjects — the promotion did not close this gap
  (an earlier same-day query that didn't filter on `skill_code IS NOT NULL` briefly suggested otherwise;
  corrected before recording here). Precise root cause, confirmed directly against Production:
  - **Every FRQ in both subjects — all 80 Statistics FRQs, all 75 Biology FRQs — is topic-only
    (`content_item_cells.skill_code IS NULL`).** Zero FRQs anywhere carry a skill-level label. This is
    true of the newly-promoted rows too, not just the original `authored` set — promoting `provisional_model`
    → `validated` made these rows visible to `content_item_topic_resolution`, but visibility doesn't
    manufacture a skill code that was never assigned.
  - **Statistics** has 11 topic×skill cells with a skill-coded MCQ (10 cells with 20 MCQs each, 1 with
    3), all with **zero** skill-coded FRQ — `mcq_n >= 2 AND frq_n >= 1` is false for all 11.
  - **Biology** has zero skill-coded cells of any kind (matches `taxonomy_cells` being empty for the
    subject — see `docs/product/LAUNCH_PLAN_STUDENT_HUB_2026_09_26.md`'s "GAP-9 remediation" note,
    pre-renumbering title, same finding as this GAP-10).
- **Why it blocks:** unchanged — a cell short an FRQ (or MCQ) makes mastery permanently unreachable
  under `DECISION-0074`, not just slower.
- **Remediation needs two content-authoring passes, neither is an engineering backfill:**
  1. Skill-label the FRQs in both subjects (today they carry a topic only).
  2. Author Biology's `app.taxonomy_cells` topic×skill grid from scratch (currently 0 rows; every
     subject except Statistics is 0 — Statistics' own 131-row grid is the only precedent to follow).
- **Owner:** — · **Status:** OPEN, measured twice, root cause fully diagnosed. Accepted by David as a
  temporary gap for content authoring to close, not a rule-design flaw.

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
