with exp(content_key, h_stem, h_body, stim) as (values
('apcalcab-mcq-sv-001-v1','01e51455b362c5e0c8f60efa5a4c1feb','ef4285fd8a0ef2bcaaedb7616e2f12e8',''),
('apcalcab-mcq-sv-001-v2','81e0dbc307d9d400bef8d4d0d3d5bebd','9c31422bc11268bb4ed7eae16878ad52',''),
('apcalcab-mcq-sv-026-v1','8515c6410611b288927a926c90b927b4','72bed8b74adffe4a10862074579b7868','No calculator is permitted.'),
('apcalcab-mcq-sv-026-v2','358cf654436b7a154357a3e68dbc24e2','84071cdf6ad272595f7b3768704b447f','No calculator is permitted.'),
('apcalcab-mcq-sv-029-v1','931a2e137f51018cf776e7bd658f33c8','59fd1b6792c7e0a6c3c0aee9aa6a2739','No calculator is permitted.'),
('apcalcab-mcq-sv-029-v2','6b391490e2c9ffc998905430b91230e5','c3d0caa5bf3c49111b4edb5b73ffb407','No calculator is permitted.'),
('apcalcab-mcq-sv-031-v1','08c689819361f83f9eb390da275c9871','a9fcb0f9b668e98d5e754a207444c044','A graphing calculator is permitted.'),
('apcalcab-mcq-sv-031-v2','eb705860ff2393ae7f874e3054850197','22151c169d93f37329b85dfe41e4e6a0','A graphing calculator is permitted.'),
('apcalcab-mcq-sv-038-v1','3e284a7ba9808f16b9899352cc308a75','387c4f0ff71541cd15394430d422c004','No calculator is permitted.'),
('apcalcab-mcq-sv-038-v2','bab82352addeaa239237edc91cf367ff','9e92796d33dd93cd717e7f8e877c0cb5','No calculator is permitted.'),
('apcalcab-mcq-sv-017-v1','1cd271d194f6fc277983d29cca3a4946','c849fe4b22faa87176e71a72bdfe242f',''),
('apcalcab-mcq-sv-017-v2','dab1522760d557dd12dbef04d5467821','6127bfdd5c30f30cca7732d801379c88',''),
('apcalcab-mcq-sv-np2-006-v1','4f411ad834027fccb581b1f2e86429da','dbfa4a674344b96d9e11318ef6981bcd',''),
('apcalcab-mcq-sv-np2-006-v2','e4cce4918fbca8dbef94dcd0064a7e52','f4a2fa03742cc047c62ef3068a37c7c9',''),
('apcalcab-mcq-sv-016-v1','9a6f838129d1f6537f3356bf53ca66ce','e45fc17ae4d26351a8774baa40ee632c',''),
('apcalcab-mcq-sv-016-v2','48174ca845aaf02d6195234ff000d034','05933a5977d84c7c8d2943f1d8b31df2',''),
('apcalcab-mcq-sv-005-v1','1695abd7165e9df48409d4f1c649d2b4','11929f2fa6da435daee3a199b7f230ad',''),
('apcalcab-mcq-sv-005-v2','9d3895cc219b2c2904aea1c4bfd12a5f','e911858207e4397e3c18c5ec3b4339a7',''),
('apcalcab-mcq-sv-007-v1','7594d53812285ed6d8faa57d2331e747','9dff2ebd1011d4b961afb6f1d751a52a',''),
('apcalcab-mcq-sv-007-v2','baa8a862dde897fcce4b659d60b3068f','9146e965789424d673c24fca1d7fe323',''),
('apcalcab-mcq-sv-030-v1','4872fff8565ce1f2a22c31ebd08c1874','e4321ad42c6301903ab80e8767e9e423',''),
('apcalcab-mcq-sv-030-v2','c4547e6e368b30c1eca43952b0608ef3','fa55bfd2e8013a5ae917a910f1ed5d5e',''),
('apcalcab-mcq-sv-008-v1','5b9b37e9cf522d91d23907551d912646','85c9348af8ab59b74790b8a6a6fd90b7',''),
('apcalcab-mcq-sv-008-v2','aa38dd62e39b288b8e29ffafb6cd7d76','9599ae07624971526d9b7277282b1ef0','')
), act as (
  select ci.content_key, md5(civ.stem) h_stem,
    md5((select string_agg(m.choice_text || '|' || m.is_correct::text || '|' || m.rationale, E'\n' order by (m.choice_text || '|' || m.is_correct::text || '|' || m.rationale) collate "C") from app.mcq_choices m where m.content_item_version_id = civ.id)) h_body,
    coalesce(civ.stimulus,'') stim, civ.canonical_answer_1,
    (select m.choice_key from app.mcq_choices m where m.content_item_version_id = civ.id and m.is_correct limit 1) correct_letter
  from app.content_items ci join app.content_item_versions civ on civ.content_item_id = ci.id and civ.version_num = 1
  where ci.exam_pack_version_id = '826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and ci.content_key like 'apcalcab-mcq-sv-%'
)
select (select count(*) from exp) expected_items, (select count(*) from act) loaded_items,
  (select count(*) from exp e join act a using (content_key) where e.h_stem = a.h_stem and e.h_body = a.h_body and e.stim = a.stim) exact_matches,
  (select coalesce(string_agg(e.content_key, ', '), 'none') from exp e join act a using (content_key) where e.h_stem <> a.h_stem or e.h_body <> a.h_body or e.stim <> a.stim) loaded_but_mismatched,
  (select count(*) from exp e left join act a using (content_key) where a.content_key is null) not_yet_loaded,
  (select count(*) from act where canonical_answer_1 is distinct from correct_letter) letter_key_inconsistent;
