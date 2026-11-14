-- Read-only. Expect 24 rows with ok = true after load (and after publish).
with exp(k,h) as (values ('apcalcbc-mcq-b16-h-5.9-a','c84b8c9f3e9f8a523d217299cad30468'),('apcalcbc-mcq-b16-sv-h-5.9-a-v1','eaf674be44995fe80480c4de5d5f9dfc'),('apcalcbc-mcq-b16-sv-h-5.9-a-v2','f7ae16c95fa91bf84b436d817d1b3455'),('apcalcbc-mcq-b16-sv-h-5.9-a-v3','a678c31223e35720401598f6b0385b29'),('apcalcbc-mcq-b16-h-5.9-b','7b2b51a08ae3c79b00ec395d994a3803'),('apcalcbc-mcq-b16-sv-h-5.9-b-v1','02a4ac9dd1b39af0faa4ea06e281e4ee'),('apcalcbc-mcq-b16-sv-h-5.9-b-v2','7b2614f2a2fff399eeec279ffa23464a'),('apcalcbc-mcq-b16-sv-h-5.9-b-v3','ae6aad57aaffa7d898b77c0fa37ed1ba'),('apcalcbc-mcq-b16-h-5.9-c','de6168ab39b64adff7e2b0bdcd9c42f8'),('apcalcbc-mcq-b16-sv-h-5.9-c-v1','a167819970c21b5450a4035d903ccebe'),('apcalcbc-mcq-b16-sv-h-5.9-c-v2','65dfdf891336b677ffe4503dd345e666'),('apcalcbc-mcq-b16-sv-h-5.9-c-v3','4d9e9ae5df2f50faf5dec2e3cdbebe82')),
got as (select ci.content_key k, ci.status item_status, civ.status version_status,
  md5(civ.stem||'|'||string_agg(c.choice_key||':'||c.choice_text||':'||c.is_correct::text||':'||c.rationale,'|' order by c.choice_key)) h
  from app.content_items ci join app.content_item_versions civ on civ.content_item_id=ci.id and civ.version_num=1
  join app.mcq_choices c on c.content_item_version_id=civ.id
  where ci.exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and (ci.content_key like 'apcalcbc-mcq-b16-h-5.%' or ci.content_key like 'apcalcbc-mcq-b16-sv-h-5.%')
  group by ci.content_key, ci.status, civ.status, civ.stem)
select e.k, g.item_status, g.version_status, (g.h=e.h) ok from exp e left join got g on g.k=e.k order by e.k;
