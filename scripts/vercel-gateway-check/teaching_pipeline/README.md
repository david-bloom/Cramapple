# Open Hand teaching items: generate and select (TASK-0065)

David, 2026-10-06: "We need a way to add questions without needing to edit them, using at least 4 models and
multiple sessions." This pipeline replaces hand-patching. **No item is ever edited.** A candidate is accepted
whole or dropped whole.

## Why

Hand-patched batches kept failing new checks:
- the rules (named traps, action fixes) were applied after the items were written;
- single model calls are noisy;
- every patch needed a full re-check.

Here the author and the checkers read the same rubric, four model families must agree, and failures are
regenerated, never repaired.

## How it works

| Step | What happens |
|---|---|
| Rubric | `rubric.mjs` holds the one rubric. The author prompt and every checker prompt are built from it. |
| Authors | Each round has two stateless authors, GPT-6.1 then Claude Opus 5.5 (`--author-order`). They run in sequence: the second writes only if the first's candidate is rejected. An author never sees the other candidate, an earlier candidate, or checker feedback. |
| Prompt caching | Long prompts put the fixed part (role, rubric, full fact pack) first, so providers serve it from cache; Claude's prefix carries an explicit cache marker. Cost per accepted item fell from $0.72 to $0.28 (`task0065-cost-test-2026-10-07/RESULTS.md`). |
| Key position | The runner places the correct answer at a deterministic random letter. |
| Lint | Deterministic rules (`lint()` in `rubric.mjs`). Any failure rejects the candidate. |
| Blind solve | 4 checkers solve the question without the key. Any wrong answer, second defensible answer or defect counts as a flag. |
| Rubric audit | The same 4 checkers judge every rubric rule and name the topic the item tests, with the full CED fact pack and the unit's topic list. Biology topics also carry their CED learning objectives and essential knowledge. |
| Checker families | Five families: OpenAI, Google, DeepSeek, Meta (Muse Spark 1.3; Moonshot's Kimi K3 before 2026-10-07), Anthropic. Every candidate is checked by the **four that did not write it**. Swap the fourth with `--fourth=<model>` only after `run.mjs calibrate` passes. |
| Fact pack | `--pack=scoped` (default): every course-wide section plus units up to the item's unit. `--pack=full` sends the whole pack. |
| Noise control | A checker that flags is re-sampled once. The candidate is rejected only if the re-sample flags too. |
| Veto | After the four pass, the **author's own family** audits too. It can reject but never approve, so every accepted item has passed all five families. Added after the Biology pilot: the strictest checker (GPT-6.1) never saw GPT-written candidates, so the bar depended on who wrote the item. |
| Accept | The first candidate that passes lint, all 4 solves, all 4 audits and the veto is accepted. |
| Escalate | If a topic has no accepted candidate after `--rounds` rounds (default 2, so 4 candidates), it is escalated to a human, never patched. |
| Controls | `controls.json` holds 6 planted-defect items (lint, wrong key, fact-style fixes, missing traps, false fact, wrong topic). They run before any generation. **If any control is accepted, the batch is void and nothing is generated.** |

## Running it

Run from `scripts/content-seed/task0065-generate-select/`:

```bash
node ../../vercel-gateway-check/teaching_pipeline/run.mjs run --batch=<batch-dir> --subject=biology --session=<your-name>
```

For a batch accepted before the veto existed, apply it. Vetoed topics reopen for the next `run`:

```bash
node ../../vercel-gateway-check/teaching_pipeline/run.mjs veto --batch=<batch-dir>
```

Then report:

```bash
node ../../vercel-gateway-check/teaching_pipeline/run.mjs report --batch=<batch-dir>
```

Options:
- `--topics=1.1,1.2` limits the run to those topics.
- `--shard=k/n` takes every n-th topic starting at k.
- `--rounds=2` sets the number of rounds per topic.
- `--conc=3` sets how many topics run in parallel.

`report` writes:
- `accepted.json`: batch item shape plus `provenance`, ready for the Development load.
- `summary.json`: per-subject accepted/escalated counts and candidate outcomes by stage.

## Multiple sessions

- **Same machine:** sessions share one batch directory. Each topic is claimed with an exclusive lock file
  (`claims/<topic>.lock`, expires after 3 hours) before work starts, so two sessions never work one topic.
- **Different machines:** give each session a disjoint `--shard=k/n` and commit its batch directory to its own
  branch. Lock files do not cross machines.
- **Resuming:** state is written after every candidate (`topics/<subject>__<topic>.json`). A rerun resumes at the
  next round and skips accepted or escalated topics.

## What a human still does

- Reads the escalated topics.
- Spot-checks a sample of accepted items per subject before the first publish (TASK-0065).
- Approves the Production load (Hard-Gate).

The checkers clear an item. They do not replace that sample.
