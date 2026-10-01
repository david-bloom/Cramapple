-- Serving-label carry-forward for the 11 items repaired by 20260930_apcalcab_037_key_and_distractor_rationale_repair.sql.   DRAFT -- NOT APPLIED.
--
-- Why: app.taxonomy_relevant_hash() covers the stem, canonical answers, every choice and every rationale, so the repair makes each
-- item's serving label stale (confirmed by a rolled-back run on Production, 2026-09-30: all 11 went 'stale', hash_fresh=false), and the
-- unit-gated selector requires label.validated_against_taxo_hash = taxonomy_relevant_hash(version). Until the label is re-pointed at the
-- new version the item is not served through unit gating.
--
-- What it does: for each repaired item, restores the label's PRIOR status (captured from Production on 2026-09-30, below) and re-points
-- validated_against_version_id / validated_against_taxo_hash at the new published version. Unit, topic and confidence are
-- NOT changed; validated_by / validated_at / validation_decision_id are restored to their ORIGINAL values (the repair's stale-marking trigger
-- nulls them; a 'validated' row requires all three). Nothing is re-labelled by a model.
--   * 5 items were 'validated' (026, 031, 037, 038, 080): carrying a human validation across a rationale/key-letter-only change is a
--     human validation act, so this file refuses to run until an approval reference is entered below (and recorded in APPROVALS_LOG).
--   * 5 items were 'provisional_model' (005, 007, 008, 016, np2-006): restored to provisional_model, re-pointed.
--   * 030 was 'provisional_model' with no hash at all (never gate-fresh): restored to provisional_model, pointers untouched.
-- Run immediately after the repair script, same sitting, so the window in which these 11 items are unserved is seconds.
-- 031 is the only item whose choice text changed; its unit/topic labels are unaffected (same skill, same error-pattern distractors).

begin;
select pg_advisory_xact_lock(hashtext('cramapple-apcalcab-label-carry-forward-20260930'));

-- >>> EDIT THIS ONE LINE at apply time to the recorded Product Owner approval id; the guard below rejects 'PENDING'. <<<
create temporary table approval (ref text) on commit drop;
insert into approval values ('APPROVAL-0066');

do $$ begin
  if (select ref from approval) = 'PENDING' then
    raise exception 'label carry-forward is not approved: enter the Product Owner approval reference above';
  end if;
end $$;

-- prior_status and the ORIGINAL validation record, captured from Production 2026-09-30. The repair makes the stale-marking trigger null
-- validated_by / validated_at / validation_decision_id (a 'validated' row requires all three), so they are restored from here.
create temporary table prior (content_key text primary key, prior_status text not null, repoint boolean not null,
  vby uuid, vat timestamptz, vdec uuid) on commit drop;
insert into prior values
('apcalcab-mcq-005','provisional_model',true,null,null,null),
('apcalcab-mcq-007','provisional_model',true,null,null,null),
('apcalcab-mcq-008','provisional_model',true,null,null,null),
('apcalcab-mcq-016','provisional_model',true,null,null,null),
('apcalcab-mcq-026','validated',true,'f5a26c6b-3566-4d58-9e97-979fbb947564','2026-09-26 23:33:19.426331+00','d3a115e1-1a0f-4d76-bbda-a89a54873797'),
('apcalcab-mcq-030','provisional_model',false,null,null,null),
('apcalcab-mcq-031','validated',true,'f5a26c6b-3566-4d58-9e97-979fbb947564','2026-09-27 18:45:34.988738+00','21f3abaa-47e1-42e3-9b5f-129e1dd16e1f'),
('apcalcab-mcq-037','validated',true,'f5a26c6b-3566-4d58-9e97-979fbb947564','2026-09-26 23:33:19.426331+00','608bd465-b7b0-41cd-b5ce-471e8ef14503'),
('apcalcab-mcq-038','validated',true,'f5a26c6b-3566-4d58-9e97-979fbb947564','2026-09-26 23:33:19.426331+00','ed10202e-cb34-4e4c-ab7d-2f74b6553d84'),
('apcalcab-mcq-080','validated',true,'f5a26c6b-3566-4d58-9e97-979fbb947564','2026-08-24 12:29:23.320786+00','b69c2d3b-baaa-4c91-bc0d-0a934556b28d'),
('apcalcab-mcq-np2-006','provisional_model',true,null,null,null);

do $$
declare n int;
begin
  -- the repair must already be applied: each item's published version carries the repair marker
  select count(*) into n from prior p join app.content_items ci on ci.content_key=p.content_key
    join app.content_item_versions civ on civ.content_item_id=ci.id and civ.status='published'
   where civ.prompt_json->>'qa_remediation' = '2026-09-30 distractor-rationale / key repair (seed audit)';
  if n<>11 then raise exception 'repair not applied to all 11 items (found %)', n; end if;
  -- only labels the repair itself made stale may be touched
  select count(*) into n from prior p join app.content_items ci on ci.content_key=p.content_key
    join app.content_taxonomy_labels l on l.content_item_id=ci.id and l.label_scope='serving' and l.superseded_by is null
   where l.label_status <> 'stale';
  if n<>0 then raise exception '% serving labels are not stale; refusing to overwrite them', n; end if;
end $$;

update app.content_taxonomy_labels l
set label_status = p.prior_status,
    validated_by = p.vby, validated_at = p.vat, validation_decision_id = p.vdec,
    validated_against_version_id = case when p.repoint then civ.id else l.validated_against_version_id end,
    validated_against_taxo_hash  = case when p.repoint then app.taxonomy_relevant_hash(civ.id) else l.validated_against_taxo_hash end,
    source_payload = l.source_payload || jsonb_build_object('carried_forward', jsonb_build_object(
        'from_version_id', l.validated_against_version_id,
        'to_version_id', civ.id,
        'reason', 'rationale/key-letter repair from the 2026-09-30 seed audit; unit and topic meaning unchanged; no relabelling',
        'approval_ref', (select ref from approval),
        'prior_status', p.prior_status))
from prior p
join app.content_items ci on ci.content_key = p.content_key
join app.content_item_versions civ on civ.content_item_id = ci.id and civ.status = 'published'
where l.content_item_id = ci.id and l.label_scope = 'serving' and l.superseded_by is null;

do $$
declare n int;
begin
  select count(*) into n from prior p join app.content_items ci on ci.content_key=p.content_key
    join app.content_item_versions civ on civ.content_item_id=ci.id and civ.status='published'
    join app.content_taxonomy_labels l on l.content_item_id=ci.id and l.label_scope='serving' and l.superseded_by is null
   where l.label_status <> p.prior_status
      or (p.repoint and (l.validated_against_version_id <> civ.id or l.validated_against_taxo_hash <> app.taxonomy_relevant_hash(civ.id)));
  if n<>0 then raise exception '% labels not restored/fresh after carry-forward', n; end if;
end $$;

select 'labels carried forward' metric, count(*)::text value from prior;
commit;
