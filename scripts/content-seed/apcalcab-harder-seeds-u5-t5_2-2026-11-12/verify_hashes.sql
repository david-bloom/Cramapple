-- Read-only. Expect 24 rows with ok = true after load (and after publish).
with exp(k,h) as (values ('apcalcab-mcq-b9-h-5.2-a','c1e8ed2757ce7270e98a308a1456f8b9'),('apcalcab-mcq-b9-sv-h-5.2-a-v1','af03c2d363b3c21a5f1f98b371393b80'),('apcalcab-mcq-b9-sv-h-5.2-a-v2','4b26a2434320c0c4c4e4531f1ff79cda'),('apcalcab-mcq-b9-sv-h-5.2-a-v3','e581edb9fcf2b04aba732c59f827afa7'),('apcalcab-mcq-b9-h-5.2-b','15d3eb2347cd32df8c45f3af24052b54'),('apcalcab-mcq-b9-sv-h-5.2-b-v1','699813aebbf6a4efd6e33a379cb73ff7'),('apcalcab-mcq-b9-sv-h-5.2-b-v2','7bab60f73a96414672ff55f5550542e2'),('apcalcab-mcq-b9-sv-h-5.2-b-v3','0d1e8f5057c702daee954738671b36b7'),('apcalcab-mcq-b9-h-5.2-c','45c14f51e26c6dc979491886b68386b3'),('apcalcab-mcq-b9-sv-h-5.2-c-v1','4c22de51926f77445c423f506d48d4f2'),('apcalcab-mcq-b9-sv-h-5.2-c-v2','90a4d4e0107bb55bb90f399d46f552a8'),('apcalcab-mcq-b9-sv-h-5.2-c-v3','55394ad1519a8e84f0d96dc75a9f5f35')),
got as (select ci.content_key k, ci.status item_status, civ.status version_status,
  md5(civ.stem||'|'||string_agg(c.choice_key||':'||c.choice_text||':'||c.is_correct::text||':'||c.rationale,'|' order by c.choice_key)) h
  from app.content_items ci join app.content_item_versions civ on civ.content_item_id=ci.id and civ.version_num=1
  join app.mcq_choices c on c.content_item_version_id=civ.id
  where ci.exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and (ci.content_key like 'apcalcab-mcq-b9-h-5.%' or ci.content_key like 'apcalcab-mcq-b9-sv-h-5.%')
  group by ci.content_key, ci.status, civ.status, civ.stem)
select e.k, g.item_status, g.version_status, (g.h=e.h) ok from exp e left join got g on g.k=e.k order by e.k;
