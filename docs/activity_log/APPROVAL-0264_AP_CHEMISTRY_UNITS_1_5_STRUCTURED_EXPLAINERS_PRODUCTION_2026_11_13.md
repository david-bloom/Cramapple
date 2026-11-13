# APPROVAL-0264 — AP Chemistry units 1-5 explainers (except 1.5) reshaped into bullets, steps and tables (recommendation #3), applied to Production

- **Date:** 2026-11-13 (UTC; chat of 2026-11-12 US).
- **Authorization:** David, in chat: "approve production for chemistry", after answering "Review first" once. Scope is AP Chemistry units 1-5 except 1.5 (1.5 went live earlier under APPROVAL-0261).
- **What is written (Production, project `pcntajvbdfqhbeewmdry`):** 47 rows of `app.topic_explainers` (ap_chemistry units 1-5: 7, 7, 13, 9 and 11 topics): `core_idea`, `what_students_need_to_understand`, `how_this_becomes_points`, `point_attaining_answer`, plus one appended `source_note` sentence. No schema, brief, reference, hook, figure or app change; `published_at` unchanged. Structure is text markers rendered by app PR 60.
- **Guard:** each update matched only if its row still hashed to the text it was built on (this includes Unit 2 in its 2026-10-31 rewritten form, APPROVAL-0204); the migration raises unless exactly 47 rows carry the new source_note. Production's aggregate hash over the 47 rows equalled the baseline (`d40f58df3cd709bd6e1a43c5995858e9`) immediately before the apply.
- **Evidence:** `scripts/content-seed/structured-explainers-2026-11-13/ap_chemistry/` (README, RULINGS, proposed_all.json, migration.sql, checker output). Two checker families (`openai/gpt-6.1-sol`, `moonshotai/kimi-k3.1-pro`), planted-defect control (3.4) caught by both; five lost-content defects (1.2, 3.1, 3.3, 3.5, 3.8) fixed by rewriting and re-checked clean; 1.7 exclusion qualifiers restored, wording now "aufbau-exception configurations (chromium, copper)". Words 8,374 -> 7,331 (unit 3 about 25% shorter). Development applied first and read back 47/47.
- **Known weak spots:** 3.1, 3.2, 3.3, 3.6, 3.8, 3.9 were compressed hardest; 1.7 wording differs from the CED phrasing; a kimi suggestion to add a "least to most ionic" line to 2.1 was rejected by the author.
- **Rollback:** re-apply the CURRENT values in `ap_chemistry/current.json` (four fields per topic) and strip the appended source_note sentence.
- **Numbering check:** highest APPROVAL on main was 0261; open PR #646 holds 0262 and 0263.

## Execution record (2026-11-13 UTC)
- Applied with `supabase db query --linked --workdir /Users/davidbloom -f migration.sql` (Production-linked checkout; ref confirmed with `--debug`; aggregate hash read first). No ledger row, per DECISION-0128.
- Independent read after the write: Production 47 of 47 rows' four-field hash equals `proposed_all.json`; 47 Chemistry rows carry a structured source_note (1.5 from 0261 plus these); Statistics 55 and Biology 33 as expected; 603 published explainers unchanged.
- Not verified: no signed-in app check; **students see raw `-` and `|` until app PR 60 is published to Lovable (not confirmed)**; no human review of the text beyond what David read.
