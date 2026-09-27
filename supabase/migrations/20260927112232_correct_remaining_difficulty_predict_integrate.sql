-- Correct DECISION-0061 predict/integrate difficulty tier assignments.
-- Generated offline on 2026-09-26; applies only after the 20260926234000-234400
-- base difficulty migrations have inserted their original Medium rows.

begin;

create temporary table tmp_difficulty_method_corrections (
  content_key text not null,
  content_item_version_id uuid not null,
  old_difficulty text not null,
  old_rationale text not null,
  new_difficulty text not null,
  new_rationale text not null
) on commit drop;

insert into tmp_difficulty_method_corrections (
  content_key, content_item_version_id, old_difficulty, old_rationale,
  new_difficulty, new_rationale
) values
  ('apphycem-frq-021', '80649e35-7e85-49bb-a863-7a53c80699d3'::uuid, 'Medium', 'Per-criterion approved task-verb tiers, modal with upward tie-break: Easy=0, Medium=4, Hard=1; uncued=3/8.', 'Hard', 'QA correction under DECISION-0061: `predict` is a Hard task verb; corrected from the already-applied Medium row to Hard.'),
  ('apphycem-frq-025', '43a19e11-5d0b-437f-9d9b-7098ee87e22e'::uuid, 'Medium', 'Per-criterion approved task-verb tiers, modal with upward tie-break: Easy=1, Medium=4, Hard=0; uncued=3/8.', 'Hard', 'QA correction under DECISION-0061: `predict` is a Hard task verb; corrected from the already-applied Medium row to Hard.'),
  ('apphycm-frq-017', '57c6fbdf-72dc-4205-9d04-8dc339144511'::uuid, 'Medium', 'Per-criterion approved task-verb tiers, modal with upward tie-break: Easy=0, Medium=3, Hard=2; uncued=2/7.', 'Hard', 'QA correction under DECISION-0061: `predict` is a Hard task verb; corrected from the already-applied Medium row to Hard.'),
  ('apphycm-frq-024', '5fcb4563-b353-4692-98aa-af5b356af902'::uuid, 'Medium', 'Per-criterion approved task-verb tiers, modal with upward tie-break: Easy=2, Medium=3, Hard=0; uncued=2/7.', 'Hard', 'QA correction under DECISION-0061: `predict` is a Hard task verb; corrected from the already-applied Medium row to Hard.'),
  ('apcalcbc-frq-np1-006', '5a71d645-8c9a-4b00-a91b-e45bdc91c184'::uuid, 'Medium', 'Per-criterion approved task-verb tiers, modal with upward tie-break: Easy=1, Medium=2, Hard=1; uncued=0/4.', 'Hard', 'QA correction under DECISION-0061: `integrate` is a Hard task verb; corrected from the already-applied Medium row to Hard.');

do $$
declare
  v_expected int := 5;
  v_rows int;
  v_missing int;
  v_wrong_old int;
  v_wrong_subject int;
begin
  select count(*) into v_rows from tmp_difficulty_method_corrections;
  if v_rows <> v_expected then
    raise exception 'difficulty method correction: expected % rows, found %', v_expected, v_rows;
  end if;

  select count(*) into v_missing
  from tmp_difficulty_method_corrections tmp
  where not exists (
    select 1
    from app.content_item_difficulty cid
    where cid.content_item_version_id = tmp.content_item_version_id
  );
  if v_missing <> 0 then
    raise exception 'difficulty method correction: % target rows are missing', v_missing;
  end if;

  select count(*) into v_wrong_old
  from tmp_difficulty_method_corrections tmp
  join app.content_item_difficulty cid
    on cid.content_item_version_id = tmp.content_item_version_id
  where cid.difficulty is distinct from tmp.old_difficulty
     or cid.basis is distinct from 'calibrated_task_verb'
     or cid.rationale is distinct from tmp.old_rationale;
  if v_wrong_old <> 0 then
    raise exception 'difficulty method correction: % rows are not at the expected applied old state', v_wrong_old;
  end if;

  select count(*) into v_wrong_subject
  from tmp_difficulty_method_corrections tmp
  where not exists (
    select 1
    from app.content_items ci
    join lateral (
      select civ.id, civ.status
      from app.content_item_versions civ
      where civ.content_item_id = ci.id
      order by civ.version_num desc
      limit 1
    ) latest on true
    where ci.content_key = tmp.content_key
      and latest.id = tmp.content_item_version_id
      and ci.status = 'published'
      and latest.status = 'published'
  );
  if v_wrong_subject <> 0 then
    raise exception 'difficulty method correction: % rows are not current published versions', v_wrong_subject;
  end if;
end $$;

update app.content_item_difficulty cid
set
  difficulty = tmp.new_difficulty,
  rationale = tmp.new_rationale,
  proposal_run = cid.proposal_run || '_method_correction_predict_integrate_2026_09_27'
from tmp_difficulty_method_corrections tmp
where cid.content_item_version_id = tmp.content_item_version_id;

do $$
declare
  v_corrected int;
begin
  select count(*) into v_corrected
  from tmp_difficulty_method_corrections tmp
  join app.content_item_difficulty cid
    on cid.content_item_version_id = tmp.content_item_version_id
  where cid.difficulty = tmp.new_difficulty
    and cid.rationale = tmp.new_rationale;

  if v_corrected <> 5 then
    raise exception 'difficulty method correction verification failed: expected %, found %', 5, v_corrected;
  end if;
end $$;

commit;
