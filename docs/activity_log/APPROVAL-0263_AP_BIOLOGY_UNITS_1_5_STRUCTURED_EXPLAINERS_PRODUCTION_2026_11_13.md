# APPROVAL-0263 — AP Biology units 1-5 explainers reshaped into bullets, steps and tables (recommendation #3), applied to Production

- **Date:** 2026-11-13 (UTC; chat of 2026-11-12 US).
- **Authorization:** David, in chat: "approve production for biology", after reviewing the Development result (first answered "Review first"). Scope is AP Biology only; Chemistry is NOT covered.
- **What is written (Production, project `pcntajvbdfqhbeewmdry`):** 33 rows of `app.topic_explainers` (ap_biology units 1-5): `core_idea`, `what_students_need_to_understand`, `how_this_becomes_points`, `point_attaining_answer`, plus one appended `source_note` sentence. No schema, brief, reference, hook, figure or app change; `published_at` unchanged. Structure is text markers rendered by app PR 60.
- **Guard:** each update matched only if its row still hashed to the text it was built on; the migration raises unless exactly 33 rows carry the new source_note. Production's aggregate hash over the 33 rows equalled the baseline (`004a1c3095bc69eaa442eb50bea85137`) immediately before the apply, with 0 rows touched.
- **Evidence:** `scripts/content-seed/structured-explainers-2026-11-13/ap_biology/` (README, RULINGS, proposed_all.json, migration.sql, checker output). Two checker families (`openai/gpt-6.1-sol`, `moonshotai/kimi-k3.1-pro`), planted-defect control (2.8) caught by both; two real defects (2.5 lost "large molecules or particles"; 5.5 core idea read as genotype-only) fixed by rewriting and re-checked clean. Words 6,643 -> 5,802. Development applied first and read back 33/33.
- **Known weak spots:** unit 5 (5.1-5.5) came from templated one-sentence fields, so the bullets are the original sentences split in two with little real structure; tables in 1.7, 2.3, 2.4, 2.10, 3.2 and 4.x condense sentences into cells.
- **Rollback:** re-apply the CURRENT values in `ap_biology/current.json` (four fields per topic) and strip the appended source_note sentence.
- **Numbering check:** highest APPROVAL on main was 0261; open PR #646 holds 0262.

## Execution record (2026-11-13 UTC)
- Applied with `supabase db query --linked --workdir /Users/davidbloom -f migration.sql` (Production-linked checkout; ref `pcntajvbdfqhbeewmdry` confirmed with `--debug`; pre-apply aggregate hash and zero touched rows read first). No ledger row, per DECISION-0128.
- Independent read after the write: Production 33 of 33 rows' four-field hash equals `proposed_all.json`; 33 Biology rows carry the source_note; Statistics 55 (APPROVAL-0262) and Chemistry 0 as expected; 603 published explainers unchanged.
- Not verified: no signed-in app check; **students see raw `-` and `|` until app PR 60 is published to Lovable (not confirmed)**; no human review; Chemistry remains Development-only.
