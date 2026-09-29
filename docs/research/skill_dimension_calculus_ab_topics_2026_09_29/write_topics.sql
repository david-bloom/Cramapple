-- TASK-0050 topic pass — ap_calculus_ab. Run topics-ap_calculus_ab-20260929100918.
-- Generated 2026-09-29T10:09:18.484Z by scripts/taxonomy/label_topics_mcp.mjs. NOT APPLIED.
-- 119 topic assignments; 3 held and deliberately not written.
--
-- These are is_primary topic-only rows (skill_code NULL), the same shape AP
-- Biology's rows took in 20260927004600_biology_topic_labels_into_cells.sql.
-- assignment_status is provisional_model: this is an unratified AI proposal,
-- at the ~81-way granularity where two-model agreement was measured at 44%.
-- It should be reviewed before anything depends on it.

begin;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '5c8cf3ea-a8a1-4adf-9cfa-d0cbed53b489', 'ccbb330e-f818-4724-bf7b-60c6018bd234', tsv.taxonomy_source_version, '1.13', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select 'df768d80-958d-4e17-b2a2-22305782c444', 'e2a84e4f-f23c-4ae9-b575-19cef29ad511', tsv.taxonomy_source_version, '1.16', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '7ec98eda-c5cc-49e7-bc74-94a4f536de28', '167fb62c-b87f-4dda-abd0-1403229b885e', tsv.taxonomy_source_version, '4.2', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select 'c0b8c2a0-f872-43d0-bb82-9d53bf733004', '0d313626-3bbe-4b2e-a49d-fb2951c9aa8a', tsv.taxonomy_source_version, '4.6', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select 'd542b46a-b449-4392-b7e8-61dfb9695a0f', '4069df3a-e60c-4608-9e65-24a920e64b27', tsv.taxonomy_source_version, '3.2', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '0e2deaad-b54b-4dd4-8c97-44740438c879', 'ac8d8f22-0aa6-4964-84d6-122952d7b4a7', tsv.taxonomy_source_version, '3.3', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '214d4eff-6127-4912-bf1a-83e834e535d7', '80904015-b7ea-4c45-b191-d241adbf1dd1', tsv.taxonomy_source_version, '4.5', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select 'df752635-45b1-40e4-943c-3646fb92612e', 'e7e9660e-5b55-42d7-9e36-51543619ff35', tsv.taxonomy_source_version, '8.3', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select 'f907d9c0-1566-4a65-b517-c7c00f4088ab', 'f55d4dec-ca07-43e6-9f1e-70e4071b91e4', tsv.taxonomy_source_version, '5.4', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '95643329-f6b9-42da-9d99-5b4baf3e360e', 'f11dedde-a8f8-4ba7-bfaf-3aa9f00f2033', tsv.taxonomy_source_version, '5.5', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select 'eea3bca6-ae1c-4391-8fe1-ad17a42f5ef6', '7478fe56-2c66-4937-81c8-c2c805aff31a', tsv.taxonomy_source_version, '6.5', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '01c34035-2eb8-421b-b381-0242b744d0e0', '6702312d-cc97-461a-8d7b-624648420740', tsv.taxonomy_source_version, '6.9', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '7c81d666-c8cb-434a-9d78-de84f9640091', '69464ac8-38be-41b6-8cdb-903586c0cfce', tsv.taxonomy_source_version, '8.12', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:majority_earned'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '8a7d511b-f1f6-4282-90d8-ce020a14ff8a', '2d6b576b-9d00-4e8b-965e-a07be0d7033e', tsv.taxonomy_source_version, '8.3', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '87186a93-84c5-459e-afc8-19ffeaaa2a0e', '73db0cfd-c121-4af5-b19d-03bd7d735bec', tsv.taxonomy_source_version, '8.3', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:majority_earned'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '58fb6c98-f338-419b-b20e-221ae5be58c3', '8ae0c760-8a62-408f-b6a5-1b7b0c654707', tsv.taxonomy_source_version, '8.2', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '4bd85135-85cd-4497-b7e5-6c6ad1d3d365', 'b400a260-7a92-4b32-8844-3fdb491d8879', tsv.taxonomy_source_version, '5.9', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '4a9a9224-46c8-462e-a6a9-776444d19b16', 'f03b7434-56b4-41a8-b778-d65c95de86e5', tsv.taxonomy_source_version, '6.5', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:majority_earned'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '42a546e2-91f3-4540-a3ec-3ad7694116c5', '90a924a8-c427-4c8b-a53b-cc872045b83b', tsv.taxonomy_source_version, '5.5', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:majority_earned'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '7ab4a473-c60f-40a4-b233-03a744681775', 'c975c3ce-6e5b-4618-8ecc-776f750fbafc', tsv.taxonomy_source_version, '1.13', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:majority_earned'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '65bb373a-f882-4250-8a27-9c7cc2988a4e', 'b21ebb17-3823-41ad-bf55-4c68e9e3d8f3', tsv.taxonomy_source_version, '1.7', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '11394079-df37-4e0f-b694-954f825c22e4', '400885fa-5480-4b13-b26e-deb87d9fdfa0', tsv.taxonomy_source_version, '3.5', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '6ecd5eaa-cadb-42a9-98fb-f62619cf5b1c', 'cc8eda3b-0e8c-4a81-b0e0-095027262a64', tsv.taxonomy_source_version, '5.6', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:majority_earned'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '92983e13-86a3-461a-ad8d-c23781d960f0', '3af5ba83-b824-4d66-b2df-3292e77f272b', tsv.taxonomy_source_version, '3.2', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:majority_earned'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '89dd1429-bacb-45ae-89df-c50b9c1bacf3', 'f7aa944a-7b37-45df-8511-56034e77b483', tsv.taxonomy_source_version, '5.9', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '3a50d8f1-ece5-4616-8dea-9b617d4c0bbd', '7840c050-967d-4695-8391-b3aa82b98f76', tsv.taxonomy_source_version, '5.9', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '14433e93-5ea0-42c7-835a-b4ee7604e8d2', 'df787769-b4b9-4d3b-bb79-5a3557d0ebab', tsv.taxonomy_source_version, '5.11', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '1e9b78b0-7527-43b3-bc56-25bf58474978', 'b2aa5c0f-685d-4df3-8d4c-da1a46163e2a', tsv.taxonomy_source_version, '5.1', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '35259881-b82d-44fb-a695-97138d5204c5', 'ca81613d-ab96-43a7-9cc1-fb3ba8b68981', tsv.taxonomy_source_version, '6.4', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '00169869-dccc-4a71-b503-05fe4bd30cbf', 'b318d8fe-1b10-4ab7-a2e5-1cddd9ee8bdd', tsv.taxonomy_source_version, '7.7', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '17e93024-90a9-4bc1-8545-6db6197d8a86', 'cbee2cad-7e2c-4a80-a4a7-7328310a04f6', tsv.taxonomy_source_version, '8.11', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:majority_earned'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select 'a95005f3-24e1-42e3-838e-dadd13a98d9a', '8d5ec26d-648b-41a1-bfc3-e9bd7fb879f4', tsv.taxonomy_source_version, '4.5', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:majority_earned'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select 'b3437be9-f3e2-4a2a-a65f-c98e40efc53b', '2be7e655-9c90-42d4-ac84-59146fd84599', tsv.taxonomy_source_version, '4.6', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select 'b8949168-940f-4d6e-acce-c4e1d3a33ce4', '095a5088-1d13-463a-a8d5-73726adc81e2', tsv.taxonomy_source_version, '5.5', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '6e3e44b0-df1d-46e2-830a-892de867e183', '2aa9f09d-7d8f-446a-a687-1ed543858db7', tsv.taxonomy_source_version, '5.4', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '3b408456-55fb-4bf6-8d37-83262287eb67', 'c9bbae66-e509-49d4-8ca1-e029c41d2668', tsv.taxonomy_source_version, '6.5', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:majority_earned'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '43c7f774-8f58-419f-bbf4-de862cbebc62', 'dc1f2f7d-12ce-4735-be3d-c3fa85c802cd', tsv.taxonomy_source_version, '6.2', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '4b231412-00f2-4620-9d74-2d2c066c3842', 'e2434089-78b6-4091-8553-4664beef7549', tsv.taxonomy_source_version, '7.7', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '9261fb4a-a3df-4700-af2f-00c8e77d78f5', '72973fb2-f772-4729-b9cb-e21d6ba8650d', tsv.taxonomy_source_version, '7.8', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select 'c0eb4905-9a39-4719-9ea4-887cdc0d1086', '9803edbb-ed8a-439e-b71f-c29204dcf34c', tsv.taxonomy_source_version, '8.1', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select 'e5fb3817-7912-49fc-bc78-977598d6553a', 'ba1c6bef-a2ad-4f5b-97fc-a34a123d0e74', tsv.taxonomy_source_version, '8.12', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '45e20c35-6008-4db3-a6df-ecd3d4c1a780', '829f41f5-2804-4231-a111-9edb31cda154', tsv.taxonomy_source_version, '1.11', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '776d2398-e222-4068-ae3a-de315e7d4309', 'd0f2974c-bac9-498d-8173-8a1c88b3d8eb', tsv.taxonomy_source_version, '1.10', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:majority_earned'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '7720d16d-1102-47a1-a8f1-7b71d6153031', '594f8bc1-35a0-4a04-ac7f-f3835f40f96d', tsv.taxonomy_source_version, '2.3', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select 'e2cfa854-271d-4039-a6b7-85906918970f', 'f786dc8a-a3c4-497f-a271-24a2da334fcd', tsv.taxonomy_source_version, '1.6', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:majority_earned'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select 'd7d5d82e-4eee-4223-ad1c-ef55e3461567', '66c7e7de-16e7-4d06-a7ac-25e80a6d8f22', tsv.taxonomy_source_version, '1.10', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select 'e2f4abc1-67d9-4e5f-a7bc-12f34926f0bb', '2f5e9638-893a-42bc-8b31-8b316a216968', tsv.taxonomy_source_version, '2.3', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '8f556122-1c8c-4d70-ae52-ad650646169a', '7a8363c6-f70b-43a7-ae03-3f9943157edc', tsv.taxonomy_source_version, '2.6', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '0ff4a511-424a-43c5-ad4a-c2267fbebe01', 'fd460169-7f26-45b2-a7d7-e96a174f5d5d', tsv.taxonomy_source_version, '2.8', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '4e34ecb4-4ced-4dc3-a4c4-1a2749ac2e75', '92b7fc1f-e3df-4f44-a251-540fee43da11', tsv.taxonomy_source_version, '3.1', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '6dc8e836-25e9-44e3-a58a-f48b72880133', 'daf9d061-631a-4f52-a59d-92d39431e448', tsv.taxonomy_source_version, '1.16', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select 'fadbfde2-fef7-4159-adc5-9a5b51490a24', 'a10d5a79-0d50-4945-adb0-b4942902ac34', tsv.taxonomy_source_version, '1.14', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '309b92e3-e8ed-4edf-a949-838f22b00ae3', '87949000-95db-4cf3-a1eb-c14767be7728', tsv.taxonomy_source_version, '1.13', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select 'd321b97f-deff-4056-ab62-ff29b0af5bbb', '3befbb63-72fe-45f2-a2d9-8fa58c57300f', tsv.taxonomy_source_version, '2.9', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select 'b2443f7f-3ce4-4271-ac2d-94f6b65a6e63', '3b86e94b-3723-498c-a653-2952a034223c', tsv.taxonomy_source_version, '2.10', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '0ed66e29-f575-4879-afe5-24b90952311a', 'b00b9a52-ad49-4f07-a7a6-4911a180f91a', tsv.taxonomy_source_version, '3.2', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '36334953-2336-4a1d-a97c-e948ea9c2b32', '798d58ab-6661-4293-a380-7ca6a7245909', tsv.taxonomy_source_version, '3.3', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select 'a92a30ec-a89d-4f2e-a30d-f75da069e3e6', 'bb06d698-561d-40bc-a57f-f4181365b134', tsv.taxonomy_source_version, '3.4', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '920f980b-875d-4388-a1e0-ce80e9567643', 'c794879c-9f93-41bb-883c-d0688834fb30', tsv.taxonomy_source_version, '1.8', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '7f0f9e98-8561-4845-a557-014da9f3dcb5', '529f709a-1910-4ffd-a628-d864a9a53d43', tsv.taxonomy_source_version, '3.6', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:majority_earned'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '819fb4de-d0b5-4849-ad14-3215f537e6db', 'bc2104db-65a3-4a64-a42d-1e7997a70d61', tsv.taxonomy_source_version, '2.4', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '80f366ed-7898-4359-8968-f74587a0d28e', '3201bedb-99aa-4e0d-b70c-d11470058cb6', tsv.taxonomy_source_version, '1.6', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select 'c819bb10-2ad5-4806-94d8-d765c996da90', 'e9090ec6-1e53-4668-b291-caaccc634d68', tsv.taxonomy_source_version, '1.16', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '7548af9b-2d97-44e0-acd1-355677638431', '4ea8c5e4-ef15-4b62-b8d0-a84e8477703e', tsv.taxonomy_source_version, '2.7', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '2f0e07bc-f464-4eff-b746-e029d34ed915', 'e1049e19-3c23-4498-b3dd-18346a7f19d3', tsv.taxonomy_source_version, '3.1', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '7d003433-9901-44ea-8ad2-903233cc8733', '70669a81-a50b-4ea6-b4a8-d36b91a7550f', tsv.taxonomy_source_version, '3.2', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '6c46b797-cc7a-41c1-9d66-56d44f0f100f', 'c4ad7dd6-4c70-4962-a033-50bacebfaa23', tsv.taxonomy_source_version, '4.5', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '003c7170-18ff-49fa-a96d-6f37d9b0b709', '3c21b13a-6d99-4ce1-8110-67fdd5541ff3', tsv.taxonomy_source_version, '4.6', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select 'c095cb0e-012c-46e7-bff4-0238a3ab925d', '597c4a89-98a5-494e-aa20-5ae679deceb9', tsv.taxonomy_source_version, '5.4', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select 'e58ed193-36ac-411c-8546-ce5ae3e7aa45', '4a7184b9-65a5-4b75-945c-834f9031d048', tsv.taxonomy_source_version, '5.1', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select 'ed3551cb-347d-405a-94f2-92976a127ce2', '10a43e2e-a36e-4aa0-abeb-edd19ebd23c5', tsv.taxonomy_source_version, '5.4', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '206f9b38-4921-46b5-8570-aa29346ce955', '6468e218-bfc5-4855-805c-41f8c944db77', tsv.taxonomy_source_version, '6.4', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '4b430949-fb18-4469-934e-1700f06794b9', 'a205589c-3f8a-4bbd-b74a-c8844a517d28', tsv.taxonomy_source_version, '6.9', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select 'bbc6834e-53aa-46c9-a3a0-85026f2fee06', '577d9167-8648-4c6e-b1b9-ca327dd98c76', tsv.taxonomy_source_version, '8.1', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '034e27f9-59a6-4738-b2b1-37d48b7f3d58', '63dcdc45-6ca7-4a95-a8a9-dfcab413c804', tsv.taxonomy_source_version, '6.5', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select 'decf66f3-a95d-4459-94d3-fd5589a6e1fb', '07870933-7bd9-44c3-81ab-86203c233021', tsv.taxonomy_source_version, '7.7', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '9282cf85-c121-42a8-9a44-5e6092b659d1', '715de584-b80d-419a-bb50-bbb52f7b47db', tsv.taxonomy_source_version, '8.4', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select 'f9e6be20-f5cc-43d1-80df-a804acaadc46', 'f38d76b2-9b8c-4c6f-9935-8059eb33124a', tsv.taxonomy_source_version, '8.9', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '61ac5c7b-bff8-413f-a62d-01a4c4e06c2f', 'd5ce86ce-69e0-4e02-80d6-12b2e47cfb19', tsv.taxonomy_source_version, '1.6', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '1d146d5c-3b22-4ce0-a1a4-5a5e21dd75ab', 'f187cb9b-ad82-4c0a-bf31-1fe9bc88b111', tsv.taxonomy_source_version, '1.11', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '92c8a8ea-cbf1-4aaf-aed3-0f3203f4c0aa', '84b735fd-c0c5-43e9-a061-3c1d49d6faa6', tsv.taxonomy_source_version, '1.16', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '61b5cb98-2dbe-4fab-aa95-fe4d1ea0b416', '83a5e4bd-4243-45ae-99f3-4dc2b20277d6', tsv.taxonomy_source_version, '1.15', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '7c65a231-9d7c-4617-8149-d0bf268c4893', '282b516f-24df-4efd-a6b4-4bd707b27ade', tsv.taxonomy_source_version, '2.2', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select 'abb64eca-ba72-4b4a-a7c1-5340818ac2e7', '669ae7ce-d0bb-4605-8672-3d5edcc82ae0', tsv.taxonomy_source_version, '2.8', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '02c786a9-b398-4729-b97a-8f677eb55dd1', '46c685fa-6f73-4fec-8e6a-65f76f20688b', tsv.taxonomy_source_version, '2.8', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '871fcb5c-9be6-45f4-8c2c-7ff7c778bd9d', '4f821f8a-e0d2-4335-a0f9-d7f0f45eab31', tsv.taxonomy_source_version, '2.4', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '13957b65-bcd2-4a1b-b541-14437aaecd28', 'd78139a9-7f07-47dd-a1d7-2b74588b00f4', tsv.taxonomy_source_version, '3.1', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '813f88a3-7796-450f-935a-0a5f4a078f98', '562a99ea-e222-44cf-be4e-3d4092773ad7', tsv.taxonomy_source_version, '3.2', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '5523d757-39f1-46d8-9450-2ecbc765663d', '070f547b-efbe-4984-9319-43489d9ec9ed', tsv.taxonomy_source_version, '4.2', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select 'e303ce63-6c52-40f5-87ba-bdc4e247b745', '1a14dfca-2526-4774-86f5-95384856fa6b', tsv.taxonomy_source_version, '4.5', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '1d1b9df8-ec9a-4399-9e17-0ebf7f240fe3', '46ed1137-6d05-41ee-ba4f-33c75138bbfe', tsv.taxonomy_source_version, '4.6', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '21a7b5a6-60e5-4072-bf43-1f65002ca15b', 'a6963891-72c1-4665-912f-948599fcbfa4', tsv.taxonomy_source_version, '4.7', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '3c3f7a10-9dc7-4cfa-a3c6-5871e7d5c62d', '4cc3b370-f56b-47ca-a7cf-4e0b32a06595', tsv.taxonomy_source_version, '5.2', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select 'a119983c-c5c9-4761-9311-ae14546ec1c5', 'cadbc0c7-61d6-4c34-87df-70fecd83e14c', tsv.taxonomy_source_version, '5.1', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '81b364f7-fc0b-4e57-b590-c087725ae78f', '809ae281-c05f-4e7e-8582-15dabad909d0', tsv.taxonomy_source_version, '5.4', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '33531ad0-93ba-4c0f-b3da-b0f7e77c6591', 'a948f2bd-99d2-4b79-b1c1-ef6f1fe0e43a', tsv.taxonomy_source_version, '5.6', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select 'b162d873-5dbc-4dcc-8919-417e9617917a', '3d5aa0f8-6b75-4490-b338-4d83c9ba3f18', tsv.taxonomy_source_version, '5.11', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '00d080e0-da0f-4db4-a8ae-1cd0c9ddfd13', '172ee07f-0692-45f6-bcf0-413062e46d4d', tsv.taxonomy_source_version, '6.2', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '79c4da74-32e9-41b0-8f9c-794367219330', '4785a80b-e6df-44f8-80b9-0a24c715da30', tsv.taxonomy_source_version, '6.4', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '444684f1-adf2-42f1-9056-dfc31d3a6271', '8a70d356-3323-498f-bf1c-ed157a9c1d4a', tsv.taxonomy_source_version, '6.6', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '7b97de5b-7485-4ad5-bab8-1654f163c372', '4513a5d9-2989-4839-9009-7cddd4eadfe1', tsv.taxonomy_source_version, '6.9', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '79baa27d-6ca3-4fd8-9c8d-2fddcf172047', 'c8d4f7c2-7aec-4ffa-a03f-d301e5d36127', tsv.taxonomy_source_version, '8.1', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '738028d2-526b-4a64-a350-b91cba86e9c0', '6202f329-6245-4fef-ab40-0a7b8a14c525', tsv.taxonomy_source_version, '7.1', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:majority_earned'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '535562ff-4eed-45d6-9312-3894a9ee2233', 'f5374b3d-e3ff-44b7-91df-5a17e34fe98a', tsv.taxonomy_source_version, '8.4', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select 'a253cf3c-3331-4b90-bec7-9218c97ddd6a', 'c431bc9c-5cfe-4059-96f8-98e8589d8410', tsv.taxonomy_source_version, '8.3', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select 'cfa7198f-117e-4339-bd0f-9620482c62f0', 'f492bfbf-5434-434f-a4d8-50b058477139', tsv.taxonomy_source_version, '1.3', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:majority_earned'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '3750ed1e-2433-4d7d-b843-20adea6e33b3', '56b14ecb-0aef-40ad-8edf-8af6d1c966fc', tsv.taxonomy_source_version, '1.4', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '28e9cb52-5305-44b7-9f01-823fbd4652ae', '05cdd14c-f447-47d2-ad62-17c0eb25cc28', tsv.taxonomy_source_version, '1.6', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select 'aa4e3ce3-7c21-4033-aacf-2428e0d82d1e', '8113b078-35ee-426c-8593-a37255f0367e', tsv.taxonomy_source_version, '1.8', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select 'd777ae35-fe33-455c-b7cc-f61cd94637d8', '771dee16-a72e-4e4c-ae4b-853c1a9e4e37', tsv.taxonomy_source_version, '4.5', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:majority_earned'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '4a9b88d9-bfd9-4d9d-875a-d9d799998934', '05bc02e0-3ca9-45f2-9643-e69eddd4161b', tsv.taxonomy_source_version, '4.7', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '429dbfb9-594c-4a8f-bf6d-65eb0296f465', 'df73f375-1e54-4c0f-a847-137c1d14103c', tsv.taxonomy_source_version, '5.5', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '1981dd27-8030-4dfa-8167-15efb1ea3800', 'c56f7008-6b5f-4b7a-a5b1-1e885b68ad89', tsv.taxonomy_source_version, '6.4', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '9a9e1740-ab4a-4dae-b160-6333b46a6e8e', '580c88e3-b631-48cf-8cd0-52a8a151a9ef', tsv.taxonomy_source_version, '6.2', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '73fe2e20-b7ee-4947-92c9-a1128b8d83d8', 'a606fa68-dd58-44cc-8103-8928f6239452', tsv.taxonomy_source_version, '7.7', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '5417b17c-f89f-43f4-913e-5474a95a86df', '8d70b5e5-45f8-4a63-af0f-8f00b605e7dc', tsv.taxonomy_source_version, '8.1', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select 'ac074afa-13f6-4ff7-bddc-e5ddedfb4d1f', 'b7da8007-1029-4fed-84f7-08354fb31397', tsv.taxonomy_source_version, '8.11', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '69014292-55f2-455b-bebb-fa7df072e6de', '9322a7ab-2a93-4b6f-8046-0ccaa6de3ba0', tsv.taxonomy_source_version, '5.6', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '967524ab-f078-4656-8991-ff70d884486c', '6a085ceb-28e4-4e9c-b330-1e64675c3e60', tsv.taxonomy_source_version, '4.6', null, true, 'provisional_model', 'topic_pass', 'topics-ap_calculus_ab-20260929100918:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

commit;