-- DECISION-0088. Applied to Production 2026-09-29.
--
-- Verified after applying: 23 skills, 20 assessed, 404 cells across 81 topics,
-- 0 not-assessed codes leaked into cells, mean 4.99 candidates per topic, and
-- app.taxonomy_scope_selftest() unchanged at its 11 pre-existing AP Statistics
-- legacy-label findings -- no new violations introduced.
--
-- Reversible: delete from app.taxonomy_cells / app.taxonomy_skills where
-- taxonomy_source_version = (select taxonomy_source_version from
-- app.taxonomy_source_versions where subject_key='ap_calculus_ab');
--
-- This file previously existed as a STUB named 20260929113000_*.sql that carried
-- only these notes and pointed at "the applied statement in the Supabase
-- migration of the same name". Two problems with that: the stub's timestamp did
-- not match the version Production actually recorded (20260929110501), so the
-- next `supabase db push` would have tried to apply an unrecorded file; and the
-- SQL existed nowhere in the repository, so the schema could not be rebuilt from
-- source. The body below is the exact statement recovered from
-- supabase_migrations.schema_migrations on Production.

-- TASK-0050 Phase A — AP Calculus AB topic x skill grid.
-- David, 2026-09-29: "No change to the definition of mastery now. Just go with option 3."
--
-- Option 3 = the FULL sub-skill grid. Each topic offers every ASSESSED sub-skill of
-- the practice the CED aligns to it. Chosen over a curated narrow grid because
-- storage grain and evaluation grain are separable: fine labels roll up to practice
-- or topic grain with a GROUP BY, whereas coarse labels cannot be split without
-- re-labelling. A curated grid would also be lossy at write time -- the composite FK
-- would reject an item whose true sub-skill was left unregistered, forcing it onto a
-- registered neighbour, which is the failure that put apcalcab-mcq-050 on topic 8.3
-- at 0.35 confidence.
--
-- DECISION-0074 is untouched. Mastery stays 2 MCQ + 1 FRQ per cell. Evaluating it at
-- a coarser roll-up remains available later as a query change, not a re-label.
--
-- Source: AP_CALCULUS_AB_BC_CED_FACT_PACK.md "Practice skills (sub-skills)" and
-- "Topic-to-practice alignment", both transcribed from the CED and verified against
-- app.taxonomy_topics (81 AB / 111 BC).
--
-- Shape: 23 skills registered (the CED's full set, so the registry stays faithful),
-- but cells built ONLY from the 20 assessed ones -- 1.A, 1.B and 3.A are marked
-- "not assessed" by the CED, so no item may carry them and no cell should offer them.
-- Expect 81 topics, 83 topic-practice pairs (2.2 carries practices 1 and 4; 5.12
-- carries 1 and 3), and 404 cells.

begin;

insert into app.taxonomy_skills (taxonomy_source_version, skill_code, practice_number, label)
select tsv.taxonomy_source_version, s.code, s.practice, s.label
from (values
 ('1.A',1,'Identify the question to be answered or problem to be solved (NOT ASSESSED)'),
 ('1.B',1,'Identify key and relevant information to answer a question or solve a problem (NOT ASSESSED)'),
 ('1.C',1,'Identify an appropriate mathematical rule or procedure based on the classification of a given expression'),
 ('1.D',1,'Identify an appropriate mathematical rule or procedure based on the relationship between concepts or processes to solve problems'),
 ('1.E',1,'Apply appropriate mathematical rules or procedures, with and without technology'),
 ('1.F',1,'Explain how an approximated value relates to the actual value'),
 ('2.A',2,'Identify common underlying structures in problems involving different contextual situations'),
 ('2.B',2,'Identify mathematical information from graphical, numerical, analytical, and/or verbal representations'),
 ('2.C',2,'Identify a re-expression of mathematical information presented in a given representation'),
 ('2.D',2,'Identify how mathematical characteristics or properties of functions are related in different representations'),
 ('2.E',2,'Describe the relationships among different representations of functions and their derivatives'),
 ('3.A',3,'Apply technology to develop claims and conjectures (NOT ASSESSED)'),
 ('3.B',3,'Identify an appropriate mathematical definition, theorem, or test to apply'),
 ('3.C',3,'Confirm whether hypotheses or conditions of a selected definition, theorem, or test have been satisfied'),
 ('3.D',3,'Apply an appropriate mathematical definition, theorem, or test'),
 ('3.E',3,'Provide reasons or rationales for solutions and conclusions'),
 ('3.F',3,'Explain the meaning of mathematical solutions in context'),
 ('3.G',3,'Confirm that solutions are accurate and appropriate'),
 ('4.A',4,'Use precise mathematical language'),
 ('4.B',4,'Use appropriate units of measure'),
 ('4.C',4,'Use appropriate mathematical symbols and notation'),
 ('4.D',4,'Use appropriate graphing techniques'),
 ('4.E',4,'Apply appropriate rounding procedures')
) as s(code, practice, label)
cross join app.taxonomy_source_versions tsv
where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

-- Cells: every (topic, assessed sub-skill of that topic's aligned practice).
-- Derived by join rather than enumerated, so the 404 rows cannot drift from the
-- 83 alignment pairs they come from.
insert into app.taxonomy_cells (taxonomy_source_version, topic_code, skill_code)
select tsv.taxonomy_source_version, a.topic, sk.skill_code
from (values
 ('1.1',2),('1.2',2),('1.3',2),('1.4',2),('1.5',1),('1.6',1),('1.7',1),('1.8',3),
 ('1.9',2),('1.10',3),('1.11',3),('1.12',1),('1.13',1),('1.14',3),('1.15',2),('1.16',3),
 ('2.1',2),('2.2',1),('2.2',4),('2.3',1),('2.4',3),('2.5',1),('2.6',1),('2.7',1),('2.8',1),('2.9',1),('2.10',1),
 ('3.1',1),('3.2',1),('3.3',3),('3.4',1),('3.5',1),('3.6',1),
 ('4.1',1),('4.2',1),('4.3',2),('4.4',1),('4.5',3),('4.6',1),('4.7',3),
 ('5.1',3),('5.2',3),('5.3',2),('5.4',3),('5.5',1),('5.6',2),('5.7',3),('5.8',2),
 ('5.9',2),('5.10',2),('5.11',3),('5.12',1),('5.12',3),
 ('6.1',4),('6.2',1),('6.3',2),('6.4',1),('6.5',2),('6.6',3),('6.7',3),('6.8',4),('6.9',1),('6.10',1),('6.14',1),
 ('7.1',2),('7.2',3),('7.3',2),('7.4',4),('7.6',1),('7.7',1),('7.8',3),
 ('8.1',1),('8.2',1),('8.3',3),('8.4',4),('8.5',1),('8.6',2),('8.7',3),('8.8',3),
 ('8.9',3),('8.10',2),('8.11',4),('8.12',2)
) as a(topic, practice)
cross join app.taxonomy_source_versions tsv
join app.taxonomy_skills sk
  on sk.taxonomy_source_version = tsv.taxonomy_source_version
 and sk.practice_number = a.practice
 and sk.label not like '%(NOT ASSESSED)%'
where tsv.subject_key = 'ap_calculus_ab'
on conflict do nothing;

commit;
