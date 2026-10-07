# Open Hand teaching batch — authoring spec (TASK-0065)

**Date:** 2026-10-06 · **Subjects:** AP Biology, AP Statistics, AP Chemistry, AP Calculus AB
**Author family:** Anthropic (Claude). Under DECISION-0093, no Anthropic model may act as a checker for this batch.
**Stage covered here:** authoring and deterministic recompute only. The two outside-family checker stages run
later through the AI Gateway (Product Owner picks the slate). Nothing in this stage writes to any database.

## What an Open Hand teaching item is

Open Hand is a worked-example screen. The student sees the question with the answer key face up and every
choice's explanation visible on load. It is never scored. So the item has to teach: each rationale is the
lesson.

## Scope per subject

One MCQ for every published topic point brief that has no active teaching item. Pull the gap list and the
fact pack with the SQL in `FACT_PACK_QUERY.sql` (Production, read-only; set `bkey` / `rkey`).

| Subject | brief key (`bkey`) | raw key (`rkey`) | Gap topics |
|---|---|---|---:|
| AP Biology | `ap_biology` | `biology` | 58 |
| AP Statistics | `ap_statistics` | `ap-statistics` | 41 |
| AP Chemistry | `ap_chemistry` | `ap-chemistry` | 84 |
| AP Calculus AB | `ap_calculus_ab` | `ap-calculus-ab` | 69 |

## Item standard (from `docs/new_design/CONTENT_AND_PEDAGOGY.md` and TASK-0065)

1. **On topic.** The item tests the topic in its brief and is answerable from that topic's content at AP level.
   It stays inside the CED: no content the brief and explainer do not support.
2. **Four choices, exactly one correct.** Keys A–D. Choice lengths roughly balanced; the correct answer is not
   reliably the longest. Spread the correct key across A–D over the batch (roughly even).
3. **Every distractor is a named trap.** Its rationale says (a) why it tempts (the specific misconception or
   slip) and (b) the one-line fix. Write it as a sentence a student reads, e.g. "Tempting if you … — but … .
   Fix: … ." 1–3 sentences, plain language.
4. **The correct choice's rationale explains why it earns the point**, in 1–3 sentences. Never just
   "Correct" or "Credited".
5. **The stem never repeats the choices inline.** No "Which of the following…: I, II, III" unless that is the
   AP format being taught. No "all of the above" or "none of the above".
6. **No calculator-only or figure-dependent items.** A small table written in the stem as plain text is fine.
   No image, graph or diagram the student would need to see. Calculus: no graphing-calculator items.
7. **Student-facing text only.** No internal IDs, content keys, "brief", "fact pack" or source notes.
8. **Seeds.** When the fact pack carries a `seed` (a published, scored MCQ on the same topic), use it only as a
   style and difficulty anchor. The new item must NOT be a near-copy: a different scenario, different numbers,
   a different stem, and a different correct-answer idea where possible. A student who studies the teaching
   item must not thereby learn the seed's answer. When there is no seed, write from the brief and explainer.
9. **Numeric items** (Statistics, Chemistry, Calculus): compute the key and every distractor's value with
   Python (sympy where symbolic) BEFORE writing the choice text, and record the computation in `verification`.
   Each numeric distractor should come from a named slip, and its rationale names that slip.

## Output

One JSON file per subject: `<rkey>.json` in this directory. It holds an array with one object per gap topic,
in course order:

```json
{
  "subject_key": "biology",
  "unit_number": 1,
  "topic_code": "1.1",
  "topic_title": "Structure of Water and Hydrogen Bonding",
  "seed_used": true,
  "stem": "…",
  "choices": [
    {"choice_key": "A", "choice_text": "…", "is_correct": false, "rationale": "…"},
    {"choice_key": "B", "choice_text": "…", "is_correct": true,  "rationale": "…"},
    {"choice_key": "C", "choice_text": "…", "is_correct": false, "rationale": "…"},
    {"choice_key": "D", "choice_text": "…", "is_correct": false, "rationale": "…"}
  ],
  "verification": "how the key was confirmed (computation for numeric items; the brief/explainer fact it rests on otherwise)",
  "author_flags": "anything a checker should look at, or empty"
}
```

Plus `<rkey>_README.md`: counts, topics skipped and why (should be none), seed use count, key-letter
distribution, and any self-flags.

## Self-check before saving (author's own pass; not a substitute for the checkers)

- Exactly one `is_correct: true` per item. Keys A–D present once each.
- Re-solve each item blind from the stem alone; the answer must match the key.
- No near-copy of the seed (compare stems and the correct choice).
- No banned words: "Credited", "all of the above", "none of the above".
- JSON parses (`python3 -c "import json;json.load(open(...))"`).
