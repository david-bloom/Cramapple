begin;
select pg_advisory_xact_lock(hashtext('cramapple-apcalcab-unit1-labels-20260930'));
create temporary table lab (content_key text primary key, units int, topic text, skill text, difficulty text, origin text, units_source text, topic_source text, diff_source text) on commit drop;
insert into lab values
('apcalcab-frq-u1n-001',1,'1.13','1.E','Medium','pipeline','serving pipeline: provisional_model','3-model unanimous','3-model unanimous'),
('apcalcab-frq-u1n-002',1,'1.14','3.E','Medium','pipeline','serving pipeline: provisional_model','3-model unanimous','3-model unanimous'),
('apcalcab-frq-u1n-003',1,'1.15','1.E','Hard','pipeline','serving pipeline: provisional_model','3-model unanimous','3-model unanimous'),
('apcalcab-frq-u1n-004',1,'1.11','3.D','Medium','pipeline','serving pipeline: provisional_model','3-model unanimous','3-model unanimous'),
('apcalcab-frq-u1n-005',1,'1.13','1.E','Medium','pipeline','serving pipeline: provisional_model','3-model majority','3-model unanimous'),
('apcalcab-mcq-u1n-001',2,'2.1','1.E','Easy','po_decision','Product Owner decision 2026-09-30: Unit 2 (models split [2] vs [1,2]; serving pipeline: 001 held, 002 Unit 2)','Product Owner decision 2026-09-30: relabel as topic 2.1 (all 3 models unanimous on 2.1)','3-model majority'),
('apcalcab-mcq-u1n-002',2,'2.1','2.B','Easy','po_decision','Product Owner decision 2026-09-30: Unit 2 (models split [2] vs [1,2]; serving pipeline: 001 held, 002 Unit 2)','Product Owner decision 2026-09-30: relabel as topic 2.1 (all 3 models unanimous on 2.1)','3-model unanimous'),
('apcalcab-mcq-u1n-003',1,'1.2','','Easy','pipeline','serving pipeline: provisional_model','3-model unanimous','3-model unanimous'),
('apcalcab-mcq-u1n-004',1,'1.2','1.E','Medium','pipeline','serving pipeline: provisional_model','3-model majority','3-model majority'),
('apcalcab-mcq-u1n-005',1,'1.4','2.B','Easy','pipeline','serving pipeline: provisional_model','3-model unanimous','3-model unanimous'),
('apcalcab-mcq-u1n-006',1,'1.5','1.E','Medium','pipeline','serving pipeline: provisional_model','3-model unanimous','3-model majority'),
('apcalcab-mcq-u1n-007',1,'1.5','','Easy','pipeline','serving pipeline: provisional_model','3-model majority','3-model majority'),
('apcalcab-mcq-u1n-008',1,'1.5','1.C','Easy','pipeline','serving pipeline: provisional_model','3-model majority','3-model unanimous'),
('apcalcab-mcq-u1n-009',1,'1.6','1.E','Medium','pipeline','serving pipeline: provisional_model','3-model majority','3-model majority'),
('apcalcab-mcq-u1n-010',1,'1.8','3.D','Easy','pipeline','serving pipeline: provisional_model','3-model unanimous','3-model majority'),
('apcalcab-mcq-u1n-011',1,'1.10','3.D','Easy','pipeline','serving pipeline: provisional_model','3-model majority','3-model majority'),
('apcalcab-mcq-u1n-012',1,'1.7','1.E','Medium','pipeline','serving pipeline: provisional_model','3-model majority','3-model unanimous'),
('apcalcab-mcq-u1n-013',1,'1.10','3.D','Medium','pipeline','serving pipeline: provisional_model','3-model unanimous','3-model majority'),
('apcalcab-mcq-u1n-014',1,'1.10','1.E','Medium','pipeline','serving pipeline: provisional_model','3-model majority','3-model unanimous'),
('apcalcab-mcq-u1n-015',1,'1.11','3.D','Medium','pipeline','serving pipeline: provisional_model','3-model unanimous','3-model unanimous'),
('apcalcab-mcq-u1n-016',1,'1.12','1.E','Medium','pipeline','serving pipeline: provisional_model','3-model unanimous','3-model majority'),
('apcalcab-mcq-u1n-017',1,'1.12','','Medium','pipeline','serving pipeline: provisional_model','3-model unanimous','3-model unanimous'),
('apcalcab-mcq-u1n-018',1,'1.13','1.E','Medium','pipeline','serving pipeline: provisional_model','3-model unanimous','3-model unanimous'),
('apcalcab-mcq-u1n-019',1,'1.13','1.E','Medium','pipeline','serving pipeline: provisional_model','3-model unanimous','3-model unanimous'),
('apcalcab-mcq-u1n-020',1,'1.13','1.E','Medium','pipeline','serving pipeline: provisional_model','3-model majority','3-model unanimous'),
('apcalcab-mcq-u1n-021',1,'1.10','1.E','Medium','pipeline','serving pipeline: provisional_model','3-model unanimous','3-model unanimous'),
('apcalcab-mcq-u1n-022',1,'1.14','1.E','Medium','pipeline','serving pipeline: provisional_model','3-model unanimous','3-model unanimous'),
('apcalcab-mcq-u1n-023',1,'1.14','1.E','Medium','pipeline','serving pipeline: provisional_model','3-model unanimous','3-model unanimous'),
('apcalcab-mcq-u1n-024',1,'1.14','1.E','Easy','pipeline','serving pipeline: provisional_model','3-model unanimous','3-model majority'),
('apcalcab-mcq-u1n-025',1,'1.14','1.E','Medium','pipeline','serving pipeline: provisional_model','3-model unanimous','3-model majority'),
('apcalcab-mcq-u1n-026',1,'1.15','1.E','Easy','pipeline','serving pipeline: provisional_model','3-model unanimous','3-model unanimous'),
('apcalcab-mcq-u1n-027',1,'1.15','1.E','Medium','pipeline','serving pipeline: provisional_model','3-model unanimous','3-model majority'),
('apcalcab-mcq-u1n-028',1,'1.15','3.F','Easy','pipeline','serving pipeline: provisional_model','3-model unanimous','3-model majority'),
('apcalcab-mcq-u1n-029',1,'1.15','1.E','Medium','pipeline','serving pipeline: provisional_model','3-model unanimous','3-model unanimous'),
('apcalcab-frq-u1v-001-v1',1,'1.13','1.E','Medium','inherited','inherited (3/3 variant labels agree)','inherited (3/3 variant labels agree)','inherited (3/3 variant labels agree)'),
('apcalcab-frq-u1v-001-v2',1,'1.13','1.E','','inherited','inherited (3/3 variant labels agree)','inherited (2/3 variant labels agree)','held: only 1/3 variant labels match the original'),
('apcalcab-frq-u1v-001-v3',1,'1.13','1.E','Medium','inherited','inherited (3/3 variant labels agree)','inherited (3/3 variant labels agree)','inherited (3/3 variant labels agree)'),
('apcalcab-frq-u1v-002-v1',1,'1.14','3.E','Medium','inherited','inherited (3/3 variant labels agree)','inherited (3/3 variant labels agree)','inherited (3/3 variant labels agree)'),
('apcalcab-frq-u1v-002-v2',1,'1.14','','Medium','inherited','inherited (3/3 variant labels agree)','inherited (3/3 variant labels agree)','inherited (3/3 variant labels agree)'),
('apcalcab-frq-u1v-002-v3',1,'1.14','3.E','Medium','inherited','inherited (3/3 variant labels agree)','inherited (3/3 variant labels agree)','inherited (3/3 variant labels agree)'),
('apcalcab-frq-u1v-003-v1',1,'1.15','1.E','Hard','inherited','inherited (3/3 variant labels agree)','inherited (3/3 variant labels agree)','inherited (3/3 variant labels agree)'),
('apcalcab-frq-u1v-003-v2',1,'1.15','1.E','Hard','inherited','inherited (3/3 variant labels agree)','inherited (3/3 variant labels agree)','inherited (3/3 variant labels agree)'),
('apcalcab-frq-u1v-003-v3',1,'1.15','1.E','Hard','inherited','inherited (2/3 variant labels agree)','inherited (3/3 variant labels agree)','inherited (3/3 variant labels agree)'),
('apcalcab-frq-u1v-004-v1',1,'1.11','3.D','Medium','inherited','inherited (3/3 variant labels agree)','inherited (2/3 variant labels agree)','inherited (3/3 variant labels agree)'),
('apcalcab-frq-u1v-004-v2',1,'1.11','3.D','Medium','inherited','inherited (3/3 variant labels agree)','inherited (2/3 variant labels agree)','inherited (3/3 variant labels agree)'),
('apcalcab-frq-u1v-004-v3',1,'1.11','3.D','Medium','inherited','inherited (3/3 variant labels agree)','inherited (3/3 variant labels agree)','inherited (3/3 variant labels agree)'),
('apcalcab-frq-u1v-005-v1',1,'1.13','','Medium','inherited','inherited (3/3 variant labels agree)','inherited (2/3 variant labels agree)','inherited (3/3 variant labels agree)'),
('apcalcab-frq-u1v-005-v2',1,'1.13','1.E','Medium','inherited','inherited (3/3 variant labels agree)','inherited (2/3 variant labels agree)','inherited (3/3 variant labels agree)'),
('apcalcab-frq-u1v-005-v3',1,'1.13','1.E','Medium','inherited','inherited (3/3 variant labels agree)','inherited (2/3 variant labels agree)','inherited (3/3 variant labels agree)'),
('apcalcab-mcq-u1v-001-v1',2,'2.1','1.E','Easy','po_decision','Product Owner decision 2026-09-30: Unit 2 (models split [2] vs [1,2]; serving pipeline: 001 held, 002 Unit 2)','Product Owner decision 2026-09-30: relabel as topic 2.1 (all 3 models unanimous on 2.1)','inherited (2/3 variant labels agree)'),
('apcalcab-mcq-u1v-001-v2',2,'2.1','1.E','','po_decision','Product Owner decision 2026-09-30: Unit 2 (models split [2] vs [1,2]; serving pipeline: 001 held, 002 Unit 2)','Product Owner decision 2026-09-30: relabel as topic 2.1 (all 3 models unanimous on 2.1)','held: only 0/3 variant labels match the original'),
('apcalcab-mcq-u1v-001-v3',2,'2.1','1.E','Easy','po_decision','Product Owner decision 2026-09-30: Unit 2 (models split [2] vs [1,2]; serving pipeline: 001 held, 002 Unit 2)','Product Owner decision 2026-09-30: relabel as topic 2.1 (all 3 models unanimous on 2.1)','inherited (3/3 variant labels agree)'),
('apcalcab-mcq-u1v-002-v1',2,'2.1','2.B','Easy','po_decision','Product Owner decision 2026-09-30: Unit 2 (models split [2] vs [1,2]; serving pipeline: 001 held, 002 Unit 2)','Product Owner decision 2026-09-30: relabel as topic 2.1 (all 3 models unanimous on 2.1)','inherited (3/3 variant labels agree)'),
('apcalcab-mcq-u1v-002-v2',2,'2.1','2.B','Easy','po_decision','Product Owner decision 2026-09-30: Unit 2 (models split [2] vs [1,2]; serving pipeline: 001 held, 002 Unit 2)','Product Owner decision 2026-09-30: relabel as topic 2.1 (all 3 models unanimous on 2.1)','inherited (3/3 variant labels agree)'),
('apcalcab-mcq-u1v-002-v3',2,'2.1','2.B','Easy','po_decision','Product Owner decision 2026-09-30: Unit 2 (models split [2] vs [1,2]; serving pipeline: 001 held, 002 Unit 2)','Product Owner decision 2026-09-30: relabel as topic 2.1 (all 3 models unanimous on 2.1)','inherited (3/3 variant labels agree)'),
('apcalcab-mcq-u1v-003-v1',1,'1.2','','Easy','inherited','inherited (3/3 variant labels agree)','inherited (3/3 variant labels agree)','inherited (3/3 variant labels agree)'),
('apcalcab-mcq-u1v-003-v2',1,'1.2','','Easy','inherited','inherited (3/3 variant labels agree)','inherited (3/3 variant labels agree)','inherited (3/3 variant labels agree)'),
('apcalcab-mcq-u1v-003-v3',1,'1.2','','Easy','inherited','inherited (3/3 variant labels agree)','inherited (3/3 variant labels agree)','inherited (3/3 variant labels agree)'),
('apcalcab-mcq-u1v-004-v1',1,'1.2','1.E','Medium','inherited','inherited (3/3 variant labels agree)','inherited (2/3 variant labels agree)','inherited (3/3 variant labels agree)'),
('apcalcab-mcq-u1v-004-v2',1,'','1.E','Medium','inherited','inherited (3/3 variant labels agree)','held: only 1/3 variant labels match the original','inherited (2/3 variant labels agree)'),
('apcalcab-mcq-u1v-004-v3',1,'','1.E','Medium','inherited','inherited (3/3 variant labels agree)','held: only 0/3 variant labels match the original','inherited (2/3 variant labels agree)'),
('apcalcab-mcq-u1v-005-v1',1,'1.4','2.B','Easy','inherited','inherited (3/3 variant labels agree)','inherited (3/3 variant labels agree)','inherited (3/3 variant labels agree)'),
('apcalcab-mcq-u1v-005-v2',1,'1.4','2.B','Easy','inherited','inherited (3/3 variant labels agree)','inherited (3/3 variant labels agree)','inherited (3/3 variant labels agree)'),
('apcalcab-mcq-u1v-005-v3',1,'1.4','2.B','Easy','inherited','inherited (3/3 variant labels agree)','inherited (3/3 variant labels agree)','inherited (3/3 variant labels agree)'),
('apcalcab-mcq-u1v-006-v1',1,'1.5','1.E','Medium','inherited','inherited (3/3 variant labels agree)','inherited (3/3 variant labels agree)','inherited (2/3 variant labels agree)'),
('apcalcab-mcq-u1v-006-v2',1,'1.5','1.E','Medium','inherited','inherited (3/3 variant labels agree)','inherited (3/3 variant labels agree)','inherited (2/3 variant labels agree)'),
('apcalcab-mcq-u1v-006-v3',1,'1.5','1.E','Medium','inherited','inherited (3/3 variant labels agree)','inherited (3/3 variant labels agree)','inherited (2/3 variant labels agree)'),
('apcalcab-mcq-u1v-007-v1',1,'','','Easy','inherited','inherited (3/3 variant labels agree)','held: only 1/3 variant labels match the original','inherited (3/3 variant labels agree)'),
('apcalcab-mcq-u1v-007-v2',1,'1.5','','','inherited','inherited (3/3 variant labels agree)','inherited (2/3 variant labels agree)','held: only 1/3 variant labels match the original'),
('apcalcab-mcq-u1v-007-v3',1,'','','','inherited','inherited (3/3 variant labels agree)','held: only 0/3 variant labels match the original','held: only 0/3 variant labels match the original'),
('apcalcab-mcq-u1v-008-v1',1,'1.5','1.C','Easy','inherited','inherited (3/3 variant labels agree)','inherited (3/3 variant labels agree)','inherited (3/3 variant labels agree)'),
('apcalcab-mcq-u1v-008-v2',1,'1.5','1.C','Easy','inherited','inherited (3/3 variant labels agree)','inherited (3/3 variant labels agree)','inherited (3/3 variant labels agree)'),
('apcalcab-mcq-u1v-008-v3',1,'1.5','1.C','Easy','inherited','inherited (3/3 variant labels agree)','inherited (3/3 variant labels agree)','inherited (2/3 variant labels agree)'),
('apcalcab-mcq-u1v-009-v1',1,'1.6','1.E','Medium','inherited','inherited (3/3 variant labels agree)','inherited (2/3 variant labels agree)','inherited (3/3 variant labels agree)'),
('apcalcab-mcq-u1v-009-v2',1,'1.6','1.E','Medium','inherited','inherited (3/3 variant labels agree)','inherited (2/3 variant labels agree)','inherited (3/3 variant labels agree)'),
('apcalcab-mcq-u1v-009-v3',1,'1.6','1.E','Medium','inherited','inherited (3/3 variant labels agree)','inherited (2/3 variant labels agree)','inherited (3/3 variant labels agree)'),
('apcalcab-mcq-u1v-010-v1',1,'1.8','3.D','Easy','inherited','inherited (3/3 variant labels agree)','inherited (3/3 variant labels agree)','inherited (2/3 variant labels agree)'),
('apcalcab-mcq-u1v-010-v2',1,'1.8','3.D','','inherited','inherited (3/3 variant labels agree)','inherited (3/3 variant labels agree)','held: only 1/3 variant labels match the original'),
('apcalcab-mcq-u1v-010-v3',1,'1.8','3.D','','inherited','inherited (3/3 variant labels agree)','inherited (3/3 variant labels agree)','held: only 1/3 variant labels match the original'),
('apcalcab-mcq-u1v-011-v1',1,'','3.D','','inherited','inherited (3/3 variant labels agree)','held: only 0/3 variant labels match the original','held: only 0/3 variant labels match the original'),
('apcalcab-mcq-u1v-011-v2',1,'1.10','3.D','','inherited','inherited (3/3 variant labels agree)','inherited (3/3 variant labels agree)','held: only 0/3 variant labels match the original'),
('apcalcab-mcq-u1v-011-v3',1,'','3.D','','inherited','inherited (3/3 variant labels agree)','held: only 0/3 variant labels match the original','held: only 0/3 variant labels match the original'),
('apcalcab-mcq-u1v-012-v1',1,'','1.E','Medium','inherited','inherited (3/3 variant labels agree)','held: only 0/3 variant labels match the original','inherited (3/3 variant labels agree)'),
('apcalcab-mcq-u1v-012-v2',1,'','1.E','Medium','inherited','inherited (3/3 variant labels agree)','held: only 0/3 variant labels match the original','inherited (3/3 variant labels agree)'),
('apcalcab-mcq-u1v-012-v3',1,'','1.E','Medium','inherited','inherited (3/3 variant labels agree)','held: only 1/3 variant labels match the original','inherited (3/3 variant labels agree)'),
('apcalcab-mcq-u1v-013-v1',1,'1.10','3.D','Medium','inherited','inherited (3/3 variant labels agree)','inherited (3/3 variant labels agree)','inherited (2/3 variant labels agree)'),
('apcalcab-mcq-u1v-013-v2',1,'1.10','3.D','Medium','inherited','inherited (3/3 variant labels agree)','inherited (3/3 variant labels agree)','inherited (3/3 variant labels agree)'),
('apcalcab-mcq-u1v-013-v3',1,'1.10','','','inherited','inherited (3/3 variant labels agree)','inherited (3/3 variant labels agree)','held: only 1/3 variant labels match the original'),
('apcalcab-mcq-u1v-014-v1',1,'1.10','','Medium','inherited','inherited (3/3 variant labels agree)','inherited (2/3 variant labels agree)','inherited (3/3 variant labels agree)'),
('apcalcab-mcq-u1v-014-v2',1,'','1.E','Medium','inherited','inherited (3/3 variant labels agree)','held: only 1/3 variant labels match the original','inherited (3/3 variant labels agree)'),
('apcalcab-mcq-u1v-014-v3',1,'1.10','1.E','Medium','inherited','inherited (3/3 variant labels agree)','inherited (2/3 variant labels agree)','inherited (3/3 variant labels agree)'),
('apcalcab-mcq-u1v-015-v1',1,'1.11','','Medium','inherited','inherited (3/3 variant labels agree)','inherited (3/3 variant labels agree)','inherited (3/3 variant labels agree)'),
('apcalcab-mcq-u1v-015-v2',1,'1.11','3.D','Medium','inherited','inherited (3/3 variant labels agree)','inherited (2/3 variant labels agree)','inherited (3/3 variant labels agree)'),
('apcalcab-mcq-u1v-015-v3',1,'1.11','','Medium','inherited','inherited (3/3 variant labels agree)','inherited (3/3 variant labels agree)','inherited (3/3 variant labels agree)'),
('apcalcab-mcq-u1v-016-v1',1,'1.12','1.E','Medium','inherited','inherited (3/3 variant labels agree)','inherited (3/3 variant labels agree)','inherited (3/3 variant labels agree)'),
('apcalcab-mcq-u1v-016-v2',1,'1.12','1.E','Medium','inherited','inherited (3/3 variant labels agree)','inherited (2/3 variant labels agree)','inherited (3/3 variant labels agree)'),
('apcalcab-mcq-u1v-016-v3',1,'1.12','1.E','Medium','inherited','inherited (3/3 variant labels agree)','inherited (2/3 variant labels agree)','inherited (3/3 variant labels agree)'),
('apcalcab-mcq-u1v-017-v1',1,'1.12','','Medium','inherited','inherited (3/3 variant labels agree)','inherited (3/3 variant labels agree)','inherited (3/3 variant labels agree)'),
('apcalcab-mcq-u1v-017-v2',1,'1.12','','Medium','inherited','inherited (3/3 variant labels agree)','inherited (3/3 variant labels agree)','inherited (3/3 variant labels agree)'),
('apcalcab-mcq-u1v-017-v3',1,'1.12','','Medium','inherited','inherited (3/3 variant labels agree)','inherited (3/3 variant labels agree)','inherited (3/3 variant labels agree)'),
('apcalcab-mcq-u1v-018-v1',1,'1.13','1.E','Medium','inherited','inherited (3/3 variant labels agree)','inherited (3/3 variant labels agree)','inherited (3/3 variant labels agree)'),
('apcalcab-mcq-u1v-018-v2',1,'1.13','1.E','Medium','inherited','inherited (3/3 variant labels agree)','inherited (3/3 variant labels agree)','inherited (3/3 variant labels agree)'),
('apcalcab-mcq-u1v-018-v3',1,'1.13','1.E','Medium','inherited','inherited (3/3 variant labels agree)','inherited (3/3 variant labels agree)','inherited (3/3 variant labels agree)'),
('apcalcab-mcq-u1v-019-v1',1,'1.13','1.E','Medium','inherited','inherited (3/3 variant labels agree)','inherited (3/3 variant labels agree)','inherited (3/3 variant labels agree)'),
('apcalcab-mcq-u1v-019-v2',1,'1.13','1.E','Medium','inherited','inherited (3/3 variant labels agree)','inherited (3/3 variant labels agree)','inherited (3/3 variant labels agree)'),
('apcalcab-mcq-u1v-019-v3',1,'1.13','1.E','Medium','inherited','inherited (3/3 variant labels agree)','inherited (3/3 variant labels agree)','inherited (3/3 variant labels agree)'),
('apcalcab-mcq-u1v-020-v1',1,'1.13','1.E','Medium','inherited','inherited (3/3 variant labels agree)','inherited (2/3 variant labels agree)','inherited (3/3 variant labels agree)'),
('apcalcab-mcq-u1v-020-v2',1,'1.13','1.E','Medium','inherited','inherited (3/3 variant labels agree)','inherited (2/3 variant labels agree)','inherited (3/3 variant labels agree)'),
('apcalcab-mcq-u1v-020-v3',1,'1.13','1.E','Medium','inherited','inherited (3/3 variant labels agree)','inherited (2/3 variant labels agree)','inherited (3/3 variant labels agree)'),
('apcalcab-mcq-u1v-021-v1',1,'1.10','1.E','Medium','inherited','inherited (3/3 variant labels agree)','inherited (3/3 variant labels agree)','inherited (3/3 variant labels agree)'),
('apcalcab-mcq-u1v-021-v2',1,'1.10','1.E','Medium','inherited','inherited (3/3 variant labels agree)','inherited (3/3 variant labels agree)','inherited (3/3 variant labels agree)'),
('apcalcab-mcq-u1v-021-v3',1,'1.10','1.E','Medium','inherited','inherited (3/3 variant labels agree)','inherited (3/3 variant labels agree)','inherited (3/3 variant labels agree)'),
('apcalcab-mcq-u1v-022-v1',1,'1.14','1.E','Medium','inherited','inherited (3/3 variant labels agree)','inherited (3/3 variant labels agree)','inherited (3/3 variant labels agree)'),
('apcalcab-mcq-u1v-022-v2',1,'1.14','1.E','Medium','inherited','inherited (3/3 variant labels agree)','inherited (3/3 variant labels agree)','inherited (3/3 variant labels agree)'),
('apcalcab-mcq-u1v-022-v3',1,'1.14','1.E','Medium','inherited','inherited (3/3 variant labels agree)','inherited (3/3 variant labels agree)','inherited (2/3 variant labels agree)'),
('apcalcab-mcq-u1v-023-v1',1,'1.14','1.E','Medium','inherited','inherited (3/3 variant labels agree)','inherited (3/3 variant labels agree)','inherited (3/3 variant labels agree)'),
('apcalcab-mcq-u1v-023-v2',1,'1.14','1.E','Medium','inherited','inherited (3/3 variant labels agree)','inherited (3/3 variant labels agree)','inherited (3/3 variant labels agree)'),
('apcalcab-mcq-u1v-023-v3',1,'1.14','1.E','Medium','inherited','inherited (3/3 variant labels agree)','inherited (3/3 variant labels agree)','inherited (3/3 variant labels agree)'),
('apcalcab-mcq-u1v-024-v1',1,'1.14','1.E','','inherited','inherited (3/3 variant labels agree)','inherited (3/3 variant labels agree)','held: only 1/3 variant labels match the original'),
('apcalcab-mcq-u1v-024-v2',1,'1.14','1.E','Easy','inherited','inherited (3/3 variant labels agree)','inherited (3/3 variant labels agree)','inherited (2/3 variant labels agree)'),
('apcalcab-mcq-u1v-024-v3',1,'1.14','1.E','','inherited','inherited (3/3 variant labels agree)','inherited (3/3 variant labels agree)','held: only 0/3 variant labels match the original'),
('apcalcab-mcq-u1v-025-v1',1,'1.14','1.E','Medium','inherited','inherited (3/3 variant labels agree)','inherited (3/3 variant labels agree)','inherited (3/3 variant labels agree)'),
('apcalcab-mcq-u1v-025-v2',1,'1.14','1.E','Medium','inherited','inherited (3/3 variant labels agree)','inherited (3/3 variant labels agree)','inherited (2/3 variant labels agree)'),
('apcalcab-mcq-u1v-025-v3',1,'1.14','1.E','','inherited','inherited (3/3 variant labels agree)','inherited (3/3 variant labels agree)','held: only 1/3 variant labels match the original'),
('apcalcab-mcq-u1v-026-v1',1,'1.15','1.E','','inherited','inherited (3/3 variant labels agree)','inherited (3/3 variant labels agree)','held: only 0/3 variant labels match the original'),
('apcalcab-mcq-u1v-026-v2',1,'1.15','1.E','','inherited','inherited (3/3 variant labels agree)','inherited (3/3 variant labels agree)','held: only 0/3 variant labels match the original'),
('apcalcab-mcq-u1v-026-v3',1,'1.15','1.E','Easy','inherited','inherited (3/3 variant labels agree)','inherited (3/3 variant labels agree)','inherited (2/3 variant labels agree)'),
('apcalcab-mcq-u1v-027-v1',1,'1.15','1.E','Medium','inherited','inherited (3/3 variant labels agree)','inherited (3/3 variant labels agree)','inherited (2/3 variant labels agree)'),
('apcalcab-mcq-u1v-027-v2',1,'1.15','1.E','Medium','inherited','inherited (3/3 variant labels agree)','inherited (3/3 variant labels agree)','inherited (3/3 variant labels agree)'),
('apcalcab-mcq-u1v-027-v3',1,'1.15','1.E','','inherited','inherited (3/3 variant labels agree)','inherited (3/3 variant labels agree)','held: only 1/3 variant labels match the original'),
('apcalcab-mcq-u1v-028-v1',1,'1.15','3.F','Easy','inherited','inherited (3/3 variant labels agree)','inherited (3/3 variant labels agree)','inherited (2/3 variant labels agree)'),
('apcalcab-mcq-u1v-028-v2',1,'1.15','3.F','Easy','inherited','inherited (3/3 variant labels agree)','inherited (3/3 variant labels agree)','inherited (2/3 variant labels agree)'),
('apcalcab-mcq-u1v-028-v3',1,'1.15','3.F','','inherited','inherited (3/3 variant labels agree)','inherited (3/3 variant labels agree)','held: only 0/3 variant labels match the original'),
('apcalcab-mcq-u1v-029-v1',1,'1.15','1.E','Medium','inherited','inherited (3/3 variant labels agree)','inherited (3/3 variant labels agree)','inherited (3/3 variant labels agree)'),
('apcalcab-mcq-u1v-029-v2',1,'1.15','1.E','Medium','inherited','inherited (3/3 variant labels agree)','inherited (3/3 variant labels agree)','inherited (3/3 variant labels agree)'),
('apcalcab-mcq-u1v-029-v3',1,'1.15','1.E','Medium','inherited','inherited (3/3 variant labels agree)','inherited (3/3 variant labels agree)','inherited (3/3 variant labels agree)');
create temporary table tgt on commit drop as
select l.*, ci.id item_id, civ.id version_id, gen_random_uuid() label_id, gen_random_uuid() vd_id
from lab l join app.content_items ci on ci.content_key=l.content_key and ci.exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d'
join app.content_item_versions civ on civ.content_item_id=ci.id and civ.version_num=1
where ci.status='reviewed_approved' and civ.status='reviewed_approved'
  and not exists (select 1 from app.content_taxonomy_labels x where x.content_item_id=ci.id);
do $$ begin if (select count(*) from tgt)<>136 then raise exception 'expected 136 targets, got %', (select count(*) from tgt); end if; end $$;
insert into app.content_taxonomy_labels (content_taxonomy_label_id, content_item_id, label_version, label_scope, required_units, max_required_unit, primary_unit, assessed_topics, taxonomy_source_version, taxonomy_confidence, label_status, source, source_payload, model_run_id, created_by)
select label_id, item_id, 1, 'serving', array[units], units, units, array[]::text[], '33b4408b-0ecc-4c7a-b0b1-612db81164a1'::uuid, 'provisional', 'provisional_model',
  'apcalcab_unit1_batch_2026_09_30',
  jsonb_build_object('origin', origin, 'units_source', units_source, 'topic_source', topic_source, 'topic', nullif(topic,''), 'skill', nullif(skill,''), 'batch','apcalcab-unit1-original-2026-09-29','report','scripts/content-seed/calc-ab-unit1-original-2026-09-29/LABELING_REPORT.md'),
  'apcalcab-unit1-labeling-2026-09-30', 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
from tgt;
insert into app.content_taxonomy_validation_decisions (validation_decision_id, content_taxonomy_label_id, decided_by, decision, decision_source, reviewed_primary_unit, reviewed_required_units, notes)
select vd_id, label_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'confirmed',
  case when origin='po_decision' then 'chat_review' else 'automated_spot_check' end, units, array[units],
  case origin
    when 'po_decision' then 'Product Owner decision 2026-09-30 (chat): promote AP Calc AB Unit 1 batch; the 8 items in the MCQ 001/002 family are relabelled Unit 2 / topic 2.1. Models split [2] vs [1,2] on the originals; all three models unanimous on topic 2.1.'
    when 'inherited' then 'Product Owner decision 2026-09-30 (chat): promote to validated with human review waived. Variant inherits its original''s unit only after a per-variant 3-model agreement check (see LABEL_INHERITANCE_SPOT_CHECK.md, LABELING_REPORT.md).'
    else 'Product Owner decision 2026-09-30 (chat): promote to validated with human review waived. Original labelled through the serving-label pipeline with three models agreeing on unit.' end
from tgt;
update app.content_taxonomy_labels l set label_status='validated', validated_by='f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, validated_at=now(), validation_decision_id=t.vd_id, validated_against_version_id=t.version_id, validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id)
from tgt t where l.content_taxonomy_label_id=t.label_id;
insert into app.content_item_difficulty (content_item_version_id, difficulty, basis, rationale, confidence, proposal_run, created_by)
select version_id, difficulty, 'calibrated_judgement',
  'Three-model blind difficulty rubric (Easy/Medium/Hard); '||diff_source||'. AP Calc AB Unit 1 batch 2026-09-29.',
  case when diff_source like '%unanimous%' or diff_source like 'inherited (3/3%' then 'high' else 'medium' end,
  'apcalcab-unit1-2026-09-30', 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
from tgt where nullif(difficulty,'') is not null;
insert into app.content_item_cells (content_item_version_id, content_item_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select version_id, item_id, '33b4408b-0ecc-4c7a-b0b1-612db81164a1'::uuid, topic, null, true, 'provisional_model', 'apcalcab_unit1_topic_2026_09_30', 'apcalcab-unit1-labeling-2026-09-30:'||topic_source
from tgt where nullif(topic,'') is not null;
insert into app.content_item_cells (content_item_version_id, content_item_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select t.version_id, t.item_id, '33b4408b-0ecc-4c7a-b0b1-612db81164a1'::uuid, t.topic, t.skill, false, 'provisional_model', 'apcalcab_unit1_skill_2026_09_30', 'apcalcab-unit1-labeling-2026-09-30'
from tgt t
where nullif(t.topic,'') is not null and nullif(t.skill,'') is not null
  and exists (select 1 from app.taxonomy_cells c where c.taxonomy_source_version='33b4408b-0ecc-4c7a-b0b1-612db81164a1' and c.topic_code=t.topic and c.skill_code=t.skill);
select (select count(*) from app.content_taxonomy_labels where source='apcalcab_unit1_batch_2026_09_30' and label_status='validated') validated_labels,
 (select count(*) from app.content_item_difficulty where proposal_run='apcalcab-unit1-2026-09-30') difficulty_rows,
 (select count(*) from app.content_item_cells where source='apcalcab_unit1_topic_2026_09_30') topic_cells,
 (select count(*) from app.content_item_cells where source='apcalcab_unit1_skill_2026_09_30') skill_cells,
 (select count(*) from tgt where nullif(topic,'') is not null and nullif(skill,'') is not null) skills_wanted;
commit;