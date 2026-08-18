# Second opinion: exemplar-injection pilot verdict + gold-set generation project

Repo: `Cramapple`, branch `claude/gold-set-answer-assignments-o3ibgi` (or
`main` if that's merged by the time you read this — check
`docs/activity_log/ACTIVITY_LOG.md`'s top entry to confirm you're on
current state).

## Who you are for this task

You are an independent second opinion, not a continuation of the work below.
A separate Claude session did the work and drew the conclusions you're
reviewing. Your job is to **try to find what it got wrong**, not to confirm
it politely. Where you agree, say so briefly and move on — spend your effort
on disagreement, gaps, and things it didn't check. If you end up agreeing
with everything, that's a fine outcome, but it should be because you
independently verified the primary evidence, not because the writeup reads
persuasively.

Two separate review targets. Don't let one contaminate the other — they're
related (the pilot's exemplars came from the gold-set project) but the
verdict on each stands independently.

---

## Target 1: the exemplar-injection grading pilot verdict

**Do not start by reading the conclusion.** Read the primary evidence first
and form your own view, then read the writeup and compare.

1. Read `docs/research/exemplar_grading_pilot_2026_08/README.md` (execution
   plan/context) and `scripts/grading-model-assessment/harness.ts` in full
   (~190 lines — read all of it, especially `scoreRun` and
   `clusterBootstrapDifference`).
2. Read `docs/research/exemplar_grading_pilot_2026_08/report.json`,
   `raw_trial_variance.json`, and skim `results_with_exemplar.json` /
   `results_without_exemplar.json` (30 cases each) — enough to understand
   what a `ResultCase` looks like.
3. Spot-check `raw_calls.jsonl` (300 lines, ~3MB) — pull a handful of
   records for the same `content_key`/`response_index` across both arms and
   confirm the prompts actually differ only in the exemplar section (this
   was never verified in the current writeup — that's a gap worth checking).
4. Independently answer: **is the reported 95% CI `[0, 12.2]` pp on overall
   accuracy trustworthy?** Specifically interrogate whether
   `clusterBootstrapDifference`'s cluster count (`"clusters": 30"` in
   `report.json`) is the right unit of resampling given that multiple
   `response_index` values share a `content_key` (held-out item). Do the
   math/reasoning yourself rather than taking the claim on faith.
5. Only now read `docs/research/exemplar_grading_pilot_2026_08/REPORT.md`
   (the verdict under review) and the corresponding
   `docs/activity_log/ACTIVITY_LOG.md` entry ("Exemplar-Injection Grading
   Pilot (AP Statistics) Scored..."). Compare against what you found in
   steps 1-4.

Things to specifically pressure-test, not just rubber-stamp:

- Is "the bootstrap treats each held-out item's multiple responses as
  independent when they're not" actually a defect, or is response-level
  clustering defensible here (e.g. if response variance genuinely dominates
  item variance in this grading task)? The writeup asserts pseudoreplication
  without quantifying how correlated same-item responses actually are —
  can you check that from the data (e.g. does `item_correctness` show
  same-`content_key` responses moving together)?
- Is "inconclusive" the right verdict, or does the marginal point estimate
  (+4.7pp) combined with every secondary metric moving the same direction
  (selective accuracy, coverage, FNR, FPR all favor the candidate) actually
  constitute weak-but-real signal that "inconclusive" is underselling?
- The writeup says the 401/409 call failures (29+1 of 330) "recovered via
  resume" and weren't a contributing cause. Verify that claim against
  `raw_trial_variance.json`'s `trial_count` field yourself rather than
  trusting the summary.
- Is there a cheaper fix than "rebuild harness.ts for item-level
  clustering" that the writeup didn't consider — e.g. scoring at the item
  level directly (one `ResultCase` per held-out item, not per response) and
  losing statistical power but gaining validity, given n=4 items?
- Anything about the pilot design itself (not just the scoring) that's
  questionable — the exemplar source, the 5-trial-per-cell choice, the
  4-item/30-response sample size, the specific AP Statistics FRQs chosen.

## Target 2: the gold-set generation project

This is broader scope — not one pilot, but the whole apparatus the exemplar
pilot's exemplars were drawn from, and the thing the readers (Jill
Schmidlkofer, Muhammad Saood, Ahmed Ali, Chisom Anuba, Abdul Hanan, Sarah
Sohail) are actively working against in Production right now.

Read, in order:

1. `docs/research/GOLD_SET_GENERATION_PROTOCOL.md` — the protocol: AI
   generation + two-family blind machine verification + reader
   certification, independence rules R1-R5, Phase 0-5 pipeline, the
   certification gate (upper 95% bound ≤5% certifies / 5-15% diagnose /
   >15% rejects).
2. `docs/research/GOLD_SET_AUTHORING_GUIDE.md` v2.0 — the reader-facing
   guide (readers verify cold, don't author).
3. `docs/research/GOLD_SET_PILOT_STATS_PHYSICS_2026_08_03.md` — the
   pre-registered pilot spec for Set B (Statistics + Physics).
4. `docs/activity_log/ACTIVITY_LOG.md` — search for every entry mentioning
   "gold-set", "gold_set", or "Gold-Set" from 2026-08-03 onward (there are
   several: the model-replacement decision on 2026-08-03, a rubric-ordering
   defect fix on 2026-08-08, roster/assignment changes on 2026-08-10, a
   reviewer-QA addendum on 2026-08-10 where a reader caught a >10x numeric
   error). Build your own timeline of what's actually shipped/verified vs.
   still planned — the individual entries are more current than the
   protocol doc's original snapshot.
5. `docs/research/GRADING_PROGRAM_LEDGER_2026_07_27.md` §3 "Gold sets" — the
   durable-foundations pointer, and check it against what you found in
   step 4 for staleness.

Then independently assess:

- **Is the independence constraint (R1-R5: no OpenAI writer/verifier, no
  same-family writer-verifier pair) actually enforced in what's shipped, or
  only specified in the protocol?** Check the actual generation scripts
  (`scripts/content-seed/gold-set/` if present) for which model families
  were used, not just the doc's claim.
- **Known defects already found, and whether they're symptomatic of a
  deeper generation-quality problem.** At minimum: A3/A6 targeting the same
  "absent" element (collision, said to be fixed), a rubric-answer-ordering
  defect in `APSTATS-SFRQ-010` (fixed per the 2026-08-08 entry), a >10x
  numeric error a reader caught independently (2026-08-10 entry — good sign
  the verification process works, or bad sign the generation quality is
  low? form your own view), and the physics-vs-statistics generator-health
  gap (physics pass-1 script compliance reported far lower than statistics
  in earlier session state — confirm whether this is still current or was
  resolved, since Saood was just added to the physics verification roster
  on 2026-08-10, which could mean either "physics content is now ready to
  verify" or "physics content still needs the same scrutiny statistics
  got").
- **Coverage/completion state**: is the corpus actually at the size the
  protocol/pilot pre-registration expected, or still short (check for any
  "discard" or "regeneration" language in recent activity, and compare
  actual answer counts against the pilot's pre-registered 112 answers /
  14 items / 52 criteria)?
- **Certification status**: has the certification gate (≤5% false-accept
  upper bound) actually been evaluated for Set B yet, or is verification
  still in progress with no gate decision made? Don't assume from the
  protocol doc that this happened — verify from the activity log.
- **Whether the exemplar pilot's failure has any bearing on the gold-set
  project's own validity.** The exemplar pilot used gold-set answers as
  its few-shot source and its own gold labels for scoring — if gold-set
  answer quality is itself unresolved (open defects, incomplete
  certification), does that undermine confidence in the exemplar pilot's
  *inputs* independent of the harness clustering bug already found? This is
  a question the current pilot writeup doesn't address at all.

## What to produce

A single markdown report, structured as:

1. **Exemplar pilot: agree / disagree / partially agree with the
   "inconclusive, do not ship" verdict**, with your reasoning and any
   errors you found in the existing writeup (cite file + line/field, not
   just prose).
2. **Gold-set project: your independent read of current status, risk, and
   whether readers/Production are exposed to any defect the existing docs
   understate.**
3. **Anything either review surfaced that isn't in
   `docs/activity_log/ACTIVITY_LOG.md` yet** — new findings, not just a
   critique of old ones.
4. **Your own confidence level** in each verdict and what would change your
   mind.

Do not edit any files. Do not touch Production (Supabase MCP or otherwise)
— this is a read-only documentation and data review, not an execution task.
If you need to see something not covered by the file pointers above, search
the repo yourself rather than asking to be told where it is.
