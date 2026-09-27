# New-session handoff — Work Order N Biology serving labels

Start a fresh Codex session in /Users/davidbloom/Documents/Cramapple.nosync and give it this
instruction:

> Read and execute
> /Users/davidbloom/Documents/Cramapple.nosync/prompts/CODEX_WORK_ORDER_N_BIOLOGY_SERVING_LABELS_2026_09_24.md
> completely. The prompt already incorporates the prior Codex preflight review. Follow its branch,
> proposal-only, two-model, disagreement, MCQ-evidence, audit, artifact and stop rules. Do not ask to
> revisit settled review questions unless Production no longer returns exactly 43 N items or another
> stated invariant cannot be satisfied.

## State at session close

- The checkout was clean on main and tracking origin/main when the prompt review began.
- No Work Order N labeling calls were made.
- Production was not queried or written.
- The two-model gateway was not invoked.
- No proposal artifacts or QA files were created.
- Work Order N and N.1 remain entirely unexecuted.

## First actions in the new session

1. Fetch origin and create or update codex/work-order-n-biology-serving-labels from current
   origin/main as directed by the authoritative prompt.
2. Re-read the prompt, launch-readiness assessment, T9/T4 sections of
   docs/architecture/TAXONOMY_LABELING_PLAN_V3_2026_08_04.md, the N.1 QA report, and the existing
   generator before editing it.
3. Confirm the corrected current-version query returns exactly 43 unlabelled published Biology
   short FRQs. Stop and report if it does not.
4. Add and use a proposal-only N/N.1 mode; never use or expose the generator's database-write path.
5. Run the two named models blind to one another, produce all required artifacts, validate the
   invariants, commit and push the proposal branch, then stop for Claude QA.

The authoritative work-order prompt contains the resolved judgement calls. This handoff is only a
navigation and state record; if the two documents ever differ, the work-order prompt governs.
