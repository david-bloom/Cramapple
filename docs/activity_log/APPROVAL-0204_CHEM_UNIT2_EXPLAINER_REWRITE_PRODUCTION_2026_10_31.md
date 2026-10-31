# APPROVAL-0204 — Rewrite the AP Chemistry Unit 2 explainers (2.1-2.7) in Production (executed 2026-10-31)

- **Date:** 2026-10-31
- **Decision:** Approved and executed.
- **Granted by:** David Bloom (Product Owner), in session: "Approve", in reply to the packet `docs/product/CHEM_UNIT2_EXPLAINER_PROD_APPROVAL_PACKET_2026_10_31.md`.
- **Related:** plan `docs/product/CHEM_UNIT2_EXPLAINER_REGENERATION_PLAN_2026_10_31.md`; batch `scripts/content-seed/ap-chemistry-explainer-u2-rewrite-2026-10-31/` (rollback snapshot `current_dev.json`, `proposed.json`, `CODEX_RULINGS.md`); migration `supabase/migrations/20261031120000_chem_unit2_explainer_rewrite.sql`.

## Scope

Seven `app.topic_explainers` rows (ap_chemistry 2.1-2.7): core_idea, what_students_need_to_understand, how_this_becomes_points for all seven; point_attaining_answer for 2.4, 2.5, 2.7; practice_bridge for 2.7. `published_at` unchanged; one provenance sentence appended to `source_note`. No schema, brief, figure, hook or frontend change.

## Evidence

- Before the apply, Production content hashes equalled the rollback snapshot for all seven rows.
- After the apply (migration loaded from file with the CLI pinned to the Production project), Production content hashes equal `proposed.json` for all seven; all seven carry the provenance tag.
- `topic_guides_database_qa.sql` exited 0 against Development before and Production after the apply.
- Caps respected; brief-twin overlap max 0.70.

## Gaps accepted

- One outside checker family (Codex) rather than two (DECISION-0093); Claude authored and arbitrated.
- Unverified and left so: 2025 exam statistics, absolute electronegativity values, bond lengths and energies.
- Students see the shorter text only after the Lovable publish of app PR #40; the data change alone shortens the fields in the old layout.

## Rollback

Re-apply the field values in `current_dev.json` for the seven rows and strip the appended `source_note` sentence.
