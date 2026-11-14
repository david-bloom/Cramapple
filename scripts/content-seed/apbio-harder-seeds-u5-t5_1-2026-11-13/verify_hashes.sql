-- Read-only. Expect 24 rows with ok = true after load (and after publish).
with exp(k,h) as (values ('apbio-mcq-b1-h-5.1-a','afbeadc5b4489b4efa6f181903dcecbd'),('apbio-mcq-b1-sv-h-5.1-a-v1','ef87d49f7520ed0402500a8be8ed2ff4'),('apbio-mcq-b1-sv-h-5.1-a-v2','a1fcf2da38fcb614dfc0b57b12b9b494'),('apbio-mcq-b1-sv-h-5.1-a-v3','c6961980967c6227785bf0c31b5da877'),('apbio-mcq-b1-h-5.1-b','3110a6f156738a5e369e999da5c21295'),('apbio-mcq-b1-sv-h-5.1-b-v1','96d37150ea11d78efec77b054cc6478a'),('apbio-mcq-b1-sv-h-5.1-b-v2','996ddaf2905a7314f4bbb5b15626ac54'),('apbio-mcq-b1-sv-h-5.1-b-v3','ee9d0061b0735f769f6c9f9d0bdbbf0f'),('apbio-mcq-b1-h-5.1-c','c1e4a8b53d214e9c63bf7c50a79f4544'),('apbio-mcq-b1-sv-h-5.1-c-v1','981a820fc598463c57ae5d81645fc5c5'),('apbio-mcq-b1-sv-h-5.1-c-v2','ecc0d058b6d8a8ed8a427b6b7abb4b79'),('apbio-mcq-b1-sv-h-5.1-c-v3','82e84cf0ac3e0c1d894946320cf54202')),
got as (select ci.content_key k, ci.status item_status, civ.status version_status,
  md5(civ.stem||'|'||string_agg(c.choice_key||':'||c.choice_text||':'||c.is_correct::text||':'||c.rationale,'|' order by c.choice_key)) h
  from app.content_items ci join app.content_item_versions civ on civ.content_item_id=ci.id and civ.version_num=1
  join app.mcq_choices c on c.content_item_version_id=civ.id
  where ci.exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and (ci.content_key like 'apbio-mcq-b1-h-5.%' or ci.content_key like 'apbio-mcq-b1-sv-h-5.%')
  group by ci.content_key, ci.status, civ.status, civ.stem)
select e.k, g.item_status, g.version_status, (g.h=e.h) ok from exp e left join got g on g.k=e.k order by e.k;
