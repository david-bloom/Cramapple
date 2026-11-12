begin;
select pg_advisory_xact_lock(hashtext('cramapple-apcalcbc-u1b-2026-11-12-publish-20261112'));
create temporary table lab (content_key text primary key, topic text, exp_hash text) on commit drop;
insert into lab values
('apcalcbc-mcq-b7-h-1.9-a','1.9','21c84d7a726406892ed47e426952fefc'),
('apcalcbc-mcq-b7-sv-h-1.9-a-v1','1.9','fa5777c5f3a4508599c3a3ed1d1c8f3c'),
('apcalcbc-mcq-b7-sv-h-1.9-a-v2','1.9','68209eca29ac1b85525e445753b7b2ac'),
('apcalcbc-mcq-b7-sv-h-1.9-a-v3','1.9','5d8dcaa5d41b40811e3d908105f02221'),
('apcalcbc-mcq-b7-h-1.9-b','1.9','0c10ee669c9387b39df5f207ae84955a'),
('apcalcbc-mcq-b7-sv-h-1.9-b-v1','1.9','9e4d527913280b101749acfb45ed0d5b'),
('apcalcbc-mcq-b7-sv-h-1.9-b-v2','1.9','70fa682766f68d670a7b8166e4dcf268'),
('apcalcbc-mcq-b7-sv-h-1.9-b-v3','1.9','50c42fe7e1703a47401248335dab25a9'),
('apcalcbc-mcq-b7-h-1.10-a','1.10','399469290c04ceb17f9e21ae57001280'),
('apcalcbc-mcq-b7-sv-h-1.10-a-v1','1.10','fa3ff7e29947189955feb1a8f36a5f01'),
('apcalcbc-mcq-b7-sv-h-1.10-a-v2','1.10','791097e6af5dc99db3601eb5bdb2066c'),
('apcalcbc-mcq-b7-sv-h-1.10-a-v3','1.10','31fd43623fa74d8776eb8908bc6c5612'),
('apcalcbc-mcq-b7-h-1.10-b','1.10','d00987acd0085511678f476c0e65b6a0'),
('apcalcbc-mcq-b7-sv-h-1.10-b-v1','1.10','191b332909de25f0c1baf6093796c42a'),
('apcalcbc-mcq-b7-sv-h-1.10-b-v2','1.10','be99f2d42ad8c07d6a58b6f8dda03b4d'),
('apcalcbc-mcq-b7-sv-h-1.10-b-v3','1.10','83cf019dfd3d69151bea1ca94ec6cf28'),
('apcalcbc-mcq-b7-h-1.11-a','1.11','c5810b995510cf5402da2266aeb00c86'),
('apcalcbc-mcq-b7-sv-h-1.11-a-v1','1.11','614e3d999860f8d0136fa6b8848ae594'),
('apcalcbc-mcq-b7-sv-h-1.11-a-v2','1.11','1d431f45236f0bf466b2b1cf42508348'),
('apcalcbc-mcq-b7-sv-h-1.11-a-v3','1.11','8e7a52bb914d8e3d5374dd74f721d725'),
('apcalcbc-mcq-b7-h-1.11-b','1.11','32addf83b7b671c7a96a1961a60f6f4e'),
('apcalcbc-mcq-b7-sv-h-1.11-b-v1','1.11','edc6bfb666730ff4e3a539bee4eb1630'),
('apcalcbc-mcq-b7-sv-h-1.11-b-v2','1.11','adbd51b0244d5afdeed591fc4b36ab47'),
('apcalcbc-mcq-b7-sv-h-1.11-b-v3','1.11','a5abd51279a507c76e88300a3a40c3f5'),
('apcalcbc-mcq-b7-h-1.12-a','1.12','70e681a409129653d5b0ef45788798f3'),
('apcalcbc-mcq-b7-sv-h-1.12-a-v1','1.12','914f4d20c87af0cee00c13ac56f82b10'),
('apcalcbc-mcq-b7-sv-h-1.12-a-v2','1.12','dc436637ffd0abd0df59e1a44d6444c3'),
('apcalcbc-mcq-b7-sv-h-1.12-a-v3','1.12','b45c60279a4ba01bb3978409aa4301d7'),
('apcalcbc-mcq-b7-h-1.12-b','1.12','2fbd3342137cdda3c1cbb9de70a27442'),
('apcalcbc-mcq-b7-sv-h-1.12-b-v1','1.12','a2c6ee1bdba002512dc68637e767e2af'),
('apcalcbc-mcq-b7-sv-h-1.12-b-v2','1.12','60210f4d6a95f195522cf8ccab640b38'),
('apcalcbc-mcq-b7-sv-h-1.12-b-v3','1.12','2654e76e5f2fa5b7e83619c8372cf714'),
('apcalcbc-mcq-b7-h-1.13-a','1.13','053b3fa66a334e432fd5a59da2ee0ca3'),
('apcalcbc-mcq-b7-sv-h-1.13-a-v1','1.13','8abc55832a3ce3b9c9b9a91dadfc3ad7'),
('apcalcbc-mcq-b7-sv-h-1.13-a-v2','1.13','02266383636946900c871b5f78e2aac3'),
('apcalcbc-mcq-b7-sv-h-1.13-a-v3','1.13','8402eeb2447990cc6ac002201f2f711f'),
('apcalcbc-mcq-b7-h-1.13-b','1.13','fe2ddeb510e8a1a9bd35626c18537295'),
('apcalcbc-mcq-b7-sv-h-1.13-b-v1','1.13','6546886a762ec4468029d23eb96c762f'),
('apcalcbc-mcq-b7-sv-h-1.13-b-v2','1.13','00caa81bc54a747588729b19f21c182b'),
('apcalcbc-mcq-b7-sv-h-1.13-b-v3','1.13','78f35b7a25d3d0eac3f6c39fb83ea332'),
('apcalcbc-mcq-b7-h-1.14-a','1.14','e5e66deb53f20623c472dcce79c8dc48'),
('apcalcbc-mcq-b7-sv-h-1.14-a-v1','1.14','c2d627776a67ad75a5b0372f5a2e3f24'),
('apcalcbc-mcq-b7-sv-h-1.14-a-v2','1.14','77f7fa2bc83757337a600e020b519c54'),
('apcalcbc-mcq-b7-sv-h-1.14-a-v3','1.14','ff51c4f679dca8386d6c39fdaa30456d'),
('apcalcbc-mcq-b7-h-1.14-b','1.14','387c40b640781842dc6c9444e72a7783'),
('apcalcbc-mcq-b7-sv-h-1.14-b-v1','1.14','5aa8f71d32fb39db5c364263396c078a'),
('apcalcbc-mcq-b7-sv-h-1.14-b-v2','1.14','09d58ddde6e8d1f2a96a2ce78dcb2200'),
('apcalcbc-mcq-b7-sv-h-1.14-b-v3','1.14','2d6e7d460c457b9e7c684030219c9e40'),
('apcalcbc-mcq-b7-h-1.15-a','1.15','1acc59335ac7af73038e8f39e2636500'),
('apcalcbc-mcq-b7-sv-h-1.15-a-v1','1.15','39387f511ee48ae01ac7d7189d80ecc2'),
('apcalcbc-mcq-b7-sv-h-1.15-a-v2','1.15','a884eab8b6f73031c8224d60f4cbce97'),
('apcalcbc-mcq-b7-sv-h-1.15-a-v3','1.15','179134395d32bcd99c55010def9b9891'),
('apcalcbc-mcq-b7-h-1.15-b','1.15','286ba0df06ca9375f3a57d278ef2d702'),
('apcalcbc-mcq-b7-sv-h-1.15-b-v1','1.15','8ca345b3d0b6dc7d45f6c88dca97f33c'),
('apcalcbc-mcq-b7-sv-h-1.15-b-v2','1.15','7a723aad9046b317449bcfdac5612b23'),
('apcalcbc-mcq-b7-sv-h-1.15-b-v3','1.15','5ce37524d2591168a3bb4de84f1cf518'),
('apcalcbc-mcq-b7-h-1.16-a','1.16','db1a686d03de15de6933dd0403f1e4f4'),
('apcalcbc-mcq-b7-sv-h-1.16-a-v1','1.16','6c8861fec405b5955d59adb2398ebd88'),
('apcalcbc-mcq-b7-sv-h-1.16-a-v2','1.16','248a7efbbd9fd7aee449fe307c29d125'),
('apcalcbc-mcq-b7-sv-h-1.16-a-v3','1.16','0122c5185675ad751003e086d39b613e'),
('apcalcbc-mcq-b7-h-1.16-b','1.16','6fdc8f28cce0187febe7d04ec523d217'),
('apcalcbc-mcq-b7-sv-h-1.16-b-v1','1.16','3b050b42a01d727cd14e5e7086c9a36d'),
('apcalcbc-mcq-b7-sv-h-1.16-b-v2','1.16','504f3d1c450cd8d1f6d279ffb9001f86'),
('apcalcbc-mcq-b7-sv-h-1.16-b-v3','1.16','44a7d584f10b751a134d367966208199');
create temporary table tgt on commit drop as
select l.*, ci.id item_id, civ.id version_id, gen_random_uuid() assignment_id, gen_random_uuid() label_id, gen_random_uuid() vd_id,
 'ab088009-dc9a-4f93-8824-803e1913505b'::uuid tsv, (case topic when '1.1' then array[1] when '1.10' then array[1] when '1.11' then array[1] when '1.12' then array[1] when '1.13' then array[1] when '1.14' then array[1] when '1.15' then array[1] when '1.16' then array[1] when '1.2' then array[1] when '1.3' then array[1] when '1.4' then array[1] when '1.5' then array[1] when '1.6' then array[1] when '1.7' then array[1] when '1.8' then array[1] when '1.9' then array[1] end)::int[] req, 1 pu
from lab l join app.content_items ci on ci.content_key=l.content_key and ci.exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27'
join app.content_item_versions civ on civ.content_item_id=ci.id and civ.version_num=1
where ci.status='draft' and civ.status='draft';
do $$ begin
 if (select count(*) from tgt)<>64 then raise exception 'expected 64 draft targets, got %', (select count(*) from tgt); end if;
 if exists (select 1 from tgt where split_part(topic,'.',1)::int<>pu) then raise exception 'topic/unit mismatch'; end if;
 if exists (select 1 from tgt t join app.content_item_cells c on c.content_item_version_id=t.version_id) or exists (select 1 from tgt t join app.content_taxonomy_labels l on l.content_item_id=t.item_id) then raise exception 'a target already has cells or labels'; end if;
 if (select count(*) from (select t.content_key from tgt t join app.content_item_versions civ on civ.id=t.version_id join app.mcq_choices c on c.content_item_version_id=civ.id group by t.content_key, civ.stem, t.exp_hash having md5(civ.stem||'|'||string_agg(c.choice_key||':'||c.choice_text||':'||c.is_correct::text||':'||c.rationale,'|' order by c.choice_key))=t.exp_hash) z)<>64 then raise exception 'loaded text does not match the build manifest'; end if;
 if exists (select 1 from tgt t where not exists (select 1 from app.taxonomy_topics tt where tt.taxonomy_source_version=t.tsv and tt.topic_code=t.topic)) then raise exception 'a topic code is not present in the taxonomy source version'; end if;
end $$;
insert into app.content_review_assignments (content_review_assignment_id, content_item_version_id, reviewer_id, review_stage, review_kind, status, assignment_purpose, created_by)
select assignment_id, version_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'tutor_question', 'mcq', 'pending', 'owner_remediation_approval', 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid from tgt;
insert into app.content_review_decisions (content_review_assignment_id, content_item_version_id, reviewer_id, review_stage, tutor_score, difficulty_label, diagnostic_flag, concern_codes, note, tutor_decision, decision_payload, decision_hash, created_by)
select assignment_id, version_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'tutor_question', 1, null, false, array[]::text[],
 'AP Calculus BC Unit 3 harder seeds and variants (batch apcalcbc_u1b_2026_11_12): Product Owner review of owner-session-authored drafts, 2026-11-12. Arithmetic verified in Python; no model-checker pass, by Product Owner decision.',
 'approve',
 jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apcalcbc_u1b_2026_11_12_po_approval','qa_date','2026-11-12','content_key',content_key),
 md5(jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apcalcbc_u1b_2026_11_12_po_approval','qa_date','2026-11-12','content_key',content_key)::text),
 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid from tgt;
create temporary table qa_blocked on commit drop as
select g.content_key, case
 when nullif(trim(civ.stem),'') is null then 'blank stem'
 when (select count(*) from app.mcq_choices m where m.content_item_version_id=civ.id)<>4 then 'choice count'
 when (select count(distinct lower(trim(m.choice_text))) from app.mcq_choices m where m.content_item_version_id=civ.id)<>4 then 'duplicate choice text'
 when (select count(*) from app.mcq_choices m where m.content_item_version_id=civ.id and m.is_correct)<>1 then 'correct key count'
 when exists (select 1 from app.mcq_choices m where m.content_item_version_id=civ.id and nullif(trim(coalesce(m.rationale,'')),'') is null) then 'blank rationale'
 when civ.canonical_answer_1 is distinct from (select m.choice_key from app.mcq_choices m where m.content_item_version_id=civ.id and m.is_correct) then 'canonical letter mismatch'
 end reason
from tgt g join app.content_item_versions civ on civ.id=g.version_id;
delete from qa_blocked where reason is null;
do $$ begin if exists (select 1 from qa_blocked) then raise exception 'structural QA blocked: %', (select string_agg(content_key||':'||reason, ', ') from qa_blocked); end if; end $$;
update app.content_item_versions civ set status='reviewed_approved', review_status='question_review_approved', approved_by='f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, approved_at=coalesce(civ.approved_at,now()), updated_at=now() from tgt where civ.id=tgt.version_id;
update app.content_items ci set status='reviewed_approved', updated_at=now() from tgt where ci.id=tgt.item_id;
insert into app.content_taxonomy_labels (content_taxonomy_label_id, content_item_id, label_version, label_scope, required_units, max_required_unit, primary_unit, assessed_topics, taxonomy_source_version, taxonomy_confidence, label_status, source, source_payload, model_run_id, created_by)
select label_id, item_id, 1, 'serving', req, 1, pu, array[]::text[], tsv, 'provisional', 'provisional_model',
 'apcalcbc_u1b_2026_11_12',
 jsonb_build_object('origin','owner_authored','units_source','AP Calculus BC Unit 1 (topics 1.x belong to unit 3; required_units set per topic from existing Unit 3 labels)','topic',topic,'report','scripts/content-seed/apchem-harder-seeds-u3-2026-11-12'),
 'apcalcbc-u1b-2026-11-12-labeling', 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid from tgt;
insert into app.content_taxonomy_validation_decisions (validation_decision_id, content_taxonomy_label_id, decided_by, decision, decision_source, reviewed_primary_unit, reviewed_required_units, notes)
select vd_id, label_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'confirmed', 'chat_review', pu, req,
 'Product Owner chat instruction 2026-11-12 (AP Calculus BC harder seeds and variants). Topic assigned by the author from the question design (topic recorded on the cell); topic-only tagging, skill left null.' from tgt;
insert into app.content_item_cells (content_item_version_id, content_item_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id, validated_by, validated_at, validation_decision_id)
select version_id, item_id, tsv, topic, null, true, 'validated', 'apcalcbc_u1b_2026_11_12_topic',
 'apcalcbc-u1b-2026-11-12-labeling (topic set by the author from the question design)', null, now(), gen_random_uuid() from tgt;
update app.content_taxonomy_labels l set label_status='validated', validated_by='f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, validated_at=now(), validation_decision_id=t.vd_id, validated_against_version_id=t.version_id, validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id) from tgt t where l.content_taxonomy_label_id=t.label_id;
update app.content_item_versions civ set status='published', published_at=coalesce(civ.published_at,now()), updated_at=now() from tgt where civ.id=tgt.version_id;
update app.content_items ci set status='published', updated_at=now() from tgt where ci.id=tgt.item_id;
do $$ declare n int; begin
  select count(*) into n from (select content_item_id from app.content_item_versions where status='published' group by 1 having count(*)>1) d; if n<>0 then raise exception 'duplicate published versions: %', n; end if;
  if (select count(*) from app.content_items ci join tgt on tgt.item_id=ci.id where ci.status='published')<>64 then raise exception 'publish count mismatch'; end if;
  select count(*) into n from app.content_taxonomy_labels l join tgt t on t.item_id=l.content_item_id where l.label_scope='serving' and l.superseded_by is null and l.label_status='validated' and l.validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id); if n<>64 then raise exception 'label post-check %', n; end if;
  select count(*) into n from app.content_item_cells where source='apcalcbc_u1b_2026_11_12_topic' and is_primary and superseded_by is null; if n<>64 then raise exception 'topic cell count %', n; end if;
end $$;
do $$ begin raise exception 'REHEARSAL OK (rolled back): published=%, validated_labels=%, topic_cells=%', (select count(*) from tgt), (select count(*) from app.content_taxonomy_labels where source='apcalcbc_u1b_2026_11_12' and label_status='validated'), (select count(*) from app.content_item_cells where source='apcalcbc_u1b_2026_11_12_topic'); end $$;
rollback;
