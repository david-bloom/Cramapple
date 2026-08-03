import { readFile, readdir, writeFile } from "node:fs/promises";

const ROOT = new URL("../../", import.meta.url).pathname;
const DIR = `${ROOT}content/item-packages/ap-calculus-ab`;
const OUT = `${ROOT}scripts/calculus-ab-content-2026-07-27/load-production-drafts.sql`;
const pattern = /^apcalcab-(mcq-(02[1-9]|0[3-4][0-9]|050)|frq-(01[7-9]|02[0-9]|03[0-6]))\.json$/;
const names = (await readdir(DIR)).filter(name=>pattern.test(name)).sort();
const packages = await Promise.all(names.map(async name=>JSON.parse(await readFile(`${DIR}/${name}`,"utf8"))));
if (packages.length!==50) throw new Error(`Expected 50 packages, found ${packages.length}.`);

const payload=JSON.stringify(packages);
const sql=`-- Load the validated 2026-07-27 AP Calculus AB batch as unassigned
-- Production drafts. This is intentionally fail-closed: if any target content
-- key already exists, the transaction aborts rather than creating a new
-- version or overwriting reviewed content.

begin;

select pg_advisory_xact_lock(
  hashtext('cramapple-ap-calculus-ab-draft-load-20260728')
);

do $load$
declare
  v_exam_pack_version_id uuid;
  v_item jsonb;
  v_part jsonb;
  v_criterion jsonb;
  v_choice jsonb;
  v_content_item_id uuid;
  v_content_item_version_id uuid;
  v_stem text;
  v_stimulus text;
  v_prompt_json jsonb;
begin
  select epv.id
  into strict v_exam_pack_version_id
  from app.exam_pack_versions epv
  join app.exam_packs ep on ep.id = epv.exam_pack_id
  where ep.exam_code = 'ap_calculus_ab'
    and epv.school_year = '2025-26';

  for v_item in
    select value
    from jsonb_array_elements($payload$${payload}$payload$::jsonb)
  loop
    if exists (
      select 1
      from app.content_items ci
      where ci.exam_pack_version_id = v_exam_pack_version_id
        and ci.content_key = v_item->>'content_key'
    ) then
      raise exception 'Target content key already exists: %', v_item->>'content_key';
    end if;

    insert into app.content_items (
      exam_pack_version_id,
      content_key,
      item_type,
      title,
      status,
      frq_form,
      practice_format,
      frq_archetype
    )
    values (
      v_exam_pack_version_id,
      v_item->>'content_key',
      v_item->>'item_type',
      v_item->>'content_key',
      'draft',
      case when v_item->>'item_type' = 'frq' then v_item->>'frq_form' else null end,
      case when v_item->>'item_type' = 'frq' then 'full_exam_frq' else null end,
      case when v_item->>'item_type' = 'frq' then v_item#>>'{archetype_ref,archetype_key}' else null end
    )
    returning id into v_content_item_id;

    select string_agg(s#>>'{payload,text}', E'\\n\\n' order by (s->>'ordinal')::integer)
    into v_stimulus
    from jsonb_array_elements(v_item->'stimuli') s;

    if v_item->>'item_type' = 'mcq' then
      v_stem := v_item#>>'{parts,0,prompt}';
    else
      select
        'Answer all parts of the following question.' || E'\\n\\n' ||
        string_agg(
          coalesce(p->>'label','') || ' ' || (p->>'prompt'),
          E'\\n\\n'
          order by (p->>'ordinal')::integer
        )
      into v_stem
      from jsonb_array_elements(v_item->'parts') p;
    end if;

    select jsonb_build_object(
      'modules', coalesce(jsonb_agg(t->>'node_key'), '[]'::jsonb),
      'subject', 'ap_calculus_ab',
      'item_type', v_item->>'item_type',
      'frq_type', v_item->>'frq_form',
      'total_points', (
        select coalesce(sum((p->>'points')::integer),0)
        from jsonb_array_elements(v_item->'parts') p
      ),
      'archetype', v_item#>>'{archetype_ref,archetype_key}',
      'difficulty', v_item->>'difficulty',
      'content_key', v_item->>'content_key',
      'calculator_mode', v_item#>>'{stimuli,0,payload,calculator_mode}',
      'source_school_year', v_item#>>'{exam_pack_ref,school_year}',
      'package_schema_version', v_item->>'schema_version',
      'package_content_sha256', v_item#>>'{provenance,content_sha256}',
      'scoring_contract', coalesce(v_item->'scoring_contract','{}'::jsonb)
    )
    into v_prompt_json
    from jsonb_array_elements(v_item->'taxonomy_refs') t;

    insert into app.content_item_versions (
      content_item_id,
      version_num,
      stem,
      stimulus,
      canonical_answer_1,
      prompt_json,
      explanation,
      help_text,
      rubric_type,
      evaluator_strategy,
      status,
      content_hash
    )
    values (
      v_content_item_id,
      1,
      v_stem,
      v_stimulus,
      v_item#>>'{canonical_answers,0}',
      v_prompt_json,
      v_item#>>'{review_notes,teaching_explanation}',
      v_item#>>'{review_notes,minimum_fix}',
      case when v_item->>'item_type' = 'mcq' then 'mcq' else 'discrete_text' end,
      case when v_item->>'item_type' = 'mcq' then 'rule_based_mcq' else 'llm_discrete_text' end,
      'draft',
      v_item#>>'{provenance,content_sha256}'
    )
    returning id into v_content_item_version_id;

    if v_item->>'item_type' = 'mcq' then
      for v_choice in
        select value from jsonb_array_elements(v_item->'mcq_choices')
      loop
        insert into app.mcq_choices (
          content_item_version_id,
          choice_key,
          choice_text,
          is_correct,
          rationale
        )
        values (
          v_content_item_version_id,
          v_choice->>'choice_key',
          v_choice->>'choice_text',
          (v_choice->>'is_correct')::boolean,
          v_choice->>'rationale'
        );
      end loop;
    else
      for v_part in
        select value from jsonb_array_elements(v_item->'parts')
      loop
        for v_criterion in
          select value from jsonb_array_elements(v_part->'criteria')
        loop
          insert into app.frq_criteria (
            content_item_version_id,
            criterion_key,
            learner_facing_text,
            points_possible,
            evidence_requirements,
            minimum_fix,
            accepted_variants
          )
          values (
            v_content_item_version_id,
            v_criterion->>'criterion_key',
            v_criterion->>'description',
            (v_criterion->>'points')::integer,
            (
              select string_agg(evidence, '; ')
              from jsonb_array_elements_text(v_criterion->'required_evidence') evidence
            ),
            v_criterion->>'minimum_fix',
            coalesce(v_criterion->'accepted_variants','[]'::jsonb)
          );
        end loop;
      end loop;
    end if;
  end loop;
end
$load$;

do $verify$
declare
  v_items integer;
  v_versions integer;
  v_mcq integer;
  v_frq integer;
  v_choices integer;
  v_correct integer;
  v_criteria integer;
  v_points integer;
  v_assignments integer;
  v_non_draft_items integer;
  v_non_draft_versions integer;
  v_published integer;
begin
  select
    count(*),
    count(*) filter (where ci.item_type='mcq'),
    count(*) filter (where ci.item_type='frq'),
    count(*) filter (where ci.status <> 'draft')
  into v_items, v_mcq, v_frq, v_non_draft_items
  from app.content_items ci
  join app.exam_pack_versions epv on epv.id=ci.exam_pack_version_id
  join app.exam_packs ep on ep.id=epv.exam_pack_id
  where ep.exam_code='ap_calculus_ab'
    and (
      ci.content_key between 'apcalcab-mcq-021' and 'apcalcab-mcq-050'
      or ci.content_key between 'apcalcab-frq-017' and 'apcalcab-frq-036'
    );

  select
    count(*),
    count(*) filter (where civ.status <> 'draft'),
    count(*) filter (where civ.published_at is not null)
  into v_versions, v_non_draft_versions, v_published
  from app.content_item_versions civ
  join app.content_items ci on ci.id=civ.content_item_id
  where ci.content_key between 'apcalcab-mcq-021' and 'apcalcab-mcq-050'
     or ci.content_key between 'apcalcab-frq-017' and 'apcalcab-frq-036';

  select count(*), count(*) filter (where ch.is_correct)
  into v_choices, v_correct
  from app.mcq_choices ch
  join app.content_item_versions civ on civ.id=ch.content_item_version_id
  join app.content_items ci on ci.id=civ.content_item_id
  where ci.content_key between 'apcalcab-mcq-021' and 'apcalcab-mcq-050';

  select count(*), coalesce(sum(fc.points_possible),0)
  into v_criteria, v_points
  from app.frq_criteria fc
  join app.content_item_versions civ on civ.id=fc.content_item_version_id
  join app.content_items ci on ci.id=civ.content_item_id
  where ci.content_key between 'apcalcab-frq-017' and 'apcalcab-frq-036';

  select count(*)
  into v_assignments
  from app.content_review_assignments a
  join app.content_item_versions civ on civ.id=a.content_item_version_id
  join app.content_items ci on ci.id=civ.content_item_id
  where ci.content_key between 'apcalcab-mcq-021' and 'apcalcab-mcq-050'
     or ci.content_key between 'apcalcab-frq-017' and 'apcalcab-frq-036';

  if (v_items,v_mcq,v_frq,v_versions,v_choices,v_correct,v_criteria,v_points)
     <> (50,30,20,50,120,30,180,180) then
    raise exception
      'Draft load reconciliation failed: items %, MCQ %, FRQ %, versions %, choices %, correct %, criteria %, points %',
      v_items,v_mcq,v_frq,v_versions,v_choices,v_correct,v_criteria,v_points;
  end if;

  if v_non_draft_items <> 0
     or v_non_draft_versions <> 0
     or v_published <> 0
     or v_assignments <> 0 then
    raise exception
      'Draft isolation failed: non-draft items %, non-draft versions %, published %, assignments %',
      v_non_draft_items,v_non_draft_versions,v_published,v_assignments;
  end if;
end
$verify$;

commit;
`;

await writeFile(OUT,sql);
console.log(`Wrote ${OUT} for ${packages.length} draft packages.`);
