-- Read-only. Expect 24 rows with ok = true after load (and after publish).
with exp(k,h) as (values ('apcalcab-mcq-b17-h-5.10-a','310c5df8ddfb37e4ab2d82f3e91b985f'),('apcalcab-mcq-b17-sv-h-5.10-a-v1','b8544f897bbf4c6527c37454677907f9'),('apcalcab-mcq-b17-sv-h-5.10-a-v2','f714cd7642b4e1a55dcd552cf4837086'),('apcalcab-mcq-b17-sv-h-5.10-a-v3','54323412119c85d36f0feecbb627a237'),('apcalcab-mcq-b17-h-5.10-b','a95bc6205f3988ec62a7717897edd7fa'),('apcalcab-mcq-b17-sv-h-5.10-b-v1','61e225a1461bafede9a3607148f57431'),('apcalcab-mcq-b17-sv-h-5.10-b-v2','dd9d5a35fd88be21bdc3378700569d38'),('apcalcab-mcq-b17-sv-h-5.10-b-v3','254d9aaaed6cd2fbe12b7edf0121c378'),('apcalcab-mcq-b17-h-5.10-c','895151ca3a57c3993fa5bcb906aa34f3'),('apcalcab-mcq-b17-sv-h-5.10-c-v1','878740bcbf8bd986aaf224b179e26fb4'),('apcalcab-mcq-b17-sv-h-5.10-c-v2','d274b08a6e39ce4a84982f041313141b'),('apcalcab-mcq-b17-sv-h-5.10-c-v3','f71ee6500bac4d808312cef37f705729')),
got as (select ci.content_key k, ci.status item_status, civ.status version_status,
  md5(civ.stem||'|'||string_agg(c.choice_key||':'||c.choice_text||':'||c.is_correct::text||':'||c.rationale,'|' order by c.choice_key)) h
  from app.content_items ci join app.content_item_versions civ on civ.content_item_id=ci.id and civ.version_num=1
  join app.mcq_choices c on c.content_item_version_id=civ.id
  where ci.exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and (ci.content_key like 'apcalcab-mcq-b17-h-5.%' or ci.content_key like 'apcalcab-mcq-b17-sv-h-5.%')
  group by ci.content_key, ci.status, civ.status, civ.stem)
select e.k, g.item_status, g.version_status, (g.h=e.h) ok from exp e left join got g on g.k=e.k order by e.k;
