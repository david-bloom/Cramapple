-- Read-only. Expect 24 rows with ok = true after load (and after publish).
with exp(k,h) as (values ('apbio-mcq-b5-h-5.5-a','bdc471bd21046902390798104d1274a0'),('apbio-mcq-b5-sv-h-5.5-a-v1','bab2b93965c08f0ef6cd76cdc21bd9d8'),('apbio-mcq-b5-sv-h-5.5-a-v2','f415b191e759ab715aed5df675739212'),('apbio-mcq-b5-sv-h-5.5-a-v3','8ff32dc22b245b411a7f814dfdd98804'),('apbio-mcq-b5-h-5.5-b','a28a2f84189ab2542fe246ffcac8e8e8'),('apbio-mcq-b5-sv-h-5.5-b-v1','93319e3d686a683e0c63c4c58bd51f65'),('apbio-mcq-b5-sv-h-5.5-b-v2','3ccd50bef04bb35a9ffa8887dd52acb0'),('apbio-mcq-b5-sv-h-5.5-b-v3','aeada35df7b8fe539ba02b51121d055e'),('apbio-mcq-b5-h-5.5-c','9da2e2608439eb7ea403165fe12e161f'),('apbio-mcq-b5-sv-h-5.5-c-v1','9a700f44c143a75fdf4217d5cc37149f'),('apbio-mcq-b5-sv-h-5.5-c-v2','b63c2f497b283a0af6e4b4b66bfbae68'),('apbio-mcq-b5-sv-h-5.5-c-v3','abf23ee6255dfb48d9623472a80399fa')),
got as (select ci.content_key k, ci.status item_status, civ.status version_status,
  md5(civ.stem||'|'||string_agg(c.choice_key||':'||c.choice_text||':'||c.is_correct::text||':'||c.rationale,'|' order by c.choice_key)) h
  from app.content_items ci join app.content_item_versions civ on civ.content_item_id=ci.id and civ.version_num=1
  join app.mcq_choices c on c.content_item_version_id=civ.id
  where ci.exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and (ci.content_key like 'apbio-mcq-b5-h-5.%' or ci.content_key like 'apbio-mcq-b5-sv-h-5.%')
  group by ci.content_key, ci.status, civ.status, civ.stem)
select e.k, g.item_status, g.version_status, (g.h=e.h) ok from exp e left join got g on g.k=e.k order by e.k;
