# APPROVAL-0262 — AP Statistics units 1-5 explainers reshaped into bullets, steps and tables (recommendation #3), applied to Production

- **Date:** 2026-11-13 (UTC; chat of 2026-11-12 US).
- **Authorization:** David, in chat: "i approve", answering my question "Approve Production for Statistics units 1-5?" after the Development result and reports. Scope is AP Statistics only; Biology and Chemistry are NOT covered by this approval.
- **What is written (Production, project `pcntajvbdfqhbeewmdry`):** 55 rows of `app.topic_explainers` (ap_statistics units 1-5, topics 1.1-5.5): `core_idea`, `what_students_need_to_understand`, `how_this_becomes_points`, `point_attaining_answer`, plus one appended `source_note` sentence. No schema, brief, reference, hook, figure or app change; `published_at` unchanged. Structure is text markers (`- `, `1. `, `| a | b |`) rendered by app PR 60.
- **Guard:** each update matched only if its row still hashed to the text it was built on; the migration raises unless exactly 55 rows carry the new source_note. Production's aggregate hash over the 55 rows equalled the baseline immediately before the apply.
- **Evidence:** `scripts/content-seed/structured-explainers-2026-11-13/ap_statistics/` (README, RULINGS, proposed_all.json, migration.sql, checker output). Two checker families (`openai/gpt-6.1-sol`, `moonshotai/kimi-k3.1-pro`), planted-defect control caught by both; real defects found and fixed by rewriting (including a lost "or description" in 2.12). Words 10,756 -> 9,569. Development applied first and read back 55/55.
- **Rollback:** re-apply the CURRENT values in `ap_statistics/current.json` (four fields per topic) and strip the appended source_note sentence.
- **Numbering check:** highest APPROVAL on main was 0261; no open PRs.
- **Result:** see below.

## Execution record (2026-11-13 UTC)
- Applied with `supabase db query --linked --workdir /Users/davidbloom -f migration.sql` (the Production-linked checkout; project ref confirmed as `pcntajvbdfqhbeewmdry` and the pre-apply aggregate hash and zero touched rows read first). `db query` records no migration ledger row, consistent with DECISION-0128.
- Independent read after the write: Production 55 of 55 rows' four-field hash equals `proposed_all.json`; 55 rows carry the source_note; 603 published explainers unchanged; 0 rows in other subjects carry it.
- Not verified: no signed-in app check; **students see raw `-` and `|` on these topics until app PR 60 is published to Lovable (not confirmed)**; no human review of the reshaped text; Biology and Chemistry remain Development-only.
