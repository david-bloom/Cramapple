-- Pool 2 minor-notes repair, 2026-08-09.
--
-- Context: docs/research/QA_PROTOCOL_SECTION9_POOL1_POOL2_RUN_2026_08_09.md
-- §4, two non-defect notes flagged during the §9 QA run's Pool 2 sample,
-- now addressed per owner direction ("repair and publish pool 2"):
--
-- 1. apcalcbc-frq-u13-014: math and rubric were already correct, but
--    prompt_json.topic/unit tagged the item as Unit 2 ("2.1 Defining Average
--    and Instantaneous Rates of Change at a Point") while Part C explicitly
--    requires the Mean Value Theorem -- verified against
--    docs/product/AP_CALCULUS_AB_BC_CED_FACT_PACK.md line 105, which lists
--    MVT as topic 5.1 (Unit 5 - Analytical Applications of Differentiation),
--    not 5.9 as an earlier pass misquoted. Retagged to reflect the item's
--    defining skill.
-- 2. apchem-sfrq-015: part-c's rubric (2 points) required only the
--    qualitative claim that collision frequency isn't determined by mole
--    count alone. Independent re-derivation shows the fully correct answer
--    is stronger and quantitative: rate ratio He:Ar = (n_He/n_Ar)*(v_He/v_Ar)
--    = 0.667*sqrt(40/4) = 0.667*3.16 = 2.1, i.e. He actually collides MORE
--    frequently than Ar despite fewer moles -- not merely "frequency isn't
--    simply mole count." Tightened the criterion to require that
--    quantitative conclusion for the full 2 points.

begin;
select pg_advisory_xact_lock(hashtext('cramapple-pool2-minor-notes-repair-20260809'));

create temporary table repair_targets (content_key text primary key, item_type text) on commit drop;
insert into repair_targets values ('apcalcbc-frq-u13-014','frq'),('apchem-sfrq-015','frq');

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
  v_new_prompt_json jsonb;
begin
  for t in select * from repair_targets order by content_key loop
    select * into strict v_item
    from app.content_items
    where content_key=t.content_key and item_type=t.item_type
    for update;

    select * into strict v_old
    from app.content_item_versions
    where content_item_id=v_item.id and status='published'
    order by version_num desc
    limit 1
    for update;

    v_new := gen_random_uuid();

    if t.content_key = 'apcalcbc-frq-u13-014' then
      v_new_prompt_json := (coalesce(v_old.prompt_json,'{}'::jsonb)
        || jsonb_build_object('unit', 5, 'topic', '5.1 Using the Mean Value Theorem'));
    else
      v_new_prompt_json := coalesce(v_old.prompt_json,'{}'::jsonb);
    end if;

    v_new_prompt_json := v_new_prompt_json || jsonb_build_object(
      'content_version', v_old.version_num+1,
      'qa_remediation', '2026-08-09 Pool 2 minor-notes repair (protocol §9 follow-up)',
      'qa_source_version_id', v_old.id
    );

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
      v_new,v_item.id,v_old.version_num+1,v_old.stem,v_old.stimulus,v_new_prompt_json,
      v_old.explanation,v_old.help_text,md5(coalesce(v_old.stem,'')),
      'draft','f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,
      v_old.canonical_answer_1,v_old.canonical_answer_2,null,
      v_old.rubric_type,v_old.evaluator_strategy,v_old.stimulus_image_path
    );

    insert into app.frq_criteria (
      content_item_version_id,criterion_key,learner_facing_text,points_possible,
      evidence_requirements,minimum_fix,accepted_variants
    )
    select v_new,criterion_key,learner_facing_text,points_possible,
      evidence_requirements,minimum_fix,accepted_variants
    from app.frq_criteria
    where content_item_version_id=v_old.id;

    insert into repaired values (t.content_key,v_old.id,v_new);
  end loop;
end $$;

-- apchem-sfrq-015 part-c: tighten to require the quantitative conclusion.
update app.frq_criteria fc
set
  learner_facing_text='Disagrees with the claim. A complete response computes the collision-frequency ratio using both amount and speed: rate ratio He:Ar = (n_He/n_Ar)x(v_He/v_Ar) = (0.200/0.300)xsqrt(40./4.00) = 0.667x3.16 approximately 2.1, showing He particles actually collide with the walls MORE frequently than Ar despite fewer moles present, because He''s lower molar mass gives it a large enough speed advantage (same average KE at the same temperature) to outweigh its smaller mole fraction.',
  evidence_requirements='Two required elements, 1 point each: (1) disagrees with the claim and correctly explains that at the same temperature He particles move faster than Ar particles (lower molar mass, same average KE), so collision frequency is not determined by mole count alone; (2) computes the quantitative collision-frequency ratio (approximately 2.1, He:Ar) and concludes He actually collides more frequently than Ar despite the smaller mole fraction. Award 1 point per element present.',
  minimum_fix='To earn full credit, explicitly show: (1) He moves faster than Ar at the same temperature because of its lower molar mass (same average KE); (2) the quantitative ratio (n_He/n_Ar)x(v_He/v_Ar) approximately 2.1, concluding He collides more frequently than Ar overall.'
from repaired r
where r.content_key='apchem-sfrq-015' and fc.content_item_version_id=r.new_version_id and fc.criterion_key='part-c';

update app.content_item_versions civ
set content_hash=md5(coalesce(civ.stem,'')||E'\n'||coalesce(civ.stimulus,'')||E'\n'||
  coalesce((select string_agg(fc.criterion_key||':'||fc.learner_facing_text, E'\n' order by fc.criterion_key)
            from app.frq_criteria fc where fc.content_item_version_id=civ.id),''))
from repaired r where civ.id=r.new_version_id;

insert into app.content_review_assignments (
  content_review_assignment_id, content_item_version_id, reviewer_id,
  review_stage, review_kind, status, assignment_purpose, created_by
)
select gen_random_uuid(),new_version_id,'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,
       'tutor_question','frq','pending','owner_remediation_approval','f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
from repaired;

insert into app.content_review_decisions (
  content_review_assignment_id,content_item_version_id,reviewer_id,
  review_stage,tutor_score,difficulty_label,diagnostic_flag,
  concern_codes,note,tutor_decision,decision_payload,
  decision_hash,created_by
)
select cra.content_review_assignment_id,r.new_version_id,'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,
       'tutor_question',1,'Medium',false,array[]::text[],
       'Owner-directed Pool 2 minor-notes repair, 2026-08-09 (protocol §9 QA follow-up): '
       || case when r.content_key='apcalcbc-frq-u13-014'
               then 'retagged topic/unit to reflect Part C''s Mean Value Theorem requirement'
               else 'tightened part-c rubric to require the quantitative collision-frequency conclusion' end
       || ' -- ' || r.content_key,
       'approve',
       jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','pool2_minor_notes_repair','content_key',r.content_key,'qa_date','2026-08-09'),
       encode(extensions.digest(jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','pool2_minor_notes_repair','content_key',r.content_key,'qa_date','2026-08-09')::text,'sha256'),'hex'),
       'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
from repaired r
join app.content_review_assignments cra on cra.content_item_version_id=r.new_version_id and cra.assignment_purpose='owner_remediation_approval' and cra.status='pending';

update app.content_item_versions civ
set status='reviewed_approved',
    review_status='question_review_approved',
    approved_by='f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,
    approved_at=coalesce(civ.approved_at,now()),
    updated_at=now()
from repaired r where civ.id=r.new_version_id;

update app.content_items ci
set status='reviewed_approved', updated_at=now()
from repaired r join app.content_item_versions civ on civ.id=r.new_version_id
where ci.id=civ.content_item_id;

update app.content_item_versions civ
set status='published', published_at=coalesce(civ.published_at,now()), updated_at=now()
from repaired r where civ.id=r.new_version_id;

update app.content_items ci
set status='published', updated_at=now()
from repaired r join app.content_item_versions civ on civ.id=r.new_version_id
where ci.id=civ.content_item_id;

do $$
declare n integer;
begin
  select count(*) into n from repaired;
  if n<>2 then raise exception 'expected 2 repaired items, got %', n; end if;

  select count(*) into n from (
    select r.content_key, sum(fc.points_possible) total_points,
      case r.content_key when 'apchem-sfrq-015' then 4 when 'apcalcbc-frq-u13-014' then 9 end expected_total
    from repaired r join app.frq_criteria fc on fc.content_item_version_id=r.new_version_id
    group by r.content_key
  ) totals where total_points<>expected_total;
  if n<>0 then raise exception 'point total drifted for % item(s)', n; end if;

  select count(*) into n from (
    select content_item_id from app.content_item_versions where status='published'
    group by content_item_id having count(*)>1
  ) d;
  if n<>0 then raise exception 'duplicate published versions after repair: %', n; end if;
end $$;

select ci.content_key, v.prompt_json->>'topic' as topic, v.prompt_json->>'unit' as unit
from repaired r
join app.content_item_versions v on v.id=r.new_version_id
join app.content_items ci on ci.id=v.content_item_id;

commit;
