-- Course Mode — same-cell confirm-transfer item selector (fail-closed, read-only).
--
-- Backs the explicit confirm-transfer flow (SESSION_ASSEMBLY spec §7.1 guess-floor):
-- after a student answers an MCQ, the server can serve ONE different, already-
-- published item tagged to the SAME content cell, so a correct follow-up confirms
-- transfer before the cell earns full `independent`. This selector is the server
-- side of that flow; it is deliberately additive and out-of-band from the ordinary
-- session-target queue (it selects nothing, and mutates nothing, in that queue).
--
-- Contract (mirrors public.select_practice_frqs so the delivery layer can reuse
-- buildRenderItem): given the source item version + its exam pack, return at most
-- ONE render-ready candidate row, or ZERO rows (fail-closed) when no valid parallel
-- item exists.
--
-- "Valid parallel item" =
--   * a DIFFERENT content item (not the source item, nor any of its versions),
--   * item_type = 'mcq',
--   * tagged to the SAME cell (taxonomy_source_version, topic_code, skill_code) as
--     the source item version,
--   * scoped to the same exam_pack_version,
--   * student-approved AND served: ci.status='published' AND civ.status='published'
--     (the exact gate the CM-D19 release stamps and select_practice_frqs enforces).
--
-- Fail-closed cases that return ZERO rows:
--   * the source item carries no cell tag,
--   * the source cell is a NUMERIC-answer cell excluded from confirm-transfer, or
--   * no other published/approved same-cell MCQ exists.
--
-- Numeric-cell exclusion (spec §7.1): confirm-transfer is a control on MCQ
-- *guessing*; it does not apply to compute-a-value cells. The two Unit-1
-- computational cells are excluded: summary_stats (1.7×3.B) and compare_stats
-- (1.9×3.B). 1.9×4.B (slotframe_4b_compare) is conceptual and is NOT excluded.
-- Enforced server-side here so the flow fails closed even if a client forgets it.
--
-- Answer safety: returns the same answer-free projection as select_practice_frqs.
-- prompt_json is carried for parity but is never forwarded to students by the
-- delivery layer (buildRenderItem strips it). is_correct / mcq_choices are never
-- selected here. Read-only, STABLE, service-role only (the edge function mediates).

create or replace function app.select_confirm_transfer_item(
  _exam_pack_version_id            uuid,
  _source_content_item_version_id  uuid
) returns table(
  content_item_version_id uuid,
  content_item_id         uuid,
  content_key             text,
  title                   text,
  stem                    text,
  stimulus                text,
  stimulus_image_path     text,
  prompt_json             jsonb,
  frq_form                text,
  practice_format         text,
  frq_archetype           text,
  published_at            timestamptz
)
language sql
stable
set search_path to 'pg_catalog'
as $$
  with source_cells as (
    -- the cell(s) the SOURCE version is tagged to
    select cic.taxonomy_source_version, cic.topic_code, cic.skill_code
    from app.content_item_cells cic
    where cic.content_item_version_id = _source_content_item_version_id
  ),
  source_item as (
    select civ.content_item_id
    from app.content_item_versions civ
    where civ.id = _source_content_item_version_id
  ),
  -- Numeric-answer cells excluded from confirm-transfer (see header).
  excluded_numeric_cells(topic_code, skill_code) as (
    values ('1.7', '3.B'), ('1.9', '3.B')
  ),
  eligible_cells as (
    select sc.taxonomy_source_version, sc.topic_code, sc.skill_code
    from source_cells sc
    where not exists (
      select 1 from excluded_numeric_cells e
      where e.topic_code = sc.topic_code
        and e.skill_code = sc.skill_code
    )
  ),
  candidates as (
    select distinct
      civ.id                  as content_item_version_id,
      ci.id                   as content_item_id,
      ci.content_key          as content_key,
      ci.title                as title,
      civ.stem                as stem,
      civ.stimulus            as stimulus,
      civ.stimulus_image_path as stimulus_image_path,
      civ.prompt_json         as prompt_json,
      ci.frq_form             as frq_form,
      ci.practice_format      as practice_format,
      ci.frq_archetype        as frq_archetype,
      civ.published_at        as published_at
    from app.content_items ci
    join app.content_item_versions civ
      on civ.content_item_id = ci.id
    join app.content_item_cells cic
      on cic.content_item_version_id = civ.id
    join eligible_cells ec
      on ec.taxonomy_source_version = cic.taxonomy_source_version
     and ec.topic_code            = cic.topic_code
     and ec.skill_code            = cic.skill_code
    where ci.exam_pack_version_id = _exam_pack_version_id
      and ci.item_type            = 'mcq'
      and ci.status               = 'published'
      and civ.status              = 'published'
      -- a DIFFERENT item: not this version, and not any version of the source item
      and civ.id <> _source_content_item_version_id
      and ci.id  <> (select content_item_id from source_item)
  )
  select
    content_item_version_id, content_item_id, content_key, title, stem, stimulus,
    stimulus_image_path, prompt_json, frq_form, practice_format, frq_archetype,
    published_at
  from candidates
  -- Deterministic, source-seeded spread: repeated calls for the same source are
  -- stable (testable); different sources fan out across the cell's instances.
  order by
    md5(content_item_version_id::text || _source_content_item_version_id::text),
    published_at,
    content_key
  limit 1;
$$;

comment on function app.select_confirm_transfer_item(uuid, uuid) is
  'Fail-closed same-cell confirm-transfer selector: one different published/approved MCQ tagged to the source item''s cell, numeric cells (1.7×3.B, 1.9×3.B) excluded. Read-only; out-of-band from the session-target queue.';

-- Service-role only: the student-session-items edge function mediates every call
-- (it enforces session ownership + exam-pack scoping first). Not exposed to
-- authenticated clients directly.
revoke all on function app.select_confirm_transfer_item(uuid, uuid) from public;
grant execute on function app.select_confirm_transfer_item(uuid, uuid) to service_role;
