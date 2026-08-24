# Orly Protocol — Next-Session Resume Guide

STATUS: resume guide | DATE: 2026-08-24 | AUDIENCE: the next session (LLM), and David.

Read this first, then `docs/research/ORLY_EXTERNAL_ASSIGNMENT_MINING_PROTOCOL_2026_08_24.md`
(the governing protocol, including its revision notes) and
`docs/research/orly_source_log/SOURCE_LOG.md` (the full provenance chain for
every document and item touched this session). This file is the "where we
left off + how to pick up" summary.

---

## Copy-paste prompt for the next session

```
Read docs/research/ORLY_PROTOCOL_NEXT_SESSION_PROMPT_2026_08_24.md, then
docs/research/ORLY_EXTERNAL_ASSIGNMENT_MINING_PROTOCOL_2026_08_24.md and
docs/research/orly_source_log/SOURCE_LOG.md. Pick up the Orly external-
assignment mining protocol work: 8 original Calc AB/BC MCQs are published,
taxonomy-labeled, and human-validated on Production as of 2026-08-24. Ask
David what's next -- e.g. more items from the same three source documents,
new source documents, running content_taxonomy_validation_decisions'
decision_source='ui_review' path once a real reviewer UI exists, or
something else entirely.
```

---

## 1. What was accomplished (2026-08-24)

**The protocol itself.** Orly is a real AP student (Solebury School) who
periodically brings home real class materials. `ORLY_EXTERNAL_ASSIGNMENT_MINING_PROTOCOL_2026_08_24.md`
governs mining those documents for topic scope, pacing, and category insight
**without ever copying their wording or numbers** — this is the load-bearing
rule, re-verify it before authoring anything new. The protocol was applied to
three real documents this session (all logged in `SOURCE_LOG.md`):

1. AP Calculus AB summer assignment (Michelle Gavin) — Unit 1 topics 1.1-1.8.
2. AP Chemistry summer assignment (Michelle Gavin) — prerequisite/readiness
   content, not CED-unit content; exposed that Cramapple's taxonomy has no
   "Unit 0" readiness layer (a real product question, still open — see §3).
3. AP Calculus BC DeltaMath summer assignment + "Corrective Assignment"
   exports (Hannah Pritchett) — Unit 1 (full, 1.1-1.16) and Unit 2 (through
   2.9, the quotient rule). Surfaced a new source category — licensed
   platform-generated content (DeltaMath), now folded into protocol §2 as
   *more* restricted than a teacher-authored worksheet.

**8 original items, full pipeline, live on Production:**

| content_key | topic | unit | status |
|---|---|---|---|
| apcalcab-mcq-060 | 1.3 Estimating limits from graphs | 1 | published, validated |
| apcalcab-mcq-070 | 1.4 Estimating limits from tables | 1 | published, validated |
| apcalcab-mcq-080 | 1.6 Algebraic manipulation | 1 | published, validated |
| apcalcab-mcq-090 | 1.8 Squeeze theorem | 1 | published, validated |
| apcalcbc-mcq-060 | 1.10 Discontinuity types | 1 | published, validated |
| apcalcbc-mcq-070 | 1.15 Limits at infinity / horiz. asymptotes | 1 | published, validated |
| apcalcbc-mcq-080 | 2.2 Definition of the derivative | 2 | published, validated |
| apcalcbc-mcq-090 | 2.9 Quotient rule | 2 | published, validated |

All 8: `content_items.status='published'`, correct-answer choice keys
genuinely randomized across A/B/C/D (not clustered — this was a real bug,
see below), `content_taxonomy_labels.label_status='validated'`, and
confirmed end-to-end servable via `public.select_unit_gated_practice_items`
(the real student-facing selector, not just the label table). **Production
only — none of this is in Dev.**

**Two real mistakes, both caught by David, both fixed same-day** (details in
`ACTIVITY_LOG.md`'s two 2026-08-24 Orly entries and the protocol's revision
notes):

1. All 8 items originally had their correct answer at choice key `A`.
   Fixed with a genuine per-item random reassignment
   (`20260824130000_randomize_orly_protocol_mcq_correct_keys.sql`). Protocol
   §6 now **requires** an actual random draw for every future MCQ's
   correct-answer placement.
2. All 8 went straight to `published` on David's topic/pacing approval
   alone, skipping `CONTENT_AUTHORING_AND_QA_PROTOCOL.md` §9's independent
   re-derivation. Retroactively re-solved all 8 from first principles and
   recorded the match (`20260824140000_...`). Protocol §6 now makes that
   re-derivation a **hard precondition** for every future item, explicitly
   not substitutable by Product Owner approval of scope/pacing/"these are
   simple." Also saved as durable memory
   (`feedback_mcq_authoring_requirements.md`) since it applies beyond just
   this protocol.

**Taxonomy labeling + human validation, run to completion:**

- Ran `scripts/taxonomy/extend_math_serving_labels.mjs --write-db` against
  Production once per `content_key` (it only accepts one `--key` filter —
  no batch mode exists). Required temporarily relinking the Supabase CLI
  Dev→Prod→Dev (relinked back to Dev when done — verify it's still Dev-linked
  before assuming otherwise). All 8 got `label_status='provisional_model'`
  via genuine two-model agreement (`openai/gpt-5.5` + `google/gemini-2.5-flash`),
  matching the originally-authored `taxonomy_refs` exactly.
- **`provisional_model` is not servable.** `select_unit_gated_practice_items`
  only reads `label_status='validated'`, and the labeling design doc
  (`TAXONOMY_LABELING_PLAN_V3_2026_08_04.md` §T6) explicitly forbids a model
  from self-certifying `validated` — human-required, no automated path exists
  today (even the lighter "spot-check" automation lane is gated behind a
  40-item gold-set calibration that has never been run). David reviewed the
  8 items' unit assignments directly in chat and confirmed them explicitly;
  applied via `20260824150000_validate_orly_protocol_taxonomy_labels.sql`.
- That validation write surfaced a genuine infra gap:
  `content_taxonomy_labels.validation_decision_id` had existed since
  `20260804170000_taxonomy_label_layer.sql` as a bare `uuid` with no FK and
  no backing table. Spawned and executed **TASK-0028**
  (`docs/tasks/TASK-0028-CONTENT-TAXONOMY-VALIDATION-DECISION-TABLE.md`):
  new table `app.content_taxonomy_validation_decisions`, backfilled the 8
  rows reusing their existing placeholder IDs, real FK added and verified
  clean (`20260824160000_content_taxonomy_validation_decisions.sql`).

**One known, pre-existing issue noticed but not touched this session** (found
by a parallel session, not this thread of work): `app.mcq_choices` grants
`authenticated` column `SELECT` on `is_correct`/`rationale` for every
published MCQ on both Prod and Dev — a live answer-key exposure affecting the
entire item bank including these 8 new items. Recommended fix
(`REVOKE SELECT (is_correct, rationale) ON app.mcq_choices FROM authenticated, anon`)
is held for David's explicit go. See the relevant `ACTIVITY_LOG.md` entries
if picking this up.

## 2. Key IDs / facts (verified this session, Production `pcntajvbdfqhbeewmdry`)

| Thing | Value |
|---|---|
| `ap_calculus_ab` exam_pack_version_id | `826c8cf1-bc1b-4f2a-bd33-61a758e1487d` |
| `ap_calculus_bc` exam_pack_version_id | `3778d753-273a-403d-8f02-55dc64ec6a27` |
| `ap_calculus_ab` taxonomy_source_version | `33b4408b-0ecc-4c7a-b0b1-612db81164a1` |
| `ap_calculus_bc` taxonomy_source_version | `ab088009-dc9a-4f93-8824-803e1913505b` |
| David's Prod `profiles.user_id` (admin) | `f5a26c6b-3566-4d58-9e97-979fbb947564` |
| New table this session | `app.content_taxonomy_validation_decisions` |
| Taxonomy labeling script | `scripts/taxonomy/extend_math_serving_labels.mjs` (single `--key` filter only) |

## 3. Open items / next steps

- **More items?** The same three source documents (Calc AB, Chemistry,
  Calc BC) have plenty of topic scope not yet turned into items — ask David
  before authoring more; nothing here implies an open-ended mandate.
- **Chemistry readiness-content gap.** Still an unresolved product question:
  does Cramapple want a pre-Unit-1 "readiness" taxonomy layer at all, and if
  so, per-subject or shared cross-subject? See the Chemistry insight note
  (`docs/research/orly_source_log/2026-08-24_ap_chemistry_summer_assignment.md`).
  No action taken on this — it's a decision for David, not a default to
  build toward.
- **Dev has none of this.** All 8 items, their labels, and the new
  validation-decisions table exist only on Production. Not automatically a
  problem (matches the scope of what was asked each time), but worth being
  aware of if Dev/Prod convergence work picks back up (see TASK-0027).
  Confirm log
  (`docs/tasks/TASK-0027-DEV-PROD-SCHEMA-CONVERGENCE.md`) before mirroring
  anything into Dev automatically.
- **`content_taxonomy_validation_decisions.decision_source`** currently only
  has one real value in use (`chat_review`) — the schema also allows
  `ui_review` and `automated_spot_check` for whenever those actual workflows
  get built. Don't assume they exist yet.
- **The live `mcq_choices` answer-key exposure** (§1 above) is unrelated to
  this protocol but affects these 8 items too. Worth asking David about
  directly if it hasn't been resolved by another session already.
