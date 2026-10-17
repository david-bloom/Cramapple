-- Legacy Biology FRQ question-instruction repair (units 1-3): STEP 1, DRAFT VERSIONS ONLY. Drafted 2026-10-17; NOT YET EXECUTED (APPROVAL-0189).
--
-- 14 published short FRQs carry a scenario stem but no question instructions (prompt_json.parts absent), so a student
-- cannot tell what is asked. This inserts a NEW DRAFT version (v+1) of each with authored parts
-- (part_key, prompt_text, points_possible). It does NOT retire, approve or publish anything: the live version keeps
-- serving, no review decision or approved_by is written, and publishing is a separate owner-run step.
-- Scoring criteria are copied unchanged (same keys, text, points).
-- Stem/stimulus changes (owner-approved in chat 2026-10-17): S-021, S-032, S-036 stems; S-019 stimulus emptied;
-- S-023 data table added. Prompts were checked by three model families (Opus 5.5, GPT-6.1, Gemini 3.8 Flash) for
-- criterion coverage, extra asks and scored-fact leaks; S-036 passed 2 of 3 (one dissent noted in APPROVAL-0189).
-- Excluded: APBIO-FRQ-S-040 (later-unit scope conflict). S-003 stays withheld by the image gate (separate ruling).
--
-- Rehearse first: replace the final `commit;` with `rollback;`; the assertions still fire.

begin;
select pg_advisory_xact_lock(hashtext('cramapple-bio-frq-instructions-20261017'));

create temporary table repair_targets (
  content_key text primary key,
  new_stem text,
  set_stimulus boolean not null,
  new_stimulus text,
  parts jsonb not null
) on commit drop;

insert into repair_targets (content_key,new_stem,set_stimulus,new_stimulus,parts) values
('APBIO-FRQ-S-003', null, false, null, $q$[{"part_key": "a", "prompt_text": "Trace the path of electrons from water to NADP+ during the light-dependent reactions. Name at least two electron carriers or complexes along the way."}, {"part_key": "b", "prompt_text": "Explain how a proton gradient is established across the thylakoid membrane and how it drives ATP synthesis."}]$q$::jsonb),
('APBIO-FRQ-S-019', null, true, null, $q$[{"part_key": "a", "prompt_text": "State two distinct pieces of evidence that support the endosymbiotic origin of mitochondria and chloroplasts."}, {"part_key": "b", "prompt_text": "Mitochondria and chloroplasts are each surrounded by two membranes. According to the theory, explain where the outer membrane came from and where the inner membrane came from."}]$q$::jsonb),
('APBIO-FRQ-S-021', $q$A student compares the structures of an amino acid and a fatty acid to understand how each behaves in a cell.$q$, false, null, $q$[{"part_key": "a", "prompt_text": "Describe how two amino acids are joined in a protein. Name the bond that forms and state what is released when it forms."}, {"part_key": "b", "prompt_text": "Describe the structural feature of a fatty acid that makes it hydrophobic, and explain why that feature keeps it from dissolving in water."}]$q$::jsonb),
('APBIO-FRQ-S-023', null, true, $q$Relative enzyme activity (% of that enzyme's maximum measured)
pH 2: pepsin 100, trypsin 2
pH 7: pepsin 8, trypsin 100
pH 11: pepsin 0, trypsin 35$q$, $q$[{"part_key": "a", "prompt_text": "Explain how the conditions at pH 2 affect the bonds that hold pepsin's active site in shape, and how this accounts for pepsin's activity at that pH."}, {"part_key": "b", "prompt_text": "Using the data, describe how trypsin activity at pH 2 compares with pH 7, and explain the cause at the molecular level."}]$q$::jsonb),
('APBIO-FRQ-S-025', null, false, null, $q$[{"part_key": "a", "prompt_text": "Explain the molecular basis of water's high specific heat and describe how this property affects temperature changes in living systems and their environments."}, {"part_key": "b", "prompt_text": "Describe how water molecules interact with the ions of dissolved sodium chloride (NaCl), including which part of the water molecule faces each ion."}]$q$::jsonb),
('APBIO-FRQ-S-026', null, false, null, $q$[{"part_key": "a", "prompt_text": "Identify two structures that the plant cell has and the bacterial cell lacks, and explain the function of one of them."}, {"part_key": "b", "prompt_text": "Explain how the lack of membrane-bound organelles affects (i) the cost to the cell of building its structure and (ii) how quickly the cell can reproduce."}]$q$::jsonb),
('APBIO-FRQ-S-028', null, false, null, $q$[{"part_key": "a", "prompt_text": "Describe two pieces of evidence that support the endosymbiotic origin of mitochondria."}, {"part_key": "b", "prompt_text": "Explain the origin of the outer mitochondrial membrane and of the inner mitochondrial membrane."}]$q$::jsonb),
('APBIO-FRQ-S-029', null, false, null, $q$[{"part_key": "a", "prompt_text": "Describe what happens to the plant cell in the concentrated salt solution and explain the mechanism."}, {"part_key": "b", "prompt_text": "Explain why a plant cell does not burst when it is placed in a hypotonic (dilute) solution."}]$q$::jsonb),
('APBIO-FRQ-S-032', $q$Cells take up glucose via facilitated diffusion using glucose transporter (GLUT) proteins rather than by simple diffusion.$q$, false, null, $q$[{"part_key": "a", "prompt_text": "Describe the properties of glucose that prevent it from crossing the phospholipid bilayer by simple diffusion, and explain why the bilayer blocks it."}, {"part_key": "b", "prompt_text": "Distinguish facilitated diffusion from active transport in terms of the direction relative to the concentration gradient and the energy required."}]$q$::jsonb),
('APBIO-FRQ-S-033', null, false, null, $q$[{"part_key": "a", "prompt_text": "Describe the steps by which influenza virus is taken into a host cell by receptor-mediated endocytosis."}, {"part_key": "b", "prompt_text": "Explain how receptor-mediated endocytosis differs from non-specific uptake in determining which molecules enter a cell."}]$q$::jsonb),
('APBIO-FRQ-S-036', $q$A student compares ATP production in aerobic respiration with ATP production by fermentation in human muscle cells under different oxygen conditions.$q$, false, null, $q$[{"part_key": "a", "prompt_text": "Compare the approximate ATP yield per glucose of aerobic respiration and of fermentation. For each, identify the process that produces the ATP; for aerobic respiration, also identify the molecules that supply its electrons."}, {"part_key": "b", "prompt_text": "Explain what happens to pyruvate during fermentation and why the cell needs this to keep making ATP when oxygen is unavailable."}]$q$::jsonb),
('APBIO-FRQ-S-038', null, false, null, $q$[{"part_key": "a", "prompt_text": "Describe how ATP synthase normally makes ATP, including what drives it."}, {"part_key": "b", "prompt_text": "Predict how the toxin changes the cell's ATP levels and justify your prediction. Then explain which ATP-producing processes, if any, remain and their approximate ATP yield per glucose."}]$q$::jsonb),
('APBIO-FRQ-S-071', null, false, null, $q$[{"part_key": "a", "prompt_text": "Predict the direction of net water movement between the soil solution and the cell, and explain the mechanism."}, {"part_key": "b", "prompt_text": "Describe how turgor pressure changes during the net water movement you predicted in part (a), and explain how this change affects further net water movement."}]$q$::jsonb),
('APBIO-FRQ-S-080', null, false, null, $q$[{"part_key": "a", "prompt_text": "Explain how a single amino acid substitution can cause a protein to misfold and lose function."}, {"part_key": "b", "prompt_text": "Identify which level of protein structure the mutation changes directly, and which level's altered folding is responsible for the loss of function."}]$q$::jsonb);

create temporary table drafted (
  content_key text primary key,
  old_version_id uuid not null,
  new_version_id uuid not null
) on commit drop;

do $$
declare
  t record;
  v_item app.content_items%rowtype;
  v_old app.content_item_versions%rowtype;
  v_new uuid;
begin
  for t in select * from repair_targets order by content_key loop
    select * into strict v_item from app.content_items
    where content_key=t.content_key and item_type='frq' for update;

    select * into strict v_old from app.content_item_versions
    where content_item_id=v_item.id and status='published'
    order by version_num desc limit 1 for update;

    if coalesce(v_old.prompt_json,'{}'::jsonb) ? 'parts' then
      raise exception '% already has authored parts; refusing to overwrite', t.content_key;
    end if;
    if exists (select 1 from app.content_item_versions o where o.content_item_id=v_item.id and o.status<>'published' and o.version_num>v_old.version_num) then
      raise exception '% already has a newer non-published version; refusing to stack', t.content_key;
    end if;

    v_new := gen_random_uuid();

    insert into app.content_item_versions (
      id,content_item_id,version_num,stem,stimulus,prompt_json,explanation,help_text,content_hash,status,created_by,
      canonical_answer_1,canonical_answer_2,review_status,rubric_type,evaluator_strategy,stimulus_image_path
    ) values (
      v_new,v_item.id,v_old.version_num+1,
      coalesce(t.new_stem,v_old.stem),
      case when t.set_stimulus then t.new_stimulus else v_old.stimulus end,
      coalesce(v_old.prompt_json,'{}'::jsonb) || jsonb_build_object(
        'content_version',v_old.version_num+1,
        'qa_remediation','2026-10-17 legacy Biology FRQ question-instruction repair (APPROVAL-0189)',
        'qa_source_version_id',v_old.id,
        'parts',(
          select jsonb_agg(jsonb_build_object('part_key',p->>'part_key','prompt_text',p->>'prompt_text',
            'points_possible',(select coalesce(sum(fc.points_possible),0) from app.frq_criteria fc
                               where fc.content_item_version_id=v_old.id and left(fc.criterion_key,1)=p->>'part_key')) order by ord)
          from jsonb_array_elements(t.parts) with ordinality as e(p,ord))
      ),
      v_old.explanation,v_old.help_text,v_old.content_hash,'draft',v_old.created_by,
      v_old.canonical_answer_1,v_old.canonical_answer_2,null,v_old.rubric_type,v_old.evaluator_strategy,v_old.stimulus_image_path
    );

    insert into app.frq_criteria (content_item_version_id,criterion_key,learner_facing_text,points_possible,evidence_requirements,minimum_fix,accepted_variants,judgement_kind)
    select v_new,criterion_key,learner_facing_text,points_possible,evidence_requirements,minimum_fix,accepted_variants,judgement_kind
    from app.frq_criteria where content_item_version_id=v_old.id;

    insert into drafted values (t.content_key,v_old.id,v_new);
  end loop;
end $$;

update app.content_item_versions civ
set content_hash = md5(coalesce(civ.stem,'')||E'\n'||coalesce(civ.stimulus,'')||E'\n'||
  coalesce((select string_agg(fc.criterion_key||':'||fc.learner_facing_text||':'||fc.points_possible::text, E'\n' order by fc.criterion_key)
            from app.frq_criteria fc where fc.content_item_version_id=civ.id),''))
from drafted d where civ.id=d.new_version_id;

do $$
declare n integer; bad text;
begin
  select count(*) into n from drafted;
  if n<>14 then raise exception 'expected 14 drafts, got %', n; end if;

  select string_agg(g.content_key||':'||g.reason, ', ' order by g.content_key) into bad from (
    select d.content_key,
      case
        when (select count(*) from app.frq_criteria fc where fc.content_item_version_id=d.new_version_id)
             <> (select count(*) from app.frq_criteria fc where fc.content_item_version_id=d.old_version_id) then 'criteria count changed'
        when (select sum(fc.points_possible) from app.frq_criteria fc where fc.content_item_version_id=d.new_version_id) <> 4 then 'points do not sum to 4'
        when exists (select 1 from app.frq_criteria fc where fc.content_item_version_id=d.new_version_id and nullif(trim(fc.learner_facing_text),'') is null) then 'blank criterion text'
        when (select jsonb_array_length(v.prompt_json->'parts') from app.content_item_versions v where v.id=d.new_version_id)<>2 then 'expected 2 parts'
        when exists (select 1 from app.content_item_versions v, jsonb_array_elements(v.prompt_json->'parts') p
                     where v.id=d.new_version_id and nullif(btrim(p->>'prompt_text'),'') is null) then 'blank part prompt'
        when (select sum((p->>'points_possible')::int) from app.content_item_versions v, jsonb_array_elements(v.prompt_json->'parts') p where v.id=d.new_version_id)<>4 then 'part points do not sum to 4'
        when not exists (select 1 from app.content_item_versions v where v.id=d.old_version_id and v.status='published') then 'live version no longer published'
      end as reason
    from drafted d) g where g.reason is not null;
  if bad is not null then raise exception 'structural gate: %', bad; end if;
end $$;

select 'drafted' metric, count(*)::text value from drafted
union all select 'still_published_old', count(*)::text from drafted d join app.content_item_versions v on v.id=d.old_version_id and v.status='published'
union all select 'draft_keys', string_agg(content_key, ', ' order by content_key) from drafted;

commit;
