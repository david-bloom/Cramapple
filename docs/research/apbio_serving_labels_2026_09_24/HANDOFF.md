# Session Handoff — Work Orders N + N.1 — 2026-09-27

## 1. Current task or issue

Execute Codex Work Order N (43 unlabelled AP Biology short FRQ serving labels) and Work Order N.1 (re-derive 5 rejected AP Biology MCQ serving labels), proposal-only.

## 2. What changed this session

- Created branch `codex/work-order-n-biology-serving-labels` from current `main`.
- Captured the exact current 48-item Production input packet in `packet.jsonl`.
- Recorded `run_metadata.json`.
- Completed the widened Unit-3 audit in `u3_audit.csv`.
- Updated `SUMMARY.md` with the model-run blocker and next action.
- No PR opened. No merge to `main`. No Production write.

## 3. What was verified

- Production project: `pcntajvbdfqhbeewmdry` (Cramapple - Production).
- Work Order N scope query returns exactly **43** items.
- Work Order N.1 scope contains exactly **5** named MCQs.
- Packet contains exactly **48 unique current Production item/version packets**.
- Current unsuperseded AP Biology serving labels containing Unit 3: **15 inspected**.
- Known N.1 Unit-3/Unit-4 confusions remain: `APBIO-MCQ-030`, `-033`, `-046`.
- Two additional suspected Unit-3/Unit-4 confusions were found outside N.1 scope: `APBIO-MCQ-031`, `APBIO-MCQ-035`.

## 4. What remains open

- Run all 48 packets through the mandated independent model pair.
- Produce `serving_label_proposal.jsonl`.
- Run the N/N.1 aggregation and invariant checks.
- Update `run_metadata.json` and `SUMMARY.md` from BLOCKED to COMPLETE if all checks pass.
- Hand proposal to independent QA. Application/promotion remains outside this work order.

## 5. Open blockers or risks

The canonical work order requires exactly:
- `openai/gpt-5.5`
- `google/gemini-2.5-flash`

through Vercel AI Gateway.

This session did not have an authenticated Vercel AI Gateway path or accessible gateway credential. No substitute model pair was used.

Risk carried forward: Unit-3/Unit-4 confusion appears broader than the original N.1 five-item scope. `APBIO-MCQ-031` and `APBIO-MCQ-035` are audit findings only and must not be silently folded into the N.1 proposal.

## 6. Files changed or checked

Changed on `codex/work-order-n-biology-serving-labels`:
- `docs/research/apbio_serving_labels_2026_09_24/packet.jsonl`
- `docs/research/apbio_serving_labels_2026_09_24/u3_audit.csv`
- `docs/research/apbio_serving_labels_2026_09_24/run_metadata.json`
- `docs/research/apbio_serving_labels_2026_09_24/SUMMARY.md`
- this handoff file

Checked:
- `prompts/CODEX_WORK_ORDER_QUEUE_2026_09_24.md`
- `prompts/CODEX_WORK_ORDER_N_BIOLOGY_SERVING_LABELS_2026_09_24.md`
- `docs/research/apbio_mcq_serving_label_qa_2026_09_24/qa_report.md`
- `scripts/taxonomy/extend_math_serving_labels.mjs`
- `scripts/taxonomy/extend_serving_labels_mcp.mjs`
- current Production state in Supabase.

## 7. Commands, queries, or tests run

Read-only Production SQL:
- N scope query: **43**.
- N.1 named-item scope: **5**.
- Packet extraction: **48 rows / 48 unique content keys**.
- Widened current Unit-3 serving-label audit: **15 labels inspected**.

GitHub:
- branch created successfully.
- checkpoint commits pushed successfully.
- latest branch commit before this handoff: `28ebd286154b475e9426abc1d2f41703d956bd80`.

No application SQL, migration, deployment, or Production mutation was run.

## 8. Approval state

The work order is already authorized as proposal-only. No Product Owner approval is required to complete the two-model proposal run. Independent QA is required before any application. No Production write or validation promotion is authorized by this work order.

## 9. Exact next step

**Next owner:** Codex / an agent with the configured Vercel AI Gateway credential.

**Next required action:** continue branch `codex/work-order-n-biology-serving-labels`, run the existing proposal-only N/N.1 lane against the committed `packet.jsonl` using exactly GPT-5.5 + Gemini 2.5 Flash, then emit `serving_label_proposal.jsonl` and run all work-order assertions. Do not open a PR or write to Production.

Recommended restart prompt:

> Resume Work Orders N and N.1 from `codex/work-order-n-biology-serving-labels`. Read `docs/research/apbio_serving_labels_2026_09_24/HANDOFF.md` and `SUMMARY.md` first. The Production packet and Unit-3 audit are already committed. Use exactly GPT-5.5 + Gemini 2.5 Flash through Vercel AI Gateway, generate `serving_label_proposal.jsonl`, run every N/N.1 invariant, keep Production writes at zero, and stop for independent QA.

## 10. Do not touch next session

- Do not expand N.1 proposal scope beyond its five named MCQs.
- Do not edit QA-owned `qa_report.md` or `qa_findings.csv`.
- Do not generate or apply Production write SQL.
- Do not promote labels to `validated`.
- Do not open a PR or merge to `main`.
- Do not substitute a different model pair.
