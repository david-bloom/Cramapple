-- Read-only. Expect 24 rows with ok = true after load (and after publish).
with exp(k,h) as (values ('apbio-mcq-b2-h-5.2-a','a4cd77ed2c8df8f1774e0b415f8ce3c6'),('apbio-mcq-b2-sv-h-5.2-a-v1','dcf56fd509362a97f718f13ae4d443ee'),('apbio-mcq-b2-sv-h-5.2-a-v2','6b2c8f3d6b88ffce9b5494e14edad39d'),('apbio-mcq-b2-sv-h-5.2-a-v3','5187141214a50f39d6343413c82f207b'),('apbio-mcq-b2-h-5.2-b','3409aa7fb00e6f213d3d6fc3600cdfde'),('apbio-mcq-b2-sv-h-5.2-b-v1','4b83e4d9ba2732b7a3792ab1cb93b516'),('apbio-mcq-b2-sv-h-5.2-b-v2','46b78c980f696aaac83c2eeb9861f568'),('apbio-mcq-b2-sv-h-5.2-b-v3','c5b914c25e2d6738a0e6685bd3756f4b'),('apbio-mcq-b2-h-5.2-c','082edd55e360cef0daf1bcf1857eaf9e'),('apbio-mcq-b2-sv-h-5.2-c-v1','7c6116ec1c55b03e574f60901bd98ebb'),('apbio-mcq-b2-sv-h-5.2-c-v2','4e718305553508fa0c5cb11b8e3d9909'),('apbio-mcq-b2-sv-h-5.2-c-v3','7e4709a39c92e87aed845c2d10d68965')),
got as (select ci.content_key k, ci.status item_status, civ.status version_status,
  md5(civ.stem||'|'||string_agg(c.choice_key||':'||c.choice_text||':'||c.is_correct::text||':'||c.rationale,'|' order by c.choice_key)) h
  from app.content_items ci join app.content_item_versions civ on civ.content_item_id=ci.id and civ.version_num=1
  join app.mcq_choices c on c.content_item_version_id=civ.id
  where ci.exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and (ci.content_key like 'apbio-mcq-b2-h-5.%' or ci.content_key like 'apbio-mcq-b2-sv-h-5.%')
  group by ci.content_key, ci.status, civ.status, civ.stem)
select e.k, g.item_status, g.version_status, (g.h=e.h) ok from exp e left join got g on g.k=e.k order by e.k;
