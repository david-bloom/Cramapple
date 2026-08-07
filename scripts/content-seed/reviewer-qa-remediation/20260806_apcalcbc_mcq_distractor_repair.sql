-- AP Calculus BC MCQ distractor-rationale repair, 2026-08-06.
--
-- Context: 2026-08-06 reviewer QA sweep (docs/Q&A/REVIEWER_QA_SWEEP_2026_08_06.md)
-- flagged that Muhammad Saood's approve_with_edits/disapprove notes on six AP Calc BC
-- MCQs identify distractor choices whose displayed numeric value cannot be reproduced
-- by the rationale text attached to them -- i.e. the "why this is wrong" explanation
-- does not actually generate the wrong-answer number shown to students. All six keyed
-- (correct) answers were independently re-derived and confirmed correct; only distractor
-- values/rationales are touched here.
--
-- Owner instruction, 2026-08-06 (chat): "Confirm Saood's Calculus BC findings and repair
-- the errors."
--
-- Per-item math re-derivation (verified with a standalone script, not trusted from the
-- original generation):
--   apcalcbc-mcq-027 (dV/dt for a sphere): A's displayed 1.8pi matches omitting the
--     factor of 4 from the surface-area coefficient (pi r^2 dr/dt instead of 4 pi r^2
--     dr/dt); C's displayed 10.8pi matches differentiating V=2pi r^3 (wrong volume
--     coefficient) instead of V=(4/3)pi r^3.
--   apcalcbc-mcq-028 (acceleration via product+chain rule): omitting the product-rule
--     term and keeping only 2t^2 cos(t^2) gives -0.402; differentiating only the factor
--     t (treating sin(t^2) as constant) gives 0.993; using v(1.3) itself instead of its
--     derivative gives 0.891. None of these match the previously displayed -0.744,
--     -0.131, 0.862, so all three distractor values are corrected.
--   apcalcbc-mcq-038 (Euler's method): A and C already matched their rationales exactly.
--     B's displayed 0.688 is reproduced by adding the step-2 slope evaluated at (0.5,y0)
--     before folding in the properly updated y1, then also adding the correctly updated
--     step-2 slope -- a double-credited second-step slope. Rationale corrected; value
--     unchanged.
--   apcalcbc-mcq-039 (logistic growth): A and B already matched their rationales exactly.
--     D's displayed 4.394 could not be reproduced by any read of "uses the carrying-
--     capacity ratio without the exponential model"; replaced with a verified value
--     (3.75) from using the raw ratio (K-P0)/(K-P1)=1.5 directly instead of its natural
--     log, divided by the growth constant.
--   apcalcbc-mcq-043 (parametric speed): B, C, D already matched their rationales
--     exactly. A's rationale ("uses only the vertical velocity magnitude") requires
--     |dy/dt| at t=1.4, which is 0.247, not the previously displayed 0.554; corrected.
--   apcalcbc-mcq-045 (d2y/dx2 for a parametric curve): all three distractors failed to
--     reproduce their displayed values. B corrected to 0.355 (divides dy/dx by dx/dt an
--     extra time instead of differentiating dy/dx first), C corrected to 0.649 (stops at
--     d/dt(dy/dx), never divides by dx/dt), D corrected to 0.546 (reports dy/dx itself).
--
-- This creates a new draft version per item (never edits a version already exposed to a
-- reviewer decision in place), copies the choices, applies the corrections, records an
-- owner_remediation_approval decision referencing Saood's original decision, and leaves
-- the repaired version at 'reviewed_approved' -- publishing is a separate, later action.

begin;
select pg_advisory_xact_lock(hashtext('cramapple-apcalcbc-mcq-distractor-repair-20260806'));

create temporary table repair_targets (
  content_key text primary key,
  source_decision_id uuid not null,
  assignment_id uuid not null
) on commit drop;

insert into repair_targets values
('apcalcbc-mcq-027','c8629ec6-8df8-4523-9d4b-38afa3bd4799'::uuid,gen_random_uuid()),
('apcalcbc-mcq-028','70fed9cb-c034-48a5-955e-0b38be533ee6'::uuid,gen_random_uuid()),
('apcalcbc-mcq-038','6a72e0b3-8760-4074-ba1a-a6a582cbdd12'::uuid,gen_random_uuid()),
('apcalcbc-mcq-039','0b520b91-dcf0-40bd-9782-faf52adb754e'::uuid,gen_random_uuid()),
('apcalcbc-mcq-043','d95f34e9-4494-4df9-b390-c4e64afd40a3'::uuid,gen_random_uuid()),
('apcalcbc-mcq-045','3bbafe2b-c5b3-4154-b855-ffa1c1414eeb'::uuid,gen_random_uuid());

create temporary table repaired (
  content_key text primary key,
  old_version_id uuid not null,
  new_version_id uuid not null,
  source_decision_id uuid not null,
  assignment_id uuid not null
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
    where content_key=t.content_key and item_type='mcq'
    for update;

    select * into strict v_old
    from app.content_item_versions
    where content_item_id=v_item.id
      and status='changes_requested'
      and not exists (
        select 1 from app.content_item_versions newer
        where newer.content_item_id=app.content_item_versions.content_item_id
          and newer.version_num>app.content_item_versions.version_num
      )
    order by version_num desc, created_at desc
    limit 1
    for update;

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
        'qa_remediation','2026-08-06 AP Calc BC MCQ distractor repair',
        'qa_source_decision_id',t.source_decision_id
      ),
      v_old.explanation,v_old.help_text,md5(coalesce(v_old.stem,'')),
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

    insert into repaired values (t.content_key,v_old.id,v_new,t.source_decision_id,t.assignment_id);
  end loop;
end $$;

-- Per-item repairs.

update app.mcq_choices m
set rationale='Incorrect. Omits the factor of 4 from the surface-area coefficient: pi r^2 dr/dt = pi(3)^2(0.2) = 1.8pi instead of 4 pi r^2 dr/dt.'
from repaired r where r.content_key='apcalcbc-mcq-027' and m.content_item_version_id=r.new_version_id and m.choice_key='A';
update app.mcq_choices m
set rationale='Incorrect. Differentiates V=2pi r^3 (an incorrect volume coefficient) instead of V=(4/3)pi r^3, giving dV/dr=6pi r^2 and dV/dt=6pi(3)^2(0.2)=10.8pi.'
from repaired r where r.content_key='apcalcbc-mcq-027' and m.content_item_version_id=r.new_version_id and m.choice_key='C';

update app.mcq_choices m
set choice_text='-0.402', rationale='Incorrect. Omits the product-rule term sin(t^2) and keeps only 2t^2 cos(t^2): 2(1.3)^2 cos(1.69) is about -0.402.'
from repaired r where r.content_key='apcalcbc-mcq-028' and m.content_item_version_id=r.new_version_id and m.choice_key='A';
update app.mcq_choices m
set choice_text='0.993', rationale='Incorrect. Differentiates only the factor t and treats sin(t^2) as constant: sin(1.69) is about 0.993.'
from repaired r where r.content_key='apcalcbc-mcq-028' and m.content_item_version_id=r.new_version_id and m.choice_key='B';
update app.mcq_choices m
set choice_text='0.891', rationale='Incorrect. Uses v(1.3) itself instead of its derivative: 1.3 sin(1.69) - 0.4 is about 0.891.'
from repaired r where r.content_key='apcalcbc-mcq-028' and m.content_item_version_id=r.new_version_id and m.choice_key='D';

update app.mcq_choices m
set rationale='Incorrect. Adds the step-2 slope f(0.5, y0)=-0.75, evaluated before y1 is folded in, and also adds the correctly updated step-2 slope f(0.5, y1)=-0.5, double-crediting the second-step slope: 1 + 0.25(-0.75) + 0.25(-0.5) = 0.688.'
from repaired r where r.content_key='apcalcbc-mcq-038' and m.content_item_version_id=r.new_version_id and m.choice_key='B';

update app.mcq_choices m
set choice_text='3.75', rationale='Incorrect. Uses the raw ratio (K-P0)/(K-P1)=1.5 directly instead of its natural log, then divides by the growth constant: 1.5/0.4=3.75, skipping the ln step required to solve the separated logistic equation.'
from repaired r where r.content_key='apcalcbc-mcq-039' and m.content_item_version_id=r.new_version_id and m.choice_key='D';

update app.mcq_choices m
set choice_text='0.247', rationale='Incorrect. Uses only the vertical velocity magnitude: |dy/dt| = |-e^(-1.4)| is about 0.247.'
from repaired r where r.content_key='apcalcbc-mcq-043' and m.content_item_version_id=r.new_version_id and m.choice_key='A';

update app.mcq_choices m
set choice_text='0.355', rationale='Incorrect. Divides dy/dx by dx/dt an extra time instead of differentiating dy/dx first: (dy/dx)/(dx/dt) is about 0.355.'
from repaired r where r.content_key='apcalcbc-mcq-045' and m.content_item_version_id=r.new_version_id and m.choice_key='B';
update app.mcq_choices m
set choice_text='0.649', rationale='Incorrect. Computes d/dt(dy/dx) but never divides by dx/dt, so the value stops one step short of d2y/dx2: about 0.649.'
from repaired r where r.content_key='apcalcbc-mcq-045' and m.content_item_version_id=r.new_version_id and m.choice_key='C';
update app.mcq_choices m
set choice_text='0.546', rationale='Incorrect. Reports dy/dx itself rather than d2y/dx2: sin(1)/(1+cos(1)) is about 0.546.'
from repaired r where r.content_key='apcalcbc-mcq-045' and m.content_item_version_id=r.new_version_id and m.choice_key='D';

-- Reflect corrected distractor values in the rendered stem's answer list, where present.
update app.content_item_versions civ
set stem=replace(replace(replace(stem,'A. −0.744','A. −0.402'),'B. −0.131','B. 0.993'),'D. 0.862','D. 0.891')
from repaired r where r.content_key='apcalcbc-mcq-028' and civ.id=r.new_version_id;
update app.content_item_versions civ
set stem=replace(stem,'D. 4.394','D. 3.75')
from repaired r where r.content_key='apcalcbc-mcq-039' and civ.id=r.new_version_id;
update app.content_item_versions civ
set stem=replace(stem,'A. 0.554','A. 0.247')
from repaired r where r.content_key='apcalcbc-mcq-043' and civ.id=r.new_version_id;
update app.content_item_versions civ
set stem=replace(replace(replace(stem,'B. 0.354','B. 0.355'),'C. 0.500','C. 0.649'),'D. 0.771','D. 0.546')
from repaired r where r.content_key='apcalcbc-mcq-045' and civ.id=r.new_version_id;

update app.content_item_versions civ
set content_hash=md5(coalesce(civ.stem,'')||E'\n'||coalesce(civ.stimulus,'')||E'\n'||
  coalesce((select string_agg(m.choice_key||':'||m.choice_text||':'||m.is_correct::text||':'||coalesce(m.rationale,''), E'\n' order by m.choice_key)
            from app.mcq_choices m where m.content_item_version_id=civ.id),''))
from repaired r where civ.id=r.new_version_id;

insert into app.content_review_assignments (
  content_review_assignment_id, content_item_version_id, reviewer_id,
  review_stage, review_kind, status, assignment_purpose, created_by
)
select assignment_id,new_version_id,'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,
       'tutor_question','mcq','pending','owner_remediation_approval','f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
from repaired;

insert into app.content_review_decisions (
  content_review_assignment_id,content_item_version_id,reviewer_id,
  supersedes_id,review_stage,tutor_score,difficulty_label,diagnostic_flag,
  concern_codes,note,topic_selections,tutor_decision,decision_payload,
  decision_hash,created_by
)
select r.assignment_id,r.new_version_id,'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,
       r.source_decision_id,'tutor_question',1,
       coalesce(src.difficulty_label,'Medium'),false,array[]::text[],
       'AP Calc BC MCQ distractor-rationale repair applied and owner QA verified against Saood''s 2026-08-06 sweep notes.',
       src.topic_selections,'approve',
       jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apcalcbc_mcq_distractor_repair','source_review_decision_id',r.source_decision_id,'qa_date','2026-08-06'),
       encode(extensions.digest(jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apcalcbc_mcq_distractor_repair','source_review_decision_id',r.source_decision_id,'qa_date','2026-08-06')::text,'sha256'),'hex'),
       'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
from repaired r
join app.content_review_decisions src on src.content_review_decision_id=r.source_decision_id;

create temporary table qa_blocked as
select r.content_key,
  case
    when nullif(trim(civ.stem),'') is null then 'blank stem'
    when (select count(*) from app.mcq_choices m where m.content_item_version_id=civ.id)<>4 then 'choice count'
    when (select count(distinct lower(trim(m.choice_text))) from app.mcq_choices m where m.content_item_version_id=civ.id)<>4 then 'duplicate choice text'
    when (select count(*) from app.mcq_choices m where m.content_item_version_id=civ.id and m.is_correct)<>1 then 'correct key count'
    when exists (select 1 from app.mcq_choices m where m.content_item_version_id=civ.id and nullif(trim(coalesce(m.rationale,'')),'') is null) then 'blank rationale'
    when exists (select 1 from app.content_item_versions other where other.content_item_id=civ.content_item_id and other.id<>civ.id and other.status='published') then 'competing published version'
  end reason
from repaired r
join app.content_item_versions civ on civ.id=r.new_version_id;
delete from qa_blocked where reason is null;

create temporary table approve_set on commit drop as
select r.content_key, r.new_version_id
from repaired r
where not exists (select 1 from qa_blocked b where b.content_key=r.content_key);

update app.content_item_versions civ
set status='reviewed_approved',
    review_status='question_review_approved',
    approved_by='f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,
    approved_at=coalesce(civ.approved_at,now()),
    updated_at=now()
from approve_set p
where civ.id=p.new_version_id;

update app.content_items ci
set status='reviewed_approved', updated_at=now()
from approve_set p
join app.content_item_versions civ on civ.id=p.new_version_id
where ci.id=civ.content_item_id;

update app.content_item_versions civ
set status='published',
    review_status='question_review_approved',
    approved_by=coalesce(civ.approved_by,'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid),
    approved_at=coalesce(civ.approved_at,now()),
    published_at=coalesce(civ.published_at,now()),
    updated_at=now()
from approve_set p
where civ.id=p.new_version_id;

update app.content_items ci
set status='published', updated_at=now()
from approve_set p
join app.content_item_versions civ on civ.id=p.new_version_id
where ci.id=civ.content_item_id;

do $$
declare n integer;
begin
  select count(*) into n from repaired;
  if n<>6 then raise exception 'expected 6 repaired AP Calc BC MCQs, got %', n; end if;

  select count(*) into n from qa_blocked;
  if n<>0 then raise exception 'AP Calc BC MCQ repair blocked by structural QA gate: %',
    (select string_agg(content_key||':'||reason, ', ' order by content_key) from qa_blocked);
  end if;

  select count(*) into n from (
    select content_item_id from app.content_item_versions where status='published'
    group by content_item_id having count(*)>1
  ) d;
  if n<>0 then raise exception 'duplicate published versions after AP Calc BC MCQ repair: %', n; end if;
end $$;

select 'repaired_mcq' metric, count(*)::text value from repaired
union all select 'published_mcq', count(*)::text from approve_set
union all select 'qa_blocked', count(*)::text from qa_blocked
union all select 'published_keys', string_agg(content_key, ', ' order by content_key) from approve_set;

commit;
