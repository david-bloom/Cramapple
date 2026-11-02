# Servable Items Check repair — 2026-11-01

Task: workflow run 41323382104; Tier: Hard-Gate (monitoring function migration).
Branch: `codex/servable-check-fixes-2026-11-01`.
Owner: David Bloom. Approval: owner explicitly requested implementing and verifying
these two diagnosed fixes in chat on 2026-11-01.
Operational state: implemented locally, verified in rollback rehearsals; not published
or applied persistently. Remote publication was rejected by automatic approval review.

## Changes

- Workflow guard uses `psql -X -q`: ignore startup files and suppress command tags,
  preserving result tuples and `ON_ERROR_STOP=1`.
- New migration repairs only the unit-gated predicates in the census and self-test.
  Reads each current function definition, requires one exact anchor, and executes
  CREATE OR REPLACE. Already-repaired predicates are skipped. Other counters,
  serving functions, return types, attributes and ACLs are retained.
- Baseline unchanged: run failed on mirror drift, not baseline decreases.

## Evidence

Original run: main `509ddb63`; check 17 ok / 76 capped / 3 mismatches.
Teaching items account exactly for differences: Physics 1 unit 1 one item,
Physics 2 unit 9 two items, Physics C Mechanics unit 1 one item.

Development transaction rehearsal: 106 ok; rolled back.
Production transaction rehearsal, applying migration twice: 20 ok / 76 capped /
zero mismatches; rolled back. This verifies idempotence against live definitions.
Fresh independent QA: source changes pass; exact unique anchors and reversible
transformation checked. No blocking source finding.

Guard SQL positive control: transaction-created public.content_ci_guard_probe with
synthetic answer_key JSON and column SELECT grant was detected in Development.
Transaction rolled back; to_regclass subsequently returned null.
Real psql 16 help confirms -q emits only query output, and -X ignores startup files.
Local end-to-end psql/database execution was unavailable: host has no PostgreSQL
server and cannot switch to a non-root server user. No claim of a green workflow run.

## Additional diagnostic, outside repair scope

The original CI guard log contained only DROP TABLE / CREATE TABLE / DO, no violation
rows. A subsequent scan through the privileged Supabase connection returned six
content findings: app.content_ingest_rows.row_payload (criteria 46, canonical_answer
40, is_correct 18, rationale 18), and app/public.content_review_decisions.decision_payload
(answer_key 1 each). Ingest/review tables have ownership-based SELECT policies.
Privileged scan findings do not prove student access and may differ from CI's
restricted database role. Do not revoke privileges or widen exclusions without a
separate role/RLS-aware assessment.

## Next steps and rollback

Publish branch and PR after publication authorization is cleared; apply only this
migration explicitly (never a bulk db push), then run the workflow at the new main
commit. A rerun of the old run would still use the old workflow.
No persistent database change has yet occurred. To roll back after release, restore
the two pre-migration function definitions, or reverse exactly the inserted teaching
predicate in those monitoring functions. Revert workflow commit to undo -X -q.
