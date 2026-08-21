begin;

-- Open the student-home release gate to all 10 subjects.
--
-- BACKGROUND: app.home_release_manifest is an explicit allowlist. The
-- original seed (20260731170200) deliberately covered only the "taxonomy
-- validation range" -- AP Biology and AP Statistics -- and left
-- quick_start_enabled false pending "the explicit staff enablement gate and
-- live inventory/resolver checks". Biology was enabled at some point; the
-- other 8 subjects never received a manifest row at all, so they could never
-- surface in public.home_quick_start_subjects regardless of entitlements or
-- published content.
--
-- This migration performs that staff enablement for the remaining subjects.
-- Every one of them already carries 40-68 published MCQ items with choices,
-- comfortably above the 10-item minimum, so all become eligible immediately.
--
-- allowed_unit_numbers is DERIVED from the verified CED taxonomy rather than
-- hardcoded, because it bounds which unit a student may set as their course
-- position (public.set_course_position raises unit_not_in_active_subject
-- outside the range). Two subjects continue their prerequisite course's
-- numbering and would be unusable with a naive 1..N range:
--   AP Physics 2            -> units 9-15
--   AP Physics C: E&M       -> units 8-13
-- Deriving from taxonomy also keeps this correct if a CED unit map changes.
--
-- Namespaces differ between registries (app.subjects uses hyphens,
-- app.taxonomy_source_versions uses underscores), so the join goes through
-- app.normalize_student_subject_key.

insert into app.home_release_manifest (
  exam_pack_version_id,
  quick_start_enabled,
  minimum_published_items,
  allowed_unit_numbers,
  criterion_starter_enabled
)
select
  epv.id,
  true,
  10,
  units.ced_units,
  false
from app.exam_pack_versions epv
join app.exam_packs ep on ep.id = epv.exam_pack_id
join app.subjects s on s.id = ep.subject_id
join lateral (
  select array_agg(distinct tu.unit_number order by tu.unit_number) as ced_units
  from app.taxonomy_source_versions tsv
  join app.taxonomy_units tu
    on tu.taxonomy_source_version = tsv.taxonomy_source_version
  where tsv.taxonomy_confidence = 'verified'
    and tsv.subject_key = app.normalize_student_subject_key(s.subject_key)
) units on true
where epv.status = 'published'
  and epv.retired_at is null
  and s.status = 'active'
  and units.ced_units is not null
on conflict (exam_pack_version_id) do nothing;

-- AP Statistics was already on the allowlist but still had quick_start
-- disabled from the original conservative seed, which is why it appeared in
-- the subject list yet never became eligible. Complete its enablement.
update app.home_release_manifest m
set quick_start_enabled = true,
    updated_at = now()
from app.exam_pack_versions epv
join app.exam_packs ep on ep.id = epv.exam_pack_id
join app.subjects s on s.id = ep.subject_id
where m.exam_pack_version_id = epv.id
  and s.subject_key = 'ap-statistics'
  and m.quick_start_enabled is distinct from true;

-- Fail loudly if any active subject with a published pack is still gated,
-- so this does not silently half-apply.
do $$
declare
  v_missing integer;
begin
  select count(*)
    into v_missing
  from app.exam_pack_versions epv
  join app.exam_packs ep on ep.id = epv.exam_pack_id
  join app.subjects s on s.id = ep.subject_id
  left join app.home_release_manifest m on m.exam_pack_version_id = epv.id
  where epv.status = 'published'
    and epv.retired_at is null
    and s.status = 'active'
    and (m.exam_pack_version_id is null or m.quick_start_enabled is not true);

  if v_missing > 0 then
    raise exception
      'home release gate incomplete: % active published subject(s) still lack an enabled manifest row',
      v_missing;
  end if;
end;
$$;

commit;
