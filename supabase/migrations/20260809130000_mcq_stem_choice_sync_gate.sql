-- MCQ stem/mcq_choices text-sync gate.
--
-- Root cause (docs/research/QA_PROTOCOL_SECTION9_POOL1_POOL2_RUN_2026_08_09.md
-- §5-§7): MCQ stems sometimes embed a duplicate lettered A/B/C/D option list
-- (an architectural leftover -- the app should render options from
-- app.mcq_choices only). Hand-written repair scripts in
-- scripts/content-seed/reviewer-qa-remediation/ update app.mcq_choices.choice_text
-- for a flagged distractor but don't always also update the matching embedded
-- text in the stem (e.g. 20260805_apchem_mcq_awe_repair.sql's apchem-mcq-042
-- block updates choice D's text with no corresponding `stem=replace(...)`
-- line). There is no single buggy function to patch -- these are ad hoc SQL
-- scripts, and the omission is inconsistent script-to-script and item-to-item.
-- A mechanical scan (2026-08-09) found 25 published MCQs with this desync,
-- concentrated in AP Chemistry (18/68), and -- the load-bearing fact --
-- 100% of them are version_num >= 2: this defect is introduced by the repair
-- process, not original authoring. In every confirmed case the underlying
-- `is_correct` answer key was unaffected; this is a presentation/grading-text
-- consistency defect, not a wrong-key defect, but it still means a student
-- reads one option's wording and is graded against another.
--
-- This migration adds a standing DB-level gate so the defect class can't
-- reach `status='published'` again, regardless of which code path (app,
-- future repair script, or manual SQL) creates the version -- the same
-- "defense in depth" rationale as the P0-B publish gate
-- (20260808200000_publish_gate_review_status.sql). It does not retroactively
-- touch the 25 already-published rows found by the scan; those are a
-- separate, tracked remediation batch (see the QA report's §7 follow-ups).

create or replace function app.mcq_stem_choice_desync(p_version_id uuid, p_stem text)
returns text[]
language plpgsql
stable
as $$
declare
  v_matches text[];
  v_letter text;
  v_embedded text;
  v_stored text;
  v_mismatches text[] := array[]::text[];
begin
  if p_stem is null then
    return v_mismatches;
  end if;

  for v_matches in
    select regexp_matches(p_stem, '(?m)^\s*([A-D])[\.\)]\s*(.+?)\s*$', 'g')
  loop
    v_letter := v_matches[1];
    v_embedded := btrim(v_matches[2]);

    select btrim(mc.choice_text) into v_stored
    from app.mcq_choices mc
    where mc.content_item_version_id = p_version_id
      and mc.choice_key = v_letter;

    if v_stored is not null and v_stored <> v_embedded then
      v_mismatches := v_mismatches || (v_letter || ': stem says "' || v_embedded || '", mcq_choices says "' || v_stored || '"');
    end if;
  end loop;

  return v_mismatches;
end;
$$;

create or replace function app.enforce_mcq_stem_choice_sync()
returns trigger
language plpgsql
as $$
declare
  v_item_type text;
  v_mismatches text[];
begin
  if new.status <> 'published' then
    return new;
  end if;

  select ci.item_type into v_item_type
  from app.content_items ci
  where ci.id = new.content_item_id;

  if v_item_type <> 'mcq' then
    return new;
  end if;

  v_mismatches := app.mcq_stem_choice_desync(new.id, new.stem);

  if array_length(v_mismatches, 1) > 0 then
    raise exception
      'mcq_stem_choice_sync: stem embeds option text that does not match app.mcq_choices for version %: %',
      new.id, array_to_string(v_mismatches, '; ')
      using errcode = 'P0001';
  end if;

  return new;
end;
$$;

drop trigger if exists content_item_versions_mcq_stem_choice_sync on app.content_item_versions;

create trigger content_item_versions_mcq_stem_choice_sync
  before insert or update of status, stem on app.content_item_versions
  for each row
  execute function app.enforce_mcq_stem_choice_sync();
