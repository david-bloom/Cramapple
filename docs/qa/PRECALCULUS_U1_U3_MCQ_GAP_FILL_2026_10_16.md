# Precalculus Units 1–3 MCQ gap fill — prepared run, 2026-10-16

**State:** Census and source/plan preparation complete; new-batch slate confirmation pending under protocol §2.1. No inference calls, authored items or database writes yet. Owner instruction: identify zero-MCQ topics, create two MCQs and three variants. Interpreted consistently with the seed pipeline as three variants of each seed.

Fresh read-only Production census: **181 practice MCQs across 44 topics; 11 empty topics**. Each topic has at least one FRQ. Count latest published versions with current primary topic cells, excluding active Open Hand teaching items. All 11 empty practice topics already have a teaching MCQ; those were retrieved into a private comparison bank so new seeds can target distinct ideas.

| Unit | Empty topic | Title | Seeds | Variants |
| ---: | --- | --- | ---: | ---: |
| 1 | 1.1 | Change in Tandem | 2 | 6 |
| 1 | 1.3 | Rates of Change and Behavior of Graphs | 2 | 6 |
| 1 | 1.11 | Equivalent Representations | 2 | 6 |
| 2 | 2.1 | Change in Arithmetic and Geometric Sequences | 2 | 6 |
| 2 | 2.2 | Change in Linear and Exponential Functions | 2 | 6 |
| 2 | 2.8 | Inverse Functions | 2 | 6 |
| 2 | 2.9 | Logarithmic Expressions | 2 | 6 |
| 2 | 2.14 | Logarithmic Function Context and Data Modeling | 2 | 6 |
| 3 | 3.4 | Sine and Cosine Function Graphs | 2 | 6 |
| 3 | 3.8 | The Tangent Function | 2 | 6 |
| 3 | 3.15 | Rates of Change in Polar Functions | 2 | 6 |

Total: **22 seeds + 66 variants = 88 items**. Nonempty topics are excluded from generation. Existing 1-MCQ topics 2.4 and 2.12 are left unchanged because the request targets zeros only.

## Checking and gates

Authorship in-session; deterministic answer placement and lint. Four non-author families (Anthropic, Google, DeepSeek, Meta), OpenAI reject-only veto, re-sampling repeated flags, independent numeric recomputation. Six planted defects and structured-output smoke checks before authoring. Seed topic labels need ≥5/6; skills need ≥3/4 else practice-level fallback; difficulty remains provisional. Each variant gets the same QA and a word-3-gram Jaccard gate ≤0.35 against its seed and accepted siblings, then inherits labels. No paid author calls or cheaper-checker substitution is planned.

Refreshed live slate input/output USD per million: Opus 5.5 $4/$20; Gemini 3.8 Flash $0.75/$3.75; DeepSeek V4 Pro $0.66/$1.98; Meta Muse Spark 1.3 $1.25/$4.25; GPT-6.1 $2/$10. Expected $20–30 for the entire run, proposed $30 ceiling including controls, errors, vetoes, re-samples and labels. Confirmation requested in chat; no spend while pending. Budget reservations precede dispatch; every actual SDK attempt is logged with retries disabled.

The user's current instruction authorizes seeds and variants without the Statistics task's Stage A/B start gate. Production publication still requires the canonical plan/preflight/rollback rehearsal and separate recorded Hard-Gate approval. No Production write or More help change is authorized by this preparation.

## Sources and scope

Canonical main verified at `9ae2a96515b82f1b1686eb5f8985d0e8c03b811a`; task branch `codex/precalculus-u1-u3-mcq-gap-fill`. No open PRs at bootstrap. Original dirty checkout preserved; this task uses the existing isolated local clone. Statistics checkpoint remains on its own remote branch.

Protocol `CONTENT_AUTHORING_AND_QA_PROTOCOL.md` §0 and §2.1; standard seed/variant pipeline and Units 1–3 runbook. Current Precalculus fact pack and exact CED target pages/continuations read; all 11 briefs and live skill grids available (8 skills each). The supplied CED governs:
- 1.3 CED title is “Rates of Change in Linear and Quadratic Functions”; current taxonomy title/brief differs. Target changing equal-interval average rates and concavity, without calculus.
- 3.4 brief emphasizes amplitude/vertical shift, which belong to later transformations. Target base sine/cosine graph coordinates, behavior, domain/range from CED 3.4 instead; no source or taxonomy changes.
- 1.1 excludes open-versus-closed interval discrimination.
- 2.8 one-to-one/reverse-pair reasoning, not logarithm-specific inverse work.
- 3.15 signed polar radius, distance behavior and secant interpolation, never derivatives or polar area.

No source corrections have been applied. Full questions, keys and raw votes will stay in private local artifacts; only metadata belongs in Git. Final census and accepted counts will be recorded after checking. Next owner: David for the pending slate/cost confirmation, then Codex executes the prepared run.
