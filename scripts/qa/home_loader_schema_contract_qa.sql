-- QA: /home loader schema contract
-- ---------------------------------------------------------------------------
-- Guards the two defects fixed on 2026-08-21 in the Lovable frontend's
-- src/lib/home.functions.ts, which had queried columns and a table that do not
-- exist. Neither query checked its error, so both degraded silently to empty
-- and every production student resolved to experienceStage "new".
--
-- This script asserts the database side of that contract. If someone renames
-- one of these, QA fails loudly here instead of the page going quietly blank.
--
-- Read-only. Run against Production and Development.

-- H1: columns the attempts query selects must all exist ---------------------
do $$
declare want text[] := array[
  'id','user_id','learning_session_id','content_item_version_id',
  'exam_pack_version_id','attempt_mode','assistance_state','status',
  'created_at','submitted_at','graded_at','score_points','score_possible'];
  missing text := '';
  c text;
begin
  foreach c in array want loop
    if not exists (select 1 from information_schema.columns
                    where table_schema='app' and table_name='attempts' and column_name=c) then
      missing := missing || c || ' ';
    end if;
  end loop;
  if missing <> '' then
    raise exception 'H1 FAIL: app.attempts is missing column(s): %', missing;
  end if;
  raise notice 'H1 PASS: every column the /home attempts query selects exists';
end $$;

-- H2: the columns the OLD broken query used must stay absent ----------------
-- If these ever reappear, the two names are ambiguous and the fix needs review.
do $$
declare n int;
begin
  select count(*) into n from information_schema.columns
   where table_schema='app' and table_name='attempts'
     and column_name in ('mcq_item_id','frq_package_id');
  if n > 0 then
    raise exception 'H2 FAIL: legacy column name(s) reintroduced on app.attempts';
  end if;
  raise notice 'H2 PASS: legacy mcq_item_id / frq_package_id remain absent';
end $$;

-- H3: course-position table name -------------------------------------------
-- The loader queried the singular form, which has never existed.
do $$
begin
  if to_regclass('app.student_course_positions') is null then
    raise exception 'H3 FAIL: app.student_course_positions (plural) does not exist';
  end if;
  if to_regclass('app.student_course_position') is not null then
    raise exception 'H3 FAIL: a singular student_course_position table now exists; the two names are ambiguous';
  end if;
  if not exists (select 1 from information_schema.columns
                  where table_schema='app' and table_name='student_course_positions'
                    and column_name in ('user_id','exam_pack_version_id','unit_id','source')) then
    raise exception 'H3 FAIL: student_course_positions is missing expected columns';
  end if;
  raise notice 'H3 PASS: student_course_positions (plural) present with expected columns';
end $$;

-- H4: profile column the loader resolves the active subject from ------------
do $$
begin
  if not exists (select 1 from information_schema.columns
                  where table_schema='app' and table_name='profiles'
                    and column_name='active_exam_pack_version_id') then
    raise exception 'H4 FAIL: app.profiles.active_exam_pack_version_id missing';
  end if;
  raise notice 'H4 PASS: profiles.active_exam_pack_version_id present';
end $$;

-- H5: enum domains the loader maps -----------------------------------------
-- attempt_mode gained 'quantitative' and assistance_state has 'exam_practice';
-- both are excluded from evidence and must stay visible to the mapping code.
do $$
declare modes text; assist text;
begin
  select pg_get_constraintdef(oid) into modes from pg_constraint
   where conrelid='app.attempts'::regclass and conname='attempts_mode_check';
  select pg_get_constraintdef(oid) into assist from pg_constraint
   where conrelid='app.attempts'::regclass and conname='attempts_assistance_check';
  if modes is null or assist is null then
    raise exception 'H5 FAIL: expected check constraints on app.attempts not found';
  end if;
  raise notice 'H5 PASS: attempt_mode := %', modes;
  raise notice 'H5 PASS: assistance_state := %', assist;
end $$;

-- H6: the standing reason /home still shows no evidence ---------------------
-- Not a failure. The loader is fixed, but nothing writes grading back onto
-- app.attempts, so evidence stays empty. This check makes that visible so it
-- is never mistaken for a regression in the fix.
do $$
declare total int; graded int; gr int;
begin
  select count(*) into total from app.attempts;
  select count(*) into graded from app.attempts where graded_at is not null;
  select count(*) into gr from app.grading_results;
  raise notice 'H6 INFO: attempts=%, attempts_with_graded_at=%, grading_results=%',
    total, graded, gr;
  if total > 0 and graded = 0 and gr > 0 then
    raise warning 'H6: grading write-back to app.attempts is still missing — /home will report zero evidence regardless of the loader fix';
  end if;
end $$;
