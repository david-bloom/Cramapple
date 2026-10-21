# TASK-0063 — Session RPC body reconciliation (UNAPPLIED)

Status: Ready for independent review; local fixture passes. Production application remains a Hard Gate.

Fresh read-only verification on 2026-10-21 matches Fable PR #519: Production's Home-start body is `de584bfdfbadd390d9b2fd4e370150e1` and subject-switch body is `1363d6eaf5a1196b448f67cc4dfbbccd`. Development runs `dbc35186dc642ac15e19295f3601186b` and `5a71a24d2fc753b91f0150aa0ac2161e`. The migration ledger discrepancy's cause is UNKNOWN; this PR records the observed divergence without inventing an explanation.

The new migration replaces only `app.start_home_learning_session_for_user` and `public.set_active_exam_pack_version` with the exact reviewed Development definitions. It preserves identity checks, selectability checks, advisory/row locks and same-subject reuse. It does not rerun old migrations, change ledger rows, alter grants, or replace any other security helper. Body/security/search-path preconditions abort if either reviewed environment has changed.

The disposable fixture installs the actual old Production definitions and reproduces `active_session_blocks_subject_switch`. After the migration it verifies cross-subject switching/start, same-subject reuse, same-key replay, wrong-actor refusal and unselectable-subject refusal. Minimal fixtures do not certify all live dependencies/RLS/client behavior.

Before application: independently review current definitions/dependencies and the later leak fix; rehearse against Development; perform signed-in student journeys; compare the intended artifact and Development result; approve the exact Production change separately. After application, compare actual bodies, attributes and grants, then repeat the journeys. Leave the ledger untouched except the normal new migration record.

Rollback/containment must preserve later security fixes. Do not blindly restore historical migrations. Development entitlement-flag alignment is an independent configuration operation and has not been performed.
