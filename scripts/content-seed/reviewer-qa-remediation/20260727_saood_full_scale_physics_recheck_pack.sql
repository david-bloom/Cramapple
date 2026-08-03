-- Create a second-review pack for the 16 full-scale Physics FRQs and assign
-- the new immutable versions to Muhammad Saood.
--
-- This is intentionally a version fork: the assignment uniqueness contract
-- permits one tutor_question assignment per reviewer/version, and Saood's
-- original submitted decisions must remain immutable.

begin;

select pg_advisory_xact_lock(
  hashtext('cramapple-saood-full-scale-physics-recheck-20260727')
);

create temporary table pack_items (
  content_key text primary key
) on commit drop;

insert into pack_items(content_key) values
  ('apphy1-frq-035'),('apphy1-frq-036'),('apphy1-frq-037'),('apphy1-frq-038'),
  ('apphy2-frq-035'),('apphy2-frq-036'),('apphy2-frq-037'),('apphy2-frq-038'),
  ('apphycm-frq-035'),('apphycm-frq-036'),('apphycm-frq-037'),('apphycm-frq-038'),
  ('apphycem-frq-035'),('apphycem-frq-036'),('apphycem-frq-037'),('apphycem-frq-038');

create temporary table created_assignments (
  content_review_assignment_id uuid primary key,
  exam_pack_id uuid not null
) on commit drop;

do $$
declare
  k record;
  v_item app.content_items%rowtype;
  v_old app.content_item_versions%rowtype;
  v_new_id uuid;
  v_assignment_id uuid;
  v_exam_pack_id uuid;
begin
  for k in select content_key from pack_items order by content_key loop
    select * into strict v_item
    from app.content_items
    where content_key=k.content_key
    for update;

    select * into strict v_old
    from app.content_item_versions
    where content_item_id=v_item.id
    order by version_num desc
    limit 1
    for update;

    select exam_pack_id into strict v_exam_pack_id
    from app.exam_pack_versions
    where id=v_item.exam_pack_version_id;

    -- Idempotent rerun: reuse the already-created pack assignment.
    if v_old.prompt_json->>'review_pack_key'=
       'saood-full-scale-physics-recheck-2026-07-27' then
      select content_review_assignment_id into strict v_assignment_id
      from app.content_review_assignments
      where content_item_version_id=v_old.id
        and reviewer_id='cee0cee4-fc59-4084-9a83-b24ccca940b9'
        and review_stage='tutor_question';

      insert into created_assignments values (
        v_assignment_id,v_exam_pack_id
      ) on conflict do nothing;
      continue;
    end if;

    update app.content_item_versions
    set status='retired'
    where id=v_old.id and status<>'retired';

    update app.content_items
    set status='draft'
    where id=v_item.id;

    insert into app.content_item_versions (
      content_item_id, version_num, stem, stimulus, prompt_json,
      explanation, help_text, content_hash, status, created_by,
      canonical_answer_1, canonical_answer_2, review_status,
      rubric_type, evaluator_strategy, stimulus_image_path
    ) values (
      v_item.id,
      v_old.version_num+1,
      v_old.stem,
      v_old.stimulus,
      coalesce(v_old.prompt_json,'{}'::jsonb) || jsonb_build_object(
        'content_version',v_old.version_num+1,
        'review_pack_key','saood-full-scale-physics-recheck-2026-07-27',
        'review_pack_name','Full-scale Physics FRQ recheck',
        'review_display_fix','queue-expanded-structured-parts'
      ),
      v_old.explanation,
      v_old.help_text,
      v_old.content_hash,
      'draft',
      'f5a26c6b-3566-4d58-9e97-979fbb947564',
      v_old.canonical_answer_1,
      v_old.canonical_answer_2,
      null,
      v_old.rubric_type,
      v_old.evaluator_strategy,
      v_old.stimulus_image_path
    ) returning id into v_new_id;

    insert into app.frq_criteria (
      content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    )
    select v_new_id, criterion_key, learner_facing_text,
           points_possible, evidence_requirements, minimum_fix, accepted_variants
    from app.frq_criteria
    where content_item_version_id=v_old.id;

    insert into app.content_review_assignments (
      content_item_version_id, reviewer_id, review_stage, review_kind,
      status, created_by
    ) values (
      v_new_id,
      'cee0cee4-fc59-4084-9a83-b24ccca940b9',
      'tutor_question',
      'frq',
      'pending',
      'f5a26c6b-3566-4d58-9e97-979fbb947564'
    ) returning content_review_assignment_id into v_assignment_id;

    insert into created_assignments values (
      v_assignment_id,v_exam_pack_id
    );
  end loop;
end
$$;

-- A workflow label gives the 16 cross-subject assignments one stable pack
-- identity while respecting the exam-pack ownership of content labels.
insert into app.content_labels (
  exam_pack_id,label_key,label_name,label_type,status,created_by
)
select distinct
  exam_pack_id,
  'saood-full-scale-physics-recheck-2026-07-27',
  'Full-scale Physics FRQ recheck',
  'workflow',
  'published',
  'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
from created_assignments
on conflict (exam_pack_id,label_key) do update
set label_name=excluded.label_name,
    label_type=excluded.label_type,
    status=excluded.status;

insert into app.content_review_assignment_labels (
  content_review_assignment_id,content_label_id,created_by
)
select
  a.content_review_assignment_id,
  l.id,
  'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
from created_assignments a
join app.content_labels l
  on l.exam_pack_id=a.exam_pack_id
 and l.label_key='saood-full-scale-physics-recheck-2026-07-27'
on conflict do nothing;

commit;
