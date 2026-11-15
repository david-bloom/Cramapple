-- Read-only. Expect 24 rows with ok = true after load (and after publish).
with exp(k,h) as (values ('apcalcbc-mcq-b11-h-5.4-a','f6160a1bff676fd0bdd837e23f771abf'),('apcalcbc-mcq-b11-sv-h-5.4-a-v1','d15c596d08b1a4a93450db2a8ed425de'),('apcalcbc-mcq-b11-sv-h-5.4-a-v2','55ec6d327201ceac370da1ccc89c5b06'),('apcalcbc-mcq-b11-sv-h-5.4-a-v3','1a3b3eb36e5d6f7c00b9e73f4841e459'),('apcalcbc-mcq-b11-h-5.4-b','826220423b728bacedd60bd08d8ac968'),('apcalcbc-mcq-b11-sv-h-5.4-b-v1','822044486ed52194892f7f9b789864cc'),('apcalcbc-mcq-b11-sv-h-5.4-b-v2','8dc3feb6ab22a642bbf5b5892207435c'),('apcalcbc-mcq-b11-sv-h-5.4-b-v3','de00463e85cb831db9934987e4ff2f5e'),('apcalcbc-mcq-b11-h-5.4-c','afa256b1d033c543dcebe4938a5914b5'),('apcalcbc-mcq-b11-sv-h-5.4-c-v1','552386b002afa91ca8e02290dea38f39'),('apcalcbc-mcq-b11-sv-h-5.4-c-v2','b5476ffbfbd9bef6ae92ba0fab867d66'),('apcalcbc-mcq-b11-sv-h-5.4-c-v3','49b192126ab37d6c324e34e530828006')),
got as (select ci.content_key k, ci.status item_status, civ.status version_status,
  md5(civ.stem||'|'||string_agg(c.choice_key||':'||c.choice_text||':'||c.is_correct::text||':'||c.rationale,'|' order by c.choice_key)) h
  from app.content_items ci join app.content_item_versions civ on civ.content_item_id=ci.id and civ.version_num=1
  join app.mcq_choices c on c.content_item_version_id=civ.id
  where ci.exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and (ci.content_key like 'apcalcbc-mcq-b11-h-5.%' or ci.content_key like 'apcalcbc-mcq-b11-sv-h-5.%')
  group by ci.content_key, ci.status, civ.status, civ.stem)
select e.k, g.item_status, g.version_status, (g.h=e.h) ok from exp e left join got g on g.k=e.k order by e.k;
