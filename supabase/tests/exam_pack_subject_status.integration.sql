-- Published exam-pack versions require active subjects.
-- Rollback-only integration coverage.

begin;

do $$
declare
  v_subject_id uuid;
  v_exam_pack_id uuid;
  v_error text;
begin
  if exists (
    select 1
    from app.subjects
    where status <> 'active'
  ) then
    raise exception 'expected all subjects to be active/student-visible';
  end if;

  if exists (
    select 1
    from app.exam_pack_versions epv
    join app.exam_packs ep on ep.id = epv.exam_pack_id
    join app.subjects s on s.id = ep.subject_id
    where epv.status = 'published'
      and s.status <> 'active'
  ) then
    raise exception 'published exam_pack_versions are linked to inactive subjects';
  end if;

  insert into app.subjects (subject_key, display_name, status)
  values ('status_guard_subject', 'Status Guard Subject', 'retired')
  returning id into v_subject_id;

  insert into app.exam_packs (exam_code, exam_name, subject_id)
  values ('status_guard_exam', 'Status Guard Exam', v_subject_id)
  returning id into v_exam_pack_id;

  begin
    insert into app.exam_pack_versions (
      exam_pack_id,
      school_year,
      official_exam_date,
      status
    )
    values (
      v_exam_pack_id,
      '2099-2100',
      '2100-05-01'::date,
      'published'
    );
  exception
    when others then
      v_error := sqlerrm;
  end;

  if v_error is distinct from 'exam_pack_version:published_requires_active_subject' then
    raise exception 'expected inactive-subject publish guard, got %',
      coalesce(v_error, '<no error>');
  end if;

  update app.subjects
  set status = 'active'
  where id = v_subject_id;

  insert into app.exam_pack_versions (
    exam_pack_id,
    school_year,
    official_exam_date,
    status
  )
  values (
    v_exam_pack_id,
    '2099-2100',
    '2100-05-01'::date,
    'published'
  );

  v_error := null;

  begin
    update app.subjects
    set status = 'retired'
    where id = v_subject_id;
  exception
    when others then
      v_error := sqlerrm;
  end;

  if v_error is distinct from 'subject:active_required_by_published_exam_pack_version' then
    raise exception 'expected active-subject retire guard, got %',
      coalesce(v_error, '<no error>');
  end if;
end;
$$;

rollback;
