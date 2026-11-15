-- Read-only. Expect 24 rows with ok = true after load (and after publish).
with exp(k,h) as (values ('apcalcab-mcq-b8-h-5.1-a','5945163ba9edb184082f6e66d422095c'),('apcalcab-mcq-b8-sv-h-5.1-a-v1','e93f3ced9fb62e282508c051e2170e0a'),('apcalcab-mcq-b8-sv-h-5.1-a-v2','a16fbf5b5f60da8f997003cce6008ad9'),('apcalcab-mcq-b8-sv-h-5.1-a-v3','1c1795c3b56ac2100bfab95330d76f8f'),('apcalcab-mcq-b8-h-5.1-b','c70bd42eb792f09cd61cae79167cd8d6'),('apcalcab-mcq-b8-sv-h-5.1-b-v1','80779042e430583e5fa13a5f2b0a7586'),('apcalcab-mcq-b8-sv-h-5.1-b-v2','de3eb21d6fe5676de206cae27483b482'),('apcalcab-mcq-b8-sv-h-5.1-b-v3','3f3579971936c72908473fd9dd39fd8f'),('apcalcab-mcq-b8-h-5.1-c','8ec5b06dcc52cfc24613d319bc5643d0'),('apcalcab-mcq-b8-sv-h-5.1-c-v1','ff5606d3f332f7c6082254e02e9698f4'),('apcalcab-mcq-b8-sv-h-5.1-c-v2','5ddc2b0b281d946bf5771cbe0b032cf6'),('apcalcab-mcq-b8-sv-h-5.1-c-v3','3b17a7e5f9d3401c7739323a48d9ba9a')),
got as (select ci.content_key k, ci.status item_status, civ.status version_status,
  md5(civ.stem||'|'||string_agg(c.choice_key||':'||c.choice_text||':'||c.is_correct::text||':'||c.rationale,'|' order by c.choice_key)) h
  from app.content_items ci join app.content_item_versions civ on civ.content_item_id=ci.id and civ.version_num=1
  join app.mcq_choices c on c.content_item_version_id=civ.id
  where ci.exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and (ci.content_key like 'apcalcab-mcq-b8-h-5.%' or ci.content_key like 'apcalcab-mcq-b8-sv-h-5.%')
  group by ci.content_key, ci.status, civ.status, civ.stem)
select e.k, g.item_status, g.version_status, (g.h=e.h) ok from exp e left join got g on g.k=e.k order by e.k;
