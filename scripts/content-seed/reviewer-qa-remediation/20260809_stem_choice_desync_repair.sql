-- Stem/mcq_choices text-desync repair, 2026-08-09.
--
-- Context: docs/research/QA_PROTOCOL_SECTION9_POOL1_POOL2_RUN_2026_08_09.md
-- §5-§7. A mechanical scan found 25 published MCQs where the stem's embedded
-- lettered option text diverges from app.mcq_choices.choice_text for the
-- same letter -- all introduced by prior hand-written repair scripts that
-- updated mcq_choices but forgot the matching stem line (100% version_num
-- >= 2). Cross-checked all 25 against their own `rationale` fields: in every
-- case mcq_choices.choice_text is internally consistent with its rationale
-- (the rationale explains that exact wording); the stem's embedded copy is
-- uniformly the stale leftover. This script resyncs the stem to match
-- mcq_choices using app.mcq_stem_choice_resync() (added alongside the
-- publish-time gate in this session) rather than hand-typed replace() calls,
-- removing the exact human-omission failure mode that caused the defect.
--
-- Owner-directed: "remediate the 25 flagged items ... Re-qa and report
-- outcome."

begin;
select pg_advisory_xact_lock(hashtext('cramapple-stem-choice-desync-repair-20260809'));

create temporary table repair_targets (content_key text primary key) on commit drop;
insert into repair_targets values
('apcalcbc-mcq-028'),('apchem-mcq-012'),('apchem-mcq-014'),('apchem-mcq-018'),
('apchem-mcq-024'),('apchem-mcq-030'),('apchem-mcq-033'),('apchem-mcq-035'),
('apchem-mcq-037'),('apchem-mcq-039'),('apchem-mcq-042'),('apchem-mcq-043'),
('apchem-mcq-046'),('apchem-mcq-049'),('apchem-mcq-055'),('apchem-mcq-057'),
('apchem-mcq-062'),('apchem-mcq-063'),('apchem-mcq-068'),('apphycem-mcq-014'),
('apphycem-mcq-025'),('apphycem-mcq-027'),('apphycm-mcq-019'),('apprecalc-mcq-028'),
('apprecalc-mcq-031');

create temporary table repaired (
  content_key text primary key,
  old_version_id uuid not null,
  new_version_id uuid not null
) on commit drop;

do $$
declare
  t record;
  v_item app.content_items%rowtype;
  v_old app.content_item_versions%rowtype;
  v_new uuid;
  v_fixed_stem text;
begin
  for t in select * from repair_targets order by content_key loop
    select * into strict v_item
    from app.content_items
    where content_key=t.content_key and item_type='mcq'
    for update;

    select * into strict v_old
    from app.content_item_versions
    where content_item_id=v_item.id and status='published'
    order by version_num desc
    limit 1
    for update;

    -- Sanity: confirm this version really has a desync before touching it.
    if array_length(app.mcq_stem_choice_desync(v_old.id, v_old.stem), 1) is null then
      raise exception 'no desync found for % (version %) -- refusing to touch a clean item', t.content_key, v_old.version_num;
    end if;

    v_fixed_stem := app.mcq_stem_choice_resync(v_old.id, v_old.stem);
    v_new := gen_random_uuid();

    update app.content_review_assignments
    set status='skipped'
    where content_item_version_id=v_old.id
      and assignment_purpose='subject_review'
      and status in ('pending','in_progress');

    update app.content_item_versions
    set status='retired', updated_at=now()
    where id=v_old.id;

    update app.content_items
    set status='draft', updated_at=now()
    where id=v_item.id;

    insert into app.content_item_versions (
      id,content_item_id,version_num,stem,stimulus,prompt_json,
      explanation,help_text,content_hash,status,created_by,
      canonical_answer_1,canonical_answer_2,review_status,
      rubric_type,evaluator_strategy,stimulus_image_path
    ) values (
      v_new,v_item.id,v_old.version_num+1,v_fixed_stem,v_old.stimulus,
      coalesce(v_old.prompt_json,'{}'::jsonb) || jsonb_build_object(
        'content_version',v_old.version_num+1,
        'qa_remediation','2026-08-09 stem/mcq_choices desync repair (protocol §9 follow-up)',
        'qa_source_version_id',v_old.id
      ),
      v_old.explanation,v_old.help_text,md5(coalesce(v_fixed_stem,'')),
      'draft','f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,
      v_old.canonical_answer_1,v_old.canonical_answer_2,null,
      v_old.rubric_type,v_old.evaluator_strategy,v_old.stimulus_image_path
    );

    insert into app.mcq_choices (
      content_item_version_id,choice_key,choice_text,is_correct,rationale
    )
    select v_new,choice_key,choice_text,is_correct,rationale
    from app.mcq_choices
    where content_item_version_id=v_old.id;

    insert into repaired values (t.content_key,v_old.id,v_new);
  end loop;
end $$;

update app.content_item_versions civ
set content_hash = md5(coalesce(civ.stem,'')||E'\n'||coalesce(civ.stimulus,'')||E'\n'||
  coalesce((select string_agg(m.choice_key||':'||m.choice_text||':'||m.is_correct::text||':'||coalesce(m.rationale,''), E'\n' order by m.choice_key)
            from app.mcq_choices m where m.content_item_version_id=civ.id),''))
from repaired r where civ.id=r.new_version_id;

insert into app.content_review_assignments (
  content_review_assignment_id, content_item_version_id, reviewer_id,
  review_stage, review_kind, status, assignment_purpose, created_by
)
select gen_random_uuid(),new_version_id,'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,
       'tutor_question','mcq','pending','owner_remediation_approval','f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
from repaired;

insert into app.content_review_decisions (
  content_review_assignment_id,content_item_version_id,reviewer_id,
  review_stage,tutor_score,difficulty_label,diagnostic_flag,
  concern_codes,note,tutor_decision,decision_payload,
  decision_hash,created_by
)
select cra.content_review_assignment_id,r.new_version_id,'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,
       'tutor_question',1,'Medium',false,array[]::text[],
       'Owner-directed stem/mcq_choices desync repair, 2026-08-09 (protocol §9 QA follow-up). Stem resynced to match mcq_choices via app.mcq_stem_choice_resync(); answer key and rationale unchanged -- ' || r.content_key,
       'approve',
       jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','stem_choice_desync_repair','content_key',r.content_key,'qa_date','2026-08-09'),
       encode(extensions.digest(jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','stem_choice_desync_repair','content_key',r.content_key,'qa_date','2026-08-09')::text,'sha256'),'hex'),
       'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
from repaired r
join app.content_review_assignments cra on cra.content_item_version_id=r.new_version_id and cra.assignment_purpose='owner_remediation_approval' and cra.status='pending';

update app.content_item_versions civ
set status='reviewed_approved',
    review_status='question_review_approved',
    approved_by='f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,
    approved_at=coalesce(civ.approved_at,now()),
    updated_at=now()
from repaired r
where civ.id=r.new_version_id;

update app.content_items ci
set status='reviewed_approved', updated_at=now()
from repaired r
join app.content_item_versions civ on civ.id=r.new_version_id
where ci.id=civ.content_item_id;

update app.content_item_versions civ
set status='published',
    published_at=coalesce(civ.published_at,now()),
    updated_at=now()
from repaired r
where civ.id=r.new_version_id;

update app.content_items ci
set status='published', updated_at=now()
from repaired r
join app.content_item_versions civ on civ.id=r.new_version_id
where ci.id=civ.content_item_id;

do $$
declare n integer;
begin
  select count(*) into n from repaired;
  if n<>25 then raise exception 'expected 25 repaired MCQs, got %', n; end if;

  select count(*) into n from (
    select r.content_key
    from repaired r
    join app.content_item_versions civ on civ.id=r.new_version_id
    where array_length(app.mcq_stem_choice_desync(civ.id, civ.stem), 1) > 0
  ) d;
  if n<>0 then raise exception 'still-desynced items after repair: %', n; end if;

  select count(*) into n from (
    select content_item_id from app.content_item_versions where status='published'
    group by content_item_id having count(*)>1
  ) d;
  if n<>0 then raise exception 'duplicate published versions after repair: %', n; end if;
end $$;

select 'repaired' metric, count(*)::text value from repaired
union all select 'still_desynced', (
  select count(*)::text from repaired r
  join app.content_item_versions civ on civ.id=r.new_version_id
  where array_length(app.mcq_stem_choice_desync(civ.id, civ.stem), 1) > 0
);

commit;
