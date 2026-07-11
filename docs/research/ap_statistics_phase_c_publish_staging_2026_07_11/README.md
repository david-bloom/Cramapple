# AP Statistics Phase C Publish Staging - 2026-07-11

This directory stages TASK-0016 Phase C AP Statistics content for Product Owner approval.

## Files

- `bulk_import_payload.json` - ready-to-run `admin-content` request body for `operation: "bulk_import"`.
- `verification_log.md` - bounded independent verification log for the packet.
- `approval_packet.md` - one-sitting approval surface for David.

## Target

- Environment: Production
- Supabase project: `pcntajvbdfqhbeewmdry`
- Exam pack version: `548f06be-ccf4-426d-b82b-b424137a4438`
- Operation staged: `bulk_import` only
- Status produced by current `admin-content` path: `draft`

Do not call `publish` from this packet. Approval of `approval_packet.md` authorizes a later, separate publish action.

## Invocation Shape

```bash
curl -sS -X POST "$SUPABASE_URL/functions/v1/admin-content" \
  -H "Authorization: Bearer $SUPABASE_ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  --data @docs/research/ap_statistics_phase_c_publish_staging_2026_07_11/bulk_import_payload.json
```

The request body already includes `operation: "bulk_import"` and an idempotency key.

## Rights Record Note

The payload intentionally does not include `rights_record`. Current `admin-content` inserts `rights_records` only when a valid `source_version_id` is supplied, while this draft import creates `source_records` inline and does not pass the generated `source_version_id` into the rights insert. The approval packet carries the Product Owner rights/source approval surface instead; do not publish until the rights/source gate is explicitly accepted.

## Collision Check

Live Supabase SELECT access was denied in this Codex session, so this packet uses checked-in Production evidence from the 2026-07-01 smoke-batch README plus the known 40 HDR key pattern. Known source-key collisions:

- `APSTATS-MCQ-001` -> staged as `APSTATS-MCQ-001-CAL`
- `APSTATS-MCQ-002` -> staged as `APSTATS-MCQ-002-CAL`
- `APSTATS-MCQ-003` -> staged as `APSTATS-MCQ-003-CAL`
- `APSTATS-MCQ-004` -> staged as `APSTATS-MCQ-004-CAL`
- `APSTATS-MCQ-005` -> staged as `APSTATS-MCQ-005-CAL`
- `APSTATS-MCQ-006` -> staged as `APSTATS-MCQ-006-CAL`
- `APSTATS-MCQ-007` -> staged as `APSTATS-MCQ-007-CAL`
- `APSTATS-MCQ-008` -> staged as `APSTATS-MCQ-008-CAL`
- `APSTATS-MCQ-009` -> staged as `APSTATS-MCQ-009-CAL`
- `APSTATS-MCQ-010` -> staged as `APSTATS-MCQ-010-CAL`
- `APSTATS-MCQ-011` -> staged as `APSTATS-MCQ-011-CAL`
- `APSTATS-MCQ-012` -> staged as `APSTATS-MCQ-012-CAL`
- `APSTATS-MCQ-013` -> staged as `APSTATS-MCQ-013-CAL`
- `APSTATS-MCQ-014` -> staged as `APSTATS-MCQ-014-CAL`
- `APSTATS-MCQ-015` -> staged as `APSTATS-MCQ-015-CAL`
- `APSTATS-MCQ-016` -> staged as `APSTATS-MCQ-016-CAL`
- `APSTATS-MCQ-017` -> staged as `APSTATS-MCQ-017-CAL`
- `APSTATS-MCQ-018` -> staged as `APSTATS-MCQ-018-CAL`

Before executing the import, run this read-only query in Production:

```sql
with staged(content_key) as (
  values
    ('APSTATS-MCQ-001-CAL'),
    ('APSTATS-MCQ-002-CAL'),
    ('APSTATS-MCQ-003-CAL'),
    ('APSTATS-MCQ-004-CAL'),
    ('APSTATS-MCQ-005-CAL'),
    ('APSTATS-MCQ-006-CAL'),
    ('APSTATS-MCQ-007-CAL'),
    ('APSTATS-MCQ-008-CAL'),
    ('APSTATS-MCQ-009-CAL'),
    ('APSTATS-MCQ-010-CAL'),
    ('APSTATS-MCQ-011-CAL'),
    ('APSTATS-MCQ-012-CAL'),
    ('APSTATS-MCQ-013-CAL'),
    ('APSTATS-MCQ-014-CAL'),
    ('APSTATS-MCQ-015-CAL'),
    ('APSTATS-MCQ-016-CAL'),
    ('APSTATS-MCQ-017-CAL'),
    ('APSTATS-MCQ-018-CAL'),
    ('APSTATS-MCQ-019'),
    ('APSTATS-MCQ-020'),
    ('APSTATS-MCQ-021'),
    ('APSTATS-MCQ-022'),
    ('APSTATS-MCQ-023'),
    ('APSTATS-MCQ-024'),
    ('APSTATS-MCQ-025'),
    ('APSTATS-MCQ-026'),
    ('APSTATS-MCQ-027'),
    ('APSTATS-MCQ-028'),
    ('APSTATS-MCQ-029'),
    ('APSTATS-MCQ-030'),
    ('APSTATS-MCQ-031'),
    ('APSTATS-MCQ-032'),
    ('APSTATS-MCQ-033'),
    ('APSTATS-MCQ-034'),
    ('APSTATS-MCQ-035'),
    ('APSTATS-MCQ-036'),
    ('APSTATS-MCQ-037'),
    ('APSTATS-MCQ-038'),
    ('APSTATS-MCQ-039'),
    ('APSTATS-MCQ-040'),
    ('APSTATS-MCQ-041'),
    ('APSTATS-MCQ-042'),
    ('APSTATS-MCQ-043'),
    ('APSTATS-MCQ-044'),
    ('APSTATS-MCQ-045'),
    ('APSTATS-MCQ-046'),
    ('APSTATS-MCQ-047'),
    ('APSTATS-MCQ-048'),
    ('APSTATS-MCQ-049'),
    ('APSTATS-MCQ-050'),
    ('APSTATS-MCQ-051'),
    ('APSTATS-MCQ-052'),
    ('APSTATS-MCQ-053'),
    ('APSTATS-MCQ-054'),
    ('APSTATS-MCQ-055'),
    ('APSTATS-MCQ-056'),
    ('APSTATS-MCQ-057'),
    ('APSTATS-MCQ-058'),
    ('APSTATS-MCQ-059'),
    ('APSTATS-MCQ-060'),
    ('APSTATS-MCQ-061'),
    ('APSTATS-MCQ-062'),
    ('APSTATS-MCQ-063'),
    ('APSTATS-MCQ-064'),
    ('APSTATS-MCQ-065'),
    ('APSTATS-MCQ-066'),
    ('APSTATS-MCQ-067'),
    ('APSTATS-MCQ-068'),
    ('APSTATS-MCQ-069'),
    ('APSTATS-MCQ-070'),
    ('APSTATS-MCQ-071'),
    ('APSTATS-MCQ-072'),
    ('APSTATS-MCQ-073'),
    ('APSTATS-MCQ-074'),
    ('APSTATS-MCQ-075'),
    ('APSTATS-MCQ-076'),
    ('APSTATS-MCQ-077'),
    ('APSTATS-MCQ-078'),
    ('APSTATS-MCQ-079'),
    ('APSTATS-MCQ-080'),
    ('APSTATS-MCQ-081'),
    ('APSTATS-MCQ-082'),
    ('APSTATS-MCQ-083'),
    ('APSTATS-MCQ-084'),
    ('APSTATS-MCQ-085'),
    ('APSTATS-MCQ-086'),
    ('APSTATS-MCQ-087'),
    ('APSTATS-MCQ-088'),
    ('APSTATS-MCQ-089'),
    ('APSTATS-MCQ-090'),
    ('APSTATS-MCQ-091'),
    ('APSTATS-MCQ-092'),
    ('APSTATS-MCQ-093'),
    ('APSTATS-MCQ-094'),
    ('APSTATS-MCQ-095'),
    ('APSTATS-MCQ-096'),
    ('APSTATS-MCQ-097'),
    ('APSTATS-MCQ-098'),
    ('APSTATS-MCQ-099'),
    ('APSTATS-MCQ-100'),
    ('APSTAT-MOD3-E001'),
    ('APSTAT-MOD3-E002'),
    ('APSTAT-MOD3-E003'),
    ('APSTAT-MOD3-E004'),
    ('APSTAT-MOD3-E005'),
    ('APSTAT-MOD3-H001-INV'),
    ('APSTAT-MOD4-M001'),
    ('APSTAT-MOD4-M002'),
    ('APSTAT-MOD4-M003'),
    ('APSTAT-MOD4-M004'),
    ('APSTAT-MOD4-M005'),
    ('APSTAT-MOD4-H001-INV'),
    ('APSTAT-MOD5-M001'),
    ('APSTAT-MOD5-M002'),
    ('APSTAT-MOD5-M003'),
    ('APSTAT-MOD5-M004'),
    ('APSTAT-MOD5-M005'),
    ('APSTAT-MOD5-H001-INV'),
    ('APSTAT-MOD6-M002'),
    ('APSTAT-MOD6-M003'),
    ('APSTAT-MOD6-M004'),
    ('APSTAT-MOD6-M005'),
    ('APSTAT-MOD6-M001'),
    ('APSTAT-MOD6-H002'),
    ('APSTAT-MOD6-H003'),
    ('APSTAT-MOD6-H004'),
    ('APSTAT-MOD6-H005'),
    ('APSTAT-MOD6-H006'),
    ('APSTAT-MOD6-H007'),
    ('APSTAT-MOD6-H008'),
    ('APSTAT-MOD6-H009'),
    ('APSTAT-MOD6-H010'),
    ('APSTAT-MOD6-H001'),
    ('APSTAT-MOD6-H002-INV'),
    ('APSTAT-MOD7-M001'),
    ('APSTAT-MOD7-M002'),
    ('APSTAT-MOD7-M003'),
    ('APSTAT-MOD7-M004'),
    ('APSTAT-MOD7-M005'),
    ('APSTAT-MOD7-H002'),
    ('APSTAT-MOD7-H003'),
    ('APSTAT-MOD7-H004'),
    ('APSTAT-MOD7-H005'),
    ('APSTAT-MOD7-H006'),
    ('APSTAT-MOD7-H007'),
    ('APSTAT-MOD7-H008'),
    ('APSTAT-MOD7-H009'),
    ('APSTAT-MOD7-H010'),
    ('APSTAT-MOD7-H001'),
    ('APSTAT-MOD7-H002-INV'),
    ('APSTAT-MOD8-M001'),
    ('APSTAT-MOD8-M002'),
    ('APSTAT-MOD8-M003'),
    ('APSTAT-MOD8-M004'),
    ('APSTAT-MOD8-M005'),
    ('APSTAT-MOD8-H002'),
    ('APSTAT-MOD8-H003'),
    ('APSTAT-MOD8-H004'),
    ('APSTAT-MOD8-H001'),
    ('APSTAT-MOD8-VH001'),
    ('STATS-MOD1-E001'),
    ('STATS-MOD1-E002'),
    ('STATS-MOD1-E003'),
    ('STATS-MOD1-E004'),
    ('STATS-MOD1-E005'),
    ('STATS-MOD1-M001'),
    ('STATS-MOD1-M002'),
    ('STATS-MOD1-M003'),
    ('STATS-MOD1-M004'),
    ('STATS-MOD1-M005'),
    ('STATS-MOD3-M006'),
    ('STATS-MOD3-M007'),
    ('STATS-MOD3-H006'),
    ('STATS-MOD3-H007'),
    ('STATS-MOD3-H008'),
    ('STATS-MOD3-H009'),
    ('STATS-MOD3-H010'),
    ('STATS-MOD4-M008'),
    ('STATS-MOD4-M009'),
    ('STATS-MOD4-M010'),
    ('STATS-MOD4-H011'),
    ('STATS-MOD4-H012'),
    ('STATS-MOD4-H013'),
    ('STATS-MOD4-H014'),
    ('STATS-MOD4-H015'),
    ('STATS-MOD9-H016'),
    ('STATS-MOD9-H017'),
    ('STATS-MOD9-H018'),
    ('STATS-MOD9-H019'),
    ('STATS-MOD9-H020'),
    ('STATS-MOD9-VH001'),
    ('STATS-MOD9-VH002'),
    ('STATS-MOD9-VH003'),
    ('STATS-MOD9-VH004'),
    ('STATS-MOD9-VH005'),
    ('STATS-MOD1-E006'),
    ('STATS-MOD3-E006'),
    ('STATS-MOD3-E007'),
    ('STATS-MOD4-E005'),
    ('STATS-MOD4-E006')
)
select s.content_key, ci.status
from staged s
join app.content_items ci
  on ci.exam_pack_version_id = '548f06be-ccf4-426d-b82b-b424137a4438'::uuid
 and ci.content_key = s.content_key
order by s.content_key;
```

Expected result: zero rows. If any row appears, do not run the import until the staged key is renamed.

## Routing Metadata Limitation

The current `admin-content` CompatibilityProjection writes `prompt_json`, `mcq_choices`, and `frq_criteria`, but does not populate `content_item_versions.rubric_type` or `content_item_versions.evaluator_strategy`. This payload stores routing metadata inside `prompt_json.rubric_type` and `prompt_json.evaluator_strategy`:

- MCQ: `mcq` / `rule_based_mcq`
- FRQ: `discrete_text` / `llm_discrete_text`

If the live grading path requires the typed columns to be non-null before publish, update `admin-content` or perform a reviewed draft metadata repair before the separate publish operation.
