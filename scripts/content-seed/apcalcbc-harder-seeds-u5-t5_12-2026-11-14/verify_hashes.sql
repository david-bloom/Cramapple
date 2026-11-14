-- Read-only. Expect 24 rows with ok = true after load (and after publish).
with exp(k,h) as (values ('apcalcbc-mcq-b19-h-5.12-a','dc11c6de3482514e9df8d97deff9c9c2'),('apcalcbc-mcq-b19-sv-h-5.12-a-v1','7ce3b5e17c57d2547b8334ed4e59e612'),('apcalcbc-mcq-b19-sv-h-5.12-a-v2','1af35d9b88924285c3a18bd9f595b083'),('apcalcbc-mcq-b19-sv-h-5.12-a-v3','c8297efd1e9314b12b797ed0498da06d'),('apcalcbc-mcq-b19-h-5.12-b','5f51e812644e98df9b3cb7dfbd7136c3'),('apcalcbc-mcq-b19-sv-h-5.12-b-v1','025174d7e9998be173ec9defc0a93719'),('apcalcbc-mcq-b19-sv-h-5.12-b-v2','fffb5f127a505a4c304cfa1a641a2ab9'),('apcalcbc-mcq-b19-sv-h-5.12-b-v3','7f89ca68c8eeb633ae6e25d9751e09b4'),('apcalcbc-mcq-b19-h-5.12-c','edc65b6bfbb510e1def413c9ae6bd2da'),('apcalcbc-mcq-b19-sv-h-5.12-c-v1','888e1985b775d59ce976bf5fb41bbba8'),('apcalcbc-mcq-b19-sv-h-5.12-c-v2','488db42fd52314ffb6ae8ec636f68a7e'),('apcalcbc-mcq-b19-sv-h-5.12-c-v3','ffb499b9f04d1f8833532263c3305c22')),
got as (select ci.content_key k, ci.status item_status, civ.status version_status,
  md5(civ.stem||'|'||string_agg(c.choice_key||':'||c.choice_text||':'||c.is_correct::text||':'||c.rationale,'|' order by c.choice_key)) h
  from app.content_items ci join app.content_item_versions civ on civ.content_item_id=ci.id and civ.version_num=1
  join app.mcq_choices c on c.content_item_version_id=civ.id
  where ci.exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and (ci.content_key like 'apcalcbc-mcq-b19-h-5.%' or ci.content_key like 'apcalcbc-mcq-b19-sv-h-5.%')
  group by ci.content_key, ci.status, civ.status, civ.stem)
select e.k, g.item_status, g.version_status, (g.h=e.h) ok from exp e left join got g on g.k=e.k order by e.k;
