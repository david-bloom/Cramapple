-- Read-only. Expect 24 rows with ok = true after load (and after publish).
with exp(k,h) as (values ('apbio-mcq-b3-h-5.3-a','9ca0018a601066686d788480a607c4f8'),('apbio-mcq-b3-sv-h-5.3-a-v1','d09631217689e05022ee77b57900247c'),('apbio-mcq-b3-sv-h-5.3-a-v2','0c980de60c6d809a6e8f4578ad06deb6'),('apbio-mcq-b3-sv-h-5.3-a-v3','8c64e7f4420e14cd5f4384d61a2e3ee9'),('apbio-mcq-b3-h-5.3-b','e88066eb68ab1d1afad2c167c6d7647f'),('apbio-mcq-b3-sv-h-5.3-b-v1','69589760a2d344d258bb495138382130'),('apbio-mcq-b3-sv-h-5.3-b-v2','5db377ce91e9c4db4d29a8fab971c684'),('apbio-mcq-b3-sv-h-5.3-b-v3','5d27ff56f4724776b1ed94e27db5566e'),('apbio-mcq-b3-h-5.3-c','8e9686b42dff1ead8b3e121fa7200f21'),('apbio-mcq-b3-sv-h-5.3-c-v1','d5a3046e2aea95824620e40c4d501a44'),('apbio-mcq-b3-sv-h-5.3-c-v2','46ce6afaef43750dadd9f6f43e062200'),('apbio-mcq-b3-sv-h-5.3-c-v3','13f94ded9cc991ec03ea1bbee44cd006')),
got as (select ci.content_key k, ci.status item_status, civ.status version_status,
  md5(civ.stem||'|'||string_agg(c.choice_key||':'||c.choice_text||':'||c.is_correct::text||':'||c.rationale,'|' order by c.choice_key)) h
  from app.content_items ci join app.content_item_versions civ on civ.content_item_id=ci.id and civ.version_num=1
  join app.mcq_choices c on c.content_item_version_id=civ.id
  where ci.exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and (ci.content_key like 'apbio-mcq-b3-h-5.%' or ci.content_key like 'apbio-mcq-b3-sv-h-5.%')
  group by ci.content_key, ci.status, civ.status, civ.stem)
select e.k, g.item_status, g.version_status, (g.h=e.h) ok from exp e left join got g on g.k=e.k order by e.k;
