# Plan: regenerate AP Chemistry Unit 2 explainers to the new length and role rules

Status: PLAN FOR APPROVAL, 2026-10-31. Nothing below has been run. No Development or Production write happens until the approvals in "Gates" are given.

## Goal
Bring the seven AP Chemistry Unit 2 explainer rows (2.1-2.7) inside the advisory length budgets and the field roles defined in `TOPIC_BRIEFS_AND_LEARN_MORE_PRODUCTION_PROTOCOL.md` (C9, C13, field roles), so the student page is a real cheat sheet plus Deep Dive. PR #40 already hides the brief twins; this plan fixes what is still shown.

## Scope
- **In:** `app.topic_explainers` rows for `ap_chemistry` topics 2.1-2.7 (7 rows). 17 visible fields are over their caps (READ, Production 2026-10-31):
  - `how_this_becomes_points` over 320 chars: all 7 topics (366-454).
  - `core_idea` over 360: 2.4 (448), 2.5 (363), 2.6 (400), 2.7 (445).
  - `what_students_need_to_understand` over 360: 2.4 (381), 2.5 (382).
  - `point_attaining_answer` over 520: 2.4 (669), 2.5 (524), 2.7 (557).
  - `practice_bridge` over 220: 2.7 (260).
- **Out:** the seven briefs (hidden on the page by PR #40 when an explainer exists; worst case 734 chars on 2.7 `what_it_is`); other units and subjects; reference entries, memory hooks (2.1 has none) and figures (2.1 has none); schema; frontend.
- **Decision to make, not assumed:** rewrite only the 17 over-cap fields, or rewrite each of the 7 explainers whole. Recommended: whole-row rewrite, because shortening `point_attaining_answer` or `core_idea` in isolation can leave the mini example, weak answer and practice bridge inconsistent with it, and the field roles (core_idea = mechanism, how_this_becomes_points = rubric path) need the row read as a unit. The 7 rows are small.

## Method (existing rules, no new process)
- Generation happens in session, authored by Claude, never by the gateway (feedback: author in session, arbitrate; DECISION-0099 "no hand edits" means no manual patching of generated text; flags are fixed by regenerating the field).
- Grounding: `AP_CHEMISTRY_CED_FACT_PACK.md` and the CED text for Unit 2; existing 2.1-2.7 rows are the starting point, not the source of truth for facts.
- Field roles, caps and C13 as in the protocol and `topic_guides_database_qa.sql` (PR #578).
- Checks: two checkers from different model families (DECISION-0093), picked from the live gateway roster at run time (roster fetched then, not assumed), one patch loop with a full re-check, union of flags verified by hand re-derivation. Count only factual or rubric errors as defects, not style. Fable sample only if you ask.
- Acceptance before any write: every visible field within caps; overlap with its brief twin < 0.80 and read by a human-style pass to confirm each pair does a different job (the lexical check cannot see paraphrase: AP Chem 2.1 scores 0.24 while saying the same thing); C8 distinctness; no AP-secure or copied exam language; answers re-derived independently.

## Steps
1. **Snapshot.** Export the current 7 explainer rows (Production, read-only) to a rollback file under `scripts/content-seed/ap-chemistry-explainer-u2-rewrite-2026-10-31/`.
2. **Ground.** Pull the Unit 2 CED text for each topic into a short per-topic fact list; note the objective each `point_attaining_answer` must satisfy.
3. **Author** 7 rows to the field-role contract and caps. Keep `topic_code`, `title`, `practice_*` and routing fields unchanged.
4. **Check.** Gateway spend estimate stated up front (7 rows x 2 checkers, small); balance and cost guard before the run; arbitrate every flag with a recorded ruling.
5. **Local gate.** Length caps, overlap vs brief, C8, and a side-by-side read of each brief/explainer pair. Fail any row, fix by regenerating that field.
6. **Development apply.** Migration file with provenance in `source_note` (batch id, date, checker families, ruling log), applied to Development; follow the `apply_migration` timestamp-drift rule (rename the local file to the recorded version). Run the full `topic_guides_database_qa.sql` and confirm counts unchanged (603/603), 0 C13a hits, 0 new C8 sharing.
7. **Render check.** Replay the Development RPC payload through the app's local harness (PR #40 code) at desktop and 375px; compare word counts before/after for 2.1-2.7.
8. **GATE: Production approval.** Hard-Gate content change. Present the before/after text, checker rulings and QA output; David approves; check open PRs before numbering the APPROVAL id (known collision trap).
9. **Production apply and verify.** Apply, re-run the QA script read-only against Production, spot-check `get_topic_point_guides` for 2.1-2.7. Rollback = re-apply the snapshot rows.
10. **Live check.** After the Lovable publish of PR #40, confirm in a signed-in browser that 2.1-2.7 show the Cheat Sheet / Deep Dive layout and the shorter text.
11. **Record.** ACTIVITY_LOG, APPROVALS_LOG, one PR for the batch files and logs.

## Gates (need you)
1. Approve this plan and the whole-row rewrite choice (or ask for 17-field-only).
2. Approve the checker pair and the gateway spend estimate when I present the live roster (step 4).
3. Separate Production approval at step 8, after you have seen Development results.

## Risks
- Shortening can drop rubric-relevant detail. Mitigation: each `point_attaining_answer` is checked against the CED objective; reviewers flag any lost required element.
- The overlap check is lexical only. Mitigation: the human-style paired read in step 5 and the checker prompt asks whether each explainer field adds something its brief twin does not.
- PR #40 must be published for students to see any of this; the data change alone does not change what the old layout shows beyond shorter fields.
- Hidden brief fields remain over cap in the database. Not student-visible while the explainer exists; dropping or rewriting them is a separate decision (recommendation #3 / schema).
