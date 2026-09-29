-- Removes the two-namespace string-matching trap between the content registry
-- and the taxonomy.
--
-- app.subjects.subject_key uses hyphens ('ap-statistics');
-- app.taxonomy_source_versions.subject_key uses underscores ('ap_statistics').
-- Nothing links them but convention, so every join is hand-rolled -- and the
-- obvious hand-rolled transform is WRONG. replace(subject_key,'_','-') maps
-- nine of ten subjects and silently fails on the tenth, because Biology's
-- registry key is 'biology', not 'ap-biology'. A failed match here does not
-- raise; it returns zero rows, which the serving path reports as "this subject
-- has no content" (see the silent-absence failure mode).
--
-- app.normalize_student_subject_key() already handles the mapping correctly in
-- the registry -> taxonomy direction, including Biology. This migration makes
-- that correctness structural instead of advisory: a real FK, so the link is
-- resolved by id and can never be got wrong by a string expression again.
--
-- Additive and non-destructive. Both subject_key columns are kept exactly as
-- they are; nothing is renamed, so no existing query changes behaviour.

begin;

alter table app.taxonomy_source_versions
  add column if not exists subject_id uuid references app.subjects(id);

-- Backfill through the sanctioned normalizer rather than a string expression,
-- so Biology maps with everything else.
update app.taxonomy_source_versions v
set subject_id = s.id
from app.subjects s
where v.subject_id is null
  and s.subject_key = app.normalize_student_subject_key(v.subject_key);

-- Refuse to finish if any version failed to map. Silence is the failure mode
-- this migration exists to remove, so it must not introduce one of its own.
do $$
declare unmapped int;
begin
  select count(*) into unmapped
  from app.taxonomy_source_versions where subject_id is null;
  if unmapped > 0 then
    raise exception
      'taxonomy_source_versions: % row(s) did not map to app.subjects; fix app.normalize_student_subject_key before applying',
      unmapped;
  end if;
end $$;

alter table app.taxonomy_source_versions
  alter column subject_id set not null;

comment on column app.taxonomy_source_versions.subject_id is
  'FK to app.subjects. THE link between the hyphenated registry namespace and '
  'the underscored taxonomy namespace. Join on this, never on a string '
  'transform of subject_key: replace(_,-) silently fails for Biology '
  '(registry key "biology", taxonomy key "ap_biology").';

commit;
