# DECISION-0066 Promotion Freshness Audit — 2026-09-27

## Result

All 216 labels promoted by `20260926233500_promote_fresh_single_unit_two_model_labels.sql`
were reconstructed from their original durable label migrations and compared with the current
published content version and `app.taxonomy_relevant_hash(current_version_id)` in Production.

| Subject | Verified fresh | Reverted | Unverifiable |
| --- | ---: | ---: | ---: |
| ap_calculus_ab | 24 | 0 | 0 |
| ap_chemistry | 25 | 0 | 0 |
| ap_physics_1 | 70 | 0 | 0 |
| ap_physics_2 | 49 | 0 | 0 |
| ap_precalculus | 25 | 0 | 0 |
| ap_statistics | 23 | 0 | 0 |
| **Total** | **216** | **0** | **0** |

The applied promotion migration had overwritten each stored validation hash, so that value was not
accepted as proof. Generation-time hashes came from the original run migrations: AP Calculus AB
batches 01–03, AP Chemistry batches 01–02, AP Physics 1/2 Tier 3 migrations, AP Precalculus
batches 01–10, and the AP Statistics backfill. The Statistics backfill captured the original run
hashes before promotion and bound them to the then-current version; the promotion version-equality
precondition proves the same version was promoted.

The row-level evidence is in
`DECISION_0066_PROMOTION_FRESHNESS_AUDIT_2026_09_27.csv`. The corrective migration
`20260927112814_reaudit_decision0066_single_unit_promotions.sql` independently guards all 216
rows and reverts any mismatched or unverifiable target to `provisional_model` while leaving the
historical validation-decision row intact. The observed correction count is zero.
