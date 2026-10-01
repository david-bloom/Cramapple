# Generates scripts/content-seed/reviewer-qa-remediation/20261001_apbio_seed_ced_vocabulary_remediation.sql from seed_ced_remediation_content.py.
import os, sys
sys.path.insert(0, os.path.dirname(__file__))
from seed_ced_remediation_content import NEW
OUT = os.path.join(os.path.dirname(__file__), "..", "reviewer-qa-remediation", "20261001_apbio_seed_ced_vocabulary_remediation.sql")
q = lambda s: "$t$" + s + "$t$"
for n in NEW.values():
    for t in [n["stimulus"], n["stem"]] + [c[0] for c in n["ch"].values()] + [c[2] for c in n["ch"].values()]:
        assert "$t$" not in t
content_rows = ",\n".join(f"  ({q(k)}, {q(n['stimulus'])}, {q(n['stem'])})" for k, n in NEW.items())
choice_rows = ",\n".join(f"  ({q(k)}, '{l}', {q(c[0])}, {str(c[1]).lower()}, {q(c[2])})" for k, n in NEW.items() for l, c in n["ch"].items())
SQL = f"""-- AP Biology: CED-vocabulary remediation of five published seeds (005, 018, 021, 022, 023), 2026-10-01.   DRAFT -- NOT APPLIED.
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
insert into approval values ('PENDING');
do $$ begin if (select ref from approval) = 'PENDING' then raise exception 'not approved: enter the Product Owner approval reference above'; end if; end $$;

create temporary table newc (content_key text primary key, stimulus text not null, stem text not null) on commit drop;
insert into newc values
{content_rows};
create temporary table newch (content_key text, choice_key text, choice_text text not null, is_correct boolean not null, rationale text not null, primary key (content_key, choice_key)) on commit drop;
insert into newch values
{choice_rows};

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
      coalesce(v_old.prompt_json,'{{}}'::jsonb) || jsonb_build_object('content_version',v_old.version_num+1,
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
set content_hash = md5(coalesce(civ.stem,'')||E'\\n'||coalesce(civ.stimulus,'')||E'\\n'||
  coalesce((select string_agg(m.choice_key||':'||m.choice_text||':'||m.is_correct::text||':'||coalesce(m.rationale,''), E'\\n' order by m.choice_key)
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
"""
open(OUT, "w").write(SQL)
# readable preview
import json
seeds = {x["key"]: x for x in json.load(open(os.path.join(os.path.dirname(__file__), "seed_items.json")))}
P = ["# Seed remediation preview (old vs new), 2026-10-01 -- DRAFT, not applied\n",
     "Approval: PENDING. Keyed letters unchanged. 021 and 023 are replacement items on the same topic; 005, 018 and 022 keep their original idea.\n"]
for k, n in NEW.items():
    o = seeds[k]
    P.append(f"\n## {k}\n\n**Old stem (as published, stimulus folded in):**\n\n> {o['stem'].replace(chr(10), ' ')}\n")
    P.append("**Old choices:**\n" + "\n".join(f"- {c['label']}{' (key)' if c['label']==o['keyed_label'] else ''}: {c['text']}" for c in o["choices"]) + "\n")
    P.append(f"**New stimulus:** {n['stimulus']}\n\n**New stem:** {n['stem']}\n")
    P.append("**New choices:**\n" + "\n".join(f"- {l}{' (key)' if c[1] else ''}: {c[0]}\n  - rationale: {c[2]}" for l, c in n["ch"].items()) + "\n")
open(os.path.join(os.path.dirname(__file__), "SEED_REMEDIATION_PREVIEW.md"), "w").write("\n".join(P))
print("wrote", os.path.relpath(OUT))
