import json
plan=json.load(open('skill_plan.json'))['plan']
VM=json.load(open('variants_map.json'))
EXC=[v['variant_key'] for v in VM if v.get('topic_matches_seed') is not True]
TSV={'ab':'33b4408b-0ecc-4c7a-b0b1-612db81164a1','chem':'cbe3116f-6ef5-410c-b535-e9fb711c4c2c','phys1':'27111dec-ee07-48f1-86cf-1a5833dd2962','precalc':'16383753-6775-430d-960a-544cd6ee0972','stats':'dae3c72e-82ca-4960-9552-1b034bd347e5','bio':'c676d1fc-3b58-4896-89e3-852d9bd1f81b'}
PK={'ab':'826c8cf1-bc1b-4f2a-bd33-61a758e1487d','chem':'c9ca46b2-b529-4ed3-9741-dddea455ab9b','phys1':'29c719dc-701b-470f-9e49-fab981722d3f','precalc':'5522b532-5e50-41f2-99a2-10144bd4e8db','stats':'548f06be-ccf4-426d-b82b-b424137a4438','bio':'2d88ba5e-a6a3-43b8-bfae-9e5505a178a7'}
sv=",".join(f"('{p['version_id']}'::uuid,'{p['item_id']}'::uuid,'{p['topic']}','{p['skill']}','{p['status']}','{p['tier']}','{TSV[p['pack']]}'::uuid)" for p in plan.values())
pk=",".join(f"('{k}','{PK[k]}'::uuid,'{TSV[k]}'::uuid)" for k in PK)
exc=",".join(f"'{k}'" for k in EXC)
nvar=len(VM)-len(EXC)
def sql(final):
    return f"""begin;
select pg_advisory_xact_lock(hashtext('cramapple-skill-cells-units13-20261003'));
create temporary table sp(version_id uuid,item_id uuid,topic text,skill text,status text,tier text,tsv uuid) on commit drop;
insert into sp values {sv};
create temporary table pk(pack text,pid uuid,tsv uuid) on commit drop;
insert into pk values {pk};
do $$ begin
 if (select count(*) from sp)<>{len(plan)} then raise exception 'seed plan rows'; end if;
 if exists (select 1 from sp join app.content_item_cells c on c.content_item_version_id=sp.version_id and c.skill_code is not null and c.superseded_by is null) then raise exception 'seed already has skill cell'; end if;
end $$;
create temporary table ins1 on commit drop as
select sp.*, gen_random_uuid() vd from sp join app.taxonomy_cells tc on tc.taxonomy_source_version=sp.tsv and tc.topic_code=sp.topic and tc.skill_code=sp.skill;
insert into app.content_item_cells (content_item_version_id,content_item_id,taxonomy_source_version,topic_code,skill_code,is_primary,assignment_status,source,model_run_id,validated_by,validated_at,validation_decision_id)
select version_id,item_id,tsv,topic,skill,false,status,'skill_units13_4voter_2026_10_03:'||tier,'skills-units13-2026-10-03 (4 voters: claude-opus-5, gpt-5.5, gemini-2.5-pro, gemini-3.8-flash; validated at >=3 of 4)',null,case when status='validated' then now() end,case when status='validated' then vd end from ins1;
create temporary table vm on commit drop as
select civ.id vversion, ci.id vitem, ci.content_key vkey, pk.pack, pk.pid, pk.tsv, pc.topic_code topic,
 replace(replace(regexp_replace(regexp_replace(ci.content_key,'-v[0-9]+$','','i'),'-sv-','-','i'),'-u1v-','-u1n-'),'-SV-','-') seed_key
from app.content_items ci join pk on pk.pid=ci.exam_pack_version_id
join app.content_item_versions civ on civ.content_item_id=ci.id and civ.status='published'
join app.content_item_cells pc on pc.content_item_version_id=civ.id and pc.is_primary and pc.superseded_by is null
join app.taxonomy_topics tt on tt.taxonomy_source_version=pc.taxonomy_source_version and tt.topic_code=pc.topic_code and tt.unit_number between 1 and 3
where ci.item_type='mcq' and ci.status='published' and ci.content_key ~* '[-_]v[0-9]+$' and ci.content_key not in ({exc})
and not exists (select 1 from app.content_item_cells c where c.content_item_version_id=civ.id and c.skill_code is not null and c.superseded_by is null);
do $$ begin if (select count(*) from vm)<>{nvar} then raise exception 'variant count % expected {nvar}', (select count(*) from vm); end if; end $$;
create temporary table ins2 on commit drop as
select vm.*, s.skill_code skill, s.assignment_status status, gen_random_uuid() vd
from vm join app.content_items si on si.exam_pack_version_id=vm.pid and si.content_key=vm.seed_key and si.status='published'
join app.content_item_versions sv on sv.content_item_id=si.id and sv.status='published'
join lateral (select c.skill_code,c.assignment_status from app.content_item_cells c where c.content_item_version_id=sv.id and c.skill_code is not null and c.superseded_by is null and c.is_primary=false and c.assignment_status in ('validated','provisional_model') order by c.created_at desc limit 1) s on true
join app.taxonomy_cells tc on tc.taxonomy_source_version=vm.tsv and tc.topic_code=vm.topic and tc.skill_code=s.skill_code;
insert into app.content_item_cells (content_item_version_id,content_item_id,taxonomy_source_version,topic_code,skill_code,is_primary,assignment_status,source,model_run_id,validated_by,validated_at,validation_decision_id)
select vversion,vitem,tsv,topic,skill,false,status,'skill_inherit_from_seed_2026_10_03:'||status,'skills-units13-2026-10-03 (variant inherits its seed skill)',null,case when status='validated' then now() end,case when status='validated' then vd end from ins2;
"""+final
rep="""do $$ declare m text; begin select format('seeds %s planned/%s written (%s validated, grid-invalid %s); variants %s in scope/%s written (%s validated); unwritten by pack: %s; unwritten seed keys: %s', (select count(*) from sp),(select count(*) from ins1),(select count(*) from ins1 where status='validated'),(select count(*) from sp)-(select count(*) from ins1),(select count(*) from vm),(select count(*) from ins2),(select count(*) from ins2 where status='validated'),(select string_agg(pack||':'||n,',') from (select pack,count(*) n from vm where vversion not in (select vversion from ins2) group by 1) z),(select string_agg(distinct seed_key,',') from vm where vversion not in (select vversion from ins2))) into m; raise exception 'REHEARSAL %', m; end $$;"""
open('write_rehearsal.sql','w').write(sql(rep+"\nrollback;"))
open('write_commit.sql','w').write(sql("commit;"))
print(len(plan),nvar)
