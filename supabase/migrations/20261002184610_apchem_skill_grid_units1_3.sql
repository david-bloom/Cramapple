-- Applied to Production (pcntajvbdfqhbeewmdry) 2026-10-02 as version 20261002184610 (APPROVAL-0074) after a rolled-back rehearsal.
-- AP Chemistry skill grid (TASK-0050 Phase A for ap_chemistry): 28 skills in 6 practices and 136 topic x skill cells for Units 1-3 (28 topics). Recorded text below; committed so the migration ledger and the repo agree.
select pg_advisory_xact_lock(hashtext('cramapple-apchem-skill-grid-u13-20261002'));
do $$ begin
  if (select count(*) from app.taxonomy_topics where taxonomy_source_version='cbe3116f-6ef5-410c-b535-e9fb711c4c2c')<>91 then raise exception 'expected 91 Chemistry topics'; end if;
  if exists (select 1 from app.taxonomy_skills where taxonomy_source_version='cbe3116f-6ef5-410c-b535-e9fb711c4c2c') or exists (select 1 from app.taxonomy_cells where taxonomy_source_version='cbe3116f-6ef5-410c-b535-e9fb711c4c2c') then raise exception 'Chemistry grid already present'; end if;
end $$;
insert into app.taxonomy_skills (taxonomy_source_version, skill_code, practice_number, label) values
('cbe3116f-6ef5-410c-b535-e9fb711c4c2c','1.A',1,'Describe the components of and quantitative information from models and representations that illustrate particulate-level properties only.'),
('cbe3116f-6ef5-410c-b535-e9fb711c4c2c','1.B',1,'Describe the components of and quantitative information from models and representations that illustrate both particulate-level and macroscopic-level properties.'),
('cbe3116f-6ef5-410c-b535-e9fb711c4c2c','2.A',2,'Identify a testable scientific question based on an observation, data, or a model.'),
('cbe3116f-6ef5-410c-b535-e9fb711c4c2c','2.B',2,'Formulate a hypothesis or predict the results of an experiment.'),
('cbe3116f-6ef5-410c-b535-e9fb711c4c2c','2.C',2,'Identify experimental procedures that are aligned to a scientific question (which may include a sketch of a lab setup).'),
('cbe3116f-6ef5-410c-b535-e9fb711c4c2c','2.D',2,'Make observations or collect data from representations of laboratory setups or results, while attending to precision where appropriate.'),
('cbe3116f-6ef5-410c-b535-e9fb711c4c2c','2.E',2,'Identify or describe potential sources of experimental error.'),
('cbe3116f-6ef5-410c-b535-e9fb711c4c2c','2.F',2,'Explain how modifications to an experimental procedure will alter results.'),
('cbe3116f-6ef5-410c-b535-e9fb711c4c2c','3.A',3,'Represent chemical phenomena using appropriate graphing techniques, including correct scale and units.'),
('cbe3116f-6ef5-410c-b535-e9fb711c4c2c','3.B',3,'Represent chemical substances or phenomena with appropriate diagrams or models (e.g., electron configuration).'),
('cbe3116f-6ef5-410c-b535-e9fb711c4c2c','3.C',3,'Represent visually the relationship between the structures and interactions across multiple levels or scales (e.g., particulate to macroscopic).'),
('cbe3116f-6ef5-410c-b535-e9fb711c4c2c','4.A',4,'Predict and/or explain chemical properties or phenomena (e.g., of atoms or molecules) using given chemical theories, models, and representations.'),
('cbe3116f-6ef5-410c-b535-e9fb711c4c2c','4.B',4,'Explain whether a model is consistent with chemical theories.'),
('cbe3116f-6ef5-410c-b535-e9fb711c4c2c','4.C',4,'Explain the connection between particulate-level and macroscopic properties of a substance using models and representations.'),
('cbe3116f-6ef5-410c-b535-e9fb711c4c2c','4.D',4,'Explain the degree to which a model or representation describes the connection between particulate-level properties and macroscopic properties.'),
('cbe3116f-6ef5-410c-b535-e9fb711c4c2c','5.A',5,'Identify quantities needed to solve a problem from given information (e.g., text, mathematical expressions, graphs, or tables).'),
('cbe3116f-6ef5-410c-b535-e9fb711c4c2c','5.B',5,'Identify an appropriate theory, definition, or mathematical relationship to solve a problem.'),
('cbe3116f-6ef5-410c-b535-e9fb711c4c2c','5.C',5,'Explain the relationship between variables within an equation when one variable changes.'),
('cbe3116f-6ef5-410c-b535-e9fb711c4c2c','5.D',5,'Identify information presented graphically to solve a problem.'),
('cbe3116f-6ef5-410c-b535-e9fb711c4c2c','5.E',5,'Determine a balanced chemical equation for a given chemical phenomenon.'),
('cbe3116f-6ef5-410c-b535-e9fb711c4c2c','5.F',5,'Calculate, estimate, or predict an unknown quantity from known quantities by selecting and following a logical computational pathway and attending to precision (e.g., performing dimensional analysis and attending to significant figures).'),
('cbe3116f-6ef5-410c-b535-e9fb711c4c2c','6.A',6,'Make a scientific claim.'),
('cbe3116f-6ef5-410c-b535-e9fb711c4c2c','6.B',6,'Support a claim with evidence from experimental data.'),
('cbe3116f-6ef5-410c-b535-e9fb711c4c2c','6.C',6,'Support a claim with evidence from representations or models at the particulate level, such as the structure of atoms and/or molecules.'),
('cbe3116f-6ef5-410c-b535-e9fb711c4c2c','6.D',6,'Provide reasoning to justify a claim using chemical principles or laws, or using mathematical justification.'),
('cbe3116f-6ef5-410c-b535-e9fb711c4c2c','6.E',6,'Provide reasoning to justify a claim using connections between particulate and macroscopic scales or levels.'),
('cbe3116f-6ef5-410c-b535-e9fb711c4c2c','6.F',6,'Explain the connection between experimental results and chemical concepts, processes, or theories.'),
('cbe3116f-6ef5-410c-b535-e9fb711c4c2c','6.G',6,'Explain how potential sources of experimental error may affect the experimental results.');
create temporary table align (topic_code text primary key, practice int) on commit drop;
insert into align values ('1.1',5),('1.2',5),('1.3',2),('1.4',5),('1.5',1),('1.6',4),('1.7',4),('1.8',4),('2.1',6),('2.2',3),('2.3',4),('2.4',4),('2.5',3),('2.6',6),('2.7',6),('3.1',4),('3.2',4),('3.3',3),('3.4',5),('3.5',4),('3.6',6),('3.7',5),('3.8',3),('3.9',2),('3.10',4),('3.11',4),('3.12',5),('3.13',2);
insert into app.taxonomy_cells (taxonomy_source_version, topic_code, skill_code)
select 'cbe3116f-6ef5-410c-b535-e9fb711c4c2c', a.topic_code, s.skill_code from align a join app.taxonomy_skills s on s.taxonomy_source_version='cbe3116f-6ef5-410c-b535-e9fb711c4c2c' and s.practice_number=a.practice;
do $$ declare n int; begin
  select count(*) into n from app.taxonomy_skills where taxonomy_source_version='cbe3116f-6ef5-410c-b535-e9fb711c4c2c'; if n<>28 then raise exception 'skills %',n; end if;
  select count(*) into n from app.taxonomy_cells where taxonomy_source_version='cbe3116f-6ef5-410c-b535-e9fb711c4c2c'; if n<>136 then raise exception 'cells %',n; end if;
end $$;
