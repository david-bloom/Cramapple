# Coaching prototype results — 2026-11-11 (Phase 2, first pass)

Script: `proto.mjs` (needs `node_modules` symlinked to `../../vercel-gateway-check/node_modules`; removed after the run).
Data: `sample.json` (8 published MCQs, 4 Statistics + 4 Biology), `out/results.jsonl`, `out/judged.json`, `out/summary.json`.
No student data was sent: misses are synthetic (every distractor of each item), histories are invented.
Total spend across both runs: about $0.81 (first run $0.34 had judge-schema and token-limit bugs; the figures below are from the fixed rerun, $0.46).

## Setup
- Generators: `anthropic/claude-haiku-5.5`, `openai/gpt-6-luna`, `deepseek/deepseek-v4-flash`.
- Judges (never a generator family): `google/gemini-3.8-flash`, `zai/glm-5.3-flash`.
- T1: 24 coaching texts per model (8 items x 3 distractors). T2: 4 synthetic cases per model (repeat miss,
  cross-session repeat, improving, "explain more").
- T0 baseline: 24 floor texts composed like `TASK-0053` (chosen choice's authored rationale plus a question). This is an
  approximation of the real composer, not its output.
- Controls: 4 planted wrong-teaching texts. Both judges caught 4 of 4.

## Quality (judge means, 1-5; factual fail = a judge found a contradiction)
| Tier / model | n | factual fail | both judges pass | specific | names point | move | would help | words | ms |
|---|---|---|---|---|---|---|---|---|---|
| T0 floor | 24 | 0.02 | 0.96 | 2.09 | 0.54 | 1.00 | 1.58 | n/a | 0 |
| T1 haiku-5.5 | 24 | 0.04 | 0.92 | 4.20 | 3.81 | 4.10 | 4.16 | 100 | 2,668 |
| T1 gpt-6-luna | 24 | 0.02 | 0.96 | 3.47 | 3.29 | 3.18 | 3.47 | 59 | 4,278 |
| T1 deepseek-v4-flash | 24 | 0.00 | 0.96 | 3.94 | 3.70 | 3.85 | 3.93 | 79 | 7,795 |
| T2 haiku-5.5 | 4 | 0 | 1.00 | 3.63 | 2.88 | 3.50 | 3.63 | 86 | 4,099 |
| T2 gpt-6-luna | 4 | 0 | 1.00 | 3.50 | 2.75 | 3.00 | 3.41 | 66 | 6,058 |
| T2 deepseek-v4-flash | 4 | 0 | 1.00 | 3.13 | 3.00 | 3.13 | 3.05 | 83 | 22,599 |

## Cost (gateway list prices; reasoning tokens bill as output)
| Tier / model | avg cost per call | avg output tokens (of which reasoning) |
|---|---|---|
| T1 haiku-5.5 | $0.000354 | 455 (255) |
| T1 gpt-6-luna | $0.000222 | 283 (194) |
| T1 deepseek-v4-flash | $0.000207 | 606 (498) |
| T2 haiku-5.5 | $0.000515 | 754 (596) |
| T2 gpt-6-luna | $0.000284 | 395 (309) |
| T2 deepseek-v4-flash | $0.000532 | 1,877 (1,769) |

Reference: today's FRQ grading averages about $0.0091 per result; MCQ grading is $0.
Implicit provider caching already served 17,664 of 82,975 input tokens (21%) with no cache tuning.

Projections from these averages (indicative, not a budget):
- Batch-filling T1 for every Biology and Statistics distractor (about 2,583): roughly $0.53 (deepseek) to $0.91
  (haiku) per full pass.
- A T2 call is about 3-6% of the price of one FRQ grade. 1,000 T2 calls cost about $0.28-$0.53.

## What the flagged items show (3 of 72 T1 texts; judged with both models)
- haiku, Statistics 1.12 (chose B): wrote "Every student was emailed", but only a random sample of 500 was. A real
  invented fact.
- haiku, Statistics 2.8 (chose B): misattributes the error to a brief habit that is about cumulative values, not
  the at-most/at-least slip. A grounding miss.
- luna, Statistics 2.8 (chose C): says the student "treats X>=3 as X=4"; the authored rationale says the error is
  leaving out P(X=3). Mild misdiagnosis.
- The only T0 flag is the approximate floor mis-framing a rationale, not a coaching fault.

## Reading
- Model coaching beats the T0 floor on every quality axis by about 1.5-2 points; the biggest gap is naming the exam
  point (0.5 vs 3.3-3.8).
- Roughly 1 in 24 texts carried a real inaccuracy. That is enough that unreviewed live T2 output is a risk and T1
  cache-fill needs the checker review step before serving.
- haiku is best on quality and fast but overruns the 90-word rule (avg 100). luna is cheapest to run and shortest
  but weaker. deepseek flash burns 500-1,800 reasoning tokens and takes 8-23 s, which is poor for a live card.
- T2 histories were used (3.0-3.5 on "uses history") but the sample is only 4 per model.

## Limits
Small sample (8 items, 24 + 4 texts per model); synthetic misses and histories; judges are models and disagree
(GLM flagged items Gemini passed, and Gemini caught the one invented fact); the scoring scale is unbounded in the
schema (a few odd values); no FRQ coverage; T0 is an approximation; no human read yet.

---

# Second pass — 30 MCQs and 10 FRQs (2026-11-11)

Script `proto2.mjs`; data `mcq30.json`, `frq10.json`, `out2pass/`. 15 Biology + 15 Statistics MCQs (every distractor, 90 first-miss
texts per model, plus 10 personal-tier cases covering repeat, cross-session, improving, "explain more" and earned praise).
10 FRQs (5 + 5, hand-drawn-graph items excluded) with synthetic student responses written to miss known criteria (all 10
responses matched their labels per both judges). No student data sent. Prompts now cap MCQ coaching at 80 words and FRQ at 110.

Spend: $1.52 total (generation $0.087, synthetic responses $0.006, judging $1.43 over 874 calls).
**Measured review cost: $0.00164 per judge call**, so two judges over 2,583 texts is about $8.5.

## Results (judge means out of 5; "flag" = either judge found a contradiction or an unfaithful claim)
| Tier / model | n | flag rate | both clean + tone ok | lint fail | would help | move | names point / targets missed | words | $/call | ms |
|---|---|---|---|---|---|---|---|---|---|---|
| T0 floor (MCQ) | 90 | 0.03* | 0.97 | 0 | 2.77 | 2.24 | 1.51 | n/a | 0 | 0 |
| T1 gpt-6-luna | 90 | 0.033 | 0.97 | 0 | 4.57 | 4.31 | 4.42 | 53 | 0.00021 | 3,386 |
| T1 haiku-5.5 | 90 | 0.033 | 0.97 | 0.16 | 4.46 | 4.30 | 4.02 | 81 | 0.00038 | 3,271 |
| T1 deepseek-v4-flash | 90 | 0.078 | 0.92 | 0 | 4.23 | 4.10 | 3.90 | 57 | 0.00015 | 4,236 |
| T2 gpt-6-luna | 10 | 0 | 1.00 | 0 | 4.30 | 3.80 | 4.00 (hist 4.0) | 52 | 0.00026 | 4,215 |
| T2 haiku-5.5 | 10 | 0 | 1.00 | 0.10 | 4.40 | 4.35 | 3.60 (hist 4.15) | 76 | 0.00046 | 4,039 |
| T2 deepseek-v4-flash | 10 | 0 | 1.00 | 0 | 4.45 | 4.20 | 3.83 (hist 4.1) | 53 | 0.00016 | 5,743 |
| FRQ T0 floor (authored fix lines) | 10 | 0.10 | 0.90 | 0 | 2.78 | 2.11 | 4.10 | n/a | 0 | 0 |
| FRQ haiku-5.5 | 10 | 0 | 1.00 | 0 | 4.75 | 4.70 | 4.80 | 100 | 0.00059 | 3,966 |
| FRQ gpt-6-luna | 10 | 0 | 1.00 | 0 | 4.15 | 4.15 | 4.15 | 63 | 0.00029 | 4,321 |
| FRQ deepseek-v4-flash | 10 | 0 | 1.00 | 0 | 3.95 | 3.95 | 3.95 | 89 | 0.00025 | 4,904 |

\* The T0 flags come from how my approximation of the floor frames a rationale ("the choice you picked: ...") and say little about the
real composer. Treat the T0 flag rate as noise.

Planted controls: 7 of 7 caught by both judges (4 MCQ wrong-teaching, 3 FRQ "says you left out what you wrote").
Lint: 15 of 90 haiku T1 texts broke the word cap even at an 80-word instruction; nothing else tripped lint.

## What the 13 flagged model texts show (of 330)
About 9 are real errors a student would have been taught:
- wrong arithmetic direction (said omitting n "inflates" z when it deflates it; said omitting R makes a concentration "too high");
- an invented probability ("2/500 each" for two $100 prizes);
- misattributed brief habits (deepseek twice, haiku once);
- misstating what the student picked ("because the triglyceride floats" when the choice says it sinks);
- calling an MCQ miss "a lost complete-description point".
About 4 are judge nitpicks or single-judge disagreements. DeepSeek flash produced 7 of the 13 (7.8% flagged versus 3.3% for luna and
haiku). Zero of 30 FRQ coaching texts were flagged.

## Reading
- Model coaching beats the floor by about 1.7-1.8 points on "would help" and by about 2.5 on naming the exam point. FRQ coaching reads the
  student's own wording and was never judged unfaithful.
- The real-error rate is roughly 3-4% of texts, so a review gate is mandatory for the pre-filled cache and live personal calls need a guard.
- gpt-6-luna is the best MCQ choice here: highest quality, shortest, never over the word cap, $0.0002 per text. haiku-5.5 is best for FRQ
  (4.75 vs 4.15) at about $0.0006 per call, 6.5% of an FRQ grade. deepseek flash is cheapest but least reliable.
- The first pass ranked haiku above luna by a wide margin; after the tighter prompt, luna led. Model ranking is sensitive to the prompt,
  so pick models after the prompt is frozen.

## Cost projection from these numbers
- Pre-fill 2,583 Biology and Statistics distractors with luna: about $0.54 generation (haiku $0.99).
- Review with two judges: 5,166 calls x $0.00164 = about $8.5. Regenerating and re-reviewing the roughly 5% that fail adds about $0.5.
- One-time total about $9-10.
- A personal MCQ call about $0.0003-0.0005; a personal FRQ coaching call about $0.0003-0.0006.

## Limits
Synthetic misses, synthetic FRQ responses (same family as one generator), model judges only (2), 10 FRQs, no human read, prompt tuned on this
sample, no hand-drawn FRQs, T0 is an approximation, no real student traffic.
