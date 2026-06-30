# Codex Execution Prompt — TASK-0013 Phase 3: Deterministic Calculation-Check Verifier

**Cleared to execute.** Depends only on Phase 1 (merged, PR #20). Does not
touch the database, so it is not blocked on Phase 2's migration sign-off —
that sign-off is still pending separately and this prompt does not grant it.

## Context

AP Statistics FRQ criteria frequently require a computed numeric answer (a
test statistic, p-value, confidence interval bound, or similar) as part of
the evidence a student must show. AP Biology's FRQ grading is entirely
LLM-judgment-based; AP Statistics needs a second, non-LLM signal for this
specific failure mode, because an LLM grader can be talked into accepting an
arithmetically wrong answer if the surrounding prose reads confidently.

This is `CONTENT_AUTHORING_AND_PROMPT_ARCHITECTURE.md` §7's "deterministic
calculation checks" — named as a verification technique, not yet built for
any subject. The closest existing precedent in this repo is
`scripts/misattribution-check/checker.py`: a standalone, deterministic,
non-LLM script that reads one JSON object per line from stdin and writes one
JSON verdict per line to stdout, used as an independent second opinion
alongside (not instead of) the LLM grader. Follow that same shape — don't
invent a new protocol.

**Important constraint:** Phase 2 (the `app.subjects`/`exam_pack`/
`taxonomy_scheme` rows for AP Statistics) has not happened yet, and no real
AP Statistics content exists in the database. This means there is nothing
live to test against. Build and validate this against **synthetic,
hand-authored test cases**, not live content — and do not assume Phase 2's
schema shape; if you need to know how a criterion's expected numeric answer
and tolerance would be represented, propose a plausible JSON shape and state
the assumption explicitly rather than querying a database that doesn't have
this data yet.

## Goal

A standalone deterministic checker that takes a student's stated calculation
work for one FRQ criterion and an expected-answer specification (value,
tolerance, and which calculation type), and returns a verdict on whether the
student's computed result is numerically consistent with that specification
— independent of whether their prose/reasoning was correct (that's still the
LLM grader's job).

## Scope

1. Read `scripts/misattribution-check/checker.py` in full first, including
   its comments about specific false-positive cases it had to guard
   against (e.g. negation scope, ambiguous lemma co-occurrence) — those are
   examples of the kind of edge case this verifier needs to anticipate for
   numeric extraction, not just a stylistic reference.
2. Cover at minimum these AP Statistics calculation types, since they
   recur across the unit weighting recorded in `TASK-0013-AP-STATISTICS-LAUNCH.md`'s
   Approval State section: a computed test statistic (z or t), a p-value,
   and a confidence interval (lower/upper bound). Pick a clear input
   contract for "expected answer" that allows a numeric tolerance (e.g.
   match within a specified absolute or relative epsilon) — AP Statistics
   rubrics generally accept a range of correct answers depending on
   rounding/method, not one exact value.
3. The checker must extract a numeric claim from free-text student work
   (e.g. "t = 2.31" or "the 95% CI is (12.4, 18.9)") and compare it against
   the expected-answer spec. Define and document what happens when:
   - no numeric claim can be extracted (verdict should be something like
     `indeterminate`, not a false `matches`/`does_not_match`);
   - multiple numeric claims appear and it's ambiguous which one answers
     the criterion;
   - the student's value is close but outside tolerance (must be a clear
     `does_not_match`, not silently rounded into a pass).
4. Write a test suite with synthetic cases covering: exact match, within-
   tolerance match, out-of-tolerance near-miss, no extractable number,
   ambiguous multiple numbers, and at least one realistic "confidently
   wrong" example (mimicking the LLM-grader failure mode this exists to
   catch).
5. Do not wire this into `evaluate-attempt` or `grade-frq` in this phase —
   there's no AP Statistics content or criterion data for it to read from
   yet (that's Phase 2/4). Keep it a standalone, independently testable
   module/script, same as the misattribution checker.

## Out of Scope

- Any LLM calls — this must be deterministic, by definition (that's the
  point of building a second, non-LLM signal).
- Database schema, migrations, or AP Statistics content/taxonomy authoring.
- Wiring this verifier into the live grading edge functions.
- Calculation types outside the test-statistic/p-value/confidence-interval
  set above — flag other types you notice are likely needed (e.g.
  regression slope, chi-square statistic) as a follow-up note rather than
  building all of them now.

## Required Evidence on Completion

- The verifier module/script and its test suite, with the test suite
  passing.
- A short note stating the assumed input contract for "expected answer
  spec" (since Phase 2's actual schema doesn't exist yet) and what would
  need to change if Phase 2 lands with a different shape.
- A short note on where/how this would plug into `evaluate-attempt` once
  Phase 2/4 exist — mirroring how Phase 1's note described where Phase 2
  plugs in.

## Do Not Touch

- Production environment, secrets, or deployment config.
- `app.subjects`, `app.exam_packs`, or any other live schema/data.
- `supabase/functions/evaluate-attempt/index.ts` or
  `supabase/functions/grade-frq/index.ts`.

## Next Expected Output

A PR against `main`, branch-prefixed `codex/...`, with `TASK-0013` referenced
in the description, ready for the same independent QA pattern used on PR #20
(fresh-context review, verify claims from source, Pass/Fail with file:line
findings — no self-certification).
