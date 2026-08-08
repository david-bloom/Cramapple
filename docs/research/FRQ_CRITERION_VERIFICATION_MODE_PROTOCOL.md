# FRQ criterion verification-mode tagging protocol

**Status:** Proposed for Product Owner review — vocabulary verified against real
released materials, no schema changes made yet.
**Date:** 2026-08-07
**Owner:** Product Owner with Claude
**Related:** `docs/research/RUBRIC_DECOMPOSITION_AND_PARTIAL_CREDIT_2026_07_30.md`;
`docs/architecture/RUBRIC_AUDIT_AND_SAMPLING_POLICY.md`

## 1. Problem

A reviewer (Jill) asked whether a criterion like "compute the residual" is
satisfied by a bare correct numeric answer with no shown calculation. The
honest answer turned out to be **it depends which subject, and which specific
point, and that dependency is itself a real pattern in how College Board
scores AP exams** — not an arbitrary house style Cramapple invented. Rubric
criteria currently carry this distinction only as free text
(`learner_facing_text` / `evidence_requirements` / `minimum_fix`), which a
human reviewer can read but which an automated grader has no structured
signal to key off. This protocol adds that signal without over-fitting it to
the two or three subjects checked so far.

## 2. Vocabulary

Four values, each verified against an official College Board scoring
guideline or sample-response commentary before being added — no value in this
list is a guess:

| Value | Meaning | Verified against |
|---|---|---|
| `conclusion_only` | The correct final claim/value alone satisfies the criterion; a response may earn it even if unsupported elsewhere. | AP Calculus AB 2025 SG Q1/Q2, points P2/P4/P9 ("earned for the correct answer, with or without supporting work"); AP English Lit 2025 SG Row A, Thesis ("the student need not cite that evidence to earn the thesis point... whether or not the rest of the response successfully supports that line of reasoning"). |
| `process_required` | A specific derivation, setup, equation, or method must appear in the response, independent of whether the final value is correct. | AP Calculus AB 2025 SG Q1 P1, Q3 P1 ("the bare quotient expression 'by itself is not sufficient'"); the general AP Statistics component pattern (e.g., "provides a justification for the range with an argument based on identifying..."). |
| `evidence_required` | A specific citation/quotation/detail from a source text must appear, connected to the claim it supports — not merely present. | AP English Lit 2025 SG Row B, Evidence AND Commentary. Confirmed via Sample 1B: a textual citation with commentary that doesn't tie back to the line of reasoning still caps the score below full credit. |
| `holistic` | The criterion is one bundled quality judgment that does not decompose into a presence/absence check for a specific thing. | AP Statistics E/P/I components generally; AP English Lit 2025 SG Row C, Sophistication ("identifying complexities," "situating within a broader context" — no computational or citation analog). |

## 3. Explicitly out of scope — do not fold in

**Graduated vs. binary point structure is a separate axis and must not become
a fifth value in this enum.** AP English Lit's Row B is not just tagged
`evidence_required`, it is scored on a continuous 0–4 band (general vs.
specific vs. uniform evidence; faulty vs. established line of reasoning) —
structurally different from a Calculus AB point or a gold-set element, which
are binary present/absent. This axis describes *how* a point is awarded;
`verification_mode` describes *what's required* to award it. Conflating them
was the exact sprawl risk flagged when this protocol was proposed. If a
graduated-scoring tag is needed later, it gets its own field and its own
verification pass — not a value added here to save a migration.

## 4. Schema (proposed, not yet applied)

- A Postgres enum type (not free text), so an invalid value cannot be
  inserted — protects against spelling drift (`evidence_required` vs
  `needs_evidence`) and silent duplication.
- An array-of-enum column on `app.frq_criteria`
  (`verification_modes app.frq_verification_mode[]`), not a join table —
  simpler, still type-constrained.
- A CHECK constraint capping the array at 2 values. In practice almost every
  criterion should carry exactly one; a criterion that seems to need three is
  a sign it should be split into two criteria, not tagged more heavily.
- The tag is **optional** (nullable/empty array). Holistic-rubric subjects or
  criteria where the question doesn't decompose this way get no tag; the
  existing free-text fields remain the authority for those rows, same as
  today.

## 5. Governance — adding a new value

Adding a fifth value to the enum requires, in order:

1. A real released College Board scoring guideline, sample-response packet,
   or equivalent primary source for the subject in question — read in full,
   the way Statistics, Calculus AB, and English Lit were checked here, not
   inferred from general knowledge of the subject.
2. A specific citation (document, question, row/point letter, quoted
   language) showing the pattern isn't covered by an existing value.
3. A schema migration adding the enum value, plus an entry in the table in
   §2 of this document with the same citation format.

No authoring script, remediation batch, or one-off content fix may introduce
a new tag value informally. If existing content seems to need one, that
content should wait for the value to be added properly, the same way new
DECISION-0044 exam packs waited for `validator_qualifications` rather than
being seeded ad hoc.

## 6. How this connects to grading

### 6.1 The gap this closes

Per `RUBRIC_DECOMPOSITION_AND_PARTIAL_CREDIT_2026_07_30.md`, the automated
judge workflow already **invents** missing structure when a criterion doesn't
state it — that investigation found 74% of multi-point criteria have no
stated point decomposition, and the grader fills the gap itself, with mixed
results (2 of 10 sampled criteria scored non-monotonically). A criterion's
`verification_mode` is the same kind of missing structure, one level up: not
"how do the points split" but "does a bare correct conclusion satisfy this
criterion at all, or must the grader find specific supporting content in the
response." Concretely, it should be injected into the per-criterion grading
prompt as an explicit instruction:

- `conclusion_only` → grader should award the point on a correct final
  claim/value regardless of whether supporting work appears elsewhere in the
  response.
- `process_required` / `evidence_required` → grader must locate the specific
  required content (the setup expression; the textual citation tied to the
  claim) in the response and should not award the point on the terminal
  answer/claim alone.
- `holistic` → grader makes one bundled judgment call using the full
  criterion text; no separate presence/absence sub-check.

This removes exactly the class of invented judgment call the prior
investigation flagged as a source of instability, the same way stated point
decompositions (when present) already stabilize partial-credit awards.

### 6.2 Where this actually lives in the codebase (confirmed, not inferred)

There is exactly one shared grading-prompt implementation, not a duplicated
one — `supabase/functions/_shared/grading-contract.ts`. Both the production
edge function (`supabase/functions/evaluate-attempt/index.ts`) and the
offline assessment harness (`scripts/grading-model-assessment/harness.ts`,
via `scoreCriterionPair`) import from it, per that module's own header
comment: "so the harness tests what production actually sends and scores,
rather than a parallel reimplementation." A `verification_mode` change made
once here reaches both live grading and the audit/harness tooling in
`RUBRIC_AUDIT_AND_SAMPLING_POLICY.md` with no second implementation to keep
in sync.

Two prompt-building variants exist in that file, selected by the
`GRADING_ARM` env var (default `"b"`):

- **Arm B, `buildGradingPrompt` (grading-contract.ts:501-563)** — one call
  per item, all criteria graded together. Per criterion it currently emits:
  `criterion_key`, `learner_facing_text`, `points_possible`, an `award:`
  range line when multi-point, then optional `evidence_requirements` and
  `minimum_fix` lines (grading-contract.ts:513-540).
- **Arm A, `buildCriterionGradingPrompt` (grading-contract.ts:240-330)** —
  one call per criterion, run in parallel, with sibling criteria listed as
  context-only (added after early Arm A regressed when a criterion was
  graded blind to its siblings). Per-criterion block at
  grading-contract.ts:278-298 carries the same field set: `criterion_key`,
  `points_possible`, `learner_facing_text`, then optional
  `evidence_requirements`, `minimum_fix`, `accepted_variants`.

Both variants already have a slot for exactly this kind of optional,
criterion-scoped instruction — `evidence_requirements` and `minimum_fix` are
today's version of it, as free text. `verification_mode` would be a new
optional line in the same position, in both blocks, translated from the enum
to an instruction sentence rather than passed as a raw tag (the model should
never see the literal string `conclusion_only`; it should see the sentence
it implies):

- `conclusion_only` -> "A correct final answer alone satisfies this
  criterion, even if no supporting work appears elsewhere in the response."
- `process_required` -> "This criterion requires the specific
  method/setup/derivation described above to appear in the response — do not
  award it on a correct final answer alone."
- `evidence_required` -> "This criterion requires a specific citation or
  quotation from the source text, connected to the claim it supports — do
  not award it on an unsupported claim alone."
- `holistic` -> no extra line; the existing criterion text is already meant
  to be graded as one bundled judgment, which is the model's default
  behavior today.

### 6.3 Where the data has to travel

`evaluate-attempt/index.ts` already selects `criterion_key,
learner_facing_text, points_possible, evidence_requirements, minimum_fix,
accepted_variants` from `app.frq_criteria` (around index.ts:807-812) before
handing them to `grading-contract.ts`. Adding `verification_modes` to that
same select list is the same shape of change as the five fields already
there — not a new fetch path, not a new join.

### 6.4 Scope: this only touches the live LLM-text engine

Per `docs/GRADING_PROGRAM.md`'s 4-engine taxonomy and the dispatch in
`supabase/functions/_shared/grading-router.ts` (`resolveGradingRoute`,
lines 150-201), `verification_mode` is only meaningful on the
`discrete_text` / `llm_discrete_text` path (Engine 1 — the only engine
actually in production). It has no effect on:
- `mcq` -> `rule_based_mcq`, deterministic, no prompt at all;
- `structured_formula` -> `python_symbolic_ecf`, deterministic code, and
  currently unreachable in practice (no live content routes to it);
- `spatial`/`holistic` rubric_type -> `human_shadow`, a **human** reviewer,
  not an LLM prompt — tagging these criteria would have no effect since
  nothing reads the tag on that path today.

### 6.5 How to validate before trusting it

Don't ship this as "add the field and assume it works." Follow the same
self-referential validation method used in
`RUBRIC_DECOMPOSITION_AND_PARTIAL_CREDIT_2026_07_30.md`, which needed no
adjudicated gold set and was explicitly called out there as the
trustworthy-at-small-n approach: construct paired answers per tagged
criterion — one with only the correct terminal claim/value, one with the
same claim plus full shown work — and run both through `scoreCriterionPair`
in the harness, with and without the new instruction line present. A working
implementation should show the `conclusion_only` pair scoring identically
regardless of shown work, and the `process_required`/`evidence_required`
pair scoring lower on the bare-conclusion version specifically when the
instruction line is present. If either doesn't hold at small n, that's a
prompt-wording problem to fix before wider rollout, not a reason to add a
fifth enum value.

### 6.6 Audit-loop tie-in and remaining scope gap

A mismatch between a criterion's `verification_mode` tag and observed judge
behavior (e.g., a `conclusion_only` criterion where the judge is visibly
penalizing missing work) is a natural new trigger rule for the audit loop in
`RUBRIC_AUDIT_AND_SAMPLING_POLICY.md` §8. This does not, by itself, address
the graduated-vs-binary scoring-style gap in §3 — that would need its own
grading-prompt change, verified separately.

## 7. Verification log

| Subject | Source documents | Date checked | Outcome |
|---|---|---|---|
| AP Statistics | 2025/2026 released FRQs, 2025 AP Central sample-response/commentary packets (Q1, Q2) | 2026-08-07 | No residual-type item found in the packets checked; general exam Directions ("correct answers without supporting work may not receive credit") and component-based scoring notes support `process_required`/`holistic` as the default for this subject. No `conclusion_only` pattern confirmed for Statistics yet. |
| AP Calculus AB | 2025/2026 released FRQs, 2025 official Scoring Guidelines (Q1–Q3), 2025 AP Central sample-response/commentary packets (Q1, Q2) | 2026-08-07 | Confirmed atomic point-based scoring with explicit `conclusion_only` and `process_required` language, point-by-point. |
| AP English Literature and Composition | 2025/2026 released FRQs (Sets 1 and 2), 2025 official Scoring Guidelines (Set 1), 2025 AP Central sample-response/commentary packet (Q1), full Course and Exam Description | 2026-08-07 | Confirmed `conclusion_only` (Row A), `evidence_required` (Row B, new value added here), and `holistic` (Row C). Row B's graduated 0–4 structure identified as a separate, out-of-scope axis (§3). |

Not yet checked: AP Physics (any variant), AP Chemistry rubric structure
specifically for this axis, AP Biology, AP Precalculus. Do not assume any of
these follow the Calculus AB or English Lit pattern without checking.
