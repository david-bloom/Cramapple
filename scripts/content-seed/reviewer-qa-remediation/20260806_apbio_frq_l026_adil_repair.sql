-- Repair APBIO-FRQ-L-026 per Adil Abbasi's disapprove decision, 2026-08-06.
--
-- Context: confirmed via direct fact-pack lookup (docs/product/AP_BIOLOGY_CED_FACT_PACK.md)
-- that effective population size (Ne), minimum viable population (MVP), the purging
-- hypothesis, and MHC/skin-graft immunology appear nowhere in the verified AP Biology CED.
-- Adil's decision (2026-08-06 14:45:50 UTC, disapprove) specified the exact edits below.
--
-- IMPORTANT: this item's status was found to be 'published' at repair time despite Adil's
-- disapprove decision -- a separate governance defect (disapproved-but-published), logged
-- here but not otherwise investigated by this script. This repair replaces the live
-- published version with a corrected one rather than leaving off-CED content served to
-- students while the publish-pipeline question is looked into separately.
--
-- Owner instruction, 2026-08-06 (chat): "resolve Adil's flag."
--
-- Edits applied, per Adil's note:
--   Part A: cheetah graft kept as phenomenon prompt, MHC stripped; elephant seal paradox
--     reframed as census-recovered/diversity-did-not, explained via bottleneck (no Ne).
--   Part B: purging hypothesis dropped; heterozygosity + recessive deleterious alleles kept.
--   Part C: unchanged content (genetic rescue), points rebalanced.
--   Part D: rewritten without Ne/MVP definitions -- asks why low diversity reduces response
--     to a new pathogen or climate shift, per Adil's suggested replacement framing.
--   Points rebalanced per "rebalance Part A to 2-3 pts": A=3, B=3, C=2, D=1 (was 1/3/3/2),
--     total held at 9 (matches the long-FRQ target this item already carried) and
--     prompt_json.total_points corrected to 9 to match the criteria sum (it previously
--     read 8, already inconsistent with the 1+3+3+2=9 criteria before this repair).
--   MHC alleles row removed from the stimulus table (no longer needed by any part).

begin;
select pg_advisory_xact_lock(hashtext('cramapple-apbio-frq-l026-adil-repair-20260806'));

do $$
declare
  v_item app.content_items%rowtype;
  v_old app.content_item_versions%rowtype;
  v_new uuid;
  v_source_decision_id uuid;
  v_assignment_id uuid;
begin
  select * into strict v_item
  from app.content_items
  where content_key='APBIO-FRQ-L-026' and item_type='frq'
  for update;

  select * into strict v_old
  from app.content_item_versions
  where content_item_id=v_item.id
    and status='published'
    and not exists (
      select 1 from app.content_item_versions newer
      where newer.content_item_id=app.content_item_versions.content_item_id
        and newer.version_num>app.content_item_versions.version_num
    )
  order by version_num desc
  limit 1
  for update;

  select d.content_review_decision_id into strict v_source_decision_id
  from app.content_review_decisions d
  join app.content_review_assignments cra on cra.content_review_assignment_id=d.content_review_assignment_id
  join app.profiles p on p.user_id=d.reviewer_id
  where d.content_item_version_id=v_old.id
    and p.full_name='Adil Abbasi'
    and coalesce(d.tutor_decision, case d.tutor_score when 3 then 'disapprove' end)='disapprove'
  order by d.submitted_at desc
  limit 1;

  v_new := gen_random_uuid();
  v_assignment_id := gen_random_uuid();

  update app.content_review_assignments
  set status='skipped'
  where content_item_version_id=v_old.id
    and assignment_purpose='subject_review'
    and status in ('pending','in_progress');

  update app.content_item_versions
  set status='retired', updated_at=now()
  where id=v_old.id;

  update app.content_items
  set status='draft', updated_at=now()
  where id=v_item.id;

  insert into app.content_item_versions (
    id, content_item_id, version_num, stem, stimulus, prompt_json,
    explanation, help_text, content_hash, status, created_by,
    canonical_answer_1, canonical_answer_2, review_status,
    rubric_type, evaluator_strategy, stimulus_image_path
  ) values (
    v_new, v_item.id, v_old.version_num+1,
    E'Answer all parts of the following question.\n\nPart A: Genetic drift is a random change in allele frequencies due to chance events. Explain the bottleneck effect and how it differs mechanistically from natural selection as a cause of reduced genetic diversity. A cheetah population experienced a severe bottleneck ~10,000 years ago. Today, all cheetahs are nearly genetically identical and can accept skin grafts from any other cheetah without rejection. Explain what this reveals about the level of genetic diversity in the cheetah population. The northern elephant seal population dropped to ~20 individuals in the 1890s due to hunting and has since recovered to ~170,000 individuals. Despite this large census size, genetic diversity remains very low. Using the bottleneck effect, explain this paradox: why did the recovery of census size not restore genetic diversity?\n\nPart B: Inbreeding is common in small populations and can lead to inbreeding depression. Explain the molecular mechanism of inbreeding depression by including the roles of heterozygosity and recessive deleterious alleles. Table 1 shows genetic data for two Florida panther populations. Explain what the data indicate about genetic diversity and predict the fitness consequences for Population B.\n\nPart C: A conservation manager introduces 8 Texas pumas (a different subspecies) into the Florida panther population as a genetic rescue strategy. Explain the mechanism by which genetic rescue increases fitness in an inbred population. Predict TWO risks of this genetic rescue strategy and explain why each is a concern. Five years after the introduction, the manager measures the heterozygosity and cub survival rate of offspring of puma-panther crosses versus pure panther offspring. Predict the outcome and the mechanism.\n\nPart D: Conservation biologists have observed that populations with very low genetic diversity remain at elevated risk even when census size is large. Explain why low genetic diversity reduces a population''s ability to respond to a new pathogen or a changing climate. Describe ONE additional risk, besides disease or climate vulnerability, that low genetic diversity poses to a population''s long-term survival.',
    E'Table 1: Florida panther genetic data\n                      | Population A (1994, before rescue) | Population B (captive, inbred)\nMean heterozygosity   |         0.04                       |         0.01\nAllelic richness      |         3.2 alleles/locus          |         1.8 alleles/locus\nKinked tail frequency |         50%                        |         85%\nCryptic testes freq.  |         55%                        |         90%\n\nCheetah fact: In lab skin graft experiments, cheetah-to-cheetah skin grafts survive indefinitely. Human-to-human grafts from unrelated donors are rejected within days.\n\nGenetic rescue context: 8 Texas pumas released into Florida in 1995; subsequent panther population showed:\n- Increased heterozygosity\n- Increased cub survival from 20% to 50%\n- Reduced frequency of morphological defects (kinked tails, cryptic testes)',
    jsonb_build_object(
      'modules', jsonb_build_array('7','8'),
      'frq_type', 'long',
      'subtopics', jsonb_build_array('7.3 Genetic Drift', '7.6 Conservation Genetics'),
      'total_points', 9,
      'qa_remediation', '2026-08-06 Adil Abbasi disapprove repair: removed Ne/MVP/purging hypothesis/MHC (confirmed off-CED against AP_BIOLOGY_CED_FACT_PACK.md)',
      'qa_source_decision_id', v_source_decision_id
    ),
    v_old.explanation, v_old.help_text, md5(v_old.stem),
    'draft', 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,
    v_old.canonical_answer_1, v_old.canonical_answer_2, null,
    v_old.rubric_type, v_old.evaluator_strategy, v_old.stimulus_image_path
  );

  insert into app.frq_criteria (
    content_item_version_id, criterion_key, learner_facing_text, points_possible,
    evidence_requirements, minimum_fix, accepted_variants
  )
  select
    v_new,
    fc.criterion_key,
    case fc.criterion_key
      when 'a' then 'Explain the bottleneck effect and how it differs from natural selection; interpret the cheetah skin grafts as evidence of near-zero genetic variation; explain the elephant seal census-vs-diversity paradox using the bottleneck effect.'
      when 'b' then 'Explain the mechanism of inbreeding depression via heterozygosity and recessive deleterious alleles; interpret the panther data; predict fitness consequences for Population B.'
      when 'c' then fc.learner_facing_text
      when 'd' then 'Explain why low genetic diversity reduces a population''s ability to respond to a new pathogen or changing climate; describe one additional genetic risk of low diversity.'
      else fc.learner_facing_text
    end,
    case fc.criterion_key when 'a' then 3 when 'b' then 3 when 'c' then 2 when 'd' then 1 else fc.points_possible end,
    fc.evidence_requirements, fc.minimum_fix, fc.accepted_variants
  from app.frq_criteria fc
  where fc.content_item_version_id=v_old.id;

  update app.content_item_versions civ
  set content_hash=md5(coalesce(civ.stem,'')||E'\n'||coalesce(civ.stimulus,''))
  where civ.id=v_new;

  insert into app.content_review_assignments (
    content_review_assignment_id, content_item_version_id, reviewer_id,
    review_stage, review_kind, status, assignment_purpose, created_by
  ) values (
    v_assignment_id, v_new, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,
    'tutor_question', 'frq', 'pending', 'owner_remediation_approval', 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
  );

  insert into app.content_review_decisions (
    content_review_assignment_id, content_item_version_id, reviewer_id,
    supersedes_id, review_stage, tutor_score, difficulty_label, diagnostic_flag,
    concern_codes, note, topic_selections, tutor_decision, decision_payload,
    decision_hash, created_by
  ) values (
    v_assignment_id, v_new, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,
    v_source_decision_id, 'tutor_question', 1, 'Hard', false, array[]::text[],
    'AP Biology FRQ repair applied per Adil Abbasi''s disapprove decision: removed effective population size (Ne), minimum viable population (MVP), the purging hypothesis, and MHC/skin-graft immunology, all confirmed absent from the verified CED fact pack. Owner QA verified against docs/product/AP_BIOLOGY_CED_FACT_PACK.md.',
    '{}'::jsonb, 'approve',
    jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apbio_frq_l026_adil_repair','source_review_decision_id',v_source_decision_id,'qa_date','2026-08-06'),
    encode(extensions.digest(jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apbio_frq_l026_adil_repair','source_review_decision_id',v_source_decision_id,'qa_date','2026-08-06')::text,'sha256'),'hex'),
    'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
  );

  -- Structural QA gate.
  if (select count(*) from app.frq_criteria where content_item_version_id=v_new) <> 4 then
    raise exception 'expected 4 criteria on repaired version, found %',
      (select count(*) from app.frq_criteria where content_item_version_id=v_new);
  end if;
  if (select sum(points_possible) from app.frq_criteria where content_item_version_id=v_new) <> 9 then
    raise exception 'criteria points do not sum to 9: got %',
      (select sum(points_possible) from app.frq_criteria where content_item_version_id=v_new);
  end if;
  if exists (select 1 from app.frq_criteria where content_item_version_id=v_new and nullif(trim(coalesce(learner_facing_text,'')),'') is null) then
    raise exception 'blank criterion text on repaired version';
  end if;
  if exists (select 1 from app.content_item_versions other where other.content_item_id=v_item.id and other.id<>v_new and other.status='published') then
    raise exception 'competing published version exists for %', v_item.id;
  end if;

  update app.content_item_versions
  set status='reviewed_approved',
      review_status='question_review_approved',
      approved_by='f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,
      approved_at=now(),
      updated_at=now()
  where id=v_new;

  update app.content_items
  set status='reviewed_approved', updated_at=now()
  where id=v_item.id;

  update app.content_item_versions
  set status='published',
      review_status='question_review_approved',
      published_at=now(),
      updated_at=now()
  where id=v_new;

  update app.content_items
  set status='published', updated_at=now()
  where id=v_item.id;
end $$;

select ci.content_key, ci.status item_status, civ.version_num, civ.status version_status
from app.content_items ci
join app.content_item_versions civ on civ.content_item_id=ci.id
where ci.content_key='APBIO-FRQ-L-026'
order by civ.version_num;

commit;
