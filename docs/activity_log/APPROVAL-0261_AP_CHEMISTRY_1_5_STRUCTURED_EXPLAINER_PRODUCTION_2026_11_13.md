# APPROVAL-0261 — AP Chemistry 1.5 explainer reshaped into bullets, steps and a table (recommendation #3 test), applied to Production

- **Date:** 2026-11-13 (UTC; chat of 2026-11-12 US).
- **Authorization:** David, in chat: "pr60 is merged, approve production for 1.5", after reviewing the candidate and the Development result.
- **What is written (Production, project `pcntajvbdfqhbeewmdry`):** one row, `app.topic_explainers` ap_chemistry 1.5. Four fields (`core_idea`, `what_students_need_to_understand`, `how_this_becomes_points`, `point_attaining_answer`) and one appended sentence in `source_note`. `published_at`, the brief, reference entries, hooks, figures and schema are unchanged. Structure is text markers (`- `, `1. `, `| a | b |`) inside the existing columns; the renderer is app PR 60 (merged).
- **Guard:** the update matched only if the row still hashed to `9c9a479ad5284e0cbf0f9adced8c98fe` (the text it was built on); a post-check raised unless exactly one row carried the new source_note.
- **Evidence:** `scripts/content-seed/ap-chemistry-explainer-u1-1-5-structured-test-2026-11-12/README.md` and `proposed.json`. Two checker families (`openai/gpt-6.1-sol`, `moonshotai/kimi-k3.1-pro`): 0 findings each, planted-defect control caught by both; deepseek returned nothing and is not counted. Caps within budget; brief overlap 0.50/0.29/0.40 (< 0.80). Development applied first (version 20261113033115) and read back identical; `topic_guides_database_qa.sql` exit 0 on Development.
- **Rollback:** re-apply the `current` values in `proposed.json` for the four fields and strip the appended source_note sentence.
- **Numbering check:** highest APPROVAL on main was 0260; no open PRs at the time.
- **Result:** see the execution record below.

## Execution record (2026-11-13 UTC)
- Applied to Production via `apply_migration` (recorded version `20261113033506`; Development recorded `20261113033115`, the file keeps the Development version, per the ledger-is-history ruling DECISION-0128).
- Independent read after the write: Production field hash `e2063d54a300dd93a863a70ad88e9435` equals the Development row and `proposed.json`; 1 row carries the source_note; 603 published explainers, unchanged.
- Not verified: `get_topic_point_guides` for 1.5 (it requires an authenticated session; not called); no signed-in browser check. **Students see raw `-` and `|` characters until app PR 60 is published to Lovable**, which I have not confirmed.
