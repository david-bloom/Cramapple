-- Read-only. Expect 24 rows with ok = true after load (and after publish).
with exp(k,h) as (values ('apcalcab-mcq-b12-h-5.5-a','b4f6962e6de3c779dd6bd1bdfc0c345f'),('apcalcab-mcq-b12-sv-h-5.5-a-v1','cede46802cc4a3aff40a444dda8b8cf0'),('apcalcab-mcq-b12-sv-h-5.5-a-v2','92dedb82db4ee24e9142a6ab9b11b2d7'),('apcalcab-mcq-b12-sv-h-5.5-a-v3','7995714eac8f77beb08fc34b433db6e0'),('apcalcab-mcq-b12-h-5.5-b','4c38e024b52c0b17c2cb619d3895c7b0'),('apcalcab-mcq-b12-sv-h-5.5-b-v1','33dd60944b42409f5b296cdd46323a19'),('apcalcab-mcq-b12-sv-h-5.5-b-v2','6fa305a04cd3557b5695eb822d4071b2'),('apcalcab-mcq-b12-sv-h-5.5-b-v3','d3c789d9d5bc61c18589e21c05ab8013'),('apcalcab-mcq-b12-h-5.5-c','590fa6e04f492d827fbb2bec72705692'),('apcalcab-mcq-b12-sv-h-5.5-c-v1','2869c8f1fd879704bafbcce8ef482048'),('apcalcab-mcq-b12-sv-h-5.5-c-v2','9614f6c1472bce9a2600a67334014bf6'),('apcalcab-mcq-b12-sv-h-5.5-c-v3','2677c899d90219bf133c74ba1cb61bd3')),
got as (select ci.content_key k, ci.status item_status, civ.status version_status,
  md5(civ.stem||'|'||string_agg(c.choice_key||':'||c.choice_text||':'||c.is_correct::text||':'||c.rationale,'|' order by c.choice_key)) h
  from app.content_items ci join app.content_item_versions civ on civ.content_item_id=ci.id and civ.version_num=1
  join app.mcq_choices c on c.content_item_version_id=civ.id
  where ci.exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and (ci.content_key like 'apcalcab-mcq-b12-h-5.%' or ci.content_key like 'apcalcab-mcq-b12-sv-h-5.%')
  group by ci.content_key, ci.status, civ.status, civ.stem)
select e.k, g.item_status, g.version_status, (g.h=e.h) ok from exp e left join got g on g.k=e.k order by e.k;
