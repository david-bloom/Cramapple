-- AP Biology: retire 7 published seeded variants that use terms the CED does not name, 2026-10-03.   APPLIED to Production under APPROVAL-0091.
-- Why: the Product Owner ruled on 2026-10-01 that items stay within CED vocabulary, and on 2026-10-03: "some of the published ones use terms outside the CED.
-- We should retire them. We have enough questions." The 24 variants published under APPROVAL-0080 were checked before that ruling.
-- Rule used: full text (stimulus, stem, every choice and rationale) matched, case-insensitively, against terms confirmed ABSENT from the AP Biology CED V.1
-- text (clathrin, receptor-mediated, endosome, peripheral/integral protein, binary fission, 70S, 80S, signal peptide/sequence/SRP, chloramphenicol,
-- streptomycin, high-salt, impermeant, biotin, Triton, micelle, protease, aldohexose, ketohexose, isomer). Seven variants matched. APBIO-MCQ-SV-005-v3 also
-- contains "tripeptides" and is deliberately NOT retired: it is a generic label for three amino acids, not a separate concept.
-- Pattern: as in APPROVAL-0077 (Statistics retirements): item status and version status set to 'retired'. Nothing is deleted; labels, cells and review
-- records are left as they are. All seven have zero attempts, which this script asserts.

begin;
select pg_advisory_xact_lock(hashtext('cramapple-apbio-retire-out-of-ced-variants-20261003'));

create temporary table approval (ref text) on commit drop;
insert into approval values ('APPROVAL-0091');
do $$ begin if (select ref from approval) = 'PENDING' then raise exception 'not approved: enter the Product Owner approval reference above'; end if; end $$;

create temporary table target (content_key text primary key, terms text not null) on commit drop;
insert into target values
 ('APBIO-MCQ-SV-014-v1','70S, 80S ribosomes'),
 ('APBIO-MCQ-SV-014-v2','70S, 80S ribosomes'),
 ('APBIO-MCQ-SV-018-v1','receptor-mediated endocytosis'),
 ('APBIO-MCQ-SV-018-v3','receptor-mediated endocytosis'),
 ('APBIO-MCQ-SV-022-v1','70S ribosomes, binary fission'),
 ('APBIO-MCQ-SV-022-v3','70S, 80S ribosomes'),
 ('APBIO-MCQ-SV-023-v2','high-salt wash');

create temporary table touched (content_key text primary key, item_id uuid not null, version_id uuid not null) on commit drop;

do $$
declare n int; r record;
begin
  -- every target exists once, is a published item with exactly one published version, and has no attempts
  select count(*) into n from target t join app.content_items ci on ci.content_key=t.content_key and ci.item_type='mcq' and ci.status='published';
  if n<>7 then raise exception 'expected 7 published target items, found %', n; end if;
  insert into touched
    select t.content_key, ci.id, civ.id
    from target t join app.content_items ci on ci.content_key=t.content_key
    join app.content_item_versions civ on civ.content_item_id=ci.id and civ.status='published';
  select count(*) into n from touched; if n<>7 then raise exception 'expected 7 published versions, found %', n; end if;
  select count(*) into n from touched k where (select count(*) from public.attempts a where a.content_item_version_id=k.version_id)>0
     or (select count(*) from app.attempts a where a.content_item_version_id=k.version_id)>0;
  if n<>0 then raise exception '% target items have attempts; refusing to retire', n; end if;
end $$;

update app.content_item_versions civ set status='retired', updated_at=now() from touched k where civ.id=k.version_id;
update app.content_items ci set status='retired', updated_at=now() from touched k where ci.id=k.item_id;

do $$
declare n int;
begin
  select count(*) into n from touched k join app.content_items ci on ci.id=k.item_id join app.content_item_versions civ on civ.id=k.version_id
   where ci.status='retired' and civ.status='retired';
  if n<>7 then raise exception 'expected 7 retired, got %', n; end if;
  -- the other 17 published variants are untouched
  select count(*) into n from app.content_items where content_key ilike 'apbio-mcq-sv-%' and status='published';
  if n<>17 then raise exception 'expected 17 published variants left, got %', n; end if;
  select count(*) into n from app.content_items where content_key ilike 'apbio-mcq-sv-%' and status not in ('published','retired');
  if n<>0 then raise exception '% variants in an unexpected status', n; end if;
end $$;

select jsonb_build_object('retired',(select count(*) from touched),'variants_still_published',(select count(*) from app.content_items where content_key ilike 'apbio-mcq-sv-%' and status='published')) as result;
commit;
