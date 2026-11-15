-- Read-only. Expect 24 rows with ok = true after load (and after publish).
with exp(k,h) as (values ('apcalcbc-mcq-b18-h-5.11-a','ca4a22ecf91f307568a962c6c3a8ddd3'),('apcalcbc-mcq-b18-sv-h-5.11-a-v1','f849c4825c199fe4088c782c71b489fc'),('apcalcbc-mcq-b18-sv-h-5.11-a-v2','f56df853f9281fa0f75f9d122d2dd9d1'),('apcalcbc-mcq-b18-sv-h-5.11-a-v3','5801a3a81aa8c9a96fc1431c23b6bfda'),('apcalcbc-mcq-b18-h-5.11-b','cd955f3262f8e3efce2020d5635479be'),('apcalcbc-mcq-b18-sv-h-5.11-b-v1','f2828f823110617d26e1b2e84266d63d'),('apcalcbc-mcq-b18-sv-h-5.11-b-v2','d7e04c8ef564d6804bc06d7f99734504'),('apcalcbc-mcq-b18-sv-h-5.11-b-v3','a06c6dda16523488d9f4321cc3bcde5f'),('apcalcbc-mcq-b18-h-5.11-c','7132a20da2f493189ecb4b54de51126e'),('apcalcbc-mcq-b18-sv-h-5.11-c-v1','24757e0f97dbf1bff13bd9833e15c26e'),('apcalcbc-mcq-b18-sv-h-5.11-c-v2','dfdd84dab50e2ff1551b80edc933b643'),('apcalcbc-mcq-b18-sv-h-5.11-c-v3','3f65c64a6c302151fde5406038b57547')),
got as (select ci.content_key k, ci.status item_status, civ.status version_status,
  md5(civ.stem||'|'||string_agg(c.choice_key||':'||c.choice_text||':'||c.is_correct::text||':'||c.rationale,'|' order by c.choice_key)) h
  from app.content_items ci join app.content_item_versions civ on civ.content_item_id=ci.id and civ.version_num=1
  join app.mcq_choices c on c.content_item_version_id=civ.id
  where ci.exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and (ci.content_key like 'apcalcbc-mcq-b18-h-5.%' or ci.content_key like 'apcalcbc-mcq-b18-sv-h-5.%')
  group by ci.content_key, ci.status, civ.status, civ.stem)
select e.k, g.item_status, g.version_status, (g.h=e.h) ok from exp e left join got g on g.k=e.k order by e.k;
