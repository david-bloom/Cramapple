-- AP Biology: CED-vocabulary remediation of five published seeds (005, 018, 021, 022, 023), 2026-10-01.   APPLIED to Production 2026-10-01 under APPROVAL-0068.
-- Why: the Product Owner ruled on 2026-10-01 that items stay within CED vocabulary. The scope check (round 3, CED V.1 pp. 49-51 and a full-text search)
-- found these seeds depend on terms the CED does not name: isomer / aldohexose / ketohexose (005); receptor-mediated endocytosis, clathrin, endosome,
-- HMG-CoA reductase (018); signal peptide, SRP, proteasome (021); 70S/80S ribosomes, binary fission (022); integral/peripheral proteins, detergent,
-- impermeant biotin (023). Evidence: scripts/content-seed/apbio-seeded-pilot-2026-09-30/PILOT_REPORT.md (rounds 3 and 4).
-- What changes: stimulus, stem and all four choices and rationales of each seed, in plain CED vocabulary. The KEYED LETTER of every item is unchanged
-- (005 C, 018 B, 021 C, 022 A, 023 D) and is asserted below. 021 and 023 are replacement items on the same topic (the original mechanism cannot be stated
-- in CED vocabulary); 005, 018 and 022 keep their original idea. Readable old-versus-new preview: SEED_REMEDIATION_PREVIEW.md in the pilot folder.
-- Pattern: owner_remediation_approval (new version, never in place), as in 20261001_apbio_mcq_023_choice_a_rationale_repair.sql. Each item's labels (validated
-- serving label, provisional coverage label) are captured in this transaction and restored, re-pointed, after the version change. Carrying a validation across
-- a content change is a human validation act: this file refuses to run until the approval reference below is entered (and recorded in APPROVALS_LOG).
-- Unit and topic are not changed. Apply only after Orly / the Product Owner has reviewed the new text.

begin;
select pg_advisory_xact_lock(hashtext('cramapple-apbio-seed-ced-vocab-remediation-20261001'));

-- >>> EDIT THIS ONE LINE at apply time to the recorded Product Owner approval id; the guard below rejects 'PENDING'. <<<
create temporary table approval (ref text) on commit drop;
insert into approval values ('APPROVAL-0068');
do $$ begin if (select ref from approval) = 'PENDING' then raise exception 'not approved: enter the Product Owner approval reference above'; end if; end $$;

create temporary table newc (content_key text primary key, stimulus text not null, stem text not null) on commit drop;
insert into newc values
  ($t$APBIO-MCQ-005$t$, $t$Glucose and fructose are monosaccharides with the same molecular formula, C6H12O6, but their atoms are arranged differently, so the two molecules have different three-dimensional shapes. A transport protein in the plasma membrane of intestinal cells moves fructose across the membrane much more efficiently than it moves glucose.$t$, $t$Which statement best explains why a transport protein can distinguish between these two sugars?$t$),
  ($t$APBIO-MCQ-018$t$, $t$Liver cells take up LDL cholesterol by endocytosis. LDL particles bind to LDL receptors, which are proteins in the plasma membrane. The membrane then folds inward and engulfs the bound LDL in a vesicle that carries it into the cell. In familial hypercholesterolemia (FH), mutations eliminate functional LDL receptors from the cell surface.$t$, $t$Which prediction about individuals with familial hypercholesterolemia is best supported by the described process?$t$),
  ($t$APBIO-MCQ-021$t$, $t$Pancreatic cells secrete the digestive enzyme amylase. Amylase is made by ribosomes on the rough ER. It is then modified and packaged in the Golgi complex, and transport vesicles carry it to the plasma membrane to be secreted. A researcher treats the cells with a drug that blocks the formation of the transport vesicles that carry material from the rough ER to the Golgi complex.$t$, $t$Which outcome for amylase in the treated cells is most likely?$t$),
  ($t$APBIO-MCQ-022$t$, $t$Evidence supporting the endosymbiotic origin of mitochondria includes: (1) mitochondria have a double membrane, with an inner membrane that resembles the plasma membrane of a prokaryote and an outer membrane that resembles the endomembrane of the eukaryotic cell; (2) mitochondria have their own circular DNA, like the chromosome of a prokaryote; (3) mitochondria make some of their own proteins on their own ribosomes; (4) new mitochondria arise from existing mitochondria without the cell having to divide.$t$, $t$Which single piece of evidence most specifically supports the claim that a prokaryote was engulfed by a host cell, rather than simply showing a prokaryote-like ancestry?$t$),
  ($t$APBIO-MCQ-023$t$, $t$Researchers study two proteins from red blood cells. Protein M is found with the membranes of broken cells and cannot be separated from the phospholipids unless the bilayer is dissolved. The amino acids on the surface of Protein M have mostly nonpolar R groups. Protein C is found dissolved in the cytoplasm. The amino acids on the surface of Protein C have mostly polar R groups.$t$, $t$Which characterization of Protein M is best supported by these results?$t$);
create temporary table newch (content_key text, choice_key text, choice_text text not null, is_correct boolean not null, rationale text not null, primary key (content_key, choice_key)) on commit drop;
insert into newch values
  ($t$APBIO-MCQ-005$t$, 'A', $t$They have different numbers of carbon, hydrogen, and oxygen atoms, so the protein recognizes the sugar with more atoms.$t$, false, $t$Incorrect. The stimulus states that both sugars have the same molecular formula, so their atom counts are the same.$t$),
  ($t$APBIO-MCQ-005$t$, 'B', $t$They differ in the number of hydroxyl groups attached to the sugar backbone, and the protein recognizes the extra groups.$t$, false, $t$Incorrect. Glucose and fructose have the same molecular formula and the same number of hydroxyl groups; what differs is how the atoms are arranged.$t$),
  ($t$APBIO-MCQ-005$t$, 'C', $t$They have the same atoms arranged differently, which gives them different three-dimensional shapes that fit the transport protein differently.$t$, true, $t$Correct. The same atoms in a different arrangement give each sugar a different three-dimensional shape, and a transport protein can fit one shape much better than the other.$t$),
  ($t$APBIO-MCQ-005$t$, 'D', $t$Fructose is a polysaccharide, so it must be moved by a different kind of transport protein than glucose.$t$, false, $t$Incorrect. Fructose is a monosaccharide, like glucose, not a polysaccharide.$t$),
  ($t$APBIO-MCQ-018$t$, 'A', $t$Their liver cells will compensate by taking in large amounts of LDL through nonspecific endocytosis that does not need receptors.$t$, false, $t$Incorrect. In the process described, uptake starts when LDL binds a receptor in the plasma membrane. Nothing in the description suggests that nonspecific uptake could make up for the missing receptors.$t$),
  ($t$APBIO-MCQ-018$t$, 'B', $t$LDL particles will accumulate in the bloodstream because liver cells cannot specifically recognize and take them in without functional receptors.$t$, true, $t$Correct. Without LDL receptors in the plasma membrane, liver cells cannot bind LDL and take it in by endocytosis. LDL is not cleared from the blood, so plasma LDL cholesterol rises, which is the defining feature of FH.$t$),
  ($t$APBIO-MCQ-018$t$, 'C', $t$Their liver cells will take in LDL normally, because endocytosis does not depend on any proteins in the plasma membrane.$t$, false, $t$Incorrect. In the process described, LDL must first bind receptor proteins before the membrane folds inward. With no functional receptors, uptake does not occur normally.$t$),
  ($t$APBIO-MCQ-018$t$, 'D', $t$Their liver cells will collect LDL inside vesicles, because the vesicles cannot fuse with the plasma membrane to release it.$t$, false, $t$Incorrect. Without functional receptors, LDL is not engulfed at all, so no vesicles containing LDL form.$t$),
  ($t$APBIO-MCQ-021$t$, 'A', $t$Amylase is no longer made at all, because ribosomes on the rough ER cannot make proteins unless vesicles leave the ER.$t$, false, $t$Incorrect. Ribosomes synthesize proteins from mRNA whether or not vesicles form. The drug blocks the movement of the protein, not its synthesis.$t$),
  ($t$APBIO-MCQ-021$t$, 'B', $t$Amylase is made by ribosomes in the Golgi complex instead, and it is then secreted normally.$t$, false, $t$Incorrect. The Golgi complex modifies and packages new products, but it is not where amylase is made. In the process described, amylase is made at the rough ER.$t$),
  ($t$APBIO-MCQ-021$t$, 'C', $t$Amylase is still made on the rough ER, but it builds up there, and little reaches the Golgi complex or is secreted.$t$, true, $t$Correct. The drug blocks the vesicles that carry material from the rough ER to the Golgi complex, so the enzyme cannot move on to be modified, packaged, and secreted.$t$),
  ($t$APBIO-MCQ-021$t$, 'D', $t$Amylase is secreted faster than normal, because it no longer has to pass through the Golgi complex first.$t$, false, $t$Incorrect. The Golgi complex modifies and packages proteins for trafficking, and secretion depends on the vesicle route. Blocking the route does not speed secretion up.$t$),
  ($t$APBIO-MCQ-022$t$, 'A', $t$The double membrane, with an outer layer like host endomembrane and an inner layer like a prokaryotic plasma membrane, matches a prokaryote surrounded by a host membrane.$t$, true, $t$Correct. Evidence (1) describes the physical result of engulfment by endocytosis: the inner membrane is the original prokaryote's plasma membrane and the outer membrane comes from the host cell. Evidence (2), (3), and (4) show prokaryote-like ancestry but not how the cell came to be inside the host.$t$),
  ($t$APBIO-MCQ-022$t$, 'B', $t$Having its own circular DNA shows that mitochondria can still survive on their own outside the host cell, as a free-living prokaryote would.$t$, false, $t$Incorrect. Circular DNA shows a link to prokaryotes, but it does not show independent survival. Modern mitochondria depend on the host cell.$t$),
  ($t$APBIO-MCQ-022$t$, 'C', $t$Making new mitochondria without any cell division shows that mitochondria were once free-living prokaryotes that lived on their own.$t$, false, $t$Incorrect. Independent reproduction is similar to prokaryotes, but it does not describe how a prokaryote came to be inside a host cell. It does not describe the engulfment event.$t$),
  ($t$APBIO-MCQ-022$t$, 'D', $t$Having their own ribosomes for making proteins shows that mitochondria are currently prokaryotes that live inside eukaryotic cells.$t$, false, $t$Incorrect. Ribosomes are found in all forms of life and reflect common ancestry. They do not show that mitochondria are still independent prokaryotes.$t$),
  ($t$APBIO-MCQ-023$t$, 'A', $t$A protein dissolved in the cytoplasm, with nonpolar R groups on its surface that interact with the surrounding water.$t$, false, $t$Incorrect. Protein M stays with the membranes, and nonpolar R groups on a surface do not interact well with water. The dissolved protein, Protein C, has the polar surface.$t$),
  ($t$APBIO-MCQ-023$t$, 'B', $t$A protein attached only to the outside of the membrane, with its nonpolar R groups facing the watery environment.$t$, false, $t$Incorrect. Nonpolar R groups are not stable facing water. Protein M cannot be separated from the phospholipids unless the bilayer is dissolved, so it is not simply attached to the outside.$t$),
  ($t$APBIO-MCQ-023$t$, 'C', $t$A protein embedded in the membrane, with polar R groups on the surface that touches the phospholipid tails.$t$, false, $t$Incorrect. Polar R groups are not stable beside the hydrophobic tails of the phospholipids. The surface of Protein M is made mostly of nonpolar R groups.$t$),
  ($t$APBIO-MCQ-023$t$, 'D', $t$A protein embedded in the bilayer, with nonpolar R groups on the surface that touches the hydrophobic tails of the phospholipids.$t$, true, $t$Correct. Protein M cannot be separated from the phospholipids unless the bilayer is dissolved, so it is embedded in the membrane, and its nonpolar surface R groups are stable beside the hydrophobic tails.$t$);

create temporary table repaired (content_key text primary key, content_item_id uuid not null, old_version_id uuid not null, new_version_id uuid not null) on commit drop;
create temporary table prior_labels on commit drop as
  select l.content_taxonomy_label_id, l.content_item_id, l.label_scope, l.label_status, l.validated_by, l.validated_at, l.validation_decision_id,
         (l.validated_against_version_id is not null) as was_pointed
  from app.content_taxonomy_labels l join app.content_items ci on ci.id = l.content_item_id
  where ci.content_key in (select content_key from newc) and l.superseded_by is null;
create temporary table old_correct on commit drop as
  select ci.content_key, m.choice_key as old_key
  from app.content_items ci join app.content_item_versions civ on civ.content_item_id=ci.id and civ.status='published'
  join app.mcq_choices m on m.content_item_version_id=civ.id and m.is_correct
  where ci.content_key in (select content_key from newc);

do $$
declare
  r record; v_item app.content_items%rowtype; v_old app.content_item_versions%rowtype; v_new uuid;
begin
  for r in select * from newc order by content_key loop
    v_new := gen_random_uuid();
    select * into strict v_item from app.content_items where content_key=r.content_key and item_type='mcq' for update;
    select * into strict v_old from app.content_item_versions where content_item_id=v_item.id and status='published' order by version_num desc limit 1 for update;

    update app.content_review_assignments set status='skipped'
      where content_item_version_id=v_old.id and assignment_purpose='subject_review' and status in ('pending','in_progress');
    update app.content_item_versions set status='retired', updated_at=now() where id=v_old.id;
    update app.content_items set status='draft', updated_at=now() where id=v_item.id;

    insert into app.content_item_versions (id,content_item_id,version_num,stem,stimulus,prompt_json,explanation,help_text,content_hash,status,created_by,
      canonical_answer_1,canonical_answer_2,review_status,rubric_type,evaluator_strategy,stimulus_image_path)
    values (v_new,v_item.id,v_old.version_num+1,r.stem,r.stimulus,
      coalesce(v_old.prompt_json,'{}'::jsonb) || jsonb_build_object('content_version',v_old.version_num+1,
        'qa_remediation','2026-10-01 CED-vocabulary remediation (Biology seed scope check)','qa_source_version_id',v_old.id),
      v_old.explanation,v_old.help_text,md5(coalesce(r.stem,'')),'draft','f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,
      v_old.canonical_answer_1,v_old.canonical_answer_2,null,v_old.rubric_type,v_old.evaluator_strategy,v_old.stimulus_image_path);

    insert into app.mcq_choices (content_item_version_id,choice_key,choice_text,is_correct,rationale)
      select v_new,choice_key,choice_text,is_correct,rationale from newch where content_key=r.content_key;

    insert into app.content_item_cells (content_item_version_id,content_item_id,taxonomy_source_version,topic_code,skill_code,is_primary,assignment_status,source,model_run_id,validated_by,validated_at,validation_decision_id)
      select v_new,content_item_id,taxonomy_source_version,topic_code,skill_code,is_primary,assignment_status,source,model_run_id,validated_by,validated_at,validation_decision_id
      from app.content_item_cells where content_item_version_id=v_old.id and superseded_by is null;
    insert into app.content_item_difficulty (content_item_version_id,difficulty,basis,attainment_ratio,ratio_source,subject_cut_points,source_value,rationale,confidence,proposal_run,created_by)
      select v_new,difficulty,basis,attainment_ratio,ratio_source,subject_cut_points,source_value,rationale,confidence,proposal_run,created_by
      from app.content_item_difficulty where content_item_version_id=v_old.id;

    insert into repaired values (r.content_key, v_item.id, v_old.id, v_new);
  end loop;
end $$;

update app.content_item_versions civ
set content_hash = md5(coalesce(civ.stem,'')||E'\n'||coalesce(civ.stimulus,'')||E'\n'||
  coalesce((select string_agg(m.choice_key||':'||m.choice_text||':'||m.is_correct::text||':'||coalesce(m.rationale,''), E'\n' order by m.choice_key)
            from app.mcq_choices m where m.content_item_version_id=civ.id),''))
from repaired r where civ.id=r.new_version_id;

insert into app.content_review_assignments (content_review_assignment_id,content_item_version_id,reviewer_id,review_stage,review_kind,status,assignment_purpose,created_by)
select gen_random_uuid(),new_version_id,'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,'tutor_question','mcq','pending','owner_remediation_approval','f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid from repaired;

insert into app.content_review_decisions (content_review_assignment_id,content_item_version_id,reviewer_id,review_stage,tutor_score,difficulty_label,diagnostic_flag,
  concern_codes,note,tutor_decision,decision_payload,decision_hash,created_by)
select cra.content_review_assignment_id,r.new_version_id,'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,'tutor_question',1,
  coalesce((select d.difficulty_label from app.content_review_decisions d where d.content_item_version_id=r.old_version_id and d.tutor_decision='approve' order by d.created_at desc limit 1),'Medium'),
  false,array[]::text[],
  'Owner-approved CED-vocabulary remediation 2026-10-01 (' || (select ref from approval) || '): stimulus, stem and choices rewritten without terms the CED does not name; keyed letter unchanged. ' || r.content_key,
  'approve',
  jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','seed_ced_vocabulary_remediation','content_key',r.content_key,'qa_date','2026-10-01'),
  md5(r.new_version_id::text||'f5a26c6b-3566-4d58-9e97-979fbb947564'||'apbio-seed-ced-vocab-20261001'),
  'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
from repaired r
join app.content_review_assignments cra on cra.content_item_version_id=r.new_version_id and cra.assignment_purpose='owner_remediation_approval' and cra.status='pending';

update app.content_item_versions civ set status='reviewed_approved', review_status='question_review_approved',
  approved_by='f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, approved_at=coalesce(civ.approved_at,now()), updated_at=now()
from repaired r where civ.id=r.new_version_id;
update app.content_items ci set status='reviewed_approved', updated_at=now() from repaired r where ci.id=r.content_item_id;
update app.content_item_versions civ set status='published', published_at=coalesce(civ.published_at,now()), updated_at=now()
from repaired r where civ.id=r.new_version_id;
update app.content_items ci set status='published', updated_at=now() from repaired r where ci.id=r.content_item_id;

-- restore the labels that the version change made stale, re-pointed at the new version (unit and topic unchanged; no model relabelling)
update app.content_taxonomy_labels l
set label_status = p.label_status,
    validated_by = p.validated_by, validated_at = p.validated_at, validation_decision_id = p.validation_decision_id,
    validated_against_version_id = case when p.was_pointed then r.new_version_id else l.validated_against_version_id end,
    validated_against_taxo_hash  = case when p.was_pointed then app.taxonomy_relevant_hash(r.new_version_id) else l.validated_against_taxo_hash end,
    source_payload = l.source_payload || jsonb_build_object('carried_forward', jsonb_build_object(
        'from_version_id', l.validated_against_version_id, 'to_version_id', r.new_version_id,
        'reason', 'CED-vocabulary remediation of the seed text; unit and topic unchanged; no relabelling',
        'approval_ref', (select ref from approval), 'prior_status', p.label_status))
from prior_labels p join repaired r on r.content_item_id = p.content_item_id
where l.content_taxonomy_label_id = p.content_taxonomy_label_id;

do $$
declare n int;
begin
  select count(*) into n from repaired; if n<>5 then raise exception 'expected 5 repaired items, got %', n; end if;
  -- every new version has exactly 4 choices and exactly one correct, and it is the SAME letter as before
  select count(*) into n from repaired r where (select count(*) from app.mcq_choices w where w.content_item_version_id=r.new_version_id)<>4
     or (select count(*) from app.mcq_choices w where w.content_item_version_id=r.new_version_id and w.is_correct)<>1;
  if n<>0 then raise exception '% items without 4 choices / exactly one correct', n; end if;
  select count(*) into n from repaired r join old_correct o on o.content_key=r.content_key
    join app.mcq_choices w on w.content_item_version_id=r.new_version_id and w.is_correct and w.choice_key<>o.old_key;
  if n<>0 then raise exception 'keyed letter changed on % items', n; end if;
  select count(*) into n from repaired r join app.content_item_versions civ on civ.id=r.new_version_id
   where array_length(app.mcq_stem_choice_desync(civ.id, civ.stem),1) > 0;
  if n<>0 then raise exception 'stem/choice desync after remediation'; end if;
  select count(*) into n from (select content_item_id from app.content_item_versions where status='published' group by 1 having count(*)>1) d;
  if n<>0 then raise exception 'duplicate published versions: %', n; end if;
  select count(*) into n from prior_labels p join app.content_taxonomy_labels l on l.content_taxonomy_label_id=p.content_taxonomy_label_id
    join repaired r on r.content_item_id=p.content_item_id
   where l.label_status<>p.label_status
      or (p.was_pointed and (l.validated_against_version_id<>r.new_version_id or l.validated_against_taxo_hash<>app.taxonomy_relevant_hash(r.new_version_id)));
  if n<>0 then raise exception '% labels not restored/fresh', n; end if;
end $$;

select jsonb_build_object('repaired',(select count(*) from repaired),'labels_restored',(select count(*) from prior_labels)) as result;
commit;
