-- Read-only. Expect 24 rows with ok = true after load (and after publish).
with exp(k,h) as (values ('apbio-mcq-b4-h-5.4-a','a8905d82c90ea640957a8fc2ade39256'),('apbio-mcq-b4-sv-h-5.4-a-v1','c5eb56cd3f1640c24f7daa4c4a9215ac'),('apbio-mcq-b4-sv-h-5.4-a-v2','46a78268a183b3c3533a60e6a0b27d3b'),('apbio-mcq-b4-sv-h-5.4-a-v3','65fb74424dc3ecfe19683747f5088255'),('apbio-mcq-b4-h-5.4-b','e6024cf8f40fa77f46f47e1a215a1bda'),('apbio-mcq-b4-sv-h-5.4-b-v1','b4cb886e791a0df4f78b7fca596c2d9d'),('apbio-mcq-b4-sv-h-5.4-b-v2','3da61693e1add7567a67cbf7f51da5c0'),('apbio-mcq-b4-sv-h-5.4-b-v3','ccd2c9a6f97b48fb944a5d8680c59d12'),('apbio-mcq-b4-h-5.4-c','b76dd1fefb6c38736c92bb49119d1024'),('apbio-mcq-b4-sv-h-5.4-c-v1','eca383e649161f5144c126c613ab93e0'),('apbio-mcq-b4-sv-h-5.4-c-v2','97f80ce20496c82b33094e252437decb'),('apbio-mcq-b4-sv-h-5.4-c-v3','bd9bf91142af4496687a75f3d6829f69')),
got as (select ci.content_key k, ci.status item_status, civ.status version_status,
  md5(civ.stem||'|'||string_agg(c.choice_key||':'||c.choice_text||':'||c.is_correct::text||':'||c.rationale,'|' order by c.choice_key)) h
  from app.content_items ci join app.content_item_versions civ on civ.content_item_id=ci.id and civ.version_num=1
  join app.mcq_choices c on c.content_item_version_id=civ.id
  where ci.exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and (ci.content_key like 'apbio-mcq-b4-h-5.%' or ci.content_key like 'apbio-mcq-b4-sv-h-5.%')
  group by ci.content_key, ci.status, civ.status, civ.stem)
select e.k, g.item_status, g.version_status, (g.h=e.h) ok from exp e left join got g on g.k=e.k order by e.k;
