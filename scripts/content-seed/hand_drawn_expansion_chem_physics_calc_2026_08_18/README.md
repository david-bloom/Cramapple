# Hand-drawn expansion: Chemistry, Physics 1, Calculus AB — 2026-08-18

**Trigger:** Owner decision, same session as
[`HAND_DRAWN_RESPONSE_MIX_AUDIT_2026_08_18.md`](../../../docs/research/HAND_DRAWN_RESPONSE_MIX_AUDIT_2026_08_18.md):
"stats is fully digital but we will use the hand drawn capture solution to
mimic hand drawn through [Desmos]. Chemistry, physics and calculus need more
questions with hand drawn components." Recorded as `DECISION-0048`
(`docs/activity_log/DECISIONS_LOG.md`).

## Status

**Draft, unreviewed, not applied to any database.** These are local JSON
files only — nothing has been inserted into Supabase (Supabase MCP is
unauthenticated in this session; no live DB access was available or used).
Six new items, two per subject, in the same `HDG-2026-*` hand-drawn-capture
schema used by the existing AP Biology/Statistics corpus
(`docs/research/hand_drawn_graph_corpus_2026_06_30/`) — i.e. genuine
photograph-and-grade items with `expected_graph_spec`/`criterion_definitions`/
`capture_instruction`, not the older typed-text "describe the construct"
items that the 08-18 mix audit's "no_constructs" counts had included for
Physics/Chemistry (see "Important scope correction" below).

| File | Subject | Items |
|---|---|---|
| `chemistry_hdg_items.json` | AP Chemistry | `HDG-2026-CHEM-001` (weak-acid/strong-base titration curve, buffer region), `HDG-2026-CHEM-002` (catalyzed vs. uncatalyzed reaction-energy diagram) |
| `physics1_hdg_items.json` | AP Physics 1 | `HDG-2026-PHYS1-001` (free-body diagram, block on an incline with friction), `HDG-2026-PHYS1-002` (velocity-time graph, vertical projectile) |
| `calcab_hdg_items.json` | AP Calculus AB | `HDG-2026-CALCAB-001` (sketch f from a sign table of f'/f''), `HDG-2026-CALCAB-002` (sketch f' from a verbal description of f's behavior) |

## Important scope correction from the mix audit

The 08-18 audit's Physics `no_constructs` count (6/53) and Chemistry's single
`no_constructs` item (`apchem-sfrq-032`) are **not** genuine hand-drawn
capture items — they accept a typed derivation or typed-or-sketched
description (`response_modalities: typed-text, typed-math`), graded by
keyword/text criteria, not a photographed drawing graded by vision against
`expected_graph_spec`. Only AP Biology and AP Statistics had any true
`HDG-*`-style capture items before this batch. This batch is therefore the
**first genuine hand-drawn-capture content** in Chemistry, Physics, and
Calculus, not an expansion of an existing capture pool.

## Why these six, and why only six

Each subject got exactly two items, chosen to hit the specific CED-documented
gap the mix audit flagged, using content that's simple and unambiguous enough
to author correctly without a fresh primary-source CED read this session:

- **Chemistry:** Practice 3 ("create graphs/diagrams") is FRQ-only, 8-16%
  weight, and the prior corpus had zero genuine capture items. Titration
  curve (weak-acid buffer region, distinct from `apchem-sfrq-032`'s
  strong-acid case) and a reaction-energy/catalyst diagram cover two
  different Practice-3 archetypes.
- **Physics 1:** ~25% of real FRQs use the "Translation Between
  Representations" archetype, and every Physics FRQ is handwritten on paper
  on the real exam. A free-body diagram (the single most exam-common
  hand-drawn artifact in this course family) and a velocity-time graph from
  a kinematics description cover the two most common construction types.
- **Calculus AB:** Practice 2 ("Connecting Representations") carries 10-20%
  FRQ weight and the corpus had zero hand-drawn items at all. Sketch-f-from-
  derivative-signs and sketch-f'-from-f's-behavior are inverse tasks
  covering both directions of that translation skill (CED Unit 5, topics
  5.8-5.9).

This is a small, targeted first batch, not a full-coverage build-out —
matched to the two clearest, least-ambiguous gaps per subject rather than an
attempt to hit every CED archetype at once.

## What was and wasn't verified

- Grounded in each subject's `docs/product/*_CED_FACT_PACK.md` (topic
  citations, FBD vector-diagram convention, Practice weightings) — these fact
  packs are themselves primary-source-verified per their own headers.
- Numeric content (titration pH values via Henderson-Hasselbalch and weak-base
  hydrolysis at equivalence; kinematics via `v = v0 - gt`; calculus sign
  tables) was computed directly and is internally consistent, but was **not**
  cross-checked against a released FRQ, scoring guideline, or a second
  independent reviewer this session — the same rigor gap the existing corpus
  handles via `rights_status: independently_authored_synthetic_research_seed_unverified`
  and a `review_stage` field, applied identically here (`review_stage: "draft"`,
  one step earlier than the existing corpus's `"canonical_answer"` stage,
  since these haven't had even a first review pass).
- No CED page number is cited per item (unlike the deep-tier fact-pack
  entries), since this batch drew on the fact packs' already-synthesized
  content rather than re-reading the primary-source CED PDFs directly.

## Next steps (not done here)

1. Route through the same review path prior `HDG-*` batches used before any
   student exposure — Learning Quality / subject-matter read, since these are
   new capture-graded items, not text-graded ones.
2. Once reviewed, apply via a proper migration (`supabase/migrations/` or a
   `content-seed` SQL batch, matching the pattern in
   `scripts/content-seed/publication/`) — this batch is JSON only.
3. Decide `practice_format` and unit/topic taxonomy tagging before these are
   selectable by `select_practice_frqs` or any targeted-drill selector.
4. **Correction:** there is no human-graded interim path for real students —
   per firm, standing Owner policy (`ACTIVITY_LOG.md`, 2026-08-14, "Runtime
   human escalation... there is no case, ever, in actual student use where a
   hard grading case reaches a human"), humans are only ever in the loop for
   engine development and calibration (audit, gold labeling, QA), never in
   the live grading path at any production authority stage. Grading a real
   student's submission is always automated — there is no other channel.
   `rubric_type: spatial` currently routes to `evaluator_strategy:
   human_shadow` in `grading-router.ts`, which despite the name is a
   development/calibration-only shadow path, not a way of serving real
   students. These six items must not reach real students for grading (via
   any selector) until Engine 4 (automated spatial grading) passes its
   accuracy bar — there is no safe intermediate "human-graded" state to route
   them to instead. Authoring ahead of that fix is fine (that's what this
   batch is); making them student-reachable before it lands is not.
5. **Scope broadened same session, `DECISION-0049`:** hand-drawn capture is
   now planned as an added submission option (not a replacement) for
   typed-math FRQs generally, retroactive to all 36 already-published
   Calculus FRQs, graded by reusing each item's existing typed-answer
   criteria through an OCR-transcription step (capture → transcribe →
   grade with the same rubric). This batch's two Calculus items
   (`HDG-2026-CALCAB-001/002`) are graph-*sketch* items and are unaffected
   by that broader change. The broader change is not implemented anywhere
   in this batch or this repo yet — see `DECISION-0049` in
   `docs/activity_log/DECISIONS_LOG.md` for the connected same-day OCR
   probe finding and the concrete next steps (OCR-transcription pilot,
   schema/migration work for the 36 existing items, frontend UI work).
