begin;

-- Keep the student-readable subject registry aligned with the published
-- topic-guide content. Development was missing active rows for the Physics 2
-- and Physics C subjects, which hid their otherwise-published topic briefs
-- and explainers from authenticated users through the topic-guide RLS policy.

insert into app.subjects (subject_key, display_name, status)
values
  ('ap-physics-2', 'AP Physics 2', 'active'),
  ('ap-physics-c-em', 'AP Physics C: Electricity and Magnetism', 'active'),
  ('ap-physics-c-mechanics', 'AP Physics C: Mechanics', 'active')
on conflict (subject_key) do update
set
  display_name = excluded.display_name,
  status = 'active',
  updated_at = now();

commit;
