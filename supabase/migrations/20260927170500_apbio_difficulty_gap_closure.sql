-- AP Biology difficulty gap closure — 2026-09-27.
--
-- Traced origin: the one-shot 2026-09-24 difficulty load
-- (20260924240000_apbio_content_item_difficulty_load.sql, work order J.0) covered exactly
-- 118 items -- every Biology item that was current-latest-published at that time -- and
-- asserted that count. Since then 42 additional items (20 FRQ + 22 MCQ, all content
-- originally created June/July 2026) moved to published status through ordinary editorial
-- review, without any corresponding difficulty backfill. Biology has never been repacked
-- (a single exam_pack_version since 2026-06-27), so this is corpus growth outrunning a
-- one-time load, not a repack or a defect in that migration.
--
-- Method: DECISION-0061/0065's approved task-verb framework, applied identically to the
-- regex classification in scripts/taxonomy/build_remaining_difficulty_artifacts.py --
-- FRQ items use the modal criterion tier with an upward tie-break across
-- app.frq_criteria (learner_facing_text/evidence_requirements/minimum_fix); MCQ items
-- classify on the item stem. Items with no decisive verb cue default to
-- Medium/calibrated_judgement (the same undiscriminated-middle-band default the approved
-- method uses elsewhere), never a fabricated ratio. No authored difficulty value existed
-- for any of the 42 items (no content/item-packages/ap-biology directory, no
-- prompt_json.difficulty on any of them), so every row is freshly classified, not
-- translated from an author signal.
--
-- Source: docs/research/apbio_difficulty_gap_closure_2026_09_27/APBIO_DIFFICULTY_GAP_CLOSURE_2026_09_27.csv. Expected rows: 42.

begin;

create temporary table tmp_apbio_gap_difficulty (
  content_key text not null,
  content_item_version_id uuid not null,
  difficulty text not null,
  basis text not null,
  confidence text not null,
  rationale text not null
) on commit drop;

insert into tmp_apbio_gap_difficulty (
  content_key, content_item_version_id, difficulty, basis, confidence, rationale
) values
  ('APBIO-FRQ-L-001', 'ef2d7484-5d11-49c9-babe-17b81ad9e722'::uuid, 'Hard', 'calibrated_task_verb', 'medium', 'Per-criterion approved task-verb tiers, modal with upward tie-break: Easy=0, Medium=1, Hard=3; uncued=0/4.'),
  ('APBIO-FRQ-L-002', '1b100ce7-9a87-4aa2-96d3-903bffb61061'::uuid, 'Hard', 'calibrated_task_verb', 'medium', 'Per-criterion approved task-verb tiers, modal with upward tie-break: Easy=0, Medium=2, Hard=2; uncued=0/4.'),
  ('APBIO-FRQ-L-005', 'e540101d-9064-42ef-be46-3f20250d5890'::uuid, 'Hard', 'calibrated_task_verb', 'medium', 'Per-criterion approved task-verb tiers, modal with upward tie-break: Easy=0, Medium=1, Hard=3; uncued=0/4.'),
  ('APBIO-FRQ-L-007', 'f220b7ee-ab08-4159-8859-957f11ff66a8'::uuid, 'Hard', 'calibrated_task_verb', 'medium', 'Per-criterion approved task-verb tiers, modal with upward tie-break: Easy=0, Medium=1, Hard=3; uncued=0/4.'),
  ('APBIO-FRQ-L-009', '40c8df1f-b101-4e70-b865-6aa40bea192e'::uuid, 'Hard', 'calibrated_task_verb', 'medium', 'Per-criterion approved task-verb tiers, modal with upward tie-break: Easy=0, Medium=1, Hard=3; uncued=0/4.'),
  ('APBIO-FRQ-L-010', 'be82158f-c595-41a1-8343-3632b05881a1'::uuid, 'Hard', 'calibrated_task_verb', 'medium', 'Per-criterion approved task-verb tiers, modal with upward tie-break: Easy=0, Medium=2, Hard=2; uncued=0/4.'),
  ('APBIO-FRQ-L-011', 'f91f89a6-f921-446a-be37-1db4b953d9dc'::uuid, 'Medium', 'calibrated_task_verb', 'medium', 'Per-criterion approved task-verb tiers, modal with upward tie-break: Easy=0, Medium=3, Hard=1; uncued=0/4.'),
  ('APBIO-FRQ-L-020', '516fea66-c5ff-4680-8ba4-64aed6069299'::uuid, 'Hard', 'calibrated_task_verb', 'medium', 'Per-criterion approved task-verb tiers, modal with upward tie-break: Easy=0, Medium=1, Hard=3; uncued=0/4.'),
  ('APBIO-FRQ-L-022', '920efb75-adb8-4a5b-82de-631fdd646811'::uuid, 'Hard', 'calibrated_task_verb', 'medium', 'Per-criterion approved task-verb tiers, modal with upward tie-break: Easy=0, Medium=2, Hard=2; uncued=0/4.'),
  ('APBIO-FRQ-L-023', 'da2a05a0-804f-411f-95c6-2758b7b90c97'::uuid, 'Hard', 'calibrated_task_verb', 'medium', 'Per-criterion approved task-verb tiers, modal with upward tie-break: Easy=0, Medium=2, Hard=2; uncued=0/4.'),
  ('APBIO-FRQ-L-024', '69b7d582-5340-4c1c-bd05-cd27a7acf2aa'::uuid, 'Hard', 'calibrated_task_verb', 'medium', 'Per-criterion approved task-verb tiers, modal with upward tie-break: Easy=0, Medium=2, Hard=2; uncued=0/4.'),
  ('APBIO-FRQ-L-027', '745f637d-38e3-4eba-a499-bd41d36c977c'::uuid, 'Hard', 'calibrated_task_verb', 'medium', 'Per-criterion approved task-verb tiers, modal with upward tie-break: Easy=0, Medium=2, Hard=2; uncued=0/4.'),
  ('APBIO-FRQ-L-028', '21f346be-0ebc-40eb-9a8e-f1c1f0a36deb'::uuid, 'Hard', 'calibrated_task_verb', 'medium', 'Per-criterion approved task-verb tiers, modal with upward tie-break: Easy=0, Medium=1, Hard=3; uncued=0/4.'),
  ('APBIO-FRQ-L-029', 'f574ed19-2e8c-454f-a608-98913fcd61e7'::uuid, 'Medium', 'calibrated_task_verb', 'medium', 'Per-criterion approved task-verb tiers, modal with upward tie-break: Easy=0, Medium=3, Hard=1; uncued=0/4.'),
  ('APBIO-FRQ-L-038', 'd5073d33-6e1c-42f8-9898-da181271a93e'::uuid, 'Hard', 'calibrated_task_verb', 'medium', 'Per-criterion approved task-verb tiers, modal with upward tie-break: Easy=0, Medium=2, Hard=2; uncued=0/4.'),
  ('APBIO-FRQ-L-041', 'aacc9ec6-170a-45c7-8506-d555901260f4'::uuid, 'Hard', 'calibrated_task_verb', 'medium', 'Per-criterion approved task-verb tiers, modal with upward tie-break: Easy=0, Medium=1, Hard=3; uncued=0/4.'),
  ('APBIO-HDG-2026-GRAPH-004', '7a422558-266b-46ca-bdd7-380649a14b8d'::uuid, 'Easy', 'calibrated_task_verb', 'medium', 'Per-criterion approved task-verb tiers, modal with upward tie-break: Easy=2, Medium=0, Hard=0; uncued=2/4.'),
  ('APBIO-HDG-2026-GRAPH-006', '69087d2a-6b94-47b9-b1d6-c46885e80db9'::uuid, 'Medium', 'calibrated_task_verb', 'medium', 'Per-criterion approved task-verb tiers, modal with upward tie-break: Easy=1, Medium=1, Hard=0; uncued=2/4.'),
  ('APBIO-HDG-2026-GRAPH-011', '7df8bdea-4624-41a2-b582-b1fbbe28ea6c'::uuid, 'Easy', 'calibrated_task_verb', 'medium', 'Per-criterion approved task-verb tiers, modal with upward tie-break: Easy=1, Medium=0, Hard=0; uncued=3/4.'),
  ('APBIO-HDG-2026-GRAPH-012', 'c94f3ece-baa2-4329-bb25-2a6d02927de9'::uuid, 'Easy', 'calibrated_task_verb', 'medium', 'Per-criterion approved task-verb tiers, modal with upward tie-break: Easy=1, Medium=0, Hard=0; uncued=3/4.'),
  ('APBIO-MCQ-001', '648de313-d7af-4d38-8dc7-a95720549f20'::uuid, 'Medium', 'calibrated_judgement', 'low', 'No decisive MCQ task-verb cue; standard one-concept item judged Medium.'),
  ('APBIO-MCQ-002', 'de3826c7-8db9-4d00-9445-f7c3906637b3'::uuid, 'Hard', 'calibrated_task_verb', 'medium', 'MCQ stem classified by the approved task-verb framework: hard task-verb cue.'),
  ('APBIO-MCQ-003', '98acb099-5d5f-44ed-9cb9-873d770fab60'::uuid, 'Hard', 'calibrated_task_verb', 'medium', 'MCQ stem classified by the approved task-verb framework: hard task-verb cue.'),
  ('APBIO-MCQ-004', 'b15b600a-bc9f-4c61-bcc3-5d8df3ed745d'::uuid, 'Hard', 'calibrated_task_verb', 'medium', 'MCQ stem classified by the approved task-verb framework: hard task-verb cue.'),
  ('APBIO-MCQ-006', '41a0ab8d-4467-4aa9-8082-5877ee02e4f1'::uuid, 'Medium', 'calibrated_judgement', 'low', 'No decisive MCQ task-verb cue; standard one-concept item judged Medium.'),
  ('APBIO-MCQ-007', '3605c3f5-5927-4138-ba89-85f553137ada'::uuid, 'Hard', 'calibrated_task_verb', 'medium', 'MCQ stem classified by the approved task-verb framework: hard task-verb cue.'),
  ('APBIO-MCQ-009', '32bd1957-aef8-4650-ac90-81aa8a71ba0a'::uuid, 'Hard', 'calibrated_task_verb', 'medium', 'MCQ stem classified by the approved task-verb framework: hard task-verb cue.'),
  ('APBIO-MCQ-010', 'cde9b518-bfa6-45c5-9810-2f50adb45e5a'::uuid, 'Medium', 'calibrated_task_verb', 'medium', 'MCQ stem classified by the approved task-verb framework: medium task-verb cue.'),
  ('APBIO-MCQ-012', 'ee0171bf-7f01-4b8b-8532-b5e899ba382e'::uuid, 'Hard', 'calibrated_task_verb', 'medium', 'MCQ stem classified by the approved task-verb framework: hard task-verb cue.'),
  ('APBIO-MCQ-013', '36f25a53-4c17-4aee-8816-fbaf2c0ca8e5'::uuid, 'Hard', 'calibrated_task_verb', 'medium', 'MCQ stem classified by the approved task-verb framework: hard task-verb cue.'),
  ('APBIO-MCQ-015', '3ba6ba0e-60d1-4e16-b7b0-5799697b4f3b'::uuid, 'Medium', 'calibrated_task_verb', 'medium', 'MCQ stem classified by the approved task-verb framework: medium task-verb cue.'),
  ('APBIO-MCQ-029', '4296ef80-3689-477e-9c96-0511b2096e4d'::uuid, 'Medium', 'calibrated_judgement', 'low', 'No decisive MCQ task-verb cue; standard one-concept item judged Medium.'),
  ('APBIO-MCQ-036', '68cd3895-492f-4579-b326-10ccb3767406'::uuid, 'Hard', 'calibrated_task_verb', 'medium', 'MCQ stem classified by the approved task-verb framework: hard task-verb cue.'),
  ('APBIO-MCQ-038', '8fde6e51-5fcd-4cf8-a989-2f56dd25f2c8'::uuid, 'Medium', 'calibrated_task_verb', 'medium', 'MCQ stem classified by the approved task-verb framework: medium task-verb cue.'),
  ('APBIO-MCQ-041', '9935ee06-b328-4cb9-84cc-246389f7a22b'::uuid, 'Easy', 'calibrated_task_verb', 'medium', 'MCQ stem classified by the approved task-verb framework: easy task-verb cue.'),
  ('APBIO-MCQ-045', 'feba2b11-784a-4bcb-ab01-a09b8e7c4836'::uuid, 'Easy', 'calibrated_task_verb', 'medium', 'MCQ stem classified by the approved task-verb framework: easy task-verb cue.'),
  ('APBIO-MCQ-049', '40c0d313-5993-4b23-9c7b-8ee7a8ea4c5a'::uuid, 'Hard', 'calibrated_task_verb', 'medium', 'MCQ stem classified by the approved task-verb framework: hard task-verb cue.'),
  ('APBIO-MCQ-052', '8e8b2818-6a81-4a84-aebd-97596446037d'::uuid, 'Hard', 'calibrated_task_verb', 'medium', 'MCQ stem classified by the approved task-verb framework: hard task-verb cue.'),
  ('APBIO-MCQ-072', 'b683c4eb-fc84-4908-b3bd-30b4592ecf9c'::uuid, 'Hard', 'calibrated_task_verb', 'medium', 'MCQ stem classified by the approved task-verb framework: hard task-verb cue.'),
  ('APBIO-MCQ-076', 'bc7ba431-91a8-4f26-abac-4494284c51cc'::uuid, 'Easy', 'calibrated_task_verb', 'medium', 'MCQ stem classified by the approved task-verb framework: easy task-verb cue.'),
  ('APBIO-MCQ-082', '08b9f83a-8993-4aa7-b31d-9e7a9d6d5f75'::uuid, 'Hard', 'calibrated_task_verb', 'medium', 'MCQ stem classified by the approved task-verb framework: hard task-verb cue.'),
  ('APBIO-MCQ-090', '2b09ca09-284c-439d-8d33-b311f1550daa'::uuid, 'Medium', 'calibrated_task_verb', 'medium', 'MCQ stem classified by the approved task-verb framework: medium task-verb cue.');

do $$
declare
  v_expected int := 42;
  v_rows int;
  v_bad_scope int;
  v_already_has_difficulty int;
begin
  select count(*) into v_rows from tmp_apbio_gap_difficulty;
  if v_rows <> v_expected then
    raise exception 'apbio difficulty gap closure: expected % rows, found %', v_expected, v_rows;
  end if;

  -- Every target must still be a published AP Biology item on its current published version,
  -- with the content_key we generated the row against, and must not already have a
  -- difficulty row (this migration only fills the gap; it never overwrites an existing value).
  select count(*) into v_bad_scope
  from tmp_apbio_gap_difficulty tmp
  join app.content_item_versions civ on civ.id = tmp.content_item_version_id
  join app.content_items ci on ci.id = civ.content_item_id and ci.content_key = tmp.content_key
  join app.exam_pack_versions epv on epv.id = ci.exam_pack_version_id
  join app.exam_packs ep on ep.id = epv.exam_pack_id and ep.exam_code = 'ap_biology'
  left join lateral (
    select v.id from app.content_item_versions v
    where v.content_item_id = ci.id order by v.version_num desc limit 1
  ) current_version on true
  where ci.status <> 'published'
     or epv.status <> 'published'
     or epv.retired_at is not null
     or current_version.id is distinct from tmp.content_item_version_id;

  if v_bad_scope <> 0 then
    raise exception 'apbio difficulty gap closure aborted: % rows have wrong subject, content key, live pack, or are not the current version', v_bad_scope;
  end if;

  select count(*) into v_already_has_difficulty
  from tmp_apbio_gap_difficulty tmp
  join app.content_item_difficulty cid on cid.content_item_version_id = tmp.content_item_version_id;

  if v_already_has_difficulty <> 0 then
    raise exception 'apbio difficulty gap closure aborted: % rows already have a difficulty row', v_already_has_difficulty;
  end if;
end $$;

insert into app.content_item_difficulty (
  content_item_version_id, difficulty, basis, source_value, rationale, confidence,
  proposal_run
)
select
  tmp.content_item_version_id,
  tmp.difficulty,
  tmp.basis,
  null,
  tmp.rationale,
  tmp.confidence,
  'apbio_gap_closure_2026_09_27'
from tmp_apbio_gap_difficulty tmp;

do $$
declare
  v_written int;
begin
  select count(*) into v_written
  from app.content_item_difficulty cid
  where cid.proposal_run = 'apbio_gap_closure_2026_09_27';
  if v_written <> 42 then
    raise exception 'apbio difficulty gap closure: expected % written rows, found %', 42, v_written;
  end if;
end $$;

commit;
