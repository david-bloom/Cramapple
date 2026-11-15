-- Read-only. Expect 24 rows with ok = true after load (and after publish).
with exp(k,h) as (values ('apcalcbc-mcq-b13-h-5.6-a','ae594e0be7d90a1af5c94426bbf83239'),('apcalcbc-mcq-b13-sv-h-5.6-a-v1','fc8225cb6465d1121449db7d95f4db40'),('apcalcbc-mcq-b13-sv-h-5.6-a-v2','d89962b9a66d063bb664b37df24ab96f'),('apcalcbc-mcq-b13-sv-h-5.6-a-v3','d20dcec659317038360bfafe5cc00f85'),('apcalcbc-mcq-b13-h-5.6-b','209f66c95e21a909c8a06b66d98c0edd'),('apcalcbc-mcq-b13-sv-h-5.6-b-v1','397e9719188f1959627203f0078c53e4'),('apcalcbc-mcq-b13-sv-h-5.6-b-v2','e5591fec0fdab0a4be365e6f44c53fe5'),('apcalcbc-mcq-b13-sv-h-5.6-b-v3','dfef1a5b7f86dc5042c58a2267ff9f1a'),('apcalcbc-mcq-b13-h-5.6-c','ee5b4a8810be54de29f2d276f37d5d49'),('apcalcbc-mcq-b13-sv-h-5.6-c-v1','2d89322efc8c4798d172428bd7037ead'),('apcalcbc-mcq-b13-sv-h-5.6-c-v2','65acd94100d665603b5bc52aaaa8616e'),('apcalcbc-mcq-b13-sv-h-5.6-c-v3','dc3c72d8f2ae35ad75ead8ce8b337817')),
got as (select ci.content_key k, ci.status item_status, civ.status version_status,
  md5(civ.stem||'|'||string_agg(c.choice_key||':'||c.choice_text||':'||c.is_correct::text||':'||c.rationale,'|' order by c.choice_key)) h
  from app.content_items ci join app.content_item_versions civ on civ.content_item_id=ci.id and civ.version_num=1
  join app.mcq_choices c on c.content_item_version_id=civ.id
  where ci.exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and (ci.content_key like 'apcalcbc-mcq-b13-h-5.%' or ci.content_key like 'apcalcbc-mcq-b13-sv-h-5.%')
  group by ci.content_key, ci.status, civ.status, civ.stem)
select e.k, g.item_status, g.version_status, (g.h=e.h) ok from exp e left join got g on g.k=e.k order by e.k;
