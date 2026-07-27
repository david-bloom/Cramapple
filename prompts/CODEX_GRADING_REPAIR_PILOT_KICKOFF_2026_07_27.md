# Kickoff: Execute the Engine 1 Grading + Repair Pilot

Repo: `Cramapple`. Branch: `claude/cramapple-grading-experiments-9lkjqc` (or its
current successor — confirm `supabase/functions/_shared/grading-router.ts` and
`grading-repair.ts` exist before proceeding).

Full spec, all 30 candidate answers, and content mappings are already prepared:
**read `docs/research/grading_repair_pilot_2026_07_27/README.md` in full before
doing anything else** — it has the exact execution plan, guardrails, and
required cleanup steps. This prompt is just the kickoff instruction; the spec
is the source of truth.

## The goal

David wants real data on three things, in this priority order (do not
optimize one at the expense of a higher one): **accuracy** — does Engine 1's
grading and repair logic actually score a range of real student-quality
answers sensibly — then **speed**, then **cost**. This is the first time
Engine 1 has been run against real published/reviewed content with a range of
realistic student answers rather than synthetic test fixtures, so treat
correctness of execution (not just "did it run") as the priority — a wrong or
sloppy pilot run is worse than no pilot run, since it would produce misleading
signal for a decision (Engine 1 rollout scope) that actually matters.

## What to actually do

1. Read `docs/research/grading_repair_pilot_2026_07_27/README.md` fully.
2. Read `docs/research/grading_repair_pilot_2026_07_27/candidate_answers.json`
   — this has all 6 items and 30 answers, pre-mapped to real
   `content_item_version_id`s.
3. Follow the README's execution plan exactly: pre-flight verification, create
   the one isolated test student identity, run all 30 answers through the
   real `evaluate-attempt` path, capture results, write the analysis report,
   then **run the cleanup step — this is not optional**.
4. Produce `docs/research/grading_repair_pilot_2026_07_27/RESULTS_2026_07_27.md`
   per the README's "Analyze and report" section, and
   `docs/research/grading_repair_pilot_2026_07_27/EXECUTION_LOG.md` recording
   what test identity/rows were created and confirming they were all deleted.
5. Commit the results + execution log (not the test data itself, which should
   no longer exist in Production by the time you commit).

## Guardrails (repeated from the README — do not skip)

- The only identity touched must be the one isolated synthetic test student
  created for this pilot. Never touch real student, tutor, or admin data.
- All Production writes from this pilot must be deleted by the end — verify
  with a final query, not just by running the delete statements.
- Do not change `status` or review decisions on the 6 real content items.
- This is independent of the publish-without-approval backfill and the
  branch-consolidation merge already queued — don't block on either.

## When you're done

Report back: the accuracy/speed/cost findings, whether repair behaved
sensibly, whether anything here should block or reshape the wider Engine 1
rollout plan (`docs/GRADING_PROGRAM.md`), and confirmation that all test data
was cleaned up.
