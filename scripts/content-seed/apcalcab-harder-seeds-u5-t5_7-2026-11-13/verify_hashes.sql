-- Read-only. Expect 24 rows with ok = true after load (and after publish).
with exp(k,h) as (values ('apcalcab-mcq-b14-h-5.7-a','652fcb5e771dc8676da09348eec9b507'),('apcalcab-mcq-b14-sv-h-5.7-a-v1','503f84b74a3d312cd207106cc639c7a4'),('apcalcab-mcq-b14-sv-h-5.7-a-v2','92bb77e593db5db9ac07ab1e29ed960f'),('apcalcab-mcq-b14-sv-h-5.7-a-v3','0dab376bb28f5e3a1333a5bc82d2d88e'),('apcalcab-mcq-b14-h-5.7-b','94d88524c0e887a59fa62a8ff174e2d1'),('apcalcab-mcq-b14-sv-h-5.7-b-v1','7bfeb424a464052377118b216170f423'),('apcalcab-mcq-b14-sv-h-5.7-b-v2','535a510e12c6102ae7cd3b3aa060ce79'),('apcalcab-mcq-b14-sv-h-5.7-b-v3','ff87ad6b07ea4d2e6e0eef7ee2d6d8db'),('apcalcab-mcq-b14-h-5.7-c','79f22d2bca6f8dcae3cad01d94123081'),('apcalcab-mcq-b14-sv-h-5.7-c-v1','18988bd7d006819a35eaa533ddca4e01'),('apcalcab-mcq-b14-sv-h-5.7-c-v2','f7d87b1f4dabc6fce0bc90b799dd8d50'),('apcalcab-mcq-b14-sv-h-5.7-c-v3','5230ca6a3d076d7b7ec06a3f1ca54cde')),
got as (select ci.content_key k, ci.status item_status, civ.status version_status,
  md5(civ.stem||'|'||string_agg(c.choice_key||':'||c.choice_text||':'||c.is_correct::text||':'||c.rationale,'|' order by c.choice_key)) h
  from app.content_items ci join app.content_item_versions civ on civ.content_item_id=ci.id and civ.version_num=1
  join app.mcq_choices c on c.content_item_version_id=civ.id
  where ci.exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and (ci.content_key like 'apcalcab-mcq-b14-h-5.%' or ci.content_key like 'apcalcab-mcq-b14-sv-h-5.%')
  group by ci.content_key, ci.status, civ.status, civ.stem)
select e.k, g.item_status, g.version_status, (g.h=e.h) ok from exp e left join got g on g.k=e.k order by e.k;
