# Codex Prompt — Full-Point Canonical Answer Generation (Biology, then Statistics)

STATUS: orchestration prompt (hand to Codex) | DATE: 2026-09-21 | AUDIENCE: David
(orchestrator) → Codex (drafter). A separate, independent non-OpenAI model runs
the QA pass — NOT Codex.

> Paste the block below into Codex. It is self-contained; everything it cites
> lives in `david-bloom/cramapple` or the Cramapple Supabase projects.

---

You are drafting **full-point canonical answers** for Cramapple free-response
(FRQ) items. A canonical answer is the response a student would write that earns
**every available point** against the item's own rubric. You are the **drafter
only** — you do not grade, you do not write to any production database, and you
**STOP for an independent AI QA pass** at the gates below. The machinery you need
(the rubrics, the grader, the fact packs) already exists; your job is the answers,
not new machinery.

## Read first (in this order)

1. `docs/proposals/2026-09-20-student-facing-canonical-answers.md` — the binding
   design. Its core rule governs this whole task: *an answer is not canonical
   until it is written as a student would write it AND the production grader
   awards it 100% against its own rubric.* You produce the draft that satisfies
   the first half; the QA pass proves the second.
2. `docs/GRADING_PROGRAM.md` and `docs/architecture/CONTENT_AUTHORING_AND_PROMPT_ARCHITECTURE.md`
   — how FRQs are scored criterion-by-criterion against `app.frq_criteria`, and
   the governance line you must hold: **an authored canonical answer is a
   development artifact, NOT the certified gold set** (DECISION-0045). This task
   produces authored canonicals; it does not touch gold-set certification.
3. `docs/product/AP_BIOLOGY_CED_FACT_PACK.md`, then
   `docs/product/AP_STATISTICS_2027_CED_FACT_PACK.md` — the authoritative scope
   and terminology per topic. Ground every answer in the item's rubric and the
   correct CED; never in model memory. (AP Statistics is the redesigned **2027**
   CED — do not use pre-redesign topic numbering.)

## Source of truth (per item)

For each FRQ, the rubric is the ground truth. Pull, read-only, from the Cramapple
**Development** Supabase project (`wmgjsdkphcyhngaffbqf`) — never Production:

- `app.content_items` (`item_type='frq'`) → its latest `app.content_item_versions`
  (the `stem`, `prompt_json`, `scoring_contract`, existing `canonical_answer_1/2`,
  `frq_form`).
- `app.frq_criteria` for that version: every `criterion_key`, `required_evidence`,
  `accepted_variants`, `points_possible`. **This is what a full-point answer must
  satisfy, criterion by criterion.**
- Subject via `content_items → exam_pack_versions → exam_packs.exam_code`.

## Scope

- **Only FRQs that lack a full-point canonical answer today** (latest version's
  `canonical_answer_1` is null/empty). Re-derive this set at run time; do not
  trust a stale count. (As of the 2026-09-21 Production audit the gaps were ~14 of
  157 Biology FRQs and ~120 of 178 Statistics FRQs — Development may differ.)
- **Never overwrite an existing canonical answer.** Items that already have one
  (e.g. Biology's reviewed "canonical pair" set) are routed to the QA pass for
  verification, not re-drafted by you.
- **FRQ only.** Ignore MCQ (it has a deterministic key). Skip any criterion the
  rubric marks as graph-construction / drawn-response with no written-answer
  equivalent (DESIGN-007); list it as out-of-scope rather than faking a written
  answer.

## Method (per item)

1. Read the stem, the `scoring_contract`, and every criterion's `required_evidence`
   and `accepted_variants`.
2. Write **one** coherent, student-quality response that a strong student would
   actually write — prose and worked steps, in the answer's own voice. It must
   satisfy **every** criterion for full points. It is **not** a restatement of the
   rubric, and it must not quote criterion/grading language ("earns a point",
   "reports…"). Show the work a criterion requires, don't just assert the result.
3. Respect the `scoring_contract` (units rule, rounding rule, carry-forward rule)
   and the CED's scope. For quantitative steps, compute the actual values from the
   stem; do not leave placeholders.
4. If — and only if — an item admits a genuinely different second full-credit path
   (not a trivial rewording), draft a second answer for the `canonical_answer_2`
   slot. Otherwise leave it empty.
5. Emit a **criterion coverage map**: for each `criterion_key`, quote the exact
   span of your answer that satisfies it. This is what makes the QA pass fast and
   is required for every draft.

## Output (drafts only — no DB writes)

Write to reviewable repo staging files; do not write to Supabase, and do not open
a PR that touches `app.*` data:

- `scripts/content-seed/canonical-answers/APBIO_canonical_drafts_2026_09_21.json`
- `scripts/content-seed/canonical-answers/APSTATS_canonical_drafts_2026_09_21.json`

Each record: `content_key`, `content_item_version_id`, `canonical_answer_1`,
optional `canonical_answer_2`, the `criterion_coverage_map`, `source` (`rubric` +
CED fact-pack version), and `notes` (anything you could not fully satisfy). Also
write a one-page `*_coverage_manifest.md` per subject: items drafted, items
skipped and why, and any item whose rubric you believe is internally broken
(criteria that no correct answer can satisfy — a finding for Orly, not something
you paper over).

## Gates — STOP for the independent QA pass

1. **Phase 1 — Biology.** Draft the Biology gap set, write the staging file and
   manifest, then **STOP.** Do not start Statistics. Hand off to the QA pass: a
   **separate, independent, non-OpenAI model** grades each draft through the
   production grader against its own `frq_criteria`; a draft passes only if it
   earns **every criterion, full points, no carry-forward rescue**. Failures go to
   Orly (rubric wrong vs. answer wrong vs. item unanswerable). You do not run this
   pass and you do not self-certify.
2. **Phase 2 — Statistics.** Only after the Biology QA pass has cleared (and any
   method problems it surfaced are corrected) do you draft the Statistics gap set
   the same way, then **STOP** again for the same independent QA pass.

## Guardrails

- **Grounded or not at all.** Every answer traces to the item's rubric and the
  correct CED fact pack. No outside facts, no invented formulas, no pre-redesign
  Statistics content.
- **Answer keys are secret.** A full-point answer is an answer key: it is drafted
  as content for review and the post-attempt student surface only, never exposed
  to a student before they submit. Do not add it to any student-facing serving
  path.
- **Never overwrite** an existing canonical, never touch MCQ, never write to
  Production, never grade your own drafts, never proceed past a STOP gate.
- **Authored ≠ gold set.** These drafts are development/teaching artifacts; they
  do not certify the grader and do not enter the DECISION-0045 gold-set pipeline.

## Definition of done (for your part)

Two staging files + two coverage manifests, each item carrying a full criterion
coverage map, Biology delivered and QA-cleared before Statistics is begun, and a
clean list of rubric-defect findings handed to Orly. Nothing written to the
database; nothing self-certified.
