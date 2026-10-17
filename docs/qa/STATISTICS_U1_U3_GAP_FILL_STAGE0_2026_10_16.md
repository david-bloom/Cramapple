# AP Statistics Units 1–3 MCQ gap fill — Stage 0, 2026-10-16

**Status: Historical planning baseline; execution state superseded by the Stage A result**
**Owner / Main Conductor:** Codex; Product Owner David Bloom  
**Branch:** `codex/statistics-u1-u3-gap-fill`  
**Tier:** Hard-Gate overall; Stage A authoring/checking bounded by the supplied work order  
**State:** Stage 0 completed; David confirmed the proposed checker slate in chat on 2026-10-16. Stage A completed with 31/31 accepted seeds; see [Stage A result](STATISTICS_U1_U3_GAP_FILL_STAGE_A_2026_10_16.md). No database writes. The baseline and proposal below record the pre-run state.

## Scope and governing sources

The owner requested a Cramapple session focused on the Statistics gap-fill work order dated 2026-10-16. The work order authorizes Stage A only: two new seeds for each of 15 empty topics and one for topic 2.2 (31 seeds). Stage B and Production publication require subsequent owner instructions. Do not alter More help, other subjects, Units 4+, or the nine thin topics.

Governing method: `docs/research/CONTENT_AUTHORING_AND_QA_PROTOCOL.md` §0, §0.4–0.5, §0.8–0.9, §2.1 and §3.2; `DECISION-0101`; topic-vote rules in `docs/handoffs/UNITS_1_3_PIPELINE_RUNBOOK_AND_SESSION_CLOSE_2026_10_04.md`. The supplied CED PDF governs source conflicts. The task instruction to author in-session and use the gateway only for checking overrides the default runner's paid-author calls. No method relaxation is authorized.

Canonical `main` was verified at `e83b1025bfcbce9dcaa746cb5a476dac358bb140`. A separate checkout was used to preserve unrelated local edits. Current GitHub PRs and remote branches were inspected; no existing Statistics gap-fill task branch or PR was present. Highest approval claimed on a live remote branch: **APPROVAL-0183**; main's log reaches 0180, and the open PR branch also claims 0181–0182. Recheck all live refs before reserving a publication approval.

## Read-only Production baseline

Project: `pcntajvbdfqhbeewmdry`. Count distinct published items using their latest published version and unsuperseded primary topic cell; exclude active Open Hand teaching designations. This matches the supplied census: **372 practice MCQs across 40 topics**.

| Unit | Empty practice-MCQ topics | Existing 2.2 MCQs | Planned seeds |
| --- | --- | ---: | ---: |
| 1 | 1.1, 1.3, 1.4 | — | 6 |
| 2 | 2.1, 2.3, 2.8, 2.11, 2.12 | 1 | 11 |
| 3 | 3.7, 3.9, 3.10, 3.11, 3.12, 3.13, 3.14 | — | 14 |
| Total | 15 empty topics | 1 | 31 |

Every topic has at least one FRQ. This query did not independently certify worked-example coverage. Thin topics left unchanged: 1.10 (4), 2.4 (4), 2.5 (4), 3.1 (4), 3.3 (3), 3.4 (4), 3.5 (4), 3.6 (4), 3.15 (4). No new items have been published, so this remains the current gap table.

The saved Stage 0 packet contains the exact gap SQL and JSON/CSV output, `plan.json` (16 topics / 31 slots), `skills.json`, source SHA-256 manifest, live roster/prices and input-coverage inventory. Full questions, keys and votes must remain private.

## Inputs and scope observations

All 16 topic briefs are present in the canonical `briefs_all.json`; all 16 are represented in the Statistics fact pack and CED. Each planned skill is allowed by the live Production topic/skill grid; Unit 2/3 reference-pack fact excerpts were checked. Unit 3 briefs come from the canonical JSON.

- **3.14 source discrepancy:** its brief asks for expected-count and degrees-of-freedom calculations. CED 3.14 covers chi-square distributions, procedure setup, hypotheses and conditions; expected-count calculation belongs to 3.15.A. The plan targets hypotheses and condition checks with expected counts supplied, avoiding that overlap. No source correction or silent overlap allowance was made. A source correction, if pursued, needs the owner's approval and regenerated candidates.
- **2.12:** the canonical JSON has the corrected conceptual framing from APPROVAL-0129. Keep both slots within 2.12.A.1–4; no Unit 4 standard-error formulas or numeric sample-size normality rules.
- **2.1 versus 2.2:** use representation comparisons for 2.1; calculation of relative frequencies is the 2.2 slot.
- **1.1:** the brief describes foundational practice rather than a standalone exam skill. The owner explicitly includes this topic; use investigative reasoning rather than procedure naming.
- **2.8:** the grid allows only 3.A. Plan representation-selection items, with no invented out-of-grid skill.

## Proposed checker slate and budget

Live gateway roster refreshed on 2026-10-16, without paid inference calls. Prices below are USD per million input / output tokens.

| Role for an OpenAI-authored seed | Model | Input / output |
| --- | --- | ---: |
| Non-author checker | `anthropic/claude-opus-5.5` | 4.00 / 20.00 |
| Non-author checker | `google/gemini-3.8-flash` | 0.75 / 3.75 |
| Non-author checker | `deepseek/deepseek-v4-pro` | 0.66 / 1.98 |
| Non-author checker | `meta/muse-spark-1.3` | 1.25 / 4.25 |
| Reject-only author-family veto | `openai/gpt-6.1-sol` | 2.00 / 10.00 |

Authorship stays in-session; no paid gateway author. Standard slate proposed, with no Qwen substitution in Stage A. Budget estimate **$7–10**, based on the cited seed pilot and current roster; this is an estimate, not measured cost. Ceiling **$12 including controls, smoke calls, every attempt/retry, vetoes and labeling**. At this pre-run baseline, spend was **$0** and no inference attempts had been recorded; actual run cost is in the Stage A result. Reserve enough for each dispatch before sending it; stop before exceeding the ceiling.

The protocol §2.1 slate confirmation was received in chat on 2026-10-16 (David: “confirmed”). The work order already answers the variant question: zero Stage A variants, and no Stage B start without a new go-ahead. Any genuinely necessary second-family author fallback must still honor the work order's prohibition on paid gateway authorship; do not silently pay for it.

## Execution requirements identified before spending

The checked-in seed runner is not a safe one-command execution of this work order:
- It defaults to three variants, so Stage A must explicitly use zero.
- It does not itself call the planted-defect control gate.
- It pays authors through the gateway; add an in-session candidate intake path instead.
- Its label vote covers skill/difficulty, not the required independent 5-of-6 topic vote (the runbook uses Gemini, DeepSeek and GPT, two samples each).
- Its call logger wraps internal retries, so it does not by itself account for every attempted gateway call. Full attempt-level usage/cost accounting and a pre-dispatch budget reservation are needed.
- Skills with fewer than three votes must remain at practice level under this work order; do not carry the runner's unique-two-vote subskill label into publication.

These are execution requirements, not changes to acceptance standards. Controls must catch all six defects before checking candidates. No generated candidate is edited. Rejected candidates are preserved and new candidates receive new IDs. Four non-author families must clear each candidate and the own-family model can only veto. After two rounds, unresolved candidates escalate; source or overlap rulings remain with the owner.

## Historical pre-run actions and gates (steps 1–3 completed; see Stage A)

1. Receive the required checker-slate confirmation; prepare the narrow execution adapter above without weakening stages.
2. Run/log controls and structured-output smoke checks, then Stage A, with deterministic key placement, deterministic numerical recomputation, independent topic labels and four-family skill/difficulty votes.
3. Stop at the Stage A report: accepted/escalated counts, all costs, controls evidence, scope decisions and labels. Offer a blind sample re-judge.
4. Publication later uses `publish_mcq_batch.py`: plan → preflight → Production rollback rehearsal → owner approval recorded in a new APPROVAL entry → publish → committed-row md5 checks → real service-role selector → fresh gap query. No approval has been allocated.
5. Stage B requires a separate go-ahead, calibration and head-to-head validation within its separate $22 ceiling.

**Next owner:** David Bloom reviews the completed Stage A gate report. Production publication and Stage B remain unapproved. Live counts and outcomes belong in the Stage A result, not in this baseline record.
