begin;
select pg_advisory_xact_lock(hashtext('cramapple-task0065-seed-pilot-bio-u1-publish-20261007'));
create temporary table lab (content_key text primary key, kind text, seed_key text, topic text, skill text, skill_status text,
  difficulty text, exp_hash text, diff_tally text, skill_tally text) on commit drop;
insert into lab values
('APBIO-MCQ-101','seed','APBIO-MCQ-101','1.1','1.C','validated','Medium','f91c9840cfb8e7ea21f918141dfc0b2a','[["Medium", 4]]','[["1.C", 4]]'),
('APBIO-MCQ-SV-101-v1','variant','APBIO-MCQ-101','1.1','1.C','validated','Medium','8f778b846a53b04e6b8c597a666eb2f2','[["Medium", 4]]','[["1.C", 4]]'),
('APBIO-MCQ-SV-101-v2','variant','APBIO-MCQ-101','1.1','1.C','validated','Medium','237a1d1ee883704963bcac6a93fb2e7e','[["Medium", 4]]','[["1.C", 4]]'),
('APBIO-MCQ-SV-101-v3','variant','APBIO-MCQ-101','1.1','1.C','validated','Medium','528e4174ae32f9ea2e1923a85bd57c13','[["Medium", 4]]','[["1.C", 4]]'),
('APBIO-MCQ-102','seed','APBIO-MCQ-102','1.1','6.D','provisional_model','Medium','1fd9341208f841327a89a096cbce246e','[["Medium", 4]]','[["6.D", 2], ["6.B", 1], ["1.C", 1]]'),
('APBIO-MCQ-SV-102-v1','variant','APBIO-MCQ-102','1.1','6.D','provisional_model','Medium','de2e2bdb76775aa7b45bf0c382875a75','[["Medium", 4]]','[["6.D", 2], ["6.B", 1], ["1.C", 1]]'),
('APBIO-MCQ-SV-102-v2','variant','APBIO-MCQ-102','1.1','6.D','provisional_model','Medium','0ccb51efb099e195ec26f12caf27cd6a','[["Medium", 4]]','[["6.D", 2], ["6.B", 1], ["1.C", 1]]'),
('APBIO-MCQ-SV-102-v3','variant','APBIO-MCQ-102','1.1','6.D','provisional_model','Medium','8a74a2d4e5544cbfe160426b94f8072d','[["Medium", 4]]','[["6.D", 2], ["6.B", 1], ["1.C", 1]]'),
('APBIO-MCQ-103','seed','APBIO-MCQ-103','1.1','6.E','validated','Medium','4932880b0d2111999784dfc7b9753e5d','[["Medium", 2], ["Hard", 2]]','[["6.E", 3], ["3.B", 1]]'),
('APBIO-MCQ-SV-103-v1','variant','APBIO-MCQ-103','1.1','6.E','validated','Medium','490a67696bb91759ecf007e7e1a87b5f','[["Medium", 2], ["Hard", 2]]','[["6.E", 3], ["3.B", 1]]'),
('APBIO-MCQ-SV-103-v3','variant','APBIO-MCQ-103','1.1','6.E','validated','Medium','aba7e67de841917b332f0114c94e4e5b','[["Medium", 2], ["Hard", 2]]','[["6.E", 3], ["3.B", 1]]'),
('APBIO-MCQ-104','seed','APBIO-MCQ-104','1.2',null,'none','Easy','56c686e02106536803b7919cbd69af9c','[["Easy", 2], ["Medium", 2]]','[["6.E", 2], ["1.C", 2]]'),
('APBIO-MCQ-SV-104-v1','variant','APBIO-MCQ-104','1.2',null,'none','Easy','f83e6936e11344426d89dbced56f9b13','[["Easy", 2], ["Medium", 2]]','[["6.E", 2], ["1.C", 2]]'),
('APBIO-MCQ-SV-104-v2','variant','APBIO-MCQ-104','1.2',null,'none','Easy','06803a8aa8d513311aeae68425f9963d','[["Easy", 2], ["Medium", 2]]','[["6.E", 2], ["1.C", 2]]'),
('APBIO-MCQ-SV-104-v3','variant','APBIO-MCQ-104','1.2',null,'none','Easy','fe23bc88bcc11d1abb1eea9f46af5ec3','[["Easy", 2], ["Medium", 2]]','[["6.E", 2], ["1.C", 2]]'),
('APBIO-MCQ-105','seed','APBIO-MCQ-105','1.2','3.C','validated','Medium','0738a43b741ac96dff4b6f25194c10b7','[["Medium", 4]]','[["3.C", 4]]'),
('APBIO-MCQ-SV-105-v2','variant','APBIO-MCQ-105','1.2','3.C','validated','Medium','a35525e9be3e540136c869570b0fc670','[["Medium", 4]]','[["3.C", 4]]'),
('APBIO-MCQ-SV-105-v3','variant','APBIO-MCQ-105','1.2','3.C','validated','Medium','0df0cd5bd7553db13de5e0da2ff9810b','[["Medium", 4]]','[["3.C", 4]]'),
('APBIO-MCQ-106','seed','APBIO-MCQ-106','1.2','6.E','validated','Medium','2fd931a7d2d2266499b7dc6420e74516','[["Medium", 4]]','[["6.E", 4]]'),
('APBIO-MCQ-SV-106-v1','variant','APBIO-MCQ-106','1.2','6.E','validated','Medium','1ee92ea456ddd5f9c56258b3c59d3533','[["Medium", 4]]','[["6.E", 4]]'),
('APBIO-MCQ-SV-106-v2','variant','APBIO-MCQ-106','1.2','6.E','validated','Medium','c062072fdb195c79248816ce27851132','[["Medium", 4]]','[["6.E", 4]]'),
('APBIO-MCQ-SV-106-v3','variant','APBIO-MCQ-106','1.2','6.E','validated','Medium','20987dfe83d637a7b363d6553e42e8cf','[["Medium", 4]]','[["6.E", 4]]'),
('APBIO-MCQ-107','seed','APBIO-MCQ-107','1.3','1.B','validated','Easy','1fba6e7f12cf97a5af4740e7efb9c745','[["Easy", 4]]','[["1.B", 4]]'),
('APBIO-MCQ-SV-107-v1','variant','APBIO-MCQ-107','1.3','1.B','validated','Easy','9753ccdb25372a796c9f331482505c6d','[["Easy", 4]]','[["1.B", 4]]'),
('APBIO-MCQ-SV-107-v2','variant','APBIO-MCQ-107','1.3','1.B','validated','Easy','918d1dc9f83d1c7a03b4e22fd32846a5','[["Easy", 4]]','[["1.B", 4]]'),
('APBIO-MCQ-SV-107-v3','variant','APBIO-MCQ-107','1.3','1.B','validated','Easy','1ea19f001e824113254f7e1cd7d82faf','[["Easy", 4]]','[["1.B", 4]]'),
('APBIO-MCQ-108','seed','APBIO-MCQ-108','1.3','4.B','validated','Medium','152b189934eb00004c58016d8d2381c3','[["Medium", 4]]','[["4.B", 3], ["6.D", 1]]'),
('APBIO-MCQ-SV-108-v1','variant','APBIO-MCQ-108','1.3','4.B','validated','Medium','2a901013d803dc4f1c1923abcdc1f491','[["Medium", 4]]','[["4.B", 3], ["6.D", 1]]'),
('APBIO-MCQ-SV-108-v2','variant','APBIO-MCQ-108','1.3','4.B','validated','Medium','d87dc4e7f1e7efbf9be04e700958b99e','[["Medium", 4]]','[["4.B", 3], ["6.D", 1]]'),
('APBIO-MCQ-SV-108-v3','variant','APBIO-MCQ-108','1.3','4.B','validated','Medium','dc210059122160d563e979f9152a302a','[["Medium", 4]]','[["4.B", 3], ["6.D", 1]]'),
('APBIO-MCQ-109','seed','APBIO-MCQ-109','1.3','6.E','validated','Medium','90f9fbd4bc33faab09bb2d0b5290fa43','[["Medium", 2], ["Hard", 2]]','[["6.E", 3], ["1.C", 1]]'),
('APBIO-MCQ-SV-109-v1','variant','APBIO-MCQ-109','1.3','6.E','validated','Medium','6fc1337e2010e2ff34194fa14e5fd551','[["Medium", 2], ["Hard", 2]]','[["6.E", 3], ["1.C", 1]]'),
('APBIO-MCQ-SV-109-v2','variant','APBIO-MCQ-109','1.3','6.E','validated','Medium','4de9061360e9d4fa74c3081b6d7fc4c2','[["Medium", 2], ["Hard", 2]]','[["6.E", 3], ["1.C", 1]]'),
('APBIO-MCQ-SV-109-v3','variant','APBIO-MCQ-109','1.3','6.E','validated','Medium','a44c00bca7d2458974f2c7110c3fdf59','[["Medium", 2], ["Hard", 2]]','[["6.E", 3], ["1.C", 1]]'),
('APBIO-MCQ-110','seed','APBIO-MCQ-110','1.4','1.C','validated','Medium','f98b494da5aa23475a3ff1f8339d6165','[["Medium", 4]]','[["1.C", 4]]'),
('APBIO-MCQ-SV-110-v1','variant','APBIO-MCQ-110','1.4','1.C','validated','Medium','95d0f559832cfcce3e2c8ea5afe6e395','[["Medium", 4]]','[["1.C", 4]]'),
('APBIO-MCQ-SV-110-v2','variant','APBIO-MCQ-110','1.4','1.C','validated','Medium','72931972c0376972496bc11a66be1ba9','[["Medium", 4]]','[["1.C", 4]]'),
('APBIO-MCQ-SV-110-v3','variant','APBIO-MCQ-110','1.4','1.C','validated','Medium','4a61a338fcb16373c9243ca0c3326fec','[["Medium", 4]]','[["1.C", 4]]'),
('APBIO-MCQ-111','seed','APBIO-MCQ-111','1.4','3.C','validated','Medium','7251459a194e62569ae676762515c380','[["Medium", 4]]','[["3.C", 4]]'),
('APBIO-MCQ-SV-111-v1','variant','APBIO-MCQ-111','1.4','3.C','validated','Medium','78df87affe2eca023c3d5a9f2d590ac7','[["Medium", 4]]','[["3.C", 4]]'),
('APBIO-MCQ-SV-111-v2','variant','APBIO-MCQ-111','1.4','3.C','validated','Medium','6a6dd1f0bf2e31d086c2db06f7652880','[["Medium", 4]]','[["3.C", 4]]'),
('APBIO-MCQ-SV-111-v3','variant','APBIO-MCQ-111','1.4','3.C','validated','Medium','daa1b65908f9be00f8956f0554468321','[["Medium", 4]]','[["3.C", 4]]'),
('APBIO-MCQ-112','seed','APBIO-MCQ-112','1.4','6.E','validated','Medium','1eeb4b0d796ce1a68129366945e642c4','[["Medium", 4]]','[["6.E", 4]]'),
('APBIO-MCQ-SV-112-v1','variant','APBIO-MCQ-112','1.4','6.E','validated','Medium','d9e083f71e6683117bd212f8e4530793','[["Medium", 4]]','[["6.E", 4]]'),
('APBIO-MCQ-SV-112-v2','variant','APBIO-MCQ-112','1.4','6.E','validated','Medium','8998d6d5666b919360ed63ec6f90f70a','[["Medium", 4]]','[["6.E", 4]]'),
('APBIO-MCQ-SV-112-v3','variant','APBIO-MCQ-112','1.4','6.E','validated','Medium','01a7212567b26377dd87bfca61d6ce98','[["Medium", 4]]','[["6.E", 4]]'),
('APBIO-MCQ-113','seed','APBIO-MCQ-113','1.5','1.B','validated','Medium','a7f23a4058f190d1ee9edc11984b31e6','[["Medium", 4]]','[["1.B", 4]]'),
('APBIO-MCQ-SV-113-v1','variant','APBIO-MCQ-113','1.5','1.B','validated','Medium','87b761d23b8a66318f49650c1a4551ed','[["Medium", 4]]','[["1.B", 4]]'),
('APBIO-MCQ-SV-113-v2','variant','APBIO-MCQ-113','1.5','1.B','validated','Medium','aae098989728575a9c1fe4ca72d0d046','[["Medium", 4]]','[["1.B", 4]]'),
('APBIO-MCQ-SV-113-v3','variant','APBIO-MCQ-113','1.5','1.B','validated','Medium','d4742dfe0aad7f19c81661c5bf4243f3','[["Medium", 4]]','[["1.B", 4]]'),
('APBIO-MCQ-114','seed','APBIO-MCQ-114','1.5',null,'none','Medium','466b674790c38f56e6e07f1315c6ebf7','[["Medium", 4]]','[["6.B", 1], ["6.D", 1], ["6.C", 1], ["4.B", 1]]'),
('APBIO-MCQ-SV-114-v1','variant','APBIO-MCQ-114','1.5',null,'none','Medium','efc91e773eb99ddc2ba7b51689adddb0','[["Medium", 4]]','[["6.B", 1], ["6.D", 1], ["6.C", 1], ["4.B", 1]]'),
('APBIO-MCQ-SV-114-v2','variant','APBIO-MCQ-114','1.5',null,'none','Medium','344c32bb5e9fb9d8939ffb892c3bc183','[["Medium", 4]]','[["6.B", 1], ["6.D", 1], ["6.C", 1], ["4.B", 1]]'),
('APBIO-MCQ-SV-114-v3','variant','APBIO-MCQ-114','1.5',null,'none','Medium','618b74dd03988807e3f8c573d95c3497','[["Medium", 4]]','[["6.B", 1], ["6.D", 1], ["6.C", 1], ["4.B", 1]]'),
('APBIO-MCQ-115','seed','APBIO-MCQ-115','1.5','6.E','validated','Medium','3062e1d3f2d014de280086904cbad4b3','[["Medium", 3], ["Hard", 1]]','[["6.E", 4]]'),
('APBIO-MCQ-SV-115-v1','variant','APBIO-MCQ-115','1.5','6.E','validated','Medium','a805a39f508279a3a15f0a8208a6df52','[["Medium", 3], ["Hard", 1]]','[["6.E", 4]]'),
('APBIO-MCQ-SV-115-v2','variant','APBIO-MCQ-115','1.5','6.E','validated','Medium','13f99b48ef6ecfcaae728d8a8249bcc7','[["Medium", 3], ["Hard", 1]]','[["6.E", 4]]'),
('APBIO-MCQ-SV-115-v3','variant','APBIO-MCQ-115','1.5','6.E','validated','Medium','ef006e03093ba3c49cfeeb886cf99fe8','[["Medium", 3], ["Hard", 1]]','[["6.E", 4]]'),
('APBIO-MCQ-116','seed','APBIO-MCQ-116','1.6','1.B','validated','Easy','cce301c3fb09916e970e7e2e5e9bb734','[["Easy", 2], ["Medium", 2]]','[["1.B", 4]]'),
('APBIO-MCQ-SV-116-v1','variant','APBIO-MCQ-116','1.6','1.B','validated','Easy','e5066da549166083804369fe2d589ab1','[["Easy", 2], ["Medium", 2]]','[["1.B", 4]]'),
('APBIO-MCQ-SV-116-v2','variant','APBIO-MCQ-116','1.6','1.B','validated','Easy','6d3ad6bcb1f2e8c11fc2ecee5aaec7b7','[["Easy", 2], ["Medium", 2]]','[["1.B", 4]]'),
('APBIO-MCQ-SV-116-v3','variant','APBIO-MCQ-116','1.6','1.B','validated','Easy','6a0ed7899fe0dc02c9ad9f73a197ccc8','[["Easy", 2], ["Medium", 2]]','[["1.B", 4]]'),
('APBIO-MCQ-117','seed','APBIO-MCQ-117','1.6','3.C','validated','Medium','708d420bec6328b88b8cdbfc55653e65','[["Medium", 4]]','[["3.C", 4]]'),
('APBIO-MCQ-SV-117-v1','variant','APBIO-MCQ-117','1.6','3.C','validated','Medium','511c14fa1fe30855ce123485c9a0e9ff','[["Medium", 4]]','[["3.C", 4]]'),
('APBIO-MCQ-SV-117-v2','variant','APBIO-MCQ-117','1.6','3.C','validated','Medium','20de09ec6f6e9a6685cfb47b54be7e00','[["Medium", 4]]','[["3.C", 4]]'),
('APBIO-MCQ-SV-117-v3','variant','APBIO-MCQ-117','1.6','3.C','validated','Medium','bf85d36eda496bc60da02c1601fe6b91','[["Medium", 4]]','[["3.C", 4]]'),
('APBIO-MCQ-118','seed','APBIO-MCQ-118','1.6','6.E','validated','Medium','a5df0f856ede42671c071f6d1fca4a7a','[["Medium", 3], ["Hard", 1]]','[["6.E", 3], ["1.B", 1]]'),
('APBIO-MCQ-SV-118-v1','variant','APBIO-MCQ-118','1.6','6.E','validated','Medium','b130bbf1206983951be69b653ecc5abd','[["Medium", 3], ["Hard", 1]]','[["6.E", 3], ["1.B", 1]]'),
('APBIO-MCQ-SV-118-v2','variant','APBIO-MCQ-118','1.6','6.E','validated','Medium','288fe6a1372b4a31347e54d18f4bf141','[["Medium", 3], ["Hard", 1]]','[["6.E", 3], ["1.B", 1]]'),
('APBIO-MCQ-SV-118-v3','variant','APBIO-MCQ-118','1.6','6.E','validated','Medium','1b448fbcaa668dabc6399e198ed05d53','[["Medium", 3], ["Hard", 1]]','[["6.E", 3], ["1.B", 1]]'),
('APBIO-MCQ-119','seed','APBIO-MCQ-119','1.7','1.C','provisional_model','Medium','562d8272e431fc92c5e7b1f7fb5d8880','[["Medium", 4]]','[["1.C", 2], ["1.B", 1], ["6.C", 1]]'),
('APBIO-MCQ-SV-119-v1','variant','APBIO-MCQ-119','1.7','1.C','provisional_model','Medium','d36e7f3d142be89bd3fe846244611345','[["Medium", 4]]','[["1.C", 2], ["1.B", 1], ["6.C", 1]]'),
('APBIO-MCQ-SV-119-v2','variant','APBIO-MCQ-119','1.7','1.C','provisional_model','Medium','944bb4aca6961dc192567d783f4e6482','[["Medium", 4]]','[["1.C", 2], ["1.B", 1], ["6.C", 1]]'),
('APBIO-MCQ-SV-119-v3','variant','APBIO-MCQ-119','1.7','1.C','provisional_model','Medium','42df77a8ef5e98fe2b51adb0094da124','[["Medium", 4]]','[["1.C", 2], ["1.B", 1], ["6.C", 1]]'),
('APBIO-MCQ-120','seed','APBIO-MCQ-120','1.7','6.D','validated','Medium','10181f96f58037a30d1b3cf59b18c284','[["Medium", 3], ["Hard", 1]]','[["6.D", 3], ["1.C", 1]]'),
('APBIO-MCQ-SV-120-v1','variant','APBIO-MCQ-120','1.7','6.D','validated','Medium','67803f462e637c349f382d136934674c','[["Medium", 3], ["Hard", 1]]','[["6.D", 3], ["1.C", 1]]'),
('APBIO-MCQ-SV-120-v2','variant','APBIO-MCQ-120','1.7','6.D','validated','Medium','aef4f0255c31fb7971c2368ecb613cc2','[["Medium", 3], ["Hard", 1]]','[["6.D", 3], ["1.C", 1]]'),
('APBIO-MCQ-SV-120-v3','variant','APBIO-MCQ-120','1.7','6.D','validated','Medium','eb9644eb63a568ff627cec21ef923d3b','[["Medium", 3], ["Hard", 1]]','[["6.D", 3], ["1.C", 1]]'),
('APBIO-MCQ-121','seed','APBIO-MCQ-121','1.7','6.E','validated','Medium','ad66150340b2b25be9fd6e22888617f8','[["Medium", 2], ["Hard", 2]]','[["6.E", 4]]'),
('APBIO-MCQ-SV-121-v1','variant','APBIO-MCQ-121','1.7','6.E','validated','Medium','d006dd20edc28f5dee69c2e933746168','[["Medium", 2], ["Hard", 2]]','[["6.E", 4]]'),
('APBIO-MCQ-SV-121-v2','variant','APBIO-MCQ-121','1.7','6.E','validated','Medium','b45df5f19cfc996690e95d65da1df428','[["Medium", 2], ["Hard", 2]]','[["6.E", 4]]'),
('APBIO-MCQ-SV-121-v3','variant','APBIO-MCQ-121','1.7','6.E','validated','Medium','92747fac2ca4e69cbe5ed0a339b1a0bb','[["Medium", 2], ["Hard", 2]]','[["6.E", 4]]');
create temporary table tgt on commit drop as
select l.*, ci.id item_id, civ.id version_id, gen_random_uuid() assignment_id, gen_random_uuid() label_id, gen_random_uuid() vd_id
from lab l join app.content_items ci on ci.content_key=l.content_key and ci.exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7'
join app.content_item_versions civ on civ.content_item_id=ci.id and civ.version_num=1
where ci.status='draft' and civ.status='draft';
do $$ begin
 if (select count(*) from tgt)<>82 then raise exception 'expected 82 draft targets, got %', (select count(*) from tgt); end if;
 if exists (select 1 from tgt t join app.content_item_cells c on c.content_item_version_id=t.version_id)
    or exists (select 1 from tgt t join app.content_taxonomy_labels l on l.content_item_id=t.item_id)
    or exists (select 1 from tgt t join app.content_item_difficulty d on d.content_item_version_id=t.version_id)
    or exists (select 1 from tgt t join app.content_review_assignments a on a.content_item_version_id=t.version_id)
   then raise exception 'a target already has cells, labels, difficulty or review rows'; end if;
 if exists (select 1 from tgt t where not exists (select 1 from app.taxonomy_topics tt where tt.taxonomy_source_version='c676d1fc-3b58-4896-89e3-852d9bd1f81b' and tt.topic_code=t.topic and tt.unit_number=1))
   then raise exception 'topic not in Unit 1 of taxonomy c676d1fc-3b58-4896-89e3-852d9bd1f81b'; end if;
 if exists (select 1 from tgt t where t.skill is not null and not exists (select 1 from app.taxonomy_cells tc where tc.taxonomy_source_version='c676d1fc-3b58-4896-89e3-852d9bd1f81b' and tc.topic_code=t.topic and tc.skill_code=t.skill))
   then raise exception 'skill not in the topic grid'; end if;
 if (select count(*) from (select t.content_key from tgt t join app.content_item_versions civ on civ.id=t.version_id join app.mcq_choices c on c.content_item_version_id=civ.id
     group by t.content_key, civ.stem, t.exp_hash having md5(civ.stem||'|'||string_agg(c.choice_key||':'||c.choice_text||':'||c.is_correct::text||':'||c.rationale,'|' order by c.choice_key))=t.exp_hash) z)<>82
   then raise exception 'loaded text does not match the build manifest'; end if;
end $$;
insert into app.content_review_assignments (content_review_assignment_id, content_item_version_id, reviewer_id, review_stage, review_kind, status, assignment_purpose, created_by)
select assignment_id, version_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'tutor_question', 'mcq', 'pending', 'owner_remediation_approval', 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid from tgt;
insert into app.content_review_decisions (content_review_assignment_id, content_item_version_id, reviewer_id, review_stage, tutor_score, difficulty_label, diagnostic_flag, concern_codes, note, tutor_decision, decision_payload, decision_hash, created_by)
select assignment_id, version_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'tutor_question', 1, null, false, array[]::text[],
 'AP Biology Unit 1 seed pilot (TASK-0065): publication on Product Owner chat instruction 2026-10-07 ("load the pilot''s 82 questions"), APPROVAL-0131; no human review per DECISION-0102. Generate-and-select (protocol v0.6 section 0, DECISION-0099): no hand edits; four non-author checker families (blind solve + rubric audit) plus own-family veto; 6/6 planted-defect controls; held-out judges found 0 defects in all 21 seeds and a 21-variant sample; every computable key recomputed.',
 'approve',
 jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','task0065_seed_pilot_po_approval','approval','APPROVAL-0131','qa_date','2026-10-07','content_key',content_key,'kind',kind,'seed',seed_key),
 md5(jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','task0065_seed_pilot_po_approval','approval','APPROVAL-0131','qa_date','2026-10-07','content_key',content_key,'kind',kind,'seed',seed_key)::text),
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
select label_id, item_id, 1, 'serving', array[1], 1, 1, array[]::text[], 'c676d1fc-3b58-4896-89e3-852d9bd1f81b'::uuid, 'provisional', 'provisional_model', 'task0065_seed_pilot_bio_u1_2026_10_07',
 jsonb_build_object('origin', kind, 'seed', seed_key, 'topic', topic, 'units_source', 'designated Unit 1 topic; four non-author checkers passed the on_topic rule', 'report', 'scripts/content-seed/task0065-seed-pilot-bio-u1-2026-10-07'),
 'task0065-seed-pilot-bio-u1-2026-10-07 (APPROVAL-0131)', 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid from tgt;
insert into app.content_taxonomy_validation_decisions (validation_decision_id, content_taxonomy_label_id, decided_by, decision, decision_source, reviewed_primary_unit, reviewed_required_units, notes)
select vd_id, label_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'confirmed', 'automated_spot_check', 1, array[1],
 'Product Owner chat instruction 2026-10-07 (APPROVAL-0131). Item was generated for its designated Unit 1 topic and passed the on_topic rule with four non-author checker families; held-out judges placed every sampled item on its topic.' from tgt;
insert into app.content_item_cells (content_item_version_id, content_item_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id, validated_by, validated_at, validation_decision_id)
select version_id, item_id, 'c676d1fc-3b58-4896-89e3-852d9bd1f81b'::uuid, topic, null, true, 'validated', 'task0065_seed_pilot_bio_u1_2026_10_07:topic', 'task0065-seed-pilot-bio-u1-2026-10-07 (APPROVAL-0131): designated topic, four-family on_topic check', null, now(), gen_random_uuid() from tgt;
insert into app.content_item_cells (content_item_version_id, content_item_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id, validated_by, validated_at, validation_decision_id)
select version_id, item_id, 'c676d1fc-3b58-4896-89e3-852d9bd1f81b'::uuid, topic, skill, false, skill_status,
 'task0065_seed_pilot_bio_u1_2026_10_07:skill:'||case when kind='seed' then 'vote' else 'inherit' end,
 'task0065-seed-pilot-bio-u1-2026-10-07 (APPROVAL-0131): '||case when kind='seed' then 'four non-author families voted (validated at >=3 of 4); tally '||skill_tally else 'inherits seed '||seed_key||' (DECISION-0101)' end,
 null, case when skill_status='validated' then now() end, case when skill_status='validated' then gen_random_uuid() end
from tgt where skill is not null;
insert into app.content_item_difficulty (content_item_version_id, difficulty, basis, source_value, rationale, confidence, proposal_run)
select version_id, difficulty,
 case when kind='seed' then 'calibrated_judgement' else 'translated' end,
 case when kind='seed' then null else seed_key end,
 case when kind='seed' then 'Four non-author model families voted (Easy = single-fact recall; Medium = apply one concept or interpret given information; Hard = combine concepts or multi-step reasoning). Tally '||diff_tally||'. Provisional until recalibrated from student attempts (DECISION-0101).'
      else 'Inherited from seed '||seed_key||' (DECISION-0096).' end,
 'low', 'task0065_seed_pilot_bio_u1_2026_10_07'
from tgt;
update app.content_taxonomy_labels l set label_status='validated', validated_by='f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, validated_at=now(), validation_decision_id=t.vd_id, validated_against_version_id=t.version_id, validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id) from tgt t where l.content_taxonomy_label_id=t.label_id;
update app.content_item_versions civ set status='published', published_at=coalesce(civ.published_at,now()), updated_at=now() from tgt where civ.id=tgt.version_id;
update app.content_items ci set status='published', updated_at=now() from tgt where ci.id=tgt.item_id;
do $$ declare n int; begin
  select count(*) into n from (select content_item_id from app.content_item_versions where status='published' group by 1 having count(*)>1) d; if n<>0 then raise exception 'duplicate published versions: %', n; end if;
  if (select count(*) from app.content_items ci join tgt on tgt.item_id=ci.id where ci.status='published')<>82 then raise exception 'publish count mismatch'; end if;
  select count(*) into n from app.content_taxonomy_labels l join tgt t on t.item_id=l.content_item_id where l.label_scope='serving' and l.superseded_by is null and l.label_status='validated' and l.validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id); if n<>82 then raise exception 'label post-check %', n; end if;
  select count(*) into n from app.content_item_cells c join tgt t on t.version_id=c.content_item_version_id where c.is_primary and c.superseded_by is null and c.assignment_status='validated'; if n<>82 then raise exception 'topic cell count %', n; end if;
  select count(*) into n from app.content_item_cells c join tgt t on t.version_id=c.content_item_version_id where not c.is_primary and c.skill_code is not null and c.superseded_by is null; if n<>74 then raise exception 'skill cell count %', n; end if;
  select count(*) into n from app.content_item_difficulty d join tgt t on t.version_id=d.content_item_version_id; if n<>82 then raise exception 'difficulty count %', n; end if;
end $$;
commit;
