# Pipeline Cost Levers 2 and 3: Measured (2026-10-07)

Follows `../task0065-cost-test-2026-10-07/RESULTS.md` (lever 1: $0.72 to $0.28). Same 24 topics, same
procedure, and blind held-out re-judging, because lever 3 changes what checkers see. Nothing was written to any
database.

## What was tried

| Lever | Result |
|---|---|
| **GPT, Gemini and Kimi caching** | Probe: three identical-prefix calls each, with the default setup, an explicit cache key, and a pinned provider. **GPT and Gemini reported 0 cached tokens in every setup** through the gateway. Kimi caches once warm (14,272 of 14,332 tokens on later calls) but not in parallel bursts. Nothing further to do from our side; Kimi is replaced below anyway. |
| **Cheaper fourth checker** | Calibrated against Kimi K3 on 9 known-defect items (6 controls without the lint-only one, plus 4 planted) and 24 judge-cleared items (`../task0065-checker-calibration-2026-10-07/`). |
| **Unit-scoped fact pack** | Every course-wide section is kept (exam structure, practices, exclusions, conventions) plus every `### Unit N` block up to the item's unit; later units are dropped. Size: Biology Unit 1 51K → 16K characters, Chemistry Unit 1 −67%, Calc AB Unit 2 −55%, Statistics Unit 3 −18%. |

### Calibration

| Candidate | Defects caught | Clean items flagged | Cost per audit | Median time | Verdict |
|---|---:|---:|---:|---:|---|
| Kimi K3 (incumbent) | 9 / 9 | 2 / 24* | $0.089 | 19 s | baseline |
| **Meta Muse Spark 1.3** | **9 / 9** | **2 / 24*** | **$0.039** | 26 s | **adopted** |
| Nvidia Nemotron 3 Ultra | 8 / 9 | 13 / 24 | — | — | rejected: misses a defect and over-flags |
| Tencent HY4 preview | — | — | — | — | rejected: structured-output failures |
| Thinking Machines Inkling | — | — | — | — | rejected: every call failed the schema |

\* The same two items in both cases: the two Calculus items written in LaTeX. The new no-LaTeX lint now rejects
them anyway, so both checkers effectively have zero false flags. Meta is a family used by no author, checker or
judge.

## Results (Muse Spark + scoped pack, same 24 topics)

| | Full pack + Kimi (lever 1) | **Scoped pack + Muse Spark** |
|---|---:|---:|
| Topics accepted | 24 / 24 | **24 / 24** |
| Candidates | 26 | 30 |
| Cost per accepted question | $0.28 | **$0.20** |
| Fourth-checker cost | $1.89 (Kimi) | $0.86 (Muse Spark) |
| Wall-clock | 10.1 min | 11.2 min |
| Controls caught (pipeline) | 6 / 6 | 6 / 6 |
| **Blind held-out re-judge: items with a confirmed defect** | 0 / 24 | **0 / 24** |
| Pedagogy clean / publish as is | 24 / 24 | **24 / 24** |
| Numeric keys recomputed | 12 / 12 | 11 / 11 |

**Re-judge notes:**
- **Adjudicated as not defects** (`judging/adjudication_reasons.json`):
  - one topic dispute, a parse artifact (a judge answered with a CED code);
  - two scope disputes, standard one-sided continuity, and a correct reading of CED 2.3.A.1.
- **Judge panel sensitivity.** 3 of the 4 planted defects reached the confirmed threshold. The planted false
  statement (P2) was flagged consistently by one judge only, so it scored as disputed. Disputes go to adjudication,
  where it would be confirmed, but this panel run was a little less sensitive on Q2 than the earlier two.
- **No LaTeX** appeared in this run.

## Adopted as defaults (`run.mjs`)

- `--pack=scoped` is now the default (`--pack=full` stays available).
- The fourth checker is now `meta/muse-spark-1.3`, replacing `moonshotai/kimi-k3`. `--fourth=<model>` swaps it
  after calibration.
- **Cumulative:** $0.72 → $0.20 per accepted question (−72%), with no measured quality loss.
