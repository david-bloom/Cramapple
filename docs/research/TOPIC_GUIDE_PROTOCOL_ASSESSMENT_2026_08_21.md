# Assessment: Topic Briefs and Learn More Production Protocol

**Date:** 2026-08-21
**Document under assessment:** `docs/product/TOPIC_BRIEFS_AND_LEARN_MORE_PRODUCTION_PROTOCOL.md`
**Version assessed:** the pre-revision draft authored in the Codex worktree
`/Users/davidbloom/.codex/worktrees/6645/Cramapple.nosync` (349 lines, untracked, at commit `95dd47f`).
**Method:** Static read of the protocol against (a) the migrations that define
the objects it governs, (b) the checked-in QA script, (c) the Lovable wiring
prompt that defines the frontend contract, and (d) read-only SQL against the
Production Supabase project `pcntajvbdfqhbeewmdry`. No writes were made to any
environment. Every quantitative claim below is a live Production query result
captured on 2026-08-21.
**Outcome:** protocol revised in place (see §5). Two items are left open as
follow-ups because they are data/code fixes, not protocol fixes.

---

## 1. Verdict

**PASS ON PLUMBING, FAIL ON CONTENT.**

The protocol is a competent release-engineering document. Its treatment of
routing, RLS, pairing, orphan detection, rollback, and release evidence is
accurate against the real schema and would catch real defects. Live Production
data confirms the plumbing rules are being followed: zero briefs outside the
taxonomy, zero unit mismatches against the taxonomy, zero `practice_*`
mismatches, zero `learn_more_path` subject/unit mismatches, zero orphans in
either direction.

It fails at the thing it is named for. Nothing in the protocol verifies that a
brief is **factually correct** or **CED-aligned**, and its one authoring escape
hatch (§3, generated-from-brief explainers) has already produced a `Learn more`
surface that is, for 96% of published topics, a verbatim restatement of the card
the student just read. The protocol as drafted would pass that content.

---

## 2. What the protocol got right

Verified accurate against the migrations and Production:

- RPC name, signature, and authenticated-only grant
  (`public.get_topic_point_guides(text, integer, text)`; `revoke ... from public, anon`).
- Table names, and all 16 brief / 14 explainer required fields exist and are
  `not null` in `app.topic_point_briefs` / `app.topic_explainers`.
- The camelCase payload claim, and the `learnMorePath` / `practiceParams`
  presence claim, both match the RPC's `jsonb_build_object` and the contract in
  `prompts/LOVABLE_TOPIC_BRIEFS_LEARN_MORE_WIRING_2026_08_21.md`.
- The anon-lockout and authenticated-execute claims match the grants.
- The AP Biology 1.1 smoke string is real: `Water is a polar molecule` appears
  verbatim at
  `supabase/migrations/20260820192400_student_readable_taxonomy_and_topic_guides.sql:662`.
- The "prefer the RPC over direct table reads" instruction is correct — the RPC
  is the only surface that normalizes subject keys and returns the pair together.

---

## 3. Accuracy findings (protocol vs. the real system)

### A1 — The stated pairing key is wrong (fixed in revision)

The protocol paired briefs and explainers on `subject_key` + `unit_number` +
`topic_code`. The actual uniqueness constraint on both tables is
`(subject_key, topic_code)`. `unit_number` is unenforced and may silently
disagree between a brief and its explainer. Because the RPC filters *both*
arrays by `_unit_number`, a drifted pair returns a brief with no explainer for a
unit-scoped call — the exact "Learn more goes nowhere" symptom. §4's row-agreement
checklist omitted `unit_number`.

Production is currently clean: `brief_explainer_unit_mismatch = 0`.

### A2 — The `app.subjects` active gate was undocumented (fixed in revision)

RLS on both tables requires an **active** row in `app.subjects` whose normalized
key matches the content's canonical key
(`supabase/migrations/20260820213000_fix_topic_guide_subject_key_normalization.sql:34`).
A fully reviewed, published, correctly routed brief for a subject that is not
`status = 'active'` in `app.subjects` is invisible to every student. No step in
the protocol mentioned this precondition, and only §8's phrasing ("to
authenticated users") would have caught it, by accident and without explanation.

Production is currently clean: `briefs_without_active_subject = 0`.

### A3 — No allowed values or formats were given (fixed in revision)

The Required Fields lists named columns but no constraints. The DB enforces:

- `class_importance`, `exam_importance` ∈ `not-important | somewhat-important | very-important`
- `status` ∈ `draft | published | retired`
- `topic_code`, `practice_topic_code` match `^[0-9]+\.[0-9]+$`
- `learn_more_path` matches `^/learn/`, and by established convention uses the
  **hyphenated** subject (`/learn/ap-biology/unit-1/...`) while `subject_key` is
  **underscored** (`ap_biology`)
- `status = 'published'` if and only if `published_at is not null`

An author working from the protocol alone writes rows the database rejects.

### A4 — The dual subject-key contract was undocumented (fixed in revision)

`public.get_topic_point_guides` returns the canonical underscored `subjectKey`.
The public views return the **hyphenated registry** key as `subject_key`, plus a
separate `canonical_subject_key` column
(`supabase/migrations/20260821013516_topic_guide_views_emit_registry_subject_keys.sql`).
§8 instructed the reader to check both surfaces without saying they disagree by
design.

### A5 — §8's count checks have no source of truth, and the automated check is already stale (open follow-up)

`scripts/qa/topic_guides_database_qa.sql:77` hard-codes an expectation of **306**
published briefs and 306 published explainers. Production holds **365** of each.
The script was last touched in commit `a3a97c3`; three later commits added the 59
BC-owned duplicates. **The checked-in QA script fails against Production today.**
The protocol had no rule requiring the automated expectations to move with the
batch. The rule is added in the revision; the script itself is left for a
separate change (see §6).

### A6 — Rollback depended on an artifact no step produced (fixed in revision)

The Rollback section offers "restore prior row values from a captured
before-state", but neither §5 nor §7 required capturing one.

### A7 — "Orphan" was undefined (fixed in revision)

§6 required "zero orphan point briefs" without saying whether orphan means
"missing its explainer" or "missing from the approved taxonomy". Both senses
appear elsewhere in the document.

### A8 — `published_at` semantics unspecified (fixed in revision)

The established seed pattern does `published_at = excluded.published_at` on
conflict, so re-running an idempotent migration overwrites the original
publication timestamp. The protocol said only "set `published_at` for published
rows".

---

## 4. Quality findings (process design)

### Q1 — There was no accuracy review at all (fixed in revision)

§4 checked originality, IP exposure, routing, and pairing. It never asked *is
this true, and is it what the CED actually says?* The grounding artifacts already
exist in the repository — `docs/product/AP_*_CED_FACT_PACK.md`, ten of them,
including topic-level Learning Objectives and Essential Knowledge — and the
protocol referenced none of them by path. §2's "Cramapple-approved source facts"
was the only hook and was bound to no file.

For an AI-authored corpus this conflates *original* with *correct*. Originality
protects Cramapple from a copyright claim; it does nothing for the student.

### Q2 — §3 contradicted §4, and the contradiction is load-bearing (fixed in revision)

§3 permitted generated-from-brief explainers provided the text "remains
**subject**-specific". §4 required point-attainment language be
"**topic**-specific". §3's weaker bar is the one that ran, via
`supabase/migrations/20260821030100_seed_topic_learn_more_explainers_from_briefs.sql`,
which interpolates the topic title into per-subject sentence templates.

Measured over all 365 published explainers in Production:

| Metric | Value |
| --- | ---: |
| `core_idea` byte-identical to the paired brief's `what_it_is` | **349 / 365 (96%)** |
| Distinct `weak_answer` strings | **22** |
| Rows sharing the single most common `weak_answer` | **150** (spanning 2 subjects) |
| Distinct `mini_example_question` 60-character prefixes | **78** |
| Distinct `point_attaining_answer` | 306 |
| Distinct `practice_bridge` | 306 |

The most-shared weak answer, on 150 rows: *"I would write the final value or
conclusion without showing why it follows."*

The mini-example is frequently not a question about the subject at all. AP
Biology 1.1, live in Production:

> *"A free-response prompt asks you to explain an observed biological pattern
> using Structure of Water and Hydrogen Bonding. What should your answer make
> explicit?"*

That is a meta-question, and title interpolation makes it ungrammatical. Compare
the 16 hand-authored AP Calculus AB Unit 1 explainers, which are genuinely
topic-specific:

> *"A car position is measured near t = 4. What does speed at exactly t = 4 mean?"*

The protocol as drafted could not tell these two tiers apart.

### Q3 — No distinctness check anywhere (fixed in revision)

Nothing in §4, §6, or §8 would surface 150 identical weak answers. A
`count(distinct ...)` assertion would have caught it on the first batch.

### Q4 — `source_note` is not doing its job (fixed in revision; data debt open)

§5 required a source note when content is "copied, generated from another row,
repaired, or moved". The BC copy and move batches complied — 59 rows carry
`Duplicated from ap_calculus_ab ...` and 4 carry `Moved from ap_calculus_ab ...`.
The 302 template-generated explainers carry only the default
`cramapple-authored`, making them indistinguishable from hand-authored work at
the row level. §3's "record that method in the batch note" was satisfied in prose
only.

### Q5 — Standards were unmeasurable (fixed in revision)

"Concise enough for a topic card" with no budget. Actual Production spread:

| Field | Min | Mean | Max |
| --- | ---: | ---: | ---: |
| `what_it_is` | 64 | 170 | **734** |
| `why_it_matters` | 67 | 144 | 430 |
| `answer_move` | 54 | 157 | 458 |
| `core_idea` | 64 | 168 | **734** |
| `point_attaining_answer` | 62 | 367 | **988** |

"Enough instruction", "usable", and "richer" were similarly unfalsifiable — a
reviewer could not fail a row against them.

### Q6 — No separation of duties and no review artifact (fixed in revision)

Author, Learning Quality reviewer, and Product Owner are three named roles held
by one person. The protocol required approval but defined no artifact for it: no
reviewer field, no sign-off record, no schema column. Meanwhile
`docs/product/CONTENT_OPERATIONS_ADJUDICATION_RELEASE_DESIGN.md` already
specifies qualification records, calibration, adjudication, release candidates,
and manifest comparison for question content. The protocol invented a lighter
parallel process and never referenced it.

### Q7 — Undocumented pair divergence (fixed in revision)

15 explainers differ from their brief on `answer_move`; 16 differ on
`common_point_loss`. §4 permitted divergence "unless a documented reason exists".
Inspection shows the divergences are benign shortenings inside the hand-authored
AP Calculus AB Unit 1 batch — for example brief *"Ask: over an interval or at one
point? If it is at one point, describe the instantaneous rate as the value
approached by average rates over smaller intervals."* against explainer *"Ask
whether the change is over an interval or at one point."* No reason is recorded
anywhere, so the rule was unenforceable as written.

### Q8 — Coverage was not tracked (fixed in revision)

365 published briefs against ~603 topics in the latest verified taxonomy version
per subject. `public.get_student_taxonomy` already emits `hasPointBrief` and
`hasExplainer` per topic, so the data to report this exists and was unused.

| Subject | Taxonomy topics | Published briefs | Coverage |
| --- | ---: | ---: | ---: |
| AP Biology | 60 | 60 | 100.0% |
| AP Calculus AB | 81 | 81 | 100.0% |
| AP Calculus BC | 111 | 85 | 76.6% |
| AP Statistics | 55 | 40 | 72.7% |
| AP Precalculus | 44 | 29 | 65.9% |
| AP Physics C: E&M | 31 | 10 | 32.3% |
| AP Physics 2 | 46 | 14 | 30.4% |
| AP Chemistry | 91 | 26 | 28.6% |
| AP Physics C: Mechanics | 41 | 10 | 24.4% |
| AP Physics 1 | 43 | 10 | 23.3% |
| **Total** | **603** | **365** | **60.5%** |

---

## 5. What changed in the protocol

The protocol was revised in place on `main` at
`docs/product/TOPIC_BRIEFS_AND_LEARN_MORE_PRODUCTION_PROTOCOL.md`. Substantive
changes:

1. **New lifecycle step 2, "Ground The Content"** — authoring must cite the
   subject's `AP_*_CED_FACT_PACK.md` section per topic, and a new step 5,
   "Accuracy Review", is a distinct gate ahead of the originality/routing review
   (now step 6).
2. **The generated-from-brief escape hatch closed** — generated-from-brief explainers must now be
   topic-specific, must carry `source_note = 'generated-from-brief'`, and must
   have a distinct mini-example. The "subject-specific" wording is gone.
3. **New "Machine-Checkable Acceptance Criteria" section (C1–C11)** — distinctness floors,
   `core_idea <> what_it_is`, brief/explainer `unit_number` equality, and field
   length budgets, each expressed as a query the QA script can run.
4. **Database Contract section added** — enums, regexes, the
   `(subject_key, topic_code)` uniqueness key, the `app.subjects` active gate,
   the hyphen/underscore namespaces, and the RPC-vs-view key difference.
5. **Before-state capture made a precondition** of production application, so the
   rollback path is real.
6. **Orphan defined** in both senses, with both checks required.
7. **Coverage reporting** added to release evidence.
8. **Reconciliation clause** pointing at
   `CONTENT_OPERATIONS_ADJUDICATION_RELEASE_DESIGN.md`, with the exemption stated
   explicitly rather than left silent.
9. **QA-expectation sync rule** — a batch that changes published counts must
   update `scripts/qa/topic_guides_database_qa.sql` in the same commit.

---

## 6. Open follow-ups (not done here)

**F1 — `scripts/qa/topic_guides_database_qa.sql` is stale and failing.** It
asserts 306; Production holds 365. This is a code fix, deliberately not bundled
into a documentation change. Fixing it should also add the new distinctness and
pair-agreement assertions from the revised protocol.

**F2 — 349 template-generated explainers grandfathered on 2026-08-21.** Product
Owner accepted them with `source_note` backfilled so the debt is visible at the
row level. Applied to Development and Production via
`supabase/migrations/20260821150000_grandfather_generated_from_brief_source_notes.sql`
after the before-state was captured to
`docs/research/topic_guide_source_note_grandfather_2026_08_21/before_state.{csv,json}`
(349 rows). Post-state on both environments:

- 286 rows: `source_note = 'generated-from-brief:legacy; grandfathered-2026-08-21'`
- 63 rows: prior duplicated/moved note plus `'; upstream-generated-from-brief; grandfathered-2026-08-21'`
- 16 rows still `cramapple-authored` — the hand-authored AP Calculus AB Unit 1 explainers, correctly labeled

No student-facing field changed. The debt is now grep-able at the row level, and
re-authoring against the CED fact packs remains a separate future batch.

**F1 remains open.** F2 was executed on 2026-08-21 as described above; the
source_note backfill changed no student-facing field. No other environment
writes were made during this assessment.

---

## 7. Baseline: the new acceptance criteria run against Production today

All eleven criteria in the revised protocol were executed read-only against
Production on 2026-08-21 to confirm they are expressible as queries and to
record where the corpus stands before any remediation. C8 excludes the 63 rows
whose `source_note` records an approved cross-subject duplication.

| Criterion | Result | Status |
| --- | ---: | --- |
| C1 — pairing orphans, both directions | 0 | PASS |
| C2 — brief/explainer `unit_number` equality | 0 violations | PASS |
| C3 — topic and unit present in approved taxonomy | 0 violations | PASS |
| C4 — `practice_*` matches the brief | 0 violations | PASS |
| C5 — `learn_more_path` subject and unit | 0 violations | PASS |
| C6 — active `app.subjects` row exists | 0 violations | PASS |
| C7 — `core_idea <> what_it_is` | **349 violations** | **FAIL** |
| C8 — no shared mini-example / weak / point-attaining / bridge text | **314 rows sharing 20 values** | **FAIL** |
| C9 — length budgets | **31 briefs, 35 explainers over budget** | **FAIL** |
| C10 — authenticated view counts match `app.*` | 365 = 365, both tables | PASS |
| C11 — `anon` locked out of views and RPCs | no grants; RPC raises `28000` | PASS |

Every plumbing criterion passes. Every content criterion fails. That split is
the assessment's verdict expressed as numbers, and it is the reason the revised
protocol adds C7–C9 rather than only tightening prose.

C7, C8, and C9 are all attributable to the same batch — the 349
template-generated explainers described in Q2. Follow-up F2 relabeled those rows'
`source_note` on 2026-08-21 so a new batch authored to the revised protocol is
now distinguishable from the debt at the row level. C7, C8, and C9 continue to
fail against the debt itself; a future re-authoring pass would clear them.
Until then, new batches can proceed because they can be filtered from the debt
by `source_note`.
