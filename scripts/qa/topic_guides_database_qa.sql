-- Topic guide database QA
--
-- Purpose:
--   Verify the Production/Development Supabase database changes for the
--   Topic Point Briefs and Topic Explainers surfaces used by Lovable.
--
-- Safe to run:
--   Read-only. Transaction + temporary tables + SET LOCAL ROLE + ROLLBACK.
--
-- Example:
--   supabase db query --linked \
--     --file scripts/qa/topic_guides_database_qa.sql \
--     --workdir /Users/davidbloom/Documents/Cramapple
--
-- Maintenance:
--   Per-subject/per-unit expectations live in a single temp table
--   `topic_guides_qa_expectations` below. When a topic-guide batch changes
--   published counts, update ONLY that table -- every derived assertion
--   follows.
--
-- Coverage of the C1-C11 acceptance criteria from
-- docs/product/TOPIC_BRIEFS_AND_LEARN_MORE_PRODUCTION_PROTOCOL.md:
--   C1 pairing orphans           - hard assertion
--   C2 unit_number equality      - hard assertion
--   C3 taxonomy orphans          - hard assertion
--   C4 practice_* fields         - hard assertion
--   C5 learn_more_path format    - hard assertion
--   C6 active app.subjects row   - hard assertion
--   C7 core_idea distinct from   - WARNING (grandfathered as of 2026-08-21;
--      the paired brief             promote to hard once the debt is cleared)
--   C8 no shared distinctness    - WARNING for grandfathered rows, hard for
--      values                       new (non-grandfathered) rows
--   C9 length budgets            - WARNING with counts
--   C10 authenticated view       - hard assertion
--       counts match app tables
--   C11 anon locked out          - hard assertion

begin;

create temporary table topic_guides_qa_profile (
  user_id uuid primary key
) on commit drop;

insert into topic_guides_qa_profile (user_id)
select p.user_id from app.profiles p order by p.created_at limit 1;

grant select on topic_guides_qa_profile to authenticated;

-- ---------------------------------------------------------------------------
-- Expectations manifest -- the single source of truth for count assertions.
-- Baseline captured against Production 2026-08-21 (365 briefs / 365
-- explainers, 10 subjects). Update this table when a batch changes counts.
-- ---------------------------------------------------------------------------

create temporary table topic_guides_qa_expectations (
  subject_key            text    not null,
  registry_subject_key   text    not null,
  unit_number            integer not null,
  expected_briefs        integer not null,
  expected_explainers    integer not null,
  primary key (subject_key, unit_number)
) on commit drop;

insert into topic_guides_qa_expectations values
  ('ap_biology',              'biology',        1,  7,  7),
  ('ap_biology',              'biology',        2, 10, 10),
  ('ap_biology',              'biology',        3,  5,  5),
  ('ap_biology',              'biology',        4,  6,  6),
  ('ap_biology',              'biology',        5,  5,  5),
  ('ap_biology',              'biology',        6,  8,  8),
  ('ap_biology',              'biology',        7, 12, 12),
  ('ap_biology',              'biology',        8,  7,  7),
  ('ap_calculus_ab',          'ap-calculus-ab', 1, 16, 16),
  ('ap_calculus_ab',          'ap-calculus-ab', 2, 10, 10),
  ('ap_calculus_ab',          'ap-calculus-ab', 3,  6,  6),
  ('ap_calculus_ab',          'ap-calculus-ab', 4,  7,  7),
  ('ap_calculus_ab',          'ap-calculus-ab', 5, 12, 12),
  ('ap_calculus_ab',          'ap-calculus-ab', 6, 11, 11),
  ('ap_calculus_ab',          'ap-calculus-ab', 7,  7,  7),
  ('ap_calculus_ab',          'ap-calculus-ab', 8, 12, 12),
  ('ap_calculus_bc',          'ap-calculus-bc', 1, 16, 16),
  ('ap_calculus_bc',          'ap-calculus-bc', 2, 10, 10),
  ('ap_calculus_bc',          'ap-calculus-bc', 3,  6,  6),
  ('ap_calculus_bc',          'ap-calculus-bc', 4,  7,  7),
  ('ap_calculus_bc',          'ap-calculus-bc', 5, 12, 12),
  ('ap_calculus_bc',          'ap-calculus-bc', 6, 12, 12),
  ('ap_calculus_bc',          'ap-calculus-bc', 7,  9,  9),
  ('ap_calculus_bc',          'ap-calculus-bc', 8, 13, 13),
  ('ap_chemistry',            'ap-chemistry',   1,  8,  8),
  ('ap_chemistry',            'ap-chemistry',   2,  7,  7),
  ('ap_chemistry',            'ap-chemistry',   3, 11, 11),
  ('ap_physics_1',            'ap-physics-1',   1,  5,  5),
  ('ap_physics_1',            'ap-physics-1',   3,  5,  5),
  ('ap_physics_2',            'ap-physics-2',   9,  6,  6),
  ('ap_physics_2',            'ap-physics-2',  11,  8,  8),
  ('ap_physics_c_em',         'ap-physics-c-em',        8,  6,  6),
  ('ap_physics_c_em',         'ap-physics-c-em',       10,  4,  4),
  ('ap_physics_c_mechanics',  'ap-physics-c-mechanics', 1,  5,  5),
  ('ap_physics_c_mechanics',  'ap-physics-c-mechanics', 3,  5,  5),
  ('ap_precalculus',          'ap-precalculus', 1, 14, 14),
  ('ap_precalculus',          'ap-precalculus', 3, 15, 15),
  ('ap_statistics',           'ap-statistics',  1, 13, 13),
  ('ap_statistics',           'ap-statistics',  2, 12, 12),
  ('ap_statistics',           'ap-statistics',  3, 15, 15);

grant select on topic_guides_qa_expectations to authenticated;

-- ---------------------------------------------------------------------------
-- Structural checks (run as service_role for the connection default).
-- ---------------------------------------------------------------------------

do $$
declare
  v_expected_brief_total     integer;
  v_expected_explainer_total integer;
  v_app_briefs               integer;
  v_app_explainers           integer;
  v_pub_briefs               integer;
  v_pub_explainers           integer;
  v_missing_columns          text[];
  v_bad                      integer;
  v_error                    text;
  r                          record;
begin
  raise notice 'QA 1: required relations exist';

  if to_regclass('app.topic_point_briefs') is null then
    raise exception 'missing app.topic_point_briefs';
  end if;
  if to_regclass('app.topic_explainers') is null then
    raise exception 'missing app.topic_explainers';
  end if;
  if to_regclass('public.topic_point_briefs') is null then
    raise exception 'missing public.topic_point_briefs';
  end if;
  if to_regclass('public.topic_explainers') is null then
    raise exception 'missing public.topic_explainers';
  end if;
  if not exists (select 1 from topic_guides_qa_profile) then
    raise exception 'QA requires at least one app.profiles row';
  end if;

  select sum(expected_briefs), sum(expected_explainers)
  into v_expected_brief_total, v_expected_explainer_total
  from topic_guides_qa_expectations;

  raise notice 'QA 2: published counts match the expectations manifest (% briefs, % explainers)',
    v_expected_brief_total, v_expected_explainer_total;

  select count(*) into v_app_briefs from app.topic_point_briefs where status='published';
  select count(*) into v_app_explainers from app.topic_explainers where status='published';
  select count(*) into v_pub_briefs from public.topic_point_briefs;
  select count(*) into v_pub_explainers from public.topic_explainers;

  if v_app_briefs <> v_expected_brief_total or v_pub_briefs <> v_expected_brief_total then
    raise exception 'expected % published briefs, got app=% public=%',
      v_expected_brief_total, v_app_briefs, v_pub_briefs;
  end if;
  if v_app_explainers <> v_expected_explainer_total or v_pub_explainers <> v_expected_explainer_total then
    raise exception 'expected % published explainers, got app=% public=%',
      v_expected_explainer_total, v_app_explainers, v_pub_explainers;
  end if;

  raise notice 'QA 3: per-(subject, unit) counts match the manifest';

  for r in
    select e.subject_key, e.unit_number, e.expected_briefs, e.expected_explainers,
      (select count(*) from app.topic_point_briefs b
         where b.status='published' and b.subject_key=e.subject_key and b.unit_number=e.unit_number) as got_briefs,
      (select count(*) from app.topic_explainers x
         where x.status='published' and x.subject_key=e.subject_key and x.unit_number=e.unit_number) as got_explainers
    from topic_guides_qa_expectations e
  loop
    if r.got_briefs <> r.expected_briefs then
      raise exception 'expected % briefs for %/unit %, got %',
        r.expected_briefs, r.subject_key, r.unit_number, r.got_briefs;
    end if;
    if r.got_explainers <> r.expected_explainers then
      raise exception 'expected % explainers for %/unit %, got %',
        r.expected_explainers, r.subject_key, r.unit_number, r.got_explainers;
    end if;
  end loop;

  -- Any published row in a (subject, unit) that isn't in the manifest is a
  -- silent drift the old script would miss. Fail it here.
  if exists (
    select 1
    from (
      select subject_key, unit_number from app.topic_point_briefs where status='published'
      union
      select subject_key, unit_number from app.topic_explainers where status='published'
    ) live
    where not exists (
      select 1 from topic_guides_qa_expectations e
      where e.subject_key=live.subject_key and e.unit_number=live.unit_number
    )
  ) then
    raise exception 'published rows exist for a (subject, unit) missing from topic_guides_qa_expectations';
  end if;

  -- C1 pairing orphans, both directions.
  raise notice 'QA 4 / C1: pairing orphans are zero in both directions';
  if exists (
    select 1 from app.topic_point_briefs b
    left join app.topic_explainers x
      on x.subject_key=b.subject_key and x.topic_code=b.topic_code and x.status='published'
    where b.status='published' and x.topic_explainer_id is null
  ) then
    raise exception 'C1: a published brief has no published explainer';
  end if;
  if exists (
    select 1 from app.topic_explainers x
    left join app.topic_point_briefs b
      on b.subject_key=x.subject_key and b.topic_code=x.topic_code and b.status='published'
    where x.status='published' and b.topic_point_brief_id is null
  ) then
    raise exception 'C1: a published explainer has no published brief';
  end if;

  -- C2 unit_number equality.
  raise notice 'QA 5 / C2: paired rows agree on unit_number';
  select count(*) into v_bad
  from app.topic_point_briefs b
  join app.topic_explainers x
    on x.subject_key=b.subject_key and x.topic_code=b.topic_code
  where b.status='published' and x.status='published' and b.unit_number <> x.unit_number;
  if v_bad <> 0 then
    raise exception 'C2: % pair(s) disagree on unit_number', v_bad;
  end if;

  -- C3 taxonomy orphans.
  raise notice 'QA 6 / C3: every published row is in the approved taxonomy';
  select count(*) into v_bad
  from app.topic_point_briefs b
  where b.status='published'
    and not exists (
      select 1
      from app.taxonomy_topics tt
      join (
        select distinct on (tsv.subject_key) tsv.taxonomy_source_version, tsv.subject_key
        from app.taxonomy_source_versions tsv
        where tsv.taxonomy_confidence='verified'
          and exists (select 1 from app.taxonomy_units tu where tu.taxonomy_source_version=tsv.taxonomy_source_version)
        order by tsv.subject_key, tsv.school_year desc, tsv.verified_at desc nulls last, tsv.created_at desc
      ) tax on tax.taxonomy_source_version=tt.taxonomy_source_version
      where tax.subject_key=b.subject_key
        and tt.topic_code=b.topic_code
        and tt.unit_number=b.unit_number
    );
  if v_bad <> 0 then
    raise exception 'C3: % published brief(s) are taxonomy orphans', v_bad;
  end if;

  -- C4 practice_* fields match the brief.
  raise notice 'QA 7 / C4: practice_* fields match the brief';
  select count(*) into v_bad
  from app.topic_point_briefs b
  where b.status='published'
    and (b.practice_subject_key <> b.subject_key
      or b.practice_unit_number <> b.unit_number
      or b.practice_topic_code  <> b.topic_code);
  if v_bad <> 0 then
    raise exception 'C4: % brief(s) have practice_* that does not match', v_bad;
  end if;

  -- C5 learn_more_path format.
  raise notice 'QA 8 / C5: learn_more_path uses the hyphenated subject and correct unit';
  select count(*) into v_bad
  from app.topic_point_briefs b
  where b.status='published'
    and b.learn_more_path not like
        '/learn/' || replace(b.subject_key,'_','-') || '/unit-' || b.unit_number || '/%';
  if v_bad <> 0 then
    raise exception 'C5: % brief(s) have a malformed learn_more_path', v_bad;
  end if;

  -- C6 active app.subjects row.
  raise notice 'QA 9 / C6: each affected subject has an active app.subjects row';
  select count(*) into v_bad
  from app.topic_point_briefs b
  where b.status='published'
    and not exists (
      select 1 from app.subjects s
      where app.normalize_student_subject_key(s.subject_key) = b.subject_key
        and s.status='active'
    );
  if v_bad <> 0 then
    raise exception 'C6: % brief(s) belong to a subject that is not active', v_bad;
  end if;

  raise notice 'QA 10: Lovable-facing public view column contract';
  select array_agg(expected_column order by expected_column)
  into v_missing_columns
  from (values
    ('id'),('subject_key'),('unit_number'),('unit_id'),('topic_id'),('title'),
    ('class_importance'),('exam_importance'),('what_it_is'),('why_it_matters'),
    ('how_points_are_earned'),('answer_move'),('common_point_loss'),
    ('learn_more_path'),('practice_subject_key'),('practice_unit_number'),
    ('practice_topic_code'),('practice_params'),('created_at'),('updated_at'),
    ('published_at'),('topic_sort_major'),('topic_sort_minor'),('topic_sort_key'),
    ('canonical_subject_key')
  ) as expected(expected_column)
  where not exists (
    select 1 from information_schema.columns c
    where c.table_schema='public' and c.table_name='topic_point_briefs'
      and c.column_name=expected.expected_column
  );
  if coalesce(array_length(v_missing_columns,1),0) > 0 then
    raise exception 'public.topic_point_briefs missing columns: %', v_missing_columns;
  end if;

  select array_agg(expected_column order by expected_column)
  into v_missing_columns
  from (values
    ('id'),('subject_key'),('unit_number'),('unit_id'),('topic_id'),('title'),
    ('core_idea'),('what_students_need_to_understand'),('how_this_becomes_points'),
    ('answer_move'),('mini_example_question'),('weak_answer'),
    ('point_attaining_answer'),('common_point_loss'),('practice_bridge'),
    ('mini_example'),('created_at'),('updated_at'),('published_at'),
    ('topic_sort_major'),('topic_sort_minor'),('topic_sort_key'),
    ('canonical_subject_key')
  ) as expected(expected_column)
  where not exists (
    select 1 from information_schema.columns c
    where c.table_schema='public' and c.table_name='topic_explainers'
      and c.column_name=expected.expected_column
  );
  if coalesce(array_length(v_missing_columns,1),0) > 0 then
    raise exception 'public.topic_explainers missing columns: %', v_missing_columns;
  end if;

  raise notice 'QA 11: representative row shape (AP Calculus AB 1.1)';
  if not exists (
    select 1 from public.topic_point_briefs
    where subject_key='ap-calculus-ab'
      and canonical_subject_key='ap_calculus_ab'
      and unit_number=1 and topic_id='1.1' and unit_id='unit-1'
      and topic_sort_major=1 and topic_sort_minor=1 and topic_sort_key=1001
      and class_importance in ('not-important','somewhat-important','very-important')
      and exam_importance  in ('not-important','somewhat-important','very-important')
      and learn_more_path='/learn/ap-calculus-ab/unit-1/instantaneous-change'
      and practice_params=jsonb_build_object('subject','ap_calculus_ab','unit','1','topic','1.1')
  ) then
    raise exception 'AP Calculus AB 1.1 public brief shape is wrong';
  end if;
  if not exists (
    select 1 from public.topic_explainers
    where subject_key='ap-calculus-ab'
      and canonical_subject_key='ap_calculus_ab'
      and unit_number=1 and topic_id='1.1' and unit_id='unit-1'
      and topic_sort_major=1 and topic_sort_minor=1 and topic_sort_key=1001
      and mini_example ? 'question'
      and mini_example ? 'weakAnswer'
      and mini_example ? 'pointAttainingAnswer'
  ) then
    raise exception 'AP Calculus AB 1.1 public explainer shape is wrong';
  end if;

  raise notice 'QA 12: public views expose only published rows';
  if exists (
    select 1 from app.topic_point_briefs b
    left join public.topic_point_briefs v on v.id=b.topic_point_brief_id
    where b.status='published' and v.id is null
  ) then
    raise exception 'a published app.topic_point_briefs row is missing from public.topic_point_briefs';
  end if;
  if exists (
    select 1 from public.topic_point_briefs v
    join app.topic_point_briefs b on b.topic_point_brief_id=v.id
    where b.status <> 'published'
  ) then
    raise exception 'public.topic_point_briefs exposed a non-published row';
  end if;
  if exists (
    select 1 from public.topic_explainers v
    join app.topic_explainers x on x.topic_explainer_id=v.id
    where x.status <> 'published'
  ) then
    raise exception 'public.topic_explainers exposed a non-published row';
  end if;

  raise notice 'QA 13 / C11: grants are read-only and authenticated-only';
  if has_table_privilege('anon','public.topic_point_briefs','SELECT')
     or has_table_privilege('anon','public.topic_explainers','SELECT') then
    raise exception 'C11: anon should not have SELECT on public topic guide views';
  end if;
  if not has_table_privilege('authenticated','public.topic_point_briefs','SELECT')
     or not has_table_privilege('authenticated','public.topic_explainers','SELECT') then
    raise exception 'authenticated should have SELECT on public topic guide views';
  end if;
  if has_table_privilege('authenticated','public.topic_point_briefs','INSERT')
     or has_table_privilege('authenticated','public.topic_point_briefs','UPDATE')
     or has_table_privilege('authenticated','public.topic_point_briefs','DELETE')
     or has_table_privilege('authenticated','public.topic_explainers','INSERT')
     or has_table_privilege('authenticated','public.topic_explainers','UPDATE')
     or has_table_privilege('authenticated','public.topic_explainers','DELETE') then
    raise exception 'authenticated should have SELECT-only access';
  end if;

  raise notice 'QA 14 / C11: RPCs enforce authentication';
  begin
    perform public.get_student_taxonomy('ap_calculus_ab');
  exception when sqlstate '28000' then v_error := 'not_authenticated';
  end;
  if v_error is distinct from 'not_authenticated' then
    raise exception 'C11: expected get_student_taxonomy to reject unauthenticated calls, got %', coalesce(v_error,'<no error>');
  end if;
  v_error := null;
  begin
    perform public.get_topic_point_guides('ap_calculus_ab', 1, null);
  exception when sqlstate '28000' then v_error := 'not_authenticated';
  end;
  if v_error is distinct from 'not_authenticated' then
    raise exception 'C11: expected get_topic_point_guides to reject unauthenticated calls, got %', coalesce(v_error,'<no error>');
  end if;
end;
$$;

-- ---------------------------------------------------------------------------
-- Warnings for grandfathered content debt (C7, C8, C9).
-- These block student value, not release safety; they are logged as counts so
-- the debt stays visible without failing every batch. Promote to hard
-- assertions when the grandfathered set is re-authored.
-- ---------------------------------------------------------------------------

do $$
declare
  v_c7                    integer;
  v_c8_grandfathered      integer;
  v_c8_new                integer;
  v_c9_briefs_over        integer;
  v_c9_explainers_over    integer;
begin
  raise notice 'QA 15 / C7: explainer.core_idea should not equal brief.what_it_is';
  select count(*) into v_c7
  from app.topic_point_briefs b
  join app.topic_explainers x
    on x.subject_key=b.subject_key and x.topic_code=b.topic_code
  where b.status='published' and x.status='published'
    and x.core_idea = b.what_it_is;
  raise notice 'C7 violations (grandfathered debt): %', v_c7;

  raise notice 'QA 16 / C8: no shared values across published explainers (excluding cross-subject duplications)';

  -- Grandfathered rows carry a source_note ending 'grandfathered-2026-08-21'.
  -- Cross-subject duplications carry 'Duplicated' or 'Moved' in source_note.
  -- Count sharing separately so the new-batch signal isn't polluted by the debt.

  with pe as (
    select topic_explainer_id, mini_example_question, weak_answer,
           point_attaining_answer, practice_bridge, source_note
    from app.topic_explainers where status='published'
  ), grandfathered as (
    select topic_explainer_id from pe where source_note like '%grandfathered-2026-08-21'
  ), new_rows as (
    select topic_explainer_id from pe
    where topic_explainer_id not in (select topic_explainer_id from grandfathered)
      and source_note not like '%Duplicated%'
      and source_note not like '%Moved%'
  ), shared_any as (
    select 'mini_example_question' as f, mini_example_question as v from pe group by 1,2 having count(*)>1
    union all select 'weak_answer', weak_answer from pe group by 1,2 having count(*)>1
    union all select 'point_attaining_answer', point_attaining_answer from pe group by 1,2 having count(*)>1
    union all select 'practice_bridge', practice_bridge from pe group by 1,2 having count(*)>1
  )
  select
    (select count(*) from pe
       join grandfathered g on g.topic_explainer_id=pe.topic_explainer_id
       where (pe.mini_example_question, 'mini_example_question') in (select v, f from shared_any)
          or (pe.weak_answer,           'weak_answer')           in (select v, f from shared_any)
          or (pe.point_attaining_answer,'point_attaining_answer')in (select v, f from shared_any)
          or (pe.practice_bridge,       'practice_bridge')       in (select v, f from shared_any)),
    (select count(*) from pe
       join new_rows n on n.topic_explainer_id=pe.topic_explainer_id
       where (pe.mini_example_question, 'mini_example_question') in (select v, f from shared_any)
          or (pe.weak_answer,           'weak_answer')           in (select v, f from shared_any)
          or (pe.point_attaining_answer,'point_attaining_answer')in (select v, f from shared_any)
          or (pe.practice_bridge,       'practice_bridge')       in (select v, f from shared_any))
  into v_c8_grandfathered, v_c8_new;

  raise notice 'C8 sharing rows -- grandfathered: %, new: %', v_c8_grandfathered, v_c8_new;
  if v_c8_new <> 0 then
    raise exception 'C8: % non-grandfathered published explainer(s) share a distinctness value', v_c8_new;
  end if;

  raise notice 'QA 17 / C9: content length budgets';
  select
    count(*) filter (where length(what_it_is)>260 or length(why_it_matters)>260
                     or length(answer_move)>320)
  into v_c9_briefs_over
  from app.topic_point_briefs where status='published';

  select
    count(*) filter (where length(core_idea)>360 or length(point_attaining_answer)>520)
  into v_c9_explainers_over
  from app.topic_explainers where status='published';

  raise notice 'C9 over-budget rows -- briefs: %, explainers: %',
    v_c9_briefs_over, v_c9_explainers_over;

  raise notice 'QA STRUCTURAL PASS';
end;
$$;

-- ---------------------------------------------------------------------------
-- Authenticated pass: what a real student session sees.
-- ---------------------------------------------------------------------------

select set_config(
  'request.jwt.claims',
  json_build_object(
    'sub', (select user_id from topic_guides_qa_profile limit 1),
    'role', 'authenticated'
  )::text,
  true
);
set local role authenticated;

do $$
declare
  v_expected_total integer;
  v_seen           integer;
  v_payload        jsonb;
  v_has_taxonomy   boolean;
  r                record;
begin
  raise notice 'QA 18: authenticated student sees the same counts (C10)';
  select sum(expected_briefs) into v_expected_total from topic_guides_qa_expectations;
  select count(*) into v_seen from public.topic_point_briefs;
  if v_seen <> v_expected_total then
    raise exception 'C10: authenticated brief count % <> expected %', v_seen, v_expected_total;
  end if;
  select sum(expected_explainers) into v_expected_total from topic_guides_qa_expectations;
  select count(*) into v_seen from public.topic_explainers;
  if v_seen <> v_expected_total then
    raise exception 'C10: authenticated explainer count % <> expected %', v_seen, v_expected_total;
  end if;

  for r in select * from topic_guides_qa_expectations loop
    select count(*) into v_seen from public.topic_point_briefs
     where subject_key=r.registry_subject_key
       and canonical_subject_key=r.subject_key
       and unit_number=r.unit_number;
    if v_seen <> r.expected_briefs then
      raise exception 'C10: authenticated sees % briefs for %/unit % (expected %)',
        v_seen, r.subject_key, r.unit_number, r.expected_briefs;
    end if;
    select count(*) into v_seen from public.topic_explainers
     where subject_key=r.registry_subject_key
       and canonical_subject_key=r.subject_key
       and unit_number=r.unit_number;
    if v_seen <> r.expected_explainers then
      raise exception 'C10: authenticated sees % explainers for %/unit % (expected %)',
        v_seen, r.subject_key, r.unit_number, r.expected_explainers;
    end if;
  end loop;

  raise notice 'QA 19: representative RPC payloads';

  v_has_taxonomy :=
    to_regclass('app.taxonomy_source_versions') is not null
    and to_regclass('app.taxonomy_units') is not null
    and to_regclass('app.taxonomy_topics') is not null;

  if v_has_taxonomy then
    v_payload := public.get_student_taxonomy('ap_calculus_ab');
    if jsonb_array_length(v_payload->'subjects') <> 1 then
      raise exception 'expected one AP Calculus AB taxonomy subject, got %', v_payload;
    end if;
    if jsonb_array_length(v_payload #> '{subjects,0,units,0,topics}') <> 16 then
      raise exception 'expected 16 AP Calculus AB Unit 1 topics, got %', v_payload #> '{subjects,0,units,0,topics}';
    end if;
    if coalesce((v_payload #>> '{subjects,0,units,0,topics,0,hasPointBrief}')::boolean, false) is not true then
      raise exception 'expected AP Calculus AB topic 1.1 to advertise hasPointBrief';
    end if;
    v_payload := public.get_student_taxonomy('ap-calculus-ab');
    if jsonb_array_length(v_payload->'subjects') <> 1 then
      raise exception 'expected hyphenated AP Calculus AB taxonomy key to normalize, got %', v_payload;
    end if;
  else
    raise notice 'QA 19: skipping taxonomy RPC checks (registry tables absent)';
  end if;

  -- Drive the RPC per expectations-manifest row so this stays in sync too.
  for r in select * from topic_guides_qa_expectations loop
    v_payload := public.get_topic_point_guides(r.subject_key, r.unit_number, null);
    if jsonb_array_length(v_payload->'briefs') <> r.expected_briefs then
      raise exception 'RPC returned % briefs for %/unit % (expected %)',
        jsonb_array_length(v_payload->'briefs'), r.subject_key, r.unit_number, r.expected_briefs;
    end if;
    if jsonb_array_length(v_payload->'explainers') <> r.expected_explainers then
      raise exception 'RPC returned % explainers for %/unit % (expected %)',
        jsonb_array_length(v_payload->'explainers'), r.subject_key, r.unit_number, r.expected_explainers;
    end if;
    -- Registry (hyphenated) key normalization.
    v_payload := public.get_topic_point_guides(r.registry_subject_key, r.unit_number, null);
    if jsonb_array_length(v_payload->'briefs') <> r.expected_briefs
       or jsonb_array_length(v_payload->'explainers') <> r.expected_explainers then
      raise exception 'RPC did not normalize hyphenated key % (unit %)',
        r.registry_subject_key, r.unit_number;
    end if;
  end loop;

  -- Single-topic call still returns one and only one paired row.
  v_payload := public.get_topic_point_guides('ap_biology', 1, '1.1');
  if jsonb_array_length(v_payload->'briefs') <> 1
     or jsonb_array_length(v_payload->'explainers') <> 1 then
    raise exception 'expected one brief and one explainer for AP Biology 1.1, got %', v_payload;
  end if;
  if not (v_payload #>> '{briefs,0,whatItIs}') like 'Water is a polar molecule%' then
    raise exception 'AP Biology 1.1 smoke string missing from RPC payload';
  end if;

  begin
    perform public.get_student_taxonomy('missing subject');
    raise exception 'invalid subject key unexpectedly succeeded';
  exception when sqlstate '22023' then null;
  end;

  raise notice 'QA PASS: topic guide database changes are working correctly';
end;
$$;

reset role;

rollback;
