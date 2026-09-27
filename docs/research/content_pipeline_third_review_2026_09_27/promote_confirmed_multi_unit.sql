-- APPROVAL-0056 / DECISION-0066: promote multi-unit serving labels confirmed by a
-- blind third review using anthropic/claude-haiku-4-5. Candidate labels were not included in model prompts.
begin;

create temporary table tmp_multi_unit_third_review (
  content_taxonomy_label_id uuid primary key,
  content_item_version_id uuid not null,
  taxonomy_relevant_hash text not null,
  reviewed_required_units integer[] not null,
  reviewed_primary_unit integer not null,
  validation_decision_id uuid not null
) on commit drop;

insert into tmp_multi_unit_third_review values
(
    '22b11e70-5b03-4bb7-b723-716093786430'::uuid,
    '63dcdc45-6ca7-4a95-a8a9-dfcab413c804'::uuid,
    '2f2d57d21d508f17e6765ab149e3b8f885043d81b24b827d9aa233ec8b57f826',
    array[5,6],
    6,
    gen_random_uuid()
  ),
(
    '6cc8f11f-6e02-4530-8810-780bed4437cf'::uuid,
    'd78139a9-7f07-47dd-a1d7-2b74588b00f4'::uuid,
    'd756b97cf4f3d1e8e26b8a3c694c27be6c32b4bcf57d406fab72c82ed8d64856',
    array[2,3],
    3,
    gen_random_uuid()
  ),
(
    '7316aaa3-937b-412b-8e45-6c34de57d1f0'::uuid,
    '070f547b-efbe-4984-9319-43489d9ec9ed'::uuid,
    'e115117ff6de6bdac41bed3d59362c3a3efadc6c9a4b8cc2449f425b958d7dc0',
    array[2,4],
    4,
    gen_random_uuid()
  ),
(
    '86157df3-23f9-4c03-a4bf-01f2ce36822c'::uuid,
    '46ed1137-6d05-41ee-ba4f-33c75138bbfe'::uuid,
    'e640f2074e6c4e3571159cc169773073478825efc9866033a8b93632683bbaaa',
    array[2,4],
    4,
    gen_random_uuid()
  ),
(
    '4763e786-a01e-4e19-8d0c-cce94912b1dd'::uuid,
    '6a085ceb-28e4-4e9c-b330-1e64675c3e60'::uuid,
    '4d0820208b1eef626792abfb54b95afea122e281996174c582a7554d99786f4a',
    array[4,5],
    4,
    gen_random_uuid()
  ),
(
    'fffbd360-3b1a-4f81-9eaf-02a86b076a44'::uuid,
    'af91cd64-2f6d-48cb-80a6-88b8eed92aab'::uuid,
    'aff00cb4db078a289410a173f94b0b04b86bb362dcabd53cf15ddf0cd35ec587',
    array[2,3],
    3,
    gen_random_uuid()
  ),
(
    '222df446-8800-4846-9675-0b5baa31cb8a'::uuid,
    '6029f4d7-0322-4c42-81e9-1ea063cb12d3'::uuid,
    '5ed6dda842641e9f630299971fdbee97712d24b60e1407affe0f43fce1638f0d',
    array[2,3],
    3,
    gen_random_uuid()
  ),
(
    '4e90f48f-0558-44b8-8e6f-d01ec097ef58'::uuid,
    'e9900869-00ec-4a88-986f-fe803d9985bf'::uuid,
    '07cba0466236a311a35ef06df69d9459e68cefe310567906f0285bdd0b8cf9dd',
    array[2,3],
    3,
    gen_random_uuid()
  ),
(
    '4649bc0d-fa48-491f-8c22-b764ba3201ba'::uuid,
    '22757b29-3af8-40f1-8f88-4d07e2ab1b0c'::uuid,
    'e55eacca5488810c9f016f9fba8eaf49c96596253fd3e1bee49d00e6ccccfcb6',
    array[2,3],
    3,
    gen_random_uuid()
  ),
(
    'ff17ce5d-f5af-466e-aa0e-b8d4f60ab3df'::uuid,
    '3af5af1d-38b3-440d-a2a6-d1e6adfbe422'::uuid,
    '2f0976cc79a5c29ad6edc8b8af67eca2f0c8674cc4906833532c6fe03aef1442',
    array[2,3],
    3,
    gen_random_uuid()
  ),
(
    'aa9d6f2d-e07d-4d8d-b2a1-d21af3fc7f0f'::uuid,
    '86e72fa9-ccf0-4496-aba2-ef42f8ec8fe1'::uuid,
    '7cc851de1ad956c312ed249190a978ad274dfe3f069cf2a50b248a9053e38154',
    array[1,2],
    1,
    gen_random_uuid()
  ),
(
    '08c68304-11a7-4f29-b774-212e003f30d7'::uuid,
    'c973ec2c-826d-4dcf-bc00-aed52d250ee9'::uuid,
    '9b0c5aa5984d14263f26ab42930a2cce701ffc12a8ca9167a7588324079d74d7',
    array[3,4],
    4,
    gen_random_uuid()
  ),
(
    '049d4d83-72ac-4fb8-b8fe-91c95163d40e'::uuid,
    'b95a39b7-e1be-49ae-aa09-a5f9dbd5cd01'::uuid,
    '740ba6634cf49adbeef5e99c7bfee322ec0b0474966eb2be6f19730f013bba06',
    array[2,5],
    5,
    gen_random_uuid()
  ),
(
    '05c7d0e5-4e55-4789-b12f-065f25636724'::uuid,
    'db659ebf-4ffa-4a30-aa77-f0fd3e2b1a3a'::uuid,
    'dd21c767173110ca4b40cac2bfa9ae39cdbef7ec294e73a4975c870d47667d86',
    array[3,7],
    7,
    gen_random_uuid()
  ),
(
    '6ed3b13d-6843-41cb-b452-79fff33a6d0d'::uuid,
    '050bf660-8498-452f-bfad-e521280c3e46'::uuid,
    'b5c4daa6a9d9dc6e1dfb6c927e782a9f00b562c535d18658012ec08bf8e86ceb',
    array[1,2,3],
    3,
    gen_random_uuid()
  ),
(
    '349ec002-2905-4b50-91dd-3836c1233369'::uuid,
    'c525b652-0731-4fa7-9300-4d8c835a76a4'::uuid,
    '3c55bde932354cee80eb4f8d7b8f3a65cd820ad254e4d2309320152ca9f5889f',
    array[2,5],
    5,
    gen_random_uuid()
  ),
(
    '73b9e315-ff98-441a-a5ed-7b28dd6559ba'::uuid,
    '8d17d888-657c-4454-b31d-8e206af7c9cc'::uuid,
    '6b688b4243a03c337916a169256276c9044dc7f824495e369969245c1a8f0fcc',
    array[2,8],
    8,
    gen_random_uuid()
  ),
(
    '9113eede-d40a-4fdc-b83b-2501f6da5bca'::uuid,
    'd6ce72be-9e61-4c93-a3db-49e39f0f2a77'::uuid,
    'ef2559cbc258ca15e39f51459032344fa4b094a985fdf5ca31518c34eb8e28e1',
    array[2,8],
    8,
    gen_random_uuid()
  ),
(
    '067fe944-0021-4de0-950b-3534f9fceb1a'::uuid,
    'e4ae8556-5d1e-47f7-87c7-299c89725d57'::uuid,
    '6c8f1bfb7ec63562aab5e4a2033da10a926182d33d5025b4ab1eafb048594039',
    array[8,10],
    8,
    gen_random_uuid()
  ),
(
    '5d0040ad-3cdc-444f-ae93-d98573761481'::uuid,
    '8caa38af-5656-4ae4-8840-b3018b308e6b'::uuid,
    'f305d24cc7d8ceadee480dcf892d5d93a2f625140986fea9978bb2351073963b',
    array[8,9],
    8,
    gen_random_uuid()
  ),
(
    '5f6f683c-a705-4413-b0d0-6f10442d746b'::uuid,
    'd9aa6cdf-6e08-4c3b-a8d7-76094bc2f2fa'::uuid,
    'd786bf24f7e6a300325ea6332044386d1bf587b71bf1961bc90831d8b789db82',
    array[8,9],
    9,
    gen_random_uuid()
  ),
(
    'bb95f757-5073-4537-b992-6f5693813318'::uuid,
    '877f60ba-7e2d-4e0d-9778-7b04264d58b9'::uuid,
    'e0b333042a2d44309a8d8f65aec282289b50688308fd3150aa0ed81b388a2993',
    array[5,6],
    5,
    gen_random_uuid()
  ),
(
    '4a3d2f17-96b7-47fa-a9aa-c708194c3c87'::uuid,
    '57c6fbdf-72dc-4205-9d04-8dc339144511'::uuid,
    '7d1c23ba618ee6cc5b940043d9936f236a04a87d118cd3ef158f7cb9072530be',
    array[1,2],
    1,
    gen_random_uuid()
  ),
(
    '83c4c06f-1bd0-4b7e-86eb-f5b542b04fe1'::uuid,
    '4ed7f1e0-371b-4985-b8b9-3f0a4e37c36c'::uuid,
    'fc703a8d999ac4efab7c0a419b93be74f0fa6e84aae67c8f23abc3515534da36',
    array[3,4],
    4,
    gen_random_uuid()
  ),
(
    '3274b6e9-ccfa-4517-a9da-ac9ff0ebb164'::uuid,
    '0fea4545-a459-41d6-9262-7f1260588076'::uuid,
    '71ef8ed2aef3e6c9102cf8f2c8b3b2cca8e66ad9358e4a36c4165500cf8391f1',
    array[2,5],
    5,
    gen_random_uuid()
  ),
(
    '1f1eab70-9f29-44de-92e9-14828602df0b'::uuid,
    '8e3d19be-4792-4fc0-a1d4-32d4a3c889d3'::uuid,
    '551baa6d7e86262b88e6c4120734cc36544623c6a0a0d5c8e7481cd76021c5ed',
    array[2,3],
    2,
    gen_random_uuid()
  ),
(
    '9c9cfab7-883b-47a7-af5e-221540016da4'::uuid,
    '6d3d6d8b-dace-4613-b074-20825db99c92'::uuid,
    'fde1100441f2af4050ec870f493ef59450a6f0ad65040646380f8ee7be1b5df2',
    array[1,2],
    2,
    gen_random_uuid()
  );

do $$
declare v_count integer;
begin
  select count(*) into v_count from tmp_multi_unit_third_review;
  if v_count <> 27 then
    raise exception 'multi-unit third-review input drift: expected 27, found %', v_count;
  end if;

  select count(*) into v_count
  from tmp_multi_unit_third_review r
  join app.content_taxonomy_labels l
    on l.content_taxonomy_label_id = r.content_taxonomy_label_id
  join app.content_items ci on ci.id = l.content_item_id
  join lateral (
    select v.id, v.status
    from app.content_item_versions v
    where v.content_item_id = ci.id
    order by v.version_num desc
    limit 1
  ) current_version on true
  where l.superseded_by is null
    and l.label_scope = 'serving'
    and l.label_status = 'provisional_model'
    and l.source = 'vercel_ai_gateway_two_model_serving_lane'
    and l.source_payload->>'reason' like 'two_model_%'
    and cardinality(l.required_units) > 1
    and l.required_units = r.reviewed_required_units
    and l.primary_unit = r.reviewed_primary_unit
    and current_version.id = r.content_item_version_id
    and current_version.status = 'published'
    and l.validated_against_version_id = r.content_item_version_id
    and l.validated_against_taxo_hash = r.taxonomy_relevant_hash
    and r.taxonomy_relevant_hash = app.taxonomy_relevant_hash(r.content_item_version_id);
  if v_count <> 27 then
    raise exception 'multi-unit third-review live-state drift: expected 27, found %', v_count;
  end if;
end $$;

insert into app.content_taxonomy_validation_decisions (
  validation_decision_id, content_taxonomy_label_id, decided_by, decided_at,
  decision, decision_source, reviewed_primary_unit, reviewed_required_units, notes
)
select
  validation_decision_id,
  content_taxonomy_label_id,
  'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,
  now(),
  'confirmed',
  'chat_review',
  reviewed_primary_unit,
  reviewed_required_units,
  'APPROVAL-0056 / DECISION-0066: blind independent multi-unit third review by anthropic/claude-haiku-4-5; exact required_units and primary_unit match. Candidate label withheld from the review prompt.'
from tmp_multi_unit_third_review;

update app.content_taxonomy_labels l
set
  label_status = 'validated',
  validation_decision_id = r.validation_decision_id,
  validated_by = 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,
  validated_at = now()
from tmp_multi_unit_third_review r
where l.content_taxonomy_label_id = r.content_taxonomy_label_id;

do $$
declare v_count integer;
begin
  select count(*) into v_count
  from tmp_multi_unit_third_review r
  join app.content_taxonomy_labels l
    on l.content_taxonomy_label_id = r.content_taxonomy_label_id
  where l.label_status = 'validated'
    and l.validation_decision_id = r.validation_decision_id;
  if v_count <> 27 then
    raise exception 'multi-unit third-review promotion failed: expected 27, found %', v_count;
  end if;
end $$;

commit;
