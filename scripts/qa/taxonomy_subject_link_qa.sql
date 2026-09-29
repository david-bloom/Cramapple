-- QA for 20260929190000_taxonomy_source_versions_subject_id.sql.
-- Read-only. Expected: every check returns PASS.

-- 1. Every taxonomy version resolves to a subject.
select case when count(*) = 0 then 'PASS' else 'FAIL: ' || count(*) || ' unmapped' end
         as every_version_maps
from app.taxonomy_source_versions where subject_id is null;

-- 2. The FK agrees with the sanctioned normalizer for every row.
select case when count(*) = 0 then 'PASS' else 'FAIL: ' || count(*) || ' disagree' end
         as fk_agrees_with_normalizer
from app.taxonomy_source_versions v
join app.subjects s on s.id = v.subject_id
where s.subject_key <> app.normalize_student_subject_key(v.subject_key);

-- 3. The naive transform is genuinely wrong, so this link is load-bearing
--    rather than decorative. Expected: exactly Biology.
select case when count(*) = 1 then 'PASS (only biology)'
            else 'REVIEW: ' || count(*) || ' subjects differ from naive transform' end
         as naive_transform_is_insufficient
from app.taxonomy_source_versions v
join app.subjects s on s.id = v.subject_id
where s.subject_key <> replace(v.subject_key, '_', '-');
