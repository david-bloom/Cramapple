-- TASK-0050 publish-14 read-only preflight. No writes.
with expected(content_key, version_id, content_hash) as (values
    ('APSTATS-HDG-2026-GRAPH-001','ae3fd164-f16b-4f23-b1a7-c86e72c7c3ab'::uuid,'9e2bd7fe88506a4d8026147896100924'),
    ('APSTATS-HDG-2026-GRAPH-021','0fe14387-dd33-41a9-86a9-1b750ad9f8c5'::uuid,'e1c81e0fe6b46a6d82c39e9a126f88e5'),
    ('APSTATS-HDG-2026-GRAPH-022','d7d85a99-bdc4-41ae-9b00-03a12f28dea8'::uuid,'8e4dbac111c71250c5dd2498873a34da'),
    ('APSTATS-HDG-2026-GRAPH-024','e75d8820-7e85-4bad-8056-98ba27af3b0b'::uuid,'703d24b3d6a3b7d034b56dbb2673f6e7'),
    ('APSTATS-HDG-2026-GRAPH-026','38dc9a05-3a41-4ca8-bf28-040d62df283f'::uuid,'fcc492d7a9378b4337038424c6961089'),
    ('APSTATS-HDG-2026-GRAPH-029','270cc4d2-323c-43a9-9c2c-4277ffbea235'::uuid,'00a71d28e70cc20f98d9665acc06c34d'),
    ('APSTATS-HDG-2026-GRAPH-032','98e1db6e-ebee-48e2-8ef9-dfd00c10cc5e'::uuid,'b6a8980fedf99cef417537db0b8392a5'),
    ('APSTATS-HDG-2026-GRAPH-036','274d2e39-e4ca-435e-9d31-04d8b3fd0bdc'::uuid,'abd20b1b82dc7b181f8be427c76bbc58'),
    ('APSTATS-MCQ-002-CAL','f8ec7c37-02ef-4086-8ff2-1171c2035825'::uuid,'0ae99d62d483278a0139c4c289627e4428d72865acd8e15eb38075c33c52e945'),
    ('APSTATS-MCQ-007','7921ecab-7098-4d9f-92ad-6ffc69279113'::uuid,'2a21c083500ba94c77000733097a6935e8709d5b781a4464d78443445cee76a8'),
    ('APSTATS-MCQ-007-CAL','1a3ef4df-21ce-4d21-aaff-91bf7b826fd2'::uuid,'0ae99d62d483278a0139c4c289627e4428d72865acd8e15eb38075c33c52e945'),
    ('APSTATS-MCQ-010','c82cd294-e08a-4aa9-b7f7-ed3fa7369d33'::uuid,'7fc137412da39f0875c906d3cd907f340132915260e123749ed16739ac114b79'),
    ('APSTATS-MCQ-012','28f514dd-4acb-437f-9430-88457c72bf1f'::uuid,'f8c0dbeb52c9ee637ebbb9c1c15bf860dc9c188bdaf23019de47fcb49d853abd'),
    ('APSTATS-MCQ-017','a03cd184-777a-4bf3-92fe-49fcc9fff0b7'::uuid,'e835b9a0f34e833174ede6554ac272d701dee6cfc4a6d0068ad20afeac79d7f5')
), audit as (
 select e.content_key, e.version_id,
        ci.id item_id, ci.status item_status, v.status version_status,
        v.review_status, v.content_hash = e.content_hash hash_matches,
        (select count(*) from app.content_item_versions v2 where v2.content_item_id=ci.id) version_count,
        (select count(*) from app.content_item_versions v2 where v2.content_item_id=ci.id and v2.status='published') published_version_count,
        (select count(*) from app.content_item_cells c where c.content_item_version_id=v.id) existing_cells,
        (select count(*) from app.content_item_topic_resolution tr where tr.content_item_version_id=v.id) topic_resolutions,
        (select count(*) from app.attempts a where a.content_item_version_id=v.id) historical_attempts
 from expected e left join app.content_items ci on ci.content_key=e.content_key
      and ci.exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438'::uuid
 left join app.content_item_versions v on v.id=e.version_id and v.content_item_id=ci.id
)
select * from audit order by content_key;
