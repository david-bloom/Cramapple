-- Read-only. Expect 24 rows with ok = true after load (and after publish).
with exp(k,h) as (values ('apcalcbc-mcq-b10-h-5.3-a','ca389565588d177f0bdc2fa5c7ba45e6'),('apcalcbc-mcq-b10-sv-h-5.3-a-v1','fafeb2c13e0f8b9bdf8cce01c6e6f203'),('apcalcbc-mcq-b10-sv-h-5.3-a-v2','6dcd0f253ed04a0aa63f41d41eb143b5'),('apcalcbc-mcq-b10-sv-h-5.3-a-v3','1fa045e8358034b549dda2b0f95895ab'),('apcalcbc-mcq-b10-h-5.3-b','bb88c3f3038788bb2825d7bb298de86b'),('apcalcbc-mcq-b10-sv-h-5.3-b-v1','27cb7e6f67271543d07d53bc52d0552d'),('apcalcbc-mcq-b10-sv-h-5.3-b-v2','79af126a6f4968860b1ad503b5f8d3ab'),('apcalcbc-mcq-b10-sv-h-5.3-b-v3','b14f4614c4d0ed8faea66e5c520a1d45'),('apcalcbc-mcq-b10-h-5.3-c','228bcc4dce95d9c3fe88ff52b41de25e'),('apcalcbc-mcq-b10-sv-h-5.3-c-v1','564aa9ce3839e0bcade95baeaaaf08ef'),('apcalcbc-mcq-b10-sv-h-5.3-c-v2','0ccba9049b2f99a8661983fd28fbbe5f'),('apcalcbc-mcq-b10-sv-h-5.3-c-v3','054ff6621aed9161612e4e98e366ae19')),
got as (select ci.content_key k, ci.status item_status, civ.status version_status,
  md5(civ.stem||'|'||string_agg(c.choice_key||':'||c.choice_text||':'||c.is_correct::text||':'||c.rationale,'|' order by c.choice_key)) h
  from app.content_items ci join app.content_item_versions civ on civ.content_item_id=ci.id and civ.version_num=1
  join app.mcq_choices c on c.content_item_version_id=civ.id
  where ci.exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and (ci.content_key like 'apcalcbc-mcq-b10-h-5.%' or ci.content_key like 'apcalcbc-mcq-b10-sv-h-5.%')
  group by ci.content_key, ci.status, civ.status, civ.stem)
select e.k, g.item_status, g.version_status, (g.h=e.h) ok from exp e left join got g on g.k=e.k order by e.k;
