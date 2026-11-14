-- Read-only. Expect 24 rows with ok = true after load (and after publish).
with exp(k,h) as (values ('apcalcab-mcq-b15-h-5.8-a','12c8b52162451e28f469869b0999f533'),('apcalcab-mcq-b15-sv-h-5.8-a-v1','35b2c3b7d74377832735d86e7761db89'),('apcalcab-mcq-b15-sv-h-5.8-a-v2','ce4bf71d5a54810dbb27e9387eb3bacd'),('apcalcab-mcq-b15-sv-h-5.8-a-v3','74ad25c4de27041c3461d97a56a5abaf'),('apcalcab-mcq-b15-h-5.8-b','541a04659d06241d103c7bb0688661ce'),('apcalcab-mcq-b15-sv-h-5.8-b-v1','cd385dafa6b0ee8a36ee7abeb422087c'),('apcalcab-mcq-b15-sv-h-5.8-b-v2','efcae63314982eca62c225121c702c2f'),('apcalcab-mcq-b15-sv-h-5.8-b-v3','653fd13bdd9ab72144ba68aafde0e5ab'),('apcalcab-mcq-b15-h-5.8-c','2a5442c12ec275663f9870b8e49d33ab'),('apcalcab-mcq-b15-sv-h-5.8-c-v1','c6799a700195f7ce959ddd7adb31197e'),('apcalcab-mcq-b15-sv-h-5.8-c-v2','e23035f33f2181cd19c3ffbbe019447e'),('apcalcab-mcq-b15-sv-h-5.8-c-v3','c7f49ca6e013d7bfb3574357f7862c44')),
got as (select ci.content_key k, ci.status item_status, civ.status version_status,
  md5(civ.stem||'|'||string_agg(c.choice_key||':'||c.choice_text||':'||c.is_correct::text||':'||c.rationale,'|' order by c.choice_key)) h
  from app.content_items ci join app.content_item_versions civ on civ.content_item_id=ci.id and civ.version_num=1
  join app.mcq_choices c on c.content_item_version_id=civ.id
  where ci.exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and (ci.content_key like 'apcalcab-mcq-b15-h-5.%' or ci.content_key like 'apcalcab-mcq-b15-sv-h-5.%')
  group by ci.content_key, ci.status, civ.status, civ.stem)
select e.k, g.item_status, g.version_status, (g.h=e.h) ok from exp e left join got g on g.k=e.k order by e.k;
