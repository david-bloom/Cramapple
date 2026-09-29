-- TASK-0050 Phase B — AP Statistics skill codes. Run skill-codes-ap_statistics-20260929040715.
-- Generated 2026-09-29T04:07:15.240Z by scripts/taxonomy/label_skill_codes_mcp.mjs.
-- DECISION-0085: proposers openai/gpt-5.5 + google/gemini-2.5-pro, blind adjudicator anthropic/claude-opus-5;
-- 'validated' earned by >= 2 of 3 agreeing. NOT APPLIED by the script.
--
-- Rows written here: 181 (42 deterministic single-candidate,
-- 139 model-consensus). Held, not written: 0.
--
-- is_primary = false on every row: these items already carry a primary
-- topic-only row, and content_item_cells_one_primary_per_version would
-- reject a second primary. assignment_status is provisional_model, NOT
-- validated, because content_item_cells_validation_check still requires a
-- human validated_by (DECISION-0085's open item). Promotion is a later
-- UPDATE once that gate clears; the consensus outcome is recorded in
-- model_run_id so it can be promoted without re-running the subject.

begin;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '649b4aec-efb7-4ed1-a606-6b873ed321b8', 'bd6662e5-ef20-4a53-8c9f-0a4010d2470c', tsv.taxonomy_source_version, '5.2', '4.D', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:deterministic_single_candidate'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select 'd2ac22b2-f075-41df-a05d-897aa44f436b', 'decf1d69-0fb2-4bd6-8d71-a587a46bff57', tsv.taxonomy_source_version, '1.12', '2.A', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:deterministic_single_candidate'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select 'c620d7d3-1a93-49ac-8d81-654c7767125f', 'b0d3059b-0072-44d5-8543-eb16cc79a17b', tsv.taxonomy_source_version, '5.2', '4.D', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:deterministic_single_candidate'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select 'a067f214-64d3-48f4-b267-c41ce5fc5e5d', 'c93a7c33-587b-48dc-9aaf-929e9e3cccc0', tsv.taxonomy_source_version, '5.3', '3.B', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:deterministic_single_candidate'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '35c5517b-23ad-497f-8eb5-10a36b7bcc11', 'b7db04ce-be58-44b8-bbec-2be286e254d9', tsv.taxonomy_source_version, '5.3', '3.B', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:deterministic_single_candidate'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select 'd49c417a-ffc9-4836-a070-bd356e021b69', '2899b6c0-815c-4b54-a8a3-1f912e11d97d', tsv.taxonomy_source_version, '2.4', '3.C', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:deterministic_single_candidate'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select 'fd23b590-846f-49cc-a45d-16ff3d187c67', '09c01266-44ef-4639-af6e-b9f8016b8211', tsv.taxonomy_source_version, '2.6', '3.C', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:deterministic_single_candidate'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select 'f7dbe26b-eb58-4ae1-a30a-c31b65767ee3', '4b713cd8-0e04-477c-ac93-1cc73faf2315', tsv.taxonomy_source_version, '1.12', '2.A', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:deterministic_single_candidate'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select 'f4ca034a-6b6b-4a24-ae04-4ffb82eef35f', 'f3b2730e-2ea9-4ab9-ad22-01566fa117e3', tsv.taxonomy_source_version, '2.3', '3.C', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:deterministic_single_candidate'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select 'c15d8495-3926-4af0-a56d-b0ebd3901957', '0838c759-dc87-4acf-ac86-06057344b531', tsv.taxonomy_source_version, '2.5', '4.B', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:deterministic_single_candidate'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '81508254-a2e0-4906-ae6f-e7a63e0ad431', 'c41a14bc-0ecb-42a3-ac92-4837389d9ac5', tsv.taxonomy_source_version, '2.8', '3.A', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:deterministic_single_candidate'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select 'b97d6604-1b56-4a08-a462-9a5b0e4af145', 'a115bde8-0657-4607-aa4a-4a46ed141af3', tsv.taxonomy_source_version, '2.6', '3.C', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:deterministic_single_candidate'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select 'f90a9e1b-6fd9-4158-a668-f4ed22e3f8c6', '1147fd77-60f7-4fb4-a485-e0100e05c21f', tsv.taxonomy_source_version, '2.12', '4.C', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:deterministic_single_candidate'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '66842193-66be-4a88-83d6-7c3ea74c727e', '75e64948-636e-47d8-9326-78e74e6e2b8f', tsv.taxonomy_source_version, '1.5', '3.A', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:deterministic_single_candidate'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '9a8bccd1-85e7-4192-a1bb-71aad94ffe4c', 'a18da3b9-14ed-4bde-ac39-83558ad64eb3', tsv.taxonomy_source_version, '1.5', '3.A', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:deterministic_single_candidate'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select 'c63603c5-a620-4b06-aec0-b91d964db1f5', 'fc46faab-c198-484a-a39c-ba3755945580', tsv.taxonomy_source_version, '1.5', '3.A', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:deterministic_single_candidate'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select 'b1ee175c-2ac3-4bbb-8139-761847e05c63', 'f3762c6e-f6c0-4c34-bb05-c2353bfe6ad3', tsv.taxonomy_source_version, '1.5', '3.A', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:deterministic_single_candidate'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '6c2e8617-66ed-484a-9fe2-d1bf33a0b5d5', '669f220b-b06c-45e5-98fd-9500811ffffb', tsv.taxonomy_source_version, '5.3', '3.B', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:deterministic_single_candidate'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '347b8d6e-259e-4ba5-a2c7-19911381cf51', '6134fe00-5bbe-469b-a58d-a882b7e57c79', tsv.taxonomy_source_version, '5.3', '3.B', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:deterministic_single_candidate'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '88730e3f-91f9-4115-89df-7fe2a405d683', 'b088e116-7949-453f-be4d-bc89ce2d05ef', tsv.taxonomy_source_version, '5.2', '4.D', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:deterministic_single_candidate'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '3d4c14b4-84d0-4302-ba3d-8b9441b8c869', '0a00c482-74fc-4a7a-8acf-9abbcb54596e', tsv.taxonomy_source_version, '5.3', '3.B', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:deterministic_single_candidate'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '6ea124bf-3dee-40cb-8352-f35595e0c4f8', 'eb0ff391-566d-484b-9774-e2ab98dc28b3', tsv.taxonomy_source_version, '5.3', '3.B', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:deterministic_single_candidate'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select 'e693fbc2-e0ff-410d-9552-c2ad9e3ebd67', 'cc3d551e-f0e0-400c-94b3-dc282aa0440a', tsv.taxonomy_source_version, '5.3', '3.B', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:deterministic_single_candidate'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '8f418ec5-bb6f-4b5b-879c-72ea36d72bdf', '745c5d49-8013-433e-a0e7-7f24217e8026', tsv.taxonomy_source_version, '5.2', '4.D', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:deterministic_single_candidate'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '771a639a-1537-48bc-9807-f91675e701f2', '86c4d1f9-5590-4a87-85f3-30a49904cabd', tsv.taxonomy_source_version, '5.2', '4.D', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:deterministic_single_candidate'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '7c24861b-c7bf-490f-87dd-715a51560c7a', 'b198739b-0eaa-44bf-b553-d1b8e34f31a1', tsv.taxonomy_source_version, '1.12', '2.A', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:deterministic_single_candidate'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select 'a3d44672-c6f9-47c9-a716-47e2dc30be30', '1b5b2fe3-9c91-469b-a753-4ca46a926432', tsv.taxonomy_source_version, '2.6', '3.C', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:deterministic_single_candidate'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '423d231a-f0a2-4478-86ac-917bd38ddf91', 'f3989253-05a9-487a-80da-a9cc317c5a2a', tsv.taxonomy_source_version, '2.7', '3.C', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:deterministic_single_candidate'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '1ef0193f-85d8-4769-b7cc-f30ef5d493b1', 'd73e4a76-8708-44e3-923c-c20ef2dce583', tsv.taxonomy_source_version, '2.6', '3.C', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:deterministic_single_candidate'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '05e76206-dbf6-494f-81cb-a055bc6a3de7', 'd7e0f2f6-6450-4a15-b928-c8c176c147a4', tsv.taxonomy_source_version, '2.4', '3.C', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:deterministic_single_candidate'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '22a1b712-6ab0-4c5a-a3b2-2b3b4e248f41', '7a17fc0d-8a82-4271-bf6f-21690d9242b6', tsv.taxonomy_source_version, '2.5', '4.B', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:deterministic_single_candidate'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select 'e49b8e85-2737-4664-8846-abc96d89a8c5', 'b1c6dd0e-9be2-471b-986c-583e31c859d5', tsv.taxonomy_source_version, '2.7', '3.C', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:deterministic_single_candidate'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select 'e05caae8-c128-498d-ac50-99f7080be477', 'baddaff9-6859-4898-abd1-434dc0530278', tsv.taxonomy_source_version, '3.6', '4.F', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:deterministic_single_candidate'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '2b68aac7-70cd-4677-9bc0-bf3e71f52bf6', 'd070a56f-521f-402b-b2ca-96c273b28c16', tsv.taxonomy_source_version, '2.6', '3.C', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:deterministic_single_candidate'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '33e696fb-715b-4022-8030-82c642778129', '17ad586e-f311-4f7d-b02f-5fcdd9ae6fbe', tsv.taxonomy_source_version, '3.6', '4.F', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:deterministic_single_candidate'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select 'bd5793b6-8c65-4dee-9eda-72a9d6c4a171', '5d06a7b5-bbb4-4395-be72-01f76dcdfd7b', tsv.taxonomy_source_version, '5.3', '3.B', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:deterministic_single_candidate'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select 'c4871d3c-0cdb-46fe-b952-0abd6541d3c4', '0adf9714-cd48-4bda-a3fa-81b51a7f08cb', tsv.taxonomy_source_version, '5.3', '3.B', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:deterministic_single_candidate'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '2f698870-8d90-4a91-a225-cd7ad743d388', '6e950b9f-b741-4ee0-bf9e-c2a394fc626a', tsv.taxonomy_source_version, '5.3', '3.B', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:deterministic_single_candidate'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '1417fc9f-9177-4044-b44c-d6bbc62e2115', '27011504-7124-4ddc-a790-d8dbfdb37484', tsv.taxonomy_source_version, '5.3', '3.B', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:deterministic_single_candidate'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '87db6ac3-aaea-4aa8-9afa-6fef36623109', '19974a3c-d85a-4c57-b70c-77dfe4e186b1', tsv.taxonomy_source_version, '5.3', '3.B', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:deterministic_single_candidate'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select 'e839c580-0946-4974-9b1a-6cbb4f7cd16f', 'af0c68fe-edfb-4726-88f1-2524e6fdea73', tsv.taxonomy_source_version, '5.3', '3.B', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:deterministic_single_candidate'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '43780d98-4cea-432e-86d7-182baf4d422c', 'f99d019c-6b73-4f89-bd9e-9dc731e6b5f3', tsv.taxonomy_source_version, '1.2', '2.A', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:deterministic_single_candidate'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '3a187fa6-d745-463a-be2b-49579aa87a84', '882d7377-1634-46a9-88c8-a46680c837db', tsv.taxonomy_source_version, '1.6', '4.A', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select 'e053bb22-4805-44ab-9003-36b2e93987ab', 'b045075d-724f-4248-8a3b-e0f0c68e82a0', tsv.taxonomy_source_version, '1.13', '2.B', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '40c0226d-ff9d-4927-8c72-75b1cdbc2dd2', '80a0b867-d6e6-4bf6-999c-323c357f10f1', tsv.taxonomy_source_version, '1.13', '2.B', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:majority_earned'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select 'a2a8e8f7-f1f4-444f-a31d-cef8ec4d3c11', '15a93acc-e093-49fc-ae64-baa0e77a2c5c', tsv.taxonomy_source_version, '1.10', '2.B', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select 'c2f7d698-bd32-4f2e-bb91-c2119089c233', '55a833f4-ab5f-4437-b36f-748038236300', tsv.taxonomy_source_version, '5.1', '4.A', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '6a376f40-6f50-42b9-b478-27f91cd92aa1', 'acf20fc2-bc25-42e9-9068-fea69c26c89c', tsv.taxonomy_source_version, '1.7', '3.B', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select 'd070712f-9e57-4a0b-8af1-ef22b932dd3d', 'bf471ada-e35b-4d63-b27d-d9aba40722ca', tsv.taxonomy_source_version, '4.10', '4.G', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:majority_earned'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '5808c609-bc29-476a-a404-afa15124ebf3', '0d1808ac-8b62-472d-abcb-1d7edd5184ab', tsv.taxonomy_source_version, '4.3', '4.F', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '7d8d53e7-8dc5-4175-b972-688ffe5f9edf', '9817ead7-52af-493f-b7ef-dc30c3c4d904', tsv.taxonomy_source_version, '3.15', '3.E', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '0d5cc3fa-48fa-44d6-a0c9-c8e9d6067a6e', '1300dd2b-de29-4d8b-a990-376c8d3ff876', tsv.taxonomy_source_version, '1.4', '3.A', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '614b65b6-f98c-4319-ae0a-b540ce47233d', 'f8ebd5b5-6ac8-405f-a564-bb6b0dfb0759', tsv.taxonomy_source_version, '1.11', '2.B', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '66dba214-f1d0-41ba-a52e-1e16996ce0d7', 'a01f2bff-79df-4a27-a7d8-39a12a4cb5df', tsv.taxonomy_source_version, '1.6', '4.B', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:majority_earned'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select 'c19e2b4d-b0f5-4944-a4d9-46840f005aab', '804d26da-67ae-4acf-8ad8-dc33c2459f67', tsv.taxonomy_source_version, '1.8', '4.A', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:majority_earned'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select 'c9e06a78-dfe6-49eb-a069-5a3bf2aa1ad7', '5a68fcbc-4c45-4bdc-ae2a-4acbcfaf79ac', tsv.taxonomy_source_version, '2.1', '4.B', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:majority_earned'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select 'ee476290-e8fa-491d-ad5f-49a9e4a51f25', 'ff256908-1a1d-4138-a396-0f24d1e0a8e4', tsv.taxonomy_source_version, '2.9', '3.B', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:majority_earned'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select 'd96694c3-cce5-407b-ae36-1656d7ce1164', '350a6f19-505d-476e-a513-f7cc14473966', tsv.taxonomy_source_version, '2.10', '3.D', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:majority_earned'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '8a42ff98-03a4-4ba2-ac27-296c1932def9', '22897ba4-5b51-473d-a7dc-ea9012892f99', tsv.taxonomy_source_version, '1.13', '2.B', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select 'a4913da2-8e3b-4524-af90-74a5eb559735', '9a053602-a9d5-4a4a-a641-afb2d8fc9f11', tsv.taxonomy_source_version, '2.11', '3.C', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '4621efff-f4e8-4fd8-ac47-0c5600406d6c', '3ffe16de-35ff-46ed-ad96-6709fc159cd4', tsv.taxonomy_source_version, '1.9', '4.A', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:majority_earned'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select 'dcedcb2b-3c9d-4e14-a931-79ab0e8f47dc', '3de3974f-38ba-408d-abe6-69de5d0eff8c', tsv.taxonomy_source_version, '1.3', '3.A', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '995aa8dd-b257-4228-a066-a045d75fcb58', '3449fff0-009e-4ffc-ac1f-ef1c77c0b670', tsv.taxonomy_source_version, '1.7', '4.B', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '88d04972-a32f-45c0-ba36-88f89a20e76a', '3c820650-f346-41be-8d54-e22610c4f03f', tsv.taxonomy_source_version, '2.1', '4.A', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '247fa43c-12a1-4325-9e4a-3d2ac12ca337', '51978e67-36b4-4df8-847d-7b8d7f83261d', tsv.taxonomy_source_version, '5.1', '3.A', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '417f613e-9b7d-4006-a7ad-7af2192740d7', '1fc2f56e-35c3-4713-8d55-5f39fddfff46', tsv.taxonomy_source_version, '1.9', '4.A', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:majority_earned'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '778dd6fe-3743-4854-a85d-41ef92621f5b', 'e3c04930-1dd7-437b-959e-c80b5b60a8c2', tsv.taxonomy_source_version, '2.1', '4.A', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select 'dabb1c22-319b-43b0-85e8-46fc2156160a', 'c10fd7cf-3fae-4e59-940f-6741d4412e8d', tsv.taxonomy_source_version, '1.9', '4.A', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:majority_earned'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '44955911-e8a2-4692-bbf5-a2371008e2e6', 'dc2a3c81-acd2-4de2-9dfd-d1e5b03eb45d', tsv.taxonomy_source_version, '1.9', '4.A', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '4089bbf4-bd0b-4fa5-ba51-74abc72743fc', '1aa509c5-ade2-40fc-b5d7-49f450e356ab', tsv.taxonomy_source_version, '1.9', '4.A', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:majority_earned'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '95710146-eeba-4389-89db-a86dc33663c7', '055efe27-cfbf-4252-a521-8841e7fa14d2', tsv.taxonomy_source_version, '1.9', '4.A', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '0dc051bb-9021-4fb3-a17e-29d934feb013', '39617234-0fbc-4c16-ad1b-6ee50674aed7', tsv.taxonomy_source_version, '1.9', '4.A', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select 'e175ed67-4d5c-4580-9665-070c7e8bd014', '85aa5add-d990-4f1f-a76f-ee4cd87666a9', tsv.taxonomy_source_version, '2.1', '4.A', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select 'b8e5af02-dfec-4250-a74c-9a38a8323fa2', '1cbab95b-416f-49e5-bad7-8213024a7144', tsv.taxonomy_source_version, '2.1', '4.A', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select 'dfdfef1f-dd1f-43e4-a636-cb65824c2ef5', 'e80e66bf-111d-485e-868f-d6dd44d54f3b', tsv.taxonomy_source_version, '2.1', '4.A', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '2e2f5711-77bc-436d-9610-0c51b18bf9e0', '20927eff-9904-40cd-b79b-02c049d828ed', tsv.taxonomy_source_version, '2.1', '4.A', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select 'ecf62b6d-7462-4724-b009-83a8a821939f', 'd1e6ab5c-ee1e-4f24-8f52-ab97b1c123e0', tsv.taxonomy_source_version, '2.1', '4.A', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select 'f5d5f18f-37e3-4dec-bb2c-9aa76f0fd002', '47c72ae4-287a-4d31-b9d7-9ebbdd42572e', tsv.taxonomy_source_version, '2.1', '4.A', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select 'ca5f0628-cd55-4293-a6d8-51a1cacb6437', '26d6805b-a82d-4db8-b0b2-9a6a73a19ea6', tsv.taxonomy_source_version, '5.1', '3.A', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select 'ac0f6ad6-20a2-4de6-9d29-56f2eee9392a', 'bb73873d-0404-4f41-b895-3eefaae8d838', tsv.taxonomy_source_version, '1.7', '4.B', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:majority_earned'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '590cd7ea-cd9a-4a5e-832f-7a00c3f1b8e6', 'f0d82dd6-21d8-43bf-a786-d3eda22eb544', tsv.taxonomy_source_version, '1.7', '4.B', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:majority_earned'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select 'e4f2d003-4353-4a80-9b53-08f3a8d06ab1', 'cf31ff96-375b-423e-848f-61b25ed78db1', tsv.taxonomy_source_version, '1.7', '3.B', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '61b590c1-2e52-4bc6-ad7e-399de26f0670', 'ff356650-a4ab-465f-b88c-07034c430457', tsv.taxonomy_source_version, '5.4', '4.D', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select 'de9b4998-3e88-45ef-aeda-9a238571ebbb', '64612ee1-a24d-4587-a1a3-25d50b4706e8', tsv.taxonomy_source_version, '5.4', '4.D', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '9c06fe8a-ef4e-4ba7-9f78-26a08ade67d1', 'c9d98aaa-7a1c-443e-9ba1-9d35f20765b5', tsv.taxonomy_source_version, '1.13', '2.A', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:majority_earned'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '33ee0e0e-4cb3-431e-bf76-f4f622c2e6ab', '9a951e40-ade8-4f65-a19d-fd60ef927a77', tsv.taxonomy_source_version, '1.13', '2.A', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:majority_earned'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select 'ac4b7d87-2e8d-4d69-ba25-fd764e6b497f', '52baca14-9fb0-4cfb-91c7-6dba0aed87bf', tsv.taxonomy_source_version, '1.13', '2.B', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select 'acce1443-26d8-463a-91df-414604d7036c', '34dfa75b-703d-4c8b-9d2f-52469c5b23ef', tsv.taxonomy_source_version, '1.13', '2.B', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '291e1dc4-ce1d-45c9-9a3d-ed206fb5397c', 'b5b551fb-d92c-49d8-9c08-cf64334cf5ba', tsv.taxonomy_source_version, '2.9', '3.B', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '4da611b4-f14f-4478-8a40-2ed9744477c4', '94f4f048-f75c-49f5-8945-0711142dadbb', tsv.taxonomy_source_version, '4.1', '4.D', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select 'e5d16b42-7b57-440b-b3a4-c044bd8c773c', 'ed8f2081-caa5-41ce-9f66-ba8e67863cfd', tsv.taxonomy_source_version, '4.1', '4.D', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '8d27f7fd-b55c-4931-a2e5-2ac4c9f4daed', '2b5f7fbb-aa4c-456d-99b0-0773f8b14e24', tsv.taxonomy_source_version, '3.2', '4.E', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '65238ef6-b008-4543-a3cb-018a6b7c8451', 'fdd35952-554d-47c4-ae1d-254e9a43c2e1', tsv.taxonomy_source_version, '3.4', '4.F', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '82f24da9-556c-4266-b163-ba2147e558db', '473ac72e-cb6a-4bba-91b6-6a97907a0f72', tsv.taxonomy_source_version, '3.4', '4.F', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '4fe5bc8e-8efc-4ac2-8ef2-d235c2321941', '9c035e67-3d3c-4318-957d-ae5eba0eda62', tsv.taxonomy_source_version, '4.2', '4.E', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '5692c37e-d47e-4d0d-8163-6cf2321aff90', '24df5444-b2fc-4fa0-8295-abb0fe064a84', tsv.taxonomy_source_version, '4.2', '4.E', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '2ad32dd5-dee0-48f1-a624-a2b57e127d74', 'd7ac1584-cdac-47a3-8705-e90c3930dab1', tsv.taxonomy_source_version, '4.4', '2.C', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '37267cf0-b493-4d79-8991-9716023331c8', '52109b9e-9a20-43ef-b443-42f9558e4305', tsv.taxonomy_source_version, '4.4', '2.C', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '6911479d-3b9f-48ae-bd28-f28f775ba509', '2bdcb47c-2ed4-402f-a1a1-e33577d8a15d', tsv.taxonomy_source_version, '3.14', '4.E', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '6f807db9-169e-4ee4-be80-c4a87658a003', 'fbde3145-2edc-418a-807b-8ad205dedf84', tsv.taxonomy_source_version, '1.7', '4.A', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:majority_earned'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select 'fe0b6b43-ebfa-413e-b762-878e5b9713a5', '7141715f-825a-4e51-be11-dabb120371ca', tsv.taxonomy_source_version, '1.7', '3.B', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '18ae04f7-9b87-4ff6-969f-21aefc78c42c', 'd3588284-6905-4667-b11b-e9d270410f0f', tsv.taxonomy_source_version, '1.7', '3.B', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '14499662-732a-400a-8b05-644cc91b3d93', 'ee90a501-d6ae-4a4e-9d1b-2dba077782df', tsv.taxonomy_source_version, '1.6', '4.A', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '35f102c0-6006-430e-976a-716915fc017a', '8e478e2a-08ac-41c1-9048-f345cc3df2bb', tsv.taxonomy_source_version, '1.7', '4.A', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '997bc646-fe66-4c6c-b66f-d5244d3e97cf', '07dc1163-1dad-411a-b70a-c4254b309fe2', tsv.taxonomy_source_version, '1.7', '3.B', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:majority_earned'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select 'bb6e2770-4f62-4701-9432-9d0410fdfcfa', 'dbb8de03-54d2-4f6a-b0e4-ed3a92f702e6', tsv.taxonomy_source_version, '1.8', '3.A', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '6f8c5dd3-3aca-4cc3-a5fc-26583442abc8', 'd9e286a3-74b3-4844-ab0a-63ba55fd63be', tsv.taxonomy_source_version, '1.7', '4.A', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '40479152-0fbe-4c34-a845-d6978fb2a37c', '7a108f76-cd92-41a2-979c-db6513fe9c17', tsv.taxonomy_source_version, '1.6', '4.A', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select 'd95ab036-87a0-47ee-ba6e-7433b9dd8f5b', '0f677e08-6a5f-4ff8-b464-a90ee5f255ee', tsv.taxonomy_source_version, '5.4', '3.B', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '3473d939-a4ff-42f7-b40e-a5dd192c28ab', '2de8949a-8ddb-46a7-85fc-35eebd0ace60', tsv.taxonomy_source_version, '5.5', '4.D', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select 'be65ce51-7d96-412e-91ee-74f468c4181f', '6a25809a-3ded-457c-982a-920144983361', tsv.taxonomy_source_version, '5.5', '4.D', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '3213356f-9a3e-47df-a521-f5d442875abf', 'b16c8b73-287e-427f-be64-f516b395ada9', tsv.taxonomy_source_version, '1.11', '2.B', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:majority_earned'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '3e4742b1-67fe-4389-ab41-463a4681e0b4', 'e0d8f8ae-9a57-4162-a5a2-bff62180c322', tsv.taxonomy_source_version, '1.11', '2.B', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select 'c62d4174-b221-427d-82e3-d3a2b3ce7dd4', '9ede0596-b285-4fb6-b1df-717ed199b3a8', tsv.taxonomy_source_version, '1.13', '2.A', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '59b1077a-1584-47bc-a529-a9d06afa4c2b', '72ff2392-7b2e-4949-95f5-d556d3fdd6ff', tsv.taxonomy_source_version, '1.13', '2.B', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '0e960a55-55c5-48d2-a135-2e35b13b258e', 'c180ab2b-d302-4e03-931c-f013a749f3f3', tsv.taxonomy_source_version, '1.13', '2.A', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select 'be4c4fcd-bd1c-4124-90cb-5b4b52c2f7e5', '9fc61bee-5442-4161-ba09-21aed4627188', tsv.taxonomy_source_version, '1.13', '2.A', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:majority_earned'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select 'a69b9346-785c-45df-9f29-a6354052e402', 'f3ddd289-cd3b-4800-a413-1887573c4961', tsv.taxonomy_source_version, '1.13', '2.B', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '3c9929da-fef6-434a-8512-6d857f40c610', '1825f66b-fd3d-46fa-89f1-b20f7c552895', tsv.taxonomy_source_version, '1.10', '2.B', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:majority_earned'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '26523b4e-c77f-4ba9-a592-74386841c208', '292ce937-5171-45cb-ab97-36848147b399', tsv.taxonomy_source_version, '2.9', '3.B', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select 'b33465a7-0f9a-4adc-91e2-1dfa175842eb', '56e5bafc-b49c-40c1-8477-5901f84e308e', tsv.taxonomy_source_version, '2.10', '4.D', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:majority_earned'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '38c5be36-fd77-47be-b061-2f9e4d28fc75', '606835ad-faa0-45de-9e59-fc31ea724592', tsv.taxonomy_source_version, '2.10', '3.C', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '2cb12761-b0a8-421b-ab3f-8e66d36218b9', '316fbac2-416c-4538-8ca1-ad2d9191ecdc', tsv.taxonomy_source_version, '4.1', '3.D', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '46f9669d-56fa-402c-9871-ef5b92646445', '654002f4-3a24-4498-9e37-4879461a2816', tsv.taxonomy_source_version, '4.1', '3.D', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '80573ffb-e9b5-4507-b530-4b22e742e4e5', '89cb0fc2-0252-4f31-ad05-5ac287e78a38', tsv.taxonomy_source_version, '4.1', '4.D', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select 'b5e36781-5f96-4734-a896-52e7d98ef57b', '4cb2b3d6-4c27-4427-9bd9-75e486e63429', tsv.taxonomy_source_version, '4.2', '3.E', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:majority_earned'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '99eb17f3-cd99-40b3-9af4-465eb5193b11', 'e6bafd72-01af-4388-b8c0-8b604b3992a6', tsv.taxonomy_source_version, '4.1', '3.D', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select 'ecbf39b7-05c2-4632-9a78-126502a2fbc3', '0ea7e612-9966-4a29-8b89-f5465316c4c1', tsv.taxonomy_source_version, '3.1', '4.B', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select 'e695f3ac-4910-47fc-b811-623bbebc730f', '18a28599-e193-469f-a5c9-5bfd767a717b', tsv.taxonomy_source_version, '3.2', '3.D', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select 'fc7633e2-9b9e-4335-806e-199a64747862', 'ce3272ff-7837-4d4f-97af-55b1979fa1b6', tsv.taxonomy_source_version, '4.2', '4.E', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '98d10d3a-7eea-481a-854f-7daf0cb997d1', 'b0d4e487-4202-4edd-842b-c6d01b1d0768', tsv.taxonomy_source_version, '3.8', '3.C', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:majority_earned'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '18565f1d-4de3-4e88-9a41-92ed9c84c0fe', 'a5fe7a0c-182a-41a1-adeb-043534bf594f', tsv.taxonomy_source_version, '4.3', '4.F', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '0bf79bc4-d0ac-4066-95f6-faaf20382b79', '1f797ea1-a552-4685-aca4-4f286a6e364a', tsv.taxonomy_source_version, '4.2', '3.E', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select 'bc8bf77c-c3a7-4d91-9862-642eb57d2eb4', '8c4d5425-a4ed-4d80-b6a8-a30e08a243ed', tsv.taxonomy_source_version, '3.5', '2.E', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '1a9fd885-25de-419b-839f-197ca2a9e38d', 'fabe1511-27c6-4a53-a3ca-7482751b40ac', tsv.taxonomy_source_version, '4.10', '4.F', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:majority_earned'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select 'e518aac2-44b7-40ee-aac3-44ad595193e2', 'b7783182-aaf1-4ab6-b9c0-4ab603588b94', tsv.taxonomy_source_version, '4.4', '2.C', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '82889042-3bc1-486c-8200-b972410522d6', '05ff0a70-0ce4-47e4-8310-7d9241ae2af1', tsv.taxonomy_source_version, '4.2', '4.C', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:majority_earned'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select 'bd79d09f-1998-45e2-a30a-376c213181df', 'e8114413-8afb-421c-9315-0d9362285834', tsv.taxonomy_source_version, '3.8', '2.D', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '5aa1ff51-39b1-4ac3-a648-e047574385a3', '8e5235c6-e540-4f11-9e8a-7a7412af1956', tsv.taxonomy_source_version, '4.10', '4.F', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:majority_earned'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '303cedc1-1c82-4c56-b07b-5661a50cefae', '79a46327-19e7-41df-9bcd-01d820f0d6d7', tsv.taxonomy_source_version, '2.2', '3.B', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '0438c3a5-9016-43e3-9456-0d31907d9868', '377b46a4-9d1d-4f3c-a875-219b971a88a8', tsv.taxonomy_source_version, '3.14', '2.C', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '615ee310-cb1f-47c9-8542-fb968ca51152', '36cdafd8-68f7-46a7-b3cd-0800bb10c360', tsv.taxonomy_source_version, '3.15', '3.C', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '4a0cde69-239f-4f41-b3db-b99b50a364af', '23fa21e5-afe2-4046-9f2c-4115d3515828', tsv.taxonomy_source_version, '2.10', '3.C', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '01987033-09b6-46aa-951e-11eec09f5125', 'c7caf9d7-21ff-4a00-a0a8-d14ab2b260b4', tsv.taxonomy_source_version, '4.1', '3.D', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:majority_earned'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '61091d9a-d9e8-4f37-8f5e-c14c49e9acf8', '731f52d2-5d52-4bd4-8492-78346923b50f', tsv.taxonomy_source_version, '2.9', '3.B', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '03b89bc0-d6e3-4440-abd8-a8b5d851a1cd', '4c0eead9-c548-41df-a21a-ef63f9bf8ff2', tsv.taxonomy_source_version, '5.4', '3.B', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '98ac4d52-1957-4d57-8f72-a4bbc43a0066', '84fc4ee3-2efc-4ba9-bc54-651ba79a0508', tsv.taxonomy_source_version, '5.1', '4.B', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '9e1afc88-21ee-4402-8a8f-ca780c570dea', '5e097357-4b8b-4c36-aaf6-afd256af7f79', tsv.taxonomy_source_version, '5.5', '4.D', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select 'adab9369-6c97-42b9-bd09-b8bd7300d769', '4408d578-eb8c-440c-8108-848035c4f93f', tsv.taxonomy_source_version, '4.9', '2.C', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '57a5f652-1c4a-492a-b292-9f6a2e58ceba', '5e770265-7e3d-451c-baab-2b4f0e848528', tsv.taxonomy_source_version, '3.8', '2.D', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '5db92eef-32b8-4e9a-a996-8b5c6b0c91b7', '21ed73e0-41c9-43fd-b7ca-a4dbd6d5c771', tsv.taxonomy_source_version, '4.4', '4.E', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:majority_earned'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select 'bd64b690-cb9c-462b-95f5-c06dbff2cb51', '45193c5d-0eb5-4bf0-ab90-1172dc07b43e', tsv.taxonomy_source_version, '3.8', '2.D', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '5f138fc9-756f-4101-9481-35ec982fbb99', 'd0e985be-e015-48c6-ab6e-9ed4646a3ac5', tsv.taxonomy_source_version, '4.2', '4.C', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '1c732cb6-7ff1-4705-9b1b-599341b3e993', '53cc851c-99fb-40d1-a284-0279a06e6bb7', tsv.taxonomy_source_version, '1.13', '2.A', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:majority_earned'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '7f1f09c3-1604-404d-a2e1-98049a614123', '2396c502-1082-43d2-8b32-308a99e1f40b', tsv.taxonomy_source_version, '4.9', '2.C', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select 'af13f295-b633-4f76-b702-a4abf6d535e3', '9bbb936d-faa0-48b3-962b-73e5c4750c17', tsv.taxonomy_source_version, '3.12', '2.C', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select 'cbe1dae5-51e8-4b26-87ff-9e457f3f054e', 'ec218044-fa22-45a3-9371-7fce48c108e8', tsv.taxonomy_source_version, '1.6', '4.A', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '29737886-6a8a-40e6-9bb9-4825cbe52d8b', '1dd34081-fec3-4055-859a-501de5407187', tsv.taxonomy_source_version, '1.7', '3.B', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:majority_earned'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select 'eb74b80e-3f89-430e-a5a2-741ece5451ef', 'bcfbc4de-a31c-4957-8137-70b589495688', tsv.taxonomy_source_version, '5.1', '4.A', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '271dbf21-91e0-423d-9c01-72dfe57a0dbf', '81ce57bf-b576-4d7d-818c-d73eb2a3b952', tsv.taxonomy_source_version, '5.4', '4.D', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '41f14ace-afaa-4882-9902-99207ac705ac', '0838c753-d383-48c5-a22f-aab1672eae4f', tsv.taxonomy_source_version, '1.11', '2.B', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select 'a1d72619-88fb-44f0-ba0c-6b541c05936b', '07ef9bbb-739d-4807-9928-ef02b7d7583f', tsv.taxonomy_source_version, '2.10', '3.D', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select 'af56da0a-d966-4882-bafb-d47d10b0b9fd', 'efc05957-06a3-4b0e-8097-9926841fdaff', tsv.taxonomy_source_version, '2.9', '4.D', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '6117e0c1-110a-42de-b2a5-10f719c1cd5d', '22c1824d-b601-4050-83ae-edb18b8e98bb', tsv.taxonomy_source_version, '3.2', '3.D', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select 'b6acbd1b-2851-400a-9761-116bb50712ef', '7abbb85e-a697-4db6-bea8-b363bea8f36e', tsv.taxonomy_source_version, '4.1', '3.D', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:majority_earned'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '520c93a1-2eb6-4363-88dd-42b182572364', '9c9ba44a-5dd0-4d74-8e92-a61791710194', tsv.taxonomy_source_version, '3.3', '3.E', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select 'f3201719-d216-4143-aa92-8d64a9c469aa', '75042cc3-3d10-45ee-ba37-fc37d552f32a', tsv.taxonomy_source_version, '3.7', '3.E', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:majority_earned'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select 'dd0be3bd-4c02-456d-a2b9-0cd59f18e774', '06881854-e997-4b97-a234-ff12ae8f7652', tsv.taxonomy_source_version, '4.5', '3.E', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:majority_earned'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '822d2c2d-81f3-4ce1-8506-661a9d94dbcc', 'ab3889f2-3d52-46fd-bb66-8bb0621e7ed5', tsv.taxonomy_source_version, '4.5', '3.E', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:majority_earned'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select 'f21ce773-4813-47a9-98fe-e89cba300512', '610f6069-076d-496c-af58-0ee910308b30', tsv.taxonomy_source_version, '3.15', '3.E', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '1a5a44ca-1545-4ea0-bc50-86ac0489ff6c', '500a0a0c-f82d-498c-a53d-c523624edda7', tsv.taxonomy_source_version, '1.1', '2.A', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '2d8d4d3d-1af7-4f45-b32e-93e8c9f03ce0', '76ca33ec-f07a-4bf6-83f6-d45bd2fb4c7b', tsv.taxonomy_source_version, '1.10', '2.A', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select 'cfabb50f-6bee-4c75-af53-7ba415dd697f', 'f4297ecb-da88-4422-a13a-d347231ebc68', tsv.taxonomy_source_version, '1.1', '2.A', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select 'd2affbe0-2481-4f00-8054-d42ff6398b27', 'b2f2de47-2c10-4b83-bf97-89cdfd695e18', tsv.taxonomy_source_version, '1.11', '2.B', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select 'd9fb8bc8-8534-4259-ae09-8a82243aabce', 'cdcd1b0e-f691-4e4e-9fa8-ac68d393cfa0', tsv.taxonomy_source_version, '1.6', '4.A', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '0f7571c4-4327-45cf-9cc4-d9f822c8db65', '8bf641e9-9524-47d4-8062-cbde41e6574e', tsv.taxonomy_source_version, '2.11', '4.C', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:majority_earned'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '07edc710-16bb-4c09-b7d2-789cdc5a9926', '90fdfeba-dc7f-464c-9420-06a78ddb1830', tsv.taxonomy_source_version, '2.11', '4.C', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select 'af82b114-64dc-4161-a900-4e6de29ab303', 'f112c2b6-7101-4fb9-bee4-94d2c90ef8c4', tsv.taxonomy_source_version, '1.13', '2.A', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select 'bb2c9c91-f2c9-4312-a416-e6867c3fdaf3', 'a52543cb-3b89-4cdf-ab6c-33698e75d9a6', tsv.taxonomy_source_version, '1.13', '2.B', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '85d23dca-8f05-4e9e-9dbe-22600f8c5528', '3e2d90af-711c-4c4c-a090-fed3cebd2159', tsv.taxonomy_source_version, '1.13', '2.B', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:unanimous'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select '4c9180d9-3f05-4fb6-a5f5-0b1e59100ad8', 'b539a1fe-8edb-49ef-ae56-c5e28f9bae10', tsv.taxonomy_source_version, '3.8', '4.D', false, 'provisional_model', 'skill_dimension_phase_b', 'skill-codes-ap_statistics-20260929040715:majority_earned'
from app.taxonomy_source_versions tsv where tsv.subject_key = 'ap_statistics'
on conflict do nothing;

commit;
