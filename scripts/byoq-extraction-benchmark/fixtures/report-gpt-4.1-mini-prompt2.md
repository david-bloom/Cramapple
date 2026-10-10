# BYOQ extraction benchmark — model gpt-4.1-mini — 2026-10-09T11:40:54.723Z

Pages: 210; proposed 210; failed 0
Latency median 2362 ms, p90 3555 ms
Tokens: input 761462, output 33965 (per page avg 3626 in / 162 out)

| cohort | n | type ok | stem ≥0.95 | stem ≥0.85 | mean stem sim | choices exact | topic top-1 | topic top-3 | leak flags | planted answer in text |
|---|---|---|---|---|---|---|---|---|---|---|
| clean | 89 | 100.0% (89/89) | 83.1% (74/89) | 100.0% (89/89) | 0.976 | 97.5% (78/80) | 80.9% (72/89) | 86.5% (77/89) | 0 | 0 |
| degraded | 89 | 100.0% (89/89) | 89.9% (80/89) | 100.0% (89/89) | 0.979 | 97.5% (78/80) | 79.8% (71/89) | 88.8% (79/89) | 0 | 0 |
| control | 30 | 100.0% (30/30) | 90.0% (27/30) | 100.0% (30/30) | 0.978 | 92.6% (25/27) | 86.7% (26/30) | 90.0% (27/30) | 0 | 0 |

## Planted controls
- circled:A (pages/control/27198229-babf-416d-93e8-1a1fd17a33df.png): captured_work=yes; leak_flags=0; in_text=false
- answer_line:B (pages/control/730c7ce7-4fbb-4793-a902-3af5dff8263b.png): captured_work=NO; leak_flags=0; in_text=false
- answer_key:C (pages/control/51f7683e-88bb-4214-84d5-ee0cfc7e3fe1.png): answer_key_present=true; captured_work=none; in_text=false
- name (pages/control/98dc1c7e-aaf3-451c-80bc-75d10b956334.png): pii=true
- handwritten_work (pages/control/5eac3a09-2cb7-424c-8682-d055e9fc7616.png): captured_work=yes; leak_flags=0; in_text=false
- circled:A (pages/control/66745782-603f-450e-aada-928ef876ba62.png): captured_work=yes; leak_flags=0; in_text=false
- answer_line (pages/control/f4d35317-2923-4924-8d15-0f815210440e.png): captured_work=NO; leak_flags=0; in_text=false
- answer_key:B (pages/control/498e7e4a-0ce1-4e9c-b96c-cbde81215243.png): answer_key_present=true; captured_work=none; in_text=false
- name (pages/control/6a9dd588-60c9-4762-819e-a10f57dd4918.png): pii=true
- handwritten_work (pages/control/b0aa5401-bb46-47b6-8dc6-7077057311d7.png): captured_work=yes; leak_flags=0; in_text=false
- circled:C (pages/control/c11e7e49-0354-4407-bb0f-e6eb7b176a10.png): captured_work=yes; leak_flags=0; in_text=false
- answer_line:D (pages/control/adbc44e7-24f4-4e7b-b38a-757170c175f5.png): captured_work=NO; leak_flags=0; in_text=false
- answer_key:D (pages/control/dd94279c-f1d9-44eb-92b4-8675b2cdfb6a.png): answer_key_present=true; captured_work=none; in_text=false
- name (pages/control/ab965996-0427-4da6-951b-29d46291db46.png): pii=false
- handwritten_work (pages/control/3b89460b-cf46-496a-86c9-1051a1b3133c.png): captured_work=yes; leak_flags=0; in_text=false
- circled:D (pages/control/603f1598-2a74-42cd-95e7-49f5426285c6.png): captured_work=yes; leak_flags=0; in_text=false
- answer_line:D (pages/control/d0d472d1-ff08-4a7b-bc4d-ca14b149642c.png): captured_work=NO; leak_flags=0; in_text=false
- answer_key:D (pages/control/66e77b42-e03d-46b2-b50f-ca4773b45f9c.png): answer_key_present=true; captured_work=none; in_text=false
- name (pages/control/0d2259c0-f24f-4e1d-ab09-2941ba5568b5.png): pii=true
- handwritten_work (pages/control/3f0530a8-6281-4f62-a80b-7797256a8474.png): captured_work=yes; leak_flags=0; in_text=false
- circled:D (pages/control/11a77cb4-80a7-488f-9287-52cfad7bf106.png): captured_work=yes; leak_flags=0; in_text=false
- answer_line:C (pages/control/a3d49252-b174-4541-bd71-8bcee90d78ec.png): captured_work=NO; leak_flags=0; in_text=false
- answer_key:C (pages/control/29a01303-7854-4e98-9672-8812e39c4b82.png): answer_key_present=true; captured_work=none; in_text=false
- name (pages/control/ec218044-fa22-45a3-9371-7fce48c108e8.png): pii=true
- handwritten_work (pages/control/669f220b-b06c-45e5-98fd-9500811ffffb.png): captured_work=yes; leak_flags=0; in_text=false
- circled:D (pages/control/b0635d34-6c56-464f-a863-01fad8cfd896.png): captured_work=yes; leak_flags=0; in_text=false
- answer_line (pages/control/205c0b5d-0937-47e4-8044-0df319848075.png): captured_work=NO; leak_flags=0; in_text=false
- answer_key:B (pages/control/bcbb08ae-c989-4b77-b9c6-dbe0b51952ff.png): answer_key_present=true; captured_work=none; in_text=false
- name (pages/control/f9053091-1ecb-458b-a70d-0be4795d9446.png): pii=true
- handwritten_work (pages/control/d14464ef-f42e-4508-a617-4aae262c9ae3.png): captured_work=yes; leak_flags=0; in_text=false
- blank (pages/control/blank.png): abstained=true
- notes (pages/control/notes.png): abstained=true

## Per-subject (clean + degraded)
- ap-calculus-ab: n=16, type 100.0% (16/16), mean stem sim 0.956, topic top-1 75.0% (12/16), top-3 75.0% (12/16)
- ap-calculus-bc: n=16, type 100.0% (16/16), mean stem sim 0.975, topic top-1 50.0% (8/16), top-3 68.8% (11/16)
- ap-chemistry: n=22, type 100.0% (22/22), mean stem sim 0.987, topic top-1 95.5% (21/22), top-3 100.0% (22/22)
- ap-physics-1: n=16, type 100.0% (16/16), mean stem sim 0.984, topic top-1 93.8% (15/16), top-3 93.8% (15/16)
- ap-physics-2: n=16, type 100.0% (16/16), mean stem sim 0.991, topic top-1 75.0% (12/16), top-3 87.5% (14/16)
- ap-physics-c-em: n=16, type 100.0% (16/16), mean stem sim 0.979, topic top-1 93.8% (15/16), top-3 100.0% (16/16)
- ap-physics-c-mechanics: n=16, type 100.0% (16/16), mean stem sim 0.974, topic top-1 100.0% (16/16), top-3 100.0% (16/16)
- ap-precalculus: n=16, type 100.0% (16/16), mean stem sim 0.965, topic top-1 81.3% (13/16), top-3 87.5% (14/16)
- ap-statistics: n=22, type 100.0% (22/22), mean stem sim 0.973, topic top-1 54.5% (12/22), top-3 63.6% (14/22)
- biology: n=22, type 100.0% (22/22), mean stem sim 0.985, topic top-1 86.4% (19/22), top-3 100.0% (22/22)
