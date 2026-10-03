-- Applied to Production (pcntajvbdfqhbeewmdry) 2026-10-02 as version 20261002170626 (APPROVAL-0073) after a rolled-back rehearsal; also widens taxonomy_skills.practice_number to 1..12 (David: "widen that check").
-- AP Biology skill grid (TASK-0050 Phase A for ap_biology), 2026-10-02. DECISION-0088 grain: full sub-skill grid.
-- Source: AP Biology CED, Effective Fall 2025 (V.1), pp. 12-13 (the six practices and 22 skills) and p. 30 (Unit at a Glance): "The suggested skills for each topic
-- show possible ways to link the content ... Progress Checks are based on this pairing. However, AP Exam questions can pair the content with any of the skills."
-- Because the CED itself says any topic can pair with any skill, the grid is the full cross-product of the 60 registered topics x 22 skills = 1320 cells. The CED's 60 suggested pairs
-- (ced_topic_suggested_skill.json, parsed from the unit-at-a-glance tables and checked consistent across both places they appear) are a subset. The cells table has no 'suggested' flag.
-- Scope: taxonomy_source_version c676d1fc-3b58-4896-89e3-852d9bd1f81b (the subject's existing verified version; 60 topics, 0 skills, 0 cells before). Reference data only; no item rows are touched.
select pg_advisory_xact_lock(hashtext('cramapple-apbio-skill-grid-20261002'));
do $$ begin
  if (select count(*) from app.taxonomy_topics where taxonomy_source_version='c676d1fc-3b58-4896-89e3-852d9bd1f81b')<>60 then raise exception 'expected 60 Biology topics'; end if;
  if exists (select 1 from app.taxonomy_skills where taxonomy_source_version='c676d1fc-3b58-4896-89e3-852d9bd1f81b') or exists (select 1 from app.taxonomy_cells where taxonomy_source_version='c676d1fc-3b58-4896-89e3-852d9bd1f81b') then raise exception 'Biology grid already present'; end if;
end $$;
-- Widen the practice_number bound (David, 2026-10-02: "widen that check"): it was hard-coded 1..4 (Statistics and Calculus have four practices); AP Biology has six.
alter table app.taxonomy_skills drop constraint taxonomy_skills_practice_number_check;
alter table app.taxonomy_skills add constraint taxonomy_skills_practice_number_check check (practice_number >= 1 and practice_number <= 12);
insert into app.taxonomy_skills (taxonomy_source_version, skill_code, practice_number, label) values
('c676d1fc-3b58-4896-89e3-852d9bd1f81b','1.A',1,'Describe biological concepts and processes.'),
('c676d1fc-3b58-4896-89e3-852d9bd1f81b','1.B',1,'Explain biological concepts and processes.'),
('c676d1fc-3b58-4896-89e3-852d9bd1f81b','1.C',1,'Explain biological concepts and processes in applied contexts.'),
('c676d1fc-3b58-4896-89e3-852d9bd1f81b','2.A',2,'Describe characteristics of visual representations of biological concepts and processes.'),
('c676d1fc-3b58-4896-89e3-852d9bd1f81b','2.B',2,'Explain relationships between characteristics of biological models in both theoretical and applied contexts.'),
('c676d1fc-3b58-4896-89e3-852d9bd1f81b','2.C',2,'Explain how biological models relate to larger principles, concepts, systems, or theories.'),
('c676d1fc-3b58-4896-89e3-852d9bd1f81b','2.D',2,'Represent relationships within biological models, including mathematical models, diagrams, flowcharts, and systems.'),
('c676d1fc-3b58-4896-89e3-852d9bd1f81b','3.A',3,'Identify or pose a testable question based on an observation, data, or a model.'),
('c676d1fc-3b58-4896-89e3-852d9bd1f81b','3.B',3,'State the null hypothesis or predict the results of an experiment.'),
('c676d1fc-3b58-4896-89e3-852d9bd1f81b','3.C',3,'Identify experimental procedures that align with the question, including identifying dependent and independent variables, identifying appropriate controls, and justifying appropriate controls.'),
('c676d1fc-3b58-4896-89e3-852d9bd1f81b','3.D',3,'Propose a new investigation based on an evaluation of the experimental design or evidence.'),
('c676d1fc-3b58-4896-89e3-852d9bd1f81b','4.A',4,'Construct a graph to represent the data (graph type, axis labeling with units and legend, scaling, accurately plotted data, error bars and trend line when appropriate).'),
('c676d1fc-3b58-4896-89e3-852d9bd1f81b','4.B',4,'Describe data from a table or graph, including identifying specific data points, describing trends and patterns, and describing relationships between variables.'),
('c676d1fc-3b58-4896-89e3-852d9bd1f81b','5.A',5,'Perform mathematical calculations (equations in the curriculum, means, rates, ratios, percentages and percent changes).'),
('c676d1fc-3b58-4896-89e3-852d9bd1f81b','5.B',5,'Use confidence intervals and error bars to estimate whether sample means are statistically different.'),
('c676d1fc-3b58-4896-89e3-852d9bd1f81b','5.C',5,'Perform chi-square hypothesis testing.'),
('c676d1fc-3b58-4896-89e3-852d9bd1f81b','5.D',5,'Use data to evaluate a hypothesis or prediction, including rejecting or failing to reject the null hypothesis.'),
('c676d1fc-3b58-4896-89e3-852d9bd1f81b','6.A',6,'Make a scientific claim.'),
('c676d1fc-3b58-4896-89e3-852d9bd1f81b','6.B',6,'Support a claim with evidence from biological principles, concepts, processes, and data.'),
('c676d1fc-3b58-4896-89e3-852d9bd1f81b','6.C',6,'Provide reasoning to justify a claim by connecting evidence to biological concepts, processes, or theories.'),
('c676d1fc-3b58-4896-89e3-852d9bd1f81b','6.D',6,'Explain the relationship between experimental results and larger biological concepts, processes, or theories.'),
('c676d1fc-3b58-4896-89e3-852d9bd1f81b','6.E',6,'Predict the causes or effects of a change in, or disruption to, one or more components in a biological system.');
insert into app.taxonomy_cells (taxonomy_source_version, topic_code, skill_code)
select t.taxonomy_source_version, t.topic_code, s.skill_code from app.taxonomy_topics t join app.taxonomy_skills s on s.taxonomy_source_version=t.taxonomy_source_version where t.taxonomy_source_version='c676d1fc-3b58-4896-89e3-852d9bd1f81b';
do $$ declare n int; begin
  select count(*) into n from app.taxonomy_skills where taxonomy_source_version='c676d1fc-3b58-4896-89e3-852d9bd1f81b'; if n<>22 then raise exception 'skills %',n; end if;
  select count(*) into n from app.taxonomy_cells where taxonomy_source_version='c676d1fc-3b58-4896-89e3-852d9bd1f81b'; if n<>1320 then raise exception 'cells %',n; end if;
  select count(*) into n from app.taxonomy_cells c where c.taxonomy_source_version='c676d1fc-3b58-4896-89e3-852d9bd1f81b' and not exists (select 1 from app.taxonomy_skills s where s.taxonomy_source_version=c.taxonomy_source_version and s.skill_code=c.skill_code); if n<>0 then raise exception 'orphan skill codes %',n; end if;
end $$;
select (select count(*) from app.taxonomy_skills where taxonomy_source_version='c676d1fc-3b58-4896-89e3-852d9bd1f81b') skills, (select count(*) from app.taxonomy_cells where taxonomy_source_version='c676d1fc-3b58-4896-89e3-852d9bd1f81b') cells;
