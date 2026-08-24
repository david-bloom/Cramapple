-- Records, retroactively, that all 8 items published in
-- 20260824120000_orly_protocol_calc_unit1_unit2_items.sql were independently
-- re-derived from first principles (CONTENT_AUTHORING_AND_QA_PROTOCOL.md §9)
-- on 2026-08-24, after publish -- closing the gap the protocol revision in
-- docs/research/ORLY_EXTERNAL_ASSIGNMENT_MINING_PROTOCOL_2026_08_24.md §6
-- step 4 now requires before publish for every future item.

update app.content_item_versions civ
set prompt_json = jsonb_set(
  civ.prompt_json,
  '{review_notes,independent_re_derivation}',
  to_jsonb('Re-solved from first principles 2026-08-24 (post-publish, per CONTENT_AUTHORING_AND_QA_PROTOCOL.md §9), independent of the drafted answer key -- matched on all 8 items in this batch.'::text)
)
from app.content_items ci
where ci.id = civ.content_item_id
  and ci.content_key in (
    'apcalcab-mcq-060','apcalcab-mcq-070','apcalcab-mcq-080','apcalcab-mcq-090',
    'apcalcbc-mcq-060','apcalcbc-mcq-070','apcalcbc-mcq-080','apcalcbc-mcq-090'
  );
