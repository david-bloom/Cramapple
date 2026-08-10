-- Pasted-prompt-rubric FRQ repair (protocol §9.3 defect class), 2026-08-10.
--
-- Context: docs/Q&A/REVIEWER_QA_SWEEP_2026_08_09.md and
-- docs/Q&A/REVIEWER_QA_SWEEP_2026_08_10.md. A mechanical scan (a criterion's
-- learner_facing_text appearing verbatim as a substring of the item's own stem) found
-- 10 live hits, all a part-b criterion echoing the stem's "state the governing
-- principle... and explain why" instruction wording instead of stating the actual
-- graded content. 5 of the 10 were retired already; these 5 are still status='published'
-- and live to students: apphy2-frq-002/003/005, apphycem-frq-008/009.
--
-- Fix: for each item, rewrite only the part-b criterion's learner_facing_text from an
-- instruction ("explain how X and explain why Y") to a declarative statement of the
-- specific physics content that earns the point -- matching the style each item's own
-- part-a criterion and evidence_requirements already use. evidence_requirements and
-- minimum_fix (already substantive, not verbatim-stem, on inspection) are left
-- unchanged; only learner_facing_text is rewritten. Points, stem, and stimulus are
-- unchanged -- this is a rubric-wording fix, not a content redesign.
--
-- Owner-directed: "Remediate the 5 pasted-prompt-rubric FRQs" (still-open follow-up from
-- the 08-09 and 08-10 sweeps).

begin;
select pg_advisory_xact_lock(hashtext('cramapple-pasted-prompt-rubric-frq-repair-20260810'));

create temporary table repair_targets (
  content_key text primary key,
  new_part_b_text text not null
) on commit drop;

insert into repair_targets values
('apphy2-frq-002',
 'Superposition applied vectorially to the two electric-field vectors makes them cancel at the midpoint, since the charges are equal in magnitude and equidistant from it; superposition applied algebraically to the two scalar potentials makes them add, since both are positive and at equal distance.'),
('apphy2-frq-003',
 E'Kirchhoff''s voltage law around the RC loop (ε = iR + q/C) yields the exponential charging equation; the ideal battery (no internal resistance) and the initially uncharged capacitor (q(0)=0) justify the initial condition V_C(0)=0.'),
('apphy2-frq-005',
 'The thin-lens equation holds because the lens is modeled as infinitely thin with paraxial (small-angle) rays; the sign convention assigns a positive image distance to the real image and a negative magnification to the inverted image, matching the computed value.'),
('apphycem-frq-008',
 E'E=-dV/dx is the governing relation between field and potential gradient; because V(x) depends only on x (one-dimensional), the negative of its slope gives the field direction found in part (a) (+x).'),
('apphycem-frq-009',
 'Capacitance is defined by C=εA/d; holding the plate area A fixed while the test varies the plate separation d isolates d as the tested variable, which is necessary to interpret the measured C as evidence for that relation.');

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
begin
  for t in select * from repair_targets order by content_key loop
    select * into strict v_item
    from app.content_items
    where content_key=t.content_key and item_type='frq'
    for update;

    select * into strict v_old
    from app.content_item_versions
    where content_item_id=v_item.id and status='published'
    order by version_num desc
    limit 1
    for update;

    -- Sanity: confirm the defect is really there before touching the item.
    if not exists (
      select 1 from app.frq_criteria fc
      where fc.content_item_version_id=v_old.id
        and fc.criterion_key='part-b'
        and length(fc.learner_facing_text) > 25
        and position(fc.learner_facing_text in v_old.stem) > 0
    ) then
      raise exception 'no pasted-prompt-rubric defect found on part-b for % (version %) -- refusing to touch a clean item', t.content_key, v_old.version_num;
    end if;

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
      v_new,v_item.id,v_old.version_num+1,v_old.stem,v_old.stimulus,
      coalesce(v_old.prompt_json,'{}'::jsonb) || jsonb_build_object(
        'content_version',v_old.version_num+1,
        'qa_remediation','2026-08-10 pasted-prompt-rubric FRQ repair (protocol §9.3 follow-up)',
        'qa_source_version_id',v_old.id
      ),
      v_old.explanation,v_old.help_text,v_old.content_hash,
      'draft','f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,
      v_old.canonical_answer_1,v_old.canonical_answer_2,null,
      v_old.rubric_type,v_old.evaluator_strategy,v_old.stimulus_image_path
    );

    insert into app.frq_criteria (
      content_item_version_id, criterion_key, learner_facing_text, points_possible,
      evidence_requirements, minimum_fix, accepted_variants
    )
    select
      v_new,
      fc.criterion_key,
      case fc.criterion_key when 'part-b' then t.new_part_b_text else fc.learner_facing_text end,
      fc.points_possible, fc.evidence_requirements, fc.minimum_fix, fc.accepted_variants
    from app.frq_criteria fc
    where fc.content_item_version_id=v_old.id;

    insert into repaired values (t.content_key,v_old.id,v_new);
  end loop;
end $$;

update app.content_item_versions civ
set content_hash = md5(coalesce(civ.stem,'')||E'\n'||coalesce(civ.stimulus,'')||E'\n'||
  coalesce((select string_agg(fc.criterion_key||':'||fc.learner_facing_text||':'||fc.points_possible::text, E'\n' order by fc.criterion_key)
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
       'Owner-directed pasted-prompt-rubric repair, 2026-08-10 (protocol §9.3 QA follow-up, docs/Q&A/REVIEWER_QA_SWEEP_2026_08_09.md and _2026_08_10.md). part-b learner_facing_text rewritten from a stem-echoing instruction to a declarative statement of the graded content; points, stem, stimulus, evidence_requirements, and minimum_fix unchanged -- ' || r.content_key,
       'approve',
       jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','pasted_prompt_rubric_frq_repair','content_key',r.content_key,'qa_date','2026-08-10'),
       encode(extensions.digest(jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','pasted_prompt_rubric_frq_repair','content_key',r.content_key,'qa_date','2026-08-10')::text,'sha256'),'hex'),
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
  if n<>5 then raise exception 'expected 5 repaired FRQs, got %', n; end if;

  select count(*) into n from (
    select r.content_key
    from repaired r
    join app.content_item_versions civ on civ.id=r.new_version_id
    join app.frq_criteria fc on fc.content_item_version_id=civ.id and fc.criterion_key='part-b'
    where length(fc.learner_facing_text) > 25
      and position(fc.learner_facing_text in civ.stem) > 0
  ) d;
  if n<>0 then raise exception 'still-pasted items after repair: %', n; end if;

  select count(*) into n from (
    select content_item_id from app.content_item_versions where status='published'
    group by content_item_id having count(*)>1
  ) d;
  if n<>0 then raise exception 'duplicate published versions after repair: %', n; end if;
end $$;

select 'repaired' metric, count(*)::text value from repaired
union all select 'still_pasted', (
  select count(*)::text
  from repaired r
  join app.content_item_versions civ on civ.id=r.new_version_id
  join app.frq_criteria fc on fc.content_item_version_id=civ.id and fc.criterion_key='part-b'
  where length(fc.learner_facing_text) > 25
    and position(fc.learner_facing_text in civ.stem) > 0
);

commit;
