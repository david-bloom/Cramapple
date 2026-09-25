# Codex Work Order — Author Original Calc AB Unit 1 Items (Topics 1.9-1.16)

**Context.** Orly shared four Solebury School AP Calculus AB documents covering the second half of
Unit 1 (Limits and Continuity): a discontinuity/continuity notes-and-practice packet, a standalone
discontinuity-types practice packet, a mid-unit review, and one photographed worksheet page (not
mined for content — see below). This follows the same protocol as the first Orly-sourced Calc AB
batch from 2026-08-24 (`apcalcab-mcq-060/070/080/090`).

**READ FIRST, IN THIS ORDER:**
1. `docs/research/ORLY_EXTERNAL_ASSIGNMENT_MINING_PROTOCOL_2026_08_24.md` — the full rights boundary
   (§2) and authoring steps (§6). This is not optional context; §2's "never copy stem wording,
   specific numbers, specific graph data, answer choices" is the hard constraint this entire order
   operates under.
2. `docs/research/orly_source_log/2026-09-24_ap_calculus_ab_unit1_part2.md` — the insight note for
   this specific batch, including a topic-numbering correction (the school's own "LT" labels do NOT
   match real CED topic codes starting at LT1.9 — do not trust them, the corrected mapping is in that
   note and re-verified below).
3. `docs/research/orly_source_log/SOURCE_LOG.md` — the new row for this batch, and the format of the
   first batch's row/notes for precedent.

**Do NOT open any of the four source documents yourself** (they are not in this repo and should not
be added to it) — the topic/skill scope you need is already extracted into the insight note above.
This order is about authoring original items from that extracted scope, not re-mining the sources.

Merge main first:

    git fetch origin
    git switch codex/orly-calc-ab-unit1-part2-2026-09-24
    # If that branch does not exist instead run:
    # git switch -c codex/orly-calc-ab-unit1-part2-2026-09-24 origin/main
    git merge origin/main

The checkout must be clean before starting. Commit and push to
codex/orly-calc-ab-unit1-part2-2026-09-24 as you go. **Draft-status content proposal only** — insert
as `status='draft'` per protocol §6 step 5, do not hand-set `published`, do not open a PR against
main, do not merge.

## Verified topic scope (do not re-derive from the source documents' own numbering)

Confirmed against `app.taxonomy_topics` for `ap_calculus_ab`, unit 1 ("Limits and Continuity"):

| Real CED topic | Topic title | Skill to author toward |
| --- | --- | --- |
| 1.9 | Connecting Multiple Representations of Limits | Given a limit presented one way (graph, table, algebraic expression, piecewise definition), evaluate or reason about it using a different representation. |
| 1.10 | Exploring Types of Discontinuities | Classify a discontinuity (removable / jump / infinite-nonremovable) for a rational, piecewise, or trig function, and state its location. |
| 1.11 | Defining Continuity at a Point | Determine whether a function is continuous at a specific point using the three-part definition; for a piecewise function, solve for a parameter that makes it continuous at the boundary. |
| 1.12 | Confirming Continuity over an Interval | Determine the interval(s) on which a function is continuous, including correct open/closed endpoint notation at removable or one-sided boundary points. |
| 1.13 | Removing Discontinuities | For a function with a removable discontinuity, find the value that would need to be assigned at that point to make the function continuous there. |
| 1.14 | Connecting Infinite Limits and Vertical Asymptotes | Identify vertical asymptotes and evaluate one-sided infinite limits near them. |
| 1.15 | Connecting Limits at Infinity and Horizontal Asymptotes | Evaluate limits as x approaches +/- infinity for rational, trigonometric (bounded-oscillation), and exponential functions; identify horizontal asymptotes. |
| 1.16 | Working with the Intermediate Value Theorem | State the IVT's hypotheses and use it to justify that a continuous function attains a specific value (or a zero) on a closed interval. |

Topic 1.11 (school-numbered) in the source material — "domain of functions, including
transformations of parent functions" — is a prerequisite/algebra-review skill, not a distinct CED
topic (see the insight note's Category section). **Do not author an item tagged to a Unit 1 topic
code for domain-finding alone** — if you think a domain-finding item is warranted, flag it as a
product question about prerequisite content per protocol §4/§6, don't force a topic tag onto it.

## Authoring instructions (protocol §6, followed exactly)

1. For each of the 8 topics above, author 1 original MCQ. For 1.11, 1.13, and 1.16 specifically
   (continuity-at-a-point/find-the-parameter, removing a discontinuity, and IVT justification), also
   author 1 original short FRQ each if a clean FRQ shape fits — these three skills are naturally
   "solve for a value and justify" rather than "select from four options," matching how real AP exams
   test them. Use your judgment on the rest; MCQ-only is fine where the skill is naturally
   multiple-choice (e.g. classifying a discontinuity type).
2. **Brand-new stems, numbers, functions, and (for MCQ) distractors** — do not reuse or lightly
   paraphrase any function, graph, or number from the source documents. Target the same skill and a
   comparable difficulty band to what a mid-unit AP Calculus AB student would see, not what the
   specific source problems looked like.
3. **Randomize the correct MCQ choice key** using an actual random draw (SQL `random()` or
   equivalent) per item — do not default to `A`, do not hand-pick a "varied enough" pattern. This
   was the exact mistake the first Orly-protocol batch made (`docs/research/ORLY_EXTERNAL_ASSIGNMENT_MINING_PROTOCOL_2026_08_24.md`
   revision notes) and it is now a hard requirement.
4. Tag full metadata at authoring time:
   - `taxonomy_refs`: the unit node key, the correct `topic-1.X` node key from the table above, and
     the relevant AP practice/skill node key(s).
   - `practice_format` for FRQ items (`targeted_drill`, matching how the first batch's items were
     scoped — these are single-skill practice items, not full-exam FRQ).
   - `difficulty` and `calculator_mode` in `prompt_json` — infer calculator_mode per skill (e.g.
     algebraic limit/discontinuity classification is typically no-calculator; a table-based limit
     estimation would be calculator-allowed) rather than defaulting one way for everything.
   - `review_notes.originality_statement` naming this work order and the source documents by title
     (not by copying their content) — e.g. "Authored fresh per
     CODEX_WORK_ORDER_ORLY_CALC_AB_UNIT1_PART2_2026_09_24; topic scope mined from Orly's Solebury
     School AP Calculus AB Unit 1 Part II materials (2026-09-24), no wording, numbers, or graphs
     reused."
5. **Independent re-derivation is a hard precondition before this can ever move past `draft`**
   (protocol §6 step 4 / `CONTENT_AUTHORING_AND_QA_PROTOCOL.md` §9): re-solve each item from first
   principles yourself and confirm it matches the drafted key/rubric — do not just assert confidence.
   Record what you re-derived and that it matched, in `review_notes`, alongside the originality
   statement. This step was skipped on the first published batch and is now mandatory, not optional.
6. Insert as `status='draft'` and let it walk `draft -> reviewed_approved -> published` normally via
   the existing pipeline guards — do not hand-set `published`.
7. Record the resulting `content_key`s back into `docs/research/orly_source_log/SOURCE_LOG.md`'s new
   row for this batch (replace "Pending" in the "Items authored from it" column).

## Deliverables

- A migration file (or equivalent SQL script, matching the repo's existing pattern e.g.
  `supabase/migrations/` or `scripts/content-seed/`) inserting the draft items, criteria/choices, and
  taxonomy labels — proposal only, do not apply it to Dev or Production yourself.
- A short SUMMARY.md: how many items per topic, MCQ vs FRQ split, the random correct-key assignment
  per MCQ (so it can be spot-checked for an accidental pattern), and the independent re-derivation
  record per item.

## What would make this rejected at QA

- Any wording, number, graph, or distractor traceable back to the source documents.
- A predictable or hand-chosen correct-answer-key pattern across the MCQs.
- An item tagged to a Unit 1 topic code for pure domain-finding (the flagged prerequisite-skill
  case).
- Skipping the independent re-derivation step, or asserting it was done without showing the work.
- Setting `status='published'` directly, or opening a PR / merging to main.
