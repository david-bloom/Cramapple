begin;

insert into app.subjects (subject_key, display_name, status)
values ('ap-calculus-ab', 'AP Calculus AB', 'active')
on conflict (subject_key) do update
set
  display_name = excluded.display_name,
  status = 'active',
  updated_at = now();

commit;
